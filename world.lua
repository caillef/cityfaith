Modules = {
    gameConfig = "github.com/caillef/cityfaith/config:55fee24",
    propsFactory = "github.com/caillef/cityfaith/props:55fee24",
    squadsFactory = "github.com/caillef/cityfaith/squads:55fee24",
}

local squad

function generateNewMap()
    local map = MutableShape()
    for z = -30, 30 do
        for x = -30, 30 do
            map:AddBlock(Color.Green, x, 0, z)
        end
    end
    map:SetParent(World)
    map.Scale = MAP_SCALE
    map.Pivot.Y = 1

    propsFactory:createSpawner("tree", -5, -5)
    propsFactory:createSpawner("tree", -8, -4)

    propsFactory:createSpawner("goblin", 4, -4)
    propsFactory:createSpawner("bush", 8, -6)
    propsFactory:createSpawner("iron", 6, -4)
end

initCamera = function()
    Camera:SetModeFree()
    Camera:SetParent(squad)
    Camera.LocalPosition = { 0, 100, -65 }
    Camera.Rotation.X = math.pi * 0.3
end

Client.OnStart = function()
    generateNewMap()

    squad = squadsFactory:create("lumberjack")

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
