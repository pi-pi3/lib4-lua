
local inpt = require('lib4/inpt')
local phys = require('lib4/phys')

local game = {}

function game:_load()
    inpt.enable_keyevents()
    inpt.add_keycode('left', 'h')
    inpt.add_keycode('right', 'l')
    inpt.add_keycode('jump', 'k')
    inpt.add_keycode('sit', 'j')
    inpt.add_keycode('shoot', 'z')

    phys.enable()
    game.time = 0
end

function game:_update(dt)
    game.time = game.time + dt
end

return game
