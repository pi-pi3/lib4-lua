
--[[ node/gui/button.lua
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
local button = {}
local mt = {__index = button}

function button.new(opts, children)
    local self = element.new(opts, children)
    setmetatable(self, mt)

    self.t = 'gui/button'

    opts = opts or {}
    self.text = opts.text
    self.downcolor = opts.downcolor or {127, 127, 127}
    self.textcolor = opts.textcolor or self.framecolor

    return self
end

function button:draw()
    if self.down then
        love.graphics.setColor(self.downcolor)
    else
        love.graphics.setColor(self.color)
    end
    love.graphics.rectangle('fill', 0, 0, self.width, self.height)

    love.graphics.setColor(self.framecolor)
    love.graphics.setLineStyle('smooth')
    love.graphics.setLineWidth(self.line_width)

    if self.text then
        love.graphics.printf(self.text, 0, 0, self.width, self.align)
    end
end

setmetatable(button, {
    __index = element,
    __call = button.new
})

return button
