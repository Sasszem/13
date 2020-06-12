local Cell = require("src.Cell")
local Sounds = require("src.Sounds")

local function shiftdown(playfield)
    -- animation time constant
    local Tdown = 0.25

    local t = 0
    while t<Tdown do
        -- update time
        local dt = coroutine.yield()
        t = t + dt

        -- linear interpolation for every cell
        for C, _ in pairs(playfield.needShiftdown) do
            C.y = math.min(C.sourceY + (C.targetY - C.sourceY)*t / Tdown, C.targetY)
        end
    end

    -- clear source and target to avoid accidental reuse
    for _, C in ipairs(playfield.cells) do
        C.targetY = nil
        C.sourceY = nil
    end

    -- add new cells
    playfield:addCells()
end

return shiftdown