local modems = { peripheral.find("modem", function(name, modem)
    return modem.isWireless()
end) }

if #modems == 0 then
    printError("No interdimensional modem attached!")
    return
end

function defaultHandler(response)
    if response and response.Headers and response.Headers.Type == "script" then
        if response.Headers.Dependencies ~= nil then
            print("This script requires dependencies:")
            term.setTextColour(colors.lightBlue)
            
            for name, uri in pairs(response.Headers.Dependencies) do
                print("    " .. name .. " | " .. uri)
            end
            term.setTextColour(colors.white)

            write("Would you like to proceed? (y/n): ")
            local proceed = string.lower(read())
            if proceed ~= "y" then return nil end
        
            for name, uri in pairs(response.Headers.Dependencies) do
                shell.run(uri)
            end
        end
        
        if not fs.exists("networking") then
            fs.makeDir("networking")
        end
            
        if not fs.exists("networking/scripts/") then
            fs.makeDir("networking/scripts")
        end
            
        local file = fs.open("networking/scripts/" .. response.Headers.name, "w")
        file.write(response.Body)
        file.close()
        shell.run("networking/scripts/" .. response.Headers.name)

        return nil
    end
    
    if response then print(response.Body) end
end

_G.internetHandler = defaultHandler

function Request(Channel, URI, Method, Headers, Body)
    local myChannel = os.getComputerID()
    
    local packet = {
        uri = URI,
        method = Method,
        Headers = Headers,
        Body = Body
    }
    
    modems[1].open(myChannel)
    modems[1].transmit(Channel, myChannel, packet)
    
    local event, side, rChannel, rReplyChannel, message, distance
    repeat
        event, side, rChannel, rReplyChannel, message, distance = os.pullEvent("modem_message")
    until rChannel == myChannel
    
    _G.internetHandler(message)
end

return {
    request = Request
}
