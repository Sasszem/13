local Sounds = require("src.Sounds")
local L = require("src.Local")
local S = require("src.menu.options.styles")


local Page1 = require("src.menu.options.Page1")
local Page2 = require("src.menu.options.Page2")
local Page3 = require("src.menu.options.Page3")


------------------
-- Options menu --
------------------

local OptionsMenu = VDiv(
    Switcher(
        Page1,
        Page2,
        Page3,
        {span=6},
        "optionsSwitcher"
    ),
    HDiv(
        Button("   <   ", S.NB, "optionsPrevBtn"),
        Button(L["back"], S.NB, "optionsBackBtn"),
        Button("   >   ", S.NB, "optionsNextBtn")
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
    local nextid = tonumber(sw.selected:sub(-1))%3 + 1
    sw.selected = ("optionsPage%d"):format(nextid)
end

-- prev button
function OptionsMenu.widgets.optionsPrevBtn.style:click()
    local sw = self:getWidget("optionsSwitcher")
    local nextid = tonumber(sw.selected:sub(-1)+1)%3 + 1
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

    -- select page 1
    self:getWidget("optionsSwitcher").selected = "optionsPage1"
end


return OptionsMenu
