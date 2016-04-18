if BuildingEvents == nil then
  BuildingEvents = class({})
end

-- A player picked a hero
function BuildingEvents:OnPlayerPickHero(keys)

  local hero = EntIndexToHScript(keys.heroindex)
  local player = EntIndexToHScript(keys.player)
  local playerID = hero:GetPlayerID()

  -- Initialize Variables for Tracking
  hero.units = {} -- This keeps the handle of all the units of the player, to iterate for unlocking upgrades
  hero.structures = {} -- This keeps the handle of the constructed units, to iterate for unlocking upgrades
  hero.buildings = {} -- This keeps the name and quantity of each building
  hero.upgrades = {} -- This kees the name of all the upgrades researched
  hero.lumber = 0 -- Secondary resource of the player

  -- Create a building in front of the hero
  local position = hero:GetAbsOrigin() + hero:GetForwardVector() * 300
  local starting_rax_name = "bm_melee_barracks"
  local construction_size = BuildingHelper:GetConstructionSize(starting_rax_name)
  local pathing_size = BuildingHelper:GetConstructionSize(starting_rax_name) 
  local angle = 90 -- rotate building when spawned
  local building = BuildingHelper:PlaceBuilding(player, starting_rax_name, position, construction_size, pathing_size, angle)

  -- Preupgrade Research
  --local spawn_air_creeps = building:FindAbilityByName("research_spawn_air_creeps")
  --hero.upgrades["research_spawn_air_creeps"] = 1
  --spawn_air_creeps:SetLevel(2)

  local spawn_melee_creeps = building:FindAbilityByName("research_spawn_melee_creeps")
  hero.upgrades["research_spawn_melee_creeps"] = 1
  spawn_melee_creeps:SetLevel(2)

  --local spawn_ranged_creeps = building:FindAbilityByName("research_spawn_ranged_creeps")
  --hero.upgrades["research_spawn_ranged_creeps"] = 1
  --spawn_ranged_creeps:SetLevel(2)

  --local spawn_siege_creeps = building:FindAbilityByName("research_spawn_siege_creeps")
  --hero.upgrades["research_spawn_siege_creeps"] = 1
  --spawn_siege_creeps:SetLevel(2)

  --local spawn_skeleton_creeps = building:FindAbilityByName("research_spawn_skeleton_creeps")
  --hero.upgrades["research_spawn_skeleton_creeps"] = 1
  --spawn_skeleton_creeps:SetLevel(2)

  --<< cows start
  -- Colorize starting rax
  local playerHero = player:GetAssignedHero()
  local heroName = playerHero:GetUnitName()

  if      heroName == "npc_dota_hero_sven"              then building:SetRenderColor(50,167,255) -- blue
  elseif  heroName == "npc_dota_hero_templar_assassin"  then building:SetRenderColor(255,255,0) -- purple
  elseif  heroName == "npc_dota_hero_terrorblade"       then building:SetRenderColor(255,128,128) -- red
  elseif  heroName == "npc_dota_hero_arc_warden"        then building:SetRenderColor(128,255,128) -- green
  end
  -- cows end>>

  -- Set health to test repair
  --building:SetHealth(building:GetMaxHealth()/3)

  --[[ These are required for repair to know how many resources the building takes
  building.GoldCost = GameRules.AbilityKV["build_"..starting_rax_name]["AbilityGoldCost"]
  building.LumberCost = 100
  building.BuildTime = 15 ]]--

  -- Add the building to the player structures list
  hero.buildings[starting_rax_name] = 1
  table.insert(hero.structures, building)

  CheckAbilityRequirements( hero, player )
  CheckAbilityRequirements( building, player )

  -- Add the hero to the player units list
  table.insert(hero.units, hero)
  hero.state = "idle" --Builder state

  --[[
  -- Spawn some peasants around the hero
  local position = hero:GetAbsOrigin()
  local numBuilders = 5
  local angle = 360/numBuilders
  for i=1,5 do
    local rotate_pos = position + Vector(1,0,0) * 100
    local builder_pos = RotatePosition(position, QAngle(0, angle*i, 0), rotate_pos)

    local builder = CreateUnitByName("peasant", builder_pos, true, hero, hero, hero:GetTeamNumber())
    builder:SetOwner(hero)
    builder:SetControllableByPlayer(playerID, true)
    table.insert(hero.units, builder)
    builder.state = "idle"

    -- Go through the abilities and upgrade
    CheckAbilityRequirements( builder, player )
  end
  ]]

  -- Give Initial Resources
  hero:SetGold(350, false)
  ModifyLumber(player, 0)

  -- Lumber tick
  Timers:CreateTimer(1, function()
    ModifyLumber(player, 5)
    return 30
  end)

  -----------------------
  -- Give item to hero --
  -----------------------
  hero:AddItemByName("item_travel_boots")
  hero:AddItemByName("item_boar")
  hero:AddItemByName("item_last_stand")

  -- Learn all abilities (this isn't necessary on creatures)
  for i=0,15 do
    local ability = hero:GetAbilityByIndex(i)
    if ability then ability:SetLevel(ability:GetMaxLevel()) end
  end
  hero:SetAbilityPoints(0)

end

-- An entity died
function BuildingEvents:OnEntityKilled( event )
  -- The Unit that was Killed
  local killedUnit = EntIndexToHScript(event.entindex_killed)
  -- The Killing entity
  local killerEntity = nil
  if event.entindex_attacker then
    killerEntity = EntIndexToHScript(event.entindex_attacker)
  end

  -- Player owner of the unit
  local player = killedUnit:GetPlayerOwner()
  local hero = nil
  if player then hero = player:GetAssignedHero() end

  -- Building Killed
  if IsCustomBuilding(killedUnit) then

    -- Building Helper grid cleanup
    -- BuildingHelper:RemoveBuilding(killedUnit, true) -- removing with upgraded script

    -- Check units for downgrades
    local building_name = killedUnit:GetUnitName()
        
    -- Substract 1 to the player building tracking table for that name
    if hero.buildings[building_name] then
      hero.buildings[building_name] = hero.buildings[building_name] - 1
    end

    -- possible unit downgrades
    for k,units in pairs(hero.units) do
        CheckAbilityRequirements( units, player )
    end

    -- possible structure downgrades
    for k,structure in pairs(hero.structures) do
      CheckAbilityRequirements( structure, player )
    end
  end

  -- Cancel queue of a builder when killed
  --[[if IsBuilder(killedUnit) then
    BuildingHelper:ClearQueue(killedUnit)
  end]]-- removing with upgraded script

  if player and not killedUnit:IsHero() then
    if IsCustomBuilding(killedUnit) then
      RemoveMatchingEntityFromTable(hero.structures, killedUnit)
    else
      RemoveMatchingEntityFromTable(hero.units, killedUnit)
    end
  end
end

function RemoveMatchingEntityFromTable(tbl, entity)
  for i,item in pairs(tbl) do
    if item and IsValidEntity(item) then
      if item:entindex() == entity:entindex() then
        table.remove(tbl, i)
        --print("Successfully removed "..entity:GetUnitName().." from table. Player owner: "..
        --  entity:GetPlayerOwnerID() .. ". Table length: "..#tbl)
        return true
      end
    else
      print("ERROR: Passed table item is nil or not valid.")
    end
  end
  print("ERROR: Could not find entity "..entity:GetUnitName().." in table.")
  return false
end