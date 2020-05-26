AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
 
include('shared.lua')

local models = {
	"models/props_junk/garbage128_composite001a.mdl",
	"models/props_junk/garbage128_composite001a.mdl",
	"models/props_junk/garbage128_composite001c.mdl",
	"models/props_junk/garbage128_composite001d.mdl",
	"models/props_junk/garbage256_composite001a.mdl",
	"models/props_junk/garbage256_composite002a.mdl",
	"models/props_junk/garbage256_composite002b.mdl",
	"models/props_junk/garbage256_composite001b.mdl"
}

function ENT:Initialize()
	self:SetModel( table.Random(models) )
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	phys:Wake()
end

function ENT:Use(activator)
	local sell = math.random( 15, 65 )
    if IsValid( activator ) and activator:IsPlayer() then
		if(activator:Team() == TEAM_CWU1) then
			if (self.chistkarp or 0) < CurTime() then
				if ( activator:Crouching() ) then
					self:SetNWInt("rp_TrashCanDelay", 0)
					activator:addMoney(sell)
					activator:SendLua("GAMEMODE:AddNotify(\"За данный мусор вы получили "..sell.." токенов\", NOTIFY_GENERIC, 10)")
					self.chistkarp= CurTime() + 120
				else
					if (self.NotifyCD or 0) > CurTime() then
        				return
    				end
					activator:SendLua("GAMEMODE:AddNotify(\"Вы должны сесть!\", NOTIFY_GENERIC, 10)")
    				self.NotifyCD= CurTime() + 5
				end
			end
		end
	end
end

function ENT:Think()
	if (self.chistkarp or 0) < CurTime() then
		self:SetColor( Color( 255, 255, 255, 255 ) )
		self:SetNoDraw(false)
	else
		self:SetColor( Color( 255, 255, 255, 0 ) )
		self:SetNoDraw(true)
	end
end

timer.Create( "TrashCD", 1, 0, function()
	for k,v in pairs(ents.GetAll()) do
		if (v:GetClass() == "rp_trash") then
			if(v:GetNWInt("rp_TrashCanDelay") < 450) then
				v:SetNWInt("rp_TrashCanDelay", v:GetNWInt("rp_TrashCanDelay") + 1)
			end
		end
	end
end)