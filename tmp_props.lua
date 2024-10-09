local propsModule = {}

local props = {}
local spawners = {}

propsModule.getAll = function(_)
    return props
end

propsModule.clearAllSpawners = function()
    for _, spawner in ipairs(spawners) do
        spawner:remove()
    end
    spawners = {}
end

propsModule.clearAllProps = function()
    for _, prop in ipairs(props) do
        prop:remove()
    end
    props = {}
end

propsModule.create = function(_, propType, x, y)
    local prop = Object()
    prop.destroyed = false

    local propInfo = gameConfig.PROPS[propType]
    prop.hp = propInfo.hp
    prop.id = math.random(100000000, 1000000000)
    prop.type = propInfo.skill
    Object:Load(propInfo.objFullname, function(obj)
        obj:SetParent(prop)
        obj.Scale = propInfo.scale
        common.setPropPosition(prop, x, y)
        obj.LocalPosition = { 0, 0, 0 }
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
    local currentProp
    local currentTimer
    spawn = function()
        local prop = self:create(type)
        currentProp = prop
        prop:SetParent(propSpawner)
        prop.LocalPosition = { 0, 0, 0 }
        prop.onDestroy = function()
            prop = nil
            currentTimer = Timer(5, function()
                spawn()
            end)
        end
    end
    spawn()

    propSpawner.remove = function(_)
        if currentProp then
            currentProp:RemoveFromParent()
        end
        if currentTimer then
            currentTimer:Cancel()
        end
        propSpawner:RemoveFromParent()
        propSpawner = nil
    end

    table.insert(spawners, propSpawner)
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
