
local button = {}

function button:_released()
    if self.down then
        lib4.set_root('assets://game.node')
    end
end

function button:_keypressed(key)
    if key == 'space' then
        lib4.set_root('assets://game.node')
    end
end

return button
