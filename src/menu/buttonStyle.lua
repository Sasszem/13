local ButtonStyle = {
    activeBorder = rgb(41, 163, 41),
    borderColor = rgb(179, 0, 0),
    placement = "fill",
}

function ButtonStyle:mouseEnter(x, y)
    self.style.borderColor, self.style.activeBorder = self.style.activeBorder, self.style.borderColor
end

function ButtonStyle:mouseLeave(x, y)
    self.style.borderColor, self.style.activeBorder = self.style.activeBorder, self.style.borderColor
end

return ButtonStyle