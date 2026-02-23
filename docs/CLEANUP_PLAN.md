# Dotfiles Cleanup Plan

## Phase 1: Security Baseline (Do First)

- Keep credentials/local auth state untracked (done via `.gitignore`)
- Rotate GitHub token and SSH key
- Migrate `~/.ssh` out of full-directory symlink
- Stop linking full `~/.ssh` in Dotbot (link only `~/.ssh/config`)

## Phase 2: Reduce Drift Surface

Current largest drift areas are under `config/`:

- `config/99 - Archive`
- `config/spicetify`
- `config/raycast`
- `config/StardewValley`

Action:

- Move personal archives and app exports to a separate non-dotfiles backup repo or local backup dir
- Keep this repo focused on reproducible config only

## Phase 3: Split Managed vs Local Config

Instead of linking the entire `~/.config`, migrate to explicit app-level links:

- Keep: `nvim`, `yazi`, `kitty`, `sketchybar`, `aerospace`, `karabiner`, `gh/config.yml`
- Ignore/local-only: auth/session/log/cache/generated files (`hosts.yml`, tokens, logs, backups)

## Phase 4: Obsidian Settings Tracking

Use repo path:

- `obsidian/dom-2nd-brain/.obsidian`

Use script:

- `./scripts/obsidian_settings.zsh snapshot`
- `./scripts/obsidian_settings.zsh link`
- `./scripts/obsidian_settings.zsh status`

This tracks only selected `.obsidian` settings and snippets, not vault notes.

## Phase 5: Ongoing Hygiene

- Before pushing: run the checks in `SECURITY.md`
- Prefer small, focused commits by area (`shell`, `windowing`, `nvim`, etc.)
- Update `README.md` and this plan when setup changes materially
