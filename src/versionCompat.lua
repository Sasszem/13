-- versionCompat.lua
-- needed because love.js has some odd quirks

local Sounds = require("src.Sounds")

local function fGetInfo(path)
    -- I used the original for 2 reasons
    -- file exists check
    -- file size check
    -- (for determining to stream or staticly load sounds)
    -- but as love.js does not suppert streaming
    -- we return a fake size that forces static
    if not love.filesystem.exists(path) then
        return false
    end
    return {
        size =  10000
    }
end

local function register()
    -- register new function missing for some reason
    if not love.filesystem.getInfo then
        love.filesystem.getInfo = fGetInfo
        Sounds.clone = false
    end
end

return {
    register = register
}