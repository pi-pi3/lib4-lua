
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

lib4.keyevents = false
lib4.scancodes = {
    'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h',
    'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p',
    'q', 'r', 's', 't', 'u', 'v', 'w', 'x',
    'y', 'z',
    '1', '2', '3', '4', '5',
    '6', '7', '8', '9', '0',
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
    'kp/', 'kp*', 'kp-', 'kp+', 'kp=', 'kpenter', 'kp.',
    'kp1', 'kp2', 'kp3', 'kp4', 'kp5',
    'kp6', 'kp7', 'kp8', 'kp9', 'kp0',
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

function lib4.set_root(root)
    if type(root) == 'string' then
        lib4.root = file.load_node(root)
    else
        lib4.root = root
    end
end

function lib4.load_splash()
    if file.exists('assets://splash.node') then
        lib4.set_root('assets://splash.node')
    else
        lib4.set_root(node())
        lib4.root:set_script(require('lib4/splash'))
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
