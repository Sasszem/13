require("yalg.yalg")
local BS = require("src.menu.buttonStyle")

local MainMenu = VDiv(
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

function MainMenu.widgets.btnNormal.style:click(x, y, button)
    self:getWidget("game"):newGame("normal")
    self:getWidget("switcher").selected = "game"
end

function MainMenu.widgets.btnTimed.style:click(x, y, button)
    self:getWidget("game"):newGame("timed")
    self:getWidget("switcher").selected = "game"
end

function MainMenu.widgets.btnHighscores.style:click(x, y, button)
    self:getWidget("highscores"):loadHighscores()

    -- quick fix: back button sometimes getting covered
    self:getWidget("GUI#1"):resize(love.graphics.getWidth(), love.graphics.getHeight())

    self:getWidget("switcher").selected = "highscores"
end

function MainMenu.widgets.btnExit.style:click(x, y, button)
    love.event.quit()
end

return MainMenu