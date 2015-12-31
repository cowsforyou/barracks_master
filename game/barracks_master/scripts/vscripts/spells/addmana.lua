function AddMana( event )
    event.target:GiveMana(event.mana_amount)
    PopupMana(event.target, event.mana_amount)
end