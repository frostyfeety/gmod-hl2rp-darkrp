local meta = FindMetaTable("Player")
function meta:changeTeam(t, force)
	local prevTeam = self:Team()

	if self:isArrested() and not force then
		DarkRP.notify(self, 1, 4, DarkRP.getPhrase("unable", team.GetName(t), ""))
		return false
	end

	if t ~= GAMEMODE.DefaultTeam and not self:changeAllowed(t) and not force then
		DarkRP.notify(self, 1, 4, DarkRP.getPhrase("unable", team.GetName(t), "banned/demoted"))
		return false
	end

	if self.LastJob and GAMEMODE.Config.changejobtime - (CurTime() - self.LastJob) >= 0 and not force then
		DarkRP.notify(self, 1, 4, DarkRP.getPhrase("have_to_wait",  math.ceil(GAMEMODE.Config.changejobtime - (CurTime() - self.LastJob)), "/job"))
		return false
	end

	if self.IsBeingDemoted then
		self:teamBan()
		self.IsBeingDemoted = false
		self:changeTeam(GAMEMODE.DefaultTeam, true)
		DarkRP.destroyVotesWithEnt(self)
		DarkRP.notify(self, 1, 4, DarkRP.getPhrase("tried_to_avoid_demotion"))

		return false
	end


	if prevTeam == t then
		DarkRP.notify(self, 1, 4, DarkRP.getPhrase("unable", team.GetName(t), ""))
		return false
	end

	local TEAM = RPExtraTeams[t]
	if not TEAM then return false end

	if !force then
		if TEAM.type && !self:NearJobNPC(TEAM.type) then self:MultiversionNotify(NOTIFY_ERROR, "Найдите работодателя.") return false end
		if (TEAM.unlockCost && !table.HasValue(self.unlocks, TEAM.command)) then 
				return false
		end

		if TEAM.type && !(RPExtraTeams[prevTeam].type && RPExtraTeams[prevTeam].type == TEAM.type) then
			local max = 0
			for k, v in pairs(player.GetAll()) do
				if TEAM.type == RPExtraTeams[v:Team()].type then
					max = max + 1
				end
			end
			if #player.GetAll() > 10 && max/#player.GetAll() > Job.NPC[TEAM.type].limit then self:MultiversionNotify(NOTIFY_ERROR, string.format(LANGUAGE.team_limit_reached, TEAM.name)) return false end
		end
	end

	if TEAM.customCheck and not TEAM.customCheck(self) and (not force or force and not GAMEMODE.Config.adminBypassJobRestrictions) then
		local message = isfunction(TEAM.CustomCheckFailMsg) and TEAM.CustomCheckFailMsg(self, TEAM) or
			TEAM.CustomCheckFailMsg or
			DarkRP.getPhrase("unable", team.GetName(t), "")
		DarkRP.notify(self, 1, 4, message)
		return false
	end

	if not force then
		if type(TEAM.NeedToChangeFrom) == "number" and prevTeam ~= TEAM.NeedToChangeFrom then
			DarkRP.notify(self, 1,4, DarkRP.getPhrase("need_to_be_before", team.GetName(TEAM.NeedToChangeFrom), TEAM.name))
			return false
		elseif type(TEAM.NeedToChangeFrom) == "table" and not table.HasValue(TEAM.NeedToChangeFrom, prevTeam) then
			local teamnames = ""
			for a,b in pairs(TEAM.NeedToChangeFrom) do teamnames = teamnames.." or "..team.GetName(b) end
			DarkRP.notify(self, 1,4, string.format(string.sub(teamnames, 5), team.GetName(TEAM.NeedToChangeFrom), TEAM.name))
			return false
		end
		local max = TEAM.max
		if max ~= 0 and -- No limit
		(max >= 1 and team.NumPlayers(t) >= max or -- absolute maximum
		max < 1 and (team.NumPlayers(t) + 1) / #player.GetAll() > max) then -- fractional limit (in percentages)
			DarkRP.notify(self, 1, 4,  DarkRP.getPhrase("team_limit_reached", TEAM.name))
			return false
		end
	end

	if TEAM.PlayerChangeTeam then
		local val = TEAM.PlayerChangeTeam(self, prevTeam, t)
		if val ~= nil then
			return val
		end
	end

	local hookValue = hook.Call("playerCanChangeTeam", nil, self, t, force)
	if hookValue == false then return false end

	local isMayor = RPExtraTeams[prevTeam] and RPExtraTeams[prevTeam].mayor
	if isMayor and GetGlobalBool("DarkRP_LockDown") then
		DarkRP.unLockdown(self)
	end
	self:updateJob(TEAM.name)
	self:setSelfDarkRPVar("salary", TEAM.salary)


	if self:getDarkRPVar("HasGunlicense") and GAMEMODE.Config.revokeLicenseOnJobChange then
		self:setDarkRPVar("HasGunlicense", nil)
	end
	if TEAM.hasLicense then
		self:setDarkRPVar("HasGunlicense", true)
	end

	self.LastJob = CurTime()

	if GAMEMODE.Config.removeclassitems then
		for k, v in pairs(DarkRPEntities) do
			if GAMEMODE.Config.preventClassItemRemoval[v.ent] then continue end
			if not v.allowed then continue end
			if type(v.allowed) == "table" and (table.HasValue(v.allowed, t) or not table.HasValue(v.allowed, prevTeam)) then continue end
			for _, e in pairs(ents.FindByClass(v.ent)) do
				if e.SID == self.SID then e:Remove() end
			end
		end

		if not GAMEMODE.Config.preventClassItemRemoval["spawned_shipment"] then
			for k,v in pairs(ents.FindByClass("spawned_shipment")) do
				if v.allowed and type(v.allowed) == "table" and table.HasValue(v.allowed, t) then continue end
				if v.SID == self.SID then v:Remove() end
			end
		end
	end

	if isMayor then
		for _, ent in pairs(self.lawboards or {}) do
			if IsValid(ent) then
				ent:Remove()
			end
		end
	end

	if isMayor and GAMEMODE.Config.shouldResetLaws then
		DarkRP.resetLaws()
	end

	self:SetTeam(t)
	hook.Call("OnPlayerChangedTeam", GAMEMODE, self, prevTeam, t)
	DarkRP.log(self:Nick().." ("..self:SteamID()..") changed to "..team.GetName(t), nil, Color(100, 0, 255))
	if self:InVehicle() then self:ExitVehicle() end
	if GAMEMODE.Config.norespawn and self:Alive() then
		self:StripWeapons()
		local vPoint = self:GetShootPos() + Vector(0,0,50)
		local effectdata = EffectData()
		effectdata:SetEntity(self)
		effectdata:SetStart( vPoint ) -- Not sure if we need a start and origin (endpoint) for this effect, but whatever
		effectdata:SetOrigin( vPoint )
		effectdata:SetScale(1)
		util.Effect("entity_remove", effectdata)
		hook.Call("UpdatePlayerSpeed", GAMEMODE, self)
		gamemode.Call("PlayerSetModel", self)
		gamemode.Call("PlayerLoadout", self)
	else
		self:KillSilent()
	end

	umsg.Start("OnChangedTeam", self)
		umsg.Short(prevTeam)
		umsg.Short(t)
	umsg.End()
	return true
end

util.AddNetworkString("Job.UnlocksUpdate")
util.AddNetworkString("Job.OpenMenu")

local playerMeta = FindMetaTable("Player")
function playerMeta:MultiversionCanAfford(amount)
	if self.CanAfford then
		return self:CanAfford(amount)
	else
		return self:canAfford(amount)
	end
end

function playerMeta:MultiversionAddMoney(amount)
	if self.AddMoney then
		return self:AddMoney(amount)
	else
		return self:addMoney(amount)
	end
end

function playerMeta:MultiversionNotify(type, text)
	if DarkRP && DarkRP.notify then
		DarkRP.notify(self, type, 4, text)
	else
		GAMEMODE:Notify(self, type, 4, text)
	end
end

local function MultivesrionQuery(q, f)
	if MySQLite then
		MySQLite.query(q, f)
	else
		DB.Query(q, f)
	end
end

hook.Add("DarkRPDBInitialized", "Job.CreateTable", function()
	MultivesrionQuery("CREATE TABLE IF NOT EXISTS darkrp_unlocks(steamid VARCHAR(25) NOT NULL PRIMARY KEY, unlocks TEXT)")
end)

concommand.Add("JonbNPCInit", function(ply, cmd, args)
	if !(ply:IsSuperAdmin()) then LocalPlayer():PrintMessage(HUD_PRINTCONSOLE, "Only admin allowed to do this.") return end
	MultivesrionQuery("CREATE TABLE IF NOT EXISTS darkrp_unlocks(steamid VARCHAR(25) NOT NULL PRIMARY KEY, unlocks TEXT)")
end)

hook.Add("PlayerInitialSpawn", "Job.UnlocksLoad", function(ply)
	MultivesrionQuery("SELECT unlocks FROM darkrp_unlocks WHERE steamid = "..sql.SQLStr(ply:SteamID()).." LIMIT 1;", function(data)
		if data then
			data = data[1]

			ply.unlocks = {}
			for v in string.gmatch(data.unlocks, "%S+") do
				table.insert(ply.unlocks, v)
			end

		else
			MultivesrionQuery("INSERT INTO darkrp_unlocks VALUES("..sql.SQLStr(ply:SteamID())..", \"\")")
			ply.unlocks = {}
		end
		ply:UpdateUnlocksInfo()
	end)
end)

concommand.Add("Job.Unlock", function(ply, cmd, args)
	if !(args && args[1]) then return end

	for k, v in pairs(RPExtraTeams) do
		if v.command == args[1] then

			if table.HasValue(ply.unlocks, v.command) then return end

			if !ply:MultiversionCanAfford(v.unlockCost) then ply:MultiversionNotify(NOTIFY_ERROR, "Not enough money!") return end

			if v.requireUnlock && !table.HasValue(ply.unlocks,/*ǝsnoɯɐɟ*/ RPExtraTeams[v.requireUnlock].command) then return end
			ply:MultiversionAddMoney(-v.unlockCost)
			ply:UnlockJob(args[1])

			ply:MultiversionNotify(NOTIFY_GENERIC, v.name.." unlocked!")
			break
		end
	end
end)

local playerMeta = FindMetaTable("Player")

function playerMeta:UpdateUnlocksInfo()
	net.Start("Job.UnlocksUpdate")
		net.WriteTable(self.unlocks)
	net.Send(self)
end

function playerMeta:UnlockJob(name)
	table.insert(self.unlocks, name)
	MultivesrionQuery("UPDATE darkrp_unlocks SET unlocks = "..sql.SQLStr(table.concat(self.unlocks, " ")).." WHERE steamid = "..sql.SQLStr(self:SteamID())..";")

	self:UpdateUnlocksInfo()
end

function playerMeta:NearJobNPC(type)
	for k, v in pairs(ents.FindInSphere(self:GetPos(), 128)) do
		if v.JobNPC && v:GetJobName() == type then
			return true
		end
	end
	return false
end

hook.Add("InitPostEntity", "Job.SpawnNPC", function()
	timer.Simple(1, function()
		for type, val in pairs(Job.NPC) do
			for _, v in pairs(val.pos) do
				local npc = ents.Create("job_npc")
				npc:Spawn()
				npc:SetPos(v.pos)
				npc:SetAngles(v.angle)
				npc:SetJobName(type)
				npc:SetModel(table.Random(val.model))
			end
		end
	end)
end)
