-- src/Local.lua
-- translation related functions

local Local = {}

local localsSaveFile = "selectedLocal.opt"

local strings = {}

function Local.index(table, key)
    if strings[key] then
        return strings[key]
    end
    print(("Error: Invalid translation key: \"%s\""):format(key))
    return ("$%s$"):format(key)
end

function Local.load()
    local selectedLocal = "EN"
    if love.filesystem.getInfo(localsSaveFile) then
        for l in love.filesystem.lines(localsSaveFile) do
            selectedLocal = l
        end
    end

    strings = require(("asset.translations.%s"):format(selectedLocal))
    setmetatable(Local, {__index = Local.index})
end

function Local.set(selectedLocal)
    local f = love.filesystem.newFile(localsSaveFile, "w")
    f:write(("%s\n"):format(selectedLocal))
    f:close()
end

Local.load()

return Local