local sbar = require("sketchybar")
local theme = require("theme")
local logger = require("util.logger")

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
        padding_left = 8,
        padding_right = 8,
        font = { size = 26.0 }
    },
    y_offset = 2,
    label = { drawing = false },
    background = { drawing = false }
})

github:subscribe("routine", function()
    sbar.exec(GITHUB_NOTIFICATIONS_COUNT, function(count)
        logger("[GITHUB] Unread notifications count: " .. count)
        count = tonumber(count or "0")

        local update_freq
        if count <= 5 then
            update_freq = 30
        elseif count <= 20 then
            update_freq = 120
        elseif count <= 50 then
            update_freq = 240
        else
            update_freq = 480
        end

        sbar.animate("sin", 30, function()
            github:set({
                update_freq = update_freq,
                icon = { color = count > 0 and theme.accent or nil }
            })
        end)
    end)
end)