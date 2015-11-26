--------------------------------------------------------------------------------------------------------
-- Autocast: Makes an ability automatically autocast
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