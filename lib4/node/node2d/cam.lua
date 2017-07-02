
--[[ node/cam2d.lua
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

local cam2d = {}
local mt = {__index = cam2d}

local screen = cpml.vec2(love.graphics.getWidth(),
                         love.graphics.getHeight())

-- Create a new cam2d
function cam2d.new(children)
    local self = node.new(children)
    setmetatable(self, mt)

    self.t = "node2d/cam"

    self.origin = cpml.vec2()
    self.position = cpml.vec2()
    self.rotation = 0

    return self
end

function cam2d:signal(s, ...)
    if s == 'draw' then
        love.graphics.push()
        love.graphics.origin()

        local origin = -self.origin + screen/2
        local pos = -self.position + screen/2
        local rot = -math.rad(self.rotation)

        love.graphics.translate(origin.x, origin.y)
        love.graphics.rotate(rot)
        love.graphics.translate(-origin.x, -origin.y)
        love.graphics.translate(pos.x, pos.y)

        node.signal(self, s, ...)

        love.graphics.pop()
    else
        node.signal(self, s, ...)
    end
end

function cam2d:resize(width, height)
    screen = cpml.vec2(width, height)
end

setmetatable(cam2d, {
    __index = node,
    __call = cam2d.new,
})

return cam2d
