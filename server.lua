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
            modem.transmit(replyChannel, channel, handle(message))
            
            if log then
                local timeResponse = http.get("http://worldtimeapi.org")
                local date
                local time
                if response then
                    local body = response.readAll()
                    response.close()
                    
                    local datetime = body:match('"datetime":"([^"]+)"')
                    if datetime then
                        date, time = datetime:match("([^T]+)T([^.]+)")
                    end
                end
                print(string.format("[%s] \"%s\" %s", time, message.uri, message.method))
            end
        end
    end
end

StartServer(true, function(m)
    local packet = {
        Headers = {},
        Body = "Hello"
    }
end)
