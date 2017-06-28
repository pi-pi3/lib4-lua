
--[[ vec2.lua
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

local vec2 = {}
setmetatable(vec2, {__call = vec2.new})

local mt = {
    __index = vec2,
    __add = function(lhs, rhs) vec2(lhs.x+rhs.x, lhs.y+rhs.y) end,
    __sub = function(lhs, rhs) vec2(lhs.x-rhs.x, lhs.y-rhs.y) end,
    __mul = function(lhs, rhs) vec2(lhs.x*rhs, lhs.y*rhs) end,
    __div = function(lhs, rhs) vec2(lhs.x/rhs, lhs.y/rhs) end,
}

function vec2.new(x, y)
    local self = {}
    setmetatable(self, mt)

    self.x = x or 0
    self.y = y or x

    return self
end

function vec2:add(v)
    self.x = self.x + v.x
    self.y = self.y + v.y

    return self
end

function vec2:subtract(v)
    self.x = self.x - v.x
    self.y = self.y - v.y

    return self
end

function vec2:multiply(scalar)
    self.x = self.x * scalar
    self.y = self.y * scalar

    return self
end

function vec2:divide(scalar)
    self.x = self.x / scalar
    self.y = self.y / scalar

    return self
end

function vec2:dot(v)
    return self.x*v.x + self.y*v.y
end

function vec2:set(v)
    self.x = v.x
    self.y = v.y

    return self
end

-- project an arbitrary 2d point `a` 
--   onto an axis `i` 
--   in relation to point `p`
function vec2:proj(i, p)
    p = p or vec2()

    local v = self-p
    local r = v:len() * v:dot(i)
    return p + i*r
end

return vec2
