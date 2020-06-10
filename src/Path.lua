local Cell = require("src.Cell")
local Sounds = require("src.Sounds")
local Tasks = require("src.Tasks")

local Path = {}
Path.__index = Path


function Path:new(playfield, config, o)
    o = o or {}
    setmetatable(o, Path)
    o.config = config
    o.elements = {}
    o.biggestYet = 2
    o.playfield = playfield
    return o
end

function Path:add(cell)
    if self:animating() then return end
    if #self.elements>1 then
        if cell == self.elements[#self.elements-1] then
            self.elements[#self.elements] = nil
        end
    end
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
    if #self.elements==2 and self.elements[2].value == 1 then
        return false
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
    if self.mergeCell then return end
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

function Path:drawMerge()
    if self.mergeCell then
        self.mergeCell:draw()
    end
end

function Path:clear()
    self.elements = {}
    self.mergeCell = nil
end

function Path:animating()
    return self.mergeTask or self.playfield.shiftdownTask
end

function Path:merge()
    if #self.elements < 2 or self:animating() then
        self:clear()
        return
    end
    Tasks.run(self.mergeAnimation, self)
end

function Path:update(dt)
    --print("Updating")
    if self.mergeTask then
        local cont, err = coroutine.resume(self.mergeTask, dt)
        if not cont then
            self.mergeTask = nil
            if err~="cannot resume dead coroutine" then
                print(err)
            end
        end
    end
end

function Path:mergeAnimation()
    -- config local:
    -- how long should it take to animate between two cells
    -- (in seconds)
    local T = 0.25

    self.mergeCell = Cell(self.config)

    self.mergeCell.value = self.elements[1].value
    for i=2, #self.elements do
        local t = 0
        local toX, toY = self.elements[i].x, self.elements[i].y
        local x, y = self.elements[i-1].x, self.elements[i-1].y
        local stepX = (toX - x)/T
        local stepY = (toY - y)/T
        local currElem = self.elements[i]
        self.elements[i-1].remove = true
        while t < T do
            local dt = coroutine.yield()
            t = t + dt
            x = x + stepX * dt
            y = y + stepY * dt
            self.mergeCell.x = x
            self.mergeCell.y = y
        end
        currElem.value = currElem.value + 1
        if currElem.value > self.biggestYet then
            Sounds.play("newBiggest")
            self.biggestYet = currElem.value
        end
        Sounds.play("click")
        self.mergeCell.value = currElem.value
    end
    self:clear()
    self.playfield:clear()
end

setmetatable(Path, {__call=Path.new})
return Path