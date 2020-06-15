require("yalg.yalg")

local BS = require("src.menu.buttonStyle")

local GameWrapper = VDiv(
    Label("", {span=11}),
    HDiv(
        Button("Back", BS, "backFromGame"),
        Label(""),
        Button("Undo", BS, "undoBtn")
    ),
    {},
    "game"
)

-- back button
function GameWrapper.widgets.backFromGame.style:click()
    self:getWidget("game"):quit()
end

-- undo button
function GameWrapper.widgets.undoBtn.style:click()
    self:getWidget("game"):undo()
end


local Config = require("src.Config")
local Game = require("src.Game")

local config = Config.get()

function GameWrapper:newGame(gamemode)
    config:resize(self.w, self.h)
    self.game = Game(config, self, gamemode)
end

function GameWrapper:draw()
    self.game:draw()
    VDiv.draw(self)
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

function GameWrapper:quit()
    self.game:quit()

    -- pressing back OR winning 
    if not self.game.won then
        self:getWidget("switcher").selected = "mainMenu"
    else
        -- game end screen
        -- setup values
        self:getWidget("switcher").selected = "gameEnd"
        self:getWidget("gameOverLbl").text = 
            (self.game.gamemode=="normal") and "You won!" or "Time's up"
        self:getWidget("resultLbl").text = 
            (self.game.gamemode=="normal") and ("Time: %d:%02d"):format(self.game.time/60, self.game.time%60) 
            or ("Maximum value: %d"):format(self.game.biggestYet)
    end

    self.game = nil
end

function GameWrapper:undo()
    self.game:undoMove()
end

return GameWrapper