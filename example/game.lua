
local node = require('lib4/node')
local node2d = require('lib4/node/node2d')
local rect = require('lib4/node/rect')
local file = require('lib4/file')

local cpml = require('cpml')

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
