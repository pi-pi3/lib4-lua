
--[[ node/phys2d/circle.lua
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

local circle = {}
local mt = {__index = circle}

-- Create a new circle
function circle.new(position, radius, rotation, children)
    local self = node.new(children)
    setmetatable(self, mt)

    self.t = "phys2d/circle"
    self.position = position or cpml.vec2()
    self.rotation = rotation or 0
    if type(radius) == 'number' then
        self.radius = {x = radius, y = radius}
    elseif type(radius) == 'table' then
        self.radius = {}
        self.radius.x = radius.x or radius[1] or 0
        self.radius.y = radius.y or radius[2] or 0
    elseif not radius then
        self.radius = 0
    end

    return self
end

function circle:transform(position, rotation, scale)
    local new = self:clone()
    new.position = new.position + position
    new.rotation = new.rotation + rotation

    local c = math.cos(self.rotation)
    local s = math.sin(self.rotation)
    scale_x = scale.x * c - scale.y * s
    scale_y = scale.y * s + scale.x * c
    new.radius.x = self.radius.x * scale_x
    new.radius.y = self.radius.y * scale_y

    return new
end

function circle:intersects(other)
    return phys.intersects(self, other)
end

setmetatable(circle, {
    __index = node,
    __call = function(_, ...) return circle.new(...) end ,
})

return circle
