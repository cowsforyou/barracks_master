function SpawnBoar( event )
    local caster = event.caster -- Hero
    local distance = event.Distance -- Passed by parameter
    local duration = event.Duration -- Passed by parameter

    -- Determine the unitName based on steamID
    local playerID = caster:GetPlayerID()
    local steamID = PlayerResource:GetSteamAccountID(playerID)
    local unitName = "scout_boar"

    if steamID == 49458799 or steamID == 12498553 or steamID == 191904610 then
        unitName = "scout_boar_blue"

    elseif steamID == 64143044 or steamID == 103029867 then
        unitName = "scout_boar_purple"

    elseif steamID == 103245869 or steamID == 167473888 or steamID == 177902321 or steamID == 177884423 or steamID == 201214330 or steamID == 30948065 then
        unitName = "scout_boar_red"

--    elseif steamID == 46639111 then
--        unitName = "scout_boar_white"

    elseif steamID == 65558412 then
        unitName = "scout_boar_yellow"

--    elseif steamID == 46639111 then
--        unitName = "scout_wolf"

    elseif steamID == 86718505 or steamID == 153872184 or steamID == 63131067 or steamID == 128354369 then
        unitName = "scout_wolf_red"

    elseif steamID == 46639111 then
        unitName = "scout_wolf_purple"

    elseif steamID == 109293655 or steamID == 119816162 then
        unitName = "scout_wolf_white"

--    elseif steamID == 46639111 then
--        unitName = "scout_wolf_yellow"

-- 46639111 cows
-- 64143044 bobby
-- 86718505 noya
-- 49458799 cawkeye
-- 103029867 seriously
-- 103245869 irest
-- 12498553 Jumbero
-- 191904610 chesscraftMC
-- 153872184 mvp
-- 63131067 mvp's partner
-- 109293655 cold
-- 119816162 Moon Moon
-- 167473888 Дворник Коля
-- 177902321 poopoo99
-- 177884423 booboo99
-- 65558412 str
-- 128354369 GrandMASTER!
-- 201214330 Legolas
-- 30948065 lak1r





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