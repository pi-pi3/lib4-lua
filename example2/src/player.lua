
local rect = require('lib4/node/box2d/rectangle')
local player = {}

function player:_load()
    self.speed = 22000
    self.jump = 80000
    self.coll_ground = {}
    self.ground = 0
    self.hop_time = 0.25
    self.hop = 0.0
end

function player:on_ground()
    return self.ground > 0
end

function player:_update(dt)
    if self.hop > 0.0 then self.hop = self.hop - dt end
end

function player:_keydown(_, key)
    if self:on_ground() then
        if key == 'h' then
            self.body:applyLinearImpulse(-self.speed, -self.jump*0.25)
            self.hop = self.hop_time
        elseif key == 'l' then
            self.body:applyLinearImpulse(self.speed, -self.jump*0.25)
            self.hop = self.hop_time
        elseif key == 'k' then
            if love.keyboard.isScancodeDown('h', 'l') then
                self.body:applyLinearImpulse(0, -self.jump*0.7)
            else
                self.body:applyLinearImpulse(0, -self.jump)
            end
        end
    else
        local mult = 1
        local jmult = 0
        if self.hop > 0.0 then
            mult = 7.5
            jmult = 1
        end
        if key == 'h' then
            self.body:applyForce(-self.speed*mult, -self.jump*jmult)
        elseif key == 'l' then
            self.body:applyForce(self.speed*mult, -self.jump*jmult)
        end
    end
end

function player:_pre_contact(shape, other, other_shape, coll)
    local nx, ny = coll:getNormal()
    if ny >= 0.85 and not self.coll_ground[other:name()] then -- approx. 45 deg
        self.coll_ground[other:name()] = true
        self.ground = self.ground + 1
    end
end

function player:_post_contact(shape, other, other_shape, coll)
    if self.coll_ground[other:name()] then
        self.coll_ground[other:name()] = nil
        self.ground = self.ground - 1
    end
end

return player
