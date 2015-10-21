--------------------------------------------------------------------------------------------------------
-- AbilitySwapper class
--------------------------------------------------------------------------------------------------------
-- An AbilitySwapper creates a pages table. Each page corresponds to a list of abilities.
-- The first page always has 5 abilities and an Ability Swap ability (for next).
-- Each subsequent page has 4 abilities and a pair of Ability Swap abilities (for previous and next).
-- If the last page has too few abilities, the remaining abilities are populated with ability_swapper_empty.
--------------------------------------------------------------------------------------------------------
-- Instantiated with AbilitySwapper(handle caster, table ability_list)
-- Assumes that ability swapper ability is in slot 5 or 6 to determine whether to go previous or next
-- An ability_list is a table that holds a list of ability names.
-- Example: local ability_list = { "meepo_earthbind", "meepo_poof", ... }
-- After it's instantiated, call AbilitySwap(ability) to go previous or next
-- NOTE: Does not keep track of ability levels yet
--------------------------------------------------------------------------------------------------------
SWAPPER_ABILITY_INDEX_PREVIOUS = 4 -- Valve 0-indexing; 6 abilities numbered 0-5
SWAPPER_ABILITY_INDEX_NEXT = 5

-- requires class_utils.lua
if AbilitySwapper == nil then
    AbilitySwapper = DeclareClass({}, function(self, caster, ability_list)
        self.initialize(self, caster, ability_list)
    end)

end

function AbilitySwapper:initialize(caster, ability_list)
    self.caster = caster
    self.pages = self:_BuildPages(ability_list)
    self.finalPage = #self.pages
    self.currentPage = 1
end

function AbilitySwapper:_BuildPages(ability_list)
    -- create table pages that holds tables
    local pages = {}
    pages[1] = {}

    -- create page 1 with 5 items
    for i=1, 5 do
        table.insert(pages[1], ability_list[1])
        table.remove(ability_list, 1)
    end

    -- each additional page has 4 items
    local thisPage = 2
    local abilitiesOnThisPage = 0
    pages[thisPage] = {}
    for _,item in pairs(ability_list) do
        abilitiesOnThisPage = abilitiesOnThisPage + 1

        -- advance the page if necessary
        if abilitiesOnThisPage > 4 then
            thisPage = thisPage + 1
            abilitiesOnThisPage = 1
            pages[thisPage] = {}
        end

        table.insert(pages[thisPage], item)
    end

    -- fill remaining page with blank abilities
    if abilitiesOnThisPage < 4 then
        for i=abilitiesOnThisPage+1, 4 do
            table.insert(pages[thisPage], "ability_swapper_empty")
        end
    end

    return pages
end

function AbilitySwapper:SetCurrentPage(newPageNumber)
    self.currentPage = newPageNumber
    return self.currentPage
end

function AbilitySwapper:GetCurrentPage()
    return self.currentPage
end

function AbilitySwapper:DoSwap()
    local currentPage = self:GetCurrentPage()
    local page = self.pages[currentPage]

    -- remove all 6 abilities
    for i=0,5 do
        local oldAbility = self.caster:GetAbilityByIndex(i)
        local oldName = oldAbility:GetAbilityName()
        self.caster:RemoveAbility(oldName)      
    end

    -- repopulate with our new abilities (up to 4 or 5)
    for _,abilityName in pairs(page) do
        self.caster:AddAbility(abilityName)
        local newAbility = self.caster:FindAbilityByName(abilityName)
        newAbility:SetLevel(newAbility:GetMaxLevel())
    end

    -- add previous swapper, if not the first page
    if currentPage ~= 1 then
        self.caster:AddAbility("ability_swapper_previous")
        local previousAbility = self.caster:FindAbilityByName("ability_swapper_previous")
        previousAbility:SetLevel(previousAbility:GetMaxLevel())
    end

    -- on the final page, make the next swapper empty
    local finalAbilityName = ""
    if currentPage == self.finalPage then
        finalAbilityName = "ability_swapper_empty"
    else
        finalAbilityName = "ability_swapper_next"
    end

    -- add the final ability, whether it's next or empty
    self.caster:AddAbility(finalAbilityName)
    local finalAbility = self.caster:FindAbilityByName(finalAbilityName)
    finalAbility:SetLevel(finalAbility:GetMaxLevel())
end

function AbilitySwapper:NextPage()
    local currentPage = self:SetCurrentPage(self:GetCurrentPage() + 1)
    self:DoSwap()
end

function AbilitySwapper:PreviousPage()
    local currentPage = self:SetCurrentPage(self:GetCurrentPage() - 1)
    self:DoSwap()
end

-- should be called on spell start
function AbilitySwapper:SwapAbilities(ability)
    local abilityIndex = ability:GetAbilityIndex()

    if abilityIndex == SWAPPER_ABILITY_INDEX_PREVIOUS then
        self:PreviousPage()
    elseif abilityIndex == SWAPPER_ABILITY_INDEX_NEXT then
        self:NextPage()
    else
        print("Error: swap ability called from wrong ability slot")
    end 
end