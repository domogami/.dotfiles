#!/bin/zsh

set -u

target="/System/Volumes/Data"
module_cache="${TMPDIR:-/tmp}/swift-modulecache"

mkdir -p "$module_cache" 2>/dev/null || true

swift_output=$(
  SWIFT_MODULECACHE_PATH="$module_cache" swift -e '
import Foundation

let url = URL(fileURLWithPath: "/System/Volumes/Data")

do {
  let values = try url.resourceValues(forKeys: [
    .volumeAvailableCapacityForImportantUsageKey,
    .volumeTotalCapacityKey,
  ])

  print("important=\(values.volumeAvailableCapacityForImportantUsage ?? -1)")
  print("total=\(values.volumeTotalCapacity ?? -1)")
} catch {
  exit(1)
}
' 2>/dev/null
)

important=$(printf '%s\n' "$swift_output" | awk -F= '/^important=/{print $2}')
total=$(printf '%s\n' "$swift_output" | awk -F= '/^total=/{print $2}')

if [[ -n "$important" && -n "$total" && "$important" -gt 0 && "$total" -gt 0 ]]; then
  awk -v available="$important" -v total="$total" '
    BEGIN {
      used = total - available
      pct = (used / total) * 100
      printf "%.1fG available of %.1fG (%.0f%% used)\n", available / 1000000000, total / 1000000000, pct
    }
  '
  exit 0
fi

df -H "$target" | awk 'NR == 2 { printf "%s available of %s (%s used)\n", $4, $2, $5 }'
