-- Cell.lua
-- a class representing a single cell


------------
-- COLORS --
------------


-- HEX color to RGB color
local function hex(hexstring)
    assert(hexstring:sub(0, 1)=="#", "Color strings must be in hex format!")

    -- extract string bits
    local r = hexstring:sub(2, 3)
    local g = hexstring:sub(4, 5)
    local b = hexstring:sub(6, 7)

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

--------------------
-- Roman numerals --
--------------------
local romanNumbers = {
    "I",
    "II",
    "III",
    "IV",
    "V",
    "VI",
    "VII",
    "VIII",
    "IX",
    "X",
    "XI",
    "XII",
    "XIII",
    "XIV",
    "XV",
}


----------------
-- CELL CLASS --
----------------

local Cell = {
    x = 0,
    y = 0,
    value = 1,
}
Cell.__index = Cell

-- constructor
function Cell:new(config, o)
    o = o or {}
    o.value = o.value or (math.random(1, 4)==1 and 2 or 1)
    o.config = config
    o.scale = 1
    setmetatable(o, Cell)
    return o
end


function Cell:draw(roman)
    if self.remove then return end
    love.graphics.push()
    love.graphics.translate(self.x, self.y)
    love.graphics.scale(self.scale, self.scale)
    love.graphics.translate(-self.x, -self.y)
    local s = self.config.Cell.size
    love.graphics.setColor(CellColors[self.value] or hex("#ffffff"))
    -- love.graphics.rectangle("fill", self.x-s/2, self.y-s/2, s, s)
    rwrc(self.x-s/2, self.y-s/2, s, s, 7)
    local font = self.config.gameFont
    local h = font:getHeight()
    love.graphics.setColor(hex("#000000"))
    local text = roman and romanNumbers[self.value] or tostring(self.value)
    love.graphics.printf(text, font, self.x-s/2, self.y - h/2, s, "center")
    love.graphics.pop()
end


local right = 0
local left = math.pi
local bottom = math.pi * 0.5
local top = math.pi * 1.5

-- rounded rectangle
-- source: https://love2d.org/forums/viewtopic.php?t=11511
function rwrc(x, y, w, h, r)
    r = r or 15
    

    -- border lines
    -- without border lines, cell lines will not be blurred
    -- but, with border lines, cell will be ugly when drawing a path
    love.graphics.rectangle("line", x, y+r, w, h-r*2)
	love.graphics.rectangle("line", x+r, y, w-r*2, r)
	love.graphics.rectangle("line", x+r, y+h-r, w-r*2, r)
	love.graphics.arc("line", x+r, y+r, r, left, top)
	love.graphics.arc("line", x + w-r, y+r, r, -bottom, right)
	love.graphics.arc("line", x + w-r, y + h-r, r, right, bottom)
	love.graphics.arc("line", x+r, y + h-r, r, bottom, left)
    
    -- filling
    love.graphics.rectangle("fill", x, y+r, w, h-r*2)
	love.graphics.rectangle("fill", x+r, y, w-r*2, r)
	love.graphics.rectangle("fill", x+r, y+h-r, w-r*2, r)
	love.graphics.arc("fill", x+r, y+r, r, left, top)
	love.graphics.arc("fill", x + w-r, y+r, r, -bottom, right)
	love.graphics.arc("fill", x + w-r, y + h-r, r, right, bottom)
	love.graphics.arc("fill", x+r, y + h-r, r, bottom, left)
end


-- test if coordinates are inside a cell
-- (used by mouse cde)
function Cell:inside(x, y)
    local s = self.config.Cell.size
    local iX = self.x - s / 2 < x and x < self.x + s / 2 -- inside X
    local iY = self.y - s / 2 < y and y < self.y + s / 2 -- inside Y

    return iX and iY
end

setmetatable(Cell, {__call = Cell.new})
return Cell
