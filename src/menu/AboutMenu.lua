local Y = require("yalg.yalg")

local Sounds = require("src.Sounds")
local L = require("src.Local")
local globals = require("src.globals")

--version number is originally stored in conf.lua, that should be inserted here instead of this line
-- local version="1.0"

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

-- this will be set in regular font, not in the theme font
local FS = {font = Y.Font(14, "asset/OpenSans-SemiBold.ttf")} 
-- this will be in the theme font
local FS2 = {font = Y.Font(24, "asset/Oregano-Regular.ttf")}
FS.placement = "center"
FS2.placement = "center"


------------------
-- About menu --
------------------

local AboutMenu = Y.VDiv(
    Y.Label(""),
    Y.Label(L["about"], {font = Y.Font(40, "asset/Oregano-Regular.ttf")}),
    Y.Label(""),
    Y.Label(L["abouttext1"] .. globalvars.version .. L["abouttext2"], FS),
    Y.Label(L["abouttext3"], FS2),
    Y.Label(""),
    Y.Label(L["abouttext4"], FS),
    Y.Label(L["abouttext5"], FS),
    Y.Label(L["abouttext6"], FS),
    Y.Label(L["abouttext7"], FS),
    Y.Label(L["abouttext8"], FS),
    Y.Label(L["abouttext9"], FS),
    Y.Label(L["abouttext10"], FS),
    Y.Label(L["abouttext11"], FS),
    Y.Label(L["abouttext12"], FS),
    Y.Label(""),
    Y.Label(L["abouttext13"], FS),
    Y.Label(L["abouttext14"], FS2),
    Y.Label(""),
    Y.Label(""),
    Y.Button(L["back"], NB, "backFromAbout"),
    Y.Label(""),
    {},
    "about"
)

-- back button
function AboutMenu.widgets.backFromAbout.style:click()
    self:getWidget("switcher").selected = "mainMenu"
end

function AboutMenu:load()

end

return AboutMenu