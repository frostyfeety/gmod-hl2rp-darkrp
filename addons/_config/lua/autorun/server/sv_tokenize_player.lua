hook.Add("PlayerInitialSpawn", "rp_set_id", function(ply)
	local id = (string.sub(ply:SteamID64(), 13, 17) or math.floor(math.random(11111, 99999)))
	local city = (string.sub(ply:SteamID64(), 16, 17) or math.floor(math.random(11, 99)))
	ply:SetNWInt("RP_ID", tonumber(id))
	ply:SetNWInt("RP_CITY", tonumber(city))
end)