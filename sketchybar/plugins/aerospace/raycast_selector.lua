local sbar = require("sketchybar")
local logger = require("util.logger")

local function urlEncode(str)
    local format = function(c)
        return string.format("%%%02X", string.byte(c))
    end

    return string.gsub(str, "([^%w%-%.%_%~])", format)
end

local function buildDeeplink(appName)
    local baseUrl = "raycast://extensions/limonkufu/aerospace/switchApps"
    local encodedArgs = urlEncode('{"workspace":"all"}')
    local encodedContext = urlEncode(string.format('{"searchText":"%s"}', appName))

    return baseUrl .. "?arguments=" .. encodedArgs .. "&context=" .. encodedContext
end

return function(appName)
    local deeplink = buildDeeplink(appName)
    local command = string.format('open "%s"', deeplink)
    logger("[RAYCAST] Executing deeplink:", command)

    return sbar.exec(command);
end
