local COMMIT_HASH = "19c54ba4"
Modules = {
    common = "github.com/caillef/cityfaith/common:" .. COMMIT_HASH,
    gameConfig = "github.com/caillef/cityfaith/config:" .. COMMIT_HASH,
    propsModule = "github.com/caillef/cityfaith/props:" .. COMMIT_HASH,
    squadsModule = "github.com/caillef/cityfaith/squads:" .. COMMIT_HASH,
    cityModule = "github.com/caillef/cityfaith/city:" .. COMMIT_HASH,
    inventoryModule = "https://github.com/caillef/cubzh-library/inventory:1037602"
}

local ADVENTURE_DURATION = 20

Config = {
    Items = { "buche.portal", "caillef.coin" }
}

local squad
local coins = 0
local coinIcon, coinText

local buildingsInfo = {
    house = {
    },
    market = {
        onInteract = function()
            local sticksPrice = inventory:getQuantity("wooden_stick")
            local logsPrice = inventory:getQuantity("oak_log") * 3
            local ironsPrice = inventory:getQuantity("iron") * 10
            local fullPrice = sticksPrice + logsPrice + ironsPrice
            print("Sell for ", fullPrice)
            LocalEvent:Send("InvClearAll", { key = "hotbar" })

            coins = coins + fullPrice
            KeyValueStore("coins"):Set(Player.UserID, coins, function() end)
            coinText.Text = string.format("%d", coins)
        end
    },
    forge = {
    },
    workshop = {
    },
}

function goToVillage()
    cityModule:show({
        buildingsInfo = buildingsInfo,
        squad = squad,
        portalCallback = generateNewMap,
        callback = function()
            squad:setPosition(0, 0)
        end
    })
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
        propsModule:create("bush", math.floor(math.random() * 50) - 25, math.floor(math.random() * 50) - 25)
    end
    for _ = 1, 30 do
        propsModule:create("tree", math.floor(math.random() * 50) - 25, math.floor(math.random() * 50) - 25)
    end
    for _ = 1, 10 do
        propsModule:create("iron", math.floor(math.random() * 50) - 25, math.floor(math.random() * 50) - 25)
    end

    squad:setPosition(0, 0)

    local durationBar = require("uikit"):createFrame(Color.White)
    durationBar.parentDidResize = function()
        durationBar.Height = 40
        durationBar.pos = { Screen.Width * 0.2, Screen.Height - Screen.SafeArea.Top - durationBar.Height - 5 }
    end
    durationBar:parentDidResize()

    local tick
    local endAt = Time.UnixMilli() + ADVENTURE_DURATION * 1000
    tick = LocalEvent:Listen(LocalEvent.Name.Tick, function(dt)
        local percentage = (endAt - Time.UnixMilli()) / (ADVENTURE_DURATION * 1000)
        if percentage < 0.15 then
            durationBar.Color = Color.Red
        end
        durationBar.Width = Screen.Width * 0.6 * percentage
    end)

    Timer(ADVENTURE_DURATION, function()
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

    coinIcon = ui:createShape(Shape(Items.caillef.coin), { spherized = true })
    LocalEvent:Listen(LocalEvent.Name.Tick, function(dt)
        coinIcon.pivot.Rotation.Y = coinIcon.pivot.Rotation.Y + dt
    end)
    coinIcon.Size = 80
    coinText = ui:createText("0", Color.White, "big")
    coinText.object.FontSize = 30
    coinText.parentDidResize = function()
        coinIcon.pos = { 10, Screen.Height - Screen.SafeArea.Top - 10 - coinIcon.Height }
        coinText.pos =
        { coinIcon.pos.X + coinIcon.Width + 5, coinIcon.pos.Y + coinIcon.Height * 0.5 - coinText.Height * 0.5 }
    end
    coinText:parentDidResize()
end

Client.OnPlayerJoin = function()
    KeyValueStore("coins"):Get(Player.UserID, function(success, results)
        if not success then print("error") end
        coins = results[Player.UserID] or 0
        coinText.Text = string.format("%d", coins)
    end)
end

Client.OnStart = function()
    squadsModule:setPropsModule(propsModule)

    squad = squadsModule:create({ "gatherer", "lumberjack", "miner" })

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
