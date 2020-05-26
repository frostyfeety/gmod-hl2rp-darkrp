
gib_models = {	"models/hunter/blocks/cube025x025x025.mdl",
				"models/props_c17/consolebox01a.mdl",
				"models/props_lab/reciever01b.mdl",
				"models/props_c17/pulleywheels_large01.mdl",
				"models/xqm/jetenginepropellerhuge.mdl",
				"models/props_lab/plotter.mdl",
				}
				
local ExplosionSound = { "ambient/explosions/explode_1.wav",
							"ambient/explosions/explode_2.wav",
							"ambient/explosions/explode_3.wav",
							"ambient/explosions/explode_4.wav",
							"ambient/explosions/explode_5.wav",
							"ambient/explosions/explode_8.wav",
							"ambient/explosions/explode_9.wav",
						}

function EFFECT:Init( data )
	self.Pos = data:GetOrigin()
	self.CreatedTime = CurTime()
	self.Emitter = ParticleEmitter(self.Pos)
	
	if math.random(1,2) == 1 then
		sound.Play(table.Random(ExplosionSound),self.Pos,math.random(70,120))
	end
	
	self:SetModel(table.Random(gib_models))
	self:SetModelScale(0.3,0)
	
	self.Entity:PhysicsInitBox( self:OBBMins(), self:OBBMaxs()  )
	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
	self.Entity:SetCollisionBounds( self:OBBMins(), self:OBBMaxs() )
	self.gib_vel = data:GetStart()
	self.life_time = 2
	self:SetModelScale(0.5,0)
	
	local phys = self.Entity:GetPhysicsObject()
	if ( phys && phys:IsValid() ) then
		phys:SetDamping(0,0)
		phys:SetMass(10000)
		phys:Wake()
		phys:SetAngles( Angle( math.Rand(0,360), math.Rand(0,360), math.Rand(0,360) ) )
		phys:SetVelocity( self.gib_vel )
		phys:AddAngleVelocity(Vector(math.Rand(-30,30),math.Rand(-30,30), math.Rand(-30,30)))
	end
	self:SetColor(Color(0,0,0,255))
 end

 
function EFFECT:Think()
	
	local vel = self:GetVelocity():Length()
	local die_time = math.Rand(0.5,1.2)
	if vel < 50 then
		die_time = math.Rand(0.7,1.5)
	end
	
	local p = self.Emitter:Add( "particles/flamelet"..math.random(1,4), self:GetPos() )
	p:SetDieTime(die_time / 2)
	p:SetGravity(Vector(0,0,10))
	p:SetVelocity(Vector(math.random(-10,50),math.random(-10,50), math.random(10,20)))
	p:SetAirResistance(20)
	p:SetStartSize(math.Rand(5,10))
	p:SetEndSize(math.Rand(13,19))
	p:SetRoll(math.Rand(-5,5))
	p:SetColor(100,100,100,255)
	p:SetEndAlpha( 0 )
	
	local p = self.Emitter:Add( "particle/particle_smokegrenade", self:GetPos() )
	p:SetDieTime(die_time)
	p:SetGravity(Vector(100,0,70))
	p:SetVelocity(Vector(math.random(-10,50),math.random(-10,50), 50))
	p:SetAirResistance(20)
	p:SetStartSize(0)
	p:SetEndSize(math.Rand(25,35))
	p:SetRoll(math.Rand(-5,5))
	p:SetColor(100,100,100,255)
	p:SetEndAlpha( 0 )
	
	if self.CreatedTime + self.life_time < CurTime() then
		self:Remove()
		return false
	else
		return true
	end
end
 
function EFFECT:Render()
	self:DrawModel()
end
