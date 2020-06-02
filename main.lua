local Config = require("src.Config")
local Playfield = require("src.Playfield")

local playfield = nil
local config = nil

function love.load()
    config = Config.get()
    playfield = Playfield(config)
end

function love.draw()
    love.graphics.push()
    love.graphics.origin()
    if config.flip then
        love.graphics.scale(0.5, 0.5)
    end
    playfield:draw()
    love.graphics.pop()
end

function love.keypressed(key, code, rep)
    if key=="escape" then
        love.event.quit()
    end
end
