include("shared.lua")

local MAT_LIGHT = Material( "sprites/gmdm_pickups/light" )

if !PRACHKA_MODEL then
	PRACHKA_MODEL = ClientsideModel("models/props_junk/PopCan01a.mdl",RENDER_GROUP_VIEW_MODEL_OPAQUE)	
	PRACHKA_MODEL:SetNoDraw(true)
end

function ENT:RenderModel(mdl,pos,angle,size,ck,Material)
	local CM = PRACHKA_MODEL
	
	local ang = self:GetAngles()
	CM:SetModel(mdl)
	CM:SetRenderOrigin(self:GetPos() + ang:Forward() * pos.x + ang:Right() *pos.y + ang:Up() *pos.z )
		
	ang:RotateAroundAxis(ang:Forward(), angle.r)
	ang:RotateAroundAxis(ang:Right(), angle.p)
	ang:RotateAroundAxis(ang:Up(), angle.y)

	CM:SetRenderAngles(ang)
	local mat = Matrix() mat:Scale(size)
	CM:EnableMatrix("RenderMultiply", mat)
	CM:SetupBones()
	render.SetBlend(ck.a/255)
	render.SetColorModulation(ck.r/255, ck.g/255, ck.b/55)
	CM:SetMaterial(Material)
	CM:DrawModel()
end

local function RenderModel(Ent,DIST)
	if Ent:GetNWInt("PrachkaIsWorking") == 0 then return end
	Ent:RenderModel("models/props_junk/garbage_newspaper001a.mdl",Vector(0,0,math.random(1,10)),Angle(0,90,math.random(1,180)),Vector(1,1,1),color_white,nil)
end

function ENT:Draw()
	self:DrawModel()

	local DIST = LocalPlayer():GetPos():Distance(self:GetPos())

	RenderModel(self,DIST)

	local position, angles = self:GetPos(), self:GetAngles()

	angles:RotateAroundAxis(angles:Forward(), 90)
	angles:RotateAroundAxis(angles:Right(), 270)
	local pos = self:GetPos()
	local ang = self:GetAngles()
	local color = Color(155, 255, 64)

	if self:GetNWInt("PrachkaIsWorking") == 1 then
		color = Color(255,0,0)
	else
		color = Color(155, 255, 64)
	end

	ang:RotateAroundAxis(ang:Forward(), 45)

	if (LocalPlayer():GetPos():Distance(self:GetPos()) < 1000) then
		render.SetMaterial(Material("sprites/glow04_noz"))
		render.DrawSprite(self:GetPos()+self:GetForward()*22+self:GetUp()*35+self:GetRight()*5.5, 6, 6, color)
	end
end