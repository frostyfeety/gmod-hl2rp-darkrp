antiafktab = {}
antiafkMinOpenSlots = 5
antiafkGracePeriod = 300
antiafkKickMessage = "AFK"

function antiafkAFK(ply, afkbool)
	if afkbool then
		antiafktab[ply] = CurTime()
	else
		if !ply:getDarkRPVar("AFK") then
			antiafktab[ply] = nil
		end
	end
end

hook.Add("playerSetAFK", "antiafkAFK", antiafkAFK)

function AFKConnecting()
	local playertokick = nil
	if (#player.GetAll()) + antiafkMinOpenSlots >= game.MaxPlayers() then
		
		for v,k in pairs(antiafktab) do
			
			if ( not v:IsValid() ) then
				antiafktab[v] = nil 
				continue
			end
			
			if antiafktab[v] + antiafkGracePeriod <= CurTime()  then
				if !playertokick then
					playertokick = v
				else
					if antiafktab[playertokick] <= antiafktab[v] then
						playertokick = v
					end
				end
			end
		end
		
		if ( playertokick ) then
			playertokick:Kick(antiafkKickMessage)
		end
	end
end
hook.Add("PlayerConnect", "AFKConnect", AFKConnecting)
