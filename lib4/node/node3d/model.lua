
--[[ node/model.lua
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

local anim9 = require('anim9')
local node = require('lib4/node')

local model = {}
local mt = {__index = model}

-- Create a new model
function model.new(model, textures, anim, children)
    assert(model)

    local self = node.new(children)
    setmetatable(self, mt)

    self.t = "node3d/model"
    if type(model) == 'string' then
        self.model = file.load_model(model)
    else
        self.model = model
    end

    if type(model) == 'string' then
        self.model.textures = {}
        for k, t in pairs(textures) do
            self.model.textures[k] = file.load_image(t)
            assert(self.model.textures[k])
        end
    else
        self.model.textures = textures
    end

    if anim then
        if type(anim) == 'string' then
            self.model.anims = file.load_anims(anim)
        else
            self.model.anims = anim
        end
        self.model.anim = anim9(self.model.anims)
        assert(self.model.anim)

        self.anim = self.model.anim:add_track(anim)
        self.anim.playing = true
        self.model.anim:update(0)
    end

    return self
end

function model:draw()
    love3d.draw(self.model)
end

setmetatable(model, {
    __index = node,
    __call = function(_, ...) return model.new(...) end ,
})

return model
