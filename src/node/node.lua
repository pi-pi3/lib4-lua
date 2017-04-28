
--[[ node.lua
    Copyright (c) 2017 Szymon "pi_pi3" Walter, Szymon Bednarek

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

local node = {}
local mt = {__index = node}

-- Create a new empty node
function node.new()
    local self = {}
    setmetatable(self, mt)

    self.t = "node"

    self.position = cpml.vec3()
    self.rotation = cpml.quaternion()
    self.scale = cpml.vec3(1.0)
    self.children = {}

    return self
end

-- Draw the node
function node:draw()
    -- push()
    -- if self.origin then identity()
    -- translate
    -- rotate
    -- scale
    -- draw
    -- pop()
end

-- Update physics, etc.
function node:update()
end

-- Send a signal to all children (recursively by default)
-- Any function can be considered a signal
function node:signal(s, recurse)
    recurse = (recurse == nil and true) or recurse

    for _, c in self.children do
    end
end

-- Adds a child
function node:add_child(c, n)
    if n and n > 1 then
        for i = 1, n do
            table.insert(self.children, c[i])
        end
    else
        table.insert(self.children, c)
    end
end

return node
