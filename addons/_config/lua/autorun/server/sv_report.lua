util.AddNetworkString"rp_cp_death"

hook.Add("PlayerDeath", "rp_PlayerDeath", function(victim, inflictor, attacker)
	if ( victim == attacker ) then return end
	for k, v in ipairs(player.GetAll()) do
		if v:isCP() then
			if victim:Team() == TEAM_MAYOR then
	        	DarkRP.notify(v, 1, 8,  attacker:GetName().. " убил Администратора Города")
            	net.Start("rp_cp_death")
                	net.WriteEntity(victim)
            	net.Send(v)
			elseif victim ~= attacker then
	        	DarkRP.notify(v, 1, 8, "Смерть "..victim:GetName()..". Убийца "..attacker:GetName())
	        	DarkRP.notify(v, 3, 8,  attacker:GetName().. " нуждается в проверке на дефектность")
            	net.Start("rp_cp_death")
                	net.WriteEntity(victim)
            	net.Send(v)
			else
	        	DarkRP.notify(v, 1, 4, "Смерть "..victim:GetName()..". Убийца #"..attacker:GetRP_ID())
            	net.Start("rp_cp_death")
                	net.WriteEntity(victim)
            	net.Send(v)
	        	attacker:setDarkRPVar("wanted", true)
	        	attacker:setDarkRPVar("wantedReason", "Убийство юнита Альянса!")
			end
		end
	end
end)