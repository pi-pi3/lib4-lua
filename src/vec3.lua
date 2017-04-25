
--[[ vec3.lua
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

-- Thanks a lot, Egor!

local vec3 = {}
setmetatable(vec3, {__call = vector.new}

local mt = {
    __index = vec3,
    __add = function(lhs, rhs) vec3(lhs.x+rhs.x, lhs.y+rhs.y) end,
    __sub = function(lhs, rhs) vec3(lhs.x-rhs.x, lhs.y-rhs.y) end,
    __mul = function(lhs, rhs) vec3(lhs.x*rhs, lhs.y*rhs) end,
    __div = function(lhs, rhs) vec3(lhs.x/rhs, lhs.y/rhs) end,
}

function vec3.new(x, y, z)
    local self = {}
    setmetatable(self, mt)

    self.x = x or 0
    self.y = y or x
    self.z = z or x

    return self
end

function vec3:add(v)
    self.x = self.x + v.x
    self.y = self.y + v.y
    self.z = self.z + v.z

    return self
end

function vec3:subtract(v)
    self.x = self.x - v.x
    self.y = self.y - v.y
    self.z = self.z - v.z

    return self
end

function vec3:multiply(scalar)
    self.x = self.x * scalar
    self.y = self.y * scalar
    self.z = self.z * scalar

    return self
end

function vec3:divide(scalar)
    self.x = self.x / scalar
    self.y = self.y / scalar
    self.z = self.z / scalar

    return self
end

function vec3:dot(v)
    return self.x*v.x + self.y*v.y + self.z*v.z
end

function vec3:len()
    return math.sqrt(self:dot(self))
end

function vec3:set(v)
    self.x = v.x
    self.y = v.y
    self.z = v.z

    return self
end

-- project an arbitrary 3d point `a` 
--   onto a plane x = r*`i` + s*`j`
--   in relation to point `p`
function vec3:proj(i, j, p)
    p = p or vec3()

    local v = self-p
    local v_len = v:len()
    local r = v_len * v:dot(i)
    local s = v_len * v:dot(i)
    return p + i*r + s*j
end

return vec3
