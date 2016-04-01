function GetBMPointsForPlayer( playerID )
    -- Disconnected players get no points
    if PlayerResource:GetConnectionState(playerID) ~= 2 then
        return 0
    end

    -- Games with a duration less than 10 min don't give points
    if GameRules:GetDOTATime(false, false) < 480 then
        return 0
    end

    -- Neither do single player games
    if PlayerResource:GetPlayerCount() == 1 then
        return 0
    end

    -- Each game has +3 points base
    local points = 3

    -- Winners get 5 extra points
    if (PlayerResource:GetTeam(playerID) == statCollection.winner) then
        points = points + 5
    end

    -- 2 points for each player still connected
    for playerID=0,DOTA_MAX_TEAM_PLAYERS do
        if PlayerResource:IsValidPlayerID(playerID) then
            if PlayerResource:GetConnectionState(playerID) == 2 then
                points = points + 2
            end
        end
    end

    return points
end