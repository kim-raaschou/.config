local sbar = require("sketchybar")
local theme = require("theme")

local MAX_APPS_PER_WORKSPACE = 10

local BUNDLE_ID_OVERRIDES = {
  ["app.net.java.openjdk.java"] = "app.com.apple.JavaLauncher",
}

return function(workspace_data, focused_window_id)
  local focused_wid = tonumber(focused_window_id or 0)

  for _, ws in ipairs(workspace_data) do
    local ws_prefix = "space." .. ws.id

    sbar.set(ws_prefix, {
      drawing = true,
      display = ws.display,
      label = {
        color = ws.focused and theme.workspace_focused or
            (#ws.apps > 0 and theme.workspace_with_apps or theme.workspace_empty),
        background = { drawing = ws.focused },
      },
      background = {
        drawing = ws.focused,
      },
    })

    local app_index = 0

    for _, app in ipairs(ws.apps) do
      app_index = app_index + 1

      sbar.set(ws_prefix .. ".app." .. app_index, {
        drawing = true,
        display = ws.display,
        click_script = "aerospace focus --window-id " .. app.window_id,
        label = { string = app.count > 1 and "􀕩" or "" },
        icon = {
          background = {
            drawing = true,
            image = {
              string = BUNDLE_ID_OVERRIDES[app.bundle_id] or app.bundle_id,
              border_color = app.window_id == focused_wid and theme.app_border_focused or "",
            }
          },
        }
      })
    end

    for i = app_index + 1, MAX_APPS_PER_WORKSPACE do
      sbar.set(ws_prefix .. ".app." .. i, {
        drawing = false,
        display = ws.display
      })
    end
  end
end
