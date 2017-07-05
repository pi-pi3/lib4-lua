
--[[ node/box2d/init.lua
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

local box2d = {}
local mt = {__index = box2d}

-- Create a new box2d
function box2d.new(meter, children)
    local self = node.new(children)
    setmetatable(self, mt)

    self.t = "box2d"

    self.meter = meter or 1
    love.physics.setMeter(self.meter)
    self.gravity = cpml.vec2()
    self.world = love.physics.newWorld()
    self.world:setCallbacks(self.pre_contact, self.post_contact,
                            self.pre_solve,   self.post_solve)

    return self
end

function box2d:phys_update(dt)
    love.physics.setMeter(self.meter)
    self.world:update(dt)
end

function box2d:set_gravity(gravity)
    local gx, gy
    if type(gravity) == 'table' then
        gx = gravity.x or gravity[1] or 0
        gy = gravity.y or gravity[2] or 0
    else
        gx = 0
        gy = gravity
    end
    self.gravity = cpml.vec2(gx, gy)
    self.world:setGravity(gx*self.meter, gy*self.meter)
end

function box2d:set_script(script)
    node.set_script(self.script)
    self.world:setCallbacks(self.pre_contact, self.post_contact,
                            self.pre_solve,   self.post_solve)
end

function box2d.pre_contact(a, b, ...)
    if a:getUserData().self.pre_contact then
        dcall(a:getUserData().self.pre_contact,
              a:getUserData().self, b:getUserData().self, ...)
    end
    if a:getUserData().self.script 
        and a:getUserData().self.script._pre_contact then
        dcall(a:getUserData().self.script._pre_contact,
              a:getUserData().self, b:getUserData().self, ...)
    end

    if b:getUserData().self.pre_contact then
        dcall(b:getUserData().self.pre_contact,
              b:getUserData().self, a:getUserData().self, ...)
    end
    if b:getUserData().self.script 
        and b:getUserData().self.script._pre_contact then
        dcall(b:getUserData().self.script._pre_contact,
              b:getUserData().self, a:getUserData().self, ...)
    end
end

function box2d.post_contact(a, b, ...)
    if a:getUserData().self.post_contact then
        dcall(a:getUserData().self.post_contact,
              a:getUserData().self, b:getUserData().self, ...)
    end
    if a:getUserData().self.script 
        and a:getUserData().self.script._post_contact then
        dcall(a:getUserData().self.script._post_contact,
              a:getUserData().self, b:getUserData().self, ...)
    end

    if b:getUserData().self.post_contact then
        dcall(b:getUserData().self.post_contact,
              b:getUserData().self, a:getUserData().self, ...)
    end
    if b:getUserData().self.script 
        and b:getUserData().self.script._post_contact then
        dcall(b:getUserData().self.script._post_contact,
              b:getUserData().self, a:getUserData().self, ...)
    end
end

function box2d.pre_solve(a, b, ...)
    if a:getUserData().self.pre_solve then
        dcall(a:getUserData().self.pre_solve,
              a:getUserData().self, b:getUserData().self, ...)
    end
    if a:getUserData().self.script 
        and a:getUserData().self.script._pre_solve then
        dcall(a:getUserData().self.script._pre_solve,
              a:getUserData().self, b:getUserData().self, ...)
    end

    if b:getUserData().self.pre_solve then
        dcall(b:getUserData().self.pre_solve,
              b:getUserData().self, a:getUserData().self, ...)
    end
    if b:getUserData().self.script 
        and b:getUserData().self.script._pre_solve then
        dcall(b:getUserData().self.script._pre_solve,
              b:getUserData().self, a:getUserData().self, ...)

    end
end

function box2d.post_solve(a, b, ...)
    if a:getUserData().self.post_solve then
        dcall(a:getUserData().self.post_solve,
              a:getUserData().self, b:getUserData().self, ...)
    end
    if a:getUserData().self.script 
        and a:getUserData().self.script._post_solve then
        dcall(a:getUserData().self.script._post_solve,
              a:getUserData().self, b:getUserData().self, ...)
    end

    if b:getUserData().self.post_solve then
        dcall(b:getUserData().self.post_solve,
              b:getUserData().self, a:getUserData().self, ...)
    end
    if b:getUserData().self.script 
        and b:getUserData().self.script._post_solve then
        dcall(b:getUserData().self.script._post_solve,
              b:getUserData().self, a:getUserData().self, ...)
    end
end

function box2d:add(c, k)
    c:make_body(self)
    node.add(self, c, k)
end

setmetatable(box2d, {
    __index = node,
    __call = function(_, ...) return box2d.new(...) end ,
})

return box2d
