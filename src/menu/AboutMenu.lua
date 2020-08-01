
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
local FS = {font = Font(14)} 
-- this will be in the theme font
local FS2 = {font = Font(24, "asset/Oregano-Regular.ttf")}
FS.placement = "center"
FS2.placement = "center"


------------------
-- About menu --
------------------

local AboutMenu = VDiv(
    Label(""),
    Label(L["about"], {font = Font(40, "asset/Oregano-Regular.ttf")}),
    Label(""),
    Label(L["abouttext1"] .. globalvars.version .. L["abouttext2"], FS),
    Label(L["abouttext3"], FS2),
    Label(""),
    Label(L["abouttext4"], FS),
    Label(L["abouttext5"], FS),
    Label(L["abouttext6"], FS),
    Label(L["abouttext7"], FS),
    Label(L["abouttext8"], FS),
    Label(L["abouttext9"], FS),
    Label(L["abouttext10"], FS),
    Label(""),
    Label(L["abouttext11"], FS),
    Label(L["abouttext12"], FS2),
    Label(""),
    Label(""),
    Button(L["back"], NB, "backFromAbout"),
    Label(""),
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