local Cell = require("src.Cell")
local Sounds = require("src.Sounds")

local function shiftdown(playfield)
    -- config locals
    local Tdown = 0.25

    local t = 0
    while t<Tdown do
        local dt = coroutine.yield()
        t = t + dt
        for C, _ in pairs(playfield.needShiftdown) do
            C.y = math.min(C.sourceY + (C.targetY - C.sourceY)*t / Tdown, C.targetY)
        end
    end
    playfield:addCells()
end

return shiftdown