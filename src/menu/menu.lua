local MainMenu = require("src.menu.MainMenu")
local GameWrapper = require("src.menu.GameWrapper")
local Highscores = require("src.menu.HighscoresMenu")
require("yalg.yalg")

local Menu = GUI(
    Switcher(
        GameWrapper,
        Highscores,
        MainMenu,
        {},
        "switcher"
    ),
    {
        font = Font(30, "asset/supercomputer.ttf")
    }
)

function Menu:update(dt)
    self:getWidget("game"):update(dt)
    GUI.update(self)
end

function Menu:mousemove(x, y)
    self:getWidget("game"):mousemove(x, y)
end

function Menu:mousereleased(x, y)
    self:getWidget("game"):mousereleased(x, y)
end

function Menu:keypressed(key)
    local sel = self:getWidget("switcher").selected
    if sel == "game" then
        self:getWidget("game"):quit()
    end
end

return Menu