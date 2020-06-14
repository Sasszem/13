local SaveRestore = require("src.SaveRestore")
local Highscores = require("src.Highscores")

------------
-- STYLES --
------------

-- base styles
local BS = require("src.menu.buttonStyle")
local LS = require("src.menu.labelStyle")


-- new button style (centered)
local NB = {}
for k, v in pairs(BS) do
    NB[k] = v
end
NB.placement = "center"


-- new label style (smaller font)
local NL = {}
for k, v in pairs(LS) do
    NL[k] = v
end
NL.font = Font(20, "asset/supercomputer.ttf")


-- on / yes button
local OnBTN = {}
for k, v in pairs(NB) do
    OnBTN[k] = v
end
OnBTN.backgroundColor = rgb(0, 102, 34)
OnBTN.borderColor = rgb(255, 204, 0)


-- off / no button
local OffBTN = {}
for k, v in pairs(NB) do
    OffBTN[k] = v
end
OffBTN.backgroundColor = rgb(179, 0, 0)
OffBTN.borderColor = rgb(255, 204, 0)


------------------
-- DELETE SAVES --
------------------

local DelSaves = Switcher(
    HDiv(
        Button("No", OffBTN, "noDelSavesBtn"),
        Label("Are you sure", NL),
        Button("Yes", OnBTN, "delSavesBtn"),
        {},
        "delSavesHDiv"
    ),
    Button("Delete saved games", NB, "delSavesMenuBtn"),
    {},
    "delSavesSwitcher"
)

-- menu button
function DelSaves.widgets.delSavesMenuBtn.style:click()
    self:getWidget("delSavesSwitcher").selected = "delSavesHDiv"
end

-- no button
function DelSaves.widgets.noDelSavesBtn.style:click()
    self:getWidget("delSavesSwitcher").selected = "delSavesMenuBtn"
end

-- yes button
function DelSaves.widgets.delSavesBtn.style:click()
    SaveRestore.remove("normal")
    SaveRestore.remove("timed")
    self:getWidget("delSavesSwitcher").selected = "delSavesMenuBtn"
end

-----------------------
-- Delete highscores --
-----------------------

local DelHS = Switcher(
    HDiv(
        Button("No", OffBTN, "noDelHSBtn"),
        Label("Are you sure", NL),
        Button("Yes", OnBTN, "delHSBtn"),
        {},
        "delHSHDiv"
    ),
    Button("Delete highscores", NB, "delHSMenuBtn"),
    {},
    "delHSSwitcher"
)

-- menu button
function DelHS.widgets.delHSMenuBtn.style:click()
    self:getWidget("delHSSwitcher").selected = "delHSHDiv"
end

-- no button
function DelHS.widgets.noDelHSBtn.style:click()
    self:getWidget("delHSSwitcher").selected = "delHSMenuBtn"
end

-- yes button
function DelHS.widgets.delHSBtn.style:click()
    Highscores.delete()
    self:getWidget("highscores"):loadHighscores()
    self:getWidget("delHSSwitcher").selected = "delHSMenuBtn"
end


------------------
-- Options menu --
------------------

local OptionsMenu = VDiv(
    Label("Options", {font = Font(40, "asset/supercomputer.ttf")}),
    HDiv(
        Label("Sounds"),
        HDiv(
            Button("On", OnBTN, "soundsOn"),
            Button("Off", OffBTN, "soundsOff")
        )
    ),
    HDiv(
        Label("Music"),
        HDiv(
            Button("On", OnBTN, "musicOn"),
            Button("Off", OffBTN, "musicOff")
        )
    ),
    Label(""),
    DelSaves,
    DelHS,
    HDiv(
        Button("Back", NB, "backFromOptions")
    ),
    {},
    "options"
)

-- back button
function OptionsMenu.widgets.backFromOptions.style:click()
    self:getWidget("switcher").selected = "mainMenu"
end

return OptionsMenu