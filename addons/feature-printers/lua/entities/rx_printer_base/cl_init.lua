include("shared.lua")
include("sh_upgrader.lua")

//====
local DoRenderDetail = true
	timer.Create("RXPrintersAround",1,0,function()
		local Count = 0
		for k,v in pairs(ents.FindInSphere(EyePos(),500)) do
			if v.RXPrinter then
				Count = Count + 1
			end
		end
		if Count >= RXPrinters_Config.RenderDetaliMax then
			DoRenderDetail = false
		else
			DoRenderDetail = true
		end
	end)

local MAT_LIGHT = Material( "sprites/gmdm_pickups/light" )

if !PRINTER_CMODEL then
	PRINTER_CMODEL = ClientsideModel("models/props_junk/PopCan01a.mdl",RENDER_GROUP_VIEW_MODEL_OPAQUE)	
	PRINTER_CMODEL:SetNoDraw(true)
end

function ENT:RenderModel(mdl,pos,angle,size,ck,Material)
	local CM = PRINTER_CMODEL
	
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
	render.SetColorModulation(ck.r/255, ck.g/255, ck.b/255)
	CM:SetMaterial(Material)
	CM:DrawModel()
end


function RenderPrinterModel(Ent,DIST)
	
	local SequenceTime = CurTime() * Ent.SequenceMultiple
	local PCK = Ent.PrinterMasterColor
	
	-- Main

	Ent:RenderModel("models/props_c17/consolebox01a.mdl",Vector(1,1,-6.5),Angle(0,0,0),Vector(1,1,1),color_white,nil)
	
	if DIST > RXPrinters_Config.RenderDetailDist then return end
	if !DoRenderDetail then return end

	-- Inside Printer
	
	if Ent:IsError() then
		SequenceTime = 0
	end
	
	local BoosterLevel = Ent:GetTuneLevel("booster")
	SequenceTime = SequenceTime*(((BoosterLevel*RXP_Additional_AnimationSpeed_Booster_Upgrade)/100)+1)
	
	local SQ = math.sin(SequenceTime)
	local MoneyBack = (SequenceTime/2)%18
	
end


function Render3D2DInfo(Ent,DIST)
		local ang = Ent:GetAngles()
			ang:RotateAroundAxis(ang:Up(), 90)
			
	local Owner = Ent:GetPrinterOwner()
	if Owner and Owner:IsValid() then
		Owner = Owner:Nick()
	else
		Owner = ""
	end
		
	cam.Start3D2D(Ent:GetPos() + Ent:GetUp()*4.1 - Ent:GetForward()*4, ang, 0.14)
		surface.SetDrawColor(Color(0,0,0,200))
		surface.DrawRect(-90,0,180,40)
		
		draw.SimpleText(Ent.PrinterName, "RXP_Header", 0,2, Color(255,255,255,200),TEXT_ALIGN_CENTER)
		draw.SimpleText(Owner, "RXP_Hull", 0,25, Color(255,255,255,200),TEXT_ALIGN_CENTER)
	
	cam.End3D2D()
end

function Render3D2DInfo2(Ent,DIST)
	local H,HM = Ent:GetHull()
		
		local ang = Ent:GetAngles()
			ang:RotateAroundAxis(ang:Right(), 270)
			ang:RotateAroundAxis(ang:Up(), 90)
		
	cam.Start3D2D(Ent:GetPos() + Ent:GetForward()*17.8 + Ent:GetUp()/9, ang, 0.1)
		surface.SetDrawColor(Ent.PrinterMasterColor)
		surface.DrawRect(-140,28,200,26)
		surface.SetDrawColor(Color(0,0,0,200))
		surface.DrawRect(-138,30,196,22)
		
		surface.SetDrawColor(Color(0,255,0,200))
		surface.DrawRect(-136,32,192 * math.min(1,H/HM),18)
		
		local TEXT = Ent:GetStoredMoney()
		local Error,ErrorCode = Ent:IsError()
		
		if Ent:IsError() then
			if CurTime()%1 < 0.5 then
				TEXT = RXPrinters_Config.ErrorCodeMessage[ErrorCode] or "ERROR"
			end
		end
		
		
			draw.SimpleText(TEXT, "RXP_Money", -80, -25, Color(255,255,255,200))
			draw.SimpleText(H .. " / " .. HM, "RXP_Hull", -45, 35, Color(255,255,255,200),TEXT_ALIGN_CENTER)
	
	cam.End3D2D()
end

function ENT:GetPrinterOwner()
	return self:Getowning_ent()
end

function ENT:OnRemove()
	self.RunningSoundOBJ:Stop()
end

function ENT:Initialize()
	self.RunningSoundOBJ = CreateSound( self , self.RuningSound[3] )
	self.RunningSoundOBJ:ChangeVolume( self.RuningSoundVolume, 0 )
	
	self.Emitter = ParticleEmitter(self:GetPos())
end

function ENT:Draw()

	--self:DrawModel()
	local DIST = LocalPlayer():GetPos():Distance(self:GetPos())
	
	if DIST <= RXPrinters_Config.RenderDist then
	
		RenderPrinterModel(self,DIST)
	
		if DIST <= RXPrinters_Config.RenderDetailDist then
			Render3D2DInfo(self,DIST)
			Render3D2DInfo2(self,DIST)
			
			local Error,ErrorCode = self:IsError()
			if ErrorCode == 2 then
				local p = self.Emitter:Add( "particle/particle_smokegrenade", self:GetPos() )
				p:SetDieTime(1)
				p:SetGravity(Vector(-100,0,70))
				p:SetVelocity(Vector(math.random(-10,50),math.random(-10,50), 50))
				p:SetAirResistance(20)
				p:SetStartSize(0)
				p:SetEndSize(math.Rand(25,35))
				p:SetRoll(math.Rand(-5,5))
				p:SetColor(100,100,100,255)
				p:SetEndAlpha( 0 )
			end
		end
		
	end
	
		render.SetColorModulation(1,1,1)
		render.SetBlend(1)
end

function ENT:Think()

	local DIST = LocalPlayer():GetPos():Distance(self:GetPos())
	if DIST > RXPrinters_Config.RenderDist then return end
	
	if self:IsError() and self.ErrorSound[1] then
		if ( self.ErrorSoundTime or 0 ) < CurTime() then
			self.ErrorSoundTime = CurTime() + self.ErrorSound[2]
			self:EmitSound(self.ErrorSound[3])
			self:EmitSound(self.ErrorSound[3])
			self.RunningSoundOBJ:Stop()
		end
	end
	if !self:IsError() and self.RuningSound[1] then
		if ( self.RunningSoundTime or 0 ) < CurTime() then
			self.RunningSoundTime = CurTime() + self.RuningSound[2]
			self.RunningSoundOBJ:Stop()
			self.RunningSoundOBJ:Play()
		end
	end
end