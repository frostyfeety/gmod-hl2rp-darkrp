local door_id = {
    599,
    598,
    597,
}

hook.Add("InitPostEntity", "rp_close_doors_id", function()
	for k,v in ipairs(door_id) do
		local ent = ents.GetMapCreatedEntity(v)
		if not IsValid(ent) then continue end
		ent:Fire("Lock", "", 0)
	end
end)

hook.Add("canArrest", "rp_no_admin_arrest", function(arrester, arrestee)
    if arrestee:Team() == TEAM_ADMIN then
        return false, "Нельзя арестовывать администраторов!"
    end
end)

local function DisablePropDamage( ent, dmg )
    if ent:IsPlayer() and dmg:IsDamageType( DMG_CRUSH ) then
        dmg:ScaleDamage( 0 )
    end
end

hook.Add( "EntityTakeDamage", "rp_disable_damage", DisablePropDamage )
