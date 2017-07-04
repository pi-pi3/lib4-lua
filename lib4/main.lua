
--[[ main.lua Entry point in this game.
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

if arg[2] == '-d' or arg[2] == '--debug' then
    DEBUG = true
else
    DEBUG = false
end

if DEBUG then
    function dcall(func, ...)
        local success, result = pcall(func, ...)
        if not success then
            log.error('lib4: ' .. result)
        end
        return success, result
    end
else
    function dcall(func, ...)
        return true, func(...)
    end
end

-- set require path
local path = love.filesystem.getRequirePath()
love.filesystem.setRequirePath(path .. ';lib/?.lua;lib/?/init.lua')

-- global definitions
lib4 = require('lib4')

require('autobatch')
love3d = require('lib4/lo3d')
util = require('lib4/util')
log = require('log')
declare = util.declare -- global alias for declare, should work in every file

local file = require('lib4/file')
local phys = require('lib4/phys')
local node = require('lib4/node')

function love.load()
    math.randomseed(os.time()) -- don't forget your randomseed!
    love.math.setRandomSeed(os.time())
    love.keyboard.setKeyRepeat(true)

    -- this is called in love.load, because some external libraries might
    -- require global variables
    util.init_G()

    love3d.load()
    file.load()
    phys.load()

    lib4.load_splash()
end

function love.update(dt)
    if lib4.keyevents then
        for scancode, _ in ipairs(lib4.keysdown) do
            local key = love.keyboard.getKeyFromScancode(scancode)
            love.keydown(key, scancode)
        end
    end

    if lib4.root and not lib4.root.pause then
        lib4.root:signal('update', dt)
    end
end

function love.phys_update(dt)
    if lib4.root and not lib4.root.pause then
        lib4.root:signal('phys_update', dt)
    end
end

function love.draw()
    if love3d.enabled then
        love3d.clear()
    end

    if lib4.root then
        lib4.root:signal('draw')
    end
end

function love.keypressed(key, scancode, isrepeat)
    lib4.keysdown[scancode] = true

    if lib4.root and not lib4.root.pause then
        lib4.root:signal('keypressed', key, scancode, isrepeat)
    end
end

function love.keyreleased(key, scancode, isrepeat)
    lib4.keysdown[scancode] = nil

    if lib4.root and not lib4.root.pause then
        lib4.root:signal('keyreleased', key, scancode, isrepeat)
    end
end

for _, func in pairs({
    'directorydropped', 'errhand', 'filedropped', 'focus',
    'keydown', 'lowmemory',
    'mousefocus', 'mousemoved', 'mousepressed', 'mousereleased',
    'quit', 'resize', 'textedited', 'textinput',
    'threaderror', 'touchmoved', 'touchpressed', 'touchreleased',
    'visible', 'wheelmoved', 'gamepadaxis', 'gamepadpressed',
    'gamepadreleased', 'joystickadded', 'joystickaxis', 'joystickhat',
    'joystickpressed', 'joystickreleased', 'joystickremoved',
}) do
    love[func] = function(...)
        if lib4.root and not lib4.root.pause then
            lib4.root:signal(func, ...)
        end
    end
end

function love.run()
    dcall(love.load, arg)
 
    -- We don't want the first frame's dt to include time taken by love.load.
    love.timer.step()
 
    local delta = 0
    local phys_dt = 0
    local dt = 0
 
    -- Main loop time.
    while true do
        -- Process events.
        love.event.pump()
        for name, a,b,c,d,e,f in love.event.poll() do
            if name == "quit" then
                if not love.quit or not love.quit() then
                    return a
                end
            end
            dcall(love.handlers[name], a, b, c, d, e, f)
        end
 
        -- Update dt, as we'll be passing it to update
        love.timer.step()
        delta = love.timer.getDelta()
 
        if phys.enabled then
            phys_dt = phys_dt + delta
            if phys_dt >= lib4.phys_delta then
                dcall(love.phys_update, phys_dt)
                if lib4.phys_delta == 0 then
                    phys_dt = 0
                else
                    phys_dt = phys_dt - lib4.phys_delta
                end
            end
        end

        dt = dt + delta
        if dt >= lib4.delta then
            dcall(love.update, dt)
            if lib4.delta == 0 then
                dt = 0
            else
                dt = dt - lib4.delta
            end
        end
 
        if love.graphics.isActive() then
            love.graphics.clear(love.graphics.getBackgroundColor())
            love.graphics.origin()
            dcall(love.draw)
            love.graphics.present()
        end
 
        love.timer.sleep(0.001)
    end
end
