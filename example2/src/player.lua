
local rect = require('lib4/node/box2d/rectangle')
local player = {}

function player:_load()
    self:set_params()
    self:add(rect(0, 0, 24, 24))

    self.speed = 220000
    self.jump = 610000
end

function player:_update()
    print(self.body:getLinearVelocity())
end

function player:_keydown(_, key)
    if key == 'h' then
        self.body:applyForce(-self.speed, 0)
    elseif key == 'l' then
        self.body:applyForce(self.speed, 0)
    elseif key == 'k' then
        self.body:applyForce(0, -self.jump)
    end
end

return player
