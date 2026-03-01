local theme = {}

function theme.load(name)
  local t = require("themes." .. (name or "tokyodark"))

  for k, v in pairs(t) do
    theme[k] = v
  end

  theme.transparent = "0x00000000"
  theme.workspace_focused = theme.accent
  theme.app_border_focused = theme.accent
  theme.mode_main = theme.workspace_with_apps
  theme.mode_active = theme.accent
  theme.border_active = theme.accent
end

return theme
