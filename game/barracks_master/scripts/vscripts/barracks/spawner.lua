--------------------------------------------------------------------------------------------------------
-- Melee Barracks AI
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

    local color = GetPlayerColor(player)
    local creepCount = ability:GetSpecialValueFor("creep_count")
    local creepDelay = ability:GetSpecialValueFor("creep_delay") -- NOTE: curently unused

    SpawnCreeps(color, creepCount, creepDelay, ability)
end

-----------------------
-- Timer functions
-----------------------
function SpawnCreeps(color, number, repeatEvery, ability)
    local team = GetTeamByColor(color)

    local p1_string, p2_string = nil, nil
    if team == DOTA_TEAM_GOODGUYS then
        p1_string = "lane_mid_pathcorner_goodguys_1"
        p2_string = "lane_mid_pathcorner_goodguys_2"
    else
        p1_string = "lane_mid_pathcorner_badguys_1"
        p2_string = "lane_mid_pathcorner_badguys_2"
    end

    local spawner = Entities:FindByName(nil, color.."_npc_spawner")
    local point1  = Entities:FindByName(nil, p1_string)
    local point2  = Entities:FindByName(nil, p2_string)
    local start_position = spawner:GetAbsOrigin()
    local p1_position = point1:GetAbsOrigin() 
    local p2_position = point2:GetAbsOrigin()
  
    -- set the cooldown to the next 30 second interval
    local nextSync = SpawnSynchronizer:GetNextInterval()
    ability:StartCooldown(nextSync) --ability:StartCooldown(repeatEvery)

    -- don't spawn creeps the first time this ability is used
    -- the -1.0 gives us a little wiggleroom for the Thinker
    if nextSync < (RESPAWN_TIME-1.0) then return end

    -- create the unit group
    for i=1, number do
        local unit = CreateUnitByName(color.."_creep_melee", start_position, true, nil, nil, team)
        
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

-----------------------
-- Utility functions
-----------------------
function GetPlayerColor(player)
    local unit = player:GetAssignedHero()
    local unitName = unit:GetUnitName()
    
    local color = nil
    if unitName == "npc_dota_hero_axe" then
        color = "blue"
    elseif unitName == "blah_blah" then
        color = "whatever"
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