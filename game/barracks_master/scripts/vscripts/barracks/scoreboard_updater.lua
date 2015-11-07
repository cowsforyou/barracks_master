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
			netWorth = self:GetNetWorth(player),
			lumber = player.lumber,
			gold = PlayerResource:GetGold(playerID),
		}
		
		CustomNetTables:SetTableValue("scores", tostring(playerID), values)
	end

	CustomGameEventManager:Send_ServerToAllClients("RefreshScoreboard", {})
end

function ScoreboardUpdater:GetNetWorth(player)
	if player.structures == nil then return 0 end

	local netWorth = 0
	--PrintTable(player)

	for _,structure in pairs(player.structures) do
		netWorth = netWorth + GetGoldCost(structure)
	end

	for _,unit in pairs(player.units) do
		netWorth = netWorth + GetGoldCost(unit)
	end

	for upgradeName,upgradeLevel in pairs(player.upgrades) do
		local costString = GameRules.AbilityKV[upgradeName]["AbilityGoldCost"]
		--print(upgradeName .. ": " .. costString)
	end

	return netWorth
end