-----------------------------[[
-- "Optimisation"
-----------------------------]]

hook.Add("InitPostEntity", "rp_assets", function()
	timer.Simple(1.5, function()
		concommand.Remove("gm_save")
		
		hook.Remove("RenderScene", "RenderSuperDoF")
		hook.Remove("RenderScene", "RenderStereoscopy")
		hook.Remove("PreRender", "PreRenderFlameBlend")
		hook.Remove("PostRender", "RenderFrameBlend")
		hook.Remove("GUIMousePressed", "SuperDOFMouseDown")
		hook.Remove("GUIMouseReleased", "SuperDOFMouseUp")
		hook.Remove("Think", "DOFThink")
		hook.Remove("PlayerTick", "TickWidgets")
		hook.Remove("PlayerBindPress", "PlayerOptionInput")
		hook.Remove("OnGamemodeLoaded", "CreateMenuBar")
		hook.Remove("HUDPaint", "drawHudVital")
		hook.Remove("RenderScreenspaceEffects", "RenderBloom")
		hook.Remove("RenderScreenspaceEffects", "RenderBokeh")
		hook.Remove("RenderScreenspaceEffects", "RenderMaterialOverlay")
		hook.Remove("RenderScreenspaceEffects", "RenderSharpen")
		hook.Remove("RenderScreenspaceEffects", "RenderSobel")
		hook.Remove("RenderScreenspaceEffects", "RenderStereoscopy")
		hook.Remove("RenderScreenspaceEffects", "RenderSunbeams")
		hook.Remove("RenderScreenspaceEffects", "RenderTexturize")
		hook.Remove("RenderScreenspaceEffects", "RenderToyTown")
	end)
end)

-----------------------------[[
-- Change toolgun shot sound
-----------------------------]]

timer.Simple( .1, function()
	weapons.GetStored( 'gmod_tool' ).ShootSound = Sound( 'ambient/weather/rain_drip4.wav' )
end)

-----------------------------[[
-- Fix and correct fov
-----------------------------]]

local orig_fov = GetConVarString("fov_desired")
local orig_timeout = GetConVarString("cl_timeout")

if tonumber(orig_fov) and tonumber(orig_fov) < 90 then
	RunConsoleCommand("fov_desired", 90)
end

RunConsoleCommand("cl_timeout", 600)

hook.Add("ShutDown", "rp_revert_fox", function()
	RunConsoleCommand("fov_desired", orig_fov)
	RunConsoleCommand("cl_timeout", orig_timeout)
end)

-----------------------------[[
-- Properties
-----------------------------]]

properties.Add("plynickname", {
	MenuLabel = "Nickname",
	Order = 1,
	MenuIcon = "icon16/vcard.png",

	Filter = function( self, ent, ply )
		if ent:IsValid() && ent:IsPlayer() then
			self.MenuLabel = ent:Nick()
			return true
		end
	end,
	Action = function( self, ent )
		SetClipboardText(ent:Nick())
	end
})

properties.Add("givemoney", {
	MenuLabel = "Дать деньги",
	Order = 10,
	MenuIcon = "icon16/money.png",

	Filter = function( self, ent, ply )
		return IsValid( ent ) && ent:IsPlayer() && ply:GetPos():Distance(ent:GetPos()) < 200
	end,
	Action = function( self, ent )
		Derma_StringRequest("Дать деньги", "Сколько вы хотите дать?", nil, function(a)
			if !tonumber(a) then return end
			self:MsgStart()
				net.WriteEntity(ent)
				net.WriteFloat(tonumber(a))
			self:MsgEnd()
		end)
	end,
	Receive = function( self, length, ply )
		local ent = net.ReadEntity()
		local amount = net.ReadFloat()

		if !(self:Filter(ent, ply) && amount) then return end

		if !ply:canAfford(amount) then
			DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("cant_afford", ""))

			return ""
		end

		ply:addMoney(-amount)
		ent:addMoney(amount)

		DarkRP.notify(ent, 0, 4, DarkRP.getPhrase("has_given", ply:Nick(), DarkRP.formatMoney(amount)))
		DarkRP.notify(ply, 0, 4, DarkRP.getPhrase("you_gave", ent:Nick(), DarkRP.formatMoney(amount)))
	end
})

properties.Add("wanted", {
	MenuLabel = "Подать в розыск",
	Order = 50,
	MenuIcon = "icon16/flag_red.png",

	Filter = function( self, ent, ply )
		return IsValid( ent ) && ent:IsPlayer() && !ent:isWanted() && GAMEMODE.CivilProtection[ply:Team()]
	end,
	Action = function( self, ent )
		Derma_StringRequest("Подать в розыск", "За что его подавать в розыск??", nil, function(a)
			RunConsoleCommand("darkrp", "wanted", ent:UserID(), a)
		end)
	end
})

properties.Add("unwanted", {
	MenuLabel = "Снять розыск",
	Order = 60,
	MenuIcon = "icon16/flag_green.png",

	Filter = function( self, ent, ply )
		return IsValid( ent ) && ent:IsPlayer() && ent:isWanted() && ply:isCP()
	end,
	Action = function( self, ent )
		RunConsoleCommand("darkrp", "unwanted", ent:UserID())
	end
})

properties.Add("warrant", {
	MenuLabel = "Запросить ордер",
	Order = 70,
	MenuIcon = "icon16/door_in.png",

	Filter = function( self, ent, ply )
		return IsValid( ent ) && ent:IsPlayer() && ply:isCP()
	end,
	Action = function( self, ent )
		Derma_StringRequest("Запросить ордер", "Что он сделал?", nil, function(a)
			RunConsoleCommand("darkrp", "warrant", ent:UserID(), a)
		end)
	end
})

-----------------------------[[
-- Anti-Player-Stuck
-----------------------------]]

if not SERVER then return end

timer.Create("rp_player_stuck", 0.1, 0, function()
	for k,v in pairs(player.GetAll()) do
		if IsValid(v) and v:IsPlayer() and v:Alive() then
			if !v:InVehicle() then
				local Offset = Vector(5, 5, 5)
				local Stuck = false
				
				if v.Stuck == nil then
					v.Stuck = false
				end
				
				if v.Stuck then
					Offset = Vector(2, 2, 2)
				end

				for _,ent in pairs(ents.FindInBox(v:GetPos() + v:OBBMins() + Offset, v:GetPos() + v:OBBMaxs() - Offset)) do
					if IsValid(ent) and ent != v and ent:IsPlayer() and ent:Alive() then
					
						v:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
						v:SetVelocity(Vector(-10, -10, 0) * 20)
						
						ent:SetVelocity(Vector(10, 10, 0) * 20)
						
						Stuck = true
					end
				end
			   
				if !Stuck then
					v.Stuck = false
					v:SetCollisionGroup(COLLISION_GROUP_PLAYER)
				end
			else
				v:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
			end	
		end
	end
end)
-----------------------------[[
-- Other Modules
-----------------------------]]

breencast_vocal = "minerva/vo/breencast/welcome.wav"

hook.Add( "KeyPress", "rp_breakbox", function( ply, key )
	if ply:HasWeapon("rp_box") then
		if ( key == IN_JUMP ) then
			ply:EmitSound( "physics/wood/wood_crate_break"..math.random(1,5)..".wav", 50, 100 )
			ply:StripWeapon("rp_box")
			ply:SetRunSpeed(235)
			ply:ChatPrint("Ты сломал коробку!")
		end
	end
end )

-----------------------------[[
-- Health Module
-----------------------------]]

hook.Add("PlayerPostThink", "rp_PlayerPostThink_health", function( ply )
	if ply:Health() < 50 then
		ply:SetRunSpeed(155)
	elseif ply:Health() < 25 then 
		ply:SetRunSpeed(133)
	elseif ply:Health() < 10 then
		ply:SetRunSpeed(100)
	else
		ply:SetRunSpeed(235)
	end
end)

