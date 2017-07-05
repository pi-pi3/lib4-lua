
--[[ node/box2d/body.lua
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
local node = require('lib4/node')
local fixture = require('lib4/node/box2d/fixture')

local body = {}
local mt = {__index = body}

-- Create a new body
function body.new(params, children)
    local self = node.new(children)
    setmetatable(self, mt)

    self.t = "box2d/body"

    self.body = nil
    self.params = params or {}

    return self
end

function body:signal(s, ...)
    if s == 'draw' then
        love.graphics.push()

        love.graphics.translate(self.body:getPosition())
        love.graphics.rotate(self.body:getAngle())

        node.signal(self, s, ...)

        love.graphics.pop()
    else
        node.signal(self, s, ...)
    end
end

function body:set_params(params)
    if not params then params = self.params end
    for k, v in pairs(params) do
        self.params[k] = v
    end

    if not self.body then
        return
    end

    if params.type then self.body:setType(params.type) end
    if params.x then self.body:setX(params.x) end
    if params.y then self.body:setY(params.y) end
    if params.active then self.body:setActive(params.active) end
    if params.awake then self.body:setAwake(params.awake) end
    if params.bullet then self.body:setBullet(params.bullet) end
    if params.fixed_rotation then
        self.body:setFixedRotation(params.fixed_rotation)
    end
    if params.gravity then
        local scale = params.gravity/self.body:getWorld():getRotation()
        self.body:setGravityScale(scale)
    end
    if params.linear_damping then
        self.body:setLinearDamping(params.linear_damping)
    end
    if params.angular_damping then
        self.body:setAngularDamping(params.angular_damping)
    end
    if params.mass then
        self.body:setMass(params.mass)
    end
end

function body:make_body(world)
    self.body = love.physics.newBody(world.world, self.x, self.y, self.type)
    self:set_params()
end

function body:destroy()
    self.body:destroy()
end

function body:add(c, k, params)
    k = k or #self.children + 1

    if not util.startswith(c.t, 'box2d/') then
        node.add(self, c, k)
        return
    end

    if not params then
        params = self.params
    else
        for k, v in pairs(self.params) do
            if not params[k] then
                params[k] = v
            end
        end
    end

    local f = fixture(params)
    f:make_fixture(self, c)
    f.fixture:setUserData({self = self, shape = k})

    local shape = f.fixture:getShape()
    if params.friction then shape:setFriction(params.friction) end
    if params.restitution then shape:setRestitution(params.restitution) end
    if params.category then shape:setCategory(unpack(params.category)) end
    if params.mask then shape:setMask(unpack(params.mask)) end

    node.add(self, f, tostring(k) .. '_fixture')
    node.add(self, c, k)
end

setmetatable(body, {
    __index = node,
    __call = function(_, ...) return body.new(...) end ,
})

return body