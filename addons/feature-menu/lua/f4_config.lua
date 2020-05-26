LOUNGE_F4.Title = "Меню"

-- Pages to display on the F4 menu.
LOUNGE_F4.Pages = {
	{
		id = "dashboard", -- Used internally
		bg = Color(30,30,30), -- The background of the page. The default is 52, 73, 94
		text = "Главное", -- The text to display on the left (links to the language table)
		icon = Material("icon16/application.png", "noclamp smooth"), -- The icon of the button
		enable = true, -- Whether this page should be listed or not
	},
	{
		id = "commands",
		bg = Color(30,30,30),
		text = "Команды",
		icon = Material("icon16/attach.png", "noclamp smooth"),
		enable = true,
	},
	{
		id = "purchase",
		bg = Color(30,30,30),
		text = "Предметы",
		icon = Material("icon16/basket_put.png", "noclamp smooth"),
		enable = true,
	},

	// Bottom buttons
	{id = "website", text = "Сайт", icon = Material("icon16/flag_red.png", "noclamp smooth"),
		callback = function()
			gui.OpenURL("https://www.minerva.pw/")
			return false
		end,
		display = function()
			return LOUNGE_F4.Website and LOUNGE_F4.Website ~= ""
		end,
		enable = true,
		bottom = true,
	},
	{id = "steamgroup", text = "Steam", icon = Material("icon16/bell.png", "noclamp smooth"),
		callback = function()
			gui.OpenURL("https://steamcommunity.com/groups/metarex_group")
			return false
		end,
		display = function()
			return LOUNGE_F4.SteamGroup and LOUNGE_F4.SteamGroup ~= ""
		end,
		enable = true,
		bottom = true,
	},
	{id = "discord", text = "Discord", icon = Material("icon16/cup.png", "noclamp smooth"),
		callback = function()
			gui.OpenURL("https://discord.gg/Nnt9rxy")
			return false
		end,
		display = function()
			return LOUNGE_F4.SteamGroup and LOUNGE_F4.SteamGroup ~= ""
		end,
		enable = true,
		bottom = true,
	},
}

-- (Advanced) Icon to display for custom pages added via the F4MenuTabs hook.
LOUNGE_F4.CustomTabNameIcon = {
	// Any custom tab called "Gangs" will have the user icon.
	["Gangs"] = Material("icon16/flag_yellow.png", "noclamp smooth"),
}

-- Website to open when clicking on the "Website" button
-- Leave empty to hide the website button.
LOUNGE_F4.Website = "http://google.com/"

-- Website to open when clicking on the "Donate" button
-- Leave empty to hide the donate button.
LOUNGE_F4.Donate = "http://google.com/"

-- Website to open when clicking on the "Steam Group" button
-- Leave empty to hide the steam group button.
LOUNGE_F4.SteamGroup = "http://steamcommunity.com/"

-- Usergroups which are part of your server's staff.
-- Used to count the number of online staff members in the Dashboard.
LOUNGE_F4.StaffUsergroups = {
	admin = true,
	superadmin = true,
	founder = true,
}

-- Display the "Food" tab (if possible) in the Purchase page.
LOUNGE_F4.EnableFoodTab = true

-- What method to use to retrieve the user group.
-- Leave to 0 if you use ULX or no special admin mode listed below
-- Set to 1 if you use ServerGuard
LOUNGE_F4.UsergroupMode = 1

-- If for some reason you don't use money on your server, set this to true to hide money displays in tabs
LOUNGE_F4.NoMoneyLabels = false

-- Set this to true to not hide JOBS with failed customChecks.
LOUNGE_F4.KeepFailedCustomCheckJobs = false

-- Set this to true to not hide ENTITIES with failed customChecks.
LOUNGE_F4.KeepFailedCustomCheckEnts = false

-- Order to use when sorting jobs.
-- 0: Do not sort jobs; display them in the order they're created.
-- 1: Sort them by NAME from A to Z.
-- 2: Sort them by NAME from Z to A.
-- 3: Sort them by SALARY from the highest to lowest.
-- 4: Sort them by SALARY from the lowest to highest.
LOUNGE_F4.JobsSortingOrder = 1

-- Order to use when sorting purchase items.
-- 0: Do not sort items; display them in the order they're created.
-- 1: Sort them by NAME from A to Z.
-- 2: Sort them by NAME from Z to A.
-- 3: Sort them by PRICE from the highest to lowest.
-- 4: Sort them by PRICE from the lowest to highest.
LOUNGE_F4.ItemsSortingOrder = 0

-- Job graph in Dashboard: Display the jobs by category rather than by each job
-- This will not work on older versions of DarkRP that do not support categories!
-- Note: You will also not be able to click on the bars to quickly switch jobs.
LOUNGE_F4.JobGraphCategories = false

-- Purchase tab: display entities by their category. Only available on recent DarkRP versions.
LOUNGE_F4.PurchaseByCategories = false

-- vrondakis Leveling-System: Hide JOBS with a level too high for the player.
LOUNGE_F4.HideHighLevelJobs = true

-- vrondakis Leveling-System: Hide ENTITIES with a level too high for the player.
LOUNGE_F4.HideHighLevelEnts = true

/**
* Style configuration
**/

-- Font to use for normal text throughout the F4 menu.
LOUNGE_F4.Font = "Circular Std Medium"

-- Font to use for bold text throughout the F4 menu.
LOUNGE_F4.FontBold = "Circular Std Bold"

-- Color sheet. Only modify if you know what you're doing
LOUNGE_F4.Style = {
	header = Color(45,45,45, 200),
	bg = Color(30,30,30, 200), -- Remember to change the color of the page backgrounds too!
	inbg = Color(45,45,45, 200),

	close_hover = Color(231, 76, 60),
	hover = Color(255, 255, 255, 10),
	hover2 = Color(255, 255, 255, 5),

	text = Color(255, 255, 255),
	text_down = Color(0, 0, 0),
	textentry = Color(236, 240, 241),

	menu = Color(127, 140, 141, 200),
}

-- Set this to true to alter the looks of jobs with failed customChecks.
-- Setting it to true will disable the normal looks of the job button.
LOUNGE_F4.DoPaintJobFailedCheck = false

-- Advanced: custom paint function for jobs with failed customChecks.
-- Only modify if you know what you're doing.
LOUNGE_F4.PaintJobFailedCheck = function(me, w, h)
	local b = LOUNGE_F4.DoPaintJobFailedCheck
	if (b) then
		draw.RoundedBox(0, 0, 0, w, h, LOUNGE_F4.Style.close_hover) -- Sets the background of the job to red if the customCheck is failed.
	end

	return b
end

/**
* Language configuration
**/

-- "Clean" Usergroup names to display on the dashboard.
-- Usergroups not in this table will be displayed directly, which may not look good.
LOUNGE_F4.CleanUsergroups = {
	user = "User",
	respected = "Respected",
	donator = "Donator",
	vip = "VIP",
	admin = "Administrator",
	founder = "Super Administrator",
}

-- Various strings used throughout the F4 Menu. Change them to your language here.
-- %s and %d are special strings replaced with relevant info, keep them in the string!

// FRENCH Translation: https://pastebin.com/6jYRtxYW

LOUNGE_F4.Language = {
	dashboard = "Dashboard",
	jobs = "Jobs",
	commands = "Commands",
	purchase = "Purchase",
	website = "Website",
	donate = "Donate",
	steamgroup = "Steam Group",

	players = "Онлайн",
	staff_online = "Администраторы",
	job_graph = "График работ",
	server_economy = "Экономика сервера",
	money_in_circulation = "Всего токенов",
	richest_player_online = "Самый богатый игрок",
	model_selection = "Model Selection",
	entities = "Энтити",
	shipments = "Коробки",
	vehicles = "Машины",
	ammo = "Ammo",
	food = "Еда",
	level_x = "Уровень %d",

	toggle = "Развернуть",
	click_to_become_x = "Click to become %s",
	salary = "Зарплата",
	weapons = "Снаряжение",
	vote_to_become_x = "Vote to become %s",
	become_x = "Become %s",
	free = "Бесплатно",
	search = "Поиск",
}
