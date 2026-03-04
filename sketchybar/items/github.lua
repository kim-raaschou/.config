local sbar = require("sketchybar")
local theme = require("theme")
local logger = require("util.logger")
local globals = require("globals")

local GITHUB_NOTIFICATIONS_COUNT = "GH_TOKEN=$(gh auth token --user krn_festina) " ..
    "gh api notifications " ..
    "--jq '[.[] | select(.unread == true)] | length'"

local github = sbar.add("item", "github", {
    updates = "when_shown",
    update_freq = 1,
    position = "right",
    click_script = "open https://github.com/notifications",
    icon = {
        drawing = true,
        string = "",
        padding_left = globals.PADDING,
        padding_right = globals.PADDING,
        font = { size = math.floor(globals.BAR_HEIGHT * 0.8) },
    },
    label = { drawing = false },
    background = { drawing = false },
})

github:subscribe("routine", function()
    sbar.exec(GITHUB_NOTIFICATIONS_COUNT, function(count)
        logger("[GITHUB] Unread notifications count: " .. count)
        sbar.animate("sin", 30, function()
            github:set({
                update_freq = 10,
                icon = { color = (tonumber(count) or 0) > 0 and theme.accent or nil }
            })
        end)
    end)
end)
