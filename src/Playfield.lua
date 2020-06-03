local Cell = require("src.Cell")
local Path = require("src.Path")

local Playfield = {
}
Playfield.__index = Playfield

function Playfield:new(config, o)
    o = o or {}
    setmetatable(o, Playfield)
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
        end
    end

    return o
end

function Playfield:update(dt)
    self.path:update(dt)
end

function Playfield:draw()
    self.path:draw()
    for _, C in ipairs(self.cells) do
        C:draw()
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
    local newCells = {}
    for _, C in ipairs(self.cells) do
        if not C.remove then
            newCells[#newCells+1] = C
        end
    end
    print(#newCells)
    self.cells = newCells
end

setmetatable(Playfield, {__call=Playfield.new})
return Playfield
