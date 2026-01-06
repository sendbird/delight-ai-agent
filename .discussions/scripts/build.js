#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

const {
  DISCUSSIONS_DIR,
  getCategories,
  getDiscussions,
  buildDiscussionContent
} = require('./utils');

const OUTPUT_DIR = path.join(DISCUSSIONS_DIR, '_output');

function buildAll() {
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
      const result = buildDiscussionContent(categoryName, discussionName);
      if (result) {
        results.push(result);

        // Write output file
        const outputPath = path.join(OUTPUT_DIR, `${categoryName}--${discussionName}.md`);
        fs.writeFileSync(outputPath, result.content);
        console.log(`Built: ${outputPath}`);
      } else {
        console.warn(`Skipping ${categoryName}/${discussionName}: no meta.json found`);
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
