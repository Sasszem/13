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
    o.scale = 1
    setmetatable(o, Cell)
    return o
end

function Cell:draw()
    if self.remove then return end
    love.graphics.push()
    love.graphics.translate(self.x, self.y)
    love.graphics.scale(self.scale, self.scale)
    love.graphics.translate(-self.x, -self.y)
    local s = self.size
    love.graphics.setColor(CellColors[self.value] or rgb(255, 255, 255))
    love.graphics.rectangle("fill", self.x-s/2, self.y-s/2, s, s)
    local font = self.config.gameFont
    local h = font:getHeight()
    love.graphics.setColor(rgb(0, 0, 0))
    love.graphics.printf(self.value, font, self.x-s/2, self.y - h/2, s, "center")
    love.graphics.pop()
end

function Cell:inside(x, y)
    local iX = self.x - self.size / 2 < x and x < self.x + self.size / 2
    local iY = self.y - self.size / 2 < y and y < self.y + self.size / 2
    return iX and iY
end

setmetatable(Cell, {__call = Cell.new})
return Cell
