
--[[ node/phys2d/rect.lua
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

local polygon = require('lib4/polygon')
local node = require('lib4/node')

local rect = {}
setmetatable(rect, {
    __index = polygon,
    __call = rect.new,
})

-- Create a new rect
function rect.new(shape, children, script)
    local x = shape.x or shape[1] or 0
    local y = shape.y or shape[2] or 0
    local w = shape.w or shape[3] or 0
    local h = shape.h or shape[4] or 0

    return polygon.new({x, y, x, y+h x+w, y+h, x+w, y}, children, script)
end

return rect
