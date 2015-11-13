--------------------------------------------------------------------------------------------------------
-- General spawner AI
--------------------------------------------------------------------------------------------------------
function OnSpellStart( keys )
    --print("OnSpellStart")
    local ability = keys.ability
    local caster = keys.caster
    local player = caster:GetPlayerOwner()
    if player == nil then return end -- don't try to spawn creeps from a ghost dummy
    local playerID = player:GetPlayerID()

    local creepName = keys.creepName
    local creepCount = ability:GetSpecialValueFor("creep_count")
    local gold_cost = ability:GetSpecialValueFor("gold_cost") or 0
    local lumber_cost = ability:GetSpecialValueFor("lumber_cost") or 0
    local max_count = ability:GetSpecialValueFor("max_count") or 0

    -- check if we've reached the max unit cap
    if max_count > 0 then
        local currentCount = GetUnitCount(player, creepName)
        if currentCount >= max_count then 
            PlayerResource:ModifyGold(playerID, gold_cost, false, 0) -- refund gold
            ability:EndCooldown()
            SendErrorMessage(playerID, "#error_max_unit_count_reached")
            return
        end
    end

    -- check if player has enough lumber
    if lumber_cost > 0 then
        if not PlayerHasEnoughLumber(player, lumber_cost) then
            PlayerResource:ModifyGold(playerID, gold_cost, false, 0) -- refund gold
            ability:EndCooldown()
            --SendErrorMessage(pID, "#error_not_enough_lumber")
            return
        else
            ModifyLumber(player, -lumber_cost)
        end
    end

    ManualSpawnCreeps(player, caster, ability, creepName)
end

function GetUnitCount(player, unitName)
    if player.units == nil then
        print("Invalid player.units table")
        return 0
    end
    
    local unitCount = 0
    for _,unit in pairs(player.units) do
        if not unit:IsNull() and unit:GetUnitName() == unitName then
            unitCount = unitCount + 1
        end
    end

    return unitCount
end