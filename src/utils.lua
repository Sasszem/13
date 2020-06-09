local function hexToRgb(hexstring)
    assert(hexstring:sub(0, 1)=="#", "Color strings must be in hex format!")
    
    -- extract string bits
    r = hexstring:sub(2, 3)
    g = hexstring:sub(4, 5)
    b = hexstring:sub(6, 7)
    
    -- convert to decimal
    r = tonumber(r, 16)
    g = tonumber(g, 16)
    b = tonumber(b, 16)

    return rgb(r, g, b)
end

function rgb(r, g, b, a)
    a = a or 255
    if type(r)=="string" then
        return hexToRgb(r)
    end
    return {r/255, g/255, b/255, a/255}
end