function OnChannelSucceeded(keys)
    local caster = keys.caster
    local ability = keys.ability
    local target = keys.target
    local player = caster:GetPlayerOwner()
    local lumber = ability:GetSpecialValueFor("lumber_per_tick")

    -- DC'd players will not gain lumber until they reconnect 
    if player then 
        ModifyLumber(player, lumber)
        PopupLumber(caster, lumber)
        Purifier:EarnedLumber(player, lumber)
    end

    caster:CastAbilityOnTarget(target, ability, player:entindex())
	--print("Gain lumber and restart channel.")
end

function OnSpellStart(keys)
    local caster = keys.caster
    local ability = keys.ability
    local target = keys.target

    if target:GetUnitName() ~= "bm_lumber_yard" then
    	caster:Stop()
    	print("Invalid target.")
    end
end

--[[




    -- locate the closest lumberyard
    local units = FindUnitsInRadius(team, pos, nil, radius,
    	DOTA_UNIT_TARGET_TEAM_FRIENDLY,
    	DOTA_UNIT_TARGET_ALL,
    	DOTA_UNIT_TARGET_FLAG_NONE,
    	FIND_CLOSEST,
    	false)

    print(#units .. " units found.")
    local closestLumberyard = nil
    for _,unit in pairs(units) do
    	local name = unit:GetUnitName()
    	if name == "bm_lumber_yard" then
    		closestLumberyard = unit
    		break
    	end
    end

    if closestLumberyard == nil then
    	print("No lumber yards nearby.")
    else
    	MoveToLumberyardAndChannel(caster, ability, closestLumberyard)
    end

end

function MoveToLumberyardAndChannel(caster, ability, closestLumberyard)
	local thinkTime = ability:GetSpecialValueFor("think_time")
	local channelRange = ability:GetSpecialValueFor("range_to_start_channel")

   	print("Moving to closest lumber yard.")
	caster:MoveToNPC(closestLumberyard)

   	print("Creating Timer.")
	Timers:CreateTimer(thinkTime, function()
		print("Getting range.")
		if caster:GetRangeToUnit(closestLumberyard) < channelRange then
			print("In range.")
		else
			print("Not yet in range.")
			MoveToLumberyardAndChannel(caster, ability, closestLumberyard)
		end

		return nil
	end)
end
]]