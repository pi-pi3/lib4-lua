
local inpt = require('lib4/inpt')
local phys = require('lib4/phys')

local game = {}

function game:_load()
    inpt.enable_keyevents()
    lib4.update_rate(0, 0)
    phys.enable()
    game.time = 0
end

function game:_update(dt)
    game.time = game.time + dt
end

return game
