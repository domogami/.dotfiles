#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Build and Review
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🛠️
# @raycast.packageName dom.quartz.publish

# Documentation:
# @raycast.description Build the Quartz site and display Git status
# @raycast.author Dominick Lee
# @raycast.authorURL https://github.com/domogami

# Set PATH to include Node.js binaries
export PATH="/Users/dom/.nvm/versions/node/v22.14.0/bin:$PATH"

# Define directories
VAULT_DIR="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/Dom's 2nd Brain"
EXPORT_DIR="/Users/dom/Documents/GitHub/obsidian-site/quartz/content"
PUBLIC_DIR="/Users/dom/Documents/GitHub/obsidian-site/quartz/public"
QUARTZ_DIR="/Users/dom/Documents/GitHub/obsidian-site/quartz"
EXPORTER="/Users/dom/Documents/GitHub/obsidian-site/obsidian-export/target/debug/obsidian-export"

# Remove old files
rm -rf "$EXPORT_DIR"/*
rm -rf "$PUBLIC_DIR"/*

# Export Obsidian Vault
"$EXPORTER" --frontmatter=always "$VAULT_DIR" "$EXPORT_DIR"

# Navigate to Quartz directory
cd "$QUARTZ_DIR" || exit 1

# Build Quartz site
if ! npx quartz build; then
  echo "❌ Build failed. Aborting."
  exit 1
fi

# Display git status
echo "📄 Git Status:"
git status