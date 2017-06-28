
--[[ node/node3d.lua
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
local node = require('node')

local node3d = {}
setmetatable(node3d, {
    __index = node,
    __call = node3d.new,
})

local mt = {__index = node3d}

-- Create a new node3d
function node3d.new(children, script)
    local self = node.new(children, script)
    setmetatable(self, mt)

    self.t = "3d"

    self.origin = false
    self.position = cpml.vec3()
    self.rotation = cpml.quaternion()
    self.scale = cpml.vec3(1.0)

    return self
end

function node3d:signal(s, ...)
    if s == 'f_draw' then
        love3d.push()

        if self.origin then
            love3d.identity()
        end

        love3d.translate(self.position.x,
                                  self.position.y,
                                  self.position.z)
        love3d.rotate(self.rotation.w,
                               self.rotation.x,
                               self.rotation.y,
                               self.rotation.z)
        love3d.scale(self.scale.x,
                              self.scale.y,
                              self.scale.z)
        love3d.transform()

        node.signal(self, s, ...)

        love3d.pop()
    else
        node.signal(self, s, ...)
    end
end

return node3d
