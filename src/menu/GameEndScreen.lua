local LS = require("src.menu.labelStyle")
local BS = require("src.menu.buttonStyle")

local GameEndScreen = VDiv(
    Label("Game over", LS, "gameOverLbl"),
    Label("gameScorePlaceholder", LS, "resultLbl"),
    Button("Back to main menu", BS, "backToMenuBtn"),
    {},
    "gameEnd"
)

function GameEndScreen.widgets.backToMenuBtn.style:click()
    self:getWidget("switcher").selected = "mainMenu"
end

GameEndScreen.widgets.backToMenuBtn.style.placement = "center"

return GameEndScreen