#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILDER_DIR="$SCRIPT_DIR/iconfont"

if [[ ! -d "$BUILDER_DIR/node_modules" ]]; then
  npm --prefix "$BUILDER_DIR" i
fi

npm --prefix "$BUILDER_DIR" run build
