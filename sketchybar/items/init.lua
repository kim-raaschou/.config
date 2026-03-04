local sbar = require("sketchybar")
local globals = require("globals")

local alias_padding = -globals.PADDING
local alias_scale = globals.ITEM_HEIGHT / 30

sbar.add("alias", "Kontrolcenter,Clock", {
    position = "right",
    padding_right = alias_padding,
    padding_left = alias_padding,
    alias = { color = "0xffffffff", scale = alias_scale },
})
sbar.add("alias", "Kontrolcenter,RAM", {
    position = "right",
    padding_right = alias_padding,
    padding_left = alias_padding,
    alias = { scale = alias_scale },
})
sbar.add("alias", "Kontrolcenter,CPU", {
    position = "right",
    padding_right = alias_padding,
    padding_left = alias_padding,
    alias = { scale = alias_scale },
})

require("items.github")
require("items.spotify")
