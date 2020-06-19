local function fGetInfo(path)
    if not love.filesystem.exists(path) then
        return false
    end
    return {
        size =  love.filesystem.getSize(path)
    }
end

local function register()
    if not love.filesystem.getInfo then
        love.filesystem.getInfo = fGetInfo
    end
end

return {
    register = register
}