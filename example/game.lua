
local node = require('node')
local node2d = require('node/node2d')
local rect = require('node/rect')

local game = {}

function game.load()
    game.elements = {}

    local t = 0
    game.root = node({
        player = node2d(
            rect({0, 0, 16, 16}, {255, 0, 127}),
            {
                function update(dt)
                    t = t + dt
                    if t >= 10 then
                        print(dt)
                        t = 0
                    end
                end
            }
        )
    })
end

return game
