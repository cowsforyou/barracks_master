function ReincarnationCheck( event )
    local caster = event.caster
    local ability = event.ability
    local damage = event.Damage

    -- Check if the damage would be lethal
    local health = caster:GetHealth()
    if health <= 0 then

        local chance = ability:GetLevelSpecialValueFor("reincarnate_chance", ability:GetLevel()-1)

        if RollPercentage(chance) then
            caster.reincarnating = true
            caster:Heal(damage, caster)
            caster:SetHealth(1)

            local duration = 2
            ability:ApplyDataDrivenModifier(caster, caster, "modifier_reincarnating", {duration=duration})

            if caster:HasModifier("modifier_hide") then
                unit:RemoveModifierByName("modifier_hide")
            end

            local particleName = "particles/bm_custom_particles/bm_particle_reincarnate.vpcf"
            ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, caster)

            local tombstone = "particles/generic_hero_status/death_tombstone.vpcf"
            local tomb_particle = ParticleManager:CreateParticle(tombstone, PATTACH_ABSORIGIN_FOLLOW, caster)
            ParticleManager:SetParticleControl(tomb_particle, 2, Vector(duration,0,0))

            StartAnimation(caster, {duration=duration, activity=ACT_DOTA_DIE_SPECIAL, rate=1.5})
            Timers:CreateTimer(duration, function()
                local particleName = "particles/units/heroes/hero_skeletonking/wraith_king_reincarnate.vpcf"
                ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, caster)
                caster:RespawnUnit()
                caster.reincarnating = nil
                ability:RemoveSelf()
            end)
        end
    end
end