
--[[ node/init.lua
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

local node = {}
local mt = {__index = node}

-- Create a new empty node
function node.new(children)
    local self = {}
    setmetatable(self, mt)

    self.t = "node"
    self.id = nil
    self.parent = nil
    self.children = {}

    if children then
        if children.t then
            self:add(children)
        else
            self:addn(children)
        end
    end

    return self
end

function node:set_script(script, load)
    self.script = script

    for k, v in pairs(script) do
        if not util.startswith(k, '_') then
            self[k] = v
            script[k] = nil
        end
    end

    if load == nil or load then
        if script._load then
            dcall(script._load, self)
        end
    end
end

-- Create an identical node without inheriting children
function node:clone()
    local new = {}
    setmetatable(new, getmetatable(self))

    new.t = self.t
    new.script = self.script
    new.children = {}

    for k, v in pairs(self) do
        if k ~= 'children' then
            new[k] = util.copy(v, true)
        end
    end

    if new.script then
        new:set_script(new.script)
    end

    return new
end

-- Send a signal to all children (recursively)
-- Any function can be considered a signal
function node:signal(s, ...)
    local success = true
    local result = nil
    local err = nil

    if self[s] then
        local s, err = dcall(self[s], self, ...)
        if s == false then
            success = false
            err = err
        end
        if result == nil then
            result = err
        end
    end

    if self.script and self.script['_' .. s] then
        local s, err = dcall(self.script['_' .. s], self, ...)
        if s == false then
            success = false
            err = err
        end
        if result == nil then
            result = err
        end
    end

    for _, c in pairs(self.children) do
        local s, err = c:signal(s, ...)
        if s == false then
            success = false
            err = err
        end
        if result == nil then
            result = err
        end
    end

    if success then
        return true, result
    else
        return false, err
    end
end

function node:name()
    if self.parent then
        return self.parent:name() .. '.' .. self.id
    else
        return self.id
    end
end

-- Set an arbitrary key to value
function node:set(k, v)
    if k ~= t and k ~= 'children' then
        self[k] = v
    end
end

-- Adds a child
function node:add(c, k)
    k = k or #self.children + 1
    self.children[k] = c

    c.parent = self
    c.id = k
end

-- Adds a table of children
function node:addn(c)
    for k, v in pairs(c) do
        self:add(v, k)
    end
end

-- Remove a child
function node:remove(k)
    if not k or k and k == 'self' then
        self:signal('destroy')
        if self.parent and self.id then
            self.parent.remove(self.id)
        end
    else
        self.children[k]:signal('destroy')
        self.children[k] = nil
    end
end

-- Find a child
function node:find(k)
    if type(k) == 'table' then
        if k[1] == 'self' or k[1] == self.id then
            if #k == 1 then
                return self
            end
            table.remove(k, 1)
        end

        local c = k[1]
        table.remove(k, 1)
        self.children[c]:find(k)
    elseif type(k) == 'string' then
        return self:find(string.tmatch(k, '[%a%d_]*'))
    end
end

setmetatable(node, {__call = function(_, ...) return node.new(...) end })

return node
