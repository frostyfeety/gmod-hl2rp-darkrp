TEAM_CITIZEN = DarkRP.createJob("Прибывший", {
    color = Color(74, 191, 72, 255),
    model = {
        "models/player/zelpa/female_01.mdl",
		"models/player/zelpa/male_01.mdl",
		"models/player/zelpa/female_02.mdl",
		"models/player/zelpa/female_02_b.mdl",
		"models/player/zelpa/female_03.mdl",
		"models/player/zelpa/male_02.mdl",
		"models/player/zelpa/female_04.mdl",
		"models/player/zelpa/male_03.mdl",
		"models/player/zelpa/female_06.mdl",
		"models/player/zelpa/female_07.mdl",
		"models/player/zelpa/male_04.mdl",
		"models/player/zelpa/male_05.mdl",
		"models/player/zelpa/male_06.mdl",
		"models/player/zelpa/male_07.mdl",
		"models/player/zelpa/male_08.mdl",
		"models/player/zelpa/male_09.mdl",
		"models/player/zelpa/male_10.mdl",
		"models/player/zelpa/male_11.mdl"
    },
    description = [[Неопознанное лицо города.]],
    weapons = {"keys"},
    command = "citizen",
    max = 0,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Гражданские",
    loyalnumber = 0,
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
        ply:SetBodygroup(1, 2) 
        ply:SetBodygroup(2, 2) 
        ply:SetBodygroup(3, 0) 
        ply:SetBodygroup(4, 0)
        ply:SetRunSpeed(ply:GetWalkSpeed())
    end,
    hobo = true,
    type = "citizens",
})

TEAM_CITIZEN1 = DarkRP.createJob("Гражданин", {
    color = Color(74, 191, 72, 255),
    model = {
		"models/player/zelpa/female_01.mdl",
		"models/player/zelpa/male_01.mdl",
		"models/player/zelpa/female_02.mdl",
		"models/player/zelpa/female_02_b.mdl",
		"models/player/zelpa/female_03.mdl",
		"models/player/zelpa/male_02.mdl",
		"models/player/zelpa/female_04.mdl",
		"models/player/zelpa/male_03.mdl",
		"models/player/zelpa/female_06.mdl",
		"models/player/zelpa/female_07.mdl",
		"models/player/zelpa/male_04.mdl",
		"models/player/zelpa/male_05.mdl",
		"models/player/zelpa/male_06.mdl",
		"models/player/zelpa/male_07.mdl",
		"models/player/zelpa/male_08.mdl",
		"models/player/zelpa/male_09.mdl",
		"models/player/zelpa/male_10.mdl",
		"models/player/zelpa/male_11.mdl"
    },
    description = [[Гражданин - основа всех работ в этом городе.]],
    weapons = {"weapon_physgun", "weapon_physcannon", "gmod_tool", "keys", "rp_cid"},
    command = "citizen1",
    max = 0,
    salary = 50,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Гражданские",
    loyalnumber = 50,
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
        ply:SetBodygroup(1, 1)
    end,
    citizen = true,
	type = "citizens",
	unlockCost = 500
})

TEAM_CITIZEN2 = DarkRP.createJob("Лоялист 1-го уровня", {
    color = Color(177, 194, 118, 255),
    model = {
		"models/player/zelpa/female_01.mdl",
		"models/player/zelpa/male_01.mdl",
		"models/player/zelpa/female_02.mdl",
		"models/player/zelpa/female_02_b.mdl",
		"models/player/zelpa/female_03.mdl",
		"models/player/zelpa/male_02.mdl",
		"models/player/zelpa/female_04.mdl",
		"models/player/zelpa/male_03.mdl",
		"models/player/zelpa/female_06.mdl",
		"models/player/zelpa/female_07.mdl",
		"models/player/zelpa/male_04.mdl",
		"models/player/zelpa/male_05.mdl",
		"models/player/zelpa/male_06.mdl",
		"models/player/zelpa/male_07.mdl",
		"models/player/zelpa/male_08.mdl",
		"models/player/zelpa/male_09.mdl",
		"models/player/zelpa/male_10.mdl",
		"models/player/zelpa/male_11.mdl"
    },
    description = [[Лоялисты - доверенные лица Альянса]],
    weapons = {"weapon_physgun", "weapon_physcannon", "gmod_tool", "keys", "rp_cid"},
    command = "loyal1",
    max = 15,
    salary = 200,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Лоялисты",
    loyalnumber = 100,
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
        ply:SetBodygroup(1, 12)
        ply:SetBodygroup(2, 6)
    end,
    citizen = true,
	type = "citizens",
	unlockCost = 3500,
    requireUnlock = TEAM_CITIZEN1
})

TEAM_CITIZEN3 = DarkRP.createJob("Лоялист 2-го уровня", {
    color = Color(177, 194, 118, 255),
    model = {
		"models/player/zelpa/female_01.mdl",
		"models/player/zelpa/male_01.mdl",
		"models/player/zelpa/female_02.mdl",
		"models/player/zelpa/female_02_b.mdl",
		"models/player/zelpa/female_03.mdl",
		"models/player/zelpa/male_02.mdl",
		"models/player/zelpa/female_04.mdl",
		"models/player/zelpa/male_03.mdl",
		"models/player/zelpa/female_06.mdl",
		"models/player/zelpa/female_07.mdl",
		"models/player/zelpa/male_04.mdl",
		"models/player/zelpa/male_05.mdl",
		"models/player/zelpa/male_06.mdl",
		"models/player/zelpa/male_07.mdl",
		"models/player/zelpa/male_08.mdl",
		"models/player/zelpa/male_09.mdl",
		"models/player/zelpa/male_10.mdl",
		"models/player/zelpa/male_11.mdl"
    },
    description = [[Лоялисты - доверенные лица Альянса]],
    weapons = {"weapon_physgun", "weapon_physcannon", "gmod_tool", "keys", "rp_cid"},
    command = "loyal2",
    max = 6,
    salary = 250,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Лоялисты",
    loyalnumber = 150,
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
        ply:SetBodygroup(1, 13)
        ply:SetBodygroup(2, 6)
    end,
    citizen = true,
	type = "citizens",
	unlockCost = 7500,
    requireUnlock = TEAM_CITIZEN2
})

TEAM_CITIZEN4 = DarkRP.createJob("Лоялист 3-го уровня", {
    color = Color(177, 194, 118, 255),
    model = {
		"models/player/zelpa/female_01.mdl",
		"models/player/zelpa/male_01.mdl",
		"models/player/zelpa/female_02.mdl",
		"models/player/zelpa/female_02_b.mdl",
		"models/player/zelpa/female_03.mdl",
		"models/player/zelpa/male_02.mdl",
		"models/player/zelpa/female_04.mdl",
		"models/player/zelpa/male_03.mdl",
		"models/player/zelpa/female_06.mdl",
		"models/player/zelpa/female_07.mdl",
		"models/player/zelpa/male_04.mdl",
		"models/player/zelpa/male_05.mdl",
		"models/player/zelpa/male_06.mdl",
		"models/player/zelpa/male_07.mdl",
		"models/player/zelpa/male_08.mdl",
		"models/player/zelpa/male_09.mdl",
		"models/player/zelpa/male_10.mdl",
		"models/player/zelpa/male_11.mdl"
    },
    description = [[Лоялисты - доверенные лица Альянса]],
    weapons = {"weapon_physgun", "weapon_physcannon", "gmod_tool", "keys", "rp_cid"},
    command = "loyal3",
    max = 2,
    salary = 300,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Лоялисты",
    loyalnumber = 150,
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
        ply:SetBodygroup(1, 14)
        ply:SetBodygroup(2, 6)
    end,
    citizen = true,
	type = "citizens",
	unlockCost = 14500,
    requireUnlock = TEAM_CITIZEN3
})

TEAM_CWU1 = DarkRP.createJob("Уборщик ГСР", {
    color = Color(70, 133, 40, 255),
    model = {
		"models/player/zelpa/female_01.mdl",
		"models/player/zelpa/male_01.mdl",
		"models/player/zelpa/female_02.mdl",
		"models/player/zelpa/female_02_b.mdl",
		"models/player/zelpa/female_03.mdl",
		"models/player/zelpa/male_02.mdl",
		"models/player/zelpa/female_04.mdl",
		"models/player/zelpa/male_03.mdl",
		"models/player/zelpa/female_06.mdl",
		"models/player/zelpa/female_07.mdl",
		"models/player/zelpa/male_04.mdl",
		"models/player/zelpa/male_05.mdl",
		"models/player/zelpa/male_06.mdl",
		"models/player/zelpa/male_07.mdl",
		"models/player/zelpa/male_08.mdl",
		"models/player/zelpa/male_09.mdl",
		"models/player/zelpa/male_10.mdl",
		"models/player/zelpa/male_11.mdl"
    },
    description = [[Уборщик улиц Сити-4, основа гражданского союза рабочих]],
    weapons = {"keys", "pocket", "weapon_physcannon", "weapon_physgun", "gmod_tool", "rp_cid"},
    command = "cwu1",
    max = 0,
    salary = 50,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "ГСР",
    cwu = true,
    type = "cwu",
    loyalnumber = 50,
    requireUnlock = TEAM_CITIZEN1,
    unlockCost = 1000,
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
        ply:SetBodygroup(1, 4)
        ply:SetBodygroup(2, 2)
        ply:SetBodygroup(3, 2)
        ply:SetBodygroup(4, 1)
    end
})

TEAM_CWU2 = DarkRP.createJob("Прачечник ГСР", {
    color = Color(70, 133, 40, 255),
    model = {
		"models/player/zelpa/female_01.mdl",
		"models/player/zelpa/male_01.mdl",
		"models/player/zelpa/female_02.mdl",
		"models/player/zelpa/female_02_b.mdl",
		"models/player/zelpa/female_03.mdl",
		"models/player/zelpa/male_02.mdl",
		"models/player/zelpa/female_04.mdl",
		"models/player/zelpa/male_03.mdl",
		"models/player/zelpa/female_06.mdl",
		"models/player/zelpa/female_07.mdl",
		"models/player/zelpa/male_04.mdl",
		"models/player/zelpa/male_05.mdl",
		"models/player/zelpa/male_06.mdl",
		"models/player/zelpa/male_07.mdl",
		"models/player/zelpa/male_08.mdl",
		"models/player/zelpa/male_09.mdl",
		"models/player/zelpa/male_10.mdl",
		"models/player/zelpa/male_11.mdl"
    },
    description = [[Прачечник Гражданского Союза Рабочих. Мойте формы граждан]],
    weapons = {"keys", "pocket", "weapon_physcannon", "weapon_physgun", "gmod_tool", "rp_cid"},
    command = "cwu2",
    max = 6,
    salary = 50,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "ГСР",
    cwu = true,
    type = "cwu",
    loyalnumber = 50,
    requireUnlock = TEAM_CWU1,
    unlockCost = 3500,
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
        ply:SetBodygroup(1, 3)
        ply:SetBodygroup(2, 6)
        ply:SetBodygroup(3, 1)
        ply:SetBodygroup(4, 0)
    end
})

TEAM_CWU5 = DarkRP.createJob("Курьер ГСР", {
    color = Color(70, 133, 40, 255),
    model = {
		"models/player/zelpa/female_01.mdl",
		"models/player/zelpa/male_01.mdl",
		"models/player/zelpa/female_02.mdl",
		"models/player/zelpa/female_02_b.mdl",
		"models/player/zelpa/female_03.mdl",
		"models/player/zelpa/male_02.mdl",
		"models/player/zelpa/female_04.mdl",
		"models/player/zelpa/male_03.mdl",
		"models/player/zelpa/female_06.mdl",
		"models/player/zelpa/female_07.mdl",
		"models/player/zelpa/male_04.mdl",
		"models/player/zelpa/male_05.mdl",
		"models/player/zelpa/male_06.mdl",
		"models/player/zelpa/male_07.mdl",
		"models/player/zelpa/male_08.mdl",
		"models/player/zelpa/male_09.mdl",
		"models/player/zelpa/male_10.mdl",
		"models/player/zelpa/male_11.mdl"
    },
    description = [[Курьер блока Гражданского Союза Рабочих]],
    weapons = {"keys", "pocket", "weapon_physcannon", "weapon_physgun", "gmod_tool", "rp_cid"},
    command = "cwu5",
    max = 4,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "ГСР",
    cwu = true,
    type = "cwu",
    loyalnumber = 50,
    requireUnlock = TEAM_CWU2,
    unlockCost = 5500,
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
        ply:SetBodygroup(1, 10)
        ply:SetBodygroup(2, 6)
        ply:SetBodygroup(3, 2)
        ply:SetBodygroup(4, 1)
        ply:SetBodygroup(5, 1)
    end
})

TEAM_CWU3 = DarkRP.createJob("Медик ГСР", {
    color = Color(70, 133, 40, 255),
    model = {
		"models/player/zelpa/female_01.mdl",
		"models/player/zelpa/male_01.mdl",
		"models/player/zelpa/female_02.mdl",
		"models/player/zelpa/female_02_b.mdl",
		"models/player/zelpa/female_03.mdl",
		"models/player/zelpa/male_02.mdl",
		"models/player/zelpa/female_04.mdl",
		"models/player/zelpa/male_03.mdl",
		"models/player/zelpa/female_06.mdl",
		"models/player/zelpa/female_07.mdl",
		"models/player/zelpa/male_04.mdl",
		"models/player/zelpa/male_05.mdl",
		"models/player/zelpa/male_06.mdl",
		"models/player/zelpa/male_07.mdl",
		"models/player/zelpa/male_08.mdl",
		"models/player/zelpa/male_09.mdl",
		"models/player/zelpa/male_10.mdl",
		"models/player/zelpa/male_11.mdl"
    },
    description = [[Врач медицинского блока Гражданского Союза Рабочих]],
    weapons = {"keys", "pocket", "weapon_physcannon", "weapon_physgun", "gmod_tool", "rp_cid", "weapon_medkit"},
    command = "cwu3",
    max = 3,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "ГСР",
    cwu = true,
    type = "cwu",
    loyalnumber = 50,
    requireUnlock = TEAM_CWU5,
    unlockCost = 7000,
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
        ply:SetBodygroup(1, 9)
        ply:SetBodygroup(2, 6)
        ply:SetBodygroup(3, 1)
        ply:SetBodygroup(4, 0)
    end
})

TEAM_CWU4 = DarkRP.createJob("Повар ГСР", {
    color = Color(70, 133, 40, 255),
    model = {
		"models/player/zelpa/female_01.mdl",
		"models/player/zelpa/male_01.mdl",
		"models/player/zelpa/female_02.mdl",
		"models/player/zelpa/female_02_b.mdl",
		"models/player/zelpa/female_03.mdl",
		"models/player/zelpa/male_02.mdl",
		"models/player/zelpa/female_04.mdl",
		"models/player/zelpa/male_03.mdl",
		"models/player/zelpa/female_06.mdl",
		"models/player/zelpa/female_07.mdl",
		"models/player/zelpa/male_04.mdl",
		"models/player/zelpa/male_05.mdl",
		"models/player/zelpa/male_06.mdl",
		"models/player/zelpa/male_07.mdl",
		"models/player/zelpa/male_08.mdl",
		"models/player/zelpa/male_09.mdl",
		"models/player/zelpa/male_10.mdl",
		"models/player/zelpa/male_11.mdl"
    },
    description = [[Повар блока Гражданского Союза Рабочих]],
    weapons = {"keys", "pocket", "weapon_physcannon", "weapon_physgun", "gmod_tool", "rp_cid"},
    command = "cwu4",
    max = 2,
    salary = 110,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "ГСР",
    cwu = true,
    type = "cwu",
    loyalnumber = 50,
    requireUnlock = TEAM_CWU3,
    unlockCost = 9000,
    cook = true,
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
        ply:SetBodygroup(1, 3)
        ply:SetBodygroup(2, 2)
        ply:SetBodygroup(4, 0)
    end
})

TEAM_CWU6 = DarkRP.createJob("Директор ГСР", {
    color = Color(70, 133, 40, 255),
    model = {
		"models/player/zelpa/female_01.mdl",
		"models/player/zelpa/male_01.mdl",
		"models/player/zelpa/female_02.mdl",
		"models/player/zelpa/female_02_b.mdl",
		"models/player/zelpa/female_03.mdl",
		"models/player/zelpa/male_02.mdl",
		"models/player/zelpa/female_04.mdl",
		"models/player/zelpa/male_03.mdl",
		"models/player/zelpa/female_06.mdl",
		"models/player/zelpa/female_07.mdl",
		"models/player/zelpa/male_04.mdl",
		"models/player/zelpa/male_05.mdl",
		"models/player/zelpa/male_06.mdl",
		"models/player/zelpa/male_07.mdl",
		"models/player/zelpa/male_08.mdl",
		"models/player/zelpa/male_09.mdl",
		"models/player/zelpa/male_10.mdl",
		"models/player/zelpa/male_11.mdl"
    },
    description = [[Директор блока Гражданского Союза Рабочих]],
    weapons = {"keys", "pocket", "weapon_physcannon", "weapon_physgun", "gmod_tool", "rp_cid"},
    command = "cwu6",
    max = 1,
    salary = 440,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "ГСР",
    cwu = true,
    type = "cwu",
    loyalnumber = 150,
    requireUnlock = TEAM_CWU4,
    unlockCost = 19000,
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
        ply:SetBodygroup(1, 11)
        ply:SetBodygroup(2, 2)
        ply:SetBodygroup(4, 0)
    end
})

TEAM_CP1 = DarkRP.createJob("C4.MPF.GU.03", {
    color = Color(98, 194, 185, 255),
    model = "models/dpfilms/metropolice/playermodels/pm_hl2concept.mdl",
    description = [[Основной отряд Гражданской Обороны, наземные силы.]],
    weapons = {"pocket", "keys", "weapon_physcannon"},
    command = "cp01",
    max = 15,
    salary = 75,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Гражданская Оборона",
    hobo = true,
    armor_can = true,
    MaxArmorCan = 20,
    MaxHealthCan = 100,
    health_can = true,
    maskid = 1,
    loyalnumber = 150,
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
        ply:SetSkin(0)
    end,
    mpf = true,
    type = "cp",
    requireUnlock = TEAM_CITIZEN1,
    unlockCost = 15000
})

TEAM_CP2 = DarkRP.createJob("C4.MPF.GU.02", {
    color = Color(98, 194, 185, 255),
    model = "models/dpfilms/metropolice/playermodels/pm_hdpolice.mdl",
    description = [[Основной отряд Гражданской Обороны, наземные силы.]],
    weapons = {"pocket", "keys", "weapon_physcannon"},
    command = "cp02",
    max = 5,
    salary = 95,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Гражданская Оборона",
    hobo = true,
    armor_can = true,
    MaxArmorCan = 45,
    MaxHealthCan = 100,
    health_can = true,
    maskid = 2,
    loyalnumber = 150,
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
        ply:SetSkin(0)
    end,
    mpf = true,
    type = "cp",
    requireUnlock = TEAM_CP1,
    unlockCost = 17500
})

TEAM_CP3 = DarkRP.createJob("C4.MPF.GU.01", {
    color = Color(98, 194, 185, 255),
    model = "models/dpfilms/metropolice/playermodels/pm_urban_police.mdl",
    description = [[Основной отряд Гражданской Обороны, наземные силы.]],
    weapons = {"pocket", "keys", "weapon_physcannon"},
    command = "cp03",
    max = 2,
    salary = 140,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Гражданская Оборона",
    hobo = true,
    armor_can = true,
    MaxArmorCan = 60,
    MaxHealthCan = 100,
    health_can = true,
    maskid = 5,
    loyalnumber = 150,
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
        ply:SetSkin(0)
    end,
    mpf = true,
    type = "cp",
    requireUnlock = TEAM_CP2,
    unlockCost = 45000
})

TEAM_CP4 = DarkRP.createJob("C4.MPF.GRID", {
    color = Color(110, 194, 185, 255),
    model = "models/dpfilms/metropolice/playermodels/pm_biopolice.mdl",
    description = [[Инженер Гражданской Обороны. Рядовой отряда GRID]],
    weapons = {"pocket", "keys", "weapon_physcannon", "gmod_tool", "weapon_physgun"},
    command = "cp1",
    max = 4,
    salary = 350,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Гражданская Оборона",
    hobo = true,
    armor_can = true,
    MaxArmorCan = 80,
    MaxHealthCan = 100,
    health_can = true,
    maskid = 2,
    grid = true,
    loyalnumber = 150,
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
        ply:SetSkin(2)
    end,
    mpf = true,
    type = "cp",
    requireUnlock = TEAM_CP3,
    unlockCost = 80000
})

TEAM_OTA1 = DarkRP.createJob("C4.OTA.ECHO.OWS", {
    color = Color(163, 123, 157, 255),
    model = "models/player/soldier_stripped.mdl",
    description = [[Рекрут Сверх-человеческого отдела патруля Альянса. Основа всех юнитов ОТА]],
    weapons = {"weapon_physcannon", "keys"},
    command = "ota1",
    max = 20,
    salary = 650,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Сверхчеловеческий Отдел",
    hobo = true,
    armor_can = true,
    MaxArmorCan = 130,
    MaxHealthCan = 180,
    health_can = true,
    loyalnumber = 150,
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
        --ply:SetSkin(1)
    end,
    ota = true,
    type = "ota",
    requireUnlock = TEAM_CP1,
    unlockCost = 250000
})

TEAM_OTA2 = DarkRP.createJob("C4.OTA.NOVA.OWS", {
    color = Color(163, 123, 157, 255),
    model = "models/player/soldier_stripped.mdl",
    description = [[Патруль тюремного блока Нексус Надзора]],
    weapons = {"keys", "weapon_physcannon"},
    command = "ota3",
    max = 3,
    salary = 800,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Сверхчеловеческий Отдел",
    hobo = true,
    armor_can = true,
    MaxArmorCan = 140,
    MaxHealthCan = 180,
    health_can = true,
    loyalnumber = 150,
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
    end,
    ota = true,
    type = "ota",
    requireUnlock = TEAM_OTA1,
    unlockCost = 500000
})

TEAM_ZOMBIE = DarkRP.createJob("Зомбированный", {
    color = Color(196, 42, 60, 255),
    model = "models/Zombie/Classic.mdl",
    description = [[Для ивентов]],
    weapons = {"weapon_weapons_zombie"},
    command = "zombie",
    max = 0,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Администрация",
    hobo = true,
    loyalnumber = 0,
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(300)
        ply:SetHealth(300)
        ply:SetArmor(0)
        ply:SetRunSpeed(100)
    end,
    zombie = true,
    type = "events"
})

TEAM_REBEL1 = DarkRP.createJob("Рядовой Повстанец", {
    color = Color(171, 149, 75, 255),
    model = {
		"models/player/zelpa/female_01.mdl",
		"models/player/zelpa/male_01.mdl",
		"models/player/zelpa/female_02.mdl",
		"models/player/zelpa/female_02_b.mdl",
		"models/player/zelpa/female_03.mdl",
		"models/player/zelpa/male_02.mdl",
		"models/player/zelpa/female_04.mdl",
		"models/player/zelpa/male_03.mdl",
		"models/player/zelpa/female_06.mdl",
		"models/player/zelpa/female_07.mdl",
		"models/player/zelpa/male_04.mdl",
		"models/player/zelpa/male_05.mdl",
		"models/player/zelpa/male_06.mdl",
		"models/player/zelpa/male_07.mdl",
		"models/player/zelpa/male_08.mdl",
		"models/player/zelpa/male_09.mdl",
		"models/player/zelpa/male_10.mdl",
		"models/player/zelpa/male_11.mdl"
    },
    description = [[Повстанец - а чо :DD]],
    weapons = {"weapon_physgun", "weapon_physcannon", "gmod_tool", "keys"},
    command = "rebel1",
    max = 0,
    salary = 25,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Повстанцы",
    loyalnumber = 0,
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(15)
        ply:SetBodygroup(2, 3)
        ply:SetBodygroup(1, 6)
        ply:SetBodygroup(3, 2)
        ply:SetBodygroup(4, 1)
    end,
    rebel = true,
	type = "rebels",
	unlockCost = 3500
})

TEAM_REBEL2 = DarkRP.createJob("Медик Повстанец", {
    color = Color(171, 149, 75, 255),
    model = {
		"models/player/zelpa/female_01.mdl",
		"models/player/zelpa/male_01.mdl",
		"models/player/zelpa/female_02.mdl",
		"models/player/zelpa/female_02_b.mdl",
		"models/player/zelpa/female_03.mdl",
		"models/player/zelpa/male_02.mdl",
		"models/player/zelpa/female_04.mdl",
		"models/player/zelpa/male_03.mdl",
		"models/player/zelpa/female_06.mdl",
		"models/player/zelpa/female_07.mdl",
		"models/player/zelpa/male_04.mdl",
		"models/player/zelpa/male_05.mdl",
		"models/player/zelpa/male_06.mdl",
		"models/player/zelpa/male_07.mdl",
		"models/player/zelpa/male_08.mdl",
		"models/player/zelpa/male_09.mdl",
		"models/player/zelpa/male_10.mdl",
		"models/player/zelpa/male_11.mdl"
    },
    description = [[Повстанец 2 - а чо :DD]],
    weapons = {"weapon_physgun", "weapon_physcannon", "gmod_tool", "keys", "med_kit"},
    command = "rebel2",
    max = 3,
    salary = 35,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Повстанцы",
    loyalnumber = 0,
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(25)
        ply:SetBodygroup(2, 3)
        ply:SetBodygroup(1, 7)
        ply:SetBodygroup(3, 2)
        ply:SetBodygroup(4, 1)
    end,
    rebel = true,
	type = "rebels",
	unlockCost = 6500
})

TEAM_REBEL3 = DarkRP.createJob("Капитан Повстанец", {
    color = Color(171, 149, 75, 255),
    model = {
		"models/player/zelpa/female_01.mdl",
		"models/player/zelpa/male_01.mdl",
		"models/player/zelpa/female_02.mdl",
		"models/player/zelpa/female_02_b.mdl",
		"models/player/zelpa/female_03.mdl",
		"models/player/zelpa/male_02.mdl",
		"models/player/zelpa/female_04.mdl",
		"models/player/zelpa/male_03.mdl",
		"models/player/zelpa/female_06.mdl",
		"models/player/zelpa/female_07.mdl",
		"models/player/zelpa/male_04.mdl",
		"models/player/zelpa/male_05.mdl",
		"models/player/zelpa/male_06.mdl",
		"models/player/zelpa/male_07.mdl",
		"models/player/zelpa/male_08.mdl",
		"models/player/zelpa/male_09.mdl",
		"models/player/zelpa/male_10.mdl",
		"models/player/zelpa/male_11.mdl"
    },
    description = [[Повстанец 3 - а чо :DD]],
    weapons = {"weapon_physgun", "weapon_physcannon", "gmod_tool", "keys"},
    command = "rebel3",
    max = 1,
    salary = 40,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Повстанцы",
    loyalnumber = 0,
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(45)
        ply:SetBodygroup(2, 3)
        ply:SetBodygroup(1, 6)
        ply:SetBodygroup(3, 2)
        ply:SetBodygroup(4, 1)
    end,
    rebel = true,
	type = "rebels",
	unlockCost = 12000
})

GAMEMODE.DefaultTeam = TEAM_CITIZEN

GAMEMODE.CivilProtection = {
    [TEAM_OTA1] = true,
    [TEAM_OTA2] = true,
    [TEAM_CP4] = true,
    [TEAM_CP3] = true,
    [TEAM_CP2] = true,
    [TEAM_CP1] = true,
}

DarkRP.addHitmanTeam(TEAM_MOB)
