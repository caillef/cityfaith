local CHARACTERS = {
    lumberjack = {
        skills = { gather = true, chop = true, attack = { type = "melee" } },
        avatarName = "caillef",
        tool = "littlecreator.lc_iron_axe"
    },
    ranger = {
        skills = { gather = true, attack = { type = "range" } },
        avatarName = "soliton",
        tool = "xavier.bow",
        toolScale = 0.5
    },
    miner = {
        skills = { gather = true, mine = true, attack = { type = "range" } },
        avatarName = "gdevillele",
        tool = "divergonia.pickaxe"
    },
}

local PROPS = {
    tree = {
        skill = "chop",
        objFullname = "voxels.ash_tree",
        drops = {
            oak_log = { 2, 3 },
            wooden_stick = { 1, 2 }
        },
        scale = 0.5,
        hp = 3,
    },
    goblin = {
        skill = "attack",
        objFullname = "voxels.goblin_axeman",
        scale = 0.5,
        hp = 5,
    },
    bush = {
        skill = "gather",
        objFullname = "voxels.bush",
        drops = {
            wooden_stick = { 1, 2 }
        },
        scale = 0.5,
        hp = 1,
    },
    iron = {
        skill = "mine",
        objFullname = "voxels.iron_ore",
        drops = {
            iron = { 2, 3 }
        },
        scale = 0.5,
        hp = 10,
    }
}

local SKILLS = {
    chop = {
        callback = function(character, action)
            if action.object.destroyed then
                character:setAction()
            end
            character.model.Animations.SwingRight:Play()
            action.object:damage(1)
        end
    },
    attack = {
        callback = function(character, action)
            if action.object.destroyed then
                character:setAction()
            end
            character.model.Animations.SwingRight:Play()
            action.object:damage(1)
        end
    },
    gather = {
        callback = function(character, action)
            if action.object.destroyed then
                character:setAction()
            end
            character.model.Animations.SwingRight:Play()
            action.object:damage(1)
        end
    },
    mine = {
        callback = function(character, action)
            if action.object.destroyed then
                character:setAction()
            end
            character.model.Animations.SwingRight:Play()
            action.object:damage(1)
        end
    }
}

local RESOURCES = {
    {
        id = 1,
        key = "wooden_stick",
        name = "Wooden Stick",
        type = "item",
        fullname = "mutt.stick",
        item = {},
        icon = {
            rotation = { 0, -math.pi * 0.25, math.pi * 0.05 },
            pos = { 0, 0 },
            scale = 2,
        },
    },
    {
        id = 2,
        key = "iron",
        name = "Iron",
        type = "block",
        block = { color = Color.LightGrey },
    },
    {
        id = 3,
        key = "oak_log",
        name = "Oak Log",
        type = "item",
        fullname = "voxels.oak",
        item = {},
        icon = {
            rotation = { 0, -math.pi * 0.25, math.pi * 0.05 },
            pos = { 0, 0 },
            scale = 2,
        },
    },
}

local RESOURCES_BY_ID = {}
local RESOURCES_BY_KEY = {}

for _, v in ipairs(RESOURCES) do
    RESOURCES_BY_KEY[v.key] = v
    RESOURCES_BY_ID[v.id] = v

    if v.fullname then
        print("Loading", v.fullname)
        Object:Load(v.fullname, function(obj)
            print("obj loaded", v.fullname, obj)
            v.cachedShape = v.assetTransformer and v.assetTransformer(obj) or obj
        end)
    end
end

local gameConfig = {
    CHARACTERS = CHARACTERS,
    PROPS = PROPS,
    SKILLS = SKILLS,
    RESOURCES = RESOURCES,
    RESOURCES_BY_ID = RESOURCES_BY_ID,
    RESOURCES_BY_KEY = RESOURCES_BY_KEY,
}

local common = {}

common.MAP_SCALE = 10

common.setPropPosition = function(obj, x, y)
    obj.Position = { (x + 0.5) * common.MAP_SCALE, 0, (y + 0.5) * common.MAP_SCALE }
end

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
    prop:SetParent(World)
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
            if propInfo.drops then
                for dropName, quantityRange in pairs(propInfo.drops) do
                    LocalEvent:Send("InvAdd", {
                        key = "hotbar",
                        rKey = dropName,
                        amount = math.floor(math.random() * (quantityRange[2] - quantityRange[1])) + quantityRange[1],
                        callback = function(success)
                            if success then
                                return
                            end
                        end,
                    })
                end
            end
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
        prop.Physics = false
        Timer(1, function()
            prop:RemoveFromParent()
        end)
    end

    prop.remove = function(_)
        prop.onDestroy = nil
        prop:RemoveFromParent()
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
