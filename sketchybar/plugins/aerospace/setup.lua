local sbar = require("sketchybar")
local theme = require("theme")
local globals = require("globals")

local MAX_APPS_PER_WORKSPACE = 10

return function (workspace_data)
  for _, ws in ipairs(workspace_data) do
    local ws_prefix = "space." .. ws.id

    sbar.add("item", ws_prefix, {
      label = {
        align = "center",
        string = tostring(ws.id),
        width = globals.WS_WIDTH,
        font = {
          style = "bold",
          size = globals.WS_FONT_SIZE
        },
        background = {
          drawing = false,
          height = 3,
          color = theme.accent,
          y_offset = globals.ITEM_OFFSET,
          corner_radius = 3
        },
      },
      icon = { drawing = false },
      background = {
        corner_radius = 3,
        drawing = true,
        color = theme.workspace_bg,
        height = globals.ITEM_HEIGHT
      },
      click_script = "aerospace workspace " .. ws.id
    })

    for i = 1, MAX_APPS_PER_WORKSPACE do
      sbar.add("item", ws_prefix .. ".app." .. i, {
        drawing = false,
        label = {
          color = theme.accent,
          y_offset = -8,
          padding_left = -6,
          font = { size = 6 },
        },
        icon = {
          background = {
            drawing = true,
            image = {
              scale = globals.APP_ICON_SCALE,
              border_width = 1,
              corner_radius = 7,
            }
          },
        }
      })
    end
  end
end