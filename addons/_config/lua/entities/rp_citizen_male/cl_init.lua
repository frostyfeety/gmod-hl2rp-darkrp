include("shared.lua")
ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:Draw()
	self:DrawModel()
	self:SetSequence(self:LookupSequence("sitccouchtv1"))
end