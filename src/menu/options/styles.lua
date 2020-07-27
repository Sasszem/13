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
NL.font = Font(24, "asset/Oregano-Regular.ttf")


-- on / yes button
local OnBTN = {}
for k, v in pairs(NB) do
    OnBTN[k] = v
end
-- OnBTN.backgroundColor = rgb(28, 33, 38)
--OnBTN.backgroundColor = rgb(44, 69, 39)
OnBTN.backgroundColor = rgb(38, 153, 51)
-- OnBTN.borderColor = rgb(99, 213, 56)
OnBTN.borderColor = rgb(58, 58, 58)
OnBTN.activeBorder = rgb(255, 204, 0)


-- off / no button
local OffBTN = {}
for k, v in pairs(NB) do
    OffBTN[k] = v
end
-- OffBTN.backgroundColor = rgb(28, 33, 38)
-- OffBTN.backgroundColor = rgb(204, 18, 49)
OffBTN.backgroundColor = rgb(166, 2, 29)
OffBTN.borderColor = rgb(58, 58, 58)
OffBTN.activeBorder = rgb(255, 204, 0)


return {
    BS = BS,
    LS = LS,
    NB = NB,
    NL = NL,
    OffBTN = OffBTN,
    OnBTN = OnBTN,
}