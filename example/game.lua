
local node = require('node')
local node2d = require('node/node2d')
local rect = require('node/rect')
local cpml = require('cpml')

local game = {}

local bullet = function(pos, vx, vy)
    local r
    if vx ~= 0 then
        r = rect.new({0, 0, 12, 4}, {127, 0, 255})
    else
        r = rect.new({0, 0, 4, 12}, {127, 0, 255})
    end

    local b = node2d.new(
        r,
        {
            update = function(self, dt)
                self.position.x = self.position.x + self.vx*dt
                self.position.y = self.position.y + self.vy*dt
            end
        }
    )

    b.position.x = pos.x
    b.position.y = pos.y
    b.vx = vx
    b.vy = vy

    return b
end

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
