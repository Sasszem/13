local Config = {
}

function Config.get()
    local c = {}
    setmetatable(c, Config)
    c.width, c.height, _ = love.window.getMode()
    c.wP = c.width / 100
    c.hP = c.height / 100
    c.mP = math.min(c.wP, c.hP)
    c.gameFont = love.graphics.newFont("asset/supercomputer.ttf", c.mP*5)
    return c
end

return Config
