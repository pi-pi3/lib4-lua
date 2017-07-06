
local inpt = require('lib4/inpt')
local phys = require('lib4/phys')

local game = {}

function game:_load()
    inpt.enable_keyevents()

    -- control scheme 1 (vim), 2 (1337), 3 (neet)
    inpt.add_keycode('left', 'h', 'a', 'left')
    inpt.add_keycode('right', 'l', 'd', 'right')
    inpt.add_keycode('jump', 'k', 'w', 'up')
    inpt.add_keycode('sit', 'j', 's', 'down')
    inpt.add_keycode('shoot', 'z', 'o') -- 3rd is also z

    phys.enable()
    game.time = 0
end

function game:_update(dt)
    game.time = game.time + dt
end

return game
