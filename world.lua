local COMMIT_HASH = "a0e422ac"
Modules = {
    common = "github.com/caillef/cityfaith/common:" .. COMMIT_HASH,
    gameConfig = "github.com/caillef/cityfaith/config:" .. COMMIT_HASH,
    propsModule = "github.com/caillef/cityfaith/props:" .. COMMIT_HASH,
    squadsModule = "github.com/caillef/cityfaith/squads:" .. COMMIT_HASH,
    inventoryModule = "https://github.com/caillef/cubzh-library/inventory:1037602"
}

Config = {
    Items = { "buche.portal" }
}

local squad

function goToVillage()
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

    local house = {}
    house.model = MutableShape()
    house.model:AddBlock(Color.Red, 0, 0, 0)
    house.model.Pivot = { 0.5, 0, 0.5 }
    house.model.Scale = 15
    house.model:SetParent(World)
    common.setPropPosition(house.model, 6, 6)

    local portal = {}
    portal.model = Shape(Items.buche.portal)
    portal.model.Rotation.Y = math.pi * 0.5
    portal.model.Scale = 3
    portal.model.Pivot.Y = 0
    portal.model:SetParent(World)
    common.setPropPosition(portal.model, 0, 10)

    portal.model.OnCollisionBegin = function(_, other)
        if other ~= squad then return end
        map:RemoveFromParent()
        portal.model:RemoveFromParent()
        house.model:RemoveFromParent()
        generateNewMap()
    end

    squad:setPosition(0, 0)
end

function generateNewMap()
    local map = MutableShape()
    for z = -30, 30 do
        for x = -30, 30 do
            map:AddBlock(Color(116, 183, 46), x, 0, z)
        end
    end
    map:SetParent(World)
    map.Scale = common.MAP_SCALE
    map.Pivot.Y = 1

    for _ = 1, 50 do
        propsModule:create("tree", math.floor(math.random() * 50) - 25, math.floor(math.random() * 50) - 25)
        propsModule:create("bush", math.floor(math.random() * 50) - 25, math.floor(math.random() * 50) - 25)
    end
    for _ = 1, 10 do
        propsModule:create("iron", math.floor(math.random() * 50) - 25, math.floor(math.random() * 50) - 25)
    end

    Timer(10, function()
        map:RemoveFromParent()
        propsModule:clearAllProps()
        goToVillage()
    end)

    squad:setPosition(0, 0)
end

initCamera = function()
    Camera:SetModeFree()
    Camera:SetParent(squad)
    Camera.LocalPosition = { 0, 100, -65 }
    Camera.Rotation.X = math.pi * 0.3
end

initUI = function()
    inventoryModule:setResources(common.RESOURCES_BY_KEY, common.RESOURCES_BY_ID)
    inventoryModule:create("hotbar", {
        width = 8,
        height = 1,
        alwaysVisible = true,
        selector = false,
        uiPos = function(node)
            local padding = require("uitheme").current.padding
            return { Screen.Width * 0.5 - node.Width * 0.5, padding }
        end,
    })
end

Client.OnStart = function()
    squadsModule:setPropsModule(propsModule)

    squad = squadsModule:create({ "lumberjack", "miner" })

    --generateNewMap()
    goToVillage()

    initCamera()
    initUI()


    --[[
    for i = -5, 15 do
        local box = createCharacterBox()
        box:SetParent(World)
        setPropPosition(box, (i - 2) * 2, 4)
    end
	--]]
end

Client.DirectionalPad = function(x, y)
    squad.Motion = (squad.Forward * y + squad.Right * x) * 50
end
