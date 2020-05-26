include("shared.lua")

ENT.RenderGroup = RENDERGROUP_OPAQUE

local COL_TEXT = Color(255,255,255)
local COL_BG   = Color(0,0,0,150)
local FONT     = "igs.20"

local function textPlate(text,y)
	surface.SetFont(FONT)
	local tw,th = surface.GetTextSize(text)
	local bx,by = -tw / 2 - 10, y - 5
	local bw,bh = tw + 10 + 10, th + 10 + 10

	surface.SetDrawColor(COL_BG)
	surface.DrawRect(bx,by, bw,bh)
	surface.SetDrawColor(COL_TEXT)
	surface.DrawRect(bx, by + bh - 4, bw, 4)

	surface.SetTextColor(COL_TEXT)
	surface.SetTextPos(-tw / 2,y)
	surface.DrawText(text)
end

local function drawInfo(ent, text, dist)
	dist = dist or EyePos():DistToSqr(ent:GetPos())

	if dist < 60000 then
		surface.SetAlphaMultiplier( math.Clamp(3 - (dist / 20000), 0, 1) )

		local _,max = ent:GetRotatedAABB(ent:OBBMins(), ent:OBBMaxs() )
		local rot = (ent:GetPos() - EyePos()):Angle().yaw - 90
		local sin = math.sin(CurTime() + ent:EntIndex()) / 3 + .5 -- EntIndex дает разницу в движении
		local center = ent:LocalToWorld(ent:OBBCenter())

		cam.Start3D2D(center + Vector(0, 0, math.abs(max.z / 2) + 8 + sin), Angle(0, rot, 90), 0.13)
			textPlate(text,15)
		cam.End3D2D()

		surface.SetAlphaMultiplier(1)
	end
end

function ENT:Draw()
	local dist = EyePos():DistToSqr(self:GetPos())
	if _G['NPC_HIDE_ON_DISTANCE'] and dist > _G['NPC_HIDE_ON_DISTANCE'] then return end

	self:DrawModel()
	self:SetSequence(4)
	drawInfo(self, "Гражданские", dist)
end
