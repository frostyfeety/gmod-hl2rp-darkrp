hook.Add("SetupMove", "rp_sprint_limiter", function(ply, mv, cmd)
	if ply:GetMoveType() ~= MOVETYPE_WALK then return end

	local s = mv:GetForwardSpeed() ~= 0 and mv:GetSideSpeed() ~= 0 and math.sqrt(ply:GetMaxSpeed() ^ 2 / 2) or ply:GetMaxSpeed()
	local ws = mv:GetForwardSpeed() ~= 0 and mv:GetSideSpeed() ~= 0 and math.sqrt(ply:GetWalkSpeed() ^ 2 / 2) or ply:GetWalkSpeed()
	local ss = ws * 0.8

	if mv:GetForwardSpeed() ~= 0 then
		if mv:GetForwardSpeed() > 0 then
			mv:SetForwardSpeed(s)
		else
			mv:SetForwardSpeed(-ss)
		end
	end
    
	if mv:GetSideSpeed() ~= 0 then
		mv:SetSideSpeed(mv:GetSideSpeed() / math.abs(mv:GetSideSpeed()) * ss)
	end
end)