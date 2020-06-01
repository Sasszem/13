local Config = require("src.Config")
local Cell = require("src.Cell")

local cell = nil
local config = nil

function love.load()
    config = Config.get()
    cell = Cell(config)
    cell.x = 100
    cell.y = 100
end

function love.draw()
    cell:draw()
end
