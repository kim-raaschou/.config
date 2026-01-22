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
- **Async:** Use pipeline.lua for parallel operations, avoid nested callbacks
- **Performance:** fetchAll() supports workspace filtering for partial updates
- **Events:** 3 types - `aerospace_workspace_change` (partial fetch), `aerospace_focus_change` (no fetch), `space_windows_change` (full fetch with 100ms delay
- **Render:** Pre-create 10 app slots per workspace, toggle `drawing = true/false` to show/hide
- **Logging:** Toggle via `spaces/logger.lua` ENABLED flag, uses JSON encoding for tables
- **Architecture:** Separate concerns - CLI (aerospace_cli.lua), State (aerospace_state.lua), Render (aerospace_update.lua + aerospace_init.lua)

## Key Files
- `spaces/init.lua` - Event handlers and state management
- `spaces/aerospace_state.lua` - Fetches and processes AeroSpace data
- `spaces/aerospace_update.lua` - Updates existing items (runtime)
- `spaces/aerospace_init.lua` - Creates initial items (startup)
- `spaces/aerospace_cli.lua` - AeroSpace CLI wrapper with workspace filtering

## KODE
DO not just begin to update/write code that not has ben approved.
SIMPLICITY IS KING <-- this it most importent