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
require('buildinghelper')
require('buildingevents') -- veg
require('barracks/spawn_synchronizer') -- veg

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

-- These internal libraries set up barebones's events and processes.  Feel free to inspect them/change them if you need to.
require('internal/gamemode')
require('internal/events')
require('internal/util')

-- settings.lua is where you can specify many different properties for your game mode and is one of the core barebones files.
require('settings')
-- events.lua is where you can specify the actions to be taken when any event occurs and is one of the core barebones files.
require('events')


function Precache( context )

  -- Model ghost and grid particles
  PrecacheResource("particle_folder", "particles/buildinghelper", context)
  PrecacheResource("particle_folder", "particles/econ/items/earthshaker/earthshaker_gravelmaw/", context)

  -- Resources used
  PrecacheUnitByNameSync("peasant", context)
  PrecacheUnitByNameSync("tower", context)
  PrecacheUnitByNameSync("tower_tier2", context)
  PrecacheUnitByNameSync("city_center", context)
  PrecacheUnitByNameSync("city_center_tier2", context)
  PrecacheUnitByNameSync("tech_center", context)
  PrecacheUnitByNameSync("dragon_tower", context)
  PrecacheUnitByNameSync("dark_tower", context)
  PrecacheUnitByNameSync("wall", context)

  PrecacheItemByNameSync("item_apply_modifiers", context)

end

-- Create our game mode and initialize it
function Activate()
  GameMode:InitGameMode()
end

---------------------------------------------------------------------------




--[[
  OUT OF VECTOR IS CAUSING ISSUES? CNetworkOriginCellCoordQuantizedVector m_cellZ cell 155 is outside of cell bounds (0->128) @(-15714.285156 -15714.285156 23405.712891)
  NEED TO ADD ABILITY_BUILDING AND QUEUE MANUALLY, NECESSARY?
  COLLISION SIZE?
]]--