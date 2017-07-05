
local rect = require('lib4/node/box2d/rectangle')
local player = {}

function player:_load()
    self:set_params()
    self:add(rect(0, 0, 24, 24))

    self.speed = 220000
    self.jump = 61000
    self.on_ground = false
end

function player:_keydown(_, key)
    local mult = 1
    if not self.on_ground then
        mult = 0.5
    end

    if key == 'h' then
        self.body:applyForce(-self.speed*mult, 0)
    elseif key == 'l' then
        self.body:applyForce(self.speed*mult, 0)
    elseif key == 'k' and self.on_ground then
        self.body:applyLinearImpulse(0, -self.jump)
    end
end

function player:_pre_contact(other, coll)
    local nx, ny = coll:getNormal()
    print('pre', nx, ny)
    if ny > 0.85 then -- approx. 45 deg
        self.on_ground = true
    end
end

function player:_post_contact(other, coll)
    local nx, ny = coll:getNormal()
    print('post', nx, ny)
    if ny == 0 then -- approx. 45 deg
        self.on_ground = false
    end
end

return player
