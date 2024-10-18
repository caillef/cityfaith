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

local cityModule = {}
local buildings = {}

local playerCityInfo = {
    buildings = {}
}
local startFetchData = false

local localSquad, inventory
local canUpgradeBuilding
local payBuildingUpgrade

local BUILDING_STATES = {
    NONE = 1,
    BUILDING = 2,
    BUILT = 3,
    CANT_UPGRADE = 4,
}
local buildingState = BUILDING_STATES.NONE
local progressBar
local progressUI
local buildingProgress = 0
local currentlyBuilding
local isUpgrade = false
function startBuildingProgress()
    if not currentlyBuilding then return end
    buildingProgress = 0

    local ui = require("uikit")

    local bg = ui:createFrame(Color(0, 0, 0, 0.5))
    progressUI = bg

    local title = ui:createText((isUpgrade and "Upgrading " or "Building ") .. currentlyBuilding .. "...", Color.White)
    title:setParent(bg)

    bg.parentDidResize = function()
        bg.Width = math.min(500, Screen.Width * 0.5)
        bg.Height = bg.Width * 0.3
        bg.pos = {
            Screen.Width * 0.5 - bg.Width * 0.5,
            Screen.Height * 0.5 - bg.Height * 0.5
        }
        title.pos = { bg.Width * 0.5 - title.Width * 0.5, bg.Height - title.Height - 5 }

        if progressBar then progressBar:remove() end
        progressBar = progressBarModule:create({
            color = Color.Green,
            width = function() return bg.Width * 0.8 end,
            height = function() return 50 end,
            pos = function(bar)
                return {
                    bg.Width * 0.5 - bar.Width * 0.5,
                    title.pos.Y - 10 - bar.Height
                }
            end
        })
        progressBar:setParent(bg)
    end
    bg:parentDidResize()
end

function updateBuildings()
    for name, buildingInfo in pairs(gameConfig.BUILDINGS) do
        local building = {}
        local newLevel = playerCityInfo.buildings[name] and playerCityInfo.buildings[name].level or 0
        if buildings[name] then
            if newLevel == buildings[name].level then
                goto continue
            end
            buildings[name].model:RemoveFromParent()
            buildings[name].model = nil
        end
        building.level = newLevel
        if building.level == 0 then
            building.model = MutableShape()
            building.model:AddBlock(Color.Grey, 0, 0, 0)
            building.model.Pivot = { 0.5, 0, 0.5 }
            building.model.Scale = { 30, 0.1, 30 }
            building.model:SetParent(World)
            building.model.Physics = PhysicsMode.Trigger
            building.model.OnCollisionBegin = function(_, other)
                if other ~= localSquad then return end
                onStartBuilding(name)
            end
            building.model.OnCollisionEnd = function(_, other)
                if other ~= localSquad then return end
                onStopBuilding(name)
            end
        elseif buildingInfo.item then
            Object:Load(buildingInfo.item, function(obj)
                building.model = obj
                building.model.Pivot = { obj.Width * 0.5, 0, obj.Depth * 0.5 }
                building.model.Scale = buildingInfo.itemScale
                building.model:SetParent(World)
                require("hierarchyactions"):applyToDescendants(obj, function(o)
                    o.Shadow = true
                end)
                building.model.Rotation.Y = buildingInfo.rotation
                building.model.OnCollisionBegin = function(_, other)
                    if other ~= localSquad then return end
                    LocalEvent:Send("InteractWithBuilding", { name = name })
                end
                building.model.Physics = PhysicsMode.Disabled
                Timer(5, function()
                    building.model.Physics = PhysicsMode.Static
                end)
                common.setPropPosition(building.model, buildingInfo.x, buildingInfo.y)
                buildings[name] = building
            end)
        end
        if building.model then
            common.setPropPosition(building.model, buildingInfo.x, buildingInfo.y)
            buildings[name] = building
        end
        ::continue::
    end
end

function saveBuildingUpgrade()
    local buildingName = currentlyBuilding
    local currentBuildingData = playerCityInfo.buildings[buildingName] or { level = 0 }
    currentBuildingData.level = currentBuildingData.level + 1
    playerCityInfo.buildings[buildingName] = currentBuildingData
    KeyValueStore("city"):Set(Player.UserID, playerCityInfo, function(succes, results)
        updateBuildings()
    end)
end

function successfullBuild()
    clearProgressUI()

    local nextLevel = 1
    if playerCityInfo.buildings[currentlyBuilding].level ~= nil then
        nextLevel = playerCityInfo.buildings[currentlyBuilding].level + 1
    end
    if not gameConfig.BUILDINGS[currentlyBuilding].repairPrices[nextLevel] then
        print("can't upgrade this building")
        setBuildingState(BUILDING_STATES.NONE)
        return
    end

    local buildingInfo = gameConfig.BUILDINGS[currentlyBuilding]
    local requirements = buildingInfo.repairPrices[nextLevel]
    local success = payBuildingUpgrade(currentlyBuilding, requirements)
    if not success then
        return setBuildingState(BUILDING_STATES.CANT_UPGRADE)
    end

    saveBuildingUpgrade()
    local ui = require("uikit")

    local bg = ui:createFrame(Color(0, 0, 0, 0.5))
    progressUI = bg

    local title = ui:createText("Successfully " .. (isUpgrade and "upgraded" or "built") .. " " .. currentlyBuilding,
        Color.White)
    title:setParent(bg)

    bg.parentDidResize = function()
        bg.Width = math.min(500, Screen.Width * 0.5)
        bg.Height = bg.Width * 0.3
        bg.pos = {
            Screen.Width * 0.5 - bg.Width * 0.5,
            Screen.Height * 0.5 - bg.Height * 0.5
        }
        title.pos = { bg.Width * 0.5 - title.Width * 0.5, bg.Height - title.Height - 5 }
    end
    bg:parentDidResize()
    currentlyBuilding = nil
end

function cantUpgradeUI()
    clearProgressUI()

    local ui = require("uikit")

    local bg = ui:createFrame(Color(0, 0, 0, 0.5))
    progressUI = bg

    local buildingInfo = gameConfig.BUILDINGS[currentlyBuilding]

    local title = ui:createText(buildingInfo.description, Color.White)
    title:setParent(bg)

    local text = ui:createText("Resources needed:", Color.White)
    text:setParent(bg)

    -- requirements UI
    local requirementsUINodes = {}
    local newLevel = (playerCityInfo.buildings[name] and playerCityInfo.buildings[name].level or 0) + 1
    local repairPrices = buildingInfo.repairPrices[newLevel]
    if repairPrices then
        for name, qty in pairs(repairPrices) do
            local iconShape = Shape(gameConfig.RESOURCES_BY_KEY[name].cachedShape, { includeChildren = true })
            local inventoryQty = inventory:getQuantity(name)
            local text = ui:createText(string.format(" %d/%d", inventoryQty, qty), Color.White)
            local icon = ui:createShape(iconShape, { spherized = true })
            icon.Size = 40
            local triptychIcon = ui_blocks:createBlock({
                triptych = {
                    dir = "horizontal",
                    right = icon,
                },
                height = function() return icon.Height end
            })
            icon.pivot.Rotation = gameConfig.RESOURCES_BY_KEY[name].icon.rotation
            local node = ui_blocks:createBlock({
                columns = {
                    triptychIcon, text
                }
            })
            table.insert(requirementsUINodes, node)
        end
        local requirementsNode
        requirementsNode = ui_blocks:createBlock({
            columns = requirementsUINodes,
            parentDidResize = function()
                if not requirementsNode.parent then return end
                requirementsNode.pos = { requirementsNode.parent.Width * 0.5 - requirementsNode.Width * 0.5, 15 }
            end
        })
        requirementsNode:setParent(bg)
        requirementsNode:parentDidResize()
    end

    bg.parentDidResize = function()
        bg.Width = math.min(title.Width + 10, Screen.Width * 0.5)
        bg.Height = bg.Width * 0.3
        bg.pos = {
            Screen.Width * 0.5 - bg.Width * 0.5,
            Screen.Height * 0.5 - bg.Height * 0.5
        }
        title.pos = { bg.Width * 0.5 - title.Width * 0.5, bg.Height - 5 - title.Height }
        text.pos = { bg.Width * 0.5 - text.Width * 0.5, bg.Height * 0.5 - text.Height * 0.5 }
    end
    bg:parentDidResize()
    currentlyBuilding = nil
end

function clearProgressUI()
    if progressBar then
        progressBar = nil
    end
    if progressUI then
        progressUI:remove()
        progressUI = nil
    end
end

function setBuildingState(newState, data)
    if newState == buildingState then return end
    if newState == BUILDING_STATES.NONE then
        clearProgressUI()
        currentlyBuilding = nil
    elseif newState == BUILDING_STATES.BUILDING then
        currentlyBuilding = data -- name string
        local nextLevel = 1
        if playerCityInfo.buildings[currentlyBuilding].level ~= nil then
            nextLevel = playerCityInfo.buildings[currentlyBuilding].level + 1
        end
        if not gameConfig.BUILDINGS[currentlyBuilding].repairPrices[nextLevel] then
            print("can't upgrade this building")
            setBuildingState(BUILDING_STATES.NONE)
            return
        end
        local canBuild = canUpgradeBuilding(
            currentlyBuilding,
            gameConfig.BUILDINGS[currentlyBuilding].repairPrices[nextLevel]
        )
        if canBuild then
            startBuildingProgress()
        else
            return setBuildingState(BUILDING_STATES.CANT_UPGRADE)
        end
    elseif newState == BUILDING_STATES.BUILT then
        successfullBuild()
    elseif newState == BUILDING_STATES.CANT_UPGRADE then
        cantUpgradeUI()
    end
    buildingState = newState
end

function onStartBuilding(name)
    isUpgrade = false
    setBuildingState(BUILDING_STATES.BUILDING, name)
end

function onStopBuilding(name)
    setBuildingState(BUILDING_STATES.NONE, name)
end

function onStartUpgrading(name)
    isUpgrade = true
    setBuildingState(BUILDING_STATES.BUILDING, name)
end

function onStopUpgrading(name)
    setBuildingState(BUILDING_STATES.NONE, name)
end

cityModule.show = function(self, config)
    localSquad = config.squad
    inventory = config.inventory
    canUpgradeBuilding = config.canUpgradeBuilding
    payBuildingUpgrade = config.payBuildingUpgrade
    if not startFetchData then
        startFetchData = true
        KeyValueStore("city"):Get(Player.UserID, function(success, results)
            if not success then
                print("can't get city status")
                self:show(config)
                return
            end
            if results[Player.UserID] then
                --playerCityInfo = results[Player.UserID]
            end
            -- playerCityInfo.buildings.market = { level = 1 }
            self:show(config)
        end)
        return
    end
    local map = MutableShape()
    for z = -30, 29 do
        for x = -30, 29 do
            local color = Color(116, 183, 46)
            if x * x + z * z < 100 then
                color = Color(200, 173, 127)
            end
            map:AddBlock(color, x, 0, z)
        end
    end
    map:SetParent(World)
    map.Scale = common.MAP_SCALE
    map.Pivot = { 0, 1, 0 }

    Object:Load("voxels.wood_barrier_fence", function(obj)
        local nbFences = 30
        for i = 0, nbFences do
            local shape = Shape(obj, { includeChildren = true })
            shape:SetParent(map)
            shape.Scale = 0.08
            require("hierarchyactions"):applyToDescendants(shape, { includeRoot = true }, function(o)
                o.Shadow = true
            end)
            shape.LocalPosition = Number3(
                math.cos((i / nbFences) * math.pi * 2) * 9 + 0.5,
                0,
                math.sin((i / nbFences) * math.pi * 2) * 9 + 0.5
            )
            shape.Rotation.Y = -(i / nbFences) * math.pi * 2 + 0.55 * math.pi
        end
    end)

    -- HTTP:Get("https://api.voxdream.art/groundgame.png", function(res)
    --     local quad = Quad()
    --     map.groundTexture = quad
    --     quad.Image = res.Body
    --     quad:SetParent(World)
    --     quad.Width = 300
    --     quad.Height = 300
    --     quad.Anchor = { 0.5, 0.5 }
    --     quad.Position.Y = 0.05
    --     quad.Rotation.X = 0.5 * math.pi
    -- end)

    updateBuildings()

    local portal = {}
    portal.model = Shape(Items.buche.portal)
    portal.model.Rotation.Y = math.pi * 0.5
    portal.model.Scale = 2.5
    portal.model.Pivot.Y = 0
    portal.model:SetParent(World)
    common.setPropPosition(portal.model, 0, 7)
    require("hierarchyactions"):applyToDescendants(portal.model, { includeRoot = true }, function(o)
        o.Shadow = true
    end)

    portal.model.OnCollisionBegin = function(_, other)
        if other ~= localSquad then return end
        if map.groundTexture then
            map.groundTexture:RemoveFromParent()
        end
        map:RemoveFromParent()
        portal.model:RemoveFromParent()
        for _, building in pairs(buildings) do
            building.model:RemoveFromParent()
        end
        buildings = {}
        config.portalCallback()
    end

    if config.callback then
        config.callback()
    end
end

LocalEvent:Listen(LocalEvent.Name.Tick, function(dt)
    if buildingState ~= BUILDING_STATES.BUILDING then return end
    buildingProgress = buildingProgress + dt
    local percentage = buildingProgress / common.TIME_TO_BUILD_BUILDING
    if percentage >= 1 then
        percentage = 1
        setBuildingState(BUILDING_STATES.BUILT)
    end
    if progressBar then
        progressBar:setPercentage(percentage)
    end
end)

return cityModule
