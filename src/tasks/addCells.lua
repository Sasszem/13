local Sounds = require("src.Sounds")
local Cell = require("src.Cell")

function addCells(cellPool, fast)
    -- animation time (per cell)
    local Tappear = 0.2

    -- delay to apply before animation
    local delay = 0

    local sizeAnim = {}
    -- cell -> animation time

    -- how many cells are still animating
    local toAnimate = 0

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
            sizeAnim[cell] = -delay
            cellPool.needAdd[i] = cellPool.needAdd[i] - 1
            delay = delay + (fast and 0.01 or 0.2)
            toAnimate = toAnimate + 1
        end
    end

    -- while still have cells to animate
    while toAnimate > 0 do

        local dt = coroutine.yield()
        -- get delta-t

        -- for each cell
        for cell, cT in pairs(sizeAnim) do

            -- linear interpolation of size
            cell.scale = math.max(cT, 0) / Tappear

            -- update animation time
            sizeAnim[cell] = sizeAnim[cell] + dt

            -- play sound and remove from animation pool
            if sizeAnim[cell] >= Tappear then
                sizeAnim[cell] = nil
                if not fast then 
                    Sounds.play("pop")
                end
                -- fixup scale just in case of floating point funnyness
                cell.scale = 1
                toAnimate = toAnimate - 1
            end
        end
    end
end

return addCells