AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_wasteland/laundry_dryer002.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	phys:Wake()
end

function ENT:Use(activator)
end


function ENT:StartTouch( hitEnt )
	local moneyForWork = math.floor(math.random(1450,2200))
	local WorkTime = 45

	if hitEnt:GetClass() == "rp_clothold" && self:GetNWInt("PrachkaIsWorking") == 0 then
		local TimerSoundC = "buttons/blip2.wav"
			
		hitEnt:Remove()
			
		self:SetNWInt("PrachkaIsWorking", 1)
			
		self:EmitSound("items/medshot4.wav")
		self:EmitSound("plats/tram_hit1.wav")
		self:SetNWInt('timer', CurTime() + WorkTime)
			
		timer.Simple(0.2, function()
			self:EmitSound("plats/tram_motor_start.wav")
		
		end)

		timer.Simple(0.4, function()
			self:EmitSound(TimerSoundC)
			self.sound = CreateSound(self, Sound("ambient/machines/laundry_machine1_amb.wav"))
			self.sound:SetSoundLevel(70)
			self.sound:PlayEx(1, 100)
		end)

		timer.Simple(WorkTime - 1.9, function()
			self:EmitSound("ambient/machines/spindown.wav")
		end)

		timer.Simple(WorkTime, function()
			self:SetNWInt("PrachkaIsWorking", 0)
			if self.sound then
				self.sound:Stop()
			end
			local entity = ents.Create("rp_clothnew")
			entity:SetPos(Vector(self:GetPos().x - 50, self:GetPos().y + 1, self:GetPos().z - 10))
			entity:Spawn()
		end)
	end
end