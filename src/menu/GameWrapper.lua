local GameWrapper = Label("", {placement = "fill"}, "game")
local Config = require("src.Config")
local Game = require("src.Game")

local config = Config.get()

function GameWrapper:newGame()
    self.game = Game(config)
end

function GameWrapper:draw()
    self.game:draw()
end

function GameWrapper:update(dt)
    if self.game then
        self.game:update(dt)
    end
end

function GameWrapper:mousemove(x, y)
    if self.game then
        self.game:touchMove(x, y)
    end
end

function GameWrapper:mousereleased(x, y)
    if self.game then
        self.game:touchEnd()
    end
end

return GameWrapper