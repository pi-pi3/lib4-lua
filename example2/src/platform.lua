
local rect = require('lib4/node/box2d/rectangle')
local platform = {}

function platform:_load()
    self:set_params()
    self:add(rect(-320, -45, 640, 90))
end

return platform
