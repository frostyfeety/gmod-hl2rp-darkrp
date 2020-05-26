local EmptyFunc = function() end

local debugInfoTbl = debug.getinfo(EmptyFunc)

local function checkEnv(plyIn)
	if game.SinglePlayer() then
		if chat and chat.AddText
				and debugInfoTbl.short_src:StartWith("addons") -- unpacked version
				and not file.Exists(debugInfoTbl.short_src:GetPathFromFilename():Replace("lua/tfa/modules/", "") .. ".git", "GAME") then -- non-git
			return
		end
	else
		local activeGamemode = engine.ActiveGamemode()
		local isRP = activeGamemode:find("rp")
				or activeGamemode:find("roleplay")
				or activeGamemode:find("serious")

		if isRP and (SERVER or (IsValid(plyIn) and (plyIn:IsAdmin() or plyIn:IsSuperAdmin()))) then
			if TFA_BASE_VERSION <= 4.034 then -- seems to be common problem with SWRP servers
				local printFunc = chat and chat.AddText or print
			end
		end
	end
end

if CLIENT then
	hook.Add("HUDPaint", "TFA_CheckEnv", function()
		local ply = LocalPlayer()

		if not IsValid(ply) then return end

		hook.Remove("HUDPaint", "TFA_CheckEnv")

		checkEnv(ply)
	end)
else
	hook.Add("InitPostEntity", "TFA_CheckEnv", checkEnv)
end