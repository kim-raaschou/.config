# macOS Tiling Window Manager Configuration

AeroSpace tiling window manager with SketchyBar integration for workspace visualization and system monitoring.

## Features

- 5 workspaces with multi-monitor support
- Modal interface (main/window/apps modes)
- Real-time workspace indicators and window focus tracking
- Quick access app launcher
- GitHub notifications integration
- Visual window borders with active window highlighting
- Workspace manager for resetting layouts and consolidating windows

## Dependencies

```bash
# Core tools
brew install --cask nikitabobko/tap/aerospace
brew install felixkratz/formulae/sketchybar
brew install felixkratz/formulae/borders
brew install gh

# Optional: Multi-window app selection
brew install --cask raycast
# Install AeroSpace extension: https://www.raycast.com/limonkufu/aerospace
```

**Fonts:** SF Pro and SF Symbols (pre-installed on macOS)

## Installation

```bash
# Clone repository
git clone https://github.com/kim-raaschou/.config.git ~/.config

# Authenticate GitHub CLI
gh auth login

# Start services
brew services start felixkratz/formulae/sketchybar
brew services start felixkratz/formulae/borders
open -a AeroSpace

# Restart to apply all settings
```

## Configuration

**Files:**
- AeroSpace: `~/.config/aerospace/aerospace.toml`
- SketchyBar: `~/.config/sketchybar/` (Lua)
- Themes: `~/.config/sketchybar/themes/` (tokyodark, tokyonight, catppuccin, nord)

**Common edits:**
- Workspace gaps: Modify `[gaps]` in `aerospace.toml`
- Theme: Change require path in `theme.lua`
- App launcher: Edit `[mode.apps.binding]` in `aerospace.toml`

## Keyboard Shortcuts

### Mode Switching
| Shortcut | Action |
|----------|--------|
| `Cmd+Ctrl+Alt+W` | Enter Window mode |
| `Cmd+Ctrl+Alt+A` | Enter Apps mode |
| `Esc` | Return to Main mode |

### Main Mode
| Shortcut | Action |
|----------|--------|
| `Cmd+Ctrl+Alt+←→↑↓` | Focus window |
| `Cmd+Ctrl+Alt+1-5` | Switch to workspace |
| `Cmd+Ctrl+Alt+Shift+1-5` | Move window to workspace |
| `Cmd+Ctrl+Alt+Shift+←→` | Navigate workspaces |
| `Cmd+Ctrl+Alt+Enter` | Toggle tiles/accordion layout |

### Window Mode
| Shortcut | Action |
|----------|--------|
| `←→↑↓` | Move window |
| `Shift+Ctrl+Alt+←→↑↓` | Join window to container |
| `Shift+←→↑↓` | Resize window (±75px) |
| `F` | Reset layout (move all windows to workspace 1), exit mode |
| `B` | Balance sizes, exit mode |
| `Q` | Kill borders, restart sketchybar, reload config, exit mode |
| `Esc` | Exit mode |

### Apps Mode
| Key | App | Key | App |
|-----|-----|-----|-----|
| `A` | Arc | `M` | Notion Mail |
| `B` | Brave | `P` | Postman |
| `C` | Notion Calendar | `S` | Spotify |
| `D` | IntelliJ IDEA | `T` | Teams |
| `E` | Excel | `V` | VS Code |
| `F` | Finder | `W` | Warp |
| `G` | ChatGPT | `Z` | Zen |
| `J` | Java | `F10` | Custom URL |
| | | `F11` | GitHub Notifications |
| | | `F12` | Messages |

## Workspace Manager

Reset AeroSpace layout by consolidating all windows to a target workspace while preserving focus on your current window.

**Usage:**

*Keyboard shortcut:* `Cmd+Ctrl+Alt+W` then `F` — Enter Window mode, move all windows to workspace 1, exit mode

*CLI command:*
```bash
sketchybar --trigger aerospace_reset_layout                  # Default to workspace 1
sketchybar --trigger aerospace_reset_layout TARGET_WS=3      # Custom workspace
```

**Behavior:**
- Moves all windows from all workspaces to the target workspace
- Preserves focus on the currently focused window
- Automatically switches to the target workspace when restoring focus
- Sets layout to `tiles accordion` when no window is focused (e.g., empty workspace)

**Implementation:** `~/.config/sketchybar/plugins/aerospace/workspace_manager.lua`

## Troubleshooting

**Reload config:** Press `Q` in Window mode or run:
```bash
brew services restart felixkratz/formulae/sketchybar
brew services restart felixkratz/formulae/borders
killall AeroSpace && open -a AeroSpace
```

**GitHub notifications:** Verify authentication:
```bash
gh auth status
```

## Credits

- [AeroSpace](https://github.com/nikitabobko/AeroSpace) by nikitabobko
- [SketchyBar](https://github.com/FelixKratz/SketchyBar) by FelixKratz
- [Borders](https://github.com/FelixKratz/borders) by FelixKratz
