AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_phx/construct/metal_tube.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	phys:Wake()
	
	self:SetUseType( SIMPLE_USE )
	
	--
	self.LastUse = 0
	self.Delay = 200
end

function ENT:Use(activator)
	local timerSound = "buttons/blip1.wav"
	local allowedTeam = TEAM_CWU2
	if activator:Team() != allowedTeam then return end
    if activator.xyu == nil then  activator.xyu = CurTime() - 1 end
    if activator.xyu > CurTime() then DarkRP.notify(activator, 1, 4, "Подождите еще ".. math.floor(activator.xyu -CurTime()) .. " секунд") return end
        activator.xyu = CurTime() + 15
		self:EmitSound("buttons/lever8.wav")

		timer.Simple(0.4, function()
			self:EmitSound("buttons/button1.wav")
		end)

		timer.Simple(1.3, function()
		self:EmitSound("buttons/button4.wav")
		local ent = ents.Create( "rp_clothold" )
		ent:SetPos( self:GetPos() + ( self:GetForward() * 3 ) + ( self:GetUp() * 5 ) )
		ent:SetAngles( self:GetAngles() + Angle( 0, 0, 0 ) )
		ent:Spawn()
		ent:Activate()
		ent:GetPhysicsObject():ApplyForceCenter( self:GetForward() * 15 )
		end)
	end
