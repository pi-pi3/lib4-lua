
local input = require('lib4/inpt')

local game = {}

function game:_load()
    love3d:enable()
    input.enable_keyevents()
end

return game
