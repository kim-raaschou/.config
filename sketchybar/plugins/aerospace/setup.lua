local sbar = require("sketchybar")
local theme = require("theme")

local MAX_APPS_PER_WORKSPACE = 10

return function (workspace_data)
  for _, ws in ipairs(workspace_data) do

    sbar.add("item", "space." .. ws.id, {
      label = {
        align = "center",
        string = tostring(ws.id),
        font = {
          family = "SF Pro",
          style = "Semibold",
          size = 18.0
        },
        y_offset = 1,
        background = {
          drawing = false,
          height = 3,
          color = theme.accent,
          y_offset = -12,
          corner_radius = 3
        },
      },
      icon = { drawing = false },
      background = {
        corner_radius = 3,
        drawing = true,
        color = theme.workspace_bg,
        height = 27,
      },
      click_script = "aerospace workspace " .. ws.id
    })

    for i = 1, MAX_APPS_PER_WORKSPACE do
      sbar.add("item", "space." .. ws.id .. ".app." .. i, {
        drawing = false,
        label = {
          color = theme.accent,
          y_offset = -10,
          padding_left = -10,
          font = { size = 8 },
        },
        icon = {
          width = 27,
          background = {
            drawing = true,
            image = {
              scale = 0.80,
              border_width = 1,
              corner_radius = 7,
            }
          },
        }
      })
    end
  end
end