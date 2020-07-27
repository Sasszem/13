local SaveRestore = require("src.SaveRestore")
local Highscores = require("src.Highscores")
local L = require("src.Local")
local S = require("src.menu.options.styles")

------------------
-- DELETE SAVES --
------------------

local DelSaves = Switcher(
    HDiv(
        Button(L["no"], S.OffBTN, "noDelSavesBtn"),
        Label(L["sure"], S.NL),
        Button(L["yes"], S.OnBTN, "delSavesBtn"),
        {},
        "delSavesHDiv"
    ),
    Button(L["delSaves"], S.NB, "delSavesMenuBtn"),
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
        Button(L["no"], S.OffBTN, "noDelHSBtn"),
        Label(L["sure"], S.NL),
        Button(L["yes"], S.OnBTN, "delHSBtn"),
        {},
        "delHSHDiv"
    ),
    Button(L["delHS"], S.NB, "delHSMenuBtn"),
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
-- OPTIONS PAGE --
------------------

local Page = VDiv(
    Label(L["gamedata"], S.LS),
    DelSaves,
    DelHS,
    {slots = 6},
    "optionsPage3"
)

return Page