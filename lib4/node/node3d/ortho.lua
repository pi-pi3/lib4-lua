
--[[ node/ortho3d.lua
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

local ortho3d = {}
local mt = {__index = ortho3d}

-- Create a new ortho3d
function ortho3d.new(cam, children)
    local self = node.new(children)
    setmetatable(self, mt)

    self.t = "node3d/ortho"

    self.origin = cpml.vec3()
    self.position = cpml.vec3()
    self.rotation = cpml.quaternion()

    self.cam = {}
    if cam then
        self.cam.l = cam.l or cam[1] or -love.graphics.getWidth()/2
        self.cam.r = cam.r or cam[2] or -self.cam.l
        self.cam.t = cam.t or cam[3] or -love.graphics.getHeight()/2
        self.cam.b = cam.b or cam[4] or -self.cam.t
        self.cam.n = cam.n or cam[5] or -0.01
        self.cam.f = cam.f or cam[6] or -100
    else
        self.cam.l = -love.graphics.getWidth()/2
        self.cam.r = -self.cam.l
        self.cam.t = -love.graphics.getHeight()/2
        self.cam.b = -self.cam.t
        self.cam.n = -0.01
        self.cam.f = -100
    end

    return self
end

function ortho3d:signal(s, ...)
    if s == 'draw' then
        love3d.matrix_mode('proj')

        love3d.identity()
        love3d.ortho(self.cam.l, self.cam.r,
                     self.cam.t, self.cam.b,
                     self.cam.n, self.cam.f)

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

setmetatable(ortho3d, {
    __index = node,
    __call = ortho3d.new,
})

return ortho3d
