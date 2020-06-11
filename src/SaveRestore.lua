local SaveRestore = {}

local CELLSFILE = "CELLS.SAV"

function SaveRestore.save(game)
    local file = love.filesystem.newFile(CELLSFILE, "w")
    for _, cell in ipairs(game.cells.cells) do
        file:write(("%s %s %s %s\n"):format(cell.x, cell.y, cell.value, cell.column))
    end
    file:close()
end

function SaveRestore.load(game)
    local info = love.filesystem.getInfo(CELLSFILE)
    if not info then return end

    cellsData = {}
    for line in love.filesystem.lines(CELLSFILE) do
        local lineData = {}
        for w in line:gmatch("[0-9.]+") do
            lineData[#lineData+1] = tonumber(w)
        end
        cellsData[#cellsData+1] = lineData
    end

    for i=1, #cellsData do
        game.cells.cells[i].x = cellsData[i][1]
        game.cells.cells[i].y = cellsData[i][2]
        game.cells.cells[i].value = cellsData[i][3]
        game.cells.cells[i].column = cellsData[i][4]
        print(("x=%s y=%s v=%s"):format(game.cells.cells[i].x, game.cells.cells[i].y, game.cells.cells[i].value))
    end
end

return SaveRestore