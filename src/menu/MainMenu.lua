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
    self:getWidget("game"):newGame()
    self:getWidget("switcher").selected = "game"
end

function MainMenu.widgets.btnExit.style:click(x, y, button)
    love.event.quit()
end

return MainMenu