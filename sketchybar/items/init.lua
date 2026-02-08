local sbar = require("sketchybar")

sbar.add("alias", "Kontrolcenter,Clock", {
    position = "right",
    padding_right = -8,
    padding_left = -8,
    alias = { color = "0xffffffff" }
})
sbar.add("alias", "Kontrolcenter,RAM", {
    position = "right",
    padding_right = -8,
    padding_left = -8,
})
sbar.add("alias", "Kontrolcenter,CPU", {
    position = "right",
    padding_right = -8,
    padding_left = -8,
})

require("items.github")
require("items.spotify")
