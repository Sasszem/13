local Y = require("yalg.yalg")

local Sounds = require("src.Sounds")
local versionCompat = require("src.versionCompat")

local menu = require("src.menu.menu")

function love.load()
    versionCompat.register()
    Sounds.playLooping("loop")
    menu:getWidget("options"):load()
    love.graphics.setBackgroundColor(Y.rgb(16, 16, 16))
end

function love.draw()
    menu:draw()
end

function love.keypressed(key, code, rep)
    menu:keypressed(key)
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