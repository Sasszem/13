-- menu/HighscoresMenu.lua
-- UI fragment to show highscores
-- also handles loading of them

-- imports
local Y = require("yalg.yalg")
local Highscores = require("src.Highscores")
local L = require("src.Local")

local themefontsrc="asset/Oregano-Regular.ttf"

------------
-- STYLES --
------------

local LS = require("src.menu.labelStyle")
local BS = require("src.menu.buttonStyle")

-- new button style (centered)
local CB = {}
for k, v in pairs(BS) do
    CB[k] = v
end
CB.placement = "center"

-- new button style (for sheet chooser)
local SC = {}
for k, v in pairs(BS) do
    SC[k] = v
end

SC.borderColor = Y.rgb(108, 110, 114)
SC.activeBorder = Y.rgb(108, 110, 114)

function SC:mouseEnter(x, y)
    self.style.borderColor, self.style.activeBorder = self.style.activeBorder, self.style.borderColor
    -- do not play a sound on a sheet chooser
    -- Sounds.play("click")
end

function SC:mouseLeave(x, y)
    -- instead of changing colors, just do nothing
end


----------
-- ROWS --
----------

local rowStyle = {
    font = Y.Font(20, themefontsrc),
}

local function makeRow(i)
    return Y.HDiv(
        Y.Label("", {font = Y.Font(32, themefontsrc), span = 1}, ("result#%d"):format(i)),
        Y.Label("", {font = Y.Font(20, themefontsrc), span = 2}, ("date#%d"):format(i)),
        rowStyle
    )
end

--normal mode highscores rows
local NormalHS = Y.VDiv(
    Y.HDiv(
        Y.Label(L["highscorecolumn1"], {span = 1}),
        Y.Label(L["highscorecolumn3"], {span = 2}),
        rowStyle
    ),
    makeRow(1),
    makeRow(2),
    makeRow(3),
    makeRow(4),
    makeRow(5),
    {
        gap = 10,
    },
    "normalHS"
)

-- timed mode highscores rows
local TimedHS = Y.VDiv(
    Y.HDiv(
        Y.Label(L["highscorecolumn2"], {span = 1}),
        Y.Label(L["highscorecolumn3"], {span = 2}),
        rowStyle
    ),
    makeRow(6),
    makeRow(7),
    makeRow(8),
    makeRow(9),
    makeRow(10),
    {
        gap = 10,
    },
    "timedHS"
)


---------------------
-- Chooser buttons --
---------------------

local chooser = Y.HDiv(
    Y.Button(L["normal"], SC, "selectNormalBtn"),
    Y.Button(L["timed"], SC, "selectTimedBtn")
)

-- custom styles for chooser buttons
chooser.widgets.selectNormalBtn.style.span = 4
chooser.widgets.selectTimedBtn.style.span = 4

-- background for selected mode button
local activeBackground = Y.rgb(108, 110, 114)

-- select normal mode button
function chooser.widgets.selectNormalBtn.style:click()
    self:getWidget("hsSwitcher").selected = "normalHS"
    self:getWidget("selectTimedBtn").style.backgroundColor = BS.backgroundColor
    self.style.backgroundColor = activeBackground
end

-- select timed mode button
function chooser.widgets.selectTimedBtn.style:click()
    self:getWidget("hsSwitcher").selected = "timedHS"
    self:getWidget("selectNormalBtn").style.backgroundColor = BS.backgroundColor
    self.style.backgroundColor = activeBackground
end


-----------------------
-- Assemble the menu --
----------------------

local HighscoresMenu = Y.VDiv(
    Y.HDiv(
        Y.Label(L["highscores"], {font = Y.Font(40, themefontsrc)})
    ),
    chooser,
    Y.Switcher(
        TimedHS,
        NormalHS,
        {
            span = 5,
        },
        "hsSwitcher"
    ),
    Y.VDiv(
        Y.HDiv(
            Y.Button(L["back"], CB, "backBtn")
        )
    ),
    {
        gap = 10,
    },
    "highscores"
)

-- activate normal mode
HighscoresMenu.widgets.selectNormalBtn.style.click(HighscoresMenu.widgets.selectNormalBtn)

-- back button
function HighscoresMenu.widgets.backBtn.style:click()
    self:getWidget("switcher").selected = "mainMenu"
end


-- function to load the data into the UI
function HighscoresMenu:loadHighscores()
    -- clear prev. text
    -- (in case of deleted highscores via options)
    for i=1, 10 do
        self:getWidget(("result#%d"):format(i)).text = ""
        self:getWidget(("date#%d"):format(i)).text = ""
    end

    -- load normal mode
    local normal = Highscores.load("normal")

    for i, line in ipairs(normal) do
        local timeStr = ("%d:%02d"):format(line[1]/60, line[1]%60)
        self:getWidget(("result#%d"):format(i)).text = tostring(timeStr)
        self:getWidget(("date#%d"):format(i)).text = tostring(line[2])
    end

    -- load timed mode
    local timed = Highscores.load("timed")

    for i, line in ipairs(timed) do
        self:getWidget(("result#%d"):format(i+5)).text = tostring(line[1])
        self:getWidget(("date#%d"):format(i+5)).text = tostring(line[2])
    end
end


return HighscoresMenu
