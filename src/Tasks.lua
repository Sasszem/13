local Tasks = {}

local running = {}

function Tasks.run(task, ...)
    local task = coroutine.create(task)
    coroutine.resume(task, ...)
    running[task] = true
end

function Tasks.update(dt)
    for task, _ in pairs(running) do
        local cont, err = coroutine.resume(task, dt)
        if not cont then
            if err~="cannot resume dead coroutine" then
                print(err)
            end
            running[task] = nil
        end
    end
end

return Tasks