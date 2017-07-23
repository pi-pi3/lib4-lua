
local cpml = require('cpml')
local input = require('lib4/inpt')

local cam = {}

function cam:_load()
    input.add_keycode('left',    'h', 'a', 'left')
    input.add_keycode('right',   'l', 'd', 'right')
    input.add_keycode('up',      'i', 'r')
    input.add_keycode('down',    'u', 'f')
    input.add_keycode('forward', 'k', 'w', 'up')  
    input.add_keycode('back',    'j', 's', 'down')

    self.velocity = cpml.vec3()
end

function cam:_update(dt)
    self.position = self.position + self.velocity * dt
end

function cam:_keydown(_, _, key)
    if key == 'left' then
        self.velocity.x = -1
    elseif key == 'right' then
        self.velocity.x = 1
    else
        self.velocity.x = 0
    end

    if key == 'up' then
        self.velocity.y = 1
    elseif key == 'down' then
        self.velocity.y = -1
    else
        self.velocity.y = 0
    end

    if key == 'forward' then
        self.velocity.z = -1
    elseif key == 'back' then
        self.velocity.z = 1
    else
        self.velocity.z = 0
    end
end

return cam
