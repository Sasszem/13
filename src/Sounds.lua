-- Sounds.lua
-- play sounds & music
-- handles loading and caching of sources
-- sounds and music can be muted


local Sounds = {
    soundsEnabled = true,
    musicEnabled = true,

    clone = true,
    -- do we need to clone the sound or use a single source
    -- later is required by love.js's limitations
}

local cache = {}
local tasks = {}

-- get a sound from cache
-- load it into cache if necessary
-- and determine preferred mode based on file size
function Sounds.getSource(name)
    -- fill in cache
    if not cache[name] then
        local filename = ("asset/%s.ogg"):format(name)
        local fileInfo = assert(
            love.filesystem.getInfo(filename),
            ("Requested sound file %s can not be found!"):format(filename)
        )
        local fileSize = fileInfo.size
        cache[name] = love.audio.newSource(filename, "static")
    end

    local s = cache[name]
    if Sounds.clone then
        s = s:clone()
    end
    return s
end

local playing = {}

-- play a short sound effect
function Sounds.play(name)
    -- muted?
    if not Sounds.soundsEnabled then return end

    local source = Sounds.getSource(name)
    if Sounds.clone then
        playing[source] = true
    end
    source:play()
end

-- play a sound looping (background music)
function Sounds.playLooping(name)
    local source = Sounds.getSource(name)
    Sounds.fadeOut()
    if Sounds.clone then
        playing[source] = true
    end

    source:setLooping(true)

    -- mute if necessary
    local volume = Sounds.musicEnabled and 1 or 0
    source:setVolume(volume)
    source:play()
end

-- start and queue a coroutine for every playing sound
-- that fades then stops them
-- they will be called from update
function Sounds.fadeOut()
    local TIME = 0.2

    for S, _ in pairs(playing) do
        local t = coroutine.create(function(s)
            local t = TIME
            while t > 0 do
                local dt = coroutine.yield()
                t = t - dt
                s:setVolume(t/TIME)
            end
            s:setVolume(0)
            s:stop()
            playing[s] = nil
        end)
        coroutine.resume(t, S)
        tasks[t] = true
    end
end

-- update function
-- calls cleanup every second
local t = 0
function Sounds.update(dt)
    -- from TaskManager.lua
    for T, _ in pairs(tasks) do
        local cont, err = coroutine.resume(T, dt)
        if not cont then
            if err~="cannot resume dead coroutine" then
                print(err)
            end
            tasks[T] = nil
        end
    end
    if math.floor(t+dt) > math.floor(t) then -- every second
        Sounds.cleanup()
    end
    t = t + dt
end


-- remove stopped sources from list
function Sounds.cleanup()
    if not Sounds.clone then return end
    for sound, _ in pairs(playing) do
        if not sound:isPlaying() then
            playing[sound] = nil
            sound:release()
        end
    end
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
    for S, _ in pairs(playing) do
        S:setVolume(volume)
    end
end


return Sounds