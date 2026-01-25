local logger = require("util.logger")

local theme = {}

function theme.load(name)
  name = name or "tokyodark"

  local loaded_theme = require("themes." .. name)

  for k, v in pairs(loaded_theme) do
    theme[k] = v
  end

  logger("[THEME] ✅ Loaded theme:", name)
end

return theme
