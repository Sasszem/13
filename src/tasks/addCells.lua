-- tasks/addCells.lua
-- a function to add cells and setup grow animation

local Cell = require("src.Cell")

function addCells(cellPool, fast)
    -- delay to apply before animation
    local delay = 0

    cellPool.sizeAnim = {}
    -- cell -> animation time

    -- how many cells are still animating
    cellPool.toAnimate = 0

    local P = cellPool.game.config.Playfield
    local C = cellPool.game.config.Cell
    for i=1, P.size do
        while (cellPool.needAdd[i] or 0) > 0 do
            local cell = Cell(cellPool.game.config)
            cellPool.cells[#cellPool.cells + 1] = cell
            cell.x = P.x + (C.size + P.gap) * (i-1)
            cell.y = P.y + (C.size + P.gap) * (cellPool.needAdd[i]-1)
            cell.column = i
            cell.scale = 0
            cellPool.sizeAnim[cell] = -delay
            cellPool.needAdd[i] = cellPool.needAdd[i] - 1
            delay = delay + (fast and 0.01 or 0.2)
            cellPool.toAnimate = cellPool.toAnimate + 1
        end
    end
end

return addCells