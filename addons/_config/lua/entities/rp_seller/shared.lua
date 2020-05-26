ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.PrintName 	= "Cкупщик"
ENT.Author 		= "Bilwin"
ENT.Category	= "HL2RP"
ENT.AutomaticFrameAdvance = true;
ENT.Spawnable = true;
ENT.AdminSpawnable = true;

function ENT:PhysicsCollide(data, physobj)
end

function ENT:PhysicsUpdate(physobj)
end

function ENT:SetAutomaticFrameAdvance(bUsingAnim)
	self.AutomaticFrameAdvance = bUsingAnim;
end