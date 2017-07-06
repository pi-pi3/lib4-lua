
--[[ lib4/init.lua
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

local node = require('lib4/node')
local file = require('lib4/file')

local lib4 = {}

lib4.delta = 1/100
lib4.phys_delta = 1/50

function lib4.update_rate(rate, phys_rate)
    if rate and rate > 0 then
        lib4.delta = 1/rate
    elseif rate and rate == 0 then
        lib4.delta = 0
    end

    if phys_rate and phys_rate > 0 then
        lib4.phys_delta = 1/phys_rate
    elseif phys_rate and phys_rate == 0 then
        lib4.phys_delta = 0
    end
end

function lib4.set_root(root)
    if type(root) == 'string' then
        lib4.root = file.load_node(root)
    else
        lib4.root = root
    end
    lib4.root.id = 'root'
    lib4.root:signal('load')
end

function lib4.load_splash()
    if file.exists('assets://splash.node') then
        lib4.set_root('assets://splash.node')
    else
        local splash = node()
        splash:set_script(require('lib4/splash'))
        lib4.set_root(splash)
    end
end

function lib4.load_game()
    if file.exists('assets://root.node') then
        lib4.set_root('assets://root.node')
    else
        lib4.set_root(node())
    end
end

return lib4
