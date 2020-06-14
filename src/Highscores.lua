local Highscores = {}

local FILENAME = "HIGHSCORE-%s.HSC"
local KEEP = 5
-- how many highscores to keep

-- format: result-month/day hour:minute

--- load highscores
-- @param gamemode the gamemode to load highscores for
-- @return a list of result(num) - date (str) pairs
function Highscores.load(gamemode)
    -- save file name
    local fn = FILENAME:format(gamemode)

    local data = {}
    if love.filesystem.getInfo(fn) then
        -- parse each line and append to data
        for line in love.filesystem.lines(fn) do
            local entry = {}
            entry[1], entry[2] = line:match("(.+)-(.+)")
            entry[1] = tonumber(entry[1])
            data[#data+1] = entry
        end
    end

    return data
end

--- save highscore data to file. Used itnernally.
-- @param fn - the file name to save into
-- @param data a list of result-date pairs
function Highscores.save(fn, data)
    local f = love.filesystem.newFile(fn, "w")
    for _, d in ipairs(data) do
        f:write(("%s-%s\n"):format(d[1], d[2]))
    end
    f:close()
end

--- update highsocres
-- @param gamemode the current gamemode
-- @time the time of the game
-- @maximum the biggest cell value in game
function Highscores.update(gamemode, time, maximum)
    local fn = FILENAME:format(gamemode)
    
    -- load old highscores
    local scores = Highscores.load(gamemode)

    -- get current date string
    local dT = os.date("*t")
    local dateString = ("%02d/%02d %2d:%02d"):format(dT.month, dT.day, dT.hour, dT.min)

    -- result from values and gamemode
    local res = gamemode=="timed" and maximum or time

    -- construct highscores entry
    scores[#scores+1] = {res, dateString}

    -- do we need to sorty ascending or descending
    local reverse = (gamemode == "timed")

    -- sort - custom sort function only adds reverse
    table.sort(scores, function(a, b)
        if reverse then
            a, b = b, a
        end
        return a[1] < b[1]
    end)

    -- remove last entries if we have more than the target number
    while  #scores > KEEP do
        scores[#scores] = nil
    end

    -- save the highscores
    Highscores.save(fn, scores)
end

function Highscores.delete()
    love.filesystem.remove(FILENAME:format("normal"))
    love.filesystem.remove(FILENAME:format("timed"))
end

return Highscores