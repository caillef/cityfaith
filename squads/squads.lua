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
        color = Color(116, 183, 46),
        props = {
            tree = 50,
            bush = 50,
            stone = 30,
            iron = 10
        }
    },
    desert = {
        color = Color(239, 221, 111),
        props = {
            stone = 60,
            iron = 20,
            gold = 10,
            bush = 5,
        }
    },
    magicland = {
        color = Color(170, 51, 106),
        props = {
            tree = 30,
            stone = 60,
            gold = 25,
            bush = 20,
        }
    },
    plateau = {
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
        scale = 0.5,
        hp = 3,
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
    berry_bush = {
        skill = "gather",
        objFullname = "voxels.berry_bush",
        drops = {
            wooden_stick = { 0, 1 },
            berry = { 1, 2 }
        },
        scale = 0.5,
        hp = 1,
    },
    stone = {
        skill = "mine",
        objFullname = "voxels.stone_ore",
        drops = {
            stone = { 2, 3 }
        },
        scale = 0.5,
        hp = 6,
    },
    iron = {
        skill = "mine",
        objFullname = "voxels.iron_ore",
        drops = {
            iron = { 2, 3 }
        },
        scale = 0.5,
        hp = 10,
    },
    gold = {
        skill = "mine",
        objFullname = "voxels.gold_ore",
        drops = {
            iron = { 1, 3 }
        },
        scale = 0.5,
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
        fullname = "voxels.stone",
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
common.ADVENTURE_DURATION = 5

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

local squadModule = {}

local propsModule
squadModule.setPropsModule = function(_, module)
    propsModule = module
end

local function equipRightHand(avatar, shapeOrItem)
    local shape = nil
    if shapeOrItem ~= nil then
        if type(shapeOrItem) == "Shape" or type(shapeOrItem) == "MutableShape" then
            shape = shapeOrItem
        elseif type(shapeOrItem) == "Item" then
            shape = Shape(shapeOrItem)
            if not shape then
                error("Player:EquipRightHand(equipment) - equipment can't be loaded", 2)
            end
        else
            error("Player:EquipRightHand(equipment) - equipment parameter should be a Shape or Item", 2)
        end
    end

    if avatar.__rightHandItem == shape then
        -- equipment already installed
        return
    end

    if avatar.__rightHandItem ~= nil and avatar.__rightHandItem:GetParent() == avatar.RightHand then
        avatar.__rightHandItem:RemoveFromParent()
        -- restore its physics attributes
        avatar.__rightHandItem.Physics = avatar.__rightHandItem.__savePhysics
        avatar.__rightHandItem.CollisionGroups = avatar.__rightHandItem.__saveCollisionGroups
        avatar.__rightHandItem.CollidesWithGroups = avatar.__rightHandItem.__saveCollidesWithGroups
        -- lose reference on it
        avatar.__rightHandItem = nil
    end
    if shape == nil then
        return
    end
    -- reset shape Pivot to center
    shape.Pivot = Number3(shape.Width * 0.5, shape.Height * 0.5, shape.Depth * 0.5)
    -- disable Physics
    shape.__savePhysics = shape.Physics
    shape.__saveCollisionGroups = shape.CollisionGroups
    shape.__saveCollidesWithGroups = shape.CollidesWithGroups
    shape.Physics = PhysicsMode.Disabled
    shape.CollisionGroups = {}
    shape.CollidesWithGroups = {}
    avatar.__rightHandItem = shape
    -- Notes about lua Point:
    -- `poi.Coords` is a simple getter and returns the value as it was stored
    -- `poi.LocalPosition` performs a block to local transformation w/ associated shape
    -- get POI rotation
    local poiRot = shape:GetPoint("ModelPoint_Hand_v2").Rotation
    local compatRotation = false -- V1 & legacy POIs conversion
    if poiRot == nil then
        poiRot = shape:GetPoint("ModelPoint_Hand").Rotation
        if poiRot == nil then
            poiRot = shape:GetPoint("Hand").Rotation
        end
        if poiRot ~= nil then
            compatRotation = true
        else
            -- default value
            poiRot = Number3(0, 0, 0)
        end
    end
    -- get POI position
    local poiPos = shape:GetPoint("ModelPoint_Hand_v2").LocalPosition
    if poiPos == nil then
        poiPos = shape:GetPoint("ModelPoint_Hand").LocalPosition
        if poiPos == nil then
            -- backward-compatibility: Item Editor saved POI position in local space and item hasn't been edited since
            -- Note: engine cannot update POI in local space when the item is resized
            poiPos = shape:GetPoint("Hand").Coords -- get stored value as is
            if poiPos ~= nil then
                poiPos = -1.0 * poiPos
            else
                poiPos = Number3(0, 0, 0)
            end
        end
    end
    -- Item Editor saves POI position in model space (block coordinates), in order to ignore resize offset ;
    -- convert into hand local space
    local localHandPoint = poiPos:Copy()
    localHandPoint = -localHandPoint -- relative to hand point instead of item pivot
    localHandPoint:Rotate(poiRot)
    if compatRotation then
        localHandPoint:Rotate(Number3(0, 0, math.pi * 0.5))
    end
    localHandPoint = localHandPoint * shape.LocalScale
    poiPos = localHandPoint
    shape:SetParent(avatar.RightHand)
    shape.LocalRotation = poiRot
    shape.LocalPosition = poiPos + avatar.RightHand:GetPoint("palm").LocalPosition
    if compatRotation then
        shape:RotateLocal(Number3(0, 0, 1), math.pi * 0.5)
    end
end

local function createCharacter(charaType)
    local charaInfo = gameConfig.CHARACTERS[charaType]

    local character = Object()

    local model = require("avatar"):get(charaInfo.avatarName)
    model:SetParent(character)
    model.Scale = 0.45
    model.Physics = PhysicsMode.Disabled
    character.model = model
    if charaInfo.tool then
        Object:Load(charaInfo.tool, function(obj)
            equipRightHand(model, obj)
            require("hierarchyactions"):applyToDescendants(obj, { includeRoot = true }, function(o)
                o.Physics = PhysicsMode.Disabled
            end)
            obj.Scale = charaInfo.toolScale or 1
        end)
    end

    local action
    local t = 0
    local nextActionTick = 0
    local cooldown = 1.0

    character.setAction = function(_, newAction)
        if action == nil and newAction == nil then return end

        if action.id and action.id == newAction.id and newAction.type ~= "idle" then return true end
        if action and action.cancelAction then
            action:cancelAction()
        end

        if newAction.type ~= "idle" and not charaInfo.skills[newAction.type] then return end

        action = newAction
        nextActionTick = t
        return true
    end

    character.actionTick = function(_, dt)
        t = t + dt

        local needToMove = action and (character.Position - action.Position).SquaredLength > 3 or false

        local squadMotion = character:GetParent().Motion
        local anims = character.model.Animations
        if squadMotion == Number3(0, 0, 0) and not needToMove then
            if anims.Walk.IsPlaying then
                anims.Walk:Stop()
                anims.Idle:Play()
            end
        else
            if anims.Idle.IsPlaying then
                anims.Idle:Stop()
                anims.Walk:Play()
            end
        end

        if not action then
            return
        end

        character.Forward = (action.Position + squadMotion) - character.Position
        character.Rotation.X = 0
        character.Rotation.Z = 0
        if needToMove then
            local dir = action.Position - character.Position
            dir:Normalize()
            character.Position = character.Position + dir * dt * 20
        elseif nextActionTick <= t then
            nextActionTick = t + cooldown
            local skill = gameConfig.SKILLS[action.type]
            if not skill then return end
            skill.callback(character, action)
        end
    end

    return character
end

squadModule.create = function(_, defaultCharacterList)
    local squad = Object()
    squad:SetParent(World)
    squad.Physics = PhysicsMode.Dynamic
    squad.CollisionGroups = Player.CollisionGroups
    squad.CollidesWithGroups = Player.CollidesWithGroups
    squad.freezed = false

    local characters = {}
    squad.add = function(_, character)
        character:SetParent(squad)
        table.insert(characters, character)
        character.LocalPosition = { 0, 0, 0 }
    end

    squad.freeze = function()
        squad.freezed = true
    end

    squad.unfreeze = function()
        squad.freezed = false
    end

    squad.setPosition = function(_, x, y)
        common.setPropPosition(squad, x, y)
        for _, c in ipairs(characters) do
            c.LocalPosition = { 0, 0, 0 }
        end
    end

    squad.reset = function()
        for _, c in ipairs(characters) do
            c:setAction({ type = "idle", Position = squad.Position })
        end
    end

    for _, defaultCharacterType in ipairs(defaultCharacterList) do
        local character = createCharacter(defaultCharacterType)
        squad:add(character)
    end

    local polygonBuilder = require("polygonbuilder")
    local handle = polygonBuilder:create({
        nbSides = 32,
        color = Color.White,
        thickness = 0.1,
        size = 40,
    })
    handle:SetParent(squad)
    handle.Rotation.X = math.pi * 0.5
    local movingCircle = handle
    local handle = polygonBuilder:create({
        nbSides = 32,
        color = Color.White,
        thickness = 2,
        size = 40,
    })
    handle:SetParent(squad)
    handle.Rotation.X = math.pi * 0.5
    local actionCircle = handle

    local moving = false
    local function findActions()
        if moving then
            local nbCharacters = #characters - 1
            for k, c in ipairs(characters) do
                local posX = 0
                local posZ = 0
                if k > 7 then
                    local nb = math.min(12, nbCharacters - 6)
                    posX = math.cos(((k - 7) / nb) * math.pi * 2) * 20
                    posZ = math.sin(((k - 7) / nb) * math.pi * 2) * 20
                elseif k > 1 then
                    local nb = math.min(6, nbCharacters)
                    posX = math.cos((k / nb) * math.pi * 2) * 10
                    posZ = math.sin((k / nb) * math.pi * 2) * 10
                end
                c:setAction({ type = "idle", Position = squad.Position + Number3(posX, 0, posZ) })
            end
            return
        end

        local availableTasks = {}
        for _, prop in ipairs(propsModule:getAll()) do
            local dist = (prop.Position - squad.Position).Length
            if dist <= 40 then
                prop.object = prop
                table.insert(availableTasks, { prop = prop, dist = dist })
            end
        end
        table.sort(availableTasks, function(a, b) return a.dist > b.dist end)
        for _, c in ipairs(characters) do
            if #availableTasks == 0 then
                c:setAction()
            else
                for i = #availableTasks, 1, -1 do
                    local task = availableTasks[i]
                    if c:setAction(task.prop) then
                        if task.prop.hp == 1 then
                            table.remove(availableTasks, i)
                        end
                        break
                    end
                end
            end
        end
    end

    LocalEvent:Listen(LocalEvent.Name.Tick, function(dt)
        if squad.freezed then return end
        if squad.Motion == Number3(0, 0, 0) then
            if moving then
                moving = false
                actionCircle.IsHidden = false
            end
        else
            if moving == false then
                moving = true
                actionCircle.IsHidden = true
            end
        end

        findActions()
        for _, c in ipairs(characters) do
            c:actionTick(dt)
        end
    end)

    common.setPropPosition(squad, 0, 0)

    return squad
end

return squadModule
