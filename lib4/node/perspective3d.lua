
--[[ node/perspective3d.lua
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

local perspective3d = {}
setmetatable(perspective3d, {
    __index = node,
    __call = perspective3d.new,
})

local mt = {__index = perspective3d}

-- Create a new perspective3d
function perspective3d.new(children, script)
    local self = node.new(children, script)
    setmetatable(self, mt)

    self.t = "perspective3d"

    self.origin = cpml.vec3()
    self.position = cpml.vec3()
    self.rotation = cpml.quaternion()

    self.cam = {}
    if cam then
        self.cam.fov = cam.fov or cam[1] or 90
        self.cam.aspect = cam.aspect or cam[2]
            or love.graphics.getWidth()/love.graphics.getHeight()
        self.cam.zn = cam.zn or cam[3] or -0.01
        self.cam.zf = cam.zf or cam[4] or -100
    else
        self.cam.fov = 90
        self.cam.aspect = love.graphics.getWidth()/love.graphics.getHeight()
        self.cam.zn = -0.01
        self.cam.zf = -100
    end

    return self
end

function perspective3d:signal(s, ...)
    if s == 'draw' then
        love3d.matrix_mode('proj')

        love3d.identity()
        love3d.perspective(self.cam.fov, self.cam.aspect,
                           self.cam.zn, self.cam.zf)

        love3d.matrix_mode('view')
        love3d.push()

        love3d.camera(self.position, self.rotation, self.origin)
        love3d.transform()

        node.signal(self, s, ...)

        love3d.matrix_mode('view')
        love3d.pop()
    else
        node.signal(self, s, ...)
    end
end

return perspective3d
