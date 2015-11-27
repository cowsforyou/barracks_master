--------------------------------------------------------------------------------------------------------
-- Autocast: Makes an ability automatically autocast
--------------------------------------------------------------------------------------------------------
function Autocast( keys )
    local ability = keys.ability

    if ability.initialAutocast == nil and ability:GetAutoCastState() == false then
        ability:ToggleAutoCast()
    end
end