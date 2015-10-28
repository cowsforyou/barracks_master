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

    local creepCount = ability:GetSpecialValueFor("creep_count")

    -- check for a stored creepName value on the caster, then use that if it's present
    local creepName = ""
    if caster.creepName == nil then
        creepName = keys.creepName
    else
        creepName = caster.creepName
    end

    AutoSpawnCreeps(player, ability, creepName, creepCount)
end