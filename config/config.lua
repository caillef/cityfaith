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
                wood_log = 50,
                stone = 25,
                berry = 10
            },
            {
                wood_log = 100,
                stone = 50,
                berry = 20
            }
        },
        repairDurations = { 5, 10 },
        item = "voxels.simple_cabin",
        itemScale = 0.75,
        color = Color.Red,
        scale = 15,
        rotation = 0.2 * math.pi,
        x = 5,
        y = 4,
    },
    workstation = {
        -- level 1 = can upgrade squad boots level 2, squad inventory
        -- level 2 = can upgrade squad boots level 3, squad inventory
        name = "Workstation",
        level = 0,
        repairPrices = {
            {
                wood_log = 75,
                stone = 40,
                iron = 10
            },
            {
                wood_log = 150,
                stone = 80,
                iron = 20
            }
        },
        repairDurations = { 5, 10 },
        item = "voxels.simple_workstation",
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
                wood_log = 100,
                stone = 50,
                gold = 5
            }
        },
        repairDurations = { 5 },
        color = Color.Yellow,
        item = "voxels.market_stall",
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
                wood_log = 60,
                stone = 80,
                iron = 20
            },
            {
                wood_log = 120,
                stone = 160,
                iron = 40,
                gold = 5
            },
        },
        repairDurations = { 5, 10 },
        color = Color.Grey,
        item = "voxels.simple_furnace",
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

return gameConfig
