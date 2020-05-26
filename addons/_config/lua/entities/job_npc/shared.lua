ENT.Base = "base_ai" 
ENT.Type = "ai"
ENT.PrintName = "Citizens"
ENT.Instructions = "Base entity"
ENT.Author = "Bilwin"
ENT.Category = "HL2RP - Jobs"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.AdminSpawnable = true

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "JobName")
end

function ENT:SetAutomaticFrameAdvance( bUsingAnim )
	self.AutomaticFrameAdvance = bUsingAnim
end
