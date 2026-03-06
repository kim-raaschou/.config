local theme = {}

function theme.load(name)
  for k, v in pairs(require("themes." .. (name or "tokyodark"))) do theme[k] = v end
end

return theme
