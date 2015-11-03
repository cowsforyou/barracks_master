--------------------------------------------------------------------------------------------------------
-- General spawner AI
--------------------------------------------------------------------------------------------------------
function Think( keys )

end

function OnSpellStart( keys )
    --print("OnSpellStart")
    local ability = keys.ability
    local caster = keys.caster
    local player = caster:GetPlayerOwner()
    if player == nil then return end -- don't try to spawn creeps from a ghost dummy

    local creepName = keys.creepName
    local creepCount = ability:GetSpecialValueFor("creep_count")
    local gold_cost = ability:GetSpecialValueFor("gold_cost") or 0
    local lumber_cost = ability:GetSpecialValueFor("lumber_cost") or 0

    if lumber_cost > 0 then
        if not PlayerHasEnoughLumber(player, lumber_cost) then
            PlayerResource:ModifyGold(player:GetPlayerID(), gold_cost, false, 0) -- refund gold
            ability:EndCooldown()
            --SendErrorMessage(pID, "#error_not_enough_lumber")
            return
        else
            ModifyLumber(player, -lumber_cost)
        end
    end

    ManualSpawnCreeps(player, caster, ability, creepName)
end