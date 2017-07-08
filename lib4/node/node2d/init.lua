
--[[ node/node2d.lua
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

local node2d = {}
local mt = {__index = node2d}

-- Create a new node2d
function node2d.new(children)
    local self = node.new(children)
    setmetatable(self, mt)

    self.t = "node2d"

    self.position = cpml.vec2()
    self.rotation = 0
    self.scale = cpml.vec2(1.0)
    self.shear = cpml.vec2()
    self.origin = cpml.vec2()

    return self
end

function node2d:signal(s, ...)
    if s == 'draw' then
        love.graphics.push()

        love.graphics.translate(-self.origin.x, -self.origin.y)
        love.graphics.translate(self.position.x, self.position.y)
        love.graphics.rotate(self.rotation)
        love.graphics.scale(self.scale.x, self.scale.y)
        love.graphics.shear(self.shear.x, self.shear.y)
        love.graphics.translate(self.origin.x, self.origin.y)

        node.signal(self, s, ...)

        love.graphics.pop()
    else
        node.signal(self, s, ...)
    end
end

setmetatable(node2d, {
    __index = node,
    __call = function(_, ...) return node2d.new(...) end ,
})

return node2d
