--------------------------------------------------------------------------------------------------------
-- Swap abilities
--------------------------------------------------------------------------------------------------------
function OnSpellStart(keys)
    local caster = keys.caster

    local list_main = {}
    list_main[0] = "repair"
    list_main[1] = "build_bm_skeleton_barracks"
    list_main[2] = "build_bm_melee_barracks"
    list_main[3] = "build_bm_ranged_barracks"
    list_main[4] = "build_bm_lumber_yard"

    local list_alt = {}
    list_alt[0] = "build_bm_siege_barracks"
    list_alt[1] = "build_bm_research_lab"
    list_alt[2] = "build_bm_aviation_sanctuary"
    list_alt[3] = "build_bm_ancient_barracks"
    list_alt[4] = "build_bm_heroes"

    local list = {}
    print(caster:GetAbilityByIndex(0):GetAbilityName())
    print(list_main[0])
    if caster:GetAbilityByIndex(0):GetAbilityName() == list_main[0] then
        list = list_alt
    else
        list = list_main
    end

    for i=0,4 do
        local ability = caster:GetAbilityByIndex(i)
        local abilityName = ability:GetName()
        caster:RemoveAbility(abilityName)

        local newAbilityName = list[i]
        caster:AddAbility(list[i])
        local newAbility = caster:FindAbilityByName(newAbilityName)
        newAbility:SetLevel(newAbility:GetMaxLevel())
    end

end