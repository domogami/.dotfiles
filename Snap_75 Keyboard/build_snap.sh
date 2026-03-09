#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'EOF'
Build SNAP RP2040 firmware from a VIA backup JSON.

Usage:
  ./build_snap.sh [options]

Options:
  -i, --input <file>         VIA backup JSON input file
                             (default: current_3-8-26.json)
  -t, --tapping-term <ms>    Global tapping term in ms (default: 600)
  --retro                    Enable retro tapping
  --no-retro                 Disable retro tapping (default)
  --layer-rgb                Enable per-layer RGB + breathing
                             (L0=turquoise breathing, L1=blue breathing,
                              L2=green breathing, L3=solid cyan)
  --no-layer-rgb             Disable per-layer RGB + breathing (default)
  --df-mods                  Enable configured anti-roll home-row mods (default)
                             (configured in ANTIROLL_MODS below)
  --no-df-mods               Disable configured anti-roll home-row mods
  --profile <name>           Optional short tag added to output filename
  --prune-old                Remove older generated UF2/build artifacts
                             after a successful build
  --keep <n>                 Keep newest <n> generated UF2 files when pruning
                             (default: 5)
  -k, --keymap <name>        Output keymap name for QMK (default: dom_snap)
  -h, --help                 Show this help

Examples:
  ./build_snap.sh
  ./build_snap.sh --input April11Snap.json --tapping-term 600
  ./build_snap.sh --retro
  ./build_snap.sh --layer-rgb --df-mods --profile dom-main --prune-old --keep 4
EOF
}

slugify() {
  local raw="$1"
  raw="$(printf '%s' "$raw" | tr '[:upper:]' '[:lower:]')"
  raw="$(printf '%s' "$raw" | tr -cs 'a-z0-9._-' '-')"
  raw="${raw#-}"
  raw="${raw%-}"
  if [[ -z "$raw" ]]; then
    raw="build"
  fi
  printf '%s' "$raw"
}

trim_build_dir() {
  local build_dir="$1"
  local keep_count="$2"
  mapfile -t old_build_files < <(find "$build_dir" -maxdepth 1 -type f | sort)
  if [[ "${#old_build_files[@]}" -le "$keep_count" ]]; then
    return 0
  fi
  for old_file in "${old_build_files[@]:0:${#old_build_files[@]}-keep_count}"; do
    rm -f "$old_file"
  done
}

prune_uf2_outputs() {
  local output_dir="$1"
  local keep_count="$2"
  mapfile -t generated_uf2s < <(find "$output_dir" -maxdepth 1 -type f -name 'snap75rp2040_*.uf2' | sort)
  if [[ "${#generated_uf2s[@]}" -le "$keep_count" ]]; then
    return 0
  fi
  for old_uf2 in "${generated_uf2s[@]:0:${#generated_uf2s[@]}-keep_count}"; do
    rm -f "$old_uf2"
  done
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INPUT_FILE="current_3-8-26.json"
TAPPING_TERM="600"
RETRO="false"
LAYER_RGB="false"
DF_MODS="true"
KEYBOARD="nullbitsco/snap/rp2040"
LAYOUT="LAYOUT_all"
KEYMAP="dom_snap"
PROFILE=""
PRUNE_OLD="false"
KEEP_COUNT="5"

# One-place anti-roll mod-tap configuration.
# Format: "MOD_*:KC_*" (mod on hold, key on tap).
ANTIROLL_MODS=(
  "MOD_LALT:KC_D"
  "MOD_LCTL:KC_F"
)
ANTIROLL_TAP_TERM_EXTRA_MS="300"

while [[ $# -gt 0 ]]; do
  case "$1" in
    -i|--input)
      INPUT_FILE="${2:-}"
      shift 2
      ;;
    -t|--tapping-term)
      TAPPING_TERM="${2:-}"
      shift 2
      ;;
    --retro)
      RETRO="true"
      shift
      ;;
    --no-retro)
      RETRO="false"
      shift
      ;;
    --layer-rgb)
      LAYER_RGB="true"
      shift
      ;;
    --no-layer-rgb)
      LAYER_RGB="false"
      shift
      ;;
    --df-mods)
      DF_MODS="true"
      shift
      ;;
    --no-df-mods)
      DF_MODS="false"
      shift
      ;;
    --profile)
      PROFILE="${2:-}"
      shift 2
      ;;
    --prune-old)
      PRUNE_OLD="true"
      shift
      ;;
    --keep)
      KEEP_COUNT="${2:-}"
      shift 2
      ;;
    -k|--keymap)
      KEYMAP="${2:-}"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      exit 1
      ;;
  esac
done

if ! [[ "$TAPPING_TERM" =~ ^[0-9]+$ ]]; then
  echo "Invalid tapping term: $TAPPING_TERM (must be an integer)." >&2
  exit 1
fi

if ! [[ "$KEEP_COUNT" =~ ^[0-9]+$ ]] || [[ "$KEEP_COUNT" -lt 1 ]]; then
  echo "Invalid keep count: $KEEP_COUNT (must be an integer >= 1)." >&2
  exit 1
fi

if ! command -v qmk >/dev/null 2>&1; then
  echo "qmk CLI is not installed or not in PATH." >&2
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "jq is required but not found in PATH." >&2
  exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "python3 is required but not found in PATH." >&2
  exit 1
fi

if [[ "$INPUT_FILE" != /* ]]; then
  INPUT_FILE="$SCRIPT_DIR/$INPUT_FILE"
fi

if [[ ! -f "$INPUT_FILE" ]]; then
  echo "Input file not found: $INPUT_FILE" >&2
  exit 1
fi

if [[ "$LAYER_RGB" == "true" ]] && ! command -v magick >/dev/null 2>&1; then
  echo "ImageMagick 'magick' is required for OLED GIF conversion when --layer-rgb is enabled." >&2
  exit 1
fi

if [[ "${#ANTIROLL_MODS[@]}" -eq 0 ]]; then
  echo "ANTIROLL_MODS must contain at least one MOD:KEY entry." >&2
  exit 1
fi

antiroll_case_lines=""
for mod_spec in "${ANTIROLL_MODS[@]}"; do
  IFS=':' read -r mod_key tap_key <<<"$mod_spec"
  if [[ -z "${mod_key:-}" || -z "${tap_key:-}" ]]; then
    echo "Invalid ANTIROLL_MODS entry: '$mod_spec' (expected MOD_*:KC_*)." >&2
    exit 1
  fi
  antiroll_case_lines+="        case MT(${mod_key}, ${tap_key}):"$'\n'
done

dfmods_map_json="$(printf '%s\n' "${ANTIROLL_MODS[@]}" | jq -Rnc '
  [inputs
   | select(length > 0)
   | split(":")
   | {key: .[1], value: ("MT(" + .[0] + "," + .[1] + ")")}
  ] | from_entries
')"

QMK_HOME="$(qmk env | awk -F= '/^QMK_HOME=/{gsub(/"/, "", $2); print $2}')"
if [[ -z "$QMK_HOME" ]]; then
  echo "Unable to determine QMK_HOME from 'qmk env'." >&2
  exit 1
fi

BUILD_DIR="$SCRIPT_DIR/build"
mkdir -p "$BUILD_DIR"

timestamp="$(date +%Y%m%d-%H%M%S)"
input_base="$(basename "$INPUT_FILE")"
input_base="${input_base%.*}"
input_tag="$(slugify "$input_base")"
profile_tag=""
if [[ -n "$PROFILE" ]]; then
  profile_tag="$(slugify "$PROFILE")"
fi
retro_suffix=""
if [[ "$RETRO" == "true" ]]; then
  retro_suffix="_retro"
fi

converted_json="$BUILD_DIR/${input_base}.${timestamp}.via2json.keymap.json"
patched_json="$BUILD_DIR/${input_base}.tt${TAPPING_TERM}${retro_suffix}.${timestamp}.keymap.json"

echo "Converting VIA backup to QMK keymap JSON..."
qmk via2json -kb "$KEYBOARD" -l "$LAYOUT" -km "$KEYMAP" "$INPUT_FILE" -o "$converted_json"

echo "Patching keymap (RESET -> QK_BOOT, tapping config)..."
jq \
  --arg term "$TAPPING_TERM" \
  --arg retro "$RETRO" \
  --arg dfmods "$DF_MODS" \
  --argjson dfmap "$dfmods_map_json" \
  '
  def apply_dfmods($dfmap):
    map(
      if ($dfmap[.] // null) != null then $dfmap[.]
      else .
      end
    );

  .layers |= map(map(if . == "RESET" then "QK_BOOT" else . end))
  | if $dfmods == "true" then
      .layers[0] |= apply_dfmods($dfmap)
      | if (.layers | length) > 3 then
          .layers[3] |= apply_dfmods($dfmap)
        else
          .
        end
    else
      .
    end
  | .config = (.config // {})
  | .config.tapping = (.config.tapping // {})
  | .config.tapping.term = ($term | tonumber)
  | if $retro == "true" then
      .config.tapping.retro = true
    else
      .config.tapping |= with_entries(select(.key != "retro"))
    end
  ' \
  "$converted_json" > "$patched_json"

echo "Compiling firmware..."
actual_keymap="$KEYMAP"
layer_tag="plain"
dfmods_tag="stdmods"
retro_tag="noretro"
gif_count="0"
gif_frames="0"
if [[ "$RETRO" == "true" ]]; then
  retro_tag="retro"
fi
if [[ "$DF_MODS" == "true" ]]; then
  dfmods_tag="dfmods"
fi

if [[ "$LAYER_RGB" == "true" ]]; then
  layer_tag="rgb"
  generated_keymap="${KEYMAP}_layer_rgb"
  if [[ "$DF_MODS" == "true" ]]; then
    generated_keymap="${generated_keymap}_dfmods"
  fi
  generated_keymap_dir="$QMK_HOME/keyboards/nullbitsco/snap/rp2040/keymaps/$generated_keymap"
  bongo_source_dir="$QMK_HOME/keyboards/nullbitsco/snap/rp2040/keymaps/bongo_reactive"
  generated_c="$BUILD_DIR/${input_base}.${timestamp}.generated.keymap.c"
  generated_config_h="$generated_keymap_dir/config.h"
  generated_rules_mk="$generated_keymap_dir/rules.mk"
  generated_oled_header="$generated_keymap_dir/oled_images.h"
  oled_images_dir="$SCRIPT_DIR/OledImages"

  echo "Generating keymap.c for RGB layer hooks..."
  qmk json2c "$patched_json" -o "$generated_c"

  mkdir -p "$generated_keymap_dir"
  cp "$generated_c" "$generated_keymap_dir/keymap.c"
  cp "$bongo_source_dir/bongo.h" "$generated_keymap_dir/bongo.h"
  cp "$bongo_source_dir/bongo_graphics.h" "$generated_keymap_dir/bongo_graphics.h"

  echo "Generating right OLED image header from: $oled_images_dir"
  if [[ -d "$oled_images_dir" ]]; then
    mapfile -t oled_image_files < <(find "$oled_images_dir" -maxdepth 1 -type f \( -iname '*.gif' -o -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.bmp' \) | sort)
  else
    oled_image_files=()
  fi

  oled_manifest="$BUILD_DIR/${input_base}.${timestamp}.oled_images.list"
  : > "$oled_manifest"
  if [[ "${#oled_image_files[@]}" -gt 0 ]]; then
    printf '%s\n' "${oled_image_files[@]}" > "$oled_manifest"
  fi

  OLED_IMAGE_LIST_FILE="$oled_manifest" python3 - <<'PY' > "$generated_oled_header"
import os
import subprocess
import tempfile
from pathlib import Path

WIDTH = 128
HEIGHT = 32
BYTES = WIDTH * HEIGHT // 8

list_file = os.environ.get("OLED_IMAGE_LIST_FILE", "")
files = []
if list_file and os.path.exists(list_file):
    with open(list_file, "r", encoding="utf-8", errors="ignore") as f:
        files = [line.strip() for line in f if line.strip()]

def parse_p1_pbm(path: str) -> bytes:
    with open(path, "r", encoding="ascii", errors="strict") as f:
        tokens = f.read().split()
    if len(tokens) < 3 or tokens[0] != "P1":
        raise RuntimeError(f"Unexpected PBM format for {path!r}")

    w = int(tokens[1])
    h = int(tokens[2])
    pixels = [int(x) for x in tokens[3:]]
    if w != WIDTH or h != HEIGHT or len(pixels) != WIDTH * HEIGHT:
        raise RuntimeError(f"Unexpected image dimensions for {path!r}: {w}x{h}")

    # PBM P1 uses 1=black and 0=white; OLED lit pixels are treated as 1.
    buf = bytearray(BYTES)
    for page in range(HEIGHT // 8):
        for x in range(WIDTH):
            value = 0
            for bit in range(8):
                y = page * 8 + bit
                pbm = pixels[y * WIDTH + x]
                lit = 1 if pbm == 0 else 0
                value |= (lit << bit)
            buf[page * WIDTH + x] = value
    return bytes(buf)

all_frames = []
all_delays = []
gif_starts = []
gif_counts = []

for image_file in files:
    identify = subprocess.run(
        ["magick", "identify", "-format", "%T\n", image_file],
        check=True,
        capture_output=True,
        text=True,
    )
    delays = [int(x) for x in identify.stdout.split() if x.strip()]
    if not delays:
        delays = [4]

    with tempfile.TemporaryDirectory(prefix="oledgif_") as tmpdir:
        out_pattern = os.path.join(tmpdir, "frame_%04d.pbm")
        subprocess.run(
            [
                "magick",
                image_file,
                "-coalesce",
                "-resize", "128x32^",
                "-gravity", "center",
                "-extent", "128x32",
                "-colorspace", "Gray",
                "-threshold", "55%",
                "-compress", "none",
                out_pattern,
            ],
            check=True,
        )

        frame_paths = sorted(Path(tmpdir).glob("frame_*.pbm"))
        if not frame_paths:
            frame_paths = []

        start = len(all_frames)
        count = min(len(delays), len(frame_paths))
        if count == 0:
            all_frames.append(bytes([0] * BYTES))
            all_delays.append(4)
            gif_starts.append(start)
            gif_counts.append(1)
            continue

        gif_starts.append(start)
        gif_counts.append(count)
        for idx in range(count):
            all_frames.append(parse_p1_pbm(str(frame_paths[idx])))
            d = delays[idx] if delays[idx] > 0 else 4
            all_delays.append(d)

if not all_frames:
    all_frames = [bytes([0] * BYTES)]
    all_delays = [4]
    gif_starts = [0]
    gif_counts = [1]

print("#pragma once")
print("")
print(f"#define OLED_IMAGE_BYTES {BYTES}")
print(f"#define OLED_GIF_COUNT {len(gif_counts)}")
print(f"#define OLED_GIF_TOTAL_FRAMES {len(all_frames)}")
print("")
print("static const uint16_t PROGMEM oled_gif_start[OLED_GIF_COUNT] = {")
print("    " + ", ".join(str(x) for x in gif_starts) + ",")
print("};")
print("")
print("static const uint16_t PROGMEM oled_gif_frame_count[OLED_GIF_COUNT] = {")
print("    " + ", ".join(str(x) for x in gif_counts) + ",")
print("};")
print("")
print("static const uint8_t PROGMEM oled_gif_delay_cs[OLED_GIF_TOTAL_FRAMES] = {")
print("    " + ", ".join(str(x) for x in all_delays) + ",")
print("};")
print("")
print("static const char PROGMEM oled_gif_frames[OLED_GIF_TOTAL_FRAMES][OLED_IMAGE_BYTES] = {")
for frame in all_frames:
    print("    {")
    for i in range(0, BYTES, 16):
        chunk = ", ".join(f"0x{b:02X}" for b in frame[i:i + 16])
        print(f"        {chunk},")
    print("    },")
print("};")
PY

  gif_count="$(awk '/^#define OLED_GIF_COUNT/{print $3}' "$generated_oled_header" | head -n1)"
  gif_frames="$(awk '/^#define OLED_GIF_TOTAL_FRAMES/{print $3}' "$generated_oled_header" | head -n1)"
  gif_count="${gif_count:-0}"
  gif_frames="${gif_frames:-0}"

  cat >> "$generated_keymap_dir/keymap.c" <<EOF

#include "bongo.h"
#include "oled_images.h"
#ifdef VIA_ENABLE
#include "dynamic_keymap.h"
#endif

#ifdef RGBLIGHT_ENABLE
static void apply_layer_rgb(layer_state_t active_layers, layer_state_t active_defaults) {
    uint8_t layer = get_highest_layer(active_layers | active_defaults);
    switch (layer) {
        case 0:
            rgblight_mode_noeeprom(RGBLIGHT_MODE_BREATHING + 1);
            // Turquoise-ish breathing for your hold-enabled base layer.
            rgblight_sethsv_noeeprom(110, 255, 255);
            break;
        case 1:
            rgblight_mode_noeeprom(RGBLIGHT_MODE_BREATHING + 1);
            rgblight_sethsv_noeeprom(HSV_BLUE);
            break;
        case 2:
            rgblight_mode_noeeprom(RGBLIGHT_MODE_BREATHING + 1);
            rgblight_sethsv_noeeprom(HSV_GREEN);
            break;
        case 3:
            rgblight_mode_noeeprom(RGBLIGHT_MODE_STATIC_LIGHT);
            rgblight_sethsv_noeeprom(HSV_CYAN);
            break;
        default:
            rgblight_mode_noeeprom(RGBLIGHT_MODE_STATIC_LIGHT);
            rgblight_sethsv_noeeprom(HSV_WHITE);
            break;
    }
}

layer_state_t layer_state_set_user(layer_state_t state) {
    apply_layer_rgb(state, default_layer_state);
    return state;
}

layer_state_t default_layer_state_set_user(layer_state_t state) {
    apply_layer_rgb(layer_state, state);
    return state;
}

void keyboard_post_init_user(void) {
    // One-time migration: reset VIA dynamic keymap/encoder map defaults after
    // firmware logic changes, then preserve user VIA edits on later boots.
#ifdef VIA_ENABLE
    const uint32_t snap_layout_version = 20260309;
    if (eeconfig_read_user() != snap_layout_version) {
        dynamic_keymap_reset();
        eeconfig_update_user(snap_layout_version);
    }
#endif
    apply_layer_rgb(layer_state, default_layer_state);
}
#endif

#ifdef ENCODER_ENABLE
bool encoder_update_user(uint8_t index, bool clockwise) {
    if (index == 0) {
        tap_code_delay(clockwise ? KC_VOLU : KC_VOLD, 10);
    } else if (index == 1) {
        // Flipped per latest request.
        tap_code_delay(clockwise ? KC_MPRV : KC_MNXT, 10);
    }
    return false;
}
#endif

uint16_t get_tapping_term(uint16_t keycode, keyrecord_t *record) {
    (void)record;
    switch (keycode) {
        // Give configured anti-roll mod-tap keys a larger tap window.
${antiroll_case_lines}            return TAPPING_TERM + ${ANTIROLL_TAP_TERM_EXTRA_MS};
        // Keep quote mod-tap aligned with global tapping term.
        case MT(MOD_LGUI, KC_QUOT):
            return TAPPING_TERM;
        default:
            return TAPPING_TERM;
    }
}

bool get_ignore_mod_tap_interrupt(uint16_t keycode, keyrecord_t *record) {
    (void)record;
    switch (keycode) {
        // Favor taps during fast rolls for home-row mods.
${antiroll_case_lines}        // Keep quote optimized for "I'm" typing.
        case MT(MOD_LGUI, KC_QUOT):
            return true;
        default:
            return false;
    }
}

bool get_permissive_hold(uint16_t keycode, keyrecord_t *record) {
    (void)record;
    switch (keycode) {
        // Avoid converting to hold from rolling taps on these mod-tap keys.
${antiroll_case_lines}        // Keep quote conservative to avoid accidental holds while typing.
        case MT(MOD_LGUI, KC_QUOT):
            return false;
        default:
            return false;
    }
}

bool get_hold_on_other_key_press(uint16_t keycode, keyrecord_t *record) {
    (void)record;
    switch (keycode) {
        // Prevent early hold conversion on fast key rolls for anti-roll mod-taps.
${antiroll_case_lines}            return false;
        default:
            return false;
    }
}

static uint8_t current_oled_gif = 0;
static uint16_t current_oled_frame = 0;
static uint32_t oled_anim_timer = 0;
static uint32_t right_oled_last_keypress = 0;

oled_rotation_t oled_init_user(oled_rotation_t rotation) {
    if (is_keyboard_left()) {
        return OLED_ROTATION_0;
    } else {
        return OLED_ROTATION_180;
    }
}

static uint16_t active_gif_start(void) {
    return pgm_read_word(&oled_gif_start[current_oled_gif]);
}

static uint16_t active_gif_count(void) {
    uint16_t count = pgm_read_word(&oled_gif_frame_count[current_oled_gif]);
    return count == 0 ? 1 : count;
}

static uint16_t active_flat_frame(void) {
    return active_gif_start() + current_oled_frame;
}

static uint16_t active_frame_delay_ms(uint16_t frame_idx) {
    uint8_t delay_cs = pgm_read_byte(&oled_gif_delay_cs[frame_idx]);
    if (delay_cs == 0) {
        delay_cs = 4;
    }

    uint16_t delay_ms = (uint16_t)delay_cs * 10;
    if (timer_elapsed32(right_oled_last_keypress) < 1200 || get_current_wpm() > 50) {
        delay_ms /= 2;
        if (delay_ms < 20) {
            delay_ms = 20;
        }
    }
    return delay_ms;
}

static void render_right_oled_gif(void) {
    uint16_t frame_idx = active_flat_frame();
    oled_write_raw_P(oled_gif_frames[frame_idx], OLED_IMAGE_BYTES);

    if (timer_elapsed32(oled_anim_timer) >= active_frame_delay_ms(frame_idx)) {
        oled_anim_timer = timer_read32();
        current_oled_frame++;
        if (current_oled_frame >= active_gif_count()) {
            current_oled_frame = 0;
        }
    }
}

bool oled_task_user(void) {
    if (is_keyboard_left()) {
        bongo_render(0, 0);
    } else {
        render_right_oled_gif();
    }
    return true;
}

bool process_record_user(uint16_t keycode, keyrecord_t *record) {
    bongo_process_record(record);

    if (record->event.pressed) {
        right_oled_last_keypress = timer_read32();
    }

    // Right encoder press currently reports as KC_HOME in your layout.
    if (record->event.pressed && keycode == KC_HOME) {
        tap_code(KC_MPLY);
        return false;
    }

    // Keep manual GIF cycling on the key currently mapped as KC_PGDN.
    if (record->event.pressed && keycode == KC_PGDN) {
        current_oled_gif = (current_oled_gif + 1) % OLED_GIF_COUNT;
        current_oled_frame = 0;
        oled_anim_timer = timer_read32();
        return false;
    }

    return true;
}

bool should_process_keypress(void) {
    return true;
}
EOF

  cat > "$generated_rules_mk" <<'EOF'
RGBLIGHT_ENABLE = yes
OLED_ENABLE = yes
OLED_DRIVER = SSD1306
VIA_ENABLE = yes
WPM_ENABLE = yes
ENCODER_MAP_ENABLE = no
EOF

  cat > "$generated_config_h" <<EOF
#pragma once

#define OLED_BRIGHTNESS 128
#define OLED_TIMEOUT 30000
#define SPLIT_TRANSPORT_MIRROR

#define TAPPING_TERM ${TAPPING_TERM}
#define TAPPING_TERM_PER_KEY
#define IGNORE_MOD_TAP_INTERRUPT_PER_KEY
#define PERMISSIVE_HOLD_PER_KEY
#define HOLD_ON_OTHER_KEY_PRESS_PER_KEY
EOF
  if [[ "$RETRO" == "true" ]]; then
    cat >> "$generated_config_h" <<'EOF'
#define RETRO_TAPPING
EOF
  fi

  actual_keymap="$generated_keymap"
  qmk compile -kb "$KEYBOARD" -km "$actual_keymap"
else
  qmk compile "$patched_json"
fi

uf2_src="$QMK_HOME/nullbitsco_snap_rp2040_${actual_keymap}.uf2"
if [[ ! -f "$uf2_src" ]]; then
  echo "Expected UF2 not found at: $uf2_src" >&2
  exit 1
fi

uf2_name_parts=(
  "snap75rp2040"
  "km-$(slugify "$actual_keymap")"
  "in-${input_tag}"
  "tt${TAPPING_TERM}"
  "${retro_tag}"
  "${layer_tag}"
  "${dfmods_tag}"
  "gif${gif_count}f${gif_frames}"
)
if [[ -n "$profile_tag" ]]; then
  uf2_name_parts+=("p-${profile_tag}")
fi
uf2_name_parts+=("$timestamp")
uf2_name="$(IFS=_; echo "${uf2_name_parts[*]}").uf2"
uf2_out="$SCRIPT_DIR/$uf2_name"
cp "$uf2_src" "$uf2_out"

if [[ "$PRUNE_OLD" == "true" ]]; then
  prune_uf2_outputs "$SCRIPT_DIR" "$KEEP_COUNT"
  trim_build_dir "$BUILD_DIR" "$((KEEP_COUNT * 8))"
fi

cat <<EOF

Build complete.
- Input:        $INPUT_FILE
- Keymap JSON:  $patched_json
- QMK keymap:   $actual_keymap
- Profile tag:  ${profile_tag:-none}
- Features:     tt=${TAPPING_TERM},${retro_tag},${layer_tag},${dfmods_tag},gif=${gif_count}x${gif_frames}
- Firmware UF2: $uf2_out
- Pruned old:   ${PRUNE_OLD} (keep=${KEEP_COUNT})

Flash each SNAP half (two MCUs total):
1. Unplug USB-C from the keyboard half you want to flash.
2. Hold that half's reset button while plugging USB-C back in.
3. A drive appears in Finder (RP2040 boot drive).
4. Drag and drop this UF2 onto that drive.
5. The drive disappears after copy; unplug/replug if needed.
6. Repeat steps 1-5 for the other keyboard half.
EOF
