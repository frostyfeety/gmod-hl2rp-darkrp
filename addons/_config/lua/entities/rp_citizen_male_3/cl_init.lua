include("shared.lua")
ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:Draw()
	self:DrawModel()
	self:SetSequence(self:LookupSequence("d1_t02_Playground_Cit2_Pockets"))
end