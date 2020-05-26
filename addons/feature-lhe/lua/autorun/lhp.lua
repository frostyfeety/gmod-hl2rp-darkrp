AddCSLuaFile()

local etb_threshold = 65
local etb_muffle_effect = 45

if CLIENT then
	local intensity = 0
	local hpwait, hpalpha = 0, 0
	local clr = {
		[ "$pp_colour_addr" ] = 0,
		[ "$pp_colour_addg" ] = 0,
		[ "$pp_colour_addb" ] = 0,
		[ "$pp_colour_brightness" ] = 0,
		[ "$pp_colour_contrast" ] = 1,
		[ "$pp_colour_colour" ] = 1,
		[ "$pp_colour_mulr" ] = 0,
		[ "$pp_colour_mulg" ] = 0,
		[ "$pp_colour_mulb" ] = 0
	}

	local function LowHP_HUDPaint()
		
		local ply = LocalPlayer()
		local hp = ply:Health()
		local x, y = ScrW(), ScrH()
		local FT = FrameTime()
		
		if ply:Health() <= etb_muffle_effect then
			if not ply.lastDSP then
				ply:SetDSP(14)
				ply.lastDSP = 14
			end
		else
			if ply.lastDSP then
				ply:SetDSP(0)
				ply.lastDSP = nil
			end
		end
		
		intensity = math.Approach(intensity, math.Clamp(1 - math.Clamp(hp / etb_threshold, 0, 1), 0, 1), FT * 3)
		
		if intensity > 0 then
			
			clr[ "$pp_colour_colour" ] = 1 - intensity
			DrawColorModify(clr)
			
			if ply:Alive() then
				local CT = CurTime()
				
				if CT > hpwait then
					hpwait = CT + 0.5
				end
			end
		end	
	end
	
	hook.Add("HUDPaint", "LowHP_HUDPaint", LowHP_HUDPaint)
end