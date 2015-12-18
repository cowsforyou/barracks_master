function SpawnBoar( event )
    local caster = event.caster -- Hero
    local distance = event.Distance -- Passed by parameter
    local duration = event.Duration -- Passed by parameter

    -- Determine the unitName based on steamID
    local playerID = caster:GetPlayerID()
    local steamID = PlayerResource:GetSteamAccountID(playerID)
    local unitName = "scout_boar"

    if steamID == 64143044 then
        unitName = "scout_boar_purple"

    elseif steamID == 86718505 then
        unitName = "scout_wolf_red"

    elseif steamID == 46639111 then
        unitName = "scout_wolf_purple"
    end

    -- Create the unit in front of the caster
    local origin = caster:GetAbsOrigin()
    local fv = caster:GetForwardVector()
    local position = origin + fv * distance

    local unit = CreateUnitByName( unitName, position, true, caster, caster, caster:GetTeamNumber() )
    unit:SetOwner(caster)
    unit:SetControllableByPlayer( playerID, true )
    unit:SetForwardVector(fv)

    -- Apply modifiers
    local ability = event.ability
    ability:ApplyDataDrivenModifier( caster, unit, "modifier_creation_and_death_effects", {} )

    -- Set duration for summoned units
    unit:AddNewModifier( unit, nil, "modifier_kill", {duration = duration} )
end