local Sounds = require("src.Sounds")
local L = require("src.Local")
local S = require("src.menu.options.styles")

-------------------
-- Sounds on-off --
-------------------
local SoundsMenu = HDiv(
    Label(L["sounds"], S.NL),
    HDiv(
        Button(L["on"], S.OnBTN, "soundsOn"),
        Button(L["off"], S.OffBTN, "soundsOff")
    )
)

-- on button
function SoundsMenu.widgets.soundsOn.style:click()
    Sounds.setSounds(true)

    -- disable off button
    self:getWidget("soundsOff").style.borderColor = S.OffBTN.borderColor

    -- set border color
    -- (borderColor and activeBorder are swapped by hovering)
    self.style.activeBorder = self.style.borderColor
end

-- off button
function SoundsMenu.widgets.soundsOff.style:click()
    Sounds.setSounds(false)

    -- disable on button
    self:getWidget("soundsOn").style.borderColor = S.OnBTN.borderColor

    -- set border color
    -- (borderColor and activeBorder are swapped by hovering)
    self.style.activeBorder = self.style.borderColor
end


------------------
-- Music on-off --
------------------

local MusicMenu = HDiv(
    Label(L["music"], S.NL),
    HDiv(
        Button(L["on"], S.OnBTN, "musicOn"),
        Button(L["off"], S.OffBTN, "musicOff")
    )
)

-- on button
function MusicMenu.widgets.musicOn.style:click()
    Sounds.setMusic(true)

    -- disable off button
    self:getWidget("musicOff").style.borderColor = S.OffBTN.borderColor

    -- set border color
    -- (borderColor and activeBorder are swapped by hovering)
    self.style.activeBorder = self.style.borderColor
end

-- off button
function MusicMenu.widgets.musicOff.style:click()
    Sounds.setMusic(false)

    -- disable on button
    self:getWidget("musicOn").style.borderColor = S.OnBTN.borderColor

    -- set border color
    -- (borderColor and activeBorder are swapped by hovering)
    self.style.activeBorder = self.style.borderColor
end


------------------
-- Roman on-off --
------------------

local RomanMenu = HDiv(
    Label(L["roman"], S.NL),
    HDiv(
        Button(L["on"], S.OnBTN, "romanOn"),
        Button(L["off"], S.OffBTN, "romanOff")
    )
)

-- on button
function RomanMenu.widgets.romanOn.style:click()
    self:getWidget("game").roman = true
    self:getWidget("titleLbl").text = "XIII"

    -- disable off button
    self:getWidget("romanOff").style.borderColor = S.OffBTN.borderColor

    -- set border color
    -- (borderColor and activeBorder are swapped by hovering)
    self.style.activeBorder = self.style.borderColor
end

-- off button
function RomanMenu.widgets.romanOff.style:click()
    self:getWidget("game").roman = false
    self:getWidget("titleLbl").text = "13"

    -- disable on button
    self:getWidget("romanOn").style.borderColor = S.OnBTN.borderColor

    -- set border color
    -- (borderColor and activeBorder are swapped by hovering)
    self.style.activeBorder = self.style.borderColor
end

local Page = VDiv(
    Label(L["options"], S.LS),
    SoundsMenu,
    MusicMenu,
    RomanMenu,
    {
        slots = 6,
    },
    "optionsPage1"
)

return Page
