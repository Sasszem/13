require("src.utils")

local CellColors = {
    rgb(255, 255, 255),
    rgb(50, 200, 75), 
}


local Cell = {
    x = 0,
    y = 0,
    value = 1,
}
Cell.__index = Cell

function Cell:new(config, o)
    o = o or {}
    o.value = o.value or math.random(1, 2)
    o.config = config
    o.size = config.Cell.size
    setmetatable(o, Cell)
    return o
end

function Cell:draw()
    local s = self.size
    love.graphics.setColor(CellColors[self.value])
    love.graphics.rectangle("fill", self.x-s/2, self.y-s/2, s, s)
    local font = self.config.gameFont
    local h = font:getHeight()
    love.graphics.setColor(rgb(0, 0, 0))
    love.graphics.printf(self.value, font, self.x-s/2, self.y - h/2, s, "center")
end

setmetatable(Cell, {__call = Cell.new})
return Cell
