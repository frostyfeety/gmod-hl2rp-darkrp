include("shared.lua")
ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:Draw()
	self:DrawModel()
	--self:SetSequence(41)
end