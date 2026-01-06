#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

const DISCUSSIONS_DIR = path.join(__dirname, '..');
const OUTPUT_DIR = path.join(DISCUSSIONS_DIR, '_output');

// Regex pattern to match version badge (linked or standalone)
// Matches: [![...](...)![...](...)](#) or ![...](...)
const VERSION_BADGE_PATTERN = /^(\[!\[.*?\]\(.*?\)!\[.*?\]\(.*?\)\]\(.*?\)|!\[.*?\]\(.*?\))\s*\n*/;

function loadConfig() {
  const configPath = path.join(DISCUSSIONS_DIR, '_config.json');
  return JSON.parse(fs.readFileSync(configPath, 'utf-8'));
}

function getCategories() {
  const config = loadConfig();
  return Object.keys(config.categories);
}

function getDiscussions(categoryDir) {
  const items = fs.readdirSync(categoryDir, { withFileTypes: true });
  return items
    .filter(item => item.isDirectory() && !item.name.startsWith('_'))
    .map(item => item.name);
}

/**
 * Extract version badge from the beginning of content
 * Returns { badge: string|null, content: string }
 */
function extractVersionBadge(content) {
  const trimmed = content.trim();
  const match = trimmed.match(VERSION_BADGE_PATTERN);

  if (match) {
    return {
      badge: match[1].trim(),
      content: trimmed.substring(match[0].length).trim()
    };
  }

  return { badge: null, content: trimmed };
}

function buildDiscussion(categoryName, discussionName) {
  const config = loadConfig();
  const discussionDir = path.join(DISCUSSIONS_DIR, categoryName, discussionName);
  const metaPath = path.join(discussionDir, 'meta.json');

  if (!fs.existsSync(metaPath)) {
    console.warn(`Skipping ${categoryName}/${discussionName}: no meta.json found`);
    return null;
  }

  const meta = JSON.parse(fs.readFileSync(metaPath, 'utf-8'));
  // Use default_platforms if order is empty or not set
  const platformOrder = (meta.order && meta.order.length > 0)
    ? meta.order.filter(p => p !== '_index')
    : config.default_platforms;

  let content = '';
  let footerContent = '';
  const versionBadges = []; // Collect version badges from platform files

  // First pass: collect version badges from platform files
  platformOrder.forEach(platform => {
    const platformFile = path.join(discussionDir, `${platform}.md`);
    if (fs.existsSync(platformFile)) {
      const platformContent = fs.readFileSync(platformFile, 'utf-8');
      const { badge } = extractVersionBadge(platformContent);
      if (badge) {
        versionBadges.push(badge);
      }
    }
  });

  // Add version badges section at the top if any exist
  if (versionBadges.length > 0) {
    content += '### Versions\n\n';
    content += versionBadges.join(' ') + '\n\n';
  }

  // Process _index.md first (always, regardless of order)
  const indexFile = path.join(discussionDir, '_index.md');
  if (fs.existsSync(indexFile)) {
    let indexContent = fs.readFileSync(indexFile, 'utf-8').trim();

    // Remove ### Versions section from _index.md (now managed in platform files)
    indexContent = indexContent.replace(/^### Versions\n+[\s\S]*?\n+(?=###|$)/, '');
    indexContent = indexContent.trim();

    // Split by ### Reference to separate header and footer
    const referenceIndex = indexContent.indexOf('### Reference');
    if (referenceIndex !== -1) {
      const headerContent = indexContent.substring(0, referenceIndex).trim();
      footerContent = '\n\n' + indexContent.substring(referenceIndex).trim();
      if (headerContent) {
        content += headerContent + '\n\n';
      }
    } else {
      if (indexContent) {
        content += indexContent + '\n\n';
      }
    }
  }

  // Second pass: build platform content
  platformOrder.forEach(platform => {
    const platformFile = path.join(discussionDir, `${platform}.md`);

    // Handle platform-specific files with collapsible details tag
    const displayName = config.platform_display_names[platform] || platform;

    content += `<details>\n<summary>${displayName}</summary>\n\n`;

    if (fs.existsSync(platformFile)) {
      const platformContent = fs.readFileSync(platformFile, 'utf-8');
      // Remove version badge from platform content (already collected above)
      const { content: contentWithoutBadge } = extractVersionBadge(platformContent);
      content += contentWithoutBadge;
    } else {
      content += `> This guide is coming soon. Stay tuned for updates!\n`;
    }

    content += '\n\n</details>\n\n';
  });

  // Add footer content (Reference, Screenshots) after platform sections
  if (footerContent) {
    content += footerContent;
  }

  // Remove trailing separator
  content = content.replace(/\n---\n\n$/, '\n');

  return {
    meta,
    content,
    category: categoryName,
    slug: discussionName,
  };
}

function buildAll() {
  const config = loadConfig();
  const categories = getCategories();
  const results = [];

  // Ensure output directory exists
  if (!fs.existsSync(OUTPUT_DIR)) {
    fs.mkdirSync(OUTPUT_DIR, { recursive: true });
  }

  categories.forEach(categoryName => {
    const categoryDir = path.join(DISCUSSIONS_DIR, categoryName);

    if (!fs.existsSync(categoryDir) || !fs.statSync(categoryDir).isDirectory()) {
      return;
    }

    const discussions = getDiscussions(categoryDir);

    discussions.forEach(discussionName => {
      const result = buildDiscussion(categoryName, discussionName);
      if (result) {
        results.push(result);

        // Write output file
        const outputPath = path.join(OUTPUT_DIR, `${categoryName}--${discussionName}.md`);
        fs.writeFileSync(outputPath, result.content);
        console.log(`Built: ${outputPath}`);
      }
    });
  });

  // Write manifest
  const manifest = results.map(r => ({
    category: r.category,
    slug: r.slug,
    title: r.meta.title,
    discussion_number: r.meta.discussion_number,
    labels: r.meta.labels,
    platforms: r.meta.platforms,
  }));

  fs.writeFileSync(
    path.join(OUTPUT_DIR, 'manifest.json'),
    JSON.stringify(manifest, null, 2)
  );

  console.log(`\nBuilt ${results.length} discussions`);
  console.log(`Manifest written to: ${path.join(OUTPUT_DIR, 'manifest.json')}`);
}

// Run
buildAll();
