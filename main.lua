local Config = require("src.Config")
local Game = require("src.Game")
local Sounds = require("src.Sounds")

local menu = require("src.menu.menu")

local game = nil
local config = nil

function love.load()
    Sounds.playLooping("loop")
    menu:getWidget("options"):load()
end

function love.draw()
    menu:draw()
end

function love.keypressed(key, code, rep)
    menu:keypressed(key)
    --if key=="r" then
    --    game.undo:restore()
    --end
end

function love.mousepressed(x, y, button, istouch, presses)
    menu:handleClick(x, y, button)
end

function love.mousemoved(x, y, dx, dy, istouch)
    menu:mousemove(x, y)
end

function love.mousereleased(x, y, button, istouch, presses)
    menu:mousereleased(x, y)
end

function love.update(dt)
    Sounds.update(dt)
    menu:update(dt)
end

function love.resize(w, h)
    menu:resize(w, h)
end

function love.quit()
    menu:getWidget("options"):save()
end