require("yalg.yalg")
local Highscores = require("src.Highscores")

------------
-- STYLES --
------------

local LS = require("src.menu.labelStyle")
local BS = require("src.menu.buttonStyle")

local rowStyle = {
    border = 3,
    borderColor = rgb(77, 77, 255),
    font = Font(20, "asset/supercomputer.ttf")
}

-- row template
local function makeRow(i)
    return HDiv(
        Label("", LS, ("result#%d"):format(i)),
        Label("", LS, ("date#%d"):format(i)),
        rowStyle
    )
end

--normal mode highscores rows
local NormalHS = VDiv(
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
local TimedHS = VDiv(
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

-- chosser buttons
local chooser = HDiv(
    Label(""),
    Button("Normal", BS, "selectNormalBtn"),
    Label(""),
    Button("Timed", BS, "selectTimedBtn"),
    Label("")
)

-- custom styles for chooser buttons
chooser.widgets.selectNormalBtn.style.span = 4
chooser.widgets.selectTimedBtn.style.span = 4

-- background for selected mode button
local activeBackground = rgb(0, 102, 34)

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

-- assemble the menu
local HighscoresMenu = VDiv(
    VDiv(
        HDiv(
            Button("Back", BS, "backBtn"),
            {
                slots = 3
            }
        ),
        Label("Highscores", LS)
    ),
    Switcher(
        TimedHS,
        NormalHS,
        {
            span = 5,
        },
        "hsSwitcher"
    ),
    chooser,
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