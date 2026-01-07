#!/usr/bin/env node

/**
 * GitHub Discussions Reverse Sync Script
 *
 * Syncs GitHub Discussions back to local .discussions files.
 * Parses the compiled discussion body and splits it back into individual platform files.
 *
 * Usage:
 *   GITHUB_TOKEN=xxx node scripts/reverse-sync.js <discussion_number>
 *
 * Examples:
 *   node scripts/reverse-sync.js 15    # Sync discussion #15 back to local files
 */

const https = require('https');
const fs = require('fs');
const path = require('path');

const {
  DISCUSSIONS_DIR,
  loadConfig
} = require('./utils');

// Configuration
const REPO_OWNER = 'sendbird';
const REPO_NAME = 'delight-ai-agent';

if (!process.env.GITHUB_TOKEN) {
  console.error('Error: GITHUB_TOKEN environment variable is required');
  process.exit(1);
}

const GITHUB_TOKEN = process.env.GITHUB_TOKEN;

// Parse command line arguments
const args = process.argv.slice(2);
const DISCUSSION_NUMBER = parseInt(args.find(arg => !arg.startsWith('--')), 10);
const DRY_RUN = args.includes('--dry-run');

if (!DISCUSSION_NUMBER || isNaN(DISCUSSION_NUMBER)) {
  console.error('Error: Discussion number is required');
  console.error('Usage: node scripts/reverse-sync.js <discussion_number>');
  process.exit(1);
}

// GraphQL helper
async function graphql(query, variables = {}) {
  return new Promise((resolve, reject) => {
    const body = JSON.stringify({ query, variables });

    const options = {
      hostname: 'api.github.com',
      path: '/graphql',
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${GITHUB_TOKEN}`,
        'Content-Type': 'application/json',
        'User-Agent': 'discussion-reverse-sync-script',
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
            reject(new Error(json.errors.map(e => e.message).join(', ')));
          } else if (!json.data) {
            reject(new Error('No data in response'));
          } else {
            resolve(json.data);
          }
        } catch (e) {
          reject(e);
        }
      });
    });

    req.on('error', reject);
    req.write(body);
    req.end();
  });
}

// Get discussion by number
async function getDiscussion(number) {
  const query = `
    query($owner: String!, $name: String!, $number: Int!) {
      repository(owner: $owner, name: $name) {
        discussion(number: $number) {
          id
          number
          title
          body
          url
          category {
            id
            name
            slug
          }
          labels(first: 20) {
            nodes {
              name
            }
          }
        }
      }
    }
  `;

  const data = await graphql(query, {
    owner: REPO_OWNER,
    name: REPO_NAME,
    number
  });

  return data.repository.discussion;
}

/**
 * Parse the compiled discussion body back into individual components
 */
function parseDiscussionBody(body) {
  // Normalize line endings (GitHub API may return \r\n)
  body = body.replace(/\r\n/g, '\n').replace(/\r/g, '\n');

  const config = loadConfig();
  const result = {
    versionBadges: {},  // platform -> badge
    indexContent: {
      summary: '',
      guideSnippet: '',
      reference: '',
      screenshots: ''
    },
    platformContents: {},  // platform -> content
    errors: []
  };

  // Create reverse mapping: display name -> platform key
  const displayNameToKey = {};
  for (const [key, displayName] of Object.entries(config.platform_display_names)) {
    displayNameToKey[displayName] = key;
  }

  // 1. Extract version badges section
  const versionsMatch = body.match(/^### Versions\n\n([\s\S]*?)\n\n(?=###|<details>)/);
  if (versionsMatch) {
    const badgesLine = versionsMatch[1].trim();
    // Parse individual badges - they are separated by space
    // Pattern: [![Platform](...)![Version](...)](#) or standalone ![...](...)
    const badgePattern = /\[!\[([^\]]+)\]\([^)]+\)!\[[^\]]+\]\([^)]+\)\]\([^)]+\)|!\[([^\]]+)\]\([^)]+\)/g;
    let match;
    while ((match = badgePattern.exec(badgesLine)) !== null) {
      const platformName = match[1] || match[2];
      const platformKey = displayNameToKey[platformName];
      if (platformKey) {
        result.versionBadges[platformKey] = match[0];
      }
    }
  }

  // 2. Extract Summary section
  const summaryMatch = body.match(/### Summary\n\n([\s\S]*?)(?=\n### Guide & Snippet|\n<details>|$)/);
  if (summaryMatch) {
    result.indexContent.summary = summaryMatch[1].trim();
  } else {
    result.errors.push('Missing required section: ### Summary');
  }

  // 3. Extract Guide & Snippet section (content between header and first <details>)
  // The content should be empty or minimal - just text before <details> blocks
  const guideMatch = body.match(/### Guide & Snippet\n\n([\s\S]*?)(?=<details>|$)/);
  if (guideMatch) {
    // Only keep non-details content (trim whitespace)
    const guideContent = guideMatch[1].trim();
    // If the content starts with <details>, it means Guide & Snippet is empty
    if (!guideContent.startsWith('<details>')) {
      result.indexContent.guideSnippet = guideContent;
    }
  }

  // 4. Extract platform contents from <details> blocks
  const detailsPattern = /<details>\n<summary>([^<]+)<\/summary>\n\n([\s\S]*?)\n\n<\/details>/g;
  let detailsMatch;
  while ((detailsMatch = detailsPattern.exec(body)) !== null) {
    const displayName = detailsMatch[1].trim();
    const content = detailsMatch[2].trim();
    const platformKey = displayNameToKey[displayName];

    if (platformKey) {
      // Skip placeholder content
      if (content !== '> This guide is coming soon. Stay tuned for updates!') {
        result.platformContents[platformKey] = content;
      }
    } else {
      result.errors.push(`Unknown platform in <details>: ${displayName}`);
    }
  }

  // 5. Extract Reference section
  const referenceMatch = body.match(/### Reference\n\n([\s\S]*?)(?=\n### Screenshots|$)/);
  if (referenceMatch) {
    result.indexContent.reference = referenceMatch[1].trim();
  } else {
    result.errors.push('Missing required section: ### Reference');
  }

  // 6. Extract Screenshots section
  const screenshotsMatch = body.match(/### Screenshots\n\n([\s\S]*?)$/);
  if (screenshotsMatch) {
    result.indexContent.screenshots = screenshotsMatch[1].trim();
  } else {
    result.errors.push('Missing required section: ### Screenshots');
  }

  return result;
}

/**
 * Find local discussion by discussion_number
 */
function findLocalDiscussion(discussionNumber) {
  const config = loadConfig();
  const categories = Object.keys(config.categories);

  for (const categoryName of categories) {
    const categoryDir = path.join(DISCUSSIONS_DIR, categoryName);

    if (!fs.existsSync(categoryDir) || !fs.statSync(categoryDir).isDirectory()) {
      continue;
    }

    const items = fs.readdirSync(categoryDir, { withFileTypes: true });
    for (const item of items) {
      if (!item.isDirectory() || item.name.startsWith('_')) continue;

      const metaPath = path.join(categoryDir, item.name, 'meta.json');
      if (!fs.existsSync(metaPath)) continue;

      const meta = JSON.parse(fs.readFileSync(metaPath, 'utf-8'));
      if (meta.discussion_number === discussionNumber) {
        return {
          category: categoryName,
          slug: item.name,
          metaPath,
          meta,
          dir: path.join(categoryDir, item.name)
        };
      }
    }
  }

  return null;
}

/**
 * Build _index.md content
 */
function buildIndexContent(parsed) {
  let content = '';

  content += '### Summary\n\n';
  content += parsed.indexContent.summary + '\n\n';

  content += '### Guide & Snippet\n\n';
  if (parsed.indexContent.guideSnippet) {
    content += parsed.indexContent.guideSnippet + '\n';
  }
  content += '\n';

  content += '### Reference\n\n';
  content += parsed.indexContent.reference + '\n\n';

  content += '### Screenshots\n\n';
  content += parsed.indexContent.screenshots + '\n';

  return content;
}

/**
 * Build platform file content
 */
function buildPlatformContent(platform, parsed) {
  let content = '';

  // Add version badge if exists
  if (parsed.versionBadges[platform]) {
    content += parsed.versionBadges[platform] + '\n\n';
  }

  // Add platform content
  if (parsed.platformContents[platform]) {
    content += parsed.platformContents[platform] + '\n';
  }

  return content;
}

/**
 * Main reverse sync function
 */
async function reverseSync() {
  console.log(`${DRY_RUN ? '[DRY RUN] ' : ''}Reverse syncing discussion #${DISCUSSION_NUMBER}\n`);

  // 1. Fetch discussion from GitHub
  console.log('Fetching discussion from GitHub...');
  const discussion = await getDiscussion(DISCUSSION_NUMBER);

  if (!discussion) {
    console.error(`Error: Discussion #${DISCUSSION_NUMBER} not found`);
    process.exit(1);
  }

  console.log(`Found: "${discussion.title}" (${discussion.category.name})`);
  console.log(`URL: ${discussion.url}\n`);

  // 2. Find local discussion
  const local = findLocalDiscussion(DISCUSSION_NUMBER);

  if (!local) {
    console.error(`Error: No local discussion found with discussion_number: ${DISCUSSION_NUMBER}`);
    console.error('Make sure the discussion exists locally with the correct discussion_number in meta.json');
    process.exit(1);
  }

  console.log(`Local path: ${local.category}/${local.slug}\n`);

  // 3. Parse discussion body
  console.log('Parsing discussion body...');
  const parsed = parseDiscussionBody(discussion.body);

  // 4. Check for parsing errors
  if (parsed.errors.length > 0) {
    console.error('\n❌ Parsing errors detected:');
    parsed.errors.forEach(err => console.error(`   - ${err}`));
    console.error('\nThe discussion body does not match the expected format.');
    console.error('Please ensure the discussion follows the correct structure.');
    process.exit(1);
  }

  console.log('✅ Parsing successful\n');

  // 5. Prepare files to write
  const filesToWrite = [];

  // _index.md
  const indexContent = buildIndexContent(parsed);
  const indexPath = path.join(local.dir, '_index.md');
  filesToWrite.push({ path: indexPath, content: indexContent, name: '_index.md' });

  // Platform files
  const config = loadConfig();
  const platforms = local.meta.platforms
    ? local.meta.platforms
    : config.default_platforms;

  for (const platform of platforms) {
    const platformContent = buildPlatformContent(platform, parsed);
    if (platformContent.trim()) {
      const platformPath = path.join(local.dir, `${platform}.md`);
      filesToWrite.push({ path: platformPath, content: platformContent, name: `${platform}.md` });
    }
  }

  // 6. Update meta.json if title or labels changed
  let metaChanged = false;
  const updatedMeta = { ...local.meta };

  if (local.meta.title !== discussion.title) {
    updatedMeta.title = discussion.title;
    metaChanged = true;
    console.log(`Title changed: "${local.meta.title}" → "${discussion.title}"`);
  }

  const discussionLabels = discussion.labels.nodes.map(l => l.name).sort();
  const localLabels = (local.meta.labels || []).sort();
  if (JSON.stringify(discussionLabels) !== JSON.stringify(localLabels)) {
    updatedMeta.labels = discussionLabels;
    metaChanged = true;
    console.log(`Labels changed: [${localLabels.join(', ')}] → [${discussionLabels.join(', ')}]`);
  }

  if (metaChanged) {
    filesToWrite.push({
      path: local.metaPath,
      content: JSON.stringify(updatedMeta, null, 2) + '\n',
      name: 'meta.json'
    });
  }

  // 7. Write files
  console.log('\nFiles to update:');
  for (const file of filesToWrite) {
    if (DRY_RUN) {
      console.log(`  📝 Would write: ${file.name}`);
    } else {
      fs.writeFileSync(file.path, file.content);
      console.log(`  ✅ Written: ${file.name}`);
    }
  }

  // Summary
  console.log('\n--- Summary ---');
  console.log(`Discussion: #${DISCUSSION_NUMBER} - ${discussion.title}`);
  console.log(`Local path: ${local.category}/${local.slug}`);
  console.log(`Files updated: ${filesToWrite.length}`);

  if (DRY_RUN) {
    console.log('\n[DRY RUN] No changes were made. Run without --dry-run to apply changes.');
  } else {
    console.log('\n✅ Reverse sync completed successfully');
  }
}

// Run
reverseSync().catch(err => {
  console.error('Fatal error:', err.message);
  process.exit(1);
});
