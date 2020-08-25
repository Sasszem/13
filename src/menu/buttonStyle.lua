local Y = require("yalg.yalg")
local Sounds = require("src.Sounds")

local ButtonStyle = {
    activeBorder = Y.rgb(114, 193, 233),
    borderColor = Y.rgb(108, 110, 114),
    placement = "fill",
    backgroundColor = Y.rgb(28, 33, 38),
    -- kattintásnál a háttérszín változzon meg
    -- ButtonStyle:click(x, y)
    --     self.style.backgroundColor=rgb(61, 174, 230)
    -- (Btimes2)
}

-- make the border color change
-- and play a sound
function ButtonStyle:mouseEnter(x, y)
    self.style.borderColor, self.style.activeBorder = self.style.activeBorder, self.style.borderColor
    Sounds.play("click")
end

-- change colors back
function ButtonStyle:mouseLeave(x, y)
    self.style.borderColor, self.style.activeBorder = self.style.activeBorder, self.style.borderColor
end

return ButtonStyle