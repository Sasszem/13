-- menu/MainMenu.lua
-- Main menu UI fragment

-- imports
require("yalg.yalg")
local BS = require("src.menu.buttonStyle")


--------------------
-- UI declaration --
--------------------

local MainMenu = VDiv(
    Label("13", {font=Font(60, "asset/supercomputer.ttf"), span = 2}),
    Button("Normal", BS, "btnNormal"),
    Button("Timed", BS, "btnTimed"),
    Button("Highscores", BS, "btnHighscores"),
    Button("Options", BS, "btnOptions"),
    Button("Exit", BS, "btnExit"),
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

-- exit button
function MainMenu.widgets.btnExit.style:click(x, y, button)
    love.event.quit()
end


return MainMenu