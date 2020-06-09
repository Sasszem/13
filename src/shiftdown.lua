local Cell = require("src.Cell")
local Sounds = require("src.Sounds")

local function shiftdown(playfield)
    -- config locals
    local Tdown = 0.25
    local Tappear = 0.2

    local t = 0
    while t<Tdown do
        local dt = coroutine.yield()
        t = t + dt
        for C, _ in pairs(playfield.needShiftdown) do
            C.y = math.min(C.sourceY + (C.targetY - C.sourceY)*t / Tdown, C.targetY)
        end
    end
    -- add back the cells
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
            delay = delay + 0.2
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
                Sounds.play("pop")
                cell.scale = 1
                toAnimate = toAnimate - 1
            end
        end
    end
end

return shiftdown