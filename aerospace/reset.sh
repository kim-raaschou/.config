#!/usr/bin/env bash
# aerospace-reset: Move all windows to workspace 1, preserving focus.

set -euo pipefail

focused_win_id=$(aerospace list-windows --focused_win_id --format '%{window-id}' 2>/dev/null || true)

windows=$(aerospace list-windows --all --format '%{window-id}|%{workspace}' \
  | awk -F'|' '$2 != "1" { print $1 }')

if [[ -n "$windows" ]]; then
  while IFS= read -r wid; do
    aerospace move-node-to-workspace --window-id "$wid" 1
  done <<< "$windows"
fi
  
aerospace workspace 1

if [[ -n "$focused_win_id" ]]; then
  aerospace focus --window-id "$focused_win_id"
fi


aerospace flatten-workspace-tree --workspace 1