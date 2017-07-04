
--[[ node/phys2d/init.lua
    Copyright (c) 2017 Szymon "pi_pi3" Walter

    This software is provided 'as-is', without any express or implied
    warranty. In no event will the authors be held liable for any damages
    arising from the use of this software.

    Permission is granted to anyone to use this software for any purpose,
    including commercial applications, and to alter it and redistribute it
    freely, subject to the following restrictions:

    1. The origin of this software must not be misrepresented you must not
    claim that you wrote the original software. If you use this software
    in a product, an acknowledgment in the product documentation would be
    appreciated but is not required.

    2. Altered source versions must be plainly marked as such, and must not be
    misrepresented as being the original software.

    3. This notice may not be removed or altered from any source
    distribution.
]]

local cpml = require('cpml')
local phys = require('lib4/phys')
local node = require('lib4/node')

local phys2d = {}
local mt = {__index = phys2d}

-- Create a new phys2d
function phys2d.new(children)
    local self = node.new(children)
    setmetatable(self, mt)

    self.t = "phys2d"

    self.layer = 0
    self.mask = {[0] = true}

    self.position = cpml.vec2()
    self.rotation = 0
    self.scale = cpml.vec2(1.0)

    self.velocity = cpml.vec2()
    self.acceleration = cpml.vec2()
    self.deceleration = cpml.vec2()
    self.gravity = cpml.vec2()

    self.bounce = 0.0

    return self
end

function phys2d:signal(s, ...)
    if s == 'draw' then
        love.graphics.push()

        love.graphics.translate(self.position.x, self.position.y)
        love.graphics.rotate(self.rotation)
        love.graphics.scale(self.scale.x, self.scale.y)

        node.signal(self, s, ...)

        love.graphics.pop()
    else
        node.signal(self, s, ...)
    end
end

function phys2d:phys_update(dt)
    self.velocity = self.velocity + self.gravity * dt

    local vx, vy = self.velocity.x, self.velocity.y
    self.velocity = self.velocity + self.acceleration * dt
    self.velocity = self.velocity - self.deceleration * dt
    if util.sign(vx) == -util.sign(self.velocity.x)
        and (vx ~= 0 or self.velocity.x ~= 0)
        or util.sign(vy) == -util.sign(self.velocity.y)
        and (vy ~= 0 or self.velocity.y ~= 0) then
        self.velocity = cpml.vec2(0)
        self.acceleration = cpml.vec2(0)
        self.deceleration = cpml.vec2(0)
    end

    self.position = self.position + self.velocity * dt

    if phys.collides(self) then
        self.position = self.position - self.velocity * dt
        self.velocity = -self.velocity * self.bounce
    end
end

function phys2d:collides(other)
    return phys.collides(self, other)
end

function phys2d:set_collide(layer, p)
    self.mask[layer] = (p == nil) or p
end

setmetatable(phys2d, {
    __index = node,
    __call = phys2d.new,
})

return phys2d
