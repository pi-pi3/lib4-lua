
local node = require('node')
local node2d = require('node/node2d')
local rect = require('node/rect')

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
            load = function(self)
                self.vx = vx
                self.vy = vy
            end,

            update = function(self, dt)
                self.position.x = self.position.x + self.vx*dt
                self.position.y = self.position.y + self.vy*dt
            end
        }
    )
    b.position.x = pos.x
    b.position.y = pos.y
end

function game.load()
    game.elements = {}

    love3d.disable()

    game.root = node.new({
        player = node2d.new(
            rect.new({0, 0, 24, 24}, {255, 0, 127}),
            {
                load = function(self)
                    self.speed = 220
                    self.shooting = -1
                    self.shot = false
                end,

                update = function(self, dt)
                    if self.shooting > 0 then
                        self.shooting = self.shooting - dt
                    end

                    local vx, vy = 0, 0

                    if love.keyboard.isScancodeDown('h') then
                        vx = vx - self.speed
                    end
                    if love.keyboard.isScancodeDown('l') then
                        vx = vx + self.speed
                    end
                    if love.keyboard.isScancodeDown('k') then
                        vy = vy - self.speed
                    end
                    if love.keyboard.isScancodeDown('j') then
                        vy = vy + self.speed
                    end

                    if love.keyboard.isScancodeDown('z') 
                        and self.shooting < 0 then
                        self.shooting = 0
                    end

                    if vx == 0 and vy == 0 then
                        self.shot = false
                    end

                    if vx ~= 0 and vy ~= 0 then
                        vx = 0
                        vy = 0
                    end

                    if self.shooting == 0 and (vx ~= 0 or vy ~= 0) then
                        game.root:add(bullet(self.position, vx*10, vy*10))
                        self.shooting = 3
                        self.shot = true
                    elseif not self.shot then
                        self.position.x = self.position.x + vx*dt
                        self.position.y = self.position.y + vy*dt
                    end
                end
            }
        )
    })

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
