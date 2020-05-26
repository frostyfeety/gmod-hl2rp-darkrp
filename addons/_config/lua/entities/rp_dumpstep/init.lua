AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
	self:SetModel("models/props_junk/TrashDumpster01a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
end

function ENT:Cooldown()
	self:SetDTInt(0, 600)
	timer.Create("DTime " ..self:EntIndex(), 1, 600, function()
		self:RemoveTime()
	end)
end


function ENT:RemoveTime()
	self:SetDTInt(0, self:GetDTInt(0) - 1)
	
	if self:GetDTInt(0) <= 0 then
		if timer.Exists("DTime " ..self:EntIndex()) then
			timer.Destroy("DTime " ..self:EntIndex())
		end
	end
end

function ENT:Use(activator)

	if self:GetDTInt(0) > 1 then 
		activator:ChatPrint('Мусорный бак пуст!')
		return 
	end

	if not activator:isCP() and activator:Team() ~= TEAM_CITIZEN then
		local rp_electrons = math.random(0,5)
		local rp_metalls = math.random(0,5)

		self:Cooldown()
		self:EmitSound("ambient/materials/platedrop"..math.random(1,3)..".wav")
		activator:ChatPrint('Вы собрали с мусорки '..rp_electrons.." единиц электроники и "..rp_metalls.." кусков металла")

		activator:SetNWInt('rp_electro', activator:GetNWInt('rp_electro', 0) + rp_electrons)
		activator:SetNWInt('rp_metal', activator:GetNWInt('rp_metal', 0) + rp_metalls)
	else
		return
	end

end

function ENT:OnRemove()
	self:RemoveTime()
end