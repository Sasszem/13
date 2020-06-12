-- HEX color to RGB color
local function hex(hexstring)
    assert(hexstring:sub(0, 1)=="#", "Color strings must be in hex format!")

    -- extract string bits
    r = hexstring:sub(2, 3)
    g = hexstring:sub(4, 5)
    b = hexstring:sub(6, 7)

    -- convert to decimal
    r = tonumber(r, 16)
    g = tonumber(g, 16)
    b = tonumber(b, 16)

    return {r/255, g/255, b/255}
end

local CellColors = {
    hex("#eeeeec"),
    hex("#8ae234"),
    hex("#729fcf"),
    hex("#ad7fa8"),
    hex("#ef2929"), -- 5
    hex("#edd400"),
    hex("#3465a4"),
    hex("#f57900"),
    hex("#babdb6"),
    hex("#cc0000"), -- 10
    hex("#c4a000"),
    hex("#204a87"),
    hex("#4e9a06"),
    hex("#5c3566"),
    hex("#a40000"), -- 15
}


local Cell = {
    x = 0,
    y = 0,
    value = 1,
}
Cell.__index = Cell

function Cell:new(config, o)
    o = o or {}
    o.value = o.value or (math.random(1, 4)==1 and 2 or 1)
    o.config = config
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
    local s = self.config.Cell.size
    love.graphics.setColor(CellColors[self.value] or hex("#ffffff"))
    love.graphics.rectangle("fill", self.x-s/2, self.y-s/2, s, s)
    local font = self.config.gameFont
    local h = font:getHeight()
    love.graphics.setColor(hex("#000000"))
    love.graphics.printf(self.value, font, self.x-s/2, self.y - h/2, s, "center")
    love.graphics.pop()
end

function Cell:inside(x, y)
    local s = self.config.Cell.size
    local iX = self.x - s / 2 < x and x < self.x + s / 2
    local iY = self.y - s / 2 < y and y < self.y + s / 2
    return iX and iY
end

setmetatable(Cell, {__call = Cell.new})
return Cell
