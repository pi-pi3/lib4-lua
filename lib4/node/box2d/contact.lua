
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

    self.children = {coll:getChildren()}
    self.fixtures = {coll:getFixtures()}
    self.normal = {coll:getNormal()}
    self.positions = {coll:getPositions()}
    self.restitution = coll:getRestitution()
    self.friction = coll:getFriction()
    self.restitution_orig = coll:getRestitution()
    self.friction_orig = coll:getFriction()
    self.enabled = coll:isEnabled()
    self.touching = coll:isTouching()
    self.t = {}
    self.t[0] = coll:type()
    self.t['Object'] = true
    self.t['Contact'] = true

    return self
end

function contact.rev(coll)
    local self = {}
    setmetatable(self, mt)

    local a, b
    a, b = coll:getChildren()
    self.children = {b, a}

    a, b = coll:getFixtures()
    self.fixtures = {b, a}

    local nx, ny = coll:getNormal()
    self.normal = {-nx, -ny}

    self.positions = {coll:getPositions()}
    self.restitution = coll:getRestitution()
    self.friction = coll:getFriction()
    self.enabled = coll:isEnabled()
    self.touching = coll:isTouching()
    self.t = coll:type()

    return self
end

function contact:getChildren() return unpack(self.children) end
function contact:getFixtures() return unpack(self.fixtures) end
function contact:getNormal() return unpack(self.normal) end
function contact:getPositions() return unpack(self.positions) end
function contact:getRestitution() return self.restitution end
function contact:getFriction() return self.friction end
function contact:isEnabled() return self.enabled end
function contact:isTouching() return self.touching end
function contact:resetFriction() self.friction = self.friction_orig end
function contact:resetRestitution() self.restitution = self.restitution_orig end
function contact:setEnabled(p) self.enabled = p end
function contact:setFriction(a) self.friction = a end
function contact:setRestitution(a) self.friction = a end
function contact:type() return self.t[0] end
function contact:typeOf(t) return self.t[t] end

return contact
