
--[[ node/box2d/circle.lua
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

local node = require('lib4/node')

local circle = {}
local mt = {__index = circle}

-- Create a new circle
function circle.new(x, y, radius, children)
    local self = node.new(children)
    setmetatable(self, mt)

    self.t = "box2d/shape"

    self.shape = love.physics.newCircleShape(x, y, radius)

    return self
end

function circle:destroy()
    self.shape:destroy()
end

setmetatable(circle, {
    __index = node,
    __call = function(_, ...) return circle.new(...) end ,
})

return circle
