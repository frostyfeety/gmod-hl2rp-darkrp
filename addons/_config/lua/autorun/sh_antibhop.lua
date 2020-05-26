hook.Add("OnPlayerHitGround", "rp_antibhop", function(player)
	local velocity = player:GetVelocity()
	player:SetVelocity(Vector(-(velocity.x * 0.75), -(velocity.y * 0.75), 0))
end)
