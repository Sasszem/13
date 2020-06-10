local Sounds = require("src.Sounds")
local Cell = require("src.Cell")

function addCells(playfield, fast)
    local Tappear = 0.2

    local delay = 0
    local sizeAnim = {}
    local toAnimate = 0

    local P = playfield.config.Playfield
    local C = playfield.config.Cell
    for i=1, P.size do
        while (playfield.needAdd[i] or 0) > 0 do
            local cell = Cell(playfield.config)
            playfield.cells[#playfield.cells + 1] = cell
            cell.x = P.x + (C.size + P.gap) * (i-1)
            cell.y = P.y + (C.size + P.gap) * (playfield.needAdd[i]-1)
            cell.column = i
            cell.scale = 0
            sizeAnim[cell] = -delay
            playfield.needAdd[i] = playfield.needAdd[i] - 1
            delay = delay + (fast and 0.01 or 0.2)
            toAnimate = toAnimate + 1
        end
    end
    while toAnimate > 0 do
        local dt = coroutine.yield()
        for cell, cT in pairs(sizeAnim) do
            cell.scale = math.max(cT, 0) / Tappear
            sizeAnim[cell] = sizeAnim[cell] + dt
            if sizeAnim[cell] >= 0.2 then
                sizeAnim[cell] = nil
                if not fast then 
                    Sounds.play("pop")
                end
                cell.scale = 1
                toAnimate = toAnimate - 1
            end
        end
    end
end

return addCells