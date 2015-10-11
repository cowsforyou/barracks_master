--------------------------------------------------------------------------------------------------------
-- Melee Barracks AI
--------------------------------------------------------------------------------------------------------
function Spawn( keys )
    -- thisEntity is a special entity that references the unit who called this script
    local playerID = thisEntity:GetMainControllingPlayer()
    local color = GetPlayerColor(playerID)
    SpawnCreeps(color, 4, 30)
    
end

function GetPlayerColor(playerID)
    local player = PlayerResource:GetPlayer(playerID) -- converts the playerID index to a player handle
    local unit = player:GetAssignedHero()
    local unitName = unit:GetUnitName()
    
    local color = nil
    if unitName == "npc_dota_hero_axe" then
        color = "blue"
    elseif unitName == "blah_blah" then
        color = "whatever"
    end
    
    return color
end




