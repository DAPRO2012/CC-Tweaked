local modems = { peripheral.find("modem", function(name, modem)
    return modem.isWireless()
end) }
function StartServer(name, log, handler)
    local id = os.getComputerID()
    modems[1].open(id)
    
    local event, side, channel, replyChannel, message, distance
    while true do
        event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
        if channel == id then
            local replyMessage
            if string.lower(message.method) == "ping" then
                replyMessage = {
                    Body = name
                }
            else
                replyMessage = handler(message)
            end
            modems[1].transmit(replyChannel, channel, replyMessage)
            
            if log then
                print(string.format("[%s] \"%s\" %s", os.date("%H:%M"), message.uri, message.method))
            end
        end
    end
end

return {
    start = StartServer
}
