local SaveRestore = {}


-- filename template to save cell info into
local CELLSFILE = "CELLS-%s.SAV"

-- filename for game data
-- (score, time, biggestYet)
local GAMEDATAFILE = "GAME-%s.SAV"


--------------------
-- SAVING SECTION --
--------------------


-- write each cell into the file, one at a line
local function saveCells(cells, gamemode)
    local file = love.filesystem.newFile(CELLSFILE:format(gamemode), "w")

    for _, cell in ipairs(cells) do
        file:write(("%s %s %s %s\n"):format(cell.x, cell.y, cell.value, cell.column))
    end

    file:close()
end


-- write game data into file, in k-v pairs
local function saveGameData(game, gamemode)

    local file = love.filesystem.newFile(GAMEDATAFILE:format(gamemode), "w")

    -- what to save
    local toSave = {"score", "time", "biggestYet" }

    for _, k in ipairs(toSave) do
        file:write(("%s:%s\n"):format(k, game[k]))
    end

    file:close()
end

-- public API
function SaveRestore.save(game)
    saveCells(game.cells.cells, game.gamemode)
    saveGameData(game, game.gamemode)
end


---------------------
-- LOADING SECTION --
---------------------


-- only load to memory and return data
local function loadCellsData(gamemode)
    -- check if file exists
    local info = love.filesystem.getInfo(CELLSFILE:format(gamemode))
    if not info then return end

    -- load each cell
    local cellsData = {}
    for line in love.filesystem.lines(CELLSFILE:format(gamemode)) do
        -- each cell is encoded in a line
        -- convert to numbers
        local lineData = {}
        for w in line:gmatch("[0-9.]+") do
            lineData[#lineData+1] = tonumber(w)
        end
        cellsData[#cellsData+1] = lineData
    end

    return cellsData
end


function loadGameData(gamemode)
    local info = love.filesystem.getInfo(GAMEDATAFILE:format(gamemode))
    if not info then return end
    -- check if file exists

    -- load backed-up k-v pairs
    local values = {}
    for line in love.filesystem.lines(GAMEDATAFILE:format(gamemode)) do
        local key, value = line:match("(.+):(.+)")
        -- getting to love regex I am...
        values[key] = tonumber(value)
    end

    return values
end

-- public API
-- also apply data to game if sucessfuly loaded
function SaveRestore.load(game)
    local cellsData = loadCellsData(game.gamemode)
    local gameData = loadGameData(game.gamemode)

    -- don't do partial loads
    if not (cellsData and gameData) then return end

    game.loadedCells = cellsData
    -- apply loaded game data
    for k, v in pairs(gameData) do
        game[k] = v
    end
end


-------------------
-- REMOVE SECTION --
-------------------

--- remove saved game data
function SaveRestore.remove(gamemode)
    love.filesystem.remove(CELLSFILE:format(gamemode))
    love.filesystem.remove(GAMEDATAFILE:format(gamemode))
end


return SaveRestore