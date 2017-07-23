
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
local node = require('lib4/node')

local node3d = {}
local mt = {__index = node3d}

-- Create a new node3d
function node3d.new(children)
    local self = node.new(children)
    setmetatable(self, mt)

    self.t = "node3d"

    self.position = cpml.vec3()
    self.rotation = cpml.quat()
    self.scale = cpml.vec3(1.0)

    return self
end

function node3d:predraw()
    love3d.matrix_mode('model')
    love3d.push()

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
end

function node3d:postdraw()
    love3d.matrix_mode('model')
    love3d.pop()
end

setmetatable(node3d, {
    __index = node,
    __call = function(_, ...) return node3d.new(...) end ,
})

return node3d
