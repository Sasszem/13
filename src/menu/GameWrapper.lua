-- menu/GameWrapper.lua
-- UI fragment as a wrapper around Game and config
-- forwards drawing, updateing and other events
-- has 2 buttons: back and undo

require("yalg.yalg")
local L = require("src.Local")

-- button style
local BS = require("src.menu.buttonStyle")


-- game wrapper widget with 2 buttons (back and undo)
local GameWrapper = VDiv(
    Label("", {span=11}),
    HDiv(
        Button(L["back_ingame"], BS, "backFromGame"),
        Label(""),
        Button(L["undo"], BS, "undoBtn")
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


-- game related imports
local Config = require("src.Config")
local Game = require("src.Game")

-- config instance
local config = Config.get()

-- start a new game in specified mode
function GameWrapper:newGame(gamemode)
    config:resize(self.w, self.h)
    -- this is needed as the screen's resolution might have changed since config creation

    self.game = Game(config, self, gamemode)
end


--------------------
-- FORWARD EVENTS --
--------------------

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

    -- pressing back OR winning?
    if not self.game.gameEnded then
        self:getWidget("switcher").selected = "mainMenu"
    else
        -- game end screen
        -- setup values
        self:getWidget("switcher").selected = "gameEnd"

        self:getWidget("gameOverLbl").text =
            (self.game.gamemode=="normal") and L["won"] or L["timerend"]

        self:getWidget("resultLbl").text =
            (self.game.gamemode=="normal") and L["gameEndTime"]:format(self.game.time/60, self.game.time%60)
                or L["gameEndValue"]:format(self.game.biggestYet)
    end

    -- delete game instance
    self.game = nil
end

function GameWrapper:undo()
    self.game:undoMove()
end

return GameWrapper
