AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/Humans/Group01/male_08.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_BBOX)
	self:SetHullSizeNormal()
	self:CapabilitiesAdd(bit.bor(CAP_ANIMATEDFACE, CAP_TURN_HEAD))
	self:SetUseType(SIMPLE_USE)
	self:DropToFloor()
	self:SetMaxYawSpeed(90)
end

function ENT:Use(activator)
	if activator:Team() == TEAM_CWU5 then 
		if not activator:HasWeapon("rp_box") then
			if (activator.CourierCD or 0) > CurTime() then
				DarkRP.notify(activator, 2, 3, "Не время!")
			else
				activator:Give("rp_box")
				activator:SelectWeapon("rp_box")
				activator:SetRunSpeed(90)
				self:EmitSound("vo/npc/male01/overthere02.wav", 70, 100)
				DarkRP.notify(activator, 2, 3, "У тебя есть три минуты!")
				timer.Create("rp_courier_time", 180, 1, function()
					activator:StripWeapon("rp_box")
					activator:SetRunSpeed(235)
					DarkRP.notify(activator, 2, 3, "Ты не смог доставить посылку!")
				end)
				activator.CourierCD= CurTime() + 185
			end
		end
	end
end