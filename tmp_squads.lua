local squadModule = {}

local propsModule
squadModule.setPropsModule = function(_, module)
    propsModule = module
end

local function equipRightHand(avatar, shapeOrItem)
    local shape = nil
    if shapeOrItem ~= nil then
        if type(shapeOrItem) == "Shape" or type(shapeOrItem) == "MutableShape" then
            shape = shapeOrItem
        elseif type(shapeOrItem) == "Item" then
            shape = Shape(shapeOrItem)
            if not shape then
                error("Player:EquipRightHand(equipment) - equipment can't be loaded", 2)
            end
        else
            error("Player:EquipRightHand(equipment) - equipment parameter should be a Shape or Item", 2)
        end
    end

    if avatar.__rightHandItem == shape then
        -- equipment already installed
        return
    end

    if avatar.__rightHandItem ~= nil and avatar.__rightHandItem:GetParent() == avatar.RightHand then
        avatar.__rightHandItem:RemoveFromParent()
        -- restore its physics attributes
        avatar.__rightHandItem.Physics = avatar.__rightHandItem.__savePhysics
        avatar.__rightHandItem.CollisionGroups = avatar.__rightHandItem.__saveCollisionGroups
        avatar.__rightHandItem.CollidesWithGroups = avatar.__rightHandItem.__saveCollidesWithGroups
        -- lose reference on it
        avatar.__rightHandItem = nil
    end
    if shape == nil then
        return
    end
    -- reset shape Pivot to center
    shape.Pivot = Number3(shape.Width * 0.5, shape.Height * 0.5, shape.Depth * 0.5)
    -- disable Physics
    shape.__savePhysics = shape.Physics
    shape.__saveCollisionGroups = shape.CollisionGroups
    shape.__saveCollidesWithGroups = shape.CollidesWithGroups
    shape.Physics = PhysicsMode.Disabled
    shape.CollisionGroups = {}
    shape.CollidesWithGroups = {}
    avatar.__rightHandItem = shape
    -- Notes about lua Point:
    -- `poi.Coords` is a simple getter and returns the value as it was stored
    -- `poi.LocalPosition` performs a block to local transformation w/ associated shape
    -- get POI rotation
    local poiRot = shape:GetPoint("ModelPoint_Hand_v2").Rotation
    local compatRotation = false -- V1 & legacy POIs conversion
    if poiRot == nil then
        poiRot = shape:GetPoint("ModelPoint_Hand").Rotation
        if poiRot == nil then
            poiRot = shape:GetPoint("Hand").Rotation
        end
        if poiRot ~= nil then
            compatRotation = true
        else
            -- default value
            poiRot = Number3(0, 0, 0)
        end
    end
    -- get POI position
    local poiPos = shape:GetPoint("ModelPoint_Hand_v2").LocalPosition
    if poiPos == nil then
        poiPos = shape:GetPoint("ModelPoint_Hand").LocalPosition
        if poiPos == nil then
            -- backward-compatibility: Item Editor saved POI position in local space and item hasn't been edited since
            -- Note: engine cannot update POI in local space when the item is resized
            poiPos = shape:GetPoint("Hand").Coords -- get stored value as is
            if poiPos ~= nil then
                poiPos = -1.0 * poiPos
            else
                poiPos = Number3(0, 0, 0)
            end
        end
    end
    -- Item Editor saves POI position in model space (block coordinates), in order to ignore resize offset ;
    -- convert into hand local space
    local localHandPoint = poiPos:Copy()
    localHandPoint = -localHandPoint -- relative to hand point instead of item pivot
    localHandPoint:Rotate(poiRot)
    if compatRotation then
        localHandPoint:Rotate(Number3(0, 0, math.pi * 0.5))
    end
    localHandPoint = localHandPoint * shape.LocalScale
    poiPos = localHandPoint
    shape:SetParent(avatar.RightHand)
    shape.LocalRotation = poiRot
    shape.LocalPosition = poiPos + avatar.RightHand:GetPoint("palm").LocalPosition
    if compatRotation then
        shape:RotateLocal(Number3(0, 0, 1), math.pi * 0.5)
    end
end

local function createCharacter(charaType)
    local charaInfo = gameConfig.CHARACTERS[charaType]

    local character = Object()

    local model = require("avatar"):get(charaInfo.avatarName)
    Object:Load(charaInfo.tool, function(obj)
        equipRightHand(model, obj)
        require("hierarchyactions"):applyToDescendants(obj, { includeRoot = true }, function(o)
            o.Physics = PhysicsMode.Disabled
        end)
        obj.Scale = charaInfo.toolScale or 1
    end)
    model:SetParent(character)
    model.Scale = 0.45
    model.Physics = PhysicsMode.Disabled
    character.model = model

    local action
    local t = 0
    local nextActionTick = 0
    local cooldown = 1.0

    character.setAction = function(_, newAction)
        if action == nil and newAction == nil then return end

        if action.id and action.id == newAction.id and newAction.type ~= "idle" then return true end
        if action and action.cancelAction then
            action:cancelAction()
        end

        if newAction.type ~= "idle" and not charaInfo.skills[newAction.type] then return end

        action = newAction
        nextActionTick = t
        return true
    end

    character.actionTick = function(_, dt)
        t = t + dt

        local needToMove = action and (character.Position - action.Position).SquaredLength > 3 or false

        local squadMotion = character:GetParent().Motion
        local anims = character.model.Animations
        if squadMotion == Number3(0, 0, 0) and not needToMove then
            if anims.Walk.IsPlaying then
                anims.Walk:Stop()
                anims.Idle:Play()
            end
        else
            if anims.Idle.IsPlaying then
                anims.Idle:Stop()
                anims.Walk:Play()
            end
        end

        if not action then
            return
        end

        character.Forward = (action.Position + squadMotion) - character.Position
        character.Rotation.X = 0
        character.Rotation.Z = 0
        if needToMove then
            local dir = action.Position - character.Position
            dir:Normalize()
            character.Position = character.Position + dir * dt * 20
        elseif nextActionTick <= t then
            nextActionTick = t + cooldown
            local skill = gameConfig.SKILLS[action.type]
            if not skill then return end
            skill.callback(character, action)
        end
    end

    return character
end

squadModule.create = function(_, defaultCharacterList)
    local squad = Object()
    squad:SetParent(World)
    squad.Physics = PhysicsMode.Dynamic
    squad.CollisionGroups = Player.CollisionGroups
    squad.CollidesWithGroups = Player.CollidesWithGroups

    local characters = {}
    squad.add = function(_, character)
        character:SetParent(squad)
        table.insert(characters, character)
        character.LocalPosition = { 0, 0, 0 }
    end

    squad.setPosition = function(_, x, y)
        common.setPropPosition(squad, x, y)
        for _, c in ipairs(characters) do
            c.LocalPosition = { 0, 0, 0 }
        end
    end

    squad.reset = function()
        for _, c in ipairs(characters) do
            c:setAction({ type = "idle", Position = squad.Position })
        end
    end

    for _, defaultCharacterType in ipairs(defaultCharacterList) do
        local character = createCharacter(defaultCharacterType)
        squad:add(character)
    end

    local polygonBuilder = require("polygonbuilder")
    local handle = polygonBuilder:create({
        nbSides = 32,
        color = Color.White,
        thickness = 0.1,
        size = 40,
    })
    handle:SetParent(squad)
    handle.Rotation.X = math.pi * 0.5
    local movingCircle = handle
    local handle = polygonBuilder:create({
        nbSides = 32,
        color = Color.White,
        thickness = 2,
        size = 40,
    })
    handle:SetParent(squad)
    handle.Rotation.X = math.pi * 0.5
    local actionCircle = handle

    local moving = false
    local function findActions()
        if moving then
            local nbCharacters = #characters - 1
            for k, c in ipairs(characters) do
                local posX = 0
                local posZ = 0
                if k > 7 then
                    local nb = math.min(12, nbCharacters - 6)
                    posX = math.cos(((k - 7) / nb) * math.pi * 2) * 20
                    posZ = math.sin(((k - 7) / nb) * math.pi * 2) * 20
                elseif k > 1 then
                    local nb = math.min(6, nbCharacters)
                    posX = math.cos((k / nb) * math.pi * 2) * 10
                    posZ = math.sin((k / nb) * math.pi * 2) * 10
                end
                c:setAction({ type = "idle", Position = squad.Position + Number3(posX, 0, posZ) })
            end
            return
        end

        local availableTasks = {}
        for _, prop in ipairs(propsModule:getAll()) do
            local dist = (prop.Position - squad.Position).Length
            if dist <= 40 then
                prop.object = prop
                table.insert(availableTasks, { prop = prop, dist = dist })
            end
        end
        table.sort(availableTasks, function(a, b) return a.dist > b.dist end)
        for _, c in ipairs(characters) do
            if #availableTasks == 0 then
                c:setAction()
            else
                for i = #availableTasks, 1, -1 do
                    local task = availableTasks[i]
                    if c:setAction(task.prop) then
                        if task.prop.hp == 1 then
                            table.remove(availableTasks, i)
                        end
                        break
                    end
                end
            end
        end
    end

    LocalEvent:Listen(LocalEvent.Name.Tick, function(dt)
        if squad.Motion == Number3(0, 0, 0) then
            if moving then
                moving = false
                actionCircle.IsHidden = false
            end
        else
            if moving == false then
                moving = true
                actionCircle.IsHidden = true
            end
        end

        findActions()
        for _, c in ipairs(characters) do
            c:actionTick(dt)
        end
    end)

    common.setPropPosition(squad, 0, 0)

    return squad
end

return squadModule
