AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_interiors/VendingMachineSoda01a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	phys:Wake()
	self:SetNWInt("rp_water_amount", 50)
	self:SetUseType( SIMPLE_USE )
	self.LastUse = 0
	self.Delay = 2
end

function ENT:Use(activator)
	if activator:Team() == TEAM_ZOMBIE then activator:SendLua("GAMEMODE:AddNotify(\"Вы не можете использовать это будучи зомбированным!\", NOTIFY_GENERIC, 1)") return end
	if activator:isCP() then return end
	if self.LastUse <= CurTime() then
		self.LastUse = CurTime() + self.Delay
		if self:GetNWInt("rp_water_amount") > 0 then
			if not activator:canAfford(20) then
				self:EmitSound("buttons/combine_button_locked.wav")
				DarkRP.notify(activator, 1, 3, "Недостаточно токенов.")
				return ""
			else
				self:SetNWInt("rp_water_amount", self:GetNWInt("rp_water_amount") - 1)
				DarkRP.notify(activator, 2, 3, "Вычтено ₮50")
				activator:addMoney(-50)
				activator:EmitSound("buttons/button24.wav")
				self:EmitSound( Sound( "ambient/levels/labs/coinslot1.wav" ) )
				timer.Simple( 1.5, function()
					self:EmitSound("buttons/button4.wav")
					local ent = ents.Create( "rp_water" )
					ent:SetPos( self:GetPos() + ( self:GetForward() * 7 ) + ( self:GetUp() * -10 ) )
					ent:SetAngles( self:GetAngles() + Angle( 0, 0, 90 ) )
					ent:Spawn()
					ent:Activate()
					ent:GetPhysicsObject():ApplyForceCenter( self:GetForward() * 10 )
				end)
			end
		else
			local reward = math.random(500,1500)
			if activator:Team() == TEAM_CWU1 then
				DarkRP.notify(activator, 2, 3, "Вы пополнили автомат водой. Вы получили ₮"..reward)
				activator:addMoney(reward)
				activator:EmitSound("physics/wood/wood_crate_impact_soft"..math.random(1,3)..".wav")
				self:SetNWInt("rp_water_amount", 50)
			else
				DarkRP.notify(activator, 1, 3, "Раздатчик пуст, вызовите курьера!")
				self:EmitSound("buttons/combine_button_locked.wav")
			end
			
		end
	end
end