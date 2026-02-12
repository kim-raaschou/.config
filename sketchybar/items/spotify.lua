local sbar = require("sketchybar")
local theme = require("theme")
local logger = require("util.logger")

local SPOTIFY_ARTWORK_CACHE_DIR = os.getenv("HOME") .. "/.cache/sketchybar/spotify"

local current_spotify_event = nil

local spotify_artist = sbar.add("item", "spotify.artist", {
  position = "right",
  width = 0,
  click_script = "open -a Spotify",
  icon = { drawing = false },
  label = {
    width = 120,
    align = "left",
    font = { size = 8.0 },
    color = theme.workspace_with_apps,
    y_offset = -8,
  }
})

local spotify_song = sbar.add("item", "spotify.song", {
  position = "right",
  click_script = "open -a Spotify",
  icon = { drawing = false },
  label = {
    width = 120,
    align = "left",
    font = { size = 13.0 },
    y_offset = 4,
  }
})

local spotify_cover = sbar.add("item", "spotify.cover", {
  position = "right",
  padding_left = 4,
  padding_right = 0,
  click_script = "open -a Spotify",
  label = { drawing = false },
  icon = {
    background = {
      drawing = true,
      image   = {
        scale = 0.32,
        corner_radius = 7
      }
    }
  }
})

local spotify_bracket = sbar.add("bracket", "spotify.bracket", {
  spotify_cover.name,
  spotify_artist.name,
  spotify_song.name,
}, {
  drawing = false,
  background = {
    height = 28,
    color = theme.workspace_bg,
    border_color = theme.border_inactive,
    border_width = 1,
    corner_radius = 7,
  }
})

local function truncate_string(str, max_length)
  if not str or #str <= max_length then return str or "" end
  return str:sub(1, max_length - 1) .. "…"
end

local function escape_quotes(str)
  if not str then return "" end
  return str:gsub("'", "'\\''")
end

local function trim(str)
  return str:match("^%s*(.-)%s*$")
end

local function spotify_event_from(env)
  if env and env.INFO then
    return {
      track_id = (env.INFO["Track ID"] or ""):match("track:(.+)$"),
      track_name = env.INFO["Name"],
      artist = env.INFO["Artist"],
      album = env.INFO["Album"],
      album_artist = env.INFO["Album Artist"],
      track_number = env.INFO["Track Number"],
      disc_number = env.INFO["Disc Number"],
      has_artwork = env.INFO["Has Artwork"],
      player_state = env.INFO["Player State"],
      duration = env.INFO["Duration"],
      playback_position = env.INFO["Playback Position"],
      play_count = env.INFO["Play Count"],
      popularity = env.INFO["Popularity"]
    }
  end

  return {}
end

local function fetch_cover_artwork(track_id, callback)
  if not track_id or track_id == "" then return end

  local cache_path = SPOTIFY_ARTWORK_CACHE_DIR .. "/" .. track_id .. ".jpg"
  local cache_file = io.open(cache_path, "r")

  if cache_file then
    cache_file:close()
    callback(cache_path)
    return
  end

  local SPOTIFY_ARTWORK_SCRIPT = [[
  if application "Spotify" is running then
    tell application "Spotify"
      if player state is playing or player state is paused then
        return artwork url of current track
      end if
    end tell
  end if
  return ""]]

  sbar.exec("osascript -e '" .. SPOTIFY_ARTWORK_SCRIPT .. "'", function(artwork_url)
    artwork_url = trim(artwork_url or "")
    if artwork_url == "" then return end

    local SPOTIFY_URL_LARGE = "0000b273"
    local SPOTIFY_URL_SMALL = "00004851"
    local small_url = artwork_url:gsub(SPOTIFY_URL_LARGE, SPOTIFY_URL_SMALL)
    local download_cmd = string.format("curl -s '%s' -o '%s'", escape_quotes(small_url), escape_quotes(cache_path))

    sbar.exec(download_cmd, function(_, exit_code)
      if exit_code == 0 then
        callback(cache_path)
      end
    end)
  end)
end

sbar.add("event", "spotify_change", "com.spotify.client.PlaybackStateChanged")

local spotify_subscription = sbar.add("item", "spotify.subscription", {
  update_freq = 2,
  drawing = false
})

spotify_subscription:subscribe("spotify_change", function(env)
  logger("Spotify event received", env)
  local spotify_event = spotify_event_from(env)

  if spotify_event.player_state == "Stopped" then
    spotify_bracket:set({ drawing = false })
    spotify_cover:set({ drawing = false })
    spotify_song:set({ drawing = false })
    spotify_artist:set({ drawing = false })
    current_spotify_event = nil
    return
  end

  local border_color = spotify_event.player_state == "Playing"
      and theme.border_active
      or theme.border_inactive

  spotify_bracket:set({
    drawing = true,
    background = { border_color = border_color }
  })

  if current_spotify_event and current_spotify_event.track_id == spotify_event.track_id then
    current_spotify_event = spotify_event
    return
  end

  current_spotify_event = spotify_event

  spotify_song:set({
    drawing = true,
    label = { string = truncate_string(spotify_event.track_name, 14) }
  })
  spotify_artist:set({
    drawing = true,
    label = { string = truncate_string(spotify_event.artist, 20) }
  })

  fetch_cover_artwork(spotify_event.track_id, function(image_path)
    spotify_cover:set({
      drawing = true,
      icon = { background = { image = { string = image_path } } }
    })
  end)
end)

--spotify_subscription:subscribe("routine", function()
  -- if current_spotify_event == nil then return end

  -- sbar.exec("pgrep -x Spotify", function(_, exit_code)
    -- local spotify_is_running = exit_code == 0
    -- if not spotify_is_running then
      -- spotify_bracket:set({ drawing = false })
      -- spotify_cover:set({ drawing = false })
      -- spotify_song:set({ drawing = false })
      -- spotify_artist:set({ drawing = false })
      -- -- Reset state when Spotify quits
      -- current_spotify_event = nil
    -- end
  -- end)
--end)

sbar.exec("mkdir -p '" .. SPOTIFY_ARTWORK_CACHE_DIR .. "'")

return { cover = spotify_cover, song = spotify_song, artist = spotify_artist }
