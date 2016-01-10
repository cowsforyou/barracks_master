---------------------------------------------------------------------------
if GameMode == nil then
  _G.GameMode = class({})
end

require('gamemode')

require('utilities')
require('upgrades')
require('mechanics')
require('orders')
require('builder')
require('buildingevents') -- veg
require('statcollection/init') -- cows

require('barracks/spawner')
require('barracks/spawn_synchronizer')
require('barracks/class_utils')
require('barracks/ability_swapper')
require('barracks/scoreboard_updater')
require('barracks/last_hits')
require('barracks/convars')
require('barracks/purifier')
require('barracks/alchemist_gifter')

require('buildings/research')

-- This library allow for easily delayed/timed actions
require('libraries/timers')
-- This library can be used for advancted physics/motion/collision of units.  See PhysicsReadme.txt for more information.
require('libraries/physics')
-- This library can be used for advanced 3D projectile systems.
require('libraries/projectiles')
-- This library can be used for sending panorama notifications to the UIs of players/teams/everyone
require('libraries/notifications')
-- This library can be used for starting customized animations on units from lua
require('libraries/animations')
-- This library can be used for performing "Frankenstein" attachments on units
require('libraries/attachments')
require('libraries/popups')
require('libraries/buildinghelper')

-- These internal libraries set up barebones's events and processes.  Feel free to inspect them/change them if you need to.
require('internal/gamemode')
require('internal/events')
require('internal/util')

-- settings.lua is where you can specify many different properties for your game mode and is one of the core barebones files.
require('settings')
-- events.lua is where you can specify the actions to be taken when any event occurs and is one of the core barebones files.
require('events')


function Precache( context )


-- Barracks Master --
  -- Particles

    -- Scouts
  PrecacheResource("particle_folder", "particles/units/heroes/hero_lone_druid", context) -- for Boar, Hawk and Techies Scouts
  PrecacheResource("particle_folder", "particles/units/heroes/hero_beastmaster", context) -- for Boar, Hawk and Techies Scouts  
  PrecacheResource("particle_folder", "particles/units/heroes/hero_techies", context) -- for Techies Scout
  PrecacheResource("particle_folder", "particles/units/heroes/hero_shredder", context) -- for Lumberjack


    -- Custom Scouts
  PrecacheResource("particle_folder", "particles/units/heroes/hero_lycan", context) -- for Wolf   
  PrecacheResource("particle_folder", "particles/econ/courier/courier_greevil_white", context) -- for land scout -- champion
  PrecacheResource("particle_folder", "particles/econ/courier/courier_greevil_purple", context) -- for land scout -- ghost
  PrecacheResource("particle_folder", "particles/econ/courier/courier_greevil_red", context) -- for land scout -- fire
  PrecacheResource("particle_folder", "particles/econ/courier/courier_greevil_blue", context) -- for land scout -- ice
  PrecacheResource("particle_folder", "particles/econ/courier/courier_greevil_yellow", context) -- for land scout -- electric


    -- Heroes
  PrecacheResource("particle_folder", "particles/units/heroes/hero_vengeful", context) -- for Hero: Vengeful Spirit
  PrecacheResource("particle_folder", "particles/units/heroes/hero_nevermore", context) -- for Hero: Shadow Fiend
                                                                                        -- for Hero: Beastmaster (precached above)
  PrecacheResource("particle_folder", "particles/units/heroes/hero_medusa", context) -- for Hero: Medusa                                                                                        


    -- Buildings
  PrecacheResource("particle_folder", "particles/econ/courier/courier_trail_hw_2012", context) -- for The Stump 
  PrecacheResource("particle_folder", "particles/units/heroes/hero_obsidian_destroyer", context) -- for Portal of Heroes
  PrecacheResource("particle_folder", "particles/econ/courier/courier_trail_international_2013_se", context) -- for Purifier


    -- Abilities
  PrecacheResource("particle", "particles/items3_fx/mango_active.vpcf", context) -- for Enchanted Mango
  PrecacheResource("particle", "particles/items_fx/chain_lightning.vpcf", context) -- for Static Touch
  PrecacheResource("particle_folder", "particles/units/heroes/hero_skywrath_mage", context) -- for Mystic Flare
  PrecacheResource("particle_folder", "particles/units/heroes/hero_invoker", context) -- for Sun Strike/Chaos Meteor
  PrecacheResource("particle_folder", "particles/units/heroes/hero_lich", context) -- for Chain Frost


    -- Override Abilities
  PrecacheResource("particle_folder", "particles/units/heroes/hero_treant", context) -- for Living Armor
  PrecacheResource("particle_folder", "particles/units/heroes/hero_sniper", context) -- for Assassinate


    -- Misc
  PrecacheResource("particle_folder", "particles/bm_custom_particles", context) -- for Construction/Research


-- Sounds
  PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_beastmaster.vsndevts", context) -- for Boar and Hawk Scouts
  PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_techies.vsndevts", context) -- for Techies Scout
  PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_shredder.vsndevts", context) -- for Lumberjacks

  PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_vengefulspirit.vsndevts", context) -- for Hero: Vengeful Spirit
  PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_nevermore.vsndevts", context) -- for Hero: Shadow Fiend
                                                                                                          -- for Hero: Beastmaster (precached above)
  PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_medusa.vsndevts", context) -- for Hero: Medusa                                                                                                      

  PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_skywrath_mage.vsndevts", context) -- for Mystic Flare
  PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_invoker.vsndevts", context) -- for Sun Strike/Chaos Meteor
  PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_lich.vsndevts", context) -- for Chain Frost

  PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_treant.vsndevts", context) -- for Living Armor
  PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_sniper.vsndevts", context) -- for Assassinate 
  PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_zuus.vsndevts", context) -- for Static Touch

    -- Global Announcements
  PrecacheResource("soundfile", "soundevents/BM_custom_sounds.vsndevts", context) -- for Barracks Master Announcer


-- Units
  PrecacheUnitByNameSync("lumberjack", context)    
  PrecacheUnitByNameSync("scout_boar", context)
  PrecacheUnitByNameSync("scout_hawk", context)
  PrecacheUnitByNameSync("scout_techies", context)
  PrecacheUnitByNameSync("creep_air", context)

  PrecacheUnitByNameSync("hero_vengeful", context)
  PrecacheUnitByNameSync("hero_nevermore", context)  
  PrecacheUnitByNameSync("hero_beastmaster", context) 
  PrecacheUnitByNameSync("hero_medusa", context)   

  PrecacheUnitByNameSync("bm_skeleton_barracks", context) 
  PrecacheUnitByNameSync("bm_melee_barracks", context) 
  PrecacheUnitByNameSync("bm_ranged_barracks", context) 
  PrecacheUnitByNameSync("bm_lumber_yard", context)
  PrecacheUnitByNameSync("bm_siege_barracks", context) 
  PrecacheUnitByNameSync("bm_tech_lab", context)
  PrecacheUnitByNameSync("bm_aviation_sanctuary", context)
  PrecacheUnitByNameSync("bm_ancient_barracks", context) 
  PrecacheUnitByNameSync("bm_heroes", context) 
  PrecacheUnitByNameSync("bm_purifier", context) 
  PrecacheUnitByNameSync("bm_library", context)
  PrecacheUnitByNameSync("bm_warp_chasm", context)
  PrecacheUnitByNameSync("bm_unpromising", context)         
  PrecacheUnitByNameSync("bm_luminous", context)    

  PrecacheUnitByNameSync("npc_dota_hero_sven", context)
  PrecacheUnitByNameSync("npc_dota_hero_templar_assassin", context)
  PrecacheUnitByNameSync("npc_dota_hero_terrorblade", context)
  PrecacheUnitByNameSync("npc_dota_hero_arc_warden", context)

  PrecacheUnitByNameSync("npc_dota_hero_wisp", context) -- for spectator

    -- Items
  PrecacheItemByNameSync("item_boar", context)
  PrecacheItemByNameSync("item_hawk", context)
  PrecacheItemByNameSync("item_techies", context)
  PrecacheItemByNameSync("item_last_stand", context)

  PrecacheItemByNameSync("item_apply_modifiers", context)

  -- Non Barracks Master --   
    -- Model ghost and grid particles
  PrecacheResource("particle_folder", "particles/buildinghelper", context)

    -- Resources used
  PrecacheUnitByNameSync("peasant", context)
  PrecacheUnitByNameSync("tower", context)
  PrecacheUnitByNameSync("tower_tier2", context)
  PrecacheUnitByNameSync("city_center", context)
  PrecacheUnitByNameSync("city_center_tier2", context)
  PrecacheUnitByNameSync("tech_center", context)
  PrecacheUnitByNameSync("dragon_tower", context)
  PrecacheUnitByNameSync("dark_tower", context)
end

-- Create our game mode and initialize it
function Activate()
  GameMode:InitGameMode()
end