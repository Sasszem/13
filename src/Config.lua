-- Config.lua
-- basic class for storing shared constants
-- used mostly for geometry
-- so values are based on screen size
-- since that changes on android after love.load, we also have to be careful and sometimes recalculate
-- (took me a long time to make it working)

local Config = {
}

function Config.get()
    local c = {}
    setmetatable(c, {__index = Config})

    c.Cell = {
        size = 50,
    }
    c.Playfield = {
        size = 6,
        gap = 15,
    }
    c.Path = {
        width = 10,
        color = rgb(255, 255, 255),
    }

    c:resize(love.graphics.getWidth(), love.graphics.getHeight())
    return c
end

function Config:resize(w, h)
    self.width, self.height = w, h

    self.wP = self.width / 100
    self.hP = self.height / 100
    self.mP = math.min(self.wP, self.hP)

    self.gameFont = love.graphics.newFont("asset/Oregano-Regular.ttf", self.mP*9)
    self.gameFontRoman = love.graphics.newFont("asset/Oregano-Regular.ttf", self.mP*7)
    self.defaultFont = love.graphics.newFont("asset/OpenSans-SemiBold.ttf", self.mP*6)

    self.Cell.size = self.mP * 10
    self.Playfield.gap = self.mP * 3
    self.Path.width = self.mP * 2

    self.Playfield.s = self.Playfield.size * (self.Cell.size + self.Playfield.gap) - self.Playfield.gap
    self.Playfield.x = (self.width - self.Playfield.s)/2 + self.Cell.size / 2
    self.Playfield.y = (self.height - self.Playfield.s)/2 + self.Cell.size / 2
end

return Config
