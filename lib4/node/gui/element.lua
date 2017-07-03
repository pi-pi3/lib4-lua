
--[[ node/gui/element.lua
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

local cpml = require('cpml')
local node = require('lib4/node')
local element = {}
local mt = {__index = element}

function element.new(opts, children)
    local self = node.new(children)
    setmetatable(self, mt)

    self.t = 'gui/element'

    self.pause = false
    self.active = true
    self.down = false
    self.toggle = false
    self.focus = false

    self.position = cpml.vec2()
    self.rotation = 0
    self.scale = cpml.vec2(1.0)

    self.width = 0
    self.height = 0

    self.align = 'center'
    self.font = love.graphics.getFont()
    self.color = {255, 255, 255}
    self.framecolor = {0, 0, 0}
    self.line_width = 1

    opts = opts or {}
    for k, v in pairs(opts) do
        self[k] = v
    end

    return self
end

function element:signal(s, ...)
    if s == 'draw' then
        love.graphics.push()

        love.graphics.translate(self.position.x, self.position.y)
        love.graphics.rotate(self.rotation)
        love.graphics.scale(self.scale.x, self.scale.y)

        love.graphics.stencil(function()
            love.graphics.rectangle(0, 0, self.width, self.height)
        end, 'replace', 1)
        love.graphics.setStencilTest('greater', 0)

        node.signal(self, s, ...)

        love.graphics.setStencilTest()
        love.graphics.pop()
    elseif util.startswith(s, 'mouse') then
        local x, y = ...
        x = x - self.position.x
        y = y - self.position.y
        if x >= 0 and x <= self.width
            and y >= 0 and y <= self.height then
            local s = string.sub(s, 6)
            node.signal(self, s, x, y, select(3, ...))
        end
        node.signal(self, s, x, y, select(3, ...))
    else
        node.signal(self, s, ...)
    end
end

function element:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle('fill', 0, 0, self.width, self.height)

    love.graphics.setColor(self.framecolor)
    love.graphics.setLineStyle('smooth')
    love.graphics.setLineWidth(self.line_width)
end

function element:pressed(x, y)
    self.down = true
end

function element:released(x, y)
    if self.down then
        self.toggle = not self.toggle
        self.focus = true
    end
end

function element:mousereleased(x, y)
    if x < 0 or x > self.width
        or y < 0 or y > self.height then
        if not self.down then
            self.focus = false
        end
    end
    self.down = false
end

function element:keypressed(key, scancode, isrepeat)
    if key == 'escape' then
        e.focus = false
    end
end

setmetatable(element, {
    __index = node,
    __call = element.new
})

return element
