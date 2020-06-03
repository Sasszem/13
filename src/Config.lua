local Config = {
}

function Config.get()
    local c = {}
    setmetatable(c, Config)
    c.width, c.height, _ = love.window.getMode()
    c.wP = c.width / 100
    c.hP = c.height / 100
    c.mP = math.min(c.wP, c.hP)
    c.gameFont = love.graphics.newFont("asset/supercomputer.ttf", c.mP*7)

    c.flip = love.system.getOS() == "Android"

    c.Cell = {
        size = c.mP * 10,
    }
    c.Playfield = {
        size = 6,
        gap = c.mP*3,
    }
    c.Path = {
        width = c.mP * 2,
        color = rgb(255, 0, 0),
    }
    local s = c.Playfield.size * (c.Cell.size + c.Playfield.gap) - c.Playfield.gap
    c.Playfield.x = (c.width - s)/2 + c.Cell.size / 2
    c.Playfield.y = (c.height - s)/2 + c.Cell.size / 2
    return c
end

return Config
