#!/bin/bash

set -euo pipefail

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title publish dotfiles
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 📦
# @raycast.packageName dom.dotfiles

# Documentation:
# @raycast.description Run health check, commit all changes with a timestamp, and push.
# @raycast.author Dominick Lee
# @raycast.authorURL https://github.com/domogami

REPO_DIR="/Users/dom/.dotfiles"
HEALTH_CHECK_SCRIPT="$REPO_DIR/scripts/dotfiles_health_check.zsh"

cd "$REPO_DIR" || {
  echo "❌ Could not enter $REPO_DIR"
  exit 1
}

echo "🔎 Running strict health check..."
"$HEALTH_CHECK_SCRIPT" --strict

echo
echo "📌 Staging changes..."
git add -A

if git diff --cached --quiet; then
  echo "ℹ️ No changes to commit."
  exit 0
fi

timestamp="$(date '+%Y-%m-%d %H:%M:%S %z')"
commit_message="chore(dotfiles): publish ${timestamp}"
branch="$(git rev-parse --abbrev-ref HEAD)"

echo
echo "📝 Commit message: $commit_message"
git commit -m "$commit_message"

echo
echo "🚀 Pushing to origin/$branch..."
git push origin "$branch"

echo
echo "✅ Dotfiles published on $branch."
