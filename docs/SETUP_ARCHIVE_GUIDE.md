# Setup Archive Guide

This guide explains how to maintain:

1. The **current setup showcase** in `/Users/dom/.dotfiles/README.md`
2. The **historical archive** in `/Users/dom/.dotfiles/docs/setup-archive/`

It is written for both humans and LLM agents.

## Purpose

Keep your root `README.md` focused on what you use **now**, while preserving old eras (README + images) as immutable snapshots.

## Architecture

- Current showcase images:
  - `/Users/dom/.dotfiles/photos/current/hero-1.png`
  - `/Users/dom/.dotfiles/photos/current/hero-2.png`
  - `/Users/dom/.dotfiles/photos/current/hero-3.png`
- Archive index metadata:
  - `/Users/dom/.dotfiles/docs/setup-archive/index.yaml`
- Archive landing page:
  - `/Users/dom/.dotfiles/docs/setup-archive/INDEX.md`
- Per-era snapshots:
  - `/Users/dom/.dotfiles/docs/setup-archive/entries/<id>/README.md`
  - `/Users/dom/.dotfiles/docs/setup-archive/entries/<id>/meta.yaml`
  - `/Users/dom/.dotfiles/docs/setup-archive/entries/<id>/images/*`
- Snapshot script:
  - `/Users/dom/.dotfiles/scripts/archive_setup_snapshot.zsh`

## Dotbot Relationship

This archive system is a **docs/content workflow**, not a symlink-management workflow.

- Dotbot still manages machine setup via:
  - `/Users/dom/.dotfiles/install`
  - `/Users/dom/.dotfiles/install.config.yaml`
- Archive workflow is independent and only updates docs/media/metadata.

## Current Setup Image Workflow (Human)

When you refresh your current setup visuals:

1. Replace files in:
   - `/Users/dom/.dotfiles/photos/current/hero-1.png`
   - `/Users/dom/.dotfiles/photos/current/hero-2.png`
   - `/Users/dom/.dotfiles/photos/current/hero-3.png`
2. Update root `README.md` copy if needed.
3. Commit those changes.

Do not rename `hero-1/2/3` unless you also update script defaults.

## Archive Current Setup (Human)

Run:

```bash
/Users/dom/.dotfiles/scripts/archive_setup_snapshot.zsh \
  --id <yyyy-slug> \
  --title "<Era Title>" \
  --date-label "<Human Date Label>" \
  --date-start YYYY-MM-DD \
  --date-end YYYY-MM-DD \
  --summary "<One sentence summary>" \
  --tools "Tool A,Tool B,Tool C"
```

Notes:

- `--date-start` and `--date-end` are optional.
- Default source README is `/Users/dom/.dotfiles/README.md`.
- Default source images are the three current hero images.
- Use `--dry-run` first to preview.
- Use `--force` only when intentionally replacing an existing entry id.

## Canonical LLM Command Template

```bash
/Users/dom/.dotfiles/scripts/archive_setup_snapshot.zsh \
  --id "{{entry_id}}" \
  --title "{{entry_title}}" \
  --date-label "{{date_label}}" \
  --date-start "{{date_start_or_empty}}" \
  --date-end "{{date_end_or_empty}}" \
  --summary "{{summary}}" \
  --tools "{{comma_separated_tools}}" \
  --source-readme "/Users/dom/.dotfiles/README.md" \
  --source-images "/Users/dom/.dotfiles/photos/current/hero-1.png,/Users/dom/.dotfiles/photos/current/hero-2.png,/Users/dom/.dotfiles/photos/current/hero-3.png"
```

## LLM Required-Input Checklist

Before running any snapshot command, the LLM must collect:

1. `id` (lowercase + dashes, unique)
2. `title`
3. `date-label`
4. `summary` (single sentence)
5. `tools` list (comma-separated)
6. Source README path (default accepted or explicit override)
7. Source image paths (default accepted or explicit override)
8. Whether to run `--dry-run` first
9. Whether overwrite is intended (`--force`)

## LLM Natural Language Mapping (“If user asks X, do Y”)

- User says: “Archive current setup now”
  - LLM action: gather missing metadata, run `--dry-run`, confirm, then run real command.
- User says: “Update current setup images”
  - LLM action: replace files under `/Users/dom/.dotfiles/photos/current/hero-*.png`; do not modify archive entries.
- User says: “Refresh archive previews in README”
  - LLM action: run snapshot only when creating/updating an entry; script auto-regenerates README archive block.
- User says: “Fix an archived entry”
  - LLM action: rerun snapshot with same `--id` and `--force`, using explicit `--source-readme`/`--source-images`.

## Deterministic Procedure: Archive Current Setup Now

1. Verify source files exist:
   - `/Users/dom/.dotfiles/README.md`
   - `/Users/dom/.dotfiles/photos/current/hero-1.png`
   - `/Users/dom/.dotfiles/photos/current/hero-2.png`
   - `/Users/dom/.dotfiles/photos/current/hero-3.png`
2. Run script with `--dry-run`.
3. Review planned operations.
4. Run script without `--dry-run`.
5. Validate:
   - Entry folder created under `docs/setup-archive/entries/<id>/`
   - `index.yaml` updated
   - `INDEX.md` updated
   - Root `README.md` archive block updated

## Deterministic Procedure: Update Current Setup Images

1. Replace files in `/Users/dom/.dotfiles/photos/current/` with new screenshots.
2. Keep names stable: `hero-1.png`, `hero-2.png`, `hero-3.png`.
3. Verify root README renders new images.
4. Commit image and README changes.

## Deterministic Procedure: Refresh Archive Previews in README

1. Ensure desired archive entry data exists in `index.yaml`.
2. Run snapshot command for that entry (optionally `--force`).
3. Confirm root README archive block was regenerated between markers:
   - `<!-- SETUP_ARCHIVE_START -->`
   - `<!-- SETUP_ARCHIVE_END -->`

## Ad Hoc Validation (No Test Files)

Use this checklist:

1. `--dry-run` logs expected operations only.
2. Real run creates expected entry files.
3. Root README has exactly one archive marker block.
4. Archive links and images resolve.
5. `git status` shows expected files only.
6. No new test files are tracked.

## Error Handling

- Duplicate id:
  - Use a new id or rerun with `--force`.
- Missing image path:
  - Fix source paths and retry.
- Bad id format:
  - Use lowercase letters, numbers, and dashes only.

## Do Not Touch (Safety)

Do not modify these when doing archive-only tasks:

- Sensitive/auth files:
  - `/Users/dom/.dotfiles/config/gh/hosts.yml`
  - `/Users/dom/.dotfiles/config/msmtp/config`
  - `/Users/dom/.dotfiles/ssh/id_*`
- Dotbot config unless requested:
  - `/Users/dom/.dotfiles/install`
  - `/Users/dom/.dotfiles/install.config.yaml`
- Historical entry files unless explicitly editing an existing archive snapshot.
