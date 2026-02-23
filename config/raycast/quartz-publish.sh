#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Publish Changes
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🚀
# @raycast.packageName dom.quartz.publish

# Documentation:
# @raycast.description Commit and push changes to the repository
# @raycast.author Dominick Lee
# @raycast.authorURL https://github.com/domogami

# Navigate to Quartz directory
cd /Users/dom/Documents/GitHub/obsidian-site/quartz || exit 1

# Commit and push changes
git add .
date=$(date '+%m-%d-%Y')
git commit -m "✨ [FEAT] $date Update"
git push

echo "✅ Published successfully!"