if not Purifier then
    Purifier = class({})
end

function Purifier:GetPurifier(player)
    for _,structure in pairs(player.structures) do
        if structure:GetUnitName() == "bm_purifier" then
            return structure
        end
    end

    return nil
end

function Purifier:EarnedGold(player, gold)
    local purifier = self:GetPurifier(player)
    if not purifier then
        --print("No purifier found.")
        return
    end

    local playerID = player:GetPlayerID()
    local extraGold = math.floor(gold * 0.25)
    PlayerResource:ModifyGold(playerID, extraGold, false, DOTA_ModifyGold_CreepKill)

    -- particle effects appear on the purifier itself
    local coinsParticle = ParticleManager:CreateParticleForPlayer("particles/generic_gameplay/lasthit_coins.vpcf", PATTACH_ABSORIGIN_FOLLOW, purifier, player)
    ParticleManager:SetParticleControl(coinsParticle, 1, purifier:GetAbsOrigin())
    PopupGoldGainForPlayer(player, purifier, extraGold)
    --print("Found purifier, gold +" .. extraGold)
end

function Purifier:EarnedLumber(player, lumber)
    local purifier = self:GetPurifier(player)
    if not purifier then
        --print("No purifier found.")
        return
    end

    --if not purifier:FindAbilityByName("bm_purify_lumber") then -- or whatever
    --    print("Purify lumber not researched yet")
    --    return
    --end

    local extraLumber = math.floor(lumber * 0.25)
    ModifyLumber(player, extraLumber)
    PopupLumber(purifier, extraLumber)
    --print("Found purifier, lumber +" .. extraLumber)
end