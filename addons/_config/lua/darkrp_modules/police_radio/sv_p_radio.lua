local function Police_Radio_Main(ply1,ply2)
	if ply2:getDarkRPVar("Police_Radio_Enabled") and (ply2:isCP() or Police_Radio_Config["Allow_Teams"][ply2:getJobTable().command]) and (ply1:isCP() or Police_Radio_Config["Allow_Teams"][ply1:getJobTable().command]) then
		if ply1:GetPos():Distance(ply2:GetPos()) > 500 then --Only disable 3D audio if they are far enough
			if ply1:getDarkRPVar("Police_Radio_CanHear") then
				return true, false
			end
		end
	end
end
hook.Add("PlayerCanHearPlayersVoice","Police_Radio_Main",Police_Radio_Main)

util.AddNetworkString("police_radio_toggle")
net.Receive("police_radio_toggle",function(len,ply)
	if Police_Radio_Config["Allow_Teams"][ply:getJobTable().command] or ply:isCP() or ply:isOTA() and ply:GetModel() ~= "models/player/soldier_stripped.mdl" then
		local radiotog = net.ReadBool()
		if radiotog then
			if ply:getDarkRPVar("Police_Radio_Enabled") then
				ply:setDarkRPVar("Police_Radio_Enabled",nil)
				net.Start("police_radio_toggle")
					net.WriteBool(true)
				net.Send(ply)
			else
				if Police_Radio_Config["Require_Admin_Approval"] then
					if tostring(ply:GetPData("Police_Radio_Allow")) == "false" or tostring(ply:GetPData("Police_Radio_Allow")) == "nil" then --Had some issues with PData, so don't ask
						ply:ChatPrint("This requires admin approval first!")
						return
					end
				end
				ply:setDarkRPVar("Police_Radio_Enabled",true)
				net.Start("police_radio_toggle")
				net.Send(ply)
			end
		else
			if ply:getDarkRPVar("Police_Radio_CanHear") then
				ply:setDarkRPVar("Police_Radio_CanHear",nil)
				net.Start("police_radio_toggle")
					net.WriteBool(true)
					net.WriteString("npc/metropolice/vo/off1.wav")
				net.Send(ply)
			else
				ply:setDarkRPVar("Police_Radio_CanHear",true)
				net.Start("police_radio_toggle")
					net.WriteBool(true)
					net.WriteString("npc/metropolice/vo/on2.wav")
				net.Send(ply)
			end
		end
	end
end)
hook.Add("PlayerInitialSpawn","Police_Radio_OnSpawn",function(ply) if Police_Radio_Config["CanHear_Default"] then ply:setDarkRPVar("Police_Radio_CanHear",true) end end)

DarkRP.defineChatCommand("giveradio",function(ply,args)
	
	if not ply:IsSuperAdmin() then ply:ChatPrint("You have insufficient permissions to use this!") return "" end
	
	local pl = DarkRP.findPlayer(args)
	
	if pl then
		ply:ChatPrint("Granted "..pl:GetName().." the ability to use the Police Radio. (This has been saved)")
		pl:ChatPrint(ply:GetName().." has enabled your Police Radio. (This remains permanent until removed)")
		local rf = RecipientFilter()
		rf:AddPlayer(ply)
		rf:AddPlayer(pl)
		net.Start("police_radio_toggle")
			net.WriteBool(true)
			net.WriteString("ambient/levels/prison/radio_random13.wav")
		net.Send(rf)
		pl:SetPData("Police_Radio_Allow",true)
	else
		ply:ChatPrint("No players were found! UserID, SteamID or name is needed")
	end
	
	return ""
end)

DarkRP.defineChatCommand("removeradio",function(ply,args)
	
	if not ply:IsSuperAdmin() then ply:ChatPrint("You have insufficient permissions to use this!") return "" end
	
	local pl = DarkRP.findPlayer(args)
	
	if pl then
		ply:ChatPrint("Removed "..pl:GetName().."'s ability to use the Police Radio. (This has been saved)")
		pl:ChatPrint(ply:GetName().." has taken away your Police Radio. (This remains permanent)")
		local rf = RecipientFilter()
		rf:AddPlayer(ply)
		rf:AddPlayer(pl)
		net.Start("police_radio_toggle")
			net.WriteBool(true)
			net.WriteString("ambient/levels/prison/radio_random7.wav")
		net.Send(rf)
		pl:RemovePData("Police_Radio_Allow")
		
		pl:setDarkRPVar("Police_Radio_Enabled",nil)
	else
		ply:ChatPrint("No players were found! UserID, SteamID or name is needed")
	end
	
	return ""
end)