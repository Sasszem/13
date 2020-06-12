local Path = require("src.Path")
local TasksManager = require("src.TaskManager")
local CellPool = require("src.CellPool")
local SaveRestore = require("src.SaveRestore")
local Undo = require("src.Undo")

local Game = {
}
Game.__index = Game

function Game:new(config, parentWidget)
    local o = {}
    setmetatable(o, Game)
    o.config = config
    o.parentWidget = parentWidget

    o.path = Path(o, config)

    o.time = 0
    o.score = 0
    o.biggestYet = 2

    o.TM = TasksManager()
    o.undo = Undo(o)
    o.cells = CellPool(o)

    o.TM:periodic(function (self)
        self.time = self.time + 1
    end, 1, 0, o)

    return o
end

function Game:drawInfo()
    -- draw score and time
    love.graphics.setFont(self.config.gameFont)
    love.graphics.setColor(rgb(255, 255, 255))
    love.graphics.printf(("%d:%02d"):format(math.floor(self.time / 60), self.time % 60), 0, 10*self.config.hP, self.config.width, "center")
    love.graphics.printf(("%d"):format(self.score), 0, 15*self.config.hP, self.config.width, "center")
end

function Game:draw()
    self.path:drawPath()
    self.cells:draw()
    self.path:drawMerge()
    self:drawInfo()
end

function Game:update(dt)
    self.TM:update(dt)
end

function Game:touchMove(x, y)
    if not love.mouse.isDown(1, 2, 3) then return end
    local cell = self.cells:findCell(x, y)
    if not cell then return end
    self.path:add(cell)
end

function Game:touchEnd(x, y)
    self.path:merge()
end

function Game:quit()
    if self.won then return end

    -- fast-forward to finish all animations
    while self.animating do
        love.update(0.01)
    end
    SaveRestore.save(self)
end

function Game:endGame()
    SaveRestore.remove()
    self.parentWidget:quit()
end

setmetatable(Game, {__call=Game.new})
return Game
