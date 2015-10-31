if not ScoreboardUpdater then
    ScoreboardUpdater = class({})
end

SCOREBOARD_UPDATE_EVERY = 1.0

function ScoreboardUpdater:Setup()
	Timers:CreateTimer(function()
		self:Update()
		return SCOREBOARD_UPDATE_EVERY
	end)
end

function ScoreboardUpdater:Update()
	local playerCount = PlayerResource:GetPlayerCount()
	for playerID=0, playerCount-1 do
		local player = PlayerResource:GetPlayer(playerID)
		--print("CS :" .. PlayerResource:GetLastHits(playerID))

		local values = {
			cs = PlayerResource:GetLastHits(playerID),
			netWorth = 0,
			lumber = player.lumber,
			gold = PlayerResource:GetGold(playerID),
		}
		
		CustomNetTables:SetTableValue("scores", tostring(playerID), values)
	end
end