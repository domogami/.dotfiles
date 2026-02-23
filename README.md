# Dom's Dotfiles

Personal macOS dotfiles managed with Dotbot.

![Current setup hero 1](./photos/current/hero-1.png)
![Current setup hero 2](./photos/current/hero-2.png)
![Current setup hero 3](./photos/current/hero-3.png)

## Installation

```bash
git clone https://github.com/domogami/.dotfiles.git
cd .dotfiles
./install
```

The installer config lives in `install.config.yaml`.

### Install Modes

`./install` supports optional Homebrew package install from `Brewfile`.

- Dotfiles only (skip brew):

```bash
./install --without-brew
```

- Dotfiles + Brewfile packages:

```bash
./install --with-brew
```

- Preview only (no writes):

```bash
./install --dry-run --without-brew
./install --dry-run --with-brew
```

- Verify repo/install health only (no writes):

```bash
./install --verify
```

- Non-interactive env flag (CI/script-friendly):

```bash
DOTFILES_INSTALL_BREW=1 ./install
DOTFILES_INSTALL_BREW=0 ./install
```

### Validation and Safety

- Run health checks directly:

```bash
./scripts/dotfiles_health_check.zsh
./scripts/dotfiles_health_check.zsh --strict
```

- Pre-commit secret scanning uses `gitleaks` via `.githooks/pre-commit`.
- `./install` configures `core.hooksPath=.githooks` automatically.

## Current Stack

### Shell and Terminal

- iTerm2 is my primary terminal.
- Zsh + Oh My Zsh + Starship for shell UX.
- Kiro CLI shell integration for autocomplete and terminal AI helpers.
- Atuin, Zoxide, FZF, and eza for history and navigation.

### Window Management and UI

- AeroSpace + Karabiner power my keyboard-first window management.
- SketchyBar + SketchyBorders provide workspace and window visuals.
- NotchNook is part utility, part fun.
- Yabai + SKHD are still kept as legacy configs in this repo.

### Editor and Navigation

- Neovim (LazyVim-based setup) + Neovide for editing.
- Yazi for terminal file management.

### Search and Launcher

- Raycast is my launcher/search workflow and Alfred replacement.

### Notes and Publishing

- Obsidian is my note-taking system.
- Quartz powers publishing for my notes: [Quartz](https://quartz.jzhao.xyz/).
- My site is [Dom's Digital Garden 🪴](https://domogami.github.io/).
- Publish pipeline repo: [domogami.github.io](https://github.com/domogami/domogami.github.io).
- Raycast publish commands are tracked in this repo: `config/raycast/quartz-build.sh` and `config/raycast/quartz-publish.sh`.
- Dotfiles publish command is tracked here: `config/raycast/dotfiles-publish.sh` (search `publish dotfiles` in Raycast).
- Dotfiles publish command always runs `scripts/dotfiles_health_check.zsh --strict` before commit/push.
- Install/link those Raycast commands with `scripts/install_raycast_commands.zsh`.

### AI Workflow

- Preferred coding model: Codex 5.3 Extra High.

### Core Dotfiles Tooling

- Dotbot (`./install`, `install.config.yaml`)
- Homebrew bootstrap script (`scripts/setup_homebrew.zsh`)
- Obsidian settings sync helper (`scripts/obsidian_settings.zsh`)

## Repository Guides

- Security notes: `SECURITY.md`
- Setup archive operations (human + LLM): `docs/SETUP_ARCHIVE_GUIDE.md`
- Cleanup roadmap: `docs/CLEANUP_PLAN.md`
- OneDark palette reference: `docs/ONEDARK_COLOR_GUIDE.md`

<!-- SETUP_ARCHIVE_START -->
## Past Setups

Snapshots of previous setup eras, with archived README content and images.

### OneDark Rice Era 2022

![OneDark Rice Era 2022 preview](./docs/setup-archive/entries/2022-onedark-rice/images/photo1.png)

_April-September 2022_

OneDark-themed macOS rice centered on Yabai, SKHD, Karabiner, and terminal-driven workflows.

Highlights: Dotbot, Yabai, SKHD, Karabiner, Oh My Zsh, LunarVim, iTerm2

[View archived setup](./docs/setup-archive/entries/2022-onedark-rice/README.md)

[Browse all setup archives](./docs/setup-archive/INDEX.md)
<!-- SETUP_ARCHIVE_END -->
