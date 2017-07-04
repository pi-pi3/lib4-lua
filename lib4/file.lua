
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
local json = require('json')
local cpml = require('cpml')

local file = {}

function file.load()
    declare('scheme', {})
    scheme.root = ''
    scheme.assets = 'assets/'
    scheme.src = 'src/'
end

function file.exists(path)
    return love.filesystem.exists(file.expand(path))
end

function file.expand(path)
    for s, val in pairs(scheme) do
        if util.startswith(path, s .. '://') then
            return scheme.root .. scheme[s] .. string.sub(path, #s + 4)
        elseif util.startswith(path, s .. ':') then
            return scheme.root .. scheme[s] .. string.sub(path, #s + 6)
        end
    end

    return path
end

function file.load_node(path)
    local types = {}

    function types.vec(val)
        if #val == 2 then
            return cpml.vec2(val[1], val[2])
        elseif #val == 3 then
            return cpml.vec3(val[1], val[2], val[3])
        elseif #val == 4 then
            return cpml.vec4(val[1], val[2], val[3], val[4])
        end
    end

    function types.quat(val)
        return cpml.quaternion(val[1], val[2], val[3], val[4])
    end

    function types.src(val)
        local _, src = dcall(file.load_src(val))
        return src
    end

    function types.img(val)
        return file.load_image(val)
    end

    function types.model(val)
        return file.load_model(val)
    end

    function types.node(val)
        return file.load_node(val)
    end

    function types.mesh(val)
        return love.graphics.newMesh(val)
    end

    local data
    if type(path) == 'string' then
        data = json.decode(love.filesystem.read(file.expand(path)))
    else
        data = path
    end

    for field, val in pairs(data) do
        for k, t in pairs(types) do
            if util.startswith(field, k .. ':') then
                local f = string.sub(field, #k + 2)
                data[f] = t(val)
                data[field] = nil
                break
            elseif util.startswith(field, '[' .. k .. ']:') then
                local f = string.sub(field, #k + 4)
                data[f] = util.map(val, function(_, v) return t(v) end)
                data[field] = nil
                break
            end
        end
    end

    local t
    if data.t == 'node' then
        t = require('lib4/node')
    else
        t = require('lib4/node/' .. data.t)
    end
    local node = t.new()

    for k, v in pairs(data) do
        node[k] = v
    end

    if node.script then
        node:set_script(node.script)
    end

    return node
end

function file.load_src(path)
    return love.filesystem.load(file.expand(path))
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
