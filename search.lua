local args = { ... }
local internet = require("internet")

if #args < 2 then
  error("Usage: <channel> <uri>")
end

internet.request(tonumber(args[1]), args[2], "GET", {}, "")
