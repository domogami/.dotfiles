#!/usr/bin/env zsh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
BREWFILE_PATH="$REPO_DIR/Brewfile"

STRICT=0
STRICT_BREW=0

if [[ -t 1 ]]; then
  C_RESET=$'\033[0m'
  C_BLUE=$'\033[34m'
  C_GREEN=$'\033[32m'
  C_YELLOW=$'\033[33m'
  C_RED=$'\033[31m'
else
  C_RESET=""
  C_BLUE=""
  C_GREEN=""
  C_YELLOW=""
  C_RED=""
fi

usage() {
  cat <<'EOF'
Usage:
  ./scripts/dotfiles_health_check.zsh [--strict] [--strict-brew]

Options:
  --strict        Treat warnings as failures for install-critical checks.
  --strict-brew   Fail if Brewfile packages are missing.
  -h, --help      Show this help text.
EOF
}

pass() {
  printf '%s[ok]%s   %s\n' "$C_GREEN" "$C_RESET" "$1"
}

note() {
  printf '%s[note]%s %s\n' "$C_BLUE" "$C_RESET" "$1"
}

warn() {
  printf '%s[warn]%s %s\n' "$C_YELLOW" "$C_RESET" "$1"
}

fail() {
  printf '%s[err]%s  %s\n' "$C_RED" "$C_RESET" "$1" >&2
}

failures=0
warnings=0

record_failure() {
  failures=$((failures + 1))
  fail "$1"
}

record_warning() {
  warnings=$((warnings + 1))
  warn "$1"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --strict)
      STRICT=1
      shift
      ;;
    --strict-brew)
      STRICT_BREW=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      fail "Unknown option: $1"
      usage
      exit 1
      ;;
  esac
done

printf '\n%s[dotfiles health check]%s %s\n' "$C_BLUE" "$C_RESET" "$REPO_DIR"

if [[ ! -d "$REPO_DIR/.git" ]]; then
  record_failure "Repository root not detected at $REPO_DIR"
  exit 1
fi
pass "Repository root detected"

note "Checking required files"
required_files=(
  "install"
  "install.config.yaml"
  "README.md"
  "Brewfile"
  ".githooks/pre-commit"
  "scripts/setup_homebrew.zsh"
  "scripts/obsidian_settings.zsh"
  "scripts/archive_setup_snapshot.zsh"
  "scripts/dotfiles_health_check.zsh"
)
for rel in "${required_files[@]}"; do
  if [[ -e "$REPO_DIR/$rel" ]]; then
    pass "found $rel"
  else
    record_failure "missing $rel"
  fi
done

note "Checking executable scripts"
required_exec=(
  "install"
  "scripts/setup_homebrew.zsh"
  "scripts/install_raycast_commands.zsh"
  "scripts/obsidian_settings.zsh"
  "scripts/archive_setup_snapshot.zsh"
  "scripts/dotfiles_health_check.zsh"
  ".githooks/pre-commit"
)
for rel in "${required_exec[@]}"; do
  if [[ -x "$REPO_DIR/$rel" ]]; then
    pass "executable $rel"
  else
    record_failure "not executable: $rel"
  fi
done

note "Checking submodule policy"
gitlinks=("${(@f)$(git -C "$REPO_DIR" ls-files -s | awk '$1==160000 {line=$0; sub(/^[0-9]+ [0-9a-f]+ [0-9]+\t/, "", line); print line}')}")
unexpected_gitlinks=()
has_dotbot=0
for gitlink_path in "${gitlinks[@]}"; do
  [[ -z "$gitlink_path" ]] && continue
  if [[ "$gitlink_path" == "dotbot" ]]; then
    has_dotbot=1
  else
    unexpected_gitlinks+=("$gitlink_path")
  fi
done

if [[ ${#unexpected_gitlinks[@]} -gt 0 ]]; then
  for gitlink_path in "${unexpected_gitlinks[@]}"; do
    record_failure "unexpected gitlink in index: $gitlink_path"
  done
else
  pass "no unexpected gitlinks found"
fi

if [[ "$has_dotbot" -eq 1 ]]; then
  pass "dotbot submodule is tracked"
else
  record_warning "dotbot submodule is not tracked in index"
fi

if [[ -f "$REPO_DIR/.gitmodules" ]] && grep -q 'path = dotbot' "$REPO_DIR/.gitmodules"; then
  pass ".gitmodules contains dotbot mapping"
else
  record_failure ".gitmodules is missing dotbot mapping"
fi

note "Checking Git hook configuration"
hooks_path="$(git -C "$REPO_DIR" config --get core.hooksPath || true)"
if [[ "$hooks_path" == ".githooks" ]]; then
  pass "core.hooksPath is .githooks"
else
  if [[ "$STRICT" -eq 1 ]]; then
    record_failure "core.hooksPath is '${hooks_path:-<unset>}' (expected .githooks)"
  else
    record_warning "core.hooksPath is '${hooks_path:-<unset>}' (run ./install to configure hooks)"
  fi
fi

note "Checking key symlinks"
install_links=(
  "$HOME/.zshrc"
  "$HOME/.bashrc"
  "$HOME/.gitconfig"
  "$HOME/.gitignore_global"
  "$HOME/.config"
)
for link_path in "${install_links[@]}"; do
  if [[ -L "$link_path" ]]; then
    pass "symlink present: $link_path"
  else
    if [[ "$STRICT" -eq 1 ]]; then
      record_failure "missing symlink: $link_path"
    else
      record_warning "missing symlink: $link_path"
    fi
  fi
done

note "Checking Homebrew/Brewfile status"
if [[ -f "$BREWFILE_PATH" ]]; then
  pass "Brewfile present"
else
  record_failure "Brewfile missing at $BREWFILE_PATH"
fi

if command -v brew >/dev/null 2>&1; then
  if brew bundle check --file="$BREWFILE_PATH" --no-upgrade >/dev/null 2>&1; then
    pass "Brewfile packages are satisfied"
  else
    if [[ "$STRICT_BREW" -eq 1 ]]; then
      record_failure "Brewfile has missing packages (strict brew mode)"
    else
      record_warning "Brewfile has missing packages"
    fi
  fi
else
  record_warning "brew is not installed"
fi

note "Checking gitleaks availability"
if command -v gitleaks >/dev/null 2>&1; then
  pass "gitleaks is installed"
else
  record_warning "gitleaks not found (install with: brew install gitleaks)"
fi

printf '\n%sSummary:%s %s failures, %s warnings\n' "$C_BLUE" "$C_RESET" "$failures" "$warnings"

if [[ "$failures" -gt 0 ]]; then
  exit 1
fi

exit 0
