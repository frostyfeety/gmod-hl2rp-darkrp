AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props/cs_militia/food_stack.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	phys:Wake()
	self:SetNWInt("rp_rations_amount", 50)
	self:SetUseType( SIMPLE_USE )
	self.LastUse = 0
	self.Delay = 2
end

function ENT:Use(activator)
	if not activator:isMPF() then return end
	if self.LastUse <= CurTime() then
		self.LastUse = CurTime() + self.Delay
		if self:GetNWInt("rp_rations_amount") > 0 and activator:getDarkRPVar("Energy") <= 50 then
			self:SetNWInt("rp_rations_amount", self:GetNWInt("rp_rations_amount") - 1)
			activator:setSelfDarkRPVar( "Energy", math.Clamp( ( activator:getDarkRPVar("Energy") or 100 ) + 100, 0, 100 ) )
			DarkRP.notify(activator, 2, 3, "Вы снова сыты!")
			activator:EmitSound("physics/cardboard/cardboard_box_break3.wav", 50, 100)
		elseif self:GetNWInt("rp_rations_amount") <= 0 then
			DarkRP.notify(activator, 1, 3, "Коробки пусты, вызовите повара!")
		else
			local reward = math.random(500,1500)
			if activator:Team() == TEAM_CWU1 then
				DarkRP.notify(activator, 2, 3, "Вы пополнили коробки, награда "..reward)
				activator:addMoney(reward)
				activator:EmitSound("physics/wood/wood_crate_impact_soft"..math.random(1,3)..".wav")
				self:SetNWInt("rp_rations_amount", 50)
			else
				DarkRP.notify(activator, 1, 3, "Ваша сытость свыше 50-ти!")
			end
		end
	end
end