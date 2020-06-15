local Sounds = require("src.Sounds")

local ButtonStyle = {
    activeBorder = rgb(41, 163, 41),
    borderColor = rgb(179, 0, 0),
    placement = "fill",
    backgroundColor = rgb(0, 0, 102),
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