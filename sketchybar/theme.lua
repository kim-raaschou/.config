local theme = {}

function theme.load(name)
  local t = require("themes." .. (name or "tokyodark"))

  for k, v in pairs(t) do
    theme[k] = v
  end
end

return theme
