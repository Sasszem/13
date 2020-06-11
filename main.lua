local Config = require("src.Config")
local Game = require("src.Game")
local Sounds = require("src.Sounds")

local game = nil
local config = nil

function love.load()
    config = Config.get()
    game = Game(config)
    Sounds.playLooping("loop")
end

function love.draw()
    game:draw()
end

function love.keypressed(key, code, rep)
    if key=="escape" then
        love.event.quit()
    end
    if key=="r" then
        game.undo:restore()
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    game:touchBegin(x, y)
end

function love.mousemoved(x, y, dx, dy, istouch)
    if love.mouse.isDown(1, 2, 3) then
        game:touchMove(x, y)
    end
end

function love.mousereleased(x, y, button, istouch, presses)
    game:touchEnd()
end

function love.update(dt)
    Sounds.update(dt)
    game:update(dt)
end

function love.resize(w, h)
    config:resize(w, h)
end

function love.quit()
    game:quit()
end