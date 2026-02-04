local sbar = require("sketchybar")
local theme = require("theme")
local logger = require("util.logger")

local SPOTIFY_EVENT = "com.spotify.client.PlaybackStateChanged"
local SPOTIFY_ARTWORK_CACHE_DIR = os.getenv("HOME") .. "/.cache/sketchybar/spotify"
local SPOTIFY_URL_LARGE = "0000b273"
local SPOTIFY_URL_SMALL = "00004851"

local SPOTIFY_ARTWORK_SCRIPT = [[
  if application "Spotify" is running then
    tell application "Spotify"
      if player state is playing or player state is paused then
        set trackName to name of current track
        set trackArtist to artist of current track
        set trackAlbum to album of current track
        set trackId to id of current track
        set artworkUrl to artwork url of current track
        set playerState to player state as string
        set trackDuration to duration of current track
        set trackPosition to player position
        set trackPopularity to popularity of current track
        set trackDiscNumber to disc number of current track
        set trackTrackNumber to track number of current track
        set playerVolume to sound volume
        set playerRepeating to repeating
        set playerShuffling to shuffling

        return trackName & "|" & trackArtist & "|" & trackAlbum & "|" & trackId & "|" & artworkUrl & "|" & playerState & "|" & trackDuration & "|" & trackPosition & "|" & trackPopularity & "|" & trackDiscNumber & "|" & trackTrackNumber & "|" & playerVolume & "|" & playerRepeating & "|" & playerShuffling
      end if
    end tell
  end if
  return ""]]

-- Track the current track ID to avoid unnecessary updates
local current_track_id = nil

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
  padding_left = 2,
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

local function fetch_cover_artwork(track_id, artwork_url, callback)
  local cache_path = SPOTIFY_ARTWORK_CACHE_DIR .. "/" .. track_id .. ".jpg"
  local file = io.open(cache_path, "r")

  if file then
    file:close()
    callback(cache_path)
  else
    artwork_url = (artwork_url or ""):match("^%s*(.-)%s*$")
    if artwork_url == "" then return end

    local small_url = artwork_url:gsub(SPOTIFY_URL_LARGE, SPOTIFY_URL_SMALL)
    local download_cmd = string.format("curl -s '%s' -o '%s'", escape_quotes(small_url), escape_quotes(cache_path))

    sbar.exec(download_cmd, function(_, exit_code)
      if exit_code == 0 then
        callback(cache_path)
      end
    end)
  end
end

local function parse_track_info(callback)
  local function split(str, delimiter)
    local result = {}
    for match in (str .. delimiter):gmatch("(.-)" .. delimiter) do
      table.insert(result, match)
    end
    return result
  end
  local function trim(str) return str:match("^%s*(.-)%s*$") end

  sbar.exec("osascript -e '" .. SPOTIFY_ARTWORK_SCRIPT .. "'", function(output)
    if not output or output == "" then
      return
    end

    local parts = split(output, "|")

    if #parts >= 8 then
      callback({
        name = trim(parts[1]),
        artist = trim(parts[2]),
        album = trim(parts[3]),
        id = trim(parts[4]),
        artwork_url = trim(parts[5]),
        player_state = trim(parts[6]),
        duration = tonumber(parts[7]),
        position = tonumber(parts[8]),
        display = string.format("%s - %s", trim(parts[1]), trim(parts[2]))
      })
    end
  end)
end

local function update_spotify(env)
  logger("Spotify update triggered", env)
  if not env or not env.INFO or env.INFO["Player State"] == "Stopped" then return end

  parse_track_info(function(track_info)
    local track_id = (track_info.id or ""):match("track:(.+)$")
    if track_id == current_track_id then return end

    current_track_id = track_id

    spotify_bracket:set({ drawing = true })

    spotify_song:set({
      drawing = true,
      label = { string = truncate_string(track_info.name, 14) }
    })

    spotify_artist:set({
      drawing = true,
      label = { string = truncate_string(track_info.artist, 20) }
    })

    fetch_cover_artwork(track_id, track_info.artwork_url, function(image_path)
      spotify_cover:set({
        drawing = true,
        icon = { background = { image = { string = image_path } } }
      })
    end)
  end)
end

local function show_if_spotify_is_running()
  sbar.exec("pgrep -x Spotify", function(_, exit_code)
    local spotify_is_running = exit_code == 0
    if not spotify_is_running then
      current_track_id = nil
      spotify_bracket:set({ drawing = false })
      spotify_cover:set({ drawing = false })
      spotify_song:set({ drawing = false })
      spotify_artist:set({ drawing = false })
    end
  end)
end

local spotify_subscription = sbar.add("item", "spotify.subscription", {
  update_freq = 1,
  drawing = false
})

sbar.add("event", "spotify_change", SPOTIFY_EVENT)
spotify_subscription:subscribe("spotify_change", update_spotify)
spotify_subscription:subscribe("routine", show_if_spotify_is_running)

sbar.exec("mkdir -p '" .. SPOTIFY_ARTWORK_CACHE_DIR .. "'")

return { cover = spotify_cover, song = spotify_song, artist = spotify_artist }
