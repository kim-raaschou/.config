local sbar = require("sketchybar")
local logger = require("util.logger")
local raycast_selector = require("plugins.aerospace.raycast_selector")
local cli = require("plugins.aerospace.cli")

local event_handler = function(env)
  logger("[TRIGGER] aerospace_app_open event received ", env)
  local appPath = env.APP_PATH

  cli.fetch_workspaces(function(workspaces)
    local matchedApp = nil
    local matchedAppCount = 0

    for _, app in pairs(workspaces) do
      if app["app-bundle-path"] == appPath then
        matchedAppCount = matchedAppCount + 1
        if not matchedApp then
          matchedApp = app
        end
      end
    end

    matchedApp = matchedApp or {}

    if matchedAppCount == 0 then
      logger("[APP_OPEN] No window found → Opening app")
      sbar.exec(string.format('open -a "%s"', appPath))
    elseif matchedAppCount == 1 then
      logger("[APP_OPEN] One window → Focusing")
      sbar.exec("aerospace focus --window-id " .. matchedApp["window-id"])
    else
      logger("[APP_OPEN] Multiple windows (" .. matchedAppCount .. ") → Raycast selector")
      raycast_selector(matchedApp["app-name"])
    end
  end)
end


sbar.add("item", "aerospace_app_open", { drawing = false })
    :subscribe("aerospace_app_open", event_handler)
