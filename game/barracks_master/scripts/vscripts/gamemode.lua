
DEBUG_SPEW = 1

function GameMode:InitGameMode()
  -- Call the internal function to set up the rules/behaviors specified in constants.lua
  -- This also sets up event hooks for all event handlers in events.lua
  -- Check out internals/gamemode to see/modify the exact code
  GameMode:_InitGameMode()

  -- Get Rid of Shop button - Change the UI Layout if you want a shop button
  GameRules:GetGameModeEntity():SetHUDVisible(6, false)
  GameRules:GetGameModeEntity():SetCameraDistanceOverride(1300)

  -- Modifying the HUD -- cows
  GameRules:GetGameModeEntity():SetHUDVisible(2, false)
  GameRules:GetGameModeEntity():SetHUDVisible(8, false)  
  --GameRules:GetGameModeEntity():SetHUDVisible(9, false) 

  GameRules:SetPostGameTime(60)

  -- DebugPrint
  --Convars:RegisterConvar('debug_spew', tostring(DEBUG_SPEW), 'Set to 1 to start spewing debug info. Set to 0 to disable.', 0)
  -- Commands can be registered for debugging purposes or as functions that can be called by the custom Scaleform UI
  --Convars:RegisterCommand( "command_example", Dynamic_Wrap(GameMode, 'ExampleConsoleCommand'), "A console command example", FCVAR_CHEAT )
  
  -- Event Hooks (redundant)
  --ListenToGameEvent('entity_killed', Dynamic_Wrap(GameMode, 'OnEntityKilled'), self)
  --ListenToGameEvent('dota_player_pick_hero', Dynamic_Wrap(GameMode, 'OnPlayerPickHero'), self)

  -- Filters
  --GameRules:GetGameModeEntity():SetExecuteOrderFilter( Dynamic_Wrap( GameMode, "FilterExecuteOrder" ), self )

  -- Converting all reliable gold to unreliable gold -- cows
  -- 1) Timer method
  Timers:CreateTimer(function() ConvertReliableGold() return 1 end)

  -- 2) Gold filter method
  --[[GameRules:GetGameModeEntity():SetModifyGoldFilter(
    function( self, params ) 
      reliable = 1
      return true
    end, 
  self)]]--

  -- Don't end the game if everyone is unassigned
  SendToServerConsole("dota_surrender_on_disconnect 0")

  -- Register Listener
  CustomGameEventManager:RegisterListener( "update_selected_entities", Dynamic_Wrap(BuildingEvents, 'OnPlayerSelectedEntities'))
  CustomGameEventManager:RegisterListener( "repair_order", Dynamic_Wrap(GameMode, "RepairOrder"))   
  CustomGameEventManager:RegisterListener( "harvest_order", Dynamic_Wrap(GameMode, "HarvestOrder"))   
  CustomGameEventManager:RegisterListener( "update_player_slot", Dynamic_Wrap(GameMode, "OnPlayerSlotUpdated"))
  
  -- Full units file to get the custom values
  GameRules.AbilityKV = LoadKeyValues("scripts/npc/npc_abilities_custom.txt")
  GameRules.UnitKV = LoadKeyValues("scripts/npc/npc_units_custom.txt")
  GameRules.HeroKV = LoadKeyValues("scripts/npc/npc_heroes_custom.txt")
  GameRules.ItemKV = LoadKeyValues("scripts/npc/npc_items_custom.txt")
  GameRules.Requirements = LoadKeyValues("scripts/kv/tech_tree.kv")

    -- Store and update selected units of each pID
  GameRules.SELECTED_UNITS = {}

  -- Keeps the blighted gridnav positions
  GameRules.Blight = {}

  -- Team sizes for each map
  local mapName = GetMapName()
  if mapName == "barracks_master_quad" then
    GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, 4)
    GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS, 4)
  else
    GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, 2)
    GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS, 2)
    --GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_CUSTOM_1, 4)    
  end

  DebugPrint('[BAREBONES] Done loading Barebones gamemode!\n\n')  
end