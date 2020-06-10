local Config = require("src.Config")
local Playfield = require("src.Playfield")
local Sounds = require("src.Sounds")
local Tasks = require("src.Tasks")

local playfield = nil
local config = nil

function love.load()
    config = Config.get()
    playfield = Playfield(config)
    Sounds.playLooping("loop")
end

function love.draw()
    playfield:draw()
end

function love.keypressed(key, code, rep)
    if key=="escape" then
        love.event.quit()
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    playfield:touchBegin(x, y)
end

function love.mousemoved(x, y, dx, dy, istouch)
    if love.mouse.isDown(1, 2, 3) then
        playfield:touchMove(x, y)
    end
end

function love.mousereleased(x, y, button, istouch, presses)
    playfield:touchEnd()
end

function love.update(dt)
    Sounds.update(dt)
    Tasks.update(dt)
end

function love.resize(w, h)
    playfield:resize(w, h)
    config:resize(w, h)
end