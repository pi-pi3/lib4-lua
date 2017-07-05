
local rect = require('lib4/node/box2d/rectangle')
local player = {}

function player:_load()
    self:set_params()
    self:add(rect(0, 0, 24, 24))

    self.speed = 22000
    self.jump = 61000
    self.on_ground = false
end

function player:_keydown(_, key)
    if self.on_ground then
        if key == 'h' then
            self.body:applyLinearImpulse(-self.speed, -self.jump/4)
        elseif key == 'l' then
            self.body:applyLinearImpulse(self.speed, -self.jump/4)
        elseif key == 'k' then
            self.body:applyLinearImpulse(0, -self.jump)
        end
    else
        if key == 'h' then
            self.body:applyForce(-self.speed, 0)
        elseif key == 'l' then
            self.body:applyForce(self.speed, 0)
        end
    end
end

function player:_pre_contact(other, coll)
    local nx, ny = coll:getNormal()
    if ny > 0.85 then -- approx. 45 deg
        self.on_ground = true
    end
end

function player:_post_contact(other, coll)
    local nx, ny = coll:getNormal()
    if ny == 0 then -- approx. 45 deg
        self.on_ground = false
    end
end

return player
