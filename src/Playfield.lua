local Cell = require("src.Cell")
local Path = require("src.Path")
local shiftdown = require("src.shiftdown")

local Playfield = {
}
Playfield.__index = Playfield

function Playfield:new(config, o)
    o = o or {}
    setmetatable(o, Playfield)
    o.config = config
    o.x = config.Playfield.x
    o.y = config.Playfield.y
    o.size = config.Playfield.size
    o.gap = config.Playfield.gap
    o.path = Path(o, config)
    o.cells = {}
    for i=1, o.size do
        for j=1, o.size do
            o.cells[#o.cells + 1] = Cell(config)
            o.cells[#o.cells].x = o.x + (config.Cell.size + o.gap) * (i-1)
            o.cells[#o.cells].y = o.y + (config.Cell.size + o.gap) * (j-1)
            o.cells[#o.cells].column = i
            --o.cells[#o.cells].value = (j-1)*o.size + i
        end
    end

    return o
end

function Playfield:update(dt)
    self.path:update(dt)
    if self.shiftdownTask then
        local cont, err = coroutine.resume(self.shiftdownTask, dt)
        if not cont then
            if err~="cannot resume dead coroutine" then
                print(err)
            end
            self.shiftdownTask = nil
        end
    end
end

function Playfield:draw()
    self.path:draw()
    for _, C in ipairs(self.cells) do
        C:draw()
    end
    self.path:drawMerge()
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
    self.shiftdownTask = coroutine.create(shiftdown)
    coroutine.resume(self.shiftdownTask, self)
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
