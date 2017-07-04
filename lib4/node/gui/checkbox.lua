
--[[ node/gui/checkbox.lua
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
local checkbox = {}
local mt = {__index = checkbox}

function checkbox.new(opts, children)
    local self = element.new(opts, children)
    setmetatable(self, mt)

    self.t = 'gui/checkbox'

    return self
end

function checkbox:draw()
    element.draw(self)

    if self.toggle then
        love.graphics.lines(0, 0, self.width, self.height)
        love.graphics.lines(self.width, 0, 0, self.height)
    end
end

setmetatable(checkbox, {
    __index = element,
    __call = function(_, ...) return checkbox.new(...) end 
})

return checkbox
