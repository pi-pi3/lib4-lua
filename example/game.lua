
local node = require('node')
local node2d = require('node/node2d')
local rect = require('node/rect')
local cpml = require('cpml')
local file = require('file')

local game = {}

function game.load()
    love3d.disable()

    game.elements = {}
    game.root = file.load_node('assets://root.node')

    local t = 0
    game.update = function(dt)
        t = t + dt
        if t >= 1 then
            t = t - 1
            print('FPS: ', 1/dt)
        end
    end
end

return game
