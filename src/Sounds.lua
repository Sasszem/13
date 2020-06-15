-- Sounds.lua
-- play sounds & music
-- handles loading and caching of sources
-- sounds and music can be muted


local Sounds = {
    soundsEnabled = true,
    musicEnabled = true
}

local cache = {}

local StreamSize = 100000
-- maximum file size for static sources


-- get a sound from cache
-- load it into cache if necessary
-- and determine preferred mode based on file size
function Sounds.getSource(name)
    -- fill in cache
    if not cache[name] then
        local filename = ("asset/%s.ogg"):format(name)
        local fileInfo = assert(love.filesystem.getInfo(filename), ("Requested sound file %s can not be found!"):format(filename))
        local fileSize = fileInfo.size
        local sourceMode = (fileSize > StreamSize) and "stream" or "static"
        cache[name] = love.audio.newSource(filename, sourceMode)
    end

    return cache[name]:clone()
end

local playing = {}

-- play a short sound effect
function Sounds.play(name)
    -- muted?
    if not Sounds.soundsEnabled then return end

    local source = Sounds.getSource(name)
    playing[#playing+1] = source
    source:play()
end

-- play a sound looping (background music)
function Sounds.playLooping(name)
    local source = Sounds.getSource(name)
    playing[#playing+1] = source

    source:setLooping(true)

    -- mute if necessary
    local volume = Sounds.musicEnabled and 1 or 0
    source:setVolume(volume)

    source:play()
end


-- update function
-- calls cleanup every second
local t = 0
function Sounds.update(dt)
    if math.floor(t+dt) > math.floor(t) then -- every second
        Sounds.cleanup()
    end
    t = t + dt
end


-- remove stopped sources from list
function Sounds.cleanup()
    local newPlaying = {}
    for _, sound in ipairs(playing) do
        if not sound:isPlaying() then
            sound:release()
        else
            newPlaying[#newPlaying+1] = sound
        end
    end
    playing = newPlaying
end


-- enable or disable (mute) effects
function Sounds.setSounds(enable)
    -- since effects are short, we do not have to apply this setting for already playing sources
    Sounds.soundsEnabled = enable
end


-- enable or disable (mute) music
function Sounds.setMusic(enable)
    Sounds.musicEnabled = enable

    -- apply setting for playing sources
    -- (might mute currently playign effects as well, but they are short and later effects won't be affected)
    local volume = enable and 1 or 0
    for _, S in ipairs(playing) do
        S:setVolume(volume)
    end
end


return Sounds