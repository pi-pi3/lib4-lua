
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

-- set require path
local path = love.filesystem.getRequirePath()
love.filesystem.setRequirePath(path .. ';lib/?.lua;lib/?/init.lua;lib4/?.lua;lib4/?/init.lua')

lib4 = {}
lib4.keyevents = true
lib4.scancodes = {
    'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h',
    'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p',
    'q', 'r', 's', 't', 'u', 'v', 'w', 'x',
    'y', 'z',
    '1', '2', '3', '4', '5', '6',
    '7', '8', '9', '0',
    'return', 'escape', 'backspace', 'tab', 'space',
    '-', '=', '[', ']', '\\', 'nonus#', ';',
    '\'', '`', ',', '.', '/', 'capslock',
    'f1', 'f2', 'f3', 'f4', 'f5', 'f6', 'f7', 'f8',
    'f9', 'f10', 'f11', 'f12', 'f13', 'f14', 'f15', 'f16',
    'f17', 'f18', 'f19', 'f20', 'f21', 'f22', 'f23', 'f24',
    'lctrl', 'lshift', 'lalt', 'lgui', 'rctrl', 'rshift', 'ralt', 'rgui',
    'printscreen', 'scrolllock', 'pause', 'insert', 'home',
    'numlock', 'pageup', 'delete', 'end', 'pagedown',
    'right', 'left', 'down', 'up',
    'nonusbackslash', 'application', 'execute', 'help',
    'menu', 'select', 'stop', 'again', 'undo',
    'cut', 'copy', 'paste', 'find',
    'kp/', 'kp*', 'kp-', 'kp+', 'kp=', 'kpenter',
    'kp1', 'kp2', 'kp3', 'kp4', 'kp5', 'kp6',
    'kp7', 'kp8', 'kp9', 'kp0', 'kp.',
    'international1', 'international2', 'international3',
    'international4', 'international5', 'international6',
    'international7', 'international8', 'international9',
    'lang1', 'lang2', 'lang3', 'lang4', 'lang5',
    'mute', 'volumeup', 'volumedown', 'audionext', 'audioprev',
    'audiostop', 'audioplay', 'audiomute', 'mediaselect',
    'www', 'mail', 'calculator', 'computer', 'acsearch', 'achome',
    'acback', 'acforward', 'acstop', 'acrefresh', 'acbookmarks',
    'power', 'brightnessdown', 'brightnessup', 'displayswitch',
    'kbdillumtoggle', 'kbdillumdown', 'kbdillumup',
    'eject', 'sleep', 'alterase', 'sysreq', 'cancel', 'clear',
    'prior', 'return2', 'separator', 'out', 'oper', 'clearagain',
    'crsel', 'exsel', 'kp00', 'kp000', 'thsousandsseparator',
    'decimalseparator', 'currencyunit', 'currencysubunit', 'app1',
    'app2', 'unknown'
}

function lib4.enable_keyevents(p)
    lib4.keyevents = (p == nil) or p
end

function lib4.disable_keyevents()
    lib4.keyevents = false
end

-- global definitions
require('autobatch')
love3d = require('lo3d')
util = require('util')
lgui = require('lgui')
log = require('log')
declare = util.declare -- global alias for declare, should work in every file

local file = require('file')

function love.load()
    math.randomseed(os.time()) -- don't forget your randomseed!
    love.keyboard.setKeyRepeat(true)

    -- this is called in love.load, because some external libraries might
    -- require global variables
    util.init_G()

    love3d.load()
    file.load()

    -- beyond this point in program execution every global variable has to be
    -- declared like this:
    declare('game', {})

    -- initial game state is the menu, but you can change it into a splash
    -- screen for example
    game.state = require('init')
    if game.state.load then
        local success, err = pcall(game.state.load)
        if not success then
            log.error('lib4: ' .. err)
        end
    end
end

function love.update(dt)
    if lib4.keyevents then
        for scancode in {} do
            if love.keyboard.isScancodeDown(scancode) then
                local key = love.keyboard.getKeyFromScancode(scancode)
                love.keydown(key, scancode)
            end
        end
    end

    if not game.state.pause
        and game.state.root then
        game.state.root:signal('update', dt)
    end

    if not game.state.pause
        and game.state.update then
        local success, err = pcall(game.state.update, dt)
        if not success then
            log.error('lib4: ' .. err)
        end
    end

    lgui.updateall(game.state.elements)
end

function love.draw()
    if love3d.enabled then
        love3d.clear()
    end

    if game.state.root then
        game.state.root:signal('draw')
    end

    if game.state.draw then
        local success, err = pcall(game.state.draw)
        if not success then
            log.error('lib4: ' .. err)
        end
    end

    lgui.drawall(game.state.elements)
end

for _, func in pairs({
    'directorydropped', 'errhand', 'filedropped', 'focus',
    'keypressed', 'keyreleased', 'keydown', 'lowmemory',
    'mousefocus', 'mousemoved', 'mousepressed', 'mousereleased',
    'quit', 'resize', 'textedited', 'textinput',
    'threaderror', 'touchmoved', 'touchpressed', 'touchreleased',
    'visible', 'wheelmoved', 'gamepadaxis', 'gamepadpressed',
    'gamepadreleased', 'joystickadded', 'joystickaxis', 'joystickhat',
    'joystickpressed', 'joystickreleased', 'joystickremoved',
}) do
    love[func] = function(...)
        if not game.state.pause
            and game.state.root then
            game.state.root:signal(func, ...)
        end

        if not game.state.pause
            and game.state[func] then
            local success, err = pcall(game.state[func], ...)
            if not success then
                log.error('lib4: ' .. err)
            end
        end

        if lgui[func] then
            pcall(lgui[func], game.state.elements, ...)
        end
    end
end

