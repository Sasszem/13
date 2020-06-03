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

local function mouseToWorld(x, y)
    if config.flip then
        return 2*x, 2*y
    end
    return x, y
end

function love.mousepressed(x, y, button, istouch, presses)
    playfield:touchBegin(mouseToWorld(x, y))
end

function love.mousemoved(x, y, dx, dy, istouch)
    if love.mouse.isDown(1, 2, 3) then
        playfield:touchMove(mouseToWorld(x, y))
    end
end

function love.mousereleased(x, y, button, istouch, presses)
    playfield:touchEnd()
end