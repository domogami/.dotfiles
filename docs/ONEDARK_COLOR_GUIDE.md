# OneDark Color Guide

Central reference for OneDark colors used across this dotfiles repo.

## Canonical Atom OneDark Palette

### Neutrals

- `#282C34` `background`
- `#21252B` `background_alt`
- `#2C313C` `surface_1`
- `#353B45` `surface_2`
- `#3E4451` `surface_3`
- `#ABB2BF` `foreground`
- `#818896` `foreground_dim`
- `#5C6370` `comment_muted`

### Accents

- `#E06C75` `red`
- `#BE5046` `red_alt`
- `#D19A66` `orange`
- `#E5C07B` `yellow`
- `#98C379` `green`
- `#56B6C2` `cyan`
- `#61AFEF` `blue`
- `#C678DD` `purple`

## Kiro CLI Autocomplete Theme

Kiro CLI currently supports theme names from `kiro-cli theme --list` and does not ship a literal `one-dark` name.

Closest built-in preset to OneDark is `plastic` (from `/Applications/Kiro CLI.app/Contents/Resources/themes/plastic.json`):

- `#21252B` `backgroundColor`
- `#A9B2C3` `textColor`
- `#5F6672` `matchBackgroundColor`
- `#E9D16C` `selection.backgroundColor`
- `#1085FF` `description.textColor`

Apply it:

```bash
~/.local/bin/kiro-cli theme plastic
```

Check current value:

```bash
~/.local/bin/kiro-cli theme
```

## Repo OneDark Variants In Use

These are also present in your current OneDark-ish configs:

- `#1E2127` `nushell_background`
- `#FFFEFE` `nushell_custom_text`
- `#181819` `sketchybar_black`
- `#E2E2E3` `sketchybar_white`
- `#FC5D7C` `sketchybar_red`
- `#9ED072` `sketchybar_green`
- `#76CCE0` `sketchybar_blue`
- `#E7C664` `sketchybar_yellow`
- `#F39660` `sketchybar_orange`
- `#B39DF3` `sketchybar_magenta`
- `#7F8490` `sketchybar_grey`

## Copy/Paste Tokens

```css
:root {
  --onedark-bg: #282c34;
  --onedark-bg-alt: #21252b;
  --onedark-surface-1: #2c313c;
  --onedark-surface-2: #353b45;
  --onedark-surface-3: #3e4451;
  --onedark-fg: #abb2bf;
  --onedark-fg-dim: #818896;
  --onedark-muted: #5c6370;
  --onedark-red: #e06c75;
  --onedark-red-alt: #be5046;
  --onedark-orange: #d19a66;
  --onedark-yellow: #e5c07b;
  --onedark-green: #98c379;
  --onedark-cyan: #56b6c2;
  --onedark-blue: #61afef;
  --onedark-purple: #c678dd;
}
```
