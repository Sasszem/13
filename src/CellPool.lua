local CellPool = {}

function CellPool:new(game)
    local o = {}
    setmetatable(o, {__index = CellPool})


    o.game = game
    o.cells = {}

    local N = game.config.Playfield.size
    o.needAdd = {}
    for i=1, N do
        o.needAdd[i] = N
    end
    game.TM:delayed(o.addCells, 0.2, o, true)

    return o
end
setmetatable(CellPool, {__call = CellPool.new})


function CellPool:findAbove(cell)
    -- find every cell above given one

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

function CellPool:addCells(fast)
    self.game.TM:run(require("src.tasks.addCells"), self, fast)
end

return CellPool