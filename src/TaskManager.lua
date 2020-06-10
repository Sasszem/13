local TaskManager = {}

function TaskManager:new()
    local o = {}
    o.running = {}
    setmetatable(o, {__index = TaskManager})
    return o
end
setmetatable(TaskManager, {__call = TaskManager.new})

-- queue a parallel task
-- a coroutine which is updated with dt's
function TaskManager:run(task, ...)
    local cor = coroutine.create(task)
    coroutine.resume(cor, ...)
    self.running[cor] = true
end

-- update queued parallel tasks
-- also displays errors and removes dead tasks
function TaskManager:update(dt)
    for task, _ in pairs(self.running) do
        local cont, err = coroutine.resume(task, dt)

        if not cont then
            if err~="cannot resume dead coroutine" then
                print(err)
            end
            self.running[task] = nil
        end
    end
end

-- call a function periodically, with an initial delay
-- also can provide arguments to that function
-- uses normal task as a backend
function TaskManager:periodic(task, period, delay, ...)
    local args = {...}

    self:run(function()
        local t = period-delay
        while true do
            while t < period do
                local dt = coroutine.yield()
                t = t + dt
            end
            task(unpack(args))
            t = 0
        end
    end)
end

-- call a function with args after a delay
-- uses normal task as a backend
function TaskManager:delayed(task, delay, ...)
    local args = {...}

    self:run(function ()
        local t = 0
        while t < delay do
            local dt = coroutine.yield()
            t = t + dt
        end
        task(unpack(args))
    end)
end

return TaskManager