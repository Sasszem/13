local Highscores = {}

local FILENAME = "HIGHSCORE-%s.HSC"
local KEEP = 5
-- how many highscores to keep

-- format: result-month/day hour:minute

function Highscores.load(fn)
    local data = {}
    if love.filesystem.getInfo(fn) then
        for line in love.filesystem.lines(fn) do
            local entry = {}
            entry[1], entry[2] = line:match("(.+)-(.+)")
            entry[1] = tonumber(entry[1])
            data[#data+1] = entry
        end
    end
    return data
end

function Highscores.save(fn, data)
    local f = love.filesystem.newFile(fn, "w")
    for _, d in ipairs(data) do
        print(d[0], d[1])
        f:write(("%s-%s\n"):format(d[1], d[2]))
    end
    f:close()
end

function Highscores.update(gamemode, time, maximum)
    local fn = FILENAME:format(gamemode)
    local d = Highscores.load(fn)
    local dT = os.date("*t")
    local dateString = ("%02d/%02d %2d:%02d"):format(dT.month, dT.day, dT.hour, dT.min)
    local res = gamemode=="timed" and maximum or time
    d[#d+1] = {res, dateString}
    local reverse = gamemode == "timed"
    table.sort(d, function(a, b)
        return not (reverse == (a[1]<b[1]))
    end)
    while  #d > KEEP do
        d[#d] = nil
    end
    Highscores.save(fn, d)
end

return Highscores