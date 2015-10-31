if not LastHits then
    LastHits = class({})
end

RESPAWN_TIME = 30.0

function LastHits:Setup()
	ListenToGameEvent("entity_killed", Dynamic_Wrap(self, "OnEntityKilled"), self)
end

function LastHits:OnEntityKilled( keys )
  local killedUnit = EntIndexToHScript( keys.entindex_killed )
  local killerEntity = nil
  if keys.entindex_attacker ~= nil then
    killerEntity = EntIndexToHScript( keys.entindex_attacker )
  end
  local killerAbility = nil
  if keys.entindex_inflictor ~= nil then
    killerAbility = EntIndexToHScript( keys.entindex_inflictor )
  end

  local killerName = killerEntity:GetUnitName()
  local killedName = killedUnit:GetUnitName()

  -- if the killer is neither a hero nor tower, and killed is neither hero nor tower, then
  if string.find(killerName, "tower") == nil and not killerEntity:IsHero() then
    if string.find(killedName, "hero") == nil and string.find(killedName, "tower") == nil then
    	local player = killerEntity:GetOwner()
    	if player then
    		local playerID = player:GetPlayerID()
    		local gold = killedUnit:GetGoldBounty()
    		PlayerResource:ModifyGold(playerID, gold, false, DOTA_ModifyGold_CreepKill)

  			local particle = ParticleManager:CreateParticle("particles/generic_gameplay/lasthit_coins.vpcf", PATTACH_ABSORIGIN_FOLLOW, killedUnit)
  			ParticleManager:SetParticleControl(particle, 1, killedUnit:GetAbsOrigin())
  			EmitSoundOn("General.Coins", killedUnit)
        	PopupGoldGain(killedUnit, gold)
        	
        	PlayerResource:IncrementLastHits(playerID)

    		print("Awarding " .. gold .. " gold to player " .. playerID)
    	else
    		print("Nil player")
    	end
    else
    	print("Creep killed hero or tower.")
    end
  else
    print("Either a tower or hero killed something.")
  end
end