include("shared.lua")
ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:Draw()
	self:DrawModel()
	self:SetSequence(self:LookupSequence("d1_t03_Tenements_Look_Out_Window_Idle"))
end