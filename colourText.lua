local function printColored(textString, defaultBg)
    local textOut = ""
    local colorOut = ""
    local bgOut = ""
    
    local currentColor = "0"
    local currentBg = defaultBg or "f"
    
    local i = 1
    while i <= #textString do
        local char = textString:sub(i, i)
       
        if char == "&" and i < #textString then
            local nextChar = textString:sub(i + 1, i + 1)
            if nextChar:match("[0-9a-fA-F]") then
                currentColor = nextChar:lower()
                i = i + 2
            else
                textOut = textOut .. char
                colorOut = colorOut .. currentColor
                bgOut = bgOut .. currentBg
                i = i + 1
            end
        else
            textOut = textOut .. char
            colorOut = colorOut .. currentColor
            bgOut = bgOut .. currentBg
            i = i + 1
        end
    end
    
    if #textOut > 0 then
        term.blit(textOut, colorOut, bgOut)
        local x, y = term.getCursorPos()
        term.setCursorPos(1, y + 1)
    end
end
