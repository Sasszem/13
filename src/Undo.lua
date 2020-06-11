-- class to store a prev. state
-- for later restoring

local Undo = {}

function Undo:new(game)
    local o = {}
    setmetatable(o, {__index = Undo})

    o.score = 0
    o.time = 0
    o.biggestYet = 0
    o.cells = {}

    o.game = game

    return o
end
setmetatable(Undo, {__call = Undo.new})


function Undo:backup()
    -- deep copies the game state for backup
    self.score = self.game.score
    self.time = self.game.time
    self.cells = {}
    for i, C in ipairs(self.game.cells.cells) do
        self.cells[i] = {}
        self.cells[i].x = C.x
        self.cells[i].y = C.y
        self.cells[i].value = C.value
        self.cells[i].column = C.column
    end
end

function Undo:restore()
    -- deep copy the saved data back to game
    self.game.score = self.score
    self.game.time = self.time
    for i, C in ipairs(self.cells) do
        self.game.cells.cells[i].x = C.x
        self.game.cells.cells[i].y = C.y
        self.game.cells.cells[i].value = C.value
        self.game.cells.cells[i].column = C.column
    end
    for i=#self.cells+1, #self.game.cells.cells do
        self.game.cells.cells[i] = nil
    end
end

return Undo