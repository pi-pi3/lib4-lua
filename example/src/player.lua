
local node = require('lib4/node')
local node2d = require('lib4/node/node2d')
local phys2d = require('lib4/node/phys2d')
local rect = require('lib4/node/node2d/rect')
local cpml = require('cpml')

local player = {}

function player:_load()
    self.speed = 220
    self.shooting = 0
end

local bullet = function(pos, vx, vy)
    local r
    if vx ~= 0 then
        r = rect.new({0, 0, 12, 4}, {127, 0, 255})
    else
        r = rect.new({0, 0, 4, 12}, {127, 0, 255})
    end

    local b = phys2d.new(r)

    b.position.x = pos.x
    b.position.y = pos.y
    b.velocity.x = vx
    b.velocity.y = vy

    return b
end

function player:_update(dt)
    if self.shooting > 0 then
        self.shooting = self.shooting - dt
    end

    local vx, vy = 0, 0
    local sx, sy = 0, 0

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

    if love.keyboard.isScancodeDown('a') then
        sx = -self.speed*10
    elseif love.keyboard.isScancodeDown('f') then
        sx = self.speed*10
    elseif love.keyboard.isScancodeDown('d') then
        sy = -self.speed*10
    elseif love.keyboard.isScancodeDown('s') then
        sy = self.speed*10
    end

    if (sx ~= 0 or sy ~= 0) and self.shooting <= 0 then
        lib4.state.root.children.camera:add(
            bullet(self.position, sx, sy))
        self.shooting = 1
    end

    if vx == 0 and vy == 0 then
        self.deceleration = self.velocity:normalize() * self.speed
    end
    self.acceleration = cpml.vec2(vx, vy)

    self.velocity.x = util.clamp(self.velocity.x, -self.speed, self.speed)
    self.velocity.y = util.clamp(self.velocity.y, -self.speed, self.speed)
end

return player
