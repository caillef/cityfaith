local COMMIT_HASH = "27f26edd"

-- MODULES
local gameLoaded = false
local inventoryModule
local common
local gameConfig
local propsModule
local squadsModule
local cityModule
local modulesLoad = {}

function dostring(str, name)
    local module, err = load(str, name)
    if not module then
        error(name .. ":" .. err)
    end
    return module()
end

modulesLoad.start = function(_, callback)
    local nbToLoad = 6
    local loaded = 0
    local function loadNext()
        loaded = loaded + 1
        if loaded == nbToLoad then
            callback()
        end
    end
    HTTP:Get("https://raw.githubusercontent.com/caillef/cubzh-library/refs/heads/main/inventory/inventory_module.lua",
        function(res)
            inventoryModule = dostring(res.Body:ToString(), "inventoryModule")
            loadNext()
        end)
    HTTP:Get("https://raw.githubusercontent.com/caillef/cityfaith/" .. COMMIT_HASH .. "/common/common.lua", function(res)
        common = dostring(res.Body:ToString(), "commonModule")
        loadNext()
    end)
    HTTP:Get("https://raw.githubusercontent.com/caillef/cityfaith/" .. COMMIT_HASH .. "/config/config.lua",
        function(res)
            gameConfig = dostring(res.Body:ToString(), "configModule")
            loadNext()
        end)
    HTTP:Get("https://raw.githubusercontent.com/caillef/cityfaith/" .. COMMIT_HASH .. "/props/props.lua", function(res)
        propsModule = dostring(res.Body:ToString(), "propsModule")
        loadNext()
    end)
    HTTP:Get("https://raw.githubusercontent.com/caillef/cityfaith/" .. COMMIT_HASH .. "/squads/squads.lua", function(res)
        squadsModule = dostring(res.Body:ToString(), "squadModule")
        loadNext()
    end)
    HTTP:Get("https://raw.githubusercontent.com/caillef/cityfaith/" .. COMMIT_HASH .. "/city/city.lua", function(res)
        cityModule = dostring(res.Body:ToString(), "cityModule")
        loadNext()
    end)
end

-- GAME

Config = {
    Items = { "buche.portal", "caillef.coin" }
}

local nbVisits = 0
local squad
local coins = 0
local coinIcon, coinText
local globalUI

function goToVillage()
    cityModule:show({
        inventory = inventory,
        squad = squad,
        portalCallback = generateNewMap,
        callback = function()
            squad:setPosition(0, 0)
        end,
        canUpgradeBuilding = function(name, requirements)
            for resName, qty in pairs(requirements) do
                local inventoryQty = inventory:getQuantity(resName)
                if inventoryQty < qty then
                    return false
                end
            end
            return true
        end,
        payBuildingUpgrade = function(name, requirements)
            for resName, qty in pairs(requirements) do
                local inventoryQty = inventory:getQuantity(resName)
                if inventoryQty < qty then
                    return false
                end
            end

            for resName, qty in pairs(requirements) do
                inventory:tryRemoveElement(resName, qty)
            end

            return true
        end
    })
end

function generateNewMap()
    nbVisits = nbVisits + 1
    local worldKeys = { "forest", "forest", "forest", "desert", "desert", "plateau", "plateau", "magicland" }
    local worldType = worldKeys[math.random(1, #worldKeys)]

    if nbVisits <= 3 then
        worldType = "forest"
    end

    local worldInfo = gameConfig.WORLDS[worldType]

    local ui = require("uikit")
    local bg = ui:createFrame(Color.Black)
    local title = ui:createText("Teleporting to " .. worldInfo.name .. "...", Color.White, "big")
    title.object.FontSize = 50
    title:setParent(bg)
    bg.parentDidResize = function()
        bg.Width = Screen.Width
        bg.Height = Screen.Height
        title.pos = { bg.Width * 0.5 - title.Width * 0.5, bg.Height * 0.5 - title.Height * 0.5 }
    end
    bg:parentDidResize()
    globalUI:hide()

    require("sfx")("whooshes_medium_1", { Spatialized = false, Volume = 0.6 })

    local map = MutableShape()
    for z = -30, 30 do
        for x = -30, 30 do
            map:AddBlock(worldInfo.color, x, 0, z)
        end
    end
    map:SetParent(World)
    map.Scale = common.MAP_SCALE
    map.Pivot.Y = 1

    for name, nb in pairs(worldInfo.props) do
        for _ = 1, nb do
            propsModule:create(name, math.floor(math.random() * 50) - 25, math.floor(math.random() * 50) - 25)
        end
    end

    function startExploration()
        squad:unfreeze()
        squad:setPosition(0, 0)

        local durationBar = require("uikit"):createFrame(Color.White)
        durationBar.parentDidResize = function()
            durationBar.Height = 40
            durationBar.pos = { Screen.Width * 0.2, Screen.Height - Screen.SafeArea.Top - durationBar.Height - 5 }
        end
        durationBar:parentDidResize()

        local tick
        local endAt = Time.UnixMilli() + common.ADVENTURE_DURATION * 1000
        tick = LocalEvent:Listen(LocalEvent.Name.Tick, function(dt)
            local percentage = (endAt - Time.UnixMilli()) / (common.ADVENTURE_DURATION * 1000)
            if percentage < 0.15 then
                durationBar.Color = Color.Red
            end
            durationBar.Width = Screen.Width * 0.6 * percentage
        end)

        Timer(common.ADVENTURE_DURATION, function()
            -- Clear map
            map:RemoveFromParent()
            propsModule:clearAllProps()

            -- Clear squad
            squad:reset()

            -- UI
            tick:Remove()
            durationBar:remove()

            -- Teleport
            goToVillage()
            require("sfx")("whooshes_medium_1", { Spatialized = false, Volume = 0.6 })
        end)
    end

    for _ = 1, 20 do
        local box = propsModule:createCharacterBox(squad)
        box:SetParent(World)
        common.setPropPosition(box, math.floor(math.random() * 50) - 25, math.floor(math.random() * 50) - 25)
    end

    squad:freeze()
    Timer(3, function()
        globalUI:show()

        bg:remove()
        title = nil
        bg = nil
        startExploration()
    end)
end

initCamera = function()
    Camera:SetModeFree()
    Camera:SetParent(squad)
    Camera.LocalPosition = { 0, 100, -65 }
    Camera.Rotation.X = math.pi * 0.3
end

initUI = function()
    inventoryModule:setResources(gameConfig.RESOURCES_BY_KEY, gameConfig.RESOURCES_BY_ID)
    inventory = inventoryModule:create("hotbar", {
        width = 8,
        height = 1,
        alwaysVisible = true,
        selector = false,
        uiPos = function(node)
            local padding = require("uitheme").current.padding
            return { Screen.Width * 0.5 - node.Width * 0.5, padding }
        end,
    })

    local ui = require("uikit")

    local uiRoot = ui:createFrame()
    uiRoot.parentDidResize = function()
        uiRoot.Width = Screen.Width
        uiRoot.Height = Screen.Height
    end
    coinIcon = ui:createShape(Shape(Items.caillef.coin), { spherized = true })
    LocalEvent:Listen(LocalEvent.Name.Tick, function(dt)
        coinIcon.pivot.Rotation.Y = coinIcon.pivot.Rotation.Y + dt
    end)
    coinIcon.Size = 80
    coinText = ui:createText("0", Color.White, "big")
    coinText.object.FontSize = 60
    coinText.parentDidResize = function()
        coinIcon.pos = { 10, Screen.Height - Screen.SafeArea.Top - 10 - coinIcon.Height }
        coinText.pos =
        { coinIcon.pos.X + coinIcon.Width + 5, coinIcon.pos.Y + coinIcon.Height * 0.5 - coinText.Height * 0.5 }
    end
    coinText:parentDidResize()

    coinIcon:setParent(uiRoot)
    coinText:setParent(uiRoot)
    return uiRoot
end

Client.OnPlayerJoin = function(player)
    if player ~= Player or gameLoaded then return end
    gameLoaded = true
    modulesLoad:start(function()
        startGame()
    end)
end

function startGame()
    require("ambience"):set(require("ambience").default)
    KeyValueStore("coins"):Get(Player.UserID, function(success, results)
        if not success then print("error") end
        coins = results[Player.UserID] or 0
        coinText.Text = string.format("%d", coins)
    end)

    squadsModule:setPropsModule(propsModule)
    squad = squadsModule:create({ "gatherer" })

    initCamera()
    globalUI = initUI()
    goToVillage()
end

-- Client.OnStart = function()
-- local node = require("controls"):getDirectionalPad()
-- if node then
--     node:hide()
-- end
-- end

-- local pointerStartX, pointerStartY
-- Pointer.Down = function(pe)
--     pointerStartX = pe.X
--     pointerStartY = pe.Y
-- end

-- Pointer.Drag = function(pe)
--     local dx, dy
--     dx = pe.X - pointerStartX
--     dy = pe.Y - pointerStartY
--     if math.abs(dx) < 0.01 then dx = 0 end
--     if math.abs(dy) < 0.01 then dy = 0 end
--     local x, y
--     if dx > 0 then x = 1 elseif dx < 0 then x = -1 else x = 0 end
--     if dy > 0 then y = 1 elseif dy < 0 then y = -1 else y = 0 end
--     -- handle diagonal
--     squad.Motion = (squad.Forward * y + squad.Right * x) * 50
-- end

-- Pointer.Up = function()
--     squad.Motion = Number3(0, 0, 0)
-- end

Client.DirectionalPad = function(x, y)
    local buildingBonus = 1
    if common.buildingsLevel.workstation == 1 then buildingBonus = 1.25 end
    if common.buildingsLevel.workstation == 2 then buildingBonus = 1.5 end
    if common.buildingsLevel.workstation == 3 then buildingBonus = 2 end

    print("move", buildingBonus)

    squad.Motion = (squad.Forward * y + squad.Right * x) * 50 * buildingBonus
end
