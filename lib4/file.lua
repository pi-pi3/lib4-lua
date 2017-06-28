
--[[ file.lua Filesystem utils
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

local iqm = require('iqm')
local file = {}

function file.load()
    declare('scheme', {})
    scheme.root = '/'
    scheme.assets = 'assets/'
    scheme.src = 'src/'
end

function file.expand(path)
    for s, val in pairs(s) do
        if util.startswith(path, s .. ':') then
            return scheme.root .. scheme[s] .. string.sub(path, #s+ 2)
        elseif util.startswith(path, s .. '://') then
            return scheme.root .. scheme[s] .. string.sub(path, #s+ 4)
        end
    end

    return path
end

function file.load_image(path)
    local tex = love.graphics.newImage(file.expand(path), {mipmaps = true})
    tex:setFilter('nearest', 'nearest')
end

function file.load_model(path)
    return iqm.load(file.expand(path))
end

function file.load_anims(path)
    return iqm.load_anims(file.expand(path))
end

return file
