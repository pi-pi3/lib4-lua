
local bullet = {}

function bullet:_load()
    self.dmg = 1
    self.life = 5
end

function bullet:on_ground()
    return self.ground > 0
end

function bullet:_update(dt)
    self.life = self.life - dt
    if self.life <= 0 then
        self:remove()
    end
end

function bullet:_pre_contact(shape, other, other_shape, coll)
end

function bullet:_post_contact(shape, other, other_shape, coll)
end

function bullet:_pre_solve(shape, other, other_shape, coll)
    if other.body:getType() == 'static' then
        coll:setEnabled(true)
    else
        coll:setEnabled(false)
    end
end

return bullet
