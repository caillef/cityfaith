local propsModule = {}

local props = {}

propsModule.getAll = function(_)
    return props
end

propsModule.create = function(_, propType)
    local prop = Object()
    prop.destroyed = false

    local propInfo = gameConfig.PROPS[propType]
    prop.hp = propInfo.hp
    prop.id = math.random(100000000, 1000000000)
    prop.type = propInfo.skill
    Object:Load(propInfo.objFullname, function(obj)
        obj:SetParent(prop)
        obj.Scale = propInfo.scale
        local box = Box()
        box:Fit(obj, true)
        obj.Pivot = Number3(obj.Width / 2, box.Min.Y + obj.Pivot.Y, obj.Depth / 2)
        require("hierarchyactions"):applyToDescendants(obj, { includeRoot = true }, function(o)
            o.Physics = PhysicsMode.Disabled
        end)
    end)

    prop.damage = function(prop, dmg, source)
        if prop.destroyed then return end
        prop.hp = prop.hp - dmg
        if prop.hp <= 0 then
            prop:destroy()
        end
    end

    prop.destroy = function(prop)
        if prop.destroyed then return end
        prop.destroyed = true
        for k, p in ipairs(props) do
            if p == prop then table.remove(props, k) end
        end
        if prop.onDestroy then
            prop:onDestroy()
        end
        prop.IsHidden = true
        Timer(1, function()
            prop:RemoveFromParent()
        end)
    end

    table.insert(props, prop)

    return prop
end

propsModule.createSpawner = function(self, type, x, y)
    local propSpawner = Object()
    propSpawner:SetParent(World)
    common.setPropPosition(propSpawner, x, y)

    local spawn
    spawn = function()
        local prop = self:create(type)
        prop:SetParent(propSpawner)
        prop.LocalPosition = { 0, 0, 0 }
        prop.onDestroy = function()
            Timer(5, function()
                spawn()
            end)
        end
    end
    spawn()

    return propSpawner
end

-- local function createCharacterBox()
--     local bonus = Object()
--     local box = Box()
--     box.Min = { -4, 0, -4 }
--     box.Max = { 4, 0, 4 }
--     bonus.CollisionBox = box
--     bonus.Physics = PhysicsMode.Trigger

--     local shape = MutableShape()
--     shape:AddBlock(Color.Blue, 0, 0, 0)
--     shape.Pivot = { 0.5, 0, 0.5 }
--     shape:SetParent(bonus)
--     shape.Scale = 5
--     shape.Physics = PhysicsMode.Disabled

--     local function executeBonus()
--         local list = { "lumberjack", "miner", "ranger" }
--         local character = createCharacter(list[math.random(#list)])
--         squad:add(character)
--     end

--     bonus.OnCollisionBegin = function(_, other)
--         if other == squad then
--             bonus.OnCollisionBegin = nil
--             bonus:RemoveFromParent()
--             executeBonus()
--         end
--     end

--     return bonus
-- end

return propsModule
