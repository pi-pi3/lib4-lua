
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

function lib4.load()
    if file.exists('src://conf.lua') then
        local _, conf = dcall(file.load_src('src://conf.lua'))
        lib4.conf(conf)
    end
end

function lib4.set_root(root)
    if type(root) == 'string' then
        lib4.root = file.load_node(root)
    else
        lib4.root = root
    end
    lib4.root.id = 'root'
    if lib4.root.script and lib4.root.script.conf then
        lib4.conf(lib4.root.script.conf)
    end
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

function lib4.conf(f)
    local c = {}
    c.window = {}
    c.modules = {}
    dcall(f, c)

    c.window.vsync = false -- vsync breaks A LOT of things in lib4

    if c.identity then love.filesystem.setIdentity(c.identity) end

    for k,v in ipairs({'keyboard', 'mouse', 'audio', 'thread', 
                       'image', 'joystick', 'physics', 'video',
                       'sound', 'touch'}) do
        if c.modules[v] then
            require("love." .. v)
        elseif c.modules[v] == false then
            love[v] = nil
        end
    end

    if c.window.title then love.window.setTitle(c.window.title) end

    if c.window.icon then
        if not love.image then
            log.warn('window.icon require love.image')
        else
            love.window.setIcon(love.image.newImageData(c.window.icon))
        end
    end

    local width, height = love.window.getMode()
    width = c.window.width or width
    height = c.window.height or height
    c.window.title = nil
    c.window.icon = nil
    c.window.width = nil
    c.window.height = nil
    love.window.setMode(width, height, c.window)

    if love.physics then
        love.physics.setMeter(1)
    end
end

return lib4
