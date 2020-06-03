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
    if config.flip and false then
        love.graphics.translate(config.width/2, config.height/2)
        love.graphics.rotate(math.rad(-90))
        love.graphics.translate(-config.width/2, -config.height/2)
        love.graphics.setBackgroundColor(1, 1, 1)
    end
    playfield:draw()
    love.graphics.pop()
end

function love.keypressed(key, code, rep)
    if key=="escape" then
        love.event.quit()
    end
end
