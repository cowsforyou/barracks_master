-- In addition and run just before CheckAbilityRequirements, when a building starts construction
function CheckResearchRequirements( unit, player )
	if IsValidEntity(unit) then
		for abilitySlot=0,15 do
			local ability = unit:GetAbilityByIndex(abilitySlot)

			if ability then
				local ability_name = ability:GetAbilityName()

				if string.find(ability_name, "research_") and not IsAbilityChannelingOrQueued(ability) then
					if PlayerHasResearch(player, ability_name) then
						if GetResearchLevel(player, ability_name) < ability:GetMaxLevel() then
							ability:SetHidden(false)
						else
							-- Player already has the research, remove it
							ability:SetHidden(true)
							unit:RemoveAbility(ability_name)						
						end
					else
						ability:SetHidden(false)
					end
				end
			end
		end
	end
end

-- checks ALL abilities on unit
function CheckAbilityRequirements( unit, player )
	-- Check the Researches for this player, adjusting the abilities that have been already upgraded
	CheckResearchRequirements( unit, player )

	if not IsValidEntity(unit) then
		print("Not a Valid Entity!, there's currently ",#player.units,"units and",#player.structures,"structures in the table")
		return
	end

	--print("--- Checking Requirements on "..unit:GetUnitName().." ---")
	for abilitySlot=0,15 do
		local ability = unit:GetAbilityByIndex(abilitySlot)
		CheckAbility(ability, player)
	end
end

function CheckAbility(ability, player)
	if not ability or not IsValidEntity(ability) then
		--print("->Ability is hidden or invalid")
		return
	end

	if IsAbilityResearch(ability) then
		CheckResearchAbility(ability, player)
	else
		CheckCreepAbility(ability, player)
	end
end

function CheckResearchAbility(ability, player)
	local abilityName = GetBaseAbilityName(ability)
	local playerHasRequirements = PlayerHasRequirementForAbility(player, abilityName)

	if IsAbilityDisabled(ability) then
		if playerHasRequirements then -- Success: Player has necessary buildings/research, OR there are no requirements
			ability = EnableDisabledAbility(ability)
			SetResearchAbilityLevel(ability, player)
		else
			--print("Requirements not met. "..abilityName.." still DISABLED.")
		end
	else -- research ability is not disabled
		if playerHasRequirements then
			SetResearchAbilityLevel(ability, player)
		else -- Failure: The player has lost some requirement due to building destruction.
			DisableBaseAbility(ability) 
		end
	end				
end

function CheckCreepAbility(ability, player)
	local abilityName = GetBaseAbilityName(ability)
	local playerHasRequirements = PlayerHasRequirementForAbility(player, abilityName)

	if IsAbilityDisabled(ability) then
		if playerHasRequirements then -- Success: Player has necessary buildings/research, OR there are no requirements
			ability = EnableDisabledAbility(ability)
			SetNormalAbilityLevel(ability, player)
		else
			--print("Requirements not met. "..abilityName.." still DISABLED.")
		end
	else -- research ability is not disabled
		if playerHasRequirements then
			SetNormalAbilityLevel(ability, player)
		else -- Failure: The player has lost some requirement due to building destruction.
			DisableBaseAbility(ability) 
		end
	end		
end

function SetResearchAbilityLevel(ability, player)
	local abilityName = ability:GetAbilityName()	
	local researchLevel = GetResearchLevel(player, abilityName)
	-- max level > 1								not nil
	if IsAbilityUpgradeableResearch(ability) and researchLevel then
		ability:SetLevel(researchLevel + 1)
	else
		ability:SetLevel(1)
	end
end

function SetNormalAbilityLevel(ability, player)
	local abilityName = ability:GetAbilityName()	
	local researchLevel = GetResearchLevel(player, "research_"..abilityName)

	if researchLevel then
		ability:SetLevel(researchLevel)
	else
		ability:SetLevel(1)
	end
end

function IsAbilityChannelingOrQueued(ability)
	local unit = ability:GetCaster()
	local abilityName = ability:GetAbilityName()

	if ability:IsChanneling() then
		return true
	end

	for itemSlot=0,5 do
		local item = unit:GetItemInSlot(itemSlot)
		if item ~= nil and string.find(item:GetName(), abilityName) then
			--print("item: " .. item:GetName())
			return true
		end
	end

	return false
end

-- Go through every ability and check if the requirements are met
-- Swaps abilities with _disabled to their non disabled version and viceversa
-- This is called in multiple events:
	-- On every unit & building after a building is destroyed
	-- On single building after spawning in OnConstructionStarted


-- By default, all abilities that have a requirement start as _disabled
-- This is to prevent applying passive modifier effects that have to be removed later
-- The disabled ability is just a dummy for tooltip, precache and level 0.
-- Check if the ability is disabled or not
function IsAbilityDisabled(ability)
	local abilityName = ability:GetAbilityName()
	if string.find(abilityName, "_disabled") then
		return true
	end
	return false
end

function IsAbilityResearch(ability)
	local abilityName = ability:GetAbilityName()
	if string.find(abilityName, "research_") then
		return true
	end
	return false
end

-- is this a research ability above level 0? we should ignore it, because it's an upgradeable research ability

function IsAbilityUpgradeableResearch(ability)
	--local abilityName = ability:GetAbilityName()
	--print("Player has research in " .. abilityName .. ": " .. tostring(PlayerHasResearch(player, abilityName)))
	--print(tostring(IsAbilityResearch(ability)))
	--print(tostring(ability:GetMaxLevel() > 1))
	return IsAbilityResearch(ability) and ability:GetMaxLevel() > 1
end

-- Cut the disabled part from the name to check the requirements
function GetBaseAbilityName(ability)
	local abilityName = ability:GetAbilityName()
	--print("1. "..abilityName)

	local length = string.len(abilityName)
	if IsAbilityDisabled(ability) then
		local sEnd = length - string.len("_disabled")
		abilityName = string.sub(abilityName, 1, sEnd)
	end

	--length = string.len(abilityName)	
	--if IsAbilityResearch(ability) then 
	--	local sStart = string.len("research_") + 1
	--	abilityName = string.sub(abilityName, sStart, length)
	--end
	
	--print("2. "..abilityName)
	return abilityName
end

-- adds the base ability, swaps it with disabled ability, sets level if needed, and returns new ability
function EnableDisabledAbility(disabled_ability)
	local unit = disabled_ability:GetCaster()
	local player = unit:GetPlayerOwner()
	local disabledAbilityName = disabled_ability:GetAbilityName()
	local abilityName = GetBaseAbilityName(disabled_ability)

	-- Learn the ability and remove the disabled one (as we might run out of the 16 ability slot limit)
	--print("SUCCESS, ENABLED "..abilityName)
	unit:AddAbility(abilityName)
	unit:SwapAbilities(disabledAbilityName, abilityName, false, true)
	unit:RemoveAbility(disabledAbilityName)

	local ability = unit:FindAbilityByName(abilityName)
	--local newLevel = GetResearchLevel(player, "research_"..abilityName) or 1

	--print(abilityName .. ": isUpgradeableResearchAbility? " .. tostring(isUpgradeableResearchAbility))
	-- Set the new ability level
	--if not IsAbilityUpgradeableResearch(ability) then
	--	ability:SetLevel(newLevel)
	--end

	return ability
end

-- Disable the ability, swap to a _disabled
function DisableBaseAbility(base_ability)
	local unit = base_ability:GetCaster()
	local abilityName = base_ability:GetAbilityName()
	local disabledAbilityName = abilityName.."_disabled"
	unit:AddAbility(disabledAbilityName)					
	unit:SwapAbilities(abilityName, disabledAbilityName, false, true)
	unit:RemoveAbility(abilityName)

	-- Set the new ability level
	--print("Finding",disabledAbilityName)
	--local disabledAbility = unit:FindAbilityByName(disabledAbilityName)
	--disabledAbility:SetLevel(0)
end