-- label and button styles
local LS = require("src.menu.labelStyle")
local BS = require("src.menu.buttonStyle")

local L = require("src.Local")

local GameEndScreen = VDiv(
    Label(L["gameover"], LS, "gameOverLbl"),
    Label("gameScorePlaceholder", LS, "resultLbl"),
    Button(L["backtomainmenu"], BS, "backToMenuBtn"),
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