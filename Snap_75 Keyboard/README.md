# SNAP 75 QMK Build Guide

This folder contains your custom QMK build flow for the Nullbits SNAP RP2040.

## What this custom firmware includes

- VIA-compatible keymap generated from your JSON backup (`via2json`).
- Tap/hold tuning with configurable `TAPPING_TERM`.
- Quote mod-tap interrupt guard for faster `"I'm"` typing.
- Layer RGB behavior:
  - Layer 0: turquoise breathing
  - Layer 1: blue breathing
  - Layer 2: green breathing
  - Layer 3: solid cyan
- Home-row anti-roll mods on base layers (0 and 3), enabled by default:
  - Hold `D` -> Left Option (`LALT`)
  - Hold `F` -> Left Control (`LCTL`)
  - Uses a longer per-key tapping term for `D/F` (`global + 300ms`) to reduce accidental modifiers
  - Uses per-key interrupt handling (`IGNORE_MOD_TAP_INTERRUPT` / no permissive-hold / no hold-on-other-key-press) to favor taps during fast rolls
- Encoder behavior:
  - Left encoder: volume up/down
  - Right encoder: clockwise = next track, counterclockwise = previous track
  - Right encoder press: play/pause (firmware override on keycode `KC_HOME`)
- OLED behavior:
  - Left OLED: reactive bongo cat
  - Right OLED: GIF carousel (all frames embedded; selected GIF loops until cycled)
  - Right GIF animation speeds up reactively while typing / high WPM
  - Key mapped as `PgDn` cycles to next GIF immediately
- Idle sleep behavior:
  - After 15 minutes of no key/encoder activity, RGB and both OLEDs auto-turn off
  - Next keypress or encoder action wakes them immediately

## Requirements

- `qmk` CLI
- `jq`
- `python3`
- ImageMagick `magick` (required for GIF conversion when `--layer-rgb` is used)

## Key files

- Build script: `build_snap.sh`
- Source keymap JSON (default): `current_3-8-26.json`
- GIF input folder: `OledImages/`
- Intermediate artifacts: `build/`
- Final firmware output: workspace root (`*.uf2`)

## Quick start

```bash
./build_snap.sh --layer-rgb --df-mods -t 600 --profile dom-main --prune-old --keep 4
```

This compiles firmware, emits a descriptive filename, and prunes old generated artifacts.

## How compilation works

1. Reads your VIA backup JSON (`--input`).
2. Converts it to QMK JSON with `qmk via2json`.
3. Patches keys/config via `jq`:
   - `RESET -> QK_BOOT`
   - tapping term
   - optional retro tapping
   - optional configured anti-roll mod-taps on base layers
4. If `--layer-rgb` is enabled:
   - Converts JSON to `keymap.c` (`qmk json2c`)
   - Injects custom RGB, encoder, tap/hold, OLED, and bongo/GIF logic
   - Converts all GIF frames from `OledImages/` to OLED frame arrays (`oled_images.h`)
5. Compiles with `qmk compile`.
6. Copies final UF2 into this folder with descriptive naming.
7. If `--prune-old` is enabled, deletes older generated UF2/build artifacts.

### Important: first boot after firmware logic updates

This firmware includes a one-time VIA migration reset (`dynamic_keymap_reset`) when the internal layout version changes.
That ensures new compiled defaults (such as `D/F` home-row mods and encoder defaults) are actually applied.
After that one reset, VIA edits persist normally again.

## Output filename format

Generated UF2 names are now descriptive:

`snap75rp2040_km-<keymap>_in-<input>_tt<term>_<retro>_<layermode>_<dfmods>_gif<count>f<frames>_p-<profile>_<timestamp>.uf2`

Example:

`snap75rp2040_km-dom_snap_layer_rgb_dfmods_in-current_3-8-26_tt600_noretro_rgb_dfmods_gif5f562_p-dom-main_20260308-230000.uf2`

## Tapping speed adjustments

- Set tapping term with `-t` / `--tapping-term`:

```bash
./build_snap.sh --layer-rgb --df-mods -t 650
```

Guidance:
- Larger value = easier holds, fewer accidental layer taps.
- Smaller value = faster tap activation.
- Start around `600` and adjust in 25-50ms steps.
- Note: anti-roll mods are enabled by default; use `--no-df-mods` to disable.
- With anti-roll mods enabled, `D` and `F` currently use `TAPPING_TERM + 300ms`.

## Idle sleep timeout

- Current default idle timeout is 15 minutes (`900000ms`).
- Implemented in generated firmware as `SNAP_IDLE_TIMEOUT_MS`, and `OLED_TIMEOUT` is tied to the same value.
- To change it, edit `IDLE_SLEEP_TIMEOUT_MS` near the top of `build_snap.sh`, then rebuild.

## Anti-roll mod-tap behavior (D/F)

Current anti-roll profile for `D` and `F`:
- `D` and `F` are converted to mod-tap keys (`MT`) on layers 0 and 3 by default.
- Per-key tapping term is longer: `TAPPING_TERM + 300ms`.
- `IGNORE_MOD_TAP_INTERRUPT` is enabled for those keys (tap is favored during fast rolls).
- `PERMISSIVE_HOLD` is disabled for those keys.
- `HOLD_ON_OTHER_KEY_PRESS` is disabled for those keys.

Practical effect:
- Fast rolling words like `for`/`ford` should stay taps more reliably.
- Hold behavior still works, but requires a cleaner intentional hold.

## Add new anti-roll modifier keys

Now this is one-place config. Edit only `ANTIROLL_MODS` near the top of `build_snap.sh`.

Example:

```bash
ANTIROLL_MODS=(
  "MOD_LALT:KC_D"
  "MOD_LCTL:KC_F"
  "MOD_RALT:KC_J"
)
```

Then rebuild and flash both halves:

```bash
./build_snap.sh --layer-rgb --df-mods -t 600 --profile your-tag
```

Or use default anti-roll settings (no `--df-mods` flag needed):

```bash
./build_snap.sh --layer-rgb -t 600 --profile your-tag
```

Notes:
- Supported modifiers include `MOD_LCTL`, `MOD_LSFT`, `MOD_LALT`, `MOD_LGUI`, `MOD_RCTL`, `MOD_RSFT`, `MOD_RALT`, `MOD_RGUI`.
- The list drives all anti-roll behavior automatically:
  - key conversion (`KC_*` -> `MT(MOD_*,KC_*)`)
  - per-key tap term extension
  - interrupt/hold tuning hooks
- By default these mods apply on layers 0 and 3; if you only want one layer, edit the `jq` layer patch section.

## Adding new GIFs

1. Drop GIF files into `OledImages/`.
2. Re-run build script.
3. Script automatically:
   - Finds supported files (`.gif`, `.png`, `.jpg`, `.jpeg`, `.bmp`)
   - Sorts by filename
   - Converts and embeds all frames
Notes:
- GIF order follows alphabetical filename order.
- If no images are found, a blank fallback frame is generated.
- Right OLED uses physical right side; left stays bongo.
- Selected GIF loops forever; press `PgDn` to switch to the next GIF.

## VIA vs recompiling

### What VIA can change live (no reflash)

- Normal key remaps, layers, and many standard keycodes.
- These are stored in keyboard EEPROM and can be changed instantly in VIA.

### What VIA cannot change

These are compiled firmware behaviors and require rebuilding + flashing a new UF2:

- OLED GIF/bongo rendering logic
- Encoder action logic
- Tap-hold algorithm behavior (`get_*` QMK hook functions)
- Idle sleep timeout behavior for RGB/OLED auto-off
- Per-layer RGB behavior in custom C hooks
- Firmware overrides (for example: cycle GIF on `PgDn` and play/pause on encoder-press `Home`)

### Why VIA still shows `PgDn` and `Home`

- GIF cycling is a firmware override on `KC_PGDN`.
- Right encoder press play/pause is a firmware override on `KC_HOME`.
- VIA shows stored keycodes, not custom override behavior.
- If you remap those keys away from `PgDn`/`Home` in VIA, those overrides stop.

### Recommended editing workflow

1. Use VIA for quick normal remaps.
2. Export/update your VIA JSON backup.
3. Re-run `build_snap.sh` when changing firmware-level behavior.
4. Flash both halves with the new UF2.

## Troubleshooting

- D/F hold mods do not trigger:
  - Confirm firmware was not built with `--no-df-mods`.
  - In VIA, verify those keys are still `D`/`F` on your base layer (not remapped away).
- Right encoder not skipping tracks:
  - Verify media keys work on host OS.
  - Reflash both halves (encoder behavior is firmware-side).
- GIF cycle key not working:
  - Keep that key as `PgDn` in VIA so firmware override can apply.
- Right encoder press play/pause not working:
  - Keep right encoder press key as `Home` in VIA so firmware override can apply.

## Script arguments

- `-i, --input <file>`: VIA backup JSON (default `current_3-8-26.json`)
- `-t, --tapping-term <ms>`: global tapping term (default `600`)
- `--retro` / `--no-retro`: toggle retro tapping
- `--layer-rgb` / `--no-layer-rgb`: toggle RGB + OLED custom path
- `--df-mods` / `--no-df-mods`: toggle configured anti-roll mod-taps (default: enabled)
- `--profile <name>`: add an identifying tag to output filename
- `--prune-old`: remove older generated artifacts after successful build
- `--keep <n>`: number of generated UF2 files to keep when pruning (default `5`)
- `-k, --keymap <name>`: base keymap name for generated QMK keymap
- `-h, --help`: show usage

## Flashing (both halves)

You must flash **both** SNAP halves (each half has its own MCU):

1. Unplug USB-C from the half you want to flash.
2. Hold that half's reset button.
3. While holding reset, plug that MCU into your laptop.
4. A drive appears in Finder (RP2040 boot drive).
5. Drag and drop the UF2 onto that drive.
6. The drive disappears when flashing completes.
7. Repeat for the other half.

## Cleanup tips

- Use pruning on each build:

```bash
./build_snap.sh --layer-rgb --df-mods -t 600 --prune-old --keep 4
```

- Manual cleanup (if needed):
  - Delete older generated UF2 files with prefix `snap75rp2040_`
  - Delete stale files in `build/`
