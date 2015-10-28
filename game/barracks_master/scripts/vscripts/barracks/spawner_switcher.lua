--------------------------------------------------------------------------------------------------------
-- General spawner AI
--------------------------------------------------------------------------------------------------------
function SwitchCreep( keys )
    local ability = keys.ability
    local caster = keys.caster
    local creepName = keys.creepName

    -- skip first ability 0 (the spawner) and disable autocast up to sixth ability
    for i=1,5 do
        local abi = caster:GetAbilityByIndex(i)
        if abi:GetAutoCastState() then
            abi:ToggleAutoCast()
        end
    end
    -- enable autocast for the clicked ability
    ability:ToggleAutoCast()

    -- for use in spawner_auto.lua's OnSpellStart()
    caster.creepName = creepName
end