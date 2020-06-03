local Cell = require("src.Cell")

local Playfield = {
    cells = 10,
}
Playfield.__index = Playfield

function Playfield:new(config, o)
    o = o or {}
    setmetatable(o, Playfield)
    o.x = config.Playfield.x
    o.y = config.Playfield.y
    o.size = config.Playfield.size
    o.gap = config.Playfield.gap
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

function Playfield:draw()
    for _, C in ipairs(self.cells) do
        C:draw()
    end
end

setmetatable(Playfield, {__call=Playfield.new})
return Playfield
