local CHARACTERS = {
    gatherer = {
        skills = { gather = true },
        avatarName = Player.Username,
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
            bush = 40,
            berry_bush = 10,
            stone = 10,
            iron = 5
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
            wooden_stick = { 1, 3 }
        },
        scale = 0.8,
        hp = 1,
    },
    berry_bush = {
        skill = "gather",
        objFullname = "voxels.berry_bush",
        drops = {
            wooden_stick = { 0, 2 },
            berry = { 1, 2 }
        },
        scale = 0.8,
        hp = 3,
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
        name = "House",
        level = 0,
        repairPrices = {
            {
                wooden_stick = 5,
                berry = 1,
            },
            {
                wood_log = 10,
                stone = 5,
                berry = 5
            },
            {
                wood_log = 100,
                stone = 50,
                berry = 20
            }
        },
        repairDurations = { 5, 10 },
        item = "voxels.simple_cabin",
        description = "The House increase your squad maximum size.",
        itemScale = 0.75,
        color = Color.Red,
        scale = 15,
        rotation = 0.2 * math.pi,
        x = 5,
        y = 4,
    },
    workstation = {
        -- level 1 = can upgrade squad boots level 2
        -- level 2 = can upgrade squad boots level 3
        name = "Workstation",
        level = 0,
        repairPrices = {
            {
                wood_log = 5,
                stone = 3,
                iron = 2
            },
            {
                wood_log = 30,
                stone = 10,
                iron = 5
            },
            {
                wood_log = 60,
                stone = 30,
                iron = 15
            }

        },
        repairDurations = { 5, 10 },
        item = "voxels.simple_workstation",
        description = "The Workstation increases your characters speed.",
        itemScale = 0.75,
        color = Color.Brown,
        scale = 25,
        rotation = 0.2 * math.pi,
        x = 5,
        y = -4
    },
    market = {
        -- level 1 = sell for coins
        name = "Market",
        level = 0,
        repairPrices = {
            {
                wooden_stick = 10,
                stone = 2,
            },
            {
                wooden_stick = 30,
                wood_log = 10,
                stone = 10,
            },
            {
                wooden_stick = 50,
                wood_log = 30,
                stone = 50,
            },
        },
        repairDurations = { 5, 10, 20 },
        color = Color.Yellow,
        item = "voxels.market_stall",
        description = "The Market increases the number of golds received.",
        itemScale = 0.75,
        rotation = -0.2 * math.pi,
        scale = 25,
        x = -5,
        y = 4,
    },
    forge = {
        -- level 1 = can upgrade characters tool (mining speed) level 2
        -- level 2 = can upgrade characters tool (mining speed) level 3
        name = "Forge",
        level = 0,
        repairPrices = {
            {
                wood_log = 5,
            },
            {
                wood_log = 30,
                stone = 30,
                iron = 20,
            },
        },
        repairDurations = { 5, 10 },
        color = Color.Grey,
        item = "voxels.simple_furnace",
        description = "The Forge allows you to gather resources faster.",
        itemScale = 0.75,
        scale = 25,
        rotation = -0.2 * math.pi,
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
common.ADVENTURE_DURATION = 45

common.setPropPosition = function(obj, x, y)
    obj.Position = { (x + 0.5) * common.MAP_SCALE, 0, (y + 0.5) * common.MAP_SCALE }
end

common.equipRightHand = function(avatar, shapeOrItem)
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

local ui_blocks = {}

ui_blocks.createTriptych = function(_, config)
    local ui = require("uikit")

    local node = ui:createFrame(config.color)

    local dir = config.dir or "horizontal"

    local left = config.left or config.top
    local center = config.center
    local right = config.right or config.bottom

    if left then
        left:setParent(node)
    end
    if center then
        center:setParent(node)
    end
    if right then
        right:setParent(node)
    end

    node.parentDidResize = function()
        if not node.parent then
            return
        end
        node.Width = node.parent.Width
        node.Height = node.parent.Height

        if center then
            center.pos = { node.Width * 0.5 - center.Width * 0.5, node.Height * 0.5 - center.Height * 0.5 }
        end

        if dir == "horizontal" then
            if left then
                left.pos = { 0, node.Height * 0.5 - left.Height * 0.5 }
            end
            if right then
                right.pos = { node.Width - right.Width, node.Height * 0.5 - right.Height * 0.5 }
            end
        end
        if dir == "vertical" then
            if left then
                left.pos = { node.Width * 0.5 - left.Width * 0.5, node.Height - left.Height }
            end
            if right then
                right.pos = { node.Width * 0.5 - right.Width * 0.5, 0 }
            end
        end
    end

    return node
end

ui_blocks.createColumns = function(_, config)
    local ui = require("uikit")

    local node = ui:createFrame()

    local nodes = config.nodes

    local nbColumns = #nodes
    if not nbColumns or nbColumns < 1 then
        error("config.nodes must have at least two nodes")
        return
    end

    local columns = {}
    for i = 1, nbColumns do
        local column = ui:createFrame()
        nodes[i]:setParent(column)
        column:setParent(node)
        table.insert(columns, column)
    end
    node.columns = columns

    node.parentDidResize = function()
        if not node.parent then
            return
        end
        node.Width = node.parent.Width
        node.Height = node.parent.Height
        local columnWidth = math.floor(node.Width / nbColumns)
        for k, column in ipairs(columns) do
            column.Width = columnWidth
            column.Height = node.Height
            column.pos = { (k - 1) * columnWidth, 0 }
        end
    end

    return node
end

ui_blocks.createRows = function(_, config)
    local ui = require("uikit")

    local node = ui:createFrame()

    local nodes = config.nodes

    local nbRows = #nodes
    if not nbRows or nbRows < 1 then
        error("config.nodes must have at least two nodes")
        return
    end

    local rows = {}
    for i = 1, nbRows do
        local row = ui:createFrame()
        nodes[i]:setParent(row)
        row:setParent(node)
        table.insert(rows, row)
    end
    node.rows = rows

    node.parentDidResize = function()
        if not node.parent then
            return
        end
        node.Width = node.parent.Width
        node.Height = node.parent.Height
        local rowHeight = math.floor(node.Height / nbRows)
        for k, row in ipairs(rows) do
            row.Width = node.Width
            row.Height = rowHeight
            row.pos = { 0, node.Height - k * rowHeight }
        end
    end

    return node
end

ui_blocks.createLineContainer = function(_, config)
    local uiContainer = require("ui_container")

    local node
    if config.dir == "vertical" then
        node = uiContainer:createVerticalContainer()
    else
        node = uiContainer:createHorizontalContainer()
    end

    for _, info in ipairs(config.nodes) do
        if info.type == "separator" then
            node:pushSeparator()
        elseif info.type == "gap" then
            node:pushGap()
        elseif info.type == "node" then
            node:pushElement(info.node)
        else
            node:pushElement(info)
        end
    end

    return node
end

ui_blocks.setNodePos = function(_, node, horizontalAnchor, verticalAnchor, margins)
    margins = margins or 0
    if type(margins) ~= "table" then
        -- left, bottom, right, top
        margins = { margins, margins, margins, margins }
    end

    local x = 0
    local y = 0

    local parentWidth = node.parent and node.parent.Width or Screen.Width
    local parentHeight = node.parent and node.parent.Height or (Screen.Height - Screen.SafeArea.Top)

    if horizontalAnchor == "left" then
        x = margins[3]
    elseif horizontalAnchor == "center" then
        x = parentWidth * 0.5 - node.Width * 0.5
    elseif horizontalAnchor == "right" then
        x = parentWidth - margins[1] - node.Width
    end

    if verticalAnchor == "bottom" then
        y = margins[2]
    elseif verticalAnchor == "center" then
        y = parentHeight * 0.5 - node.Height * 0.5
    elseif verticalAnchor == "top" then
        y = parentHeight - margins[4] - node.Height
    end

    node.pos = { x, y }
end

-- Only works on node that are not resized // where parentDidResize is not set
-- If you need to define parentDidResize, use setNodePos
ui_blocks.anchorNode = function(_, node, horizontalAnchor, verticalAnchor, margins)
    node.parentDidResize = function()
        ui_blocks:setNodePos(node, horizontalAnchor, verticalAnchor, margins)
    end
    node:parentDidResize()
    return node
end

ui_blocks.createBlock = function(_, config)
    local ui = require("uikit")

    local node = ui:createFrame()

    local subnode
    if config.triptych then
        subnode = ui_blocks:createTriptych(config.triptych)
    elseif config.columns then
        subnode = ui_blocks:createColumns({ nodes = config.columns })
    elseif config.rows then
        subnode = ui_blocks:createRows({ nodes = config.rows })
    end
    subnode:setParent(node)

    node.parentDidResize = function()
        if config.parentDidResize then
            config.parentDidResize(node)
        end
        node.Width = config.width and config.width(node) or (node.parent and node.parent.Width or Screen.Width)
        node.Height = config.height and config.height(node)
            or (node.parent and node.parent.Height or Screen.Height - Screen.SafeArea.Top)
        node.pos = config.pos and config.pos(node) or { 0, 0 }
    end
    node:parentDidResize()

    return node
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
            local worldPos = prop.Position
            prop:destroy()
            if propInfo.drops then
                for dropName, quantityRange in pairs(propInfo.drops) do
                    local randomRange = math.random() * (quantityRange[2] - quantityRange[1])
                    local quantity = math.floor(randomRange) + quantityRange[1]
                    if quantity > 0 then
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
                        local ui = require("uikit")
                        local iconShape = Shape(gameConfig.RESOURCES_BY_KEY[dropName].cachedShape,
                            { includeChildren = true })
                        local text = ui:createText(string.format("+%d", quantity), Color.White)
                        local icon = ui:createShape(iconShape, { spherized = true })
                        icon.Size = 40
                        local triptychIcon = ui_blocks:createBlock({
                            triptych = {
                                dir = "horizontal",
                                right = icon,
                            },
                            height = function() return icon.Height end
                        })
                        icon.pivot.Rotation = gameConfig.RESOURCES_BY_KEY[dropName].icon.rotation
                        local node = ui_blocks:createBlock({
                            columns = {
                                triptychIcon, text
                            }
                        })
                        local nodeParent = ui:createFrame()
                        nodeParent.Width = 100
                        nodeParent.Height = icon.Height
                        node:setParent(nodeParent)
                        local pos = Camera:WorldToScreen(worldPos) * Number2(Screen.Width, Screen.Height)
                        nodeParent.pos = pos - Number2(50, 20)
                        local tickListener = LocalEvent:Listen(LocalEvent.Name.Tick, function(dt)
                            nodeParent.pos = pos + Number2(0, dt * 100)
                        end)
                        Timer(2, function()
                            nodeParent:remove()
                            tickListener:Remove()
                        end)
                    end
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

propsModule.createCharacterBox = function(_, localSquad)
    local bonus = Object()
    local box = Box()
    box.Min = { -4, 0, -4 }
    box.Max = { 4, 4, 4 }
    bonus.CollisionBox = box
    bonus.Physics = PhysicsMode.Trigger

    -- local shape = MutableShape()
    -- shape:AddBlock(Color.Blue, 0, 0, 0)
    -- shape.Pivot = { 0.5, 0, 0.5 }
    -- shape:SetParent(bonus)
    -- shape.Scale = 8
    -- shape.Physics = PhysicsMode.Disabled

    local CHARACTERS = { "lumberjack", "miner", "gatherer" }
    local randomIndex = math.random(#CHARACTERS)
    local characterType = CHARACTERS[randomIndex]
    -- local COLORS = { Color.Blue, Color.Red, Color.Green }
    -- shape:GetBlock(0, 0, 0):Replace(COLORS[randomIndex])

    local charaInfo = gameConfig.CHARACTERS[characterType]
    local model = require("avatar"):get(charaInfo.avatarName)
    model:SetParent(bonus)
    model.LocalPosition.Y = 1
    model.Rotation.Y = math.pi
    model.Scale = 0.6
    require("hierarchyactions"):applyToDescendants(model, { includeRoot = true }, function(obj)
        obj.Physics = PhysicsMode.Disabled
    end)

    if charaInfo.tool then
        Object:Load(charaInfo.tool, function(obj)
            common.equipRightHand(model, obj)
            require("hierarchyactions"):applyToDescendants(obj, { includeRoot = true }, function(o)
                o.Physics = PhysicsMode.Disabled
            end)
            obj.Scale = charaInfo.toolScale or 1
        end)
    end

    bonus.OnCollisionBegin = function(_, other)
        if other == localSquad then
            bonus.OnCollisionBegin = nil
            bonus:RemoveFromParent()
            LocalEvent:Send("AddCharacter", { name = characterType })
        end
    end

    bonus.destroy = function()
        bonus.OnCollisionBegin = nil
        bonus:RemoveFromParent()
    end

    table.insert(props, bonus)

    return bonus
end

return propsModule
