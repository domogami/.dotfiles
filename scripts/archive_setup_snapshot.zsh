#!/usr/bin/env zsh

set -euo pipefail

# Archive a setup snapshot (README + images) into docs/setup-archive, then
# regenerate:
# 1) docs/setup-archive/index.yaml
# 2) docs/setup-archive/INDEX.md
# 3) README.md archive preview block
#
# This script is intentionally dependency-light so it can run on a fresh machine
# without Python/Node tooling.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

ARCHIVE_ROOT="$REPO_DIR/docs/setup-archive"
ENTRIES_DIR="$ARCHIVE_ROOT/entries"
INDEX_YAML="$ARCHIVE_ROOT/index.yaml"
INDEX_MD="$ARCHIVE_ROOT/INDEX.md"
ROOT_README="$REPO_DIR/README.md"

START_MARKER="<!-- SETUP_ARCHIVE_START -->"
END_MARKER="<!-- SETUP_ARCHIVE_END -->"

DEFAULT_SOURCE_README="$REPO_DIR/README.md"
DEFAULT_SOURCE_IMAGES="$REPO_DIR/photos/current/hero-1.png,$REPO_DIR/photos/current/hero-2.png,$REPO_DIR/photos/current/hero-3.png"

ID=""
TITLE=""
DATE_LABEL=""
DATE_START=""
DATE_END=""
SUMMARY=""
TOOLS_CSV=""
SOURCE_README="$DEFAULT_SOURCE_README"
SOURCE_IMAGES_CSV="$DEFAULT_SOURCE_IMAGES"

DRY_RUN=false
FORCE=false

die() {
  echo "error: $*" >&2
  exit 1
}

log() {
  echo "[archive] $*"
}

usage() {
  cat <<'EOF'
Usage:
  scripts/archive_setup_snapshot.zsh \
    --id <entry-id> \
    --title <title> \
    --date-label <label> \
    --summary <summary> \
    --tools <comma,separated,tools> \
    [--date-start YYYY-MM-DD] \
    [--date-end YYYY-MM-DD] \
    [--source-readme /absolute/or/repo/path] \
    [--source-images /path/a.png,/path/b.png,/path/c.png] \
    [--dry-run] \
    [--force]

Examples:
  scripts/archive_setup_snapshot.zsh \
    --id 2022-onedark-rice \
    --title "OneDark Rice Era 2022" \
    --date-label "April-September 2022" \
    --date-start 2022-04-21 \
    --date-end 2022-09-24 \
    --summary "OneDark-themed macOS rice focused on keyboard-first workflows." \
    --tools "Dotbot,Yabai,SKHD,Karabiner,Neovim,Oh My Zsh" \
    --source-readme /tmp/legacy-readme.md \
    --source-images /Users/dom/.dotfiles/photos/photo1.png,/Users/dom/.dotfiles/photos/photo2.png,/Users/dom/.dotfiles/photos/photo3.png

Notes:
  - --dry-run prints intended operations without writing files.
  - --force allows replacing an existing entry id.
EOF
}

trim() {
  printf '%s' "$1" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'
}

yaml_escape() {
  local value="$1"
  value="${value//\\/\\\\}"
  value="${value//\"/\\\"}"
  printf '%s' "$value"
}

run_cmd() {
  if [[ "$DRY_RUN" == true ]]; then
    printf 'DRYRUN:'
    printf ' %q' "$@"
    printf '\n'
  else
    "$@"
  fi
}

write_file() {
  local file_path="$1"
  local content="$2"
  if [[ "$DRY_RUN" == true ]]; then
    log "DRYRUN write: $file_path"
    return 0
  fi

  local tmp="${file_path}.tmp.$$"
  printf '%s' "$content" > "$tmp"
  mv "$tmp" "$file_path"
}

relative_to_repo() {
  local file_path="$1"
  if [[ "$file_path" == "$REPO_DIR/"* ]]; then
    printf '%s' "${file_path#$REPO_DIR/}"
  else
    printf '%s' "$file_path"
  fi
}

index_entries_tsv() {
  local index_content="$1"
  printf '%s' "$index_content" | awk '
    function unquote(v) {
      gsub(/^"/, "", v)
      gsub(/"$/, "", v)
      return v
    }
    function flush() {
      if (id != "") {
        printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\n", id, title, date_label, summary, entry_readme, preview_img, tools
      }
    }
    /^  - id: / {
      flush()
      id=$0
      sub(/^  - id: "/, "", id)
      sub(/"$/, "", id)
      title=""
      date_label=""
      summary=""
      entry_readme=""
      preview_img=""
      tools=""
      in_tools=0
      in_preview=0
      next
    }
    {
      if (id == "") next
      if ($0 ~ /^    title: /) {
        title=$0
        sub(/^    title: "/, "", title)
        sub(/"$/, "", title)
        in_tools=0
        in_preview=0
      } else if ($0 ~ /^    date_label: /) {
        date_label=$0
        sub(/^    date_label: "/, "", date_label)
        sub(/"$/, "", date_label)
        in_tools=0
        in_preview=0
      } else if ($0 ~ /^    summary: /) {
        summary=$0
        sub(/^    summary: "/, "", summary)
        sub(/"$/, "", summary)
        in_tools=0
        in_preview=0
      } else if ($0 ~ /^    entry_readme: /) {
        entry_readme=$0
        sub(/^    entry_readme: "/, "", entry_readme)
        sub(/"$/, "", entry_readme)
        in_tools=0
        in_preview=0
      } else if ($0 ~ /^    tools_highlights:$/) {
        in_tools=1
        in_preview=0
      } else if ($0 ~ /^    preview_images:$/) {
        in_preview=1
        in_tools=0
      } else if (in_tools && $0 ~ /^      - /) {
        tool=$0
        sub(/^      - "/, "", tool)
        sub(/"$/, "", tool)
        if (tools == "") {
          tools=tool
        } else {
          tools=tools ", " tool
        }
      } else if (in_preview && $0 ~ /^      - /) {
        if (preview_img == "") {
          preview_img=$0
          sub(/^      - "/, "", preview_img)
          sub(/"$/, "", preview_img)
        }
      } else {
        in_tools=0
        in_preview=0
      }
    }
    END {
      flush()
    }
  '
}

build_index_markdown() {
  local entries_tsv="$1"
  local out=""

  out+="# Setup Archive"$'\n\n'
  out+="Historical snapshots of previous dotfiles eras."$'\n\n'
  out+="Each entry preserves the README and images from that point in time."$'\n\n'

  if [[ -z "$(printf '%s' "$entries_tsv" | tr -d '[:space:]')" ]]; then
    out+="_No archived setups yet._"$'\n'
    printf '%s' "$out"
    return 0
  fi

  while IFS=$'\t' read -r entry_id entry_title entry_date entry_summary entry_readme entry_img entry_tools; do
    [[ -z "$entry_id" ]] && continue

    local readme_local="${entry_readme#docs/setup-archive/}"
    local img_local="${entry_img#docs/setup-archive/}"

    out+="## $entry_title"$'\n\n'
    if [[ -n "$img_local" ]]; then
      out+="![${entry_title} preview](./${img_local})"$'\n\n'
    fi
    out+="- Date: ${entry_date}"$'\n'
    out+="- Highlights: ${entry_tools}"$'\n'
    out+="- Summary: ${entry_summary}"$'\n'
    out+="- Snapshot: [View archived README](./${readme_local})"$'\n\n'
  done <<< "$entries_tsv"

  printf '%s' "$out"
}

build_readme_archive_block() {
  local entries_tsv="$1"
  local out=""

  out+="$START_MARKER"$'\n'
  out+="## Past Setups"$'\n\n'
  out+="Snapshots of previous setup eras, with archived README content and images."$'\n\n'

  while IFS=$'\t' read -r entry_id entry_title entry_date entry_summary entry_readme entry_img entry_tools; do
    [[ -z "$entry_id" ]] && continue
    out+="### ${entry_title}"$'\n\n'
    if [[ -n "$entry_img" ]]; then
      out+="![${entry_title} preview](./${entry_img})"$'\n\n'
    fi
    out+="_${entry_date}_"$'\n\n'
    out+="${entry_summary}"$'\n\n'
    out+="Highlights: ${entry_tools}"$'\n\n'
    out+="[View archived setup](./${entry_readme})"$'\n\n'
  done <<< "$entries_tsv"

  out+="[Browse all setup archives](./docs/setup-archive/INDEX.md)"$'\n'
  out+="$END_MARKER"$'\n'

  printf '%s' "$out"
}

replace_or_append_archive_block() {
  local block="$1"

  if [[ "$DRY_RUN" == true ]]; then
    log "DRYRUN update README archive block in $ROOT_README"
    return 0
  fi

  local block_tmp readme_tmp
  block_tmp="$(mktemp /tmp/archive-block.XXXXXX)"
  readme_tmp="$(mktemp /tmp/readme-archive.XXXXXX)"
  printf '%s' "$block" > "$block_tmp"

  if grep -q "^${START_MARKER}$" "$ROOT_README"; then
    awk -v start="$START_MARKER" -v end="$END_MARKER" -v block_file="$block_tmp" '
      BEGIN {
        while ((getline line < block_file) > 0) {
          block = block line ORS
        }
      }
      $0 == start {
        printf "%s", block
        in_block = 1
        replaced = 1
        next
      }
      in_block && $0 == end {
        in_block = 0
        next
      }
      !in_block {
        print
      }
      END {
        if (!replaced) {
          print ""
          printf "%s", block
        }
      }
    ' "$ROOT_README" > "$readme_tmp"
  else
    cat "$ROOT_README" > "$readme_tmp"
    printf '\n\n' >> "$readme_tmp"
    cat "$block_tmp" >> "$readme_tmp"
  fi

  mv "$readme_tmp" "$ROOT_README"
  rm -f "$block_tmp"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --id)
      ID="${2:-}"
      shift 2
      ;;
    --title)
      TITLE="${2:-}"
      shift 2
      ;;
    --date-label)
      DATE_LABEL="${2:-}"
      shift 2
      ;;
    --date-start)
      DATE_START="${2:-}"
      shift 2
      ;;
    --date-end)
      DATE_END="${2:-}"
      shift 2
      ;;
    --summary)
      SUMMARY="${2:-}"
      shift 2
      ;;
    --tools)
      TOOLS_CSV="${2:-}"
      shift 2
      ;;
    --source-readme)
      SOURCE_README="${2:-}"
      shift 2
      ;;
    --source-images)
      SOURCE_IMAGES_CSV="${2:-}"
      shift 2
      ;;
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --force)
      FORCE=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      usage
      die "unknown argument: $1"
      ;;
  esac
done

# Validate required arguments and normalize user input.
[[ -n "$ID" ]] || die "--id is required"
[[ -n "$TITLE" ]] || die "--title is required"
[[ -n "$DATE_LABEL" ]] || die "--date-label is required"
[[ -n "$SUMMARY" ]] || die "--summary is required"
[[ -n "$TOOLS_CSV" ]] || die "--tools is required"

printf '%s' "$ID" | grep -Eq '^[a-z0-9][a-z0-9-]*$' || die "--id must match ^[a-z0-9][a-z0-9-]*$"
[[ -f "$SOURCE_README" ]] || die "--source-readme does not exist: $SOURCE_README"
[[ -f "$ROOT_README" ]] || die "root README not found: $ROOT_README"

if [[ -n "$DATE_START" ]]; then
  printf '%s' "$DATE_START" | grep -Eq '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' || die "--date-start must be YYYY-MM-DD"
fi
if [[ -n "$DATE_END" ]]; then
  printf '%s' "$DATE_END" | grep -Eq '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' || die "--date-end must be YYYY-MM-DD"
fi

typeset -a TOOLS=()
typeset -a RAW_TOOLS=()
IFS=',' read -rA RAW_TOOLS <<< "$TOOLS_CSV"
for raw_tool in "${RAW_TOOLS[@]}"; do
  tool="$(trim "$raw_tool")"
  [[ -n "$tool" ]] && TOOLS+=("$tool")
done
(( ${#TOOLS[@]} > 0 )) || die "--tools resolved to an empty list after trimming"

typeset -a SOURCE_IMAGES=()
typeset -a RAW_IMAGES=()
IFS=',' read -rA RAW_IMAGES <<< "$SOURCE_IMAGES_CSV"
for raw_image in "${RAW_IMAGES[@]}"; do
  image_path="$(trim "$raw_image")"
  [[ -n "$image_path" ]] || continue
  [[ -f "$image_path" ]] || die "source image does not exist: $image_path"
  SOURCE_IMAGES+=("$image_path")
done
(( ${#SOURCE_IMAGES[@]} > 0 )) || die "--source-images resolved to an empty list"

# Phase 1: Create or replace the snapshot entry directory and copy snapshot
# artifacts (README + images).
ENTRY_DIR="$ENTRIES_DIR/$ID"
ENTRY_IMAGES_DIR="$ENTRY_DIR/images"
ENTRY_REL="docs/setup-archive/entries/$ID"
ENTRY_README_REL="$ENTRY_REL/README.md"

if [[ -d "$ENTRY_DIR" && "$FORCE" != true ]]; then
  die "entry already exists: $ENTRY_DIR (use --force to replace)"
fi

if [[ -d "$ENTRY_DIR" && "$FORCE" == true ]]; then
  run_cmd rm -rf "$ENTRY_DIR"
fi

run_cmd mkdir -p "$ENTRY_IMAGES_DIR"
run_cmd mkdir -p "$ARCHIVE_ROOT"

run_cmd cp "$SOURCE_README" "$ENTRY_DIR/README.md"

typeset -a COPIED_IMAGE_RELS=()
for src_image in "${SOURCE_IMAGES[@]}"; do
  image_name="$(basename "$src_image")"
  dst_image="$ENTRY_IMAGES_DIR/$image_name"
  run_cmd cp "$src_image" "$dst_image"
  COPIED_IMAGE_RELS+=("$ENTRY_REL/images/$image_name")
done

# Rewrite markdown image links in the archived README so snapshots are
# self-contained:
# 1) explicitly provided --source-images
# 2) any additional local markdown image paths found in the README
if [[ "$DRY_RUN" == true ]]; then
  log "DRYRUN rewrite image links inside $ENTRY_DIR/README.md"
else
  entry_readme_content="$(cat "$ENTRY_DIR/README.md")"
  source_readme_dir="$(cd "$(dirname "$SOURCE_README")" && pwd)"

  # First pass: rewrite images explicitly provided by --source-images.
  for src_image in "${SOURCE_IMAGES[@]}"; do
    image_name="$(basename "$src_image")"
    repo_rel_src="$(relative_to_repo "$src_image")"
    snapshot_rel="./images/$image_name"

    entry_readme_content="${entry_readme_content//${src_image}/${snapshot_rel}}"
    entry_readme_content="${entry_readme_content//.\/${repo_rel_src}/${snapshot_rel}}"
    entry_readme_content="${entry_readme_content//${repo_rel_src}/${snapshot_rel}}"
  done

  # Second pass: discover additional local markdown image links and copy them
  # into this snapshot entry.
  typeset -a md_images=()
  while IFS= read -r image_ref; do
    [[ -n "$image_ref" ]] && md_images+=("$image_ref")
  done < <(printf '%s' "$entry_readme_content" | perl -ne 'while(/!\[[^\]]*\]\(([^)]+)\)/g){print "$1\n"}')

  typeset -a normalized_seen=()
  for image_ref in "${md_images[@]}"; do
    case "$image_ref" in
      http://*|https://*|data:*)
        continue
        ;;
    esac

    # Skip links already rewritten to the snapshot image directory.
    if [[ "$image_ref" == "./images/"* ]]; then
      continue
    fi

    source_path=""
    if [[ -f "$image_ref" ]]; then
      source_path="$image_ref"
    elif [[ -f "$source_readme_dir/$image_ref" ]]; then
      source_path="$source_readme_dir/$image_ref"
    elif [[ -f "$REPO_DIR/$image_ref" ]]; then
      source_path="$REPO_DIR/$image_ref"
    elif [[ -f "$REPO_DIR/${image_ref#./}" ]]; then
      source_path="$REPO_DIR/${image_ref#./}"
    fi

    [[ -n "$source_path" ]] || continue

    source_path="$(cd "$(dirname "$source_path")" && pwd)/$(basename "$source_path")"

    # De-duplicate per absolute source path.
    already_seen=false
    for seen in "${normalized_seen[@]}"; do
      if [[ "$seen" == "$source_path" ]]; then
        already_seen=true
        break
      fi
    done
    if [[ "$already_seen" == false ]]; then
      normalized_seen+=("$source_path")
    fi

    dest_name="$(basename "$source_path")"
    dest_path="$ENTRY_IMAGES_DIR/$dest_name"

    if [[ -e "$dest_path" ]] && ! cmp -s "$source_path" "$dest_path"; then
      # Handle basename collisions deterministically.
      suffix=2
      stem="${dest_name%.*}"
      ext="${dest_name##*.}"
      if [[ "$stem" == "$dest_name" ]]; then
        ext=""
      fi
      while :; do
        if [[ -n "$ext" ]]; then
          candidate="${stem}-${suffix}.${ext}"
        else
          candidate="${stem}-${suffix}"
        fi
        if [[ ! -e "$ENTRY_IMAGES_DIR/$candidate" ]]; then
          dest_name="$candidate"
          dest_path="$ENTRY_IMAGES_DIR/$dest_name"
          break
        fi
        suffix=$((suffix + 1))
      done
    fi

    if [[ ! -e "$dest_path" ]]; then
      cp "$source_path" "$dest_path"
    fi

    copied_rel="$ENTRY_REL/images/$dest_name"
    present=false
    for existing_rel in "${COPIED_IMAGE_RELS[@]}"; do
      if [[ "$existing_rel" == "$copied_rel" ]]; then
        present=true
        break
      fi
    done
    if [[ "$present" == false ]]; then
      COPIED_IMAGE_RELS+=("$copied_rel")
    fi

    entry_readme_content="${entry_readme_content//${image_ref}/./images/$dest_name}"
  done

  # Normalize accidental duplicate relative prefixes after substitutions.
  entry_readme_content="${entry_readme_content//.\/.\/images\//.\/images\/}"
  write_file "$ENTRY_DIR/README.md" "$entry_readme_content"
fi

captured_at="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
source_commit="$(git -C "$REPO_DIR" log -n 1 --pretty=format:%h -- "$SOURCE_README" 2>/dev/null || true)"
if [[ -z "$source_commit" ]]; then
  source_commit="$(git -C "$REPO_DIR" rev-parse --short HEAD 2>/dev/null || echo "unknown")"
fi

meta_content=""
meta_content+="id: \"$(yaml_escape "$ID")\""$'\n'
meta_content+="title: \"$(yaml_escape "$TITLE")\""$'\n'
meta_content+="captured_at: \"$(yaml_escape "$captured_at")\""$'\n'
meta_content+="source_readme_path: \"$(yaml_escape "$(relative_to_repo "$SOURCE_README")")\""$'\n'
meta_content+="source_commit: \"$(yaml_escape "$source_commit")\""$'\n'
meta_content+="date_label: \"$(yaml_escape "$DATE_LABEL")\""$'\n'
meta_content+="date_start: \"$(yaml_escape "$DATE_START")\""$'\n'
meta_content+="date_end: \"$(yaml_escape "$DATE_END")\""$'\n'
meta_content+="summary: \"$(yaml_escape "$SUMMARY")\""$'\n'
meta_content+="tools_highlights:"$'\n'
for tool in "${TOOLS[@]}"; do
  meta_content+="  - \"$(yaml_escape "$tool")\""$'\n'
done
meta_content+="images:"$'\n'
for copied_rel in "${COPIED_IMAGE_RELS[@]}"; do
  meta_content+="  - \"$(yaml_escape "$copied_rel")\""$'\n'
done
meta_content+="notes: \"\""$'\n'

write_file "$ENTRY_DIR/meta.yaml" "$meta_content"

# Phase 2: Rebuild index.yaml with this entry first (newest-first ordering by
# insertion), preserving prior entries except a replaced id.
existing_entries=""
if [[ -f "$INDEX_YAML" ]]; then
  if grep -q "^  - id: \"${ID}\"$" "$INDEX_YAML" && [[ "$FORCE" != true ]]; then
    die "id already present in $INDEX_YAML: $ID"
  fi

  existing_entries="$(awk -v target="$ID" '
    /^entries:/ { in_entries=1; next }
    !in_entries { next }
    /^  - id: "/ {
      current = $0
      sub(/^  - id: "/, "", current)
      sub(/"$/, "", current)
      if (current == target) {
        skip = 1
        next
      }
      if (skip == 1) {
        skip = 0
      }
    }
    skip == 1 { next }
    { print }
  ' "$INDEX_YAML")"
fi

index_entry_block=""
index_entry_block+="  - id: \"$(yaml_escape "$ID")\""$'\n'
index_entry_block+="    title: \"$(yaml_escape "$TITLE")\""$'\n'
index_entry_block+="    date_label: \"$(yaml_escape "$DATE_LABEL")\""$'\n'
index_entry_block+="    date_start: \"$(yaml_escape "$DATE_START")\""$'\n'
index_entry_block+="    date_end: \"$(yaml_escape "$DATE_END")\""$'\n'
index_entry_block+="    summary: \"$(yaml_escape "$SUMMARY")\""$'\n'
index_entry_block+="    tools_highlights:"$'\n'
for tool in "${TOOLS[@]}"; do
  index_entry_block+="      - \"$(yaml_escape "$tool")\""$'\n'
done
index_entry_block+="    entry_readme: \"$(yaml_escape "$ENTRY_README_REL")\""$'\n'
index_entry_block+="    preview_images:"$'\n'
for copied_rel in "${COPIED_IMAGE_RELS[@]}"; do
  index_entry_block+="      - \"$(yaml_escape "$copied_rel")\""$'\n'
done

index_content=""
index_content+="version: 1"$'\n'
index_content+="entries:"$'\n'
index_content+="$index_entry_block"
if [[ -n "$(printf '%s' "$existing_entries" | tr -d '[:space:]')" ]]; then
  index_content+="$existing_entries"$'\n'
fi

write_file "$INDEX_YAML" "$index_content"

# Phase 3: Regenerate human-facing archive pages from index metadata.
entries_tsv="$(index_entries_tsv "$index_content")"
index_md_content="$(build_index_markdown "$entries_tsv")"
write_file "$INDEX_MD" "$index_md_content"

# Phase 4: Regenerate the root README archive block between markers.
archive_block="$(build_readme_archive_block "$entries_tsv")"
replace_or_append_archive_block "$archive_block"

log "Snapshot complete: $ID"
if [[ "$DRY_RUN" == true ]]; then
  log "Dry run completed with no file modifications."
fi
