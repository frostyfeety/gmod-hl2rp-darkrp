usermessage.Hook("_Notify", function(msg)
	local text = msg:ReadString()
	GAMEMODE:AddNotify(text, msg:ReadShort(), msg:ReadLong())
	surface.PlaySound("buttons/lightswitch2.wav")
	MsgC(Color(62, 105, 131), "[MinervaRP] ", Color(215, 215, 215), text, "\n")
end)

local hide = {
	["joinleave"]  = true,
	["namechange"] = true,
	["servermsg"]  = true
}

local weapons = {
	["weapon_physgun"] = true,
	["gmod_tool"] 	   = true
}

hook.Add("ChatText", "rp_hide_dfmsgs", function(index, name, text, type)
	if hide[type] then
		return true
	end
end)

hook.Add("SpawnMenuOpen", "rp_spawnmenu_fix", function()
	local aw = LocalPlayer():GetActiveWeapon()
	return (IsValid(aw) and weapons[aw:GetClass()]) or LocalPlayer():IsSuperAdmin()
end)

local notifications = {
	"Если вы хотите стать администратором сервера, подайте заявку на форуме: minerva.pw",
	"Вам нравится наш проект? И вы хотите поддержать нас? Нажмите F6",
	"Наш форум и сайт: minerva.pw",
	"Нашли баг? Эксплойт? Сообщите об этом нашей администрации: minerva.pw",
	"Вас убили без причины? Скорей подавайте жалобу через: @ \"текст\""
}

timer.Create("rp_notify", 300, 0, function()
	chat.AddText(Color(62, 105, 131), '[MinervaRP] ', Color(255, 255, 255), notifications[math.random(1, #notifications)] )
end)