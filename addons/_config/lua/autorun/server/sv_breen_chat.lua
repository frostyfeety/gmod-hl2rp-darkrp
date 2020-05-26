local folder = "npc/metropolice/vo/"

local sounds = {}
sounds["Код 1"] = {folder .. "sacrificecode1maintaincp.wav"}

hook.Add("PostPlayerSay", "rp_combine_chat_sounds", function(player, txt)
	if IsValid(player) && player:Team() == TEAM_MAYOR then
		if player.SoundDelay and player.SoundDelay > CurTime() then return end
		local sound = sounds[txt]
		if not sound then return end
		player:EmitSound(sound[math.random(#sound)], 80, 80)
		player.SoundDelay = CurTime() + 3
	end
end)