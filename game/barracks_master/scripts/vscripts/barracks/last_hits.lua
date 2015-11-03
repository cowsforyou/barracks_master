if not LastHits then
    LastHits = class({})
end

RESPAWN_TIME = 30.0

function LastHits:Setup()
    ListenToGameEvent("entity_killed", Dynamic_Wrap(self, "OnEntityKilled"), self)
end

function LastHits:IsTower(entity)
    local isTower = string.find(entity:GetUnitName(), "tower")
    if isTower ~= nil then
        return true
    else
        return false
    end
end

function LastHits:IsValidBountyKiller(entity)
    return not self:IsTower(entity) and not entity:IsHero() and entity:GetOwner() ~= nil
end

function LastHits:IsValidBountyTargetForPlayer(player, entity)
    return not self:IsTower(entity) and not entity:IsHero() and entity:GetOwner() ~= player
end

function LastHits:OnEntityKilled( keys )
    local killedUnit = EntIndexToHScript( keys.entindex_killed )
    local killerEntity = nil
    if keys.entindex_attacker ~= nil then
        killerEntity = EntIndexToHScript( keys.entindex_attacker )
    end

    local player = killerEntity:GetOwner()
    if self:IsValidBountyKiller(killerEntity) and self:IsValidBountyTargetForPlayer(player, killedUnit) then
		local playerID = player:GetPlayerID()
		local gold = killedUnit:GetGoldBounty()
		PlayerResource:ModifyGold(playerID, gold, false, DOTA_ModifyGold_CreepKill)
        PlayerResource:IncrementLastHits(playerID)

		local coinsParticle = ParticleManager:CreateParticleForPlayer("particles/generic_gameplay/lasthit_coins.vpcf", PATTACH_ABSORIGIN_FOLLOW, killedUnit, player)
		ParticleManager:SetParticleControl(coinsParticle, 1, killedUnit:GetAbsOrigin())
		EmitSoundOnClient("General.Coins", player)
    	PopupGoldGainForPlayer(player, killedUnit, gold)

		--print("Awarding " .. gold .. " gold to player " .. playerID)
    else
    	--print("Valid killer: " .. tostring(self:IsValidBountyKiller(killerEntity)) ..
        --    ", Valid target: " .. tostring(self:IsValidBountyTargetForPlayer(player, killedUnit)))
    end
end