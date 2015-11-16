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
    local gold_cost = ability:GetSpecialValueFor("gold_cost") or 0
    local lumber_cost = ability:GetSpecialValueFor("lumber_cost") or 0
    local overrideSpawnSync = false

    -- check for a stored creepName value on the caster, then use that if it's present
    local creepName = ""
    if caster.creepName == nil then
        creepName = keys.creepName
    else
        creepName = caster.creepName
    end

    -- check lumber (if necessary) and refund gold if lumber is insufficient
    -- doing this will override the spawn synchronizer, so no thinker should be used
    if lumber_cost > 0 then
        if not PlayerHasEnoughLumber(player, lumber_cost) then
            PlayerResource:ModifyGold(player:GetPlayerID(), gold_cost, false, 0) -- refund gold
            ability:EndCooldown()
            --SendErrorMessage(pID, "#error_not_enough_lumber")
            return
        else
            ModifyLumber(player, -lumber_cost)
            overrideSpawnSync = true
        end
    end

    -- including a gold cost overrides the spawn synchronizer
    if gold_cost > 0 then
        overrideSpawnSync = true
    end
    
    -- play a sound -- veggiesama
    local soundName = keys.soundName
    if soundName then 
        EmitGlobalSound(soundName)
    end

    -- display notifications
    local iconName = keys.iconName
    if iconName then
        local dur = 3.0
        Notifications:BottomToAll({hero=iconName, duration=dur})
        Notifications:BottomToAll({text="#"..creepName, duration=dur, continue=true}) -- "#hero_beastmaster"
        Notifications:BottomToAll({text=" ", duration=dur, continue=true})
        Notifications:BottomToAll({text="#hero_spawned", duration=dur, continue=true})
    end

    AutoSpawnCreeps(player, ability, creepName, creepCount, overrideSpawnSync)
end