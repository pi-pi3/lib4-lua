
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
setmetatable(node, {__call = node.new})
local mt = {__index = node}

-- Create a new empty node
function node.new(children, script)
    local self = {}
    setmetatable(self, mt)

    self.t = "node"
    self.script = script

    if children and children.t then
        self.children = {children}
    else
        self.children = children or {}
    end

    if script and script.load then
        local success, result = pcall(script.load, self)
        if not success then
            log.error('lib4: ' .. err)
        end
    end

    return self
end

-- Send a signal to all children (recursively)
-- Any function can be considered a signal
function node:signal(s, ...)
    local success = true
    local result = nil
    local err = nil

    if self[s] then
        local s, err = pcall(self[s], self, ...)
        if s == false then
            success = false
            err = err
            log.error('lib4: ' .. err)
        end
        if result == nil then
            result = err
        end
    end

    if self.script and self.script[s] then
        local s, err = pcall(self.script[s], self, ...)
        if s == false then
            success = false
            err = err
            log.error('lib4: ' .. err)
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

-- Set an arbitrary key to value
function node:set(k, v)
    if k ~= t and k ~= 'children' then
        self[k] = v
    end
end

-- Adds a child
function node:add(c, k)
    if k then
        self.children[k] = c
    else
        table.insert(self.children, c)
    end
end

-- Adds a table of children
function node:addn(c)
    for k, v in pairs(c) do
        self.children[k] = v
    end
end

-- Remove a child
function node:remove(k)
    self.children[k] = nil
end

-- Find a child
function node:find(k)
    return self.children[k]
end

return node
