local Y = require("yalg.yalg")

local Sounds = require("src.Sounds")
local L = require("src.Local")
local S = require("src.menu.options.styles")


local Page1 = require("src.menu.options.Page1")
local Page2 = require("src.menu.options.Page2")
local Page3 = require("src.menu.options.Page3")
local Page4 = require("src.menu.options.Page4")

-- update here after inserting a new page
local numofpages=4


------------------
-- Options menu --
------------------

local OptionsMenu = Y.VDiv(
    Y.Switcher(
        Page1,
        Page2,
        Page3,
        Page4,
        {span=6},
        "optionsSwitcher"
    ),
    Y.HDiv(
        Y.Button("   <   ", S.NB, "optionsPrevBtn"),
        Y.Button(L["back"], S.NB, "optionsBackBtn"),
        Y.Button("   >   ", S.NB, "optionsNextBtn")
    ),
    "options"
)

-------------
-- BUTTONS --
-------------


-- back button
function OptionsMenu.widgets.optionsBackBtn.style:click()
    self:getWidget("switcher").selected = "mainMenu"
end

-- next button
function OptionsMenu.widgets.optionsNextBtn.style:click()
    local sw = self:getWidget("optionsSwitcher")
    local nextid = tonumber(sw.selected:sub(-1))%numofpages + 1
    sw.selected = ("optionsPage%d"):format(nextid)
end

-- prev button
function OptionsMenu.widgets.optionsPrevBtn.style:click()
    local sw = self:getWidget("optionsSwitcher")
    -- after increasing the number of pages by 1, adding -1 here did not change the page, so I tried -2, and this works
    local nextid = tonumber(sw.selected:sub(-1)-2)%numofpages + 1
    sw.selected = ("optionsPage%d"):format(nextid)
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
        roman = self:getWidget("game").roman and 1 or 0,
        track = self:getWidget("optionsPage4").track or "track01"
    }

    local f = love.filesystem.newFile(FILENAME, "w")
    for k, v in pairs(options) do
        f:write(("%s=%s\n"):format(k, v))
    end
    f:close()
end

function OptionsMenu:load()
    -- disable sounds
    Sounds.setSounds(false)
    Sounds.setMusic(false)

    -- default options
    local options = {
        sounds = true,
        music = true,
        roman = false,
        track = "track01",
    }

    -- load from file
    if love.filesystem.getInfo(FILENAME) then
        for line in love.filesystem.lines(FILENAME) do
            local k, v = line:match("(.+)=(.+)")
            options[k] = v
        end
    end

    options.music = options.music=="1"
    options.sounds = options.music=="1"
    options.roman = options.music=="1"

    -- simulate button clicks

    -- what buttons to click
    local push = {}
    push[#push+1] = ("music%s"):format(options.music and "On" or "Off")
    push[#push+1] = ("roman%s"):format(options.roman and "On" or "Off")
    push[#push+1] = ("sounds%s"):format(options.sounds and "On" or "Off")
    push[#push+1] = ("%s"):format(options.track)

    -- click them
    for _, id in ipairs(push) do
        local w = self:getWidget(id)

        -- need to enter-leave too
        w.style.mouseEnter(w)
        w.style.click(w)
        w.style.mouseLeave(w)
    end

    -- select page 1
    self:getWidget("optionsSwitcher").selected = "optionsPage1"
end


return OptionsMenu
