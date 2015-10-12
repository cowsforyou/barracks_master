if not SpawnSynchronizer then
    SpawnSynchronizer = class({})
end

RESPAWN_TIME = 30.0

-- BUG: will probably break if you try to build anything before the horn

-- runs only once during DOTA_GAMERULES_STATE_GAME_IN_PROGRESS
function SpawnSynchronizer:Setup()
	Timers:CreateTimer(function()
		SpawnSynchronizer.nextSpawnAt = GameRules:GetGameTime() + RESPAWN_TIME
		return RESPAWN_TIME
	end)
end

-- returns time in seconds until next tick
function SpawnSynchronizer:GetNextInterval()
	return SpawnSynchronizer.nextSpawnAt - GameRules:GetGameTime()
end