-- Misc. player stuff.
local entityMeta = FindMetaTable("Entity")
local playerMeta = FindMetaTable("Player")

nut.net = nut.net or {}
nut.net.globals = nut.net.globals or {}

local function checkBadType(name, object)
	local objectType = type(object)
	
	if (objectType == "function") then
		ErrorNoHalt("Net var '"..name.."' contains a bad object type!")
		
		return true
	elseif (objectType == "table") then
		for k, v in pairs(object) do
			-- Check both the key and the value for tables, and has recursion.
			if (checkBadType(name, k) or checkBadType(name, v)) then
				return true
			end
		end
	end
end

function setNetVar(key, value, receiver)
	if (checkBadType(key, value)) then return end
	if (getNetVar(key) == value) then return end

	nut.net.globals[key] = value
	netstream.Start(receiver, "gVar", key, value)
end

function entityMeta:sendNetVar(key, receiver)
	netstream.Start(receiver, "nVar", self:EntIndex(), key, nut.net[self] and nut.net[self][key])
end

function entityMeta:clearNetVars(receiver)
	nut.net[self] = nil
	netstream.Start(receiver, "nDel", self:EntIndex())
end

function entityMeta:setNetVar(key, value, receiver)
	if (checkBadType(key, value)) then return end
		
	nut.net[self] = nut.net[self] or {}

	if (nut.net[self][key] != value) then
		nut.net[self][key] = value
	end

	self:sendNetVar(key, receiver)
end

function entityMeta:getNetVar(key, default)
	if (nut.net[self] and nut.net[self][key] != nil) then
		return nut.net[self][key]
	end

	return default
end

function playerMeta:setLocalVar(key, value)
	if (checkBadType(key, value)) then return end
	
	nut.net[self] = nut.net[self] or {}
	nut.net[self][key] = value

	netstream.Start(self, "nLcl", key, value)
end

playerMeta.getLocalVar = entityMeta.getNetVar

function getNetVar(key, default)
	local value = nut.net.globals[key]

	return value != nil and value or default
end

do
	if (SERVER) then
		-- Performs a delayed action on a player.
		function playerMeta:setAction(text, time, callback, startTime, finishTime)
			if (time and time <= 0) then
				if (callback) then
					callback(self)
				end
				
				return
			end

			-- Default the time to five seconds.
			time = time or 5
			startTime = startTime or CurTime()
			finishTime = finishTime or (startTime + time)

			if (text == false) then
				timer.Remove("nutAct"..self:UniqueID())
				netstream.Start(self, "actBar")

				return
			end

			-- Tell the player to draw a bar for the action.
			netstream.Start(self, "actBar", startTime, finishTime, text)

			-- If we have provided a callback, run it delayed.
			if (callback) then
				-- Create a timer that runs once with a delay.
				timer.Create("nutAct"..self:UniqueID(), time, 1, function()
					-- Call the callback if the player is still valid.
					if (IsValid(self)) then
						callback(self)
					end
				end)
			end
		end
	end
	-- Player ragdoll utility stuff.
	do
		function nut.util.findEmptySpace(entity, filter, spacing, size, height, tolerance)
			spacing = spacing or 32
			size = size or 3
			height = height or 36
			tolerance = tolerance or 5

			local position = entity:GetPos()
			local angles = Angle(0, 0, 0)
			local mins, maxs = Vector(-spacing * 0.5, -spacing * 0.5, 0), Vector(spacing * 0.5, spacing * 0.5, height)
			local output = {}

			for x = -size, size do
				for y = -size, size do
					local origin = position + Vector(x * spacing, y * spacing, 0)
					local color = green
					local i = 0

					local data = {}
						data.start = origin + mins + Vector(0, 0, tolerance)
						data.endpos = origin + maxs
						data.filter = filter or entity
					local trace = util.TraceLine(data)

					data.start = origin + Vector(-maxs.x, -maxs.y, tolerance)
					data.endpos = origin + Vector(mins.x, mins.y, height)

					local trace2 = util.TraceLine(data)

					if (trace.StartSolid or trace.Hit or trace2.StartSolid or trace2.Hit or !util.IsInWorld(origin)) then
						continue
					end

					output[#output + 1] = origin
				end
			end

			table.sort(output, function(a, b)
				return a:Distance(position) < b:Distance(position)
			end)

			return output
		end

		function playerMeta:isStuck()
			return util.TraceEntity({
				start = self:GetPos(),
				endpos = self:GetPos(),
				filter = self
			}, self).StartSolid
		end

		function playerMeta:setRagdolled(state, time, getUpGrace)
			getUpGrace = getUpGrace or time or 5

			if (state) then
				if (IsValid(self.nutRagdoll)) then
					self.nutRagdoll:Remove()
				end

				local entity = ents.Create("prop_ragdoll")
				entity:SetPos(self:GetPos())
				entity:SetAngles(self:EyeAngles())
				entity:SetModel(self:GetModel())
				entity:SetSkin(self:GetSkin())
				entity:Spawn()
				entity:setNetVar("player", self)
				entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
				entity:Activate()
				_G['stunned_ply_fix'] = true
				entity:CallOnRemove("fixer", function()
					if (IsValid(self)) then
						self:setLocalVar("blur", nil)
						self:setLocalVar("ragdoll", nil)

						if (!entity.nutNoReset) then
							self:SetPos(entity:GetPos())
						end

						self:SetNoDraw(false)
						self:SetNotSolid(false)
						self:Freeze(false)
						self:SetMoveType(MOVETYPE_WALK)
						self:SetLocalVelocity(IsValid(entity) and entity.nutLastVelocity or vector_origin)
					end

					if (IsValid(self) and !entity.nutIgnoreDelete) then
						if (entity.nutWeapons) then
							for k, v in ipairs(entity.nutWeapons) do
								self:Give(v)
							end
						end

						if (self:isStuck()) then
							entity:DropToFloor()
							self:SetPos(entity:GetPos() + Vector(0, 0, 16))

							local positions = nut.util.findEmptySpace(self, {entity, self})

							for k, v in ipairs(positions) do
								self:SetPos(v)

								if (!self:isStuck()) then
									return
								end
							end
						end
					end
				end)

				local velocity = self:GetVelocity()

				for i = 0, entity:GetPhysicsObjectCount() - 1 do
					local physObj = entity:GetPhysicsObjectNum(i)

					if (IsValid(physObj)) then
						physObj:SetVelocity(velocity)

						local index = entity:TranslatePhysBoneToBone(i)

						if (index) then
							local position, angles = self:GetBonePosition(index)

							physObj:SetPos(position)
							physObj:SetAngles(angles)
						end
					end
				end

				self:setLocalVar("blur", 25)
				self.nutRagdoll = entity

				entity.nutWeapons = {}
				entity.nutPlayer = self

				if (getUpGrace) then
					entity.nutGrace = CurTime() + getUpGrace
				end

				if (time and time > 0) then
					entity.nutStart = CurTime()
					entity.nutFinish = entity.nutStart + time
					_G['stunned_ply_fix'] = false
					self:setAction("@wakingUp", nil, nil, entity.nutStart, entity.nutFinish)
				end

				for k, v in ipairs(self:GetWeapons()) do
					entity.nutWeapons[#entity.nutWeapons + 1] = v:GetClass()
				end

				self:GodDisable()
				self:StripWeapons()
				self:Freeze(true)
				self:SetNoDraw(true)
				self:SetNotSolid(true)

				if (time) then
					local time2 = time
					local uniqueID = "nutUnRagdoll"..self:SteamID()

					timer.Create(uniqueID, 0.33, 0, function()
						if (IsValid(entity) and IsValid(self)) then
							local velocity = entity:GetVelocity()
							entity.nutLastVelocity = velocity
							
							self:SetPos(entity:GetPos())

							if (velocity:Length2D() >= 8) then
								if (!entity.nutPausing) then
									self:setAction()
									entity.nutPausing = true
								end

								return
							elseif (entity.nutPausing) then
								self:setAction("@wakingUp", time)
								entity.nutPausing = false
							end

							time = time - 0.33

							if (time <= 0) then
								entity:Remove()
							end
						else
							timer.Remove(uniqueID)
						end
					end)
				end

				self:setLocalVar("ragdoll", entity:EntIndex())
				hook.Run("OnCharFallover", self, entity, true)
			elseif (IsValid(self.nutRagdoll)) then
				self.nutRagdoll:Remove()

				hook.Run("OnCharFallover", self, entity, false)
			end
		end
	end
end