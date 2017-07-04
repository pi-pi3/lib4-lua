
local button = {}

function button:_released()
    if self.down then
        love.event.quit()
    end
end

return button
