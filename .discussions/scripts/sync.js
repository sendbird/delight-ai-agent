#!/usr/bin/env node

/**
 * GitHub Discussions Sync Script
 *
 * Syncs local .discussions files to GitHub Discussions using GraphQL API.
 * - Creates new discussions if no discussion_number exists in meta.json
 * - Updates existing discussions if discussion_number exists
 *
 * Usage:
 *   GITHUB_TOKEN=xxx node scripts/sync.js [--dry-run] [category/slug]
 *
 * Examples:
 *   node scripts/sync.js                           # Sync all discussions
 *   node scripts/sync.js --dry-run                 # Preview without making changes
 *   node scripts/sync.js conversation/customize-typing-indicator  # Sync single discussion
 */

const https = require('https');
const fs = require('fs');
const path = require('path');

const {
  DISCUSSIONS_DIR,
  loadConfig,
  buildDiscussionContent
} = require('./utils');

// Configuration
const REPO_OWNER = 'sendbird';
const REPO_NAME = 'delight-ai-agent';

// Parse command line arguments
const args = process.argv.slice(2);
const DRY_RUN = args.includes('--dry-run');
const TARGET_PATH = args.find(arg => !arg.startsWith('--'));

if (!process.env.GITHUB_TOKEN) {
  console.error('Error: GITHUB_TOKEN environment variable is required');
  console.error('Create a token at: https://github.com/settings/tokens');
  console.error('Required scopes: repo, write:discussion');
  process.exit(1);
}

const GITHUB_TOKEN = process.env.GITHUB_TOKEN;

// Delay helper
function delay(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

// GraphQL helper with retry logic
async function graphql(query, variables = {}, retries = 3) {
  const makeRequest = () => new Promise((resolve, reject) => {
    const body = JSON.stringify({ query, variables });

    const options = {
      hostname: 'api.github.com',
      path: '/graphql',
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${GITHUB_TOKEN}`,
        'Content-Type': 'application/json',
        'User-Agent': 'discussion-sync-script',
        'Content-Length': Buffer.byteLength(body)
      }
    };

    const req = https.request(options, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => {
        try {
          const json = JSON.parse(data);
          if (json.errors) {
            console.error('GraphQL errors:', JSON.stringify(json.errors, null, 2));
            reject(new Error(json.errors.map(e => e.message).join(', ')));
          } else if (!json.data) {
            console.error('No data in response. Full response:', JSON.stringify(json, null, 2));
            reject(new Error('No data in response'));
          } else {
            resolve(json.data);
          }
        } catch (e) {
          console.error('Parse error. Raw response:', data);
          reject(e);
        }
      });
    });

    req.on('error', reject);
    req.write(body);
    req.end();
  });

  let lastError;
  for (let attempt = 1; attempt <= retries; attempt++) {
    try {
      const result = await makeRequest();
      // Add delay after successful API call to prevent rate limiting
      await delay(500);
      return result;
    } catch (err) {
      lastError = err;
      if (attempt < retries) {
        const waitTime = attempt * 1000; // 1s, 2s, 3s...
        console.log(`   ⚠️  Attempt ${attempt} failed: ${err.message}. Retrying in ${waitTime}ms...`);
        await delay(waitTime);
      }
    }
  }
  throw lastError;
}

// Get repository and category IDs
async function getRepoInfo() {
  const query = `
    query($owner: String!, $name: String!) {
      repository(owner: $owner, name: $name) {
        id
        discussionCategories(first: 20) {
          nodes {
            id
            name
            slug
          }
        }
        labels(first: 100) {
          nodes {
            id
            name
          }
        }
      }
    }
  `;

  const data = await graphql(query, { owner: REPO_OWNER, name: REPO_NAME });
  return {
    repositoryId: data.repository.id,
    categories: data.repository.discussionCategories.nodes,
    labels: data.repository.labels.nodes
  };
}

// Get existing discussion by number (returns null if not found)
async function getDiscussion(number) {
  const query = `
    query($owner: String!, $name: String!, $number: Int!) {
      repository(owner: $owner, name: $name) {
        discussion(number: $number) {
          id
          title
          body
          category {
            id
            name
          }
          labels(first: 20) {
            nodes {
              id
              name
            }
          }
        }
      }
    }
  `;

  try {
    const data = await graphql(query, {
      owner: REPO_OWNER,
      name: REPO_NAME,
      number
    });
    return data.repository.discussion;
  } catch (err) {
    // NOT_FOUND is expected when discussion doesn't exist in this repo
    if (err.message.includes('Could not resolve to a Discussion')) {
      return null;
    }
    throw err;
  }
}

// Create new discussion
async function createDiscussion(repositoryId, categoryId, title, body) {
  const mutation = `
    mutation($repositoryId: ID!, $categoryId: ID!, $title: String!, $body: String!) {
      createDiscussion(input: {
        repositoryId: $repositoryId
        categoryId: $categoryId
        title: $title
        body: $body
      }) {
        discussion {
          id
          number
          url
        }
      }
    }
  `;

  const data = await graphql(mutation, { repositoryId, categoryId, title, body });
  return data.createDiscussion.discussion;
}

// Add labels to a discussion
async function addLabelsToDiscussion(discussionId, labelIds) {
  if (!labelIds || labelIds.length === 0) return;

  const mutation = `
    mutation($labelableId: ID!, $labelIds: [ID!]!) {
      addLabelsToLabelable(input: {
        labelableId: $labelableId
        labelIds: $labelIds
      }) {
        labelable {
          ... on Discussion {
            id
          }
        }
      }
    }
  `;

  await graphql(mutation, { labelableId: discussionId, labelIds });
}

// Create a label in the repository (REST API) with retry logic
async function createLabel(name, color = 'ededed', description = '', retries = 3) {
  const makeRequest = () => new Promise((resolve, reject) => {
    const body = JSON.stringify({ name, color, description });

    const options = {
      hostname: 'api.github.com',
      path: `/repos/${REPO_OWNER}/${REPO_NAME}/labels`,
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${GITHUB_TOKEN}`,
        'Content-Type': 'application/json',
        'User-Agent': 'discussion-sync-script',
        'Accept': 'application/vnd.github+json',
        'Content-Length': Buffer.byteLength(body)
      }
    };

    const req = https.request(options, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => {
        if (res.statusCode === 201) {
          const label = JSON.parse(data);
          resolve({ id: label.node_id, name: label.name });
        } else if (res.statusCode === 422) {
          // Label already exists
          resolve(null);
        } else {
          reject(new Error(`Failed to create label: ${res.statusCode} ${data}`));
        }
      });
    });

    req.on('error', reject);
    req.write(body);
    req.end();
  });

  let lastError;
  for (let attempt = 1; attempt <= retries; attempt++) {
    try {
      const result = await makeRequest();
      // Add delay after successful API call
      await delay(500);
      return result;
    } catch (err) {
      lastError = err;
      if (attempt < retries) {
        const waitTime = attempt * 1000;
        console.log(`   ⚠️  Attempt ${attempt} failed: ${err.message}. Retrying in ${waitTime}ms...`);
        await delay(waitTime);
      }
    }
  }
  throw lastError;
}

// Get or create labels, returns array of label IDs
async function getOrCreateLabelIds(labelNames, githubLabels) {
  const labelIds = [];

  for (const name of labelNames) {
    // Try to find existing label (case-insensitive)
    let label = githubLabels.find(l => l.name.toLowerCase() === name.toLowerCase());

    if (!label) {
      // Create new label
      console.log(`   🏷️  Creating label "${name}"...`);
      const newLabel = await createLabel(name);
      if (newLabel) {
        label = newLabel;
        githubLabels.push(newLabel); // Cache for future use
      }
    }

    if (label) {
      labelIds.push(label.id);
    }
  }

  return labelIds;
}

// Remove labels from a discussion
async function removeLabelsFromDiscussion(discussionId, labelIds) {
  if (!labelIds || labelIds.length === 0) return;

  const mutation = `
    mutation($labelableId: ID!, $labelIds: [ID!]!) {
      removeLabelsFromLabelable(input: {
        labelableId: $labelableId
        labelIds: $labelIds
      }) {
        labelable {
          ... on Discussion {
            id
          }
        }
      }
    }
  `;

  await graphql(mutation, { labelableId: discussionId, labelIds });
}

// Update existing discussion
async function updateDiscussion(discussionId, title, body, categoryId) {
  const mutation = `
    mutation($discussionId: ID!, $title: String!, $body: String!, $categoryId: ID!) {
      updateDiscussion(input: {
        discussionId: $discussionId
        title: $title
        body: $body
        categoryId: $categoryId
      }) {
        discussion {
          id
          number
          url
        }
      }
    }
  `;

  const data = await graphql(mutation, { discussionId, title, body, categoryId });
  return data.updateDiscussion.discussion;
}

// Get all discussions to sync
function getDiscussionsToSync() {
  const config = loadConfig();
  const categories = Object.keys(config.categories);
  const discussions = [];

  categories.forEach(categoryName => {
    const categoryDir = path.join(DISCUSSIONS_DIR, categoryName);

    if (!fs.existsSync(categoryDir) || !fs.statSync(categoryDir).isDirectory()) {
      return;
    }

    const items = fs.readdirSync(categoryDir, { withFileTypes: true });
    items
      .filter(item => item.isDirectory() && !item.name.startsWith('_'))
      .forEach(item => {
        if (TARGET_PATH && `${categoryName}/${item.name}` !== TARGET_PATH) {
          return;
        }

        const built = buildDiscussionContent(categoryName, item.name);
        if (built) {
          discussions.push(built);
        }
      });
  });

  return discussions;
}

// Map local category name to GitHub category
function mapCategory(localCategory, githubCategories) {
  const config = loadConfig();
  const categoryConfig = config.categories[localCategory];

  if (!categoryConfig) {
    return null;
  }

  // Try to find by name (case-insensitive)
  const categoryName = categoryConfig.name;
  return githubCategories.find(
    c => c.name.toLowerCase() === categoryName.toLowerCase()
  );
}

// Main sync function
async function sync() {
  console.log(`${DRY_RUN ? '[DRY RUN] ' : ''}Syncing discussions to ${REPO_OWNER}/${REPO_NAME}\n`);

  // Get repository info
  console.log('Fetching repository info...');
  const { repositoryId, categories: githubCategories, labels: githubLabels } = await getRepoInfo();
  console.log(`Repository ID: ${repositoryId}`);
  console.log(`Categories: ${githubCategories.map(c => c.name).join(', ')}`);
  console.log(`Labels: ${githubLabels.map(l => l.name).join(', ')}\n`);

  // Get discussions to sync
  const discussions = getDiscussionsToSync();
  console.log(`Found ${discussions.length} discussions to sync\n`);

  let created = 0;
  let updated = 0;
  let skipped = 0;
  let errors = 0;

  // Track missing categories to show summary
  const missingCategories = new Set();

  for (const discussion of discussions) {
    const path = `${discussion.category}/${discussion.slug}`;
    const githubCategory = mapCategory(discussion.category, githubCategories);

    if (!githubCategory) {
      const config = loadConfig();
      const categoryConfig = config.categories[discussion.category];
      if (categoryConfig) {
        missingCategories.add(`${categoryConfig.name} ${categoryConfig.emoji}`);
      }
      skipped++;
      continue;
    }

    try {
      if (discussion.meta.discussion_number) {
        // Update existing discussion
        const existingDiscussion = await getDiscussion(discussion.meta.discussion_number);

        if (!existingDiscussion) {
          console.log(`⚠ ${path}: Discussion #${discussion.meta.discussion_number} not found, will create new`);
          discussion.meta.discussion_number = null;
        } else {
          // Check if content changed
          const contentChanged = existingDiscussion.body !== discussion.content;
          const titleChanged = existingDiscussion.title !== discussion.meta.title;
          const categoryChanged = existingDiscussion.category.id !== githubCategory.id;

          // Check if labels changed
          const existingLabelNames = (existingDiscussion.labels?.nodes || []).map(l => l.name.toLowerCase()).sort();
          const wantedLabelNames = (discussion.meta.labels || []).map(l => l.toLowerCase()).sort();
          const labelsChanged = JSON.stringify(existingLabelNames) !== JSON.stringify(wantedLabelNames);

          if (!contentChanged && !titleChanged && !categoryChanged && !labelsChanged) {
            console.log(`⏭ ${path}: No changes detected, skipping`);
            skipped++;
            continue;
          }

          // Get or create wanted labels
          const wantedLabelIds = await getOrCreateLabelIds(discussion.meta.labels || [], githubLabels);

          if (DRY_RUN) {
            console.log(`📝 ${path}: Would update #${discussion.meta.discussion_number}`);
            if (titleChanged) console.log(`   Title: "${existingDiscussion.title}" → "${discussion.meta.title}"`);
            if (categoryChanged) console.log(`   Category: "${existingDiscussion.category.name}" → "${githubCategory.name}"`);
            if (contentChanged) console.log(`   Content changed (${discussion.content.length} chars)`);
            if (labelsChanged) console.log(`   Labels: [${existingLabelNames.join(', ')}] → [${wantedLabelNames.join(', ')}]`);
          } else {
            const result = await updateDiscussion(
              existingDiscussion.id,
              discussion.meta.title,
              discussion.content,
              githubCategory.id
            );

            // Update labels if changed
            if (labelsChanged) {
              // Remove existing labels first
              const existingLabelIds = (existingDiscussion.labels?.nodes || []).map(l => l.id);
              if (existingLabelIds.length > 0) {
                await removeLabelsFromDiscussion(existingDiscussion.id, existingLabelIds);
              }
              // Add new labels if any
              if (wantedLabelIds.length > 0) {
                await addLabelsToDiscussion(existingDiscussion.id, wantedLabelIds);
              }
            }

            console.log(`✅ ${path}: Updated #${result.number} - ${result.url}`);
          }
          updated++;
          continue;
        }
      }

      // Create new discussion
      // Get or create labels
      const labelIds = await getOrCreateLabelIds(discussion.meta.labels || [], githubLabels);

      if (DRY_RUN) {
        console.log(`🆕 ${path}: Would create new discussion in "${githubCategory.name}"`);
        console.log(`   Title: "${discussion.meta.title}"`);
        console.log(`   Labels: ${discussion.meta.labels?.join(', ') || 'none'}`);
        console.log(`   Content: ${discussion.content.length} chars`);
      } else {
        const result = await createDiscussion(
          repositoryId,
          githubCategory.id,
          discussion.meta.title,
          discussion.content
        );

        // Add labels if any
        if (labelIds.length > 0) {
          await addLabelsToDiscussion(result.id, labelIds);
        }

        // Update meta.json with new discussion number
        discussion.meta.discussion_number = result.number;
        discussion.meta.html_url = result.url;
        fs.writeFileSync(discussion.metaPath, JSON.stringify(discussion.meta, null, 2) + '\n');

        console.log(`✅ ${path}: Created #${result.number} - ${result.url} (${labelIds.length} labels)`);
      }
      created++;

    } catch (err) {
      console.error(`❌ ${path}: ${err.message}`);
      errors++;
    }

    // Small delay to avoid rate limiting
    await new Promise(r => setTimeout(r, 200));
  }

  // Summary
  console.log('\n--- Summary ---');
  console.log(`Created: ${created}`);
  console.log(`Updated: ${updated}`);
  console.log(`Skipped: ${skipped}`);
  console.log(`Errors: ${errors}`);

  if (missingCategories.size > 0) {
    console.log('\n⚠️  Missing categories (create these on GitHub first):');
    missingCategories.forEach(cat => console.log(`   - ${cat}`));
    console.log(`\n   Go to: https://github.com/${REPO_OWNER}/${REPO_NAME}/discussions/categories`);
  }

  if (DRY_RUN) {
    console.log('\n[DRY RUN] No changes were made. Run without --dry-run to apply changes.');
  }
}

// Run
sync().catch(err => {
  console.error('Fatal error:', err.message);
  process.exit(1);
});
