
--[[ node/box2d/init.lua
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

local contact = {}
local mt = {__index = contact}

function contact.new(coll)
    local self = {}
    setmetatable(self, mt)

    self.coll = coll
    self.children = {coll:getChildren()}
    self.fixtures = {coll:getFixtures()}
    self.normal = {coll:getNormal()}

    return self
end

function contact.rev(coll)
    local self = {}
    setmetatable(self, mt)

    self.coll = coll

    local a, b
    a, b = coll:getChildren()
    self.children = {b, a}

    a, b = coll:getFixtures()
    self.fixtures = {b, a}

    local nx, ny = coll:getNormal()
    self.normal = {-nx, -ny}

    return self
end

function contact:getChildren() return unpack(self.children) end
function contact:getFixtures() return unpack(self.fixtures) end
function contact:getNormal() return unpack(self.normal) end
function contact:getPositions() return self.coll:getPositions() end
function contact:getRestitution() return self.coll:getRestitution() end
function contact:getFriction() return self.coll:getFriction() end
function contact:isEnabled() return self.coll:isEnabled() end
function contact:isTouching() return self.coll:isTouching() end
function contact:resetFriction() self.coll:resetFriction(); self.friction = self.coll:getFriction() end
function contact:resetRestitution() self.coll:resetRestitution(); self.friction = self.coll:getRestitution() end
function contact:setEnabled(p) self.enabled = p; self.coll:setEnabled(p) end
function contact:setFriction(a) self.friction = a; self.coll:setFriction(a) end
function contact:setRestitution(a) self.restitution = a; self.coll:setRestitution(a) end
function contact:type() return coll:type() end
function contact:typeOf(t) return coll:typeOf(t) end

return contact
