# Sketchybar + AeroSpace Integration - Agent Guidelines

## Testing & Development
- **Restart:** `brew services restart felixkratz/formulae/sketchybar`
- **View logs:** `tail -f ~/sketchybar.log` (when logging enabled)
- **Test manually:** Open/close apps, switch workspaces with `aerospace workspace N`
- **No formal tests:** Manual testing required for UI changes

## Code Style
- **Language:** Lua 5.4
- **Naming:** snake_case for functions/variables, SCREAMING_SNAKE for constants
- **State:** Immutable pattern - never modify passed state, create new tables
- **Error handling:** Check CLI exit codes, use `callback(nil)` for errors
- **Async:** Parallel CLI calls in cli.lua, avoid nested callbacks
- **Performance:** Pre-create 10 app slots per workspace, toggle `drawing = true/false` to show/hide
- **Events:** 3 types - `aerospace_workspace_change`, `aerospace_focus_change`, `space_windows_change`
- **Logging:** Toggle via `util/logger.lua` ENABLED flag, uses JSON encoding for tables
- **Architecture:** Separate concerns - CLI (cli.lua), Data (data.lua), Render (update.lua + setup.lua)

## Key Files
- `plugins/aerospace/init.lua` - Event handlers and bootstrap
- `plugins/aerospace/cli.lua` - AeroSpace CLI wrapper (parallel workspace + window fetch)
- `plugins/aerospace/data.lua` - Transforms raw AeroSpace data into workspace model
- `plugins/aerospace/setup.lua` - Creates initial sketchybar items (startup)
- `plugins/aerospace/update.lua` - Updates existing items (runtime)
- `plugins/aerospace/mode.lua` - AeroSpace mode indicator (main/apps/window)
- `plugins/aerospace/app_open.lua` - Smart app opener (focus/open/Raycast)
- `plugins/aerospace/workspace_manager.lua` - Moves all windows to target workspace
- `items/github.lua` - GitHub notification badge
- `items/spotify.lua` - Spotify now-playing widget with cover art
- `util/logger.lua` - JSON-capable logger with enable/disable toggle

## KODE
DO not just begin to update/write code that not has ben approved.
SIMPLICITY IS KING <-- this it most importent