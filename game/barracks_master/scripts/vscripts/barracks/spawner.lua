--------------------------------------------------------------------------------------------------------
-- General spawner AI
--------------------------------------------------------------------------------------------------------
function Think( keys )
    --print("Think")
    local caster = keys.caster
    local ability = keys.ability

    if ability.initialAutocast == nil and ability:GetAutoCastState() == false then
        ability:ToggleAutoCast()
        ability.initialAutocast = true
    end

    if ability:GetAutoCastState() == true and ability:IsFullyCastable() and not caster:HasModifier("modifier_construction") then
        caster:CastAbilityNoTarget(ability, 0)
    end
end

function OnSpellStart( keys )
    --print("OnSpellStart")
    local ability = keys.ability
    local caster = keys.caster
    local player = caster:GetPlayerOwner()
    if player == nil then return end -- don't try to spawn creeps from a ghost dummy

    local creepName = keys.creepName
    local creepCount = ability:GetSpecialValueFor("creep_count")

    SpawnCreeps(player, ability, creepName, creepCount)
end

-----------------------
-- Spawn creep groups and manage building ability cooldown
-----------------------
function SpawnCreeps(player, buildingAbility, creepName, numberToSpawn)
    local playerColor = GetPlayerColor(player)
    local team = GetTeamByColor(playerColor)

    local p1_string, p2_string = nil, nil
    if team == DOTA_TEAM_GOODGUYS then
        p1_string = "lane_mid_pathcorner_goodguys_1"
        p2_string = "lane_mid_pathcorner_goodguys_2"
    else
        p1_string = "lane_mid_pathcorner_badguys_1"
        p2_string = "lane_mid_pathcorner_badguys_2"
    end

    local spawner = Entities:FindByName(nil, playerColor.."_npc_spawner")
    local point1  = Entities:FindByName(nil, p1_string)
    local point2  = Entities:FindByName(nil, p2_string)
    local start_position = spawner:GetAbsOrigin()
    local p1_position = point1:GetAbsOrigin() 
    local p2_position = point2:GetAbsOrigin()
  
    -- set the cooldown to the next 30 second interval
    local nextSync = SpawnSynchronizer:GetNextInterval()
    buildingAbility:StartCooldown(nextSync)

    -- don't spawn creeps the first time this ability is used
    -- the -1.0 gives us a little wiggleroom for the Thinker
    if nextSync < (RESPAWN_TIME-1.0) then return end

    -- create the unit group
    for i=1, numberToSpawn do
        local unit = CreateUnitByName(creepName, start_position, true, nil, player, team)
        ApplyCreepParameters(unit, team, playerColor)
       
        -- Building Helper tie-ins
        CheckAbilityRequirements(unit, player) -- upgrades on spawn
        table.insert(player.units, unit)       -- adds unit to player's units table

        -- short delay before issuing orders, or the orders won't go through
        Timers:CreateTimer(0.1, function()
            local order1 = {}
            order1["UnitIndex"] = unit:GetEntityIndex()
            order1["OrderType"] = DOTA_UNIT_ORDER_ATTACK_MOVE
            order1["Position"]  = p1_position

            local order2 = order1
            order2["Position"] = p2_position
            order2["Queue"]    = true

            ExecuteOrderFromTable(order1)
            ExecuteOrderFromTable(order2)
            return nil
        end)
    end
end

function ApplyCreepParameters(unit, team, color)
    local unitName = unit:GetUnitName()
    local model = nil
    
    if unitName == "creep_melee" then
        if team == DOTA_TEAM_GOODGUYS then
            model = "models/creeps/lane_creeps/creep_radiant_melee/radiant_melee.vmdl"
            unit:SetModel(model)
            unit:SetOriginalModel(model)
        else
            model = "models/creeps/lane_creeps/creep_bad_melee/creep_bad_melee.vmdl"
            unit:SetModel(model)
            unit:SetOriginalModel(model)
        end
    end

    if unitName == "creep_ranged" then
        if team == DOTA_TEAM_GOODGUYS then
            model = "models/creeps/lane_creeps/creep_radiant_ranged/radiant_ranged.vmdl"
            unit:SetModel(model)
            unit:SetOriginalModel(model)
        else
            model = "models/creeps/lane_creeps/creep_bad_ranged/lane_dire_ranged.vmdl"
            unit:SetModel(model)
            unit:SetOriginalModel(model)
        end
    end

    if unitName == "creep_wagon" then
        if team == DOTA_TEAM_GOODGUYS then
            model = "models/creeps/lane_creeps/creep_good_siege/creep_good_siege.vmdl"
            unit:SetModel(model)
            unit:SetOriginalModel(model)
        else
            model = "models/creeps/lane_creeps/creep_bad_siege/creep_bad_siege.vmdl"
            unit:SetModel(model)
            unit:SetOriginalModel(model)
        end
    end


    
    if     color == "red"    then unit:SetRenderColor(255,128,128)
    elseif color == "blue"   then unit:SetRenderColor(0,128,255)
    elseif color == "green"  then unit:SetRenderColor(128,255,128)
    elseif color == "purple" then unit:SetRenderColor(255,128,255)
    end
    
end

-----------------------
-- Utility functions
-----------------------
function GetPlayerColor(player)
    local unit = player:GetAssignedHero()
    local unitName = unit:GetUnitName()
    
    local color = nil
    if unitName == "npc_dota_hero_sven" then
        color = "blue"
    elseif unitName == "npc_dota_hero_templar_assassin" then
        color = "purple"
    elseif unitName == "npc_dota_hero_axe" then
        color = "red"
    elseif unitName == "npc_dota_hero_venomancer" then
        color = "green"
    end
    
    return color
end

function GetTeamByColor(color)
    if color == "blue" or color == "purple" then
        return DOTA_TEAM_GOODGUYS
    elseif color == "red" or color == "green" then
        return DOTA_TEAM_BADGUYS
    end
end