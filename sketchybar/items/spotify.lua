local sbar = require("sketchybar")
local theme = require("theme")
local logger = require("util.logger")
local globals = require("globals")

local SLIDER_WIDTH = 150
local CACHE_DIR = os.getenv("HOME") .. "/.cache/sketchybar/spotify"
local current_event = nil

local progress = sbar.add("slider", "spotify.progress", SLIDER_WIDTH, {
  position = "right",
  width = 0,
  y_offset = -math.floor(globals.ITEM_HEIGHT * 0.36),
  drawing = false,
  update_freq = 0,
  icon = { drawing = false },
  label = { drawing = false },
  slider = {
    highlight_color = theme.active_foreground,
    percentage = 0,
    background = { height = 3, corner_radius = 2 },
  },
})

local text = sbar.add("item", "spotify.text", {
  position = "right",
  drawing = false,
  scroll_texts = true,
  click_script = "open -a Spotify",
  icon = { drawing = false },
  label = {
    width = SLIDER_WIDTH,
    align = "left",
    y_offset = math.floor(globals.ITEM_HEIGHT * 0.2),
    scroll_duration = 150,
    font = { size = 13 }
  },
})

local cover = sbar.add("item", "spotify.cover", {
  position = "right",
  drawing = false,
  padding_left = globals.PADDING,
  padding_right = 0,
  click_script = "open -a Spotify",
  label = { drawing = false },
  icon = {
    background = {
      drawing = true,
      image = { scale = globals.ITEM_HEIGHT / 72, corner_radius = 4 },
    }
  },
})

progress:subscribe("routine", function()
  local script = [[osascript -e 'if application "Spotify" is running then
    tell application "Spotify" to if player state is playing then
      set pos to player position
      set dur to (duration of current track) / 1000
      return (round pos rounding down) as text & ":" & (round dur rounding down) as text
    end if
  end if']]
  sbar.exec(script, function(result)
    local pos, dur = (result or ""):match("^%s*(%d+):(%d+)%s*$")
    if not pos or dur == "0" then return end
    progress:set({ slider = { percentage = math.floor(math.min(100, tonumber(pos) / tonumber(dur) * 100)) } })
  end)
end)

local function fetch_cover(track_id, callback)
  if not track_id or track_id == "" then return end

  local path = CACHE_DIR .. "/" .. track_id .. ".jpg"
  local f = io.open(path, "r")
  if f then
    f:close(); return callback(path)
  end

  local script = [[if application "Spotify" is running then
    tell application "Spotify" to if player state is not stopped then return artwork url of current track
  end if]]
  sbar.exec("osascript -e '" .. script .. "'", function(url)
    url = (url or ""):match("^%s*(.-)%s*$")
    if url == "" then return end
    -- Downscale cover art
    local cmd = string.format("curl -s '%s' -o '%s'", url:gsub("0000b273", "00004851"), path:gsub("'", "'\\''"))
    sbar.exec(cmd, function(_, code) if code == 0 then callback(path) end end)
  end)
end

local function set_drawing(visible)
  cover:set({ drawing = visible })
  text:set({ drawing = visible })
  progress:set({ drawing = visible })
end

local state_handlers = {
  stopped = function()
    set_drawing(false); current_event = nil
  end,
  paused  = function()
    set_drawing(true); progress:set({ update_freq = 0 })
  end,
  playing = function()
    set_drawing(true); progress:set({ update_freq = 1 })
  end,
}

sbar.add("event", "spotify_change", "com.spotify.client.PlaybackStateChanged")

sbar.add("item", "spotify.sub", { drawing = false }):subscribe("spotify_change", function(env)
  logger("Spotify event received", env)
  local info = env and env.INFO or {}
  local event = {
    track_id = (info["Track ID"] or ""):match("track:(.+)$"),
    track_name = info["Name"],
    artist = info["Artist"],
    state = (info["Player State"] or ""):lower(),
  }

  local handler = state_handlers[event.state]
  if handler then handler() end
  if event.state == "stopped" then return end

  if current_event and current_event.track_id == event.track_id then
    current_event = event
    return
  end
  current_event = event

  progress:set({ slider = { percentage = 0 } })
  local label = (event.track_name or "") .. " - " .. (event.artist or "")
  text:set({ label = { string = label, max_chars = 20 } })

  fetch_cover(event.track_id, function(img)
    cover:set({ icon = { background = { image = { string = img } } } })
  end)
end)

sbar.exec("mkdir -p '" .. CACHE_DIR .. "'")
