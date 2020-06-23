-- menu/menu.lua
-- main menu assembly from UI fragments
-- forwards most event handlers

require("yalg.yalg")

-- fragment imports
local MainMenu = require("src.menu.MainMenu")
local GameWrapper = require("src.menu.GameWrapper")
local Highscores = require("src.menu.HighscoresMenu")
local GameEndScreen = require("src.menu.GameEndScreen")
local OptionsMenu = require("src.menu.OptionsMenu")


local Menu = GUI(
    Switcher(
        GameWrapper,
        Highscores,
        GameEndScreen,
        OptionsMenu,
        MainMenu,
        {},
        "switcher"
    ),
    {
        font = Font(30, "asset/Oregano-Regular.ttf")
    }
)


--------------------
-- event forwards --
--------------------

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

    -- save and quit game if in game
    if sel == "game" then
        self:getWidget("game"):quit()
    end

    -- exit application if in main menu
    if sel == "mainMenu" then
        love.event.quit()
    end

    -- just go back to main menu
    self:getWidget("switcher").selected = "mainMenu"
end


return Menu
