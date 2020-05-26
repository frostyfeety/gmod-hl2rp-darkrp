ENT.Base = "base_ai" 
ENT.Type = "ai"
ENT.PrintName = "Гражданин - Муж.4"
ENT.Instructions = "Base entity"
ENT.Author = "Bilwin"
ENT.Category = "HL2RP - Citizens"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.AdminSpawnable = true

function ENT:SetAutomaticFrameAdvance( bUsingAnim )
	self.AutomaticFrameAdvance = bUsingAnim
end
