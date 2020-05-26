local function respawntime(pl)
	return 60
end

if SERVER then
	util.AddNetworkString("rp_respawn_timer")

	hook.Add("PlayerDeath", "rp_respawn_timer", function(ply)
		ply.deadtime = RealTime()
		net.Start("rp_respawn_timer")
		net.Send(ply)
	end)
	hook.Add("PlayerDeathThink", "rp_respawn_timer", function(ply)
		if ply.deadtime && RealTime() - ply.deadtime < respawntime(ply) then
			return false
		end
	end)
end

if CLIENT then
	net.Receive("rp_respawn_timer", function()
		local dead = RealTime()
		hook.Add("HUDPaint", "rp_respawn_timer", function()
			draw.SimpleText("Вы возродитесь через " .. math.Round(respawntime() - RealTime() + dead) .. " секунд", "DermaLarge", ScrW() / 2, ScrH() /2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end)
		timer.Simple(respawntime(), function()
			hook.Remove("HUDPaint", "rp_respawn_timer")
			dead = nil
		end)
		system.FlashWindow()
	end)
end