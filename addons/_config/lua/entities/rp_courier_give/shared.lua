ENT.Base = "base_ai" 
ENT.Type = "ai"
ENT.PrintName = "Посылка - Отправка"
ENT.Instructions = "Base entity"
ENT.Author = "Bilwin"
ENT.Category = "CWU"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.AdminSpawnable = true

function ENT:SetAutomaticFrameAdvance( bUsingAnim )
	self.AutomaticFrameAdvance = bUsingAnim
end
