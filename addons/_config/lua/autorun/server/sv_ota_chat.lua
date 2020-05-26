local sounds = {}
sounds["Выполнять"] = {"npc/combine_soldier/vo/administer.wav"}
sounds["Есть"] = {"npc/combine_soldier/vo/affirmative.wav"}
sounds["Есть попадание"] = {"npc/combine_soldier/vo/affirmativewegothimnow.wav"}
sounds["Тревога"] = {"npc/combine_soldier/vo/alert1.wav"}
sounds["Нарушитель Один"] = {"npc/combine_soldier/vo/anticitizenone.wav"}
sounds["Дезинфекция"] = {"npc/combine_soldier/vo/antiseptic.wav"}
sounds["Аспект"] = {"npc/combine_soldier/vo/apex.wav"}
sounds["Азимут"] = {"npc/combine_soldier/vo/bearing.wav"}
sounds["Нож"] = {"npc/combine_soldier/vo/blade.wav"}
sounds["Блок 31 магнат"] = {"npc/combine_soldier/vo/block31mace.wav"}
sounds["Блок 64 йота"] = {"npc/combine_soldier/vo/block64jet.wav"}
sounds["Защита держим"] = {"npc/combine_soldier/vo/bodypackholding.wav"}
sounds["Ложись"] = {"npc/combine_soldier/vo/bouncerbouncer.wav"}
sounds["Вижу паразита"] = {"npc/combine_soldier/vo/callcontactparasitics.wav"}
sounds["Возможно цель №1"] = {"npc/combine_soldier/vo/callcontacttarget1.wav"}
sounds["Горячая точка"] = {"npc/combine_soldier/vo/callhotpoint.wav"}
sounds["Чисто"] = {"npc/combine_soldier/vo/cleaned.wav"}
sounds["Приближаюсь"] = {"npc/combine_soldier/vo/closing.wav"}
sounds["В секторе опасная форма жизни"] = {"npc/combine_soldier/vo/confirmsectornotsterile.wav"}
sounds["Контакт"] = {"npc/combine_soldier/vo/contact.wav"}
sounds["Есть контакт"] = {"npc/combine_soldier/vo/contactconfim.wav"}
sounds["Есть контакт преследую"] = {"npc/combine_soldier/vo/contactconfirmprosecuting.wav"}
sounds["Убит"] = {"npc/combine_soldier/vo/contained.wav"}
sounds["Продолжаю задержание"] = {"npc/combine_soldier/vo/containmentproceeding.wav"}
sounds["Понял"] = {"npc/combine_soldier/vo/copy.wav"}
sounds["Вас понял"] = {"npc/combine_soldier/vo/copythat.wav"}
sounds["Прикрой"] = {"npc/combine_soldier/vo/cover.wav"}

hook.Add("PostPlayerSay", "rp_ota_chat_sounds", function(player, txt)
	if IsValid(player) && player:isOTA() && player:GetModel() ~= "models/player/soldier_stripped.mdl" then
		if player.SDelay and player.SDelay > CurTime() then return end
		local sound = sounds[txt]
		if not sound then return end
		player:EmitSound(sound[math.random(#sound)], 80, 85)
		player.SDelay = CurTime() + 3
	end
end)