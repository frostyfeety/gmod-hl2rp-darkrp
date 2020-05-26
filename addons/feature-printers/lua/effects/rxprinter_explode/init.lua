EFFECT.Mat = Material( "Effects/blueblacklargebeam" )

local Height = 300
local FallBackDist = 800
/*---------------------------------------------------------
   Init( data table )
---------------------------------------------------------*/
function EFFECT:Init( data )
	self.Pos 	= data:GetOrigin()
	self:SetPos(self.Pos)
	self.Start = CurTime()
	self:SetRenderBoundsWS( self.Pos - Vector(100,100,100), self.Pos + Vector(100,100,200))
	
	self.Emitter = ParticleEmitter(self.Pos)
	
	self.DieTime = CurTime() + 1.6
	
	for k=1,5 do
		self:PartExplode(self.Pos + Vector(math.random(-60,60),math.random(-60,60),0))
	end
	
	

			for i=0,50 do -- Spread
				local Smoke = self.Emitter:Add("sprites/physg_glow1", self.Pos)
					Smoke:SetVelocity( VectorRand()*200)
					Smoke:SetDieTime( 2 )
					Smoke:SetStartAlpha( 255 )
					Smoke:SetEndAlpha( 0 )
					Smoke:SetStartSize( 15 )
					Smoke:SetEndSize( 0 )				 		
					Smoke:SetStartLength( math.Rand( 10, 24 ) )
					Smoke:SetEndLength( math.Rand( 70, 100 ) )
					Smoke:SetColor( 255,math.random(50,255),0 )
					Smoke:SetGravity( Vector( 0, 0, -700 ) )
			end
			

			for i=0,10 do
			local Smoke = self.Emitter:Add("particle/smokesprites_000"..math.random(1,9),  self.Pos)
				Smoke:SetVelocity(VectorRand()*300)
				Smoke:SetDieTime(3)
				Smoke:SetStartAlpha(math.Rand(255,255))
				Smoke:SetEndAlpha(0)
				Smoke:SetStartSize(math.random(50,60))
				Smoke:SetEndSize(0)
				Smoke:SetRoll(math.Rand(180,480))
				Smoke:SetRollDelta(math.Rand(-3,3))
				Smoke:SetColor(255,255,255)
				Smoke:SetLighting( true )
				Smoke:SetAirResistance(220)
			end
			
			for k=1,40 do
				local particle = self.Emitter:Add( "particles/flamelet"..math.random(1,5),  self.Pos )
				if (particle) then
					particle:SetVelocity( VectorRand() * math.random(100,180) + Vector(0,0,math.random(200,400)) )
					particle:SetLifeTime( 0 )
					particle:SetDieTime( 1 )
					particle:SetStartAlpha( 100 )
					particle:SetEndAlpha( 0 )
					particle:SetStartSize( 12 )
					particle:SetEndSize( 3 )
					particle:SetColor( 255 , 255 , 0 )
				
					particle:SetAirResistance( 100 )
					particle:SetGravity( Vector( 0, 0, -700 ) )
					particle:SetCollide( true )
					particle:SetBounce( 0 )
				end
			end
			
end

function EFFECT:PartExplode(pos)

		local ED = EffectData()
		ED:SetOrigin(pos)
		ED:SetStart(VectorRand()*100+Vector(0,0,100))
		util.Effect("rxprinter_gib", ED)
	
end

function EFFECT:CrashEffect()
	if (self.CEDel or 0) < CurTime() then
		self.CEDel = CurTime()+0.1
		
		for i=1,4 do
			local Ang = math.rad(360/4*i)
			local VEC = Vector(math.sin(Ang),math.cos(Ang),0)*25
			
			local Smoke = self.Emitter:Add("particle/particle_smokegrenade", self.Pos + VEC)
				Smoke:SetVelocity(VectorRand()*80+Vector(0,0,100))
				Smoke:SetDieTime(0.4)
				Smoke:SetStartAlpha(math.Rand(255,255))
				Smoke:SetEndAlpha(0)
				Smoke:SetStartSize(math.random(60,70))
				Smoke:SetEndSize(math.random(120,140))
				Smoke:SetColor(150,150,150)
				Smoke:SetAirResistance(220)
		end
	end
end
function EFFECT:Render()
end

function EFFECT:Think( )

	if CurTime() > self.DieTime then
		self:Remove()
		return false
	end
	return true

end