-- Path.lua
-- class representing the path connecting the cells
-- handles adding, removing and merging animation


local Cell = require("src.Cell")
local Sounds = require("src.Sounds")


local Path = {}
Path.__index = Path

-- constructor
function Path:new(game, config, o)
    o = o or {}
    setmetatable(o, Path)

    o.config = config
    o.elements = {}
    o.game = game

    return o
end


-- add or remove a cell if possible
-- called by game
function Path:add(cell)
    -- trigger adding or removing of a cell

    -- disallow any action while animating to prevent funny effects
    if self:animating() then return end

    -- cell removing
    -- (if cell is previous-to-last in path, remove it)
    if #self.elements>1 then
        if cell == self.elements[#self.elements-1] then
            self.elements[#self.elements] = nil
        end
    end

    -- adding it if can add
    if self:canAdd(cell) then
        self.elements[#self.elements+1] = cell
    end
end


-- check if a cell can be added
-- used by add
function Path:canAdd(cell)
    -- if empty, only allow ones
    if #self.elements == 0 then
        return cell.value == 1
    end

    -- do not allow adding the same twice (while holding the mouse)
    if self.elements[#self.elements] == cell then return end

    -- special case: 1-1 -> 2
    if #self.elements == 1 and cell.value==1 then
        return self:canAddByPosition(cell)
    end

    -- do not allow 1-1-2
    if #self.elements==2 and self.elements[2].value == 1 then
        return false
    end

    -- if incremental, check position
    if cell.value == (self.elements[#self.elements].value + 1) then
        return self:canAddByPosition(cell)
    end
end


-- check id a cell can be added by position
-- used by canAdd
function Path:canAddByPosition(cell)
    -- distances
    local dX = math.abs(cell.x - self.elements[#self.elements].x)
    local dY = math.abs(cell.y - self.elements[#self.elements].y)

    -- max distance - 110% because I do not trust float math
    local maxD = (self.config.Cell.size + self.config.Playfield.gap)*1.1

    return (dX <= maxD) and (dY <= maxD)
end


-- draw the path only
function Path:drawPath()
    -- only if not merging
    if self.mergeCell then return end

    -- only if having at least 2 elements
    if #self.elements < 2 then return end


    -- draw line segments
    love.graphics.setLineWidth(self.config.Path.width)
    love.graphics.setColor(self.config.Path.color)

    local x, y = self.elements[1].x, self.elements[1].y
    for i=2, #self.elements do
        local xn, yn = self.elements[i].x, self.elements[i].y
        love.graphics.line(x, y, xn, yn)
        x, y = xn, yn
    end
end


-- draw merge cells
function Path:drawMerge()
    -- need 2 separate draws because of layering
    if self.mergeCell then
        self.mergeCell:draw()
    end
end


-- remove all elements and merge cell
-- called at the end of the merging animation
function Path:clear()
    self.elements = {}
    self.mergeCell = nil
end


-- check if some animation is running
function Path:animating()
    return self.game.animating
end


-- merge the cells if possible
-- called by game
-- returns if merging is successful
function Path:merge()
    -- don't do a thing if still animating
    if self:animating() then return end

    -- merge if possible, if not, clear
    if #self.elements < 2 then
        self:clear()
        return
    end

    self.game.undo:backup()
    self.game.TM:run(self.mergeAnimation, self)
    return true
end

-- at which value to win the game
local VICTORYVALUE = 13

-- merge animation async task
function Path:mergeAnimation()
    self.game.animating = true

    -- config local:
    -- how long should it take to animate between two cells
    -- (in seconds)
    local T = 0.25

    self.mergeCell = Cell(self.config)
    self.mergeCell.value = self.elements[1].value

    -- for each move
    for i=2, #self.elements do
        local t = 0
        -- move time

        local toX, toY = self.elements[i].x, self.elements[i].y
        -- goal coordinates

        local fromX, fromY = self.elements[i-1].x, self.elements[i-1].y
        -- starting coordinates

        local currElem = self.elements[i]
        -- current target cell

        self.elements[i-1].remove = true
        -- mark prev cell as remove (hides it)

        while t < T do
            local dt = coroutine.yield()
            t = t + dt
            self.mergeCell.x = fromX + (toX - fromX)*t/T
            self.mergeCell.y = fromY + (toY - fromY)*t/T
        end

        currElem.value = currElem.value + 1

        -- if new biggest cell yet in the game, play sound
        -- play victory sound and set flag if we won
        if currElem.value > self.game.biggestYet then
            if currElem.value == VICTORYVALUE then
                self.game.gameEnded = true
            else
                Sounds.play("newBiggest")
            end
            self.game.biggestYet = currElem.value
        end

        Sounds.play("click")
        self.mergeCell.value = currElem.value
    end

    -- clearup
    self:clear()

    -- start other animations
    self.game.cells:afterMerge()
end


setmetatable(Path, {__call=Path.new})
return Path