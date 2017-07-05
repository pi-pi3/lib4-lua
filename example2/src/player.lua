
local rect = require('lib4/node/box2d/rectangle')
local player = {}

function player:_load()
    self:set_params()
    self:add(rect(-12, -12, 24, 24))
end

function player:_phys_update(dt)
    print('delta: ' .. dt)
    print(self.body:getPosition())
end

return player
