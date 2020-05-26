local black_list = {}

hook.Add("PhysgunPickup", "rp_fix_ladder_glitch", function(ply, ent)
	black_list[ply] = ent
	if ply:GetMoveType() == MOVETYPE_LADDER then
		return false
	end
end)

hook.Add("PhysgunDrop", "rp_fix_ladder_glitch", function(ply, ent)
	black_list[ply] = nil
end)

hook.Add("Think", "rp_fix_ladder_glitch", function()
	for ply, ent in pairs(black_list) do
		if not ply:IsValid() or not ent:IsValid() then
			black_list[ply] = nil
			continue
		end

		if ply:GetMoveType() == MOVETYPE_LADDER then
			ent:ForcePlayerDrop()
			black_list[ply] = nil
		end
	end
end)