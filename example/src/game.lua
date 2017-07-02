
local phys = require('lib4/phys')

local game = {}

function game._load()
    phys.enable()
    game.time = 0
end

function game._update()
    game.time = game.time + dt
    if game.time >= 1 then
        game.time = game.time - 1
        print('FPS: ', 1/dt)
    end
end

return game
