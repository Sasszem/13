-- CellPool.lua
-- Class storing all the cells in the playfield
-- and relate operations


local CellPool = {}
local SaveRestore = require("src.SaveRestore")

-- constructor
function CellPool:new(game)
    local o = {}
    setmetatable(o, {__index = CellPool})


    o.game = game
    o.cells = {}
    o:init()
    return o
end
setmetatable(CellPool, {__call = CellPool.new})

-- initializer - called by constructor
function CellPool:init()
    -- setup needAdd for addCells task to add all the cells
    -- (reusing addCells task from the merging animation)
    local N = self.game.config.Playfield.size
    self.needAdd = {}
    for i=1, N do
        self.needAdd[i] = N
    end

    -- start async tasks
    self.game.TM:run(self.loadCells, self)
    self.game.TM:delayed(self.addCells, 0.2, self, true)
end

-- find every cell above given one
-- used for gravity simulation
function CellPool:findAbove(cell)
    local result = {}
    local y = cell.y
    local column = cell.column

    for _, C in ipairs(self.cells) do
        if C.column == column then
            if C.y < y then
                result[#result+1] = C
            end
        end
    end

    return result
end


-- find cell by XY coordinates
-- used for mouse handling
function CellPool:findCell(x,y)
    -- find touched cell

    for _, cell in ipairs(self.cells) do
        if cell:inside(x, y) then
            return cell
        end
    end
end


function CellPool:draw()
    -- draw each cell
    for _, C in ipairs(self.cells) do
        C:draw()
    end
end


function CellPool:afterMerge()
    -- clear marked cells
    -- shift down (in a task)
    -- add new cells (in a task)

    -- make a copy from the non-marked cells

    local newCells = {}
    -- store non-removed cells

    self.needShiftdown = {}
    -- to shift down, we need to setup animation target when removing
    -- and also store the cells to work on

    self.needAdd = {}
    -- to add new, we need to coun how many to add per column

    -- on every cell
    for _, C in ipairs(self.cells) do

        if not C.remove then
            -- if not removed, store it
            newCells[#newCells+1] = C
        else
            -- count how many to add per column
            self.needAdd[C.column] = (self.needAdd[C.column] or 0) + 1

            -- setup or update animation for each cell above
            for _, N in ipairs(self:findAbove(C)) do
                N.targetY = (N.targetY or N.y) + (self.game.config.Cell.size + self.game.config.Playfield.gap)
                N.sourceY = N.y
                self.needShiftdown[N] = true
            end

        end
    end
    self.cells = newCells

    self.game.TM:run(require("src.tasks.shiftdown"), self)
end


-- add back the cells removed after merge
function CellPool:addCells(fast)
    require("src.tasks.addCells")(self, fast)
    self.game.TM:run(require("src.tasks.growCells"), self, fast)
end


-- load saved game
function CellPool:loadCells()
    -- wait until cells are added
    -- e.g needAdd contains all zeroes
    -- e.g sum is zero
    while true do
        local sum = 0
        for _, i in ipairs(self.needAdd) do
            sum = sum + i
        end

        if sum == 0 then break end

        coroutine.yield()
    end

    -- apply loaded cells data from game
    local cellsData = self.game.loadedCells

    if not cellsData then return end

    for i=1, #cellsData do
        self.cells[i].x = cellsData[i][1]
        self.cells[i].y = cellsData[i][2]
        self.cells[i].value = cellsData[i][3]
        self.cells[i].column = cellsData[i][4]
    end

    -- remove loaded data
    self.game.loadedCells = nil
end

return CellPool