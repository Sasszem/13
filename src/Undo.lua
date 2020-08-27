-- Undo.lua
-- class to store a game state
-- for later restoring


local Undo = {}

function Undo:new(game)
    local o = {}
    setmetatable(o, {__index = Undo})

    o.time = 0
    o.biggestYet = 0
    o.cells = {}

    o.game = game

    return o
end
setmetatable(Undo, {__call = Undo.new})


function Undo:backup()
    -- deep copies the game state for backup
    self.time = self.game.time
    self.biggestYet = self.game.biggestYet
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
    -- do not restore if no data
    -- (no backup was made yet)
    if self.biggestYet == 0 then return end

    self.game.TM:run(self.undoTask, self)
end


function Undo:undoTask()
    -- wait for game to finish animating
    while self.game.animating do
        local _ = coroutine.yield()
    end

    -- deep copy the saved data back to game
    self.game.time = self.time

    for i, C in ipairs(self.cells) do
        self.game.cells.cells[i].x = C.x
        self.game.cells.cells[i].y = C.y
        self.game.cells.cells[i].value = C.value
        self.game.cells.cells[i].column = C.column
    end

    -- remove extra cells in game
    for i=#self.cells+1, #self.game.cells.cells do
        self.game.cells.cells[i] = nil
    end
end


return Undo