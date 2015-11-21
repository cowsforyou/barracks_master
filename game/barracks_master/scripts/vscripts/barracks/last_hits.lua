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
    return not self:IsTower(entity) and not entity:IsHero() and entity:GetPlayerOwner() ~= nil
end

function LastHits:IsValidBountyTargetForPlayer(player, entity)
    return not self:IsTower(entity) and not entity:IsHero() and entity:GetPlayerOwner() ~= player
end

function LastHits:OnEntityKilled( keys )
    local killedUnit = EntIndexToHScript( keys.entindex_killed )
    local killerEntity = nil
    if keys.entindex_attacker ~= nil then
        killerEntity = EntIndexToHScript( keys.entindex_attacker )
    end

    local player = killerEntity:GetPlayerOwner()
    if self:IsValidBountyKiller(killerEntity) and self:IsValidBountyTargetForPlayer(player, killedUnit) then
        local playerID = player:GetPlayerID()
        local gold = killedUnit:GetGoldBounty()
        Purifier:EarnedGold(player, gold)
        -- FUNNY STORY: turns out if you set the unit's ownership correctly, you don't need to do this stuff. -- cows says LEL
        --PlayerResource:ModifyGold(playerID, gold, false, DOTA_ModifyGold_CreepKill)
        --PlayerResource:IncrementLastHits(playerID)
        --local coinsParticle = ParticleManager:CreateParticleForPlayer("particles/generic_gameplay/lasthit_coins.vpcf", PATTACH_ABSORIGIN_FOLLOW, killedUnit, player)
        --ParticleManager:SetParticleControl(coinsParticle, 1, killedUnit:GetAbsOrigin())
        --PopupGoldGainForPlayer(player, killedUnit, gold)
        --EmitSoundOnClient("General.Coins", player)
        --print("Awarding " .. gold .. " gold to player " .. playerID)
    else
        --print("Valid killer: " .. tostring(self:IsValidBountyKiller(killerEntity)) ..
        --    ", Valid target: " .. tostring(self:IsValidBountyTargetForPlayer(player, killedUnit)))
    end

    if self:IsTower(killedUnit) then
        self:IncrementLastStandCharges(killedUnit:GetTeam())
    end
end

function LastHits:IncrementLastStandCharges(towerTeam)
    local heroList = HeroList:GetAllHeroes()
    for _,hero in pairs(heroList) do
        if hero:GetTeam() == towerTeam then
            local itemName = "item_last_stand"
            local lastStandItem = GetItemByName(hero, itemName)
            if lastStandItem then
                lastStandItem:SetCurrentCharges(lastStandItem:GetCurrentCharges() + 1)
            else
                hero:AddItemByName(itemName)
            end
        end
    end
end

function LastHits:IncrementLastStandCharges(towerTeam)
    local dur = 5.0                                                                                                 
    --Notifications:BottomToTeam(killedUnit:GetTeam(), {ability="lion_finger_of_death", duration=dur})        -- removed as picture looked oversized              
    Notifications:BottomToTeam(towerTeam, {text="#give_item_last_stand", duration=dur})  
  
      local heroList = HeroList:GetAllHeroes()
    for _,hero in pairs(heroList) do
        if hero:GetTeam() == towerTeam then
            local itemName = "item_last_stand"
            local lastStandItem = GetItemByName(hero, itemName)
            if lastStandItem then
                lastStandItem:SetCurrentCharges(lastStandItem:GetCurrentCharges() + 1)
            else
                hero:AddItemByName(itemName)
            end
            --EmitSoundOnClient("BarracksMaster.NewItem", player)
            --EmitAnnouncerSoundForTeam("BarracksMaster.NewItem", unit:GetTeam())
        end
    end
end

function GetItemByName(unit, item_name)
    for i=DOTA_ITEM_SLOT_1, DOTA_ITEM_SLOT_6 do
            local item = unit:GetItemInSlot(i)
            if item and item:GetAbilityName() == item_name then
                return item
            end
    end

    return nil
end