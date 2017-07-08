
--[[ node/sprite.lua
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

local file = require('lib4/file')
local node = require('lib4/node')

local sprite = {}
local mt = {__index = sprite}

-- Create a new sprite
function sprite.new(texture, quad, children)
    local self = node.new(children)
    setmetatable(self, mt)

    self.t = "node2d/sprite"

    if type(texture) == 'string' then
        self.texture = file.load_image(texture)
    else
        self.texture = texture
    end

    local w0, h0 = self.texture:getDimensions()
    local x, y, w, h = 0, 0, w0, h0

    if quad.x and quad.y then
        x, y = quad.x, quad.y
    end
    if quad.w and quad.h then
        w, h = quad.w, quad.h
    end
    if quad[1] and quad[2] then
        x, y = quad[1], quad[2]
    end
    if quad[3] and quad[4] then
        w, h = quad[3], quad[4]
    end

    self.quad = love.graphics.newQuad(x, y, w, h, w0, h0)
    self.ox = w/2
    self.oy = h/2

    return self
end

function sprite:draw()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(self.texture, self.quad, -self.ox, -self.oy)
end

setmetatable(sprite, {
    __index = node,
    __call = function(_, ...) return sprite.new(...) end ,
})

return sprite
