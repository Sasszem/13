-- tasks/growCells.lua
-- a coroutine based async task for cell appear animation

local Sounds = require("src.Sounds")

local function growCells(cellPool, fast)
    while cellPool.toAnimate == 0 do
        coroutine.yield()
    end

    -- animation time (per cell)
    local Tappear = 0.2

    local sizeAnim = cellPool.sizeAnim

    -- while still have cells to animate
    while cellPool.toAnimate > 0 do

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
                cellPool.toAnimate = cellPool.toAnimate - 1
            end
        end
    end

    -- clean up
    cellPool.sizeAnim = nil
    cellPool.game.animating = false

    -- end game if won
    if cellPool.game.gameEnded then
        cellPool.game:endGame()
    end
end

return growCells