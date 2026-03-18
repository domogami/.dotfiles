#!/bin/zsh

set -u

total_mib_from_hostinfo() {
  hostinfo 2>/dev/null | awk -F': ' '
    /Primary memory available/ {
      gsub(/ gigabytes/, "", $2)
      printf "%.0f\n", $2 * 1024
      exit
    }
  '
}

used_token="$(top -l 1 -n 0 2>/dev/null | awk -F'[:,()]' '
  /PhysMem:/ {
    gsub(/^ +| +$/, "", $2)
    split($2, parts, " ")
    print parts[1]
    exit
  }
')"
total_mib="$(total_mib_from_hostinfo)"

if [[ -n "$used_token" && -n "$total_mib" ]]; then
  used_mib="$(
    awk -v token="$used_token" '
      BEGIN {
        match(token, /^([0-9.]+)([BKMGTP])$/, parts)
        value = parts[1] + 0
        unit = parts[2]

        if (unit == "B") mib = value / 1048576
        else if (unit == "K") mib = value / 1024
        else if (unit == "M") mib = value
        else if (unit == "G") mib = value * 1024
        else if (unit == "T") mib = value * 1048576
        else if (unit == "P") mib = value * 1073741824

        printf "%.0f\n", mib
      }
    '
  )"

  if [[ -n "$used_mib" ]]; then
    printf '%sMiB / %sMiB\n' "$used_mib" "$total_mib"
    exit 0
  fi
fi

memory_output="$(memory_pressure 2>/dev/null)"

if [[ -n "$memory_output" ]]; then
  total_bytes="$(printf '%s\n' "$memory_output" | awk '/^The system has / {print $4; exit}')"
  free_pct="$(printf '%s\n' "$memory_output" | awk -F': ' '/System-wide memory free percentage/ {gsub(/%/, "", $2); print $2; exit}')"

  if [[ -n "$total_bytes" && -n "$free_pct" ]]; then
    awk -v total="$total_bytes" -v free_pct="$free_pct" '
      BEGIN {
        used = total * (100 - free_pct) / 100
        printf "%.0fMiB / %.0fMiB\n", used / 1048576, total / 1048576
      }
    '
    exit 0
  fi
fi

exit 1
