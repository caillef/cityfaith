local COMMIT_HASH = "24d2535616b35335878e1e28aa54213e6e127dd0"
Modules = {
    common = "github.com/caillef/cityfaith/common:" .. COMMIT_HASH,
    gameConfig = "github.com/caillef/cityfaith/config:" .. COMMIT_HASH,
    propsModule = "github.com/caillef/cityfaith/props:" .. COMMIT_HASH,
    squadsModule = "github.com/caillef/cityfaith/squads:" .. COMMIT_HASH,
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

    portal.model.OnCollisionBegin = function()
        map:RemoveFromParent()
        portal.house:RemoveFromParent()
        portal.model:RemoveFromParent()
        generateNewMap()
    end
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

    local spawners = {
        propsModule:createSpawner("tree", -5, -5),
        propsModule:createSpawner("tree", -8, -4),
        propsModule:createSpawner("goblin", 4, -4),
        propsModule:createSpawner("bush", 8, -6),
        propsModule:createSpawner("iron", 6, -4),
    }

    Timer(10, function()
        map:RemoveFromParent()
        for _, spawner in ipairs(spawners) do
            spawner:remove()
        end
        goToVillage()
    end)
end

initCamera = function()
    Camera:SetModeFree()
    Camera:SetParent(squad)
    Camera.LocalPosition = { 0, 100, -65 }
    Camera.Rotation.X = math.pi * 0.3
end

Client.OnStart = function()
    squadsModule:setPropsModule(propsModule)

    --generateNewMap()
    goToVillage()

    squad = squadsModule:create("lumberjack")
    initCamera()

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
