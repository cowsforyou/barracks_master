function OnSpellStart(keys)
    local caster = keys.caster
    local ability = keys.ability
    local player = caster:GetPlayerOwner()

    -- Page 1: 5 abilities; Pages 2+: 4 abilities
    -- Do NOT use duplicate ability names on the same page
    local ability_list = {
        "repair", -- start page 1 (contains 5 abilities)
        "build_bm_skeleton_barracks",
        "build_bm_melee_barracks",
        "build_bm_ranged_barracks",
        "build_bm_lumber_yard",
        "build_bm_siege_barracks",-- start page 2
        "build_bm_tech_lab",
        "build_bm_aviation_sanctuary",
        "build_bm_ancient_barracks",
        "build_bm_heroes",-- start page 3
        "build_bm_purifier",
        "build_bm_library",
        "build_bm_unpromising",
        "build_bm_luminous",-- start page 4
        -- remaining slots will be filled with blanks
    }

    -- if caster doesn't have an AbilitySwapper, make one
    if caster.AbilitySwapper == nil then
        caster.AbilitySwapper = AbilitySwapper(caster, ability_list)
    end

    -- swap abilities (takes the ability to know which index it's in)
    caster.AbilitySwapper:SwapAbilities(ability)

    -- building helper fixes requirements
    CheckAbilityRequirements(caster, player) 
end