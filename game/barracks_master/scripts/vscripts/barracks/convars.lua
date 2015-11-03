if BMConvars == nil then
  BMConvars = class({})
end

function BMConvars:Setup()
	self:RegisterConvars()
	self:RegisterCommands()
end

function BMConvars:RegisterConvars()
	-- Register custom console variables here.
  	--local debugOutput = 0
  	--if BM_DEBUG_OUTPUT then
  	--	debugOutput = 1
  	--end
  	--Convars:RegisterConvar("bm_debug_output", tostring(debugOutput), "Set to 1 for debug output. Default: 0", FCVAR_CHEAT)
end

function BMConvars:RegisterCommands()
	-- Register custom console command handlers here.
  	-- this is already built into the engine
  	--Convars:RegisterCommand( "set_time_of_day", Dynamic_Wrap(self, 'ConvarSetTimeOfDay'), "Sets the time of day to the indicated value.", FCVAR_CHEAT )
    Convars:RegisterCommand("bm_fake_heroes", Dynamic_Wrap(self, 'SpawnFakeHeroes'), "Spawn heroes to fill in missing players.", FCVAR_CHEAT )
    Convars:RegisterCommand("bm_money", Dynamic_Wrap(self, 'GiveMoney'), "+9999 gold and lumber", FCVAR_CHEAT )
    Convars:RegisterCommand("bm_warpten", Dynamic_Wrap(self, 'WarpTen'), "Instant buildings.", FCVAR_CHEAT )
end

function BMConvars:WarpTen()
  local humanPlayer = Convars:GetCommandClient()
  local humanPlayerID = humanPlayer:GetPlayerID()

  if GameRules.WarpTen == nil or GameRules.WarpTen == false then
    print("Instant buildings activated.")
    GameRules.WarpTen = true
  else
    print("Instant buildings deactivated.")
    GameRules.WarpTen = false
  end
end

function BMConvars:GiveMoney()
  local humanPlayer = Convars:GetCommandClient()
  local humanPlayerID = humanPlayer:GetPlayerID()
  local hero = humanPlayer:GetAssignedHero()

  hero:ModifyGold(9999, false, 0)
  ModifyLumber(humanPlayer, 9999)
end

function BMConvars:SpawnFakeHeroes()
  local humanPlayer = Convars:GetCommandClient()
  local humanPlayerID = humanPlayer:GetPlayerID()

  -- our master list of heroes, with the spectator heroes removed
  local missingHeroList = LoadKeyValues("scripts/npc/herolist.txt")
  missingHeroList["npc_dota_hero_wisp"] = nil
  missingHeroList["npc_dota_hero_disruptor"] = nil

  -- heroes in current game
  local heroList = HeroList:GetAllHeroes()

  -- remove present heroes from missing hero list
  for _,hero in pairs(heroList) do
    local heroName = hero:GetUnitName()
    if IsHeroOnList(missingHeroList, heroName) then
      missingHeroList[heroName] = nil
    end
  end

  -- spawn missing heroes
  for heroName,_ in pairs(missingHeroList) do
    local msg = "dota_create_unit " .. heroName
    if PlayerResource:GetTeam(humanPlayerID) ~= GetTeamByUnitName(heroName) then
      msg = msg .. " enemy"
    end
    SendToServerConsole(msg)
  end
end