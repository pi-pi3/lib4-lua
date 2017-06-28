
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

-- global definitions
require('autobatch')
love3d = require('lo3d')
util = require('util')
lgui = require('lgui')
log = require('log')
declare = util.declare -- global alias for declare, should work in every file

function love.load()
    math.randomseed(os.time()) -- don't forget your randomseed!
    love.keyboard.setKeyRepeat(true)

    -- this is called in love.load, because some external libraries might
    -- require global variables
    util.init_G()

    love3d.load()

    -- beyond this point in program execution every global variable has to be
    -- declared like this:
    declare('scheme', {})
    scheme.root = '/'
    scheme.assets = 'assets/'
    scheme.src = 'src/'

    declare('game', {})

    -- initial game state is the menu, but you can change it into a splash
    -- screen for example
    game.state = require('game')
    pcall(game.state.load)
end


function love.update(dt)
    if not game.state.pause
        and game.state.root then
        game.state.root:signal('f_update', dt)
    end

    if not game.state.pause
        and game.state.update then
        pcall(game.state.update, dt)
    end

    lgui.updateall(game.state.elements)
end

function love.draw()
    if love3d.enabled then
        love3d.clear()
    end

    if game.state.root then
        game.state.root:signal('f_draw')
    end

    if game.state.draw then
        pcall(game.state.draw)
    end

    lgui.drawall(game.state.elements)
end


-- functions beyond this point normally don't have to be editted
function love.mousepressed(mx, my, button)
    if not game.state.pause
        and game.state.root then
        game.state.root:signal('f_mousepressed', mx, my, button)
    end

    if not game.state.pause
        and game.state.mousepressed then
        pcall(game.state.mousepressed, mx, my, button)
    end

    if button == 1 then
        lgui.mousepressed(game.state.elements, mx, my)
    end
end

function love.mousereleased(mx, my, button)
    if not game.state.pause
        and game.state.root then
        game.state.root:signal('f_mousereleased', mx, my, button)
    end

    if not game.state.pause
        and game.state.mousereleased then
        pcall(game.state.mousereleased, mx, my, button)
    end

    if button == 1 then
        lgui.mousereleased(game.state.elements, mx, my)
    end
end

function love.mousemoved(mx, my, dx, dy)
    if not game.state.pause
        and game.state.root then
        game.state.root:signal('f_mousemoved', mx, my, dx, dy)
    end

    if not game.state.pause
        and game.state.mousemoved then
        pcall(game.state.mousemoved, mx, my, dx, dy)
    end

    lgui.mousemoved(game.state.elements, mx, my, dx, dy)
end

function love.wheelmoved(dx, dy)
    if not game.state.pause
        and game.state.root then
        game.state.root:signal('f_wheelmoved', dx, dy)
    end

    if not game.state.pause
        and game.state.wheelmoved then
        pcall(game.state.wheelmoved, dx, dy)
    end

    lgui.wheelmoved(game.state.elements, dx, dy)
end

function love.textinput(c)
    if not game.state.pause
        and game.state.root then
        game.state.root:signal('f_textinput', c)
    end

    if not game.state.pause
        and game.state.textinput then
        pcall(game.state.textinput, mx, my, dx, dy)
    end

    lgui.textinput(game.state.elements, c)
end

function love.keypressed(key, scancode, isrepeat)
    if not game.state.pause
        and game.state.root then
        game.state.root:signal('f_keypressed', key, scancode, isrepeat)
    end

    if not game.state.pause
        and game.state.keypressed then
        pcall(game.state.keypressed, key, scancode, isrepeat)
    end

    lgui.keypressed(game.state.elements, key, scancode, isrepeat)
end

function love.quit()
    if not game.state.pause
        and game.state.root then
        game.state.root:signal('f_quit')
    end

    if game.state.quit then
        pcall(game.state.quit)
    end
end

