#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

const DISCUSSIONS_DIR = path.join(__dirname, '..');

// Regex pattern to match version badge (linked or standalone)
// Matches: [![...](...)![...](...)](#) or ![...](...)
const VERSION_BADGE_PATTERN = /^(\[!\[.*?\]\(.*?\)!\[.*?\]\(.*?\)\]\(.*?\)|!\[.*?\]\(.*?\))\s*\n*/;

/**
 * Load configuration from _config.json
 */
function loadConfig() {
  const configPath = path.join(DISCUSSIONS_DIR, '_config.json');
  return JSON.parse(fs.readFileSync(configPath, 'utf-8'));
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

/**
 * Get category directories from config
 */
function getCategories() {
  const config = loadConfig();
  return Object.keys(config.categories);
}

/**
 * Get discussion directories within a category
 */
function getDiscussions(categoryDir) {
  const items = fs.readdirSync(categoryDir, { withFileTypes: true });
  return items
    .filter(item => item.isDirectory() && !item.name.startsWith('_'))
    .map(item => item.name);
}

module.exports = {
  DISCUSSIONS_DIR,
  VERSION_BADGE_PATTERN,
  loadConfig,
  extractVersionBadge,
  getCategories,
  getDiscussions
};
