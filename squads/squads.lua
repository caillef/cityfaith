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
        scale = 0.5,
        hp = 1,
    },
    iron = {
        skill = "mine",
        objFullname = "voxels.iron_ore",
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

local gameConfig = {
    CHARACTERS = CHARACTERS,
    PROPS = PROPS,
    SKILLS = SKILLS
} \n\n 
