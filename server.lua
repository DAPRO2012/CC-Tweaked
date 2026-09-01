local modems = { peripheral.find("modem", function(name, modem)
    return modem.isWireless()
end) }
function StartServer(log, handler)
    local id = os.getComputerID()
    modems[1].open(id)
    
    local event, side, channel, replyChannel, message, distance
    while true do
        event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
        if channel == id then
            modems[1].transmit(replyChannel, channel, handler(message))
            
            if log then
                print(string.format("[%s] \"%s\" %s", os.date("%H:%M"), message.uri, message.method))
            end
        end
    end
end

StartServer(true, function(m)
    local packet = {
        Headers = {},
        Body = "Hello"
    }
    return packet
end)
