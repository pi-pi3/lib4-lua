
--[[ lo3d.lua A wrapper around excessive's love3d
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

local l3d = require('love3d');
l3d.import()

local love3d = {}
setmetatable(love3d, {__index = l3d})

local cpml = require('cpml')

local static_shader = [[
    varying vec3 f_normal;

#ifdef VERTEX
    attribute vec3 VertexNormal;

    uniform mat4 u_model;
    uniform mat4 u_view;
    uniform mat4 u_proj;

    vec4 position(mat4 _, vec4 vertex) {
        f_normal = mat3(u_model) * VertexNormal;
        return u_proj * u_view * u_model * vertex;
    }
#endif

#ifdef PIXEL
    vec4 effect(vec4 _col, Image s_color, vec2 uv, vec2 _sc) {
        vec4 col = texture2D(s_color, uv);
        return vec4(col.rgb, 1.0);
    }
#endif
]]

local anim_shader = [[
    varying vec3 f_normal;

#ifdef VERTEX
    attribute vec4 VertexWeight;
    attribute vec4 VertexBone;
    attribute vec3 VertexNormal;

    uniform mat4 u_model;
    uniform mat4 u_view;
    uniform mat4 u_proj;
    uniform mat4 u_pose[100];

    vec4 position(mat4 _, vec4 vertex) {
        mat4 skeleton = u_pose[int(VertexBone.x*255.0)] * VertexWeight.x +
                        u_pose[int(VertexBone.y*255.0)] * VertexWeight.y +
                        u_pose[int(VertexBone.z*255.0)] * VertexWeight.z +
                        u_pose[int(VertexBone.w*255.0)] * VertexWeight.w;

        mat4 transform = u_model*skeleton;

        f_normal = mat3(transform) * VertexNormal;
        
        return u_proj * u_view * transform * vertex;
    }
#endif

#ifdef PIXEL
    vec4 effect(vec4 _col, Image s_color, vec2 uv, vec2 _sc) {
        vec4 col = texture2D(s_color, uv);
        return vec4(col.rgb, 1.0);
    }
#endif
]]

function love3d.load()
    love3d.static_shader = love.graphics.newShader(static_shader)
    love3d.anim_shader = love.graphics.newShader(anim_shader)

    love3d.model = {cpml.mat4()}
    love3d.view = {cpml.mat4()}
    love3d.proj = {cpml.mat4()}
    love3d.mat = 'model'
    love3d.matrix_up = {model = false, view = false, proj = false}

    cpml.mat4.identity(love3d.model[1])
    cpml.mat4.identity(love3d.view[1])
    cpml.mat4.identity(love3d.proj[1])

    love3d.enable()
end

function love3d.enable(p)
    if p or p == nil then 
        love3d.enabled = true

        love3d.set_shader(love3d.static_shader)
        love3d.set_depth_test('less')
        love3d.set_culling('back')
    else 
        love3d.disable()
    end
end

function love3d.disable()
    love3d.enabled = false
    
    love3d.set_shader(nil)
    love3d.set_depth_test(nil)
    love3d.set_culling(nil)
end

function love3d.set_shader(shader)
    love3d.shader = shader
    love.graphics.setShader(shader)
end

function love3d.matrix_mode(mat)
    love3d.mat = mat
end

function love3d.stack()
    return love3d[love3d.mat]
end

function love3d.top()
    local stack = love3d.stack()
    return stack[#stack]
end

function love3d.pop()
    local stack = love3d[love3d.mat]
    local mat = util.copy(stack[#stack])
    table.remove(stack, #stack)
    return mat
end

function love3d.push()
    local stack = love3d[love3d.mat]
    local mat = util.copy(stack[#stack])
    stack[#stack+1] = mat
end

function love3d.transform()
    local model = love3d.model[#love3d.model]
    local view = love3d.view[#love3d.view]
    local proj = love3d.proj[#love3d.proj]

    love3d.shader:send('u_model', model:to_vec4s())
    love3d.shader:send('u_view', view:to_vec4s())
    love3d.shader:send('u_proj', proj:to_vec4s())

    love3d.matrix_up.model = false
    love3d.matrix_up.view = false
    love3d.matrix_up.proj = false
end

function love3d.identity()
    cpml.mat4.identity(love3d.top())
end

function love3d.translate(x, y, z)
    local xx, yy, zz
    if type(x) == 'table' then
        xx = x.x or x[1] or 0
        yy = x.y or x[2] or 0
        zz = x.z or x[3] or 0
    elseif type(x) == 'number' then
        xx = x or 0
        yy = y or 0
        zz = z or 0
    end

    local pos = cpml.vec3(xx, yy, zz)
    local mat = love3d.top()

    cpml.mat4.translate(mat, mat, pos)

    love3d.matrix_up[love3d.mat] = false
end

function love3d.rotate(w, x, y, z)
    local ww, xx, yy, zz
    if type(w) == 'table' then
        ww = w.w or w[4] or 0
        xx = w.x or w[1] or 0
        yy = w.y or w[2] or 0
        zz = w.z or w[3] or 0
    elseif type(w) == 'number' then
        ww = w or 0
        xx = x or 0
        yy = y or 0
        zz = z or 0
    end

    local rot = cpml.mat4.from_quaternion(cpml.quat(xx, yy, zz, ww))
    local mat = love3d.top()

    cpml.mat4.mul(mat, mat, rot)
    love3d.matrix_up[love3d.mat] = false
end

function love3d.scale(x, y, z)
    local xx, yy, zz
    if type(x) == 'table' then
        xx = x.x or x[1] or 0
        yy = x.y or x[2] or 0
        zz = x.z or x[3] or 0
    elseif type(x) == 'number' then
        xx = x or 0
        yy = y or 0
        zz = z or 0
    end

    local scale = cpml.vec3(xx, yy, zz)
    local mat = love3d.top()

    cpml.mat4.scale(mat, mat, scale)
    love3d.matrix_up[love3d.mat] = false
end

function love3d.ortho(l, r, t, b, n, f)
    local w = r-l
    local h = b-t
    local d = f-n
    local proj = cpml.mat4.new(
        {2/w, 0.0, 0.0,  -(r+l)/(r-l),
         0.0, 2/h, 0.0,  -(b+t)/(b-t),
         0.0, 0.0, -2/d, -(f+n)/(f-n),
         0.0, 0.0, 0.0,  1.0})

    local mat = love3d.top()
    cpml.mat4.mul(mat, mat, proj)
    love3d.matrix_up[love3d.mat] = false
end

function love3d.perspective(fov, aspect, zn, zf)
    local t = math.tan(math.rad(fov)/2)
    local proj = cpml.mat4.new(
        {1/(t*aspect), 0.0, 0.0,            0.0,
         0.0,          1/t, 0.0,            0.0,
         0.0,          0.0, (f+n)/(f-n),    1.0,
         0.0,          0.0, -(2*f*n)/(f-n), 0.0})

    local mat = love3d.top()
    cpml.mat4.mul(mat, mat, proj)
    love3d.matrix_up[love3d.mat] = false
end

function love3d.camera(pos, rot, origin)
    local ox = origin.x or origin[1] or 0
    local oy = origin.y or origin[2] or 0
    local oz = origin.z or origin[3] or 0

    local tx = pos.x or pos[1] or 0
    local ty = pos.y or pos[2] or 0
    local tz = pos.z or pos[3] or 0

    local rw = rot.w or rot[4] or 0
    local rx = rot.x or rot[1] or 0
    local ry = rot.y or rot[2] or 0
    local rz = rot.z or rot[3] or 0

    origin = -cpml.vec3(ox, oy, oz)
    pos = -cpml.vec3(tx, ty, tz)
    rot = cpml.mat4.from_quaternion(-cpml.quat(rx, ry, rz, rw))

    local mat = love3d.top()

    cpml.mat4.translate(mat, mat, origin)
    cpml.mat4.mul(mat, mat, rot)
    cpml.mat4.translate(mat, mat, -origin)
    cpml.mat4.translate(mat, mat, pos)
    love3d.matrix_up[love3d.mat] = false
end

function love3d.draw(model)
    if model.anim then
        love3d.set_shader(love3d.anim_shader)
    else
        love3d.set_shader(love3d.static_shader)
    end

    if not gfx.matrix_up.model then
        local model = love3d.model[#love3d.model]
        love3d.shader:send('u_model', model:to_vec4s())
    end

    if not gfx.matrix_up.view then
        local view = love3d.view[#love3d.view]
        love3d.shader:send('u_view', view:to_vec4s())
    end

    if not gfx.matrix_up.proj then
        local proj = love3d.proj[#love3d.proj]
        love3d.shader:send('u_proj', proj:to_vec4s())
    end

    for _, buffer in ipairs(model) do
        if model.textures then
            local texture = model.textures[buffer.material]
            model.mesh:setTexture(texture)
        end
        model.mesh:setDrawRange(buffer.first, buffer.last)
        love.graphics.draw(model.mesh)
    end
end

return love3d
