LOUNGE_F4.Commands = {
	{
		name = "General",
		commands = {
			{
				name = "Выбросить токены",
				cmd = function()
					L_StringRequest("Выбросить токены", "Сколько токенов вы хотите выбросить?", function(text)
						RunConsoleCommand("say", "/dropmoney " .. text)
					end)
				end,
			},
			{
				name = "Сменить имя",
				cmd = function()
					L_StringRequest("Сменить имя", "Укажите какое имя вы себе хотите.", function(text)
						RunConsoleCommand("say", "/rpname " .. text)
					end)
				end,
			},
			{
				name = "Выбросить текущее оружие",
				cmd = function()
					RunConsoleCommand("say", "/drop")
				end,
			},
			{
				name = "Продать все двери",
				cmd = function()
					RunConsoleCommand("say", "/unownalldoors")
				end,
			},
			{
				name = "Подать объявление",
				cmd = function()
					L_StringRequest("Подать объявление", "Внесите для вас нужный текст ниже", function(text)
						RunConsoleCommand("say", "/ad " .. text)
					end)
				end,
			},
		},
	},
}
