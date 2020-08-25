-- menu/MainMenu.lua
-- Main menu UI fragment

-- imports
local Y = require("yalg.yalg")
local BS = require("src.menu.buttonStyle")
local L = require("src.Local")

--------------------
-- UI declaration --
--------------------

local MainMenu = Y.VDiv(
    Y.Label("XIII", {font=Y.Font(60, "asset/Oregano-Regular.ttf"), span = 2}, "titleLbl"),
    Y.Button(L["normal"], BS, "btnNormal"),
    Y.Button(L["timed"], BS, "btnTimed"),
    Y.Button(L["highscores"], BS, "btnHighscores"),
    Y.Button(L["options"], BS, "btnOptions"),
    Y.Button(L["about"], BS, "btnAbout"),
    Y.Button(L["exit"], BS, "btnExit"),
    {
        placement = "center",
        gap = 10,
    },
    "mainMenu"
)


----------------------
-- Button callbacks --
----------------------

-- normal mode button
function MainMenu.widgets.btnNormal.style:click(x, y, button)
    self:getWidget("game"):newGame("normal")
    self:getWidget("switcher").selected = "game"
end

-- timed mode button
function MainMenu.widgets.btnTimed.style:click(x, y, button)
    self:getWidget("game"):newGame("timed")
    self:getWidget("switcher").selected = "game"
end

-- highscores button
function MainMenu.widgets.btnHighscores.style:click(x, y, button)
    self:getWidget("highscores"):loadHighscores()

    -- quick fix: back button sometimes getting covered by status bar on android
    self:getWidget("GUI#1"):resize(love.graphics.getWidth(), love.graphics.getHeight())

    self:getWidget("switcher").selected = "highscores"
end

-- options button
function MainMenu.widgets.btnOptions.style:click()
    self:getWidget("switcher").selected = "options"
end

-- options button
function MainMenu.widgets.btnAbout.style:click()
    self:getWidget("switcher").selected = "about"
end


-- exit button
function MainMenu.widgets.btnExit.style:click(x, y, button)
    love.event.quit()
end


return MainMenu
