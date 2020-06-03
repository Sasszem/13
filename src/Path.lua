local Path = {}
Path.__index = Path


function Path:new(config, o)
    o = o or {}
    setmetatable(o, Path)
    o.config = config
    o.elements = {}
    return o
end

function Path:add(cell)
    if self:canAdd(cell) then
        self.elements[#self.elements+1] = cell
    end
end

function Path:canAdd(cell)
    if #self.elements == 0 then
        return cell.value == 1
    end
    if self.elements[#self.elements] == cell then return end
    if #self.elements == 1 and cell.value==1 then
        return self:canAddByPosition(cell)
    end
    if cell.value == (self.elements[#self.elements].value + 1) then
        return self:canAddByPosition(cell)
    end
end

function Path:canAddByPosition(cell)
    local dX = math.abs(cell.x - self.elements[#self.elements].x)
    local dY = math.abs(cell.y - self.elements[#self.elements].y)
    local maxD = (self.config.Cell.size + self.config.Playfield.gap)*1.1
    local ex = dX<=maxD and dY<=maxD
    return ex
end

function Path:draw()
    if #self.elements < 2 then return end
    love.graphics.setLineWidth(self.config.Path.width)
    love.graphics.setColor(self.config.Path.color)
    local x, y = self.elements[1].x, self.elements[1].y
    for i=2, #self.elements do
        local xn, yn = self.elements[i].x, self.elements[i].y
        love.graphics.line(x, y, xn, yn)
        x, y = xn, yn
    end
end

function Path:clear()
    self.elements = {}
end

setmetatable(Path, {__call=Path.new})
return Path