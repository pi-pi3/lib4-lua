
--[[ phys/intersects
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

local i = {}

function i.intersects(self, other)
    if self.t == 'phys2d/polygon' and other.t == 'phys2d/polygon' then
        return i.polygon_polygon(self, other)
    elseif self.t == 'phys2d/circle' and other.t == 'phys2d/circle' then
        return i.circle_circle(self, other)
    end
end

function i.polygon_polygon(self, other)
end

function i.circle_circle(self, other)
    local d = self.position - other.position
    local dist2 = d.x*d.x + d.y*d.y
    local ang = d:to_polar()

    local a1 = self.radius.x
    local b1 = self.radius.y

    local a2 = other.radius.x
    local b2 = other.radius.y

    local r1
    if a1 == b1 then
        r1 = a1
    else
        local ang1 = ang-self.rotation
        local as1 = a1*math.sin(ang1)
        local bc1 = b1*math.cos(ang1)
        local r1 = a1*b1/math.sqrt(as1*as1+bc1*bc1)
    end

    local r2
    if a2 == b2 then
        r2 = a2
    else
        local ang2 = ang-other.rotation
        local as2 = a2*math.sin(ang1)
        local bc2 = b2*math.cos(ang1)
        local r2 = a2*b2/math.sqrt(as2*as2+bc2*bc2)
    end

    return (r1+r2)*(r1+r2) < dist2
end

return i.intersects
