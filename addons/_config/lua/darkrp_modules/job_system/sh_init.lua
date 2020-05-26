Job = {}
Job.NPC = {
OneJob = { -- Уникальный индификатор NPC, который нужно указывать в jobs.lua
	name = "OneJob", -- Название NPC
	model = {"models/gman_high.mdl"}, -- Моделька NPC
	pos = { -- Код позиции (Open)
		[1] = { -- Координаты NPC(Open) ||| [1] [2] [3] [4] и т.п.
			pos = Vector(820.29663085938,-757.98315429688,-143.96875), -- Координаты NPC (JonbNPCSpawnPos)
			angle = Angle(0,131.55439758301,0), -- Позиция головы (JonbNPCSpawnPos)
		} -- Координаты NPC (Close)

	
	}, -- Код позиции (Close)
	limit = 1 -- Лимит. Работает по процентам. 1 - это 100% онлайна сервера. Как указать 50%? Ответ прост: "0.5". Значит пишем - limit = 0.5
}, -- Данная скобка закрывает код NPC(То есть, ее удалять не нужно)
}

function Job:Get(name)
	return Job.NPC[name]
end