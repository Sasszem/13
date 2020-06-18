-- Game.lua
-- class representing the game itself

-- component imports
local Path = require("src.Path")
local TasksManager = require("src.TaskManager")
local CellPool = require("src.CellPool")
local SaveRestore = require("src.SaveRestore")
local Undo = require("src.Undo")
local Highscores = require("src.Highscores")

local Game = {
}
Game.__index = Game


function Game:new(config, parentWidget, gamemode)
    local o = {}
    setmetatable(o, Game)

    -- constructor parameters
    o.config = config
    o.parentWidget = parentWidget
    o.gamemode = gamemode

    -- components
    o.path = Path(o, config)
    o.TM = TasksManager()
    o.undo = Undo(o)
    o.cells = CellPool(o)

    -- game state
    o.time = ((gamemode == "timed") and 300) or 0
    o.biggestYet = 2

    -- load saved game
    SaveRestore.load(o)

    -- time updater
    o.TM:periodic(function (game)
        local dt = game.gamemode == "normal" and 1 or -1
        game.time = game.time + dt
    end, 1, 0, o)


    -- time's up detector task
    if gamemode == "timed" then
        o.TM:run(function (game)
            while game.time > 0 do
                coroutine.yield()
            end
            game.gameEnded = true
            game:endGame()
        end, o)
    end

    return o
end


function Game:drawInfo()
    -- draw time
    love.graphics.setFont(self.config.gameFont)
    love.graphics.setColor(rgb(255, 255, 255))
    love.graphics.printf(
        ("%d:%02d"):format(
            math.floor(self.time / 60),
            self.time % 60),
        0, 10*self.config.hP, self.config.width, "center"
    )
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


-- mouse / touch moved
function Game:touchMove(x, y)
    -- ignore if mouse is not held down
    if not love.mouse.isDown(1, 2, 3) then return end

    local cell = self.cells:findCell(x, y)
    if not cell then return end

    -- Path handles condition checking, adding or removing
    self.path:add(cell)
end


function Game:touchEnd(x, y)
    self.path:merge()
end


function Game:quit()
    if self.gameEnded then return end

    -- fast-forward to finish all animations
    while self.animating do
        love.update(0.01)
    end

    SaveRestore.save(self)
end

function Game:endGame()
    SaveRestore.remove(self.gamemode)
    Highscores.update(self.gamemode, self.time, self.biggestYet)
    self.parentWidget:quit()
end


function Game:undoMove()
    self.undo:restore()
end


setmetatable(Game, {__call=Game.new})
return Game
