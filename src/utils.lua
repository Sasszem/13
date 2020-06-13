-- allow using web notation (0-255, alpha defaults to 255)
function rgb(r, g, b, a)
    a = a or 255
    return {r/255, g/255, b/255, a/255}
end