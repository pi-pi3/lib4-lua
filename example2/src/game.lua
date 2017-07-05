
local phys = require('lib4/phys')

local game = {}

function game:_load()
    phys.enable()
    game.time = 0
end

function game:_update(dt)
    game.time = game.time + dt
end

return game
