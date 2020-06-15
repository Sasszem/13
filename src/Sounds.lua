local Sounds = {
    soundsEnabled = true,
    musicEnabled = true
}

local cache = {}

local StreamSize = 100000
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

function Sounds.play(name)
    if not Sounds.soundsEnabled then return end
    local source = Sounds.getSource(name)
    playing[#playing+1] = source
    source:play()
end

function Sounds.playLooping(name)
    local source = Sounds.getSource(name)
    playing[#playing+1] = source
    source:setLooping(true)
    local volume = Sounds.musicEnabled and 1 or 0
    source:setVolume(volume)
    source:play()
end

local t = 0
function Sounds.update(dt)
    if math.floor(t+dt) > math.floor(t) then -- every second
        Sounds.cleanup()
    end
    t = t + dt
end

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

function Sounds.setSounds(enable)
    Sounds.soundsEnabled = enable
end

function Sounds.setMusic(enable)
    Sounds.musicEnabled = enable
    local volume = enable and 1 or 0
    for _, S in ipairs(playing) do
        S:setVolume(volume)
    end
end

return Sounds