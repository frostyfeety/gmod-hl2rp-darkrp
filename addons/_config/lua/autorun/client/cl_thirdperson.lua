local toggle = CreateClientConVar("rp_toggle_thirdperson", "0", true, false)

local offset = {
	[1] = 2,
	[2] = 17,
	[3] = -55
}

hook.Add('ShouldDrawLocalPlayer', 'rp_draw_player', function()
	if toggle:GetBool() then
		return ( (not LocalPlayer():InVehicle()) )
	end
end)

hook.Add('CalcView', 'rp_draw_calc_view', function (pl, origin, ang, fov)
	if toggle:GetBool() and (not pl:InVehicle()) then
		return {
			origin = util.TraceLine({
				start = origin,
				endpos = origin + (ang:Up() * offset[1]) + (ang:Right() * offset[2]) + (ang:Forward() * offset[3]),
				filter = pl,
				
			}).HitPos + (ang:Forward() * 16),
			angles = ang,
			fov = fov
		}
	end
end)