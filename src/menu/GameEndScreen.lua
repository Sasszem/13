local Y = require("yalg.yalg")

-- label and button styles
local LS = require("src.menu.labelStyle")
local BS = require("src.menu.buttonStyle")

local L = require("src.Local")

local GameEndScreen = Y.VDiv(
    Y.Label(L["gameover"], LS, "gameOverLbl"),
    Y.Label("gameScorePlaceholder", LS, "resultLbl"),
    Y.Button(L["backtomainmenu"], BS, "backToMenuBtn"),
    {},
    "gameEnd"
)


-- back button click handler
function GameEndScreen.widgets.backToMenuBtn.style:click()
    self:getWidget("switcher").selected = "mainMenu"
end

-- override placement of back button to center
GameEndScreen.widgets.backToMenuBtn.style.placement = "center"


return GameEndScreen