local Cell = require("src.Cell")
local Path = require("src.Path")
local Tasks = require("src.Tasks")
local shiftdown = require("src.shiftdown")
local addCells = require("src.addCells")

local Playfield = {
}
Playfield.__index = Playfield

function Playfield:new(config, o)
    o = o or {}
    setmetatable(o, Playfield)
    o.config = config
    o.path = Path(o, config)

    local N = config.Playfield.size
    o.cells = {}
    o.needAdd = {}
    for i=1, N do
        o.needAdd[i] = N
    end
    Tasks.run(function(self)
        local t = 0
        while t < 0.2 do
            local dt = coroutine.yield()
            t = t + dt
        end
        self:addCells(true)
    end, o)
    return o
end

function Playfield:addCells(fast)
    Tasks.run(addCells, self, fast)
end

function Playfield:draw()
    self.path:draw()
    for _, C in ipairs(self.cells) do
        C:draw()
    end
    self.path:drawMerge()
end

function Playfield:resize(w, h)
    local oldW, oldH = self.config.width, self.config.height
    local dX, dY = w/oldW, h/oldH
    for _, C in ipairs(self.cells) do
        C.x = C.x * dX
        C.y = C.y * dY
    end
end

function Playfield:findCell(x,y)
    for _, cell in ipairs(self.cells) do
        if cell:inside(x, y) then
            return cell
        end
    end
end

function Playfield:touchBegin(x, y)
    local cell = self:findCell(x, y)
    if not cell then return end
    self.path:add(cell)
end

function Playfield:touchMove(x, y)
    local cell = self:findCell(x, y)
    if not cell then return end
    self.path:add(cell)
end

function Playfield:touchEnd(x, y)
    self.path:merge()
end

function Playfield:clear()
    -- make a copy from the non-marked cells
    local newCells = {}
    self.needShiftdown = {}
    self.needAdd = {}
    for _, C in ipairs(self.cells) do
        if not C.remove then
            newCells[#newCells+1] = C
        else
            -- set target Y (for shifting down) to non-marked
            self.needAdd[C.column] = (self.needAdd[C.column] or 0) + 1
            for _, N in ipairs(self:findAbove(C)) do
                N.targetY = (N.targetY or N.y) + (self.config.Cell.size + self.config.Playfield.gap)
                N.sourceY = N.y
                self.needShiftdown[N] = true
            end
        end
    end
    self.cells = newCells
    Tasks.run(shiftdown, self)
end

function Playfield:findAbove(cell)
    -- find every cell above given
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

setmetatable(Playfield, {__call=Playfield.new})
return Playfield
