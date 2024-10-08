local COMMIT_HASH = "ca0cdd29d6861dcfcde8b6503324648dcd8dca48"
Modules = {
    common = "github.com/caillef/cityfaith/common:" .. COMMIT_HASH,
    gameConfig = "github.com/caillef/cityfaith/config:" .. COMMIT_HASH,
    propsModule = "github.com/caillef/cityfaith/props:" .. COMMIT_HASH,
    squadsModule = "github.com/caillef/cityfaith/squads:" .. COMMIT_HASH,
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
    map.Scale = common.MAP_SCALE
    map.Pivot.Y = 1

    propsModule:createSpawner("tree", -5, -5)
    propsModule:createSpawner("tree", -8, -4)

    propsModule:createSpawner("goblin", 4, -4)
    propsModule:createSpawner("bush", 8, -6)
    propsModule:createSpawner("iron", 6, -4)
end

initCamera = function()
    Camera:SetModeFree()
    Camera:SetParent(squad)
    Camera.LocalPosition = { 0, 100, -65 }
    Camera.Rotation.X = math.pi * 0.3
end

Client.OnStart = function()
    squadsModule:setPropsModule(propsModule)
    generateNewMap()

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
