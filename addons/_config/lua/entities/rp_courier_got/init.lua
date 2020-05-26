AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/Humans/Group01/Male_04.mdl")
	self:PhysicsInit(SOLID_NONE)
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
		if activator:HasWeapon("rp_box") then
			local mani = math.random(300,1000)
			activator:StripWeapon("rp_box")
			activator:addMoney(mani)
			activator:SetRunSpeed(235)
			timer.Remove("rp_courier_time")
			self:EmitSound("vo/npc/male01/question07.wav", 70, 100)
    		DarkRP.notify(activator, 2, 3, "Вы получили "..mani.." токенов за посылку!")
		end
	end
end