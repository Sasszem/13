local SaveRestore = {}


-- filename to save cell info into
local CELLSFILE = "CELLS.SAV"

-- filename for game data
-- (score, time, biggestYet)
local GAMEDATAFILE = "GAME.SAV"


--------------------
-- SAVING SECTION --
--------------------


-- write each cell into the file, one at a line
local function saveCells(cells)
    local file = love.filesystem.newFile(CELLSFILE, "w")

    for _, cell in ipairs(cells) do
        file:write(("%s %s %s %s\n"):format(cell.x, cell.y, cell.value, cell.column))
    end

    file:close()
end


-- write game data into file, in k-v pairs
local function saveGameData(game)

    local file = love.filesystem.newFile(GAMEDATAFILE, "w")

    -- what to save
    local toSave = {"score", "time", "biggestYet" }

    for _, k in ipairs(toSave) do
        file:write(("%s:%s\n"):format(k, game[k]))
    end

    file:close()
end

-- public API
function SaveRestore.save(game)
    saveCells(game.cells.cells)
    saveGameData(game)
end


---------------------
-- LOADING SECTION --
---------------------


-- only load to memory and return data
local function loadCellsData()
    -- check if file exists
    local info = love.filesystem.getInfo(CELLSFILE)
    if not info then return end

    -- load each cell
    local cellsData = {}
    for line in love.filesystem.lines(CELLSFILE) do
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


function loadGameData()
    local info = love.filesystem.getInfo(GAMEDATAFILE)
    if not info then return end
    -- check if file exists

    -- load backed-up k-v pairs
    local values = {}
    for line in love.filesystem.lines(GAMEDATAFILE) do
        local key, value = line:match("(.+):(.+)")
        -- getting to love regex I am...
        values[key] = tonumber(value)
    end

    return values
end

-- public API
-- also apply data to game if sucessfuly loaded
function SaveRestore.load(game)
    local cellsData = loadCellsData()
    local gameData = loadGameData()

    -- don't do partial loads
    if not (cellsData and gameData) then return end

    -- apply loaded cells data
    for i=1, #cellsData do
        game.cells.cells[i].x = cellsData[i][1]
        game.cells.cells[i].y = cellsData[i][2]
        game.cells.cells[i].value = cellsData[i][3]
        game.cells.cells[i].column = cellsData[i][4]
    end

    -- apply loaded game data
    for k, v in pairs(gameData) do
        game[k] = v
    end
end


-------------------
-- REMOVE SECTION --
-------------------

--- remove saved game data
function SaveRestore.remove()
    love.filesystem.remove(CELLSFILE)
    love.filesystem.remove(GAMEDATAFILE)
end


return SaveRestore