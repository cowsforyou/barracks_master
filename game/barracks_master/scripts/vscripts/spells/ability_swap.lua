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
        "build_bm_siege_barracks", -- start page 2
        "build_bm_research_lab",
        "build_bm_aviation_sanctuary",
        "build_bm_ancient_barracks",
        "build_bm_heroes", -- start page 3
        "meepo_earthbind",
        "meepo_poof",
        "meepo_geostrike",
        "treant_natures_guise", -- start page 4
        "treant_leech_seed",
        "treant_living_armor",
        "treant_overgrowth",
        "disruptor_thunder_strike", -- start page 5
        "disruptor_glimpse", -- remaining 2 slots will be filled with blanks
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