# macOS Tiling Window Manager Configuration

A streamlined macOS setup featuring AeroSpace tiling window manager with deep SketchyBar integration for workspace visualization and system monitoring.

## Features

- **5 Workspaces** with multi-monitor support and custom gap configurations
- **Modal Interface** - Three operation modes (main, window, apps) for efficient workflow
- **Dynamic Status Bar** - Real-time workspace indicators, app icons, and window focus tracking
- **Smart Window Management** - Automatic floating rules for dialogs and tool windows
- **Application Launcher** - Quick access to 17+ apps via keyboard shortcuts
- **GitHub Notifications** - Integrated notification monitoring in the status bar
- **Visual Window Borders** - Active window highlighting with custom colors
- **System Monitoring** - CPU and RAM usage display

## Dependencies

### Core Tools

```bash
# AeroSpace - Tiling window manager
brew install --cask nikitabobko/tap/aerospace

# SketchyBar - Customizable status bar with Lua support
brew install felixkratz/formulae/sketchybar

# Borders - Window border highlighting
brew install felixkratz/formulae/borders

# GitHub CLI - For notification monitoring
brew install gh
```

### Optional Tools

```bash
# Raycast - For multi-window app selection
brew install --cask raycast
# Install the AeroSpace extension: https://www.raycast.com/limonkufu/aerospace
```

### Fonts

- **SF Pro** - Apple system font (pre-installed on macOS)
- **SF Symbols** - Icon font (pre-installed on macOS)

## Installation

1. **Install dependencies** (see above)

2. **Clone this repository**
   ```bash
   git clone https://github.com/kim-raaschou/.config.git ~/.config
   ```

3. **Authenticate GitHub CLI** (for notifications)
   ```bash
   gh auth login
   ```

4. **Start services**
   ```bash
   brew services start felixkratz/formulae/sketchybar
   brew services start felixkratz/formulae/borders
   ```

5. **Set AeroSpace to start at login** (already enabled in config)
   ```bash
   # Open AeroSpace, it will auto-start on next login
   open -a AeroSpace
   ```

6. **Restart to apply all settings**

## Configuration

### File Locations

- **AeroSpace**: `~/.config/aerospace/aerospace.toml`
- **SketchyBar**: `~/.config/sketchybar/` (Lua-based)
- **Themes**: `~/.config/sketchybar/themes/`

### Customization

**Change workspace gaps:**
Edit `aerospace.toml` and modify the `[gaps]` section.

**Switch themes:**
Edit `~/.config/sketchybar/theme.lua` and change the require path:
```lua
-- Available: tokyodark, tokyonight, catppuccin, nord
return require("themes.tokyodark")
```

**Modify app launcher:**
Edit the `[mode.apps.binding]` section in `aerospace.toml`.

**Adjust workspace count:**
Modify the `workspace-to-monitor-force-assignment` and keybindings in `aerospace.toml`.

## Keyboard Shortcuts

### Mode Switching
| Shortcut | Action |
|----------|--------|
| `Cmd+Ctrl+Alt+W` | Enter Window mode |
| `Cmd+Ctrl+Alt+A` | Enter Apps mode |
| `Esc` | Return to Main mode |

### Main Mode (Default)
| Shortcut | Action |
|----------|--------|
| `Cmd+Ctrl+Alt+←→↑↓` | Focus window (with wrap-around) |
| `Cmd+Ctrl+Alt+1-5` | Switch to workspace 1-5 |
| `Cmd+Ctrl+Alt+Shift+1-5` | Move window to workspace 1-5 |
| `Cmd+Ctrl+Alt+Shift+←→` | Navigate between workspaces |
| `Cmd+Ctrl+Alt+Enter` | Toggle layout (tiles/accordion) |

### Window Mode
| Shortcut | Action |
|----------|--------|
| `←→↑↓` | Move window in direction |
| `Shift+Ctrl+Alt+←→↑↓` | Join window to container |
| `Shift+←→↑↓` | Resize window (±75px) |
| `B` | Balance window sizes and return to Main mode |
| `Q` | Reload config, restart services, return to Main mode |
| `Esc` | Return to Main mode |

### Apps Mode (Quick Launcher)
| Key | Application |
|-----|-------------|
| `A` | Arc Browser |
| `B` | Brave Browser |
| `C` | Notion Calendar |
| `D` | IntelliJ IDEA |
| `E` | Microsoft Excel |
| `F` | Finder |
| `G` | ChatGPT |
| `J` | Java (OpenJDK) |
| `M` | Notion Mail |
| `P` | Postman |
| `S` | Spotify |
| `T` | Microsoft Teams |
| `V` | Visual Studio Code |
| `W` | Warp Terminal |
| `Z` | Zen Browser |
| `F10` | Custom GitHub URL |
| `F11` | GitHub Notifications |
| `F12` | Messages |

## Troubleshooting

### Reload Configuration
Press `Q` in Window mode to reload AeroSpace config and restart services, or manually:
```bash
brew services restart felixkratz/formulae/sketchybar
brew services restart felixkratz/formulae/borders
killall AeroSpace && open -a AeroSpace
```

### GitHub Notifications
Verify GitHub CLI authentication:
```bash
gh auth status
gh api notifications
```

## Credits

- [AeroSpace](https://github.com/nikitabobko/AeroSpace) by nikitabobko
- [SketchyBar](https://github.com/FelixKratz/SketchyBar) by FelixKratz
- [Borders](https://github.com/FelixKratz/borders) by FelixKratz
