
--[[ list.lua
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

local list = {}
local mt = {
    __index = list,
    __newindex = function() end,
    __call = list.new,

    -- usage:
    --  local l1 = list(1)
    --  local l2 = l1 .. 2
    -- l2 is [1, 2]
    __concat = function(a, b) 
        a:append(list(b))
        return a
    end
}

function list.new(head, tail)
    if getmetatable(tail) ~= mt then
        error('list.lua: list.new(head, tail): tail must be a list')
    end
    return setmetatable({head = head, tail = tail}, mt)
end

function list.from_table(t, i)
    i = i or 1

    if not t[i] then
        return list(t[i])
    end

    return list.from_table(t, i+1):cons(list(t[i]))
end

function list.from(...)
    return list.from_table({...})
end

-- usage:
--  local l1 = list(2)
--  local l2 = l1:cons(1)
-- l2 is {head = 1, tail = {head = 2, tail = nil}}
function list:cons(val)
    return list(val, self)
end

-- usage:
--  local l1 = list(1)
--  local l2 = list(2)
--  local l3 = l1:append(l2)
function list:append(tail)
    if not self.tail then
        rawset(self, 'tail', tail)
        return
    end

    return self.tail:append(tail)
end

-- usage:
--  -- assume l1 is [1, 2, 3, 4, 5]
--  l1:remove_last()
-- l1 == [1, 2, 3, 4]
function list:remove_last()
    if self.tail ~= nil then
        if self.tail.tail == nil then
            self.tail = nil
            return
        end
    end

    return self.tail:remove_last()
end

-- usage:
--  -- assume l1 is [1, 2, 3, 4, 5]
--  x = l1:length()
-- x == 5
function list:length(acc)
    acc = acc or 0
    acc = acc + 1
    if not self.tail then
        return acc
    else
        return self.tail:length(acc)
    end
end

function list:map(fn)
    if not self.tail then
        return list(fn(self.head))
    end

    return self.tail:map(fn):cons(list(fn(self.head)))
end

function list:fold(fn, acc)
    if not self.tail then
        return fn(self.head, acc)
    end

    return self.tail:fold(fn, fn(self.head, acc))
end

function list:filter(fn)
    if not self.tail then
        if fn(self.head) then
            return list(self.head)
        else
            return nil
        end
    else
        if fn(self.head) then
            return self.tail:filter(fn):cons(self.head)
        else
            return self.tail:filter(fn)
        end
    end
end

return list
