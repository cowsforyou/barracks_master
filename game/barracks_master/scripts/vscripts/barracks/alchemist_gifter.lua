if not AlchemistGifter then
    AlchemistGifter = class({})
end

-- Formula: GIFT_CONSTANT + (CURRENT_MINUTE * GIFT_MULTIPLIER) every GIFT_INTERVAL minutes
GIFT_MULTIPLIER = 23
GIFT_CONSTANT = 100
GIFT_INTERVAL = 4 -- minutes

function AlchemistGifter:Setup()
	local t = GIFT_INTERVAL * 60

	Timers:CreateTimer(t, function()
		self:GiftAllPlayers()
		return t
	end)
end

-- returns time in seconds until next tick
function AlchemistGifter:GiftAllPlayers()
	local playerCount = PlayerResource:GetPlayerCount()

	local currentMinute = math.floor(GameRules:GetGameTime() / 60)
	local gold = GIFT_CONSTANT + (GIFT_MULTIPLIER * currentMinute)
	print(string.format("Minute: %s, Gold: %s", currentMinute, gold))
    Notifications:TopToAll({hero="npc_dota_hero_alchemist", duration=5.0})
	Notifications:TopToAll({text="#alch_gold", duration=5.0, continue=true})
	Notifications:TopToAll({text=gold.."g", duration=5.0, continue=true})
	EmitGlobalSound("General.CoinsBig") 
	for i=0, playerCount do
		PlayerResource:ModifyGold(i, gold, true, 0)
	end
end