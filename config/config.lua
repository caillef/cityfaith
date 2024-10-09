local CHARACTERS = {
    lumberjack = {
        skills = { gather = true, chop = true, attack = { type = "melee" } },
        avatarName = "caillef",
        tool = "littlecreator.lc_iron_axe"
    },
    ranger = {
        skills = { gather = true, attack = { type = "range" } },
        avatarName = "soliton",
        tool = "xavier.bow",
        toolScale = 0.5
    },
    miner = {
        skills = { gather = true, mine = true, attack = { type = "range" } },
        avatarName = "gdevillele",
        tool = "divergonia.pickaxe"
    },
}

local PROPS = {
    tree = {
        skill = "chop",
        objFullname = "voxels.ash_tree",
        drops = {
            oak_log = { 2, 3 },
            wooden_stick = { 1, 2 }
        },
        scale = 0.5,
        hp = 3,
    },
    goblin = {
        skill = "attack",
        objFullname = "voxels.goblin_axeman",
        scale = 0.5,
        hp = 5,
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
    iron = {
        skill = "mine",
        objFullname = "voxels.iron_ore",
        drops = {
            iron = { 2, 3 }
        },
        scale = 0.5,
        hp = 10,
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
    attack = {
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
        key = "iron",
        name = "Iron",
        type = "block",
        block = { color = Color.LightGrey },
    },
    {
        id = 3,
        key = "oak_log",
        name = "Oak Log",
        type = "item",
        fullname = "voxels.oak",
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
        print("Loading", v.fullname)
        Object:Load(v.fullname, function(obj)
            print("obj loaded", v.fullname, obj)
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
}

return gameConfig
