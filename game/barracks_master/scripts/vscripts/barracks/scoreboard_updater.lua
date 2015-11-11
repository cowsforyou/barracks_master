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


-- Net Worth = current gold + buildings worth + research worth + living units worth (heroes, lumberjacks, scouts)
function ScoreboardUpdater:GetNetWorth(player)
	if player.structures == nil then return 0 end

	local netWorth = PlayerResource:GetGold(player:GetPlayerID())
	--PrintTable(player)

	for _,structure in pairs(player.structures) do
		netWorth = netWorth + GetGoldCost(structure)
	end

	for _,unit in pairs(player.units) do
		netWorth = netWorth + GetGoldCost(unit)
	end

	for upgradeName,upgradeLevel in pairs(player.upgrades) do
		local costString = GameRules.AbilityKV[upgradeName]["AbilityGoldCost"]
		local costTable = self:SplitResearchGoldCostString(costString)
		
		for i=1, upgradeLevel do
			netWorth = netWorth + costTable[i]
			--print(upgradeName .. ": Adding " .. costTable[i])
		end
	end

	return netWorth
end

function ScoreboardUpdater:SplitResearchGoldCostString(costString)
	return string_split(costString, " ")
end

-- http://stackoverflow.com/questions/1426954/split-string-in-lua
function string_split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end