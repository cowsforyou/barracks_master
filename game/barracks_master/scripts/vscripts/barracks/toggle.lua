--------------------------------------------------------------------------------------------------------
-- Autocast: Makes an ability automatically autocast
--------------------------------------------------------------------------------------------------------
function Toggle( event )
	local ability = event.ability
	ability:ToggleAbility()
end