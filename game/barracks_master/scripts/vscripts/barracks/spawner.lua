
---------------------------------------------------------------------
-- Spawn one creep at a time (peasants)
-- No orders issued, spawns next to base
---------------------------------------------------------------------
function ManualSpawnCreeps(player, building, buildingAbility, creepName)
    local hero = player:GetAssignedHero()
    local playerColor = GetPlayerColor(player)
    local team = GetTeamByColor(playerColor)
    local pos = building:GetAbsOrigin() + RandomVector(256.0)

    local unit = CreateUnitByName(creepName, pos, true, hero, player, team)
    unit:SetControllableByPlayer(player:GetPlayerID(), true)
    ApplyModelToUnit(unit, team)
    ApplyColorToUnit(unit, playerColor)

    -- Building Helper tie-ins
    CheckAbilityRequirements(unit, player) -- upgrades on spawn
    table.insert(player.units, unit)       -- adds unit to player's units table

    -- unstick
    Timers:CreateTimer(0.03, function()
        FindClearSpaceForUnit(unit, pos, true)
    end)
end

---------------------------------------------------------------------
-- Spawn creep groups and manage building ability cooldown
---------------------------------------------------------------------
function AutoSpawnCreeps(player, buildingAbility, creepName, numberToSpawn)
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

    -- don't spawn creeps the first time this ability is used
    -- the -1.0 gives us a little wiggleroom for the Thinker
    if nextSync == nil or nextSync < (RESPAWN_TIME-1.0) then 
        return
    else
        buildingAbility:StartCooldown(nextSync)
    end

    -- create the unit group
    for i=1, numberToSpawn do
        local unit = CreateUnitByName(creepName, start_position, true, nil, player, team)
        ApplyModelToUnit(unit, team)
        ApplyColorToUnit(unit, playerColor)
       
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

---------------------------------------------------------------------
-- Set up coloration and model swaps
---------------------------------------------------------------------
function ApplyModelToUnit(unit, team)
    local unitName = unit:GetUnitName()
    local model = nil

    if unitName == "creep_skeleton" then
        if team == DOTA_TEAM_GOODGUYS then
            model = "models/creeps/neutral_creeps/n_creep_troll_skeleton/n_creep_skeleton_melee.vmdl"
            unit:SetModel(model)
            unit:SetOriginalModel(model)
        else
            model = "models/creeps/neutral_creeps/n_creep_troll_skeleton/n_creep_skeleton_melee.vmdl"
            unit:SetModel(model)
            unit:SetOriginalModel(model)
        end

    elseif unitName == "creep_melee" then
        if team == DOTA_TEAM_GOODGUYS then
            model = "models/creeps/lane_creeps/creep_radiant_melee/radiant_melee.vmdl"
            unit:SetModel(model)
            unit:SetOriginalModel(model)
        else
            model = "models/creeps/lane_creeps/creep_bad_melee/creep_bad_melee.vmdl"
            unit:SetModel(model)
            unit:SetOriginalModel(model)
        end
    
    elseif unitName == "creep_ranged" then
        if team == DOTA_TEAM_GOODGUYS then
            model = "models/creeps/lane_creeps/creep_radiant_ranged/radiant_ranged.vmdl"
            unit:SetModel(model)
            unit:SetOriginalModel(model)
        else
            model = "models/creeps/lane_creeps/creep_bad_ranged/lane_dire_ranged.vmdl"
            unit:SetModel(model)
            unit:SetOriginalModel(model)
        end
    
    elseif unitName == "creep_siege" then
        if team == DOTA_TEAM_GOODGUYS then
            model = "models/creeps/lane_creeps/creep_good_siege/creep_good_siege.vmdl"
            unit:SetModel(model)
            unit:SetOriginalModel(model)
        else
            model = "models/creeps/lane_creeps/creep_bad_siege/creep_bad_siege.vmdl"
            unit:SetModel(model)
            unit:SetOriginalModel(model)
        end
    
    elseif unitName == "creep_air" then
        if team == DOTA_TEAM_GOODGUYS then
            model = "models/heroes/visage/visage_familiar.vmdl"
            unit:SetModel(model)
            unit:SetOriginalModel(model)
        else
            model = "models/heroes/visage/visage_familiar.vmdl"
            unit:SetModel(model)
            unit:SetOriginalModel(model)
        end
    
    elseif unitName == "creep_ancient1" then
        if team == DOTA_TEAM_GOODGUYS then
            model = "models/creeps/neutral_creeps/n_creep_golem_a/neutral_creep_golem_a.vmdl"
            unit:SetModel(model)
            unit:SetOriginalModel(model)
        else
            model = "models/creeps/neutral_creeps/n_creep_golem_a/neutral_creep_golem_a.vmdl"
            unit:SetModel(model)
            unit:SetOriginalModel(model)
        end
    
    elseif unitName == "creep_ancient2" then
        if team == DOTA_TEAM_GOODGUYS then
            model = "models/creeps/neutral_creeps/n_creep_thunder_lizard/n_creep_thunder_lizard_big.vmdl"
            unit:SetModel(model)
            unit:SetOriginalModel(model)
        else
            model = "models/creeps/neutral_creeps/n_creep_thunder_lizard/n_creep_thunder_lizard_big.vmdl"
            unit:SetModel(model)
            unit:SetOriginalModel(model)
        end
    
    elseif unitName == "creep_ancient3" then
        if team == DOTA_TEAM_GOODGUYS then
            model = "models/creeps/neutral_creeps/n_creep_black_dragon/n_creep_black_dragon.vmdl"
            unit:SetModel(model)
            unit:SetOriginalModel(model)
        else
            model = "models/creeps/neutral_creeps/n_creep_black_dragon/n_creep_black_dragon.vmdl"
            unit:SetModel(model)
            unit:SetOriginalModel(model)
        end
    end
end

function ApplyColorToUnit(unit, color)
    if     color == "red"    then unit:SetRenderColor(255,128,128)
    elseif color == "blue"   then unit:SetRenderColor(0,128,255)
    elseif color == "green"  then unit:SetRenderColor(128,255,128)
    elseif color == "purple" then unit:SetRenderColor(255,128,255)
    end
end

-----------------------
-- Utility functions
-----------------------

-- Each player has their own color, independent from team
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