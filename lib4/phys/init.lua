
--[[ phys.lua Lightweight physics
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

local phys = {}
phys.intersects = require('lib4/phys/intersects')

function phys.load()
    phys.colliders = {}
    phys.enabled = false
end

function phys.enable(p)
    phys.enabled = (p == nil) or p
end

function phys.disable()
    phys.enabled = false
end

function phys.collides(a, b)
    if b then
        if a.children.body and b.children.body then
            if a.layer == b.layer or a.mask[b.layer] and b.mask[a.layer] then
                local a_body = a.children.body:transform(a.position, a.rotation, a.scale)
                local b_body = b.children.body:transform(b.position, b.rotation, b.scale)
                return a_body:collides(b_body)
            else
                return false
            end
        else
            return false
        end
    else
        for _, v in pairs(phys.colliders) do
            if phys.collides(a, v) then
                return true
            end
        end
    end
    return false
end

function phys.add(c, k)
    if k then
        phys.colliders[k] = c
    else
        table.insert(phys.colliders, c)
    end
end

function phys:addn(c)
    for k, v in pairs(c) do
        phys.colliders[k] = v
    end
end

function phys:remove(k)
    phys.colliders[k] = nil
end

function phys:find(k)
    return phys.colliders[k]
end

return phys
