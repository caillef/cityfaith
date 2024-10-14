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
}

local common = {}

common.MAP_SCALE = 10
common.TIME_TO_BUILD_BUILDING = 5

common.setPropPosition = function(obj, x, y)
    obj.Position = { (x + 0.5) * common.MAP_SCALE, 0, (y + 0.5) * common.MAP_SCALE }
end

local cityModule = {}
local buildings = {}

local playerCityInfo = {
    buildings = {}
}
local startFetchData = false

local BUILDING_STATES = {
    NONE = 1,
    BUILDING = 2,
}
local buildingState = BUILDING_STATES.NONE
local progressBar
local progressUI
local buildingProgress = 0
local currentlyBuilding
function startBuildingProgress()
    if not currentlyBuilding then return end
    local ui = require("uikit")

    local bg = ui:createFrame(Color(0, 0, 0, 0.5))
    progressUI = bg

    local title = ui:createText("Upgrading " .. currentlyBuilding, Color.White)
    title:setParent(bg)

    local barBg = ui:createFrame(Color.Black)
    barBg:setParent(bg)

    local bar = ui:createFrame(Color.Green)
    bar:setParent(barBg)

    bg.parentDidResize = function()
        bg.Width = math.min(500, Screen.Width * 0.5)
        bg.Height = bg.Width * 0.5
        bg.pos = {
            Screen.Width * 0.5 - bg.Width * 0.5,
            Screen.Height * 0.5 - bg.Height * 0.5
        }
        title.pos = { bg.Width * 0.5 - title.Width * 0.5, bg.Height - title.Height - 5 }

        barBg.Width = bg.Width * 0.8
        barBg.Height = bg.Height * 0.5
        barBg.pos = {
            bg.Width * 0.5 - barBg.Width * 0.5,
            title.pos.Y - 10 - barBg.Height
        }

        bar.Width = barBg.Width
        bar.Height = barBg.Height
        progressBar = bar
    end
    bg:parentDidResize()
end

function clearProgressUI()
    progressUI:remove()
    progressUI = nil
end

function setBuildingState(newState, data)
    if newState == buildingState then return end
    if newState == BUILDING_STATES.NONE then
        clearProgressUI()
        currentlyBuilding = nil
    elseif newState == BUILDING_STATES.BUILDING then
        currentlyBuilding = data -- name string
        startBuildingProgress()
    end
    buildingState = newState
end

function onStartBuilding(name)
    setBuildingState(BUILDING_STATES.BUILDING, name)
end

function onStopBuilding(name)
    setBuildingState(BUILDING_STATES.NONE, name)
end

cityModule.show = function(self, config)
    if not startFetchData then
        startFetchData = true
        KeyValueStore("city"):Get(Player.UserID, function(success, results)
            if not success then
                print("can't get city status")
                self:show(config)
                return
            end
            if results[Player.UserID] then
                playerCityInfo = results[Player.UserID]
            end
            playerCityInfo.buildings.market = { level = 1 }
            self:show(config)
        end)
        return
    end
    local map = MutableShape()
    for z = -20, 20 do
        for x = -30, 30 do
            local color = Color(116, 183, 46)
            if (x > -2 and x < 2) or (z > -2 and z < 2) then
                color = Color(200, 173, 127)
            end
            map:AddBlock(color, x, 0, z)
        end
    end
    map:SetParent(World)
    map.Scale = common.MAP_SCALE
    map.Pivot.Y = 1

    for name, buildingInfo in pairs(gameConfig.BUILDINGS) do
        local building = {}
        building.level = playerCityInfo.buildings[name] and playerCityInfo.buildings[name].level or 0
        if building.level == 0 then
            building.model = MutableShape()
            building.model:AddBlock(Color.Grey, 0, 0, 0)
            building.model.Pivot = { 0.5, 0, 0.5 }
            building.model.Scale = { buildingInfo.scale, 0.1, buildingInfo.scale }
            building.model:SetParent(World)
            building.model.Physics = PhysicsMode.Trigger
            building.model.OnCollisionBegin = function(_, other)
                if other ~= config.squad then return end
                onStartBuilding(name)
            end
            building.model.OnCollisionEnd = function(_, other)
                if other ~= config.squad then return end
                onStopBuilding(name)
            end
        else
            building.model = MutableShape()
            building.model:AddBlock(buildingInfo.color, 0, 0, 0)
            building.model.Pivot = { 0.5, 0, 0.5 }
            building.model.Scale = buildingInfo.scale
            building.model:SetParent(World)
            if config.buildingsInfo[name].onInteract then
                building.model.OnCollisionBegin = function(_, other)
                    if other ~= config.squad then return end
                    config.buildingsInfo[name].onInteract()
                end
            end
        end
        common.setPropPosition(building.model, buildingInfo.x, buildingInfo.y)
        table.insert(buildings, building)
    end

    local portal = {}
    portal.model = Shape(Items.buche.portal)
    portal.model.Rotation.Y = math.pi * 0.5
    portal.model.Scale = 3
    portal.model.Pivot.Y = 0
    portal.model:SetParent(World)
    common.setPropPosition(portal.model, 0, 10)

    portal.model.OnCollisionBegin = function(_, other)
        if other ~= config.squad then return end
        map:RemoveFromParent()
        portal.model:RemoveFromParent()
        for _, building in ipairs(buildings) do
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
    if not progressBar then return end
    buildingProgress = buildingProgress + dt
    progressBar.Width = progressBar.parent.Width * (buildingProgress / common.TIME_TO_BUILD_BUILDING)
end)

return cityModule
