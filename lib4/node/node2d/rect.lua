
--[[ node/rect.lua
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

local rect = {}
setmetatable(rect, {
    __index = node,
    __call = rect.new,
})

local mt = {__index = rect}

-- Create a new rect
function rect.new(rect, col, children)
    local self = node.new(children)
    setmetatable(self, mt)

    self.t = "node2d/rect"

    if not rect then
        return self
    end

    local x = rect.x or rect[1] or 0
    local y = rect.y or rect[2] or 0
    local w = rect.w or rect[3] or 0
    local h = rect.h or rect[4] or 0

    local color
    local r, g, b, a
    if col then
        if type(col[1]) == 'table' then
            color = {}
            for i = 1, 4 do
                if not col[i] then
                    break
                end

                color[i] = {}
                color[i].r = col[i].r or col[i][1]
                color[i].g = col[i].g or col[i][2]
                color[i].b = col[i].b or col[i][3]
                color[i].a = col[i].a or col[i][4]
            end
        elseif type(col[1]) == 'number' then
            r = col.r or col[1]
            g = col.g or col[2]
            b = col.b or col[3]
            a = col.a or col[4]
        end
    end

    if color then
        self.rect = love.graphics.newMesh({
            {x,   y,   0, 0, color[1].r, color[1].g, color[1].b, color[1].a},
            {x,   y+h, 0, 0, color[2].r, color[2].g, color[2].b, color[2].a},
            {x+w, y+h, 0, 0, color[3].r, color[3].g, color[3].b, color[3].a},
            {x+w, y,   0, 0, color[4].r, color[4].g, color[4].b, color[4].a},
        })
    elseif r and g and b then
        self.rect = love.graphics.newMesh({
            {x,   y,   0, 0, r, g, b, a},
            {x,   y+h, 0, 0, r, g, b, a},
            {x+w, y+h, 0, 0, r, g, b, a},
            {x+w, y,   0, 0, r, g, b, a},
        })
    else
        self.rect = love.graphics.newMesh({
            {x,   y},
            {x,   y+h},
            {x+w, y+h},
            {x+w, y},
        })
    end

    return self
end

function rect:draw()
    love.graphics.draw(self.rect, 0, 0)
end

return rect
