local sbar = require("sketchybar")

local config = { position = "right", padding_right = -8, padding_left = -8 }
sbar.add("alias", "Kontrolcenter,Clock", config)
sbar.add("alias", "Kontrolcenter,RAM", config)
sbar.add("alias", "Kontrolcenter,CPU", config)

require("items.github")
require("items.spotify")
