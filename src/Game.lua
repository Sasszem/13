local Path = require("src.Path")
local TasksManager = require("src.TaskManager")
local CellPool = require("src.CellPool")
local SaveRestore = require("src.SaveRestore")

local Game = {
}
Game.__index = Game

function Game:new(config, o)
    o = o or {}
    setmetatable(o, Game)
    o.config = config
    o.path = Path(o, config)

    o.time = 0
    o.score = 0
    o.biggestYet = 2

    o.TM = TasksManager()

    o.cells = CellPool(o)

    o.TM:periodic(function (self)
        self.time = self.time + 1
    end, 1, 0, o)

    return o
end

function Game:drawInfo()
    -- draw score and time
    love.graphics.setFont(self.config.gameFont)
    love.graphics.setColor(rgb("#ffffff"))
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

function Game:touchBegin(x, y)
    local cell = self.cells:findCell(x, y)
    if not cell then return end
    self.path:add(cell)
end

function Game:touchMove(x, y)
    local cell = self.cells:findCell(x, y)
    if not cell then return end
    self.path:add(cell)
end

function Game:touchEnd(x, y)
    self.path:merge()
end

function Game:quit()
    -- fast-forward a second to finish all animations
    for i=1, 100 do
        love.update(0.01)
    end
    SaveRestore.save(self)
end

setmetatable(Game, {__call=Game.new})
return Game
