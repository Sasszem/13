local SaveRestore = require("src.SaveRestore")
local Highscores = require("src.Highscores")
local Sounds = require("src.Sounds")

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
NL.font = Font(20, "asset/Oregano-Regular.ttf")


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

-------------------
-- Sounds on-off --
-------------------
local SoundsMenu = HDiv(
    Label("Sounds"),
    HDiv(
        Button("On", OnBTN, "soundsOn"),
        Button("Off", OffBTN, "soundsOff")
    )
)

-- on button
function SoundsMenu.widgets.soundsOn.style:click()
    Sounds.setSounds(true)

    -- disable off button
    self:getWidget("soundsOff").style.borderColor = OffBTN.borderColor

    -- set border color
    -- (borderColor and activeBorder are swapped by hovering)
    self.style.activeBorder = self.style.borderColor
end

-- off button
function SoundsMenu.widgets.soundsOff.style:click()
    Sounds.setSounds(false)

    -- disable on button
    self:getWidget("soundsOn").style.borderColor = OnBTN.borderColor

    -- set border color
    -- (borderColor and activeBorder are swapped by hovering)
    self.style.activeBorder = self.style.borderColor
end


------------------
-- Music on-off --
------------------

local MusicMenu = HDiv(
    Label("Music"),
    HDiv(
        Button("On", OnBTN, "musicOn"),
        Button("Off", OffBTN, "musicOff")
    )
)

-- on button
function MusicMenu.widgets.musicOn.style:click()
    Sounds.setMusic(true)

    -- disable off button
    self:getWidget("musicOff").style.borderColor = OffBTN.borderColor

    -- set border color
    -- (borderColor and activeBorder are swapped by hovering)
    self.style.activeBorder = self.style.borderColor
end

-- off button
function MusicMenu.widgets.musicOff.style:click()
    Sounds.setMusic(false)

    -- disable on button
    self:getWidget("musicOn").style.borderColor = OnBTN.borderColor

    -- set border color
    -- (borderColor and activeBorder are swapped by hovering)
    self.style.activeBorder = self.style.borderColor
end

------------------
-- Options menu --
------------------

local OptionsMenu = VDiv(
    Label("Options", {font = Font(40, "asset/Oregano-Regular.ttf")}),
    SoundsMenu,
    MusicMenu,
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

--------------------------
-- Sound options saving --
--------------------------

local FILENAME = "OPTIONS.SAV"

-- (need to place it down there to register it to OptionsMenu)
function OptionsMenu:save()
    local options = {
        sounds = Sounds.soundsEnabled and 1 or 0,
        music = Sounds.musicEnabled and 1 or 0,
    }

    local f = love.filesystem.newFile(FILENAME, "w")
    for k, v in pairs(options) do
        f:write(("%s=%s\n"):format(k, v))
    end
    f:close()
end

function OptionsMenu:load()
    -- default options
    local options = {
        sounds = true,
        music = true,
    }

    -- load from file
    if love.filesystem.getInfo(FILENAME) then
        for line in love.filesystem.lines(FILENAME) do
            local k, v = line:match("(.+)=(.+)")
            v = v=="1"
            options[k] = v
        end
    end

    -- simulate button clicks

    -- what buttons to click
    local push = {}
    push[#push+1] = ("sounds%s"):format(options.sounds and "On" or "Off")
    push[#push+1] = ("music%s"):format(options.music and "On" or "Off")

    -- click them
    for _, id in ipairs(push) do
        local w = self:getWidget(id)

        -- need to enter-leave too
        w.style.mouseEnter(w)
        w.style.click(w)
        w.style.mouseLeave(w)
    end
end

return OptionsMenu
