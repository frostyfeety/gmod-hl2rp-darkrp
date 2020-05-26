include("shared.lua")

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:BuildBonePositions(NumBones, NumPhysBones)
end
 
function ENT:SetRagdollBones(bIn)
	self.m_bRagdollSetup = bIn;
end

function ENT:DoRagdollBone(PhysBoneNum, BoneNum)
end
