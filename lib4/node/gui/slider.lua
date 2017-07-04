
--[[ node/gui/slider.lua
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

local element = require('lib4/node/gui/element')
local slider = {}
local mt = {__index = slider}

function slider.new(opts, children)
    local self = element.new(opts, children)
    setmetatable(self, mt)

    self.t = 'gui/slider'

    opts = opts or {}
    self.value = opts.value or 0
    self.round = opts.round or false
    self.min = opts.min or 0
    self.max = opts.max or 1

    return self
end

function slider:draw()
    element.draw(self)

    love.graphics.rectangle(self.value/(self.max-self.min), self.height/2
                            self.height, self.height)
end

function slider:mousemoved(x, y, dx, dy)
    if not self.down then
        return
    end

    self.value = util.clamp(x/self.width * (self.max-self.min) + self.min,
                            self.min, self.max)

    if self.round == 'floor' then
        self.value = math.floor(self.value)
    elseif self.round == 'ceil' then
        self.value = math.ceil(self.value)
    elseif self.round == 'round'
        or self.round == true then
        self.value = math.floor(self.value+0.5)
    end
end

setmetatable(slider, {
    __index = element,
    __call = function(_, ...) return slider.new(...) end 
})

return slider
