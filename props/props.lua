local CHARACTERS = {
    gatherer = {
        skills = { gather = true },
        avatarName = "soliton",
        slots = 30
    },
    lumberjack = {
        skills = { chop = true, gather = true },
        avatarName = "caillef",
        tool = "littlecreator.lc_iron_axe",
        slots = 5
    },
    miner = {
        skills = { mine = true, gather = true },
        avatarName = "gdevillele",
        tool = "divergonia.pickaxe",
        slots = 5
    },
}

local WORLDS = {
    forest = {
        name = "the Whispering Woods",
        color = Color(116, 183, 46),
        props = {
            tree = 50,
            bush = 50,
            stone = 30,
            iron = 10
        }
    },
    desert = {
        name = "the Golden Dunes",
        color = Color(239, 221, 111),
        props = {
            stone = 60,
            iron = 20,
            gold = 10,
            bush = 5,
        }
    },
    magicland = {
        name = "the Arcane Territories",
        color = Color(170, 51, 106),
        props = {
            tree = 30,
            stone = 60,
            gold = 25,
            bush = 20,
        }
    },
    plateau = {
        name = "the Skyreach Plateau",
        color = Color(167, 167, 167),
        props = {
            tree = 5,
            stone = 60,
            iron = 30,
            gold = 10,
        }
    }
}

local PROPS = {
    tree = {
        skill = "chop",
        objFullname = "voxels.ash_tree",
        drops = {
            wood_log = { 2, 3 },
            wooden_stick = { 1, 2 }
        },
        scale = 0.8,
        hp = 3,
    },
    bush = {
        skill = "gather",
        objFullname = "voxels.bush",
        drops = {
            wooden_stick = { 1, 2 }
        },
        scale = 0.8,
        hp = 1,
    },
    berry_bush = {
        skill = "gather",
        objFullname = "voxels.berry_bush",
        drops = {
            wooden_stick = { 0, 1 },
            berry = { 1, 2 }
        },
        scale = 0.8,
        hp = 1,
    },
    stone = {
        skill = "mine",
        objFullname = "voxels.stone_ore",
        drops = {
            stone = { 2, 3 }
        },
        scale = 0.8,
        hp = 6,
    },
    iron = {
        skill = "mine",
        objFullname = "voxels.iron_ore",
        drops = {
            iron = { 2, 3 }
        },
        scale = 0.8,
        hp = 10,
    },
    gold = {
        skill = "mine",
        objFullname = "voxels.gold_ore",
        drops = {
            iron = { 1, 3 }
        },
        scale = 0.8,
        hp = 20,
    }
}

local BUILDINGS = {
    house = {
        -- level 0 = 1 people in squad
        -- level 1 = 2 people in squad
        -- level 2 = 4 people in squad
        level = 0,
        repairPrices = {
            {
                wood_log = 1,
                stone = 1
            },
            {
                wood_log = 2,
                stone = 2
            }
        },
        repairDurations = { 5, 10 },
        item = "caillef.shop2",
        itemScale = 0.75,
        color = Color.Red,
        scale = 15,
        x = 5,
        y = 4,
    },
    workshop = {
        -- level 1 = can upgrade squad boots level 2, squad inventory
        -- level 2 = can upgrade squad boots level 3, squad inventory
        level = 0,
        repairPrices = {
            {
                wood_log = 1,
                stone = 1
            },
            {
                wood_log = 2,
                stone = 2
            }
        },
        repairDurations = { 5, 10 },
        item = "wrden.workbench",
        itemScale = 0.75,
        color = Color.Brown,
        scale = 25,
        x = 5,
        y = -4
    },
    market = {
        -- level 1 = sell for coins
        level = 0,
        repairPrices = {
            {
                wood_log = 1,
                stone = 1
            }
        },
        repairDurations = { 5 },
        color = Color.Yellow,
        item = "voxels.market_stall",
        itemScale = 0.75,
        scale = 25,
        x = -5,
        y = 4,
    },
    forge = {
        -- level 1 = can upgrade characters tool (mining speed) level 2
        -- level 2 = can upgrade characters tool (mining speed) level 3
        level = 0,
        repairPrices = {
            {
                wood_log = 1,
                stone = 1
            },
            {
                wood_log = 1,
                stone = 1
            },
        },
        repairDurations = { 5, 10 },
        color = Color.Grey,
        item = "voxels.simple_furnace",
        itemScale = 0.75,
        scale = 25,
        x = -5,
        y = -4
    }
}

local SKILLS = {
    chop = {
        callback = function(character, action)
            if action.object.destroyed then
                character:setAction()
            end
            local damaged = action.object:damage(1)
            if damaged then
                require("sfx")("wood_impact_" .. math.floor(math.random(1, 5)), { Spatialized = false, Volume = 0.6 })
                character.model.Animations.SwingRight:Play()
            end
        end
    },
    gather = {
        callback = function(character, action)
            if action.object.destroyed then
                character:setAction()
            end
            local damaged = action.object:damage(1)
            if damaged then
                require("sfx")("walk_sand_" .. math.floor(math.random(1, 5)), { Spatialized = false, Volume = 0.6 })
                character.model.Animations.SwingRight:Play()
            end
        end
    },
    mine = {
        callback = function(character, action)
            if action.object.destroyed then
                character:setAction()
            end
            local damaged = action.object:damage(1)
            if damaged then
                require("sfx")("metal_clanging_" .. math.floor(math.random(1, 8)), { Spatialized = false, Volume = 0.6 })
                character.model.Animations.SwingRight:Play()
            end
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
        key = "wood_log",
        name = "Wood Log",
        type = "item",
        fullname = "voxels.oak",
        item = {},
        icon = {
            rotation = { 0, -math.pi * 0.25, math.pi * 0.05 },
            pos = { 0, 0 },
            scale = 2,
        },
    },
    {
        id = 3,
        key = "stone",
        name = "Stone",
        type = "item",
        fullname = "voxels.stone_ore",
        item = {},
        icon = {
            rotation = { 0, -math.pi * 0.25, math.pi * 0.05 },
            pos = { 0, 0 },
            scale = 2,
        },
    },
    {
        id = 4,
        key = "iron",
        name = "Iron",
        type = "item",
        fullname = "voxels.iron",
        item = {},
        icon = {
            rotation = { 0, -math.pi * 0.25, math.pi * 0.05 },
            pos = { 0, 0 },
            scale = 2,
        },
    },
    {
        id = 5,
        key = "gold",
        name = "Gold",
        type = "item",
        fullname = "voxels.gold",
        item = {},
        icon = {
            rotation = { 0, -math.pi * 0.25, math.pi * 0.05 },
            pos = { 0, 0 },
            scale = 2,
        },
    },
    {
        id = 6,
        key = "berry",
        name = "Berry",
        type = "item",
        fullname = "chocomatte.tomato",
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
        Object:Load(v.fullname, function(obj)
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
    BUILDINGS = BUILDINGS,
    WORLDS = WORLDS,
}

local common = {}

common.MAP_SCALE = 10
common.TIME_TO_BUILD_BUILDING = 5
common.ADVENTURE_DURATION = 15

common.setPropPosition = function(obj, x, y)
    obj.Position = { (x + 0.5) * common.MAP_SCALE, 0, (y + 0.5) * common.MAP_SCALE }
end

local progressBarModule = {}

progressBarModule.create = function(_, config)
    local ui = require("uikit")

    local barBg = ui:createFrame(Color.Black)
    local bar = ui:createFrame(config.color or Color.Green)
    bar:setParent(barBg)

    barBg.parentDidResize = function()
        barBg.Width = config.width and config.width(barBg) or 100
        barBg.Height = config.height and config.height(barBg) or 30
        local pos = config.pos(barBg)
        if pos then
            barBg:show()
            barBg.pos = pos
        else
            barBg:hide()
        end
        bar.Height = barBg.Height
    end
    barBg:parentDidResize()

    barBg.setPercentage = function(_, percentage)
        bar.Width = barBg.Width * percentage
    end

    return barBg
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
    for i = #props, 1, -1 do
        props[i]:destroy()
    end
    props = {}
end

propsModule.create = function(_, propType, x, y)
    local prop = Object()
    prop:SetParent(World)
    prop.destroyed = false

    local hpBar, hpBarTickListener
    local propInfo = gameConfig.PROPS[propType]
    prop.hp = propInfo.hp
    prop.maxHp = prop.hp
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
            o.Shadow = true
        end)
    end)

    prop.damage = function(prop, dmg, source)
        if prop.destroyed then return false end
        if not hpBar then
            hpBar = progressBarModule:create({
                color = Color.Red,
                width = function() return 40 end,
                height = function() return 8 end,
                pos = function(bar)
                    local propScreenPos = Camera:WorldToScreen(prop.Position)
                    if not propScreenPos then
                        bar:hide()
                        return Number2(0, 0)
                    end
                    local pos = propScreenPos * Number2(Screen.Width, Screen.Height) + Number2(-25, 5)
                    bar:show()
                    return pos
                end
            })
            hpBarTickListener = LocalEvent:Listen(LocalEvent.Name.Tick, function(dt)
                if not prop or not hpBar then return end
                local propScreenPos = Camera:WorldToScreen(prop.Position)
                if not propScreenPos then
                    hpBar:hide()
                    return
                end
                local pos = propScreenPos * Number2(Screen.Width, Screen.Height) + Number2(-25, 10)
                hpBar:show()
                hpBar.pos = pos
            end)
        end
        prop.hp = prop.hp - dmg
        if prop.hp <= 0 then prop.hp = 0 end
        hpBar:setPercentage(prop.hp / prop.maxHp)
        if prop.hp <= 0 then
            prop:destroy()
            if propInfo.drops then
                for dropName, quantityRange in pairs(propInfo.drops) do
                    local randomRange = math.random() * (quantityRange[2] - quantityRange[1])
                    local quantity = math.floor(randomRange) + quantityRange[1]
                    LocalEvent:Send("InvAdd", {
                        key = "hotbar",
                        rKey = dropName,
                        amount = quantity,
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
            if p == prop then
                table.remove(props, k)
                break
            end
        end
        if hpBar then
            hpBarTickListener:Remove()
            hpBar:remove()
            hpBar = nil
        end
        if prop.onDestroy then
            prop:onDestroy()
        end
        require("hierarchyactions"):applyToDescendants(prop, { includeRoot = true }, function(o)
            o.IsHidden = true
            o.Physics = PhysicsMode.Disabled
        end)
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
