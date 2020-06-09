local Sounds = {}

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
    local source = Sounds.getSource(name)
    playing[#playing+1] = source
    source:play()
end

function Sounds.playLooping(name)
    local source = Sounds.getSource(name)
    playing[#playing+1] = source
    source:setLooping(true)
    source:play()
end

return Sounds