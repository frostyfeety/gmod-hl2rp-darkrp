--[[
	STool: Fading Doors
	Version: 2.1.1
	Author: http://www.steamcommunity.com/id/zapk
--]]

--[[
	New in 2.1.0:
	-	Fixed "No Effect" not working.
	-	Cleaned up code.
--]]

TOOL.Category = "Minerva"
TOOL.Name = "#tool.fading_door.name"

TOOL.ClientConVar["key"] = "5"
TOOL.ClientConVar["toggle"] = "1"
TOOL.ClientConVar["reversed"] = "0"
TOOL.ClientConVar["noeffect"] = "0"

-- create convar fading_door_nokeyboard (defualt 0)
local noKeyboard = CreateConVar("fading_door_nokeyboard", "1", FCVAR_ARCHIVE, "Set to 1 to disable using fading doors with the keyboard")

local function checkTrace(tr)
	-- edgy, yes, but easy to read

	return tr.Entity
		and tr.Entity:IsValid()
		and not (
			tr.Entity:IsPlayer()
			or tr.Entity:IsNPC()
			or tr.Entity:IsVehicle()
			or tr.HitWorld
		)
end

if CLIENT then
	-- handle languages
	language.Add( "tool.fading_door.name", "Fading Door" )
	language.Add( "tool.fading_door.desc", "При активации делает объект прозрачным" )
	language.Add( "tool.fading_door.0", "Нажмите на объект, чтобы сделать его FD." )
	language.Add( "Undone_fading_door", "Fading Door удалён" )

	-- handle tool panel
	function TOOL:BuildCPanel()
		self:AddControl( "Header", { Text = "#tool.fading_door.name", Description = "#tool.fading_door.desc" } )
		self:AddControl( "CheckBox", { Label = "Начать прозрачным", Command = "fading_door_reversed" } )
		--self:AddControl( "CheckBox", { Label = "Toggle", Command = "fading_door_toggle" } )
		self:AddControl( "CheckBox", { Label = "Без эффектов", Command = "fading_door_noeffect" } )
		self:AddControl( "Numpad", { Label = "Кнопка", ButtonSize = "22", Command = "fading_door_key" } )
	end

	-- leftclick trace function
	TOOL.LeftClick = checkTrace

	return
end

local function fadeActivate(self)
	self.fadeActive = true
	--AN("Открывает FDOOR", self:CPPIGetOwner())


	self.fadeMaterial = self:GetMaterial()
	self.fadeColor = self:GetColor()

	if self.noEffect then
		self:SetColor(Color(255, 255, 255, 0))
		self:SetMaterial("Models/effects/vol_light001")
	else
		self:SetMaterial("sprites/heatwave")
	end

	self:DrawShadow(false)
	self:SetNotSolid(true)

	local phys = self:GetPhysicsObject()

	if IsValid(phys) then
		self.fadeMoveable = phys:IsMoveable()
		phys:EnableMotion(false)
	end

	self:SetNWBool("fading", false)

end

local function fadeDeactivate(self)

	local can, reason = hook.Run( 'PreventFadingDoorDudos', self, self:CPPIGetOwner() )
	
	if can then
		return 
	end
	--AN("Закрывает FDOOR", self:CPPIGetOwner())


	self.fadeActive = false

	self:SetMaterial(self.fadeMaterial or "")
	self:SetColor(self.fadeColor or color_white)

	self:DrawShadow(true)
	self:SetNotSolid(false)

	local phys = self:GetPhysicsObject()

	if IsValid(phys) then
		phys:EnableMotion(false)
	end

	self:SetNWBool("fading", true)
	
end

local function fadeToggleActive(self, ply)

	if noKeyboard:GetBool() and not numpad.FromButton() then
		DarkRP.notify(ply,0,4,"Нужно поставить кейпад или кнопку")
		return
	end


	
	if self.fadeActive then
		self:fadeDeactivate()
	else
		self:fadeActivate()
	end
end

local function onUp(ply, ent)
		return
end

numpad.Register("Fading Door onUp", onUp)

local function onDown(ply, ent)
	if ply.nextfdoor and ply.nextfdoor > CurTime() then return end
	if not (ent:IsValid() and ent.fadeToggleActive) then
		return
	end

	ent:fadeToggleActive(ply)
	ply.nextfdoor = CurTime() + 3
end

numpad.Register("Fading Door onDown", onDown)



local function onRemove(self)
	numpad.Remove(self.fadeUpNum)
	numpad.Remove(self.fadeDownNum)
end

local function dooEet(ply, ent, stuff)
	if ent.isFadingDoor then
		ent:fadeDeactivate()
		onRemove(ent)
	else
		ent.isFadingDoor = true

		ent.fadeActivate = fadeActivate
		ent.fadeDeactivate = fadeDeactivate
		ent.fadeToggleActive = fadeToggleActive

		ent:CallOnRemove("Fading Door", onRemove)
	end

	ent.fadeUpNum = numpad.OnUp(ply, stuff.key, "Fading Door onUp", ent)
	ent.fadeDownNum = numpad.OnDown(ply, stuff.key, "Fading Door onDown", ent)
	ent.fadeToggle = stuff.toggle
	ent.noEffect = stuff.noEffect

	if stuff.reversed then
		ent:fadeActivate()
	end

	duplicator.StoreEntityModifier(ent, "Fading Door", stuff)

	return true
end

duplicator.RegisterEntityModifier("Fading Door", dooEet)

if not FadingDoor then
	local function legacy(ply, ent, data)
		return dooEet(ply, ent, {
			key      = data.Key,
			toggle   = data.Toggle,
			reversed = data.Inverse,
			noEffect = data.NoEffect
		})
	end

	duplicator.RegisterEntityModifier("FadingDoor", legacy)
end

local function doUndo(undoData, ent)
	if IsValid(ent) then
		onRemove(ent)
		ent:fadeDeactivate()

		ent.isFadingDoor = false

		if WireLib then
			ent.TriggerInput = ent.fadeTriggerInput

			if ent.Inputs then
				Wire_Link_Clear(ent, "Fade")
				ent.Inputs['Fade'] = nil
				WireLib._SetInputs(ent)
			end if ent.Outputs then
				local port = ent.Outputs['FadeActive']

				if port then
					for i,inp in ipairs(port.Connected) do
						if (inp.Entity:IsValid()) then
							Wire_Link_Clear(inp.Entity, inp.Name)
						end
					end
				end

				ent.Outputs['FadeActive'] = nil
				WireLib._SetOutputs(ent)
			end
		end
		ent:SetNW2Bool("fading", false)
	end
end

function TOOL:LeftClick(tr)
	if not checkTrace(tr) then
		return false
	end

	local ent = tr.Entity
	local ply = self:GetOwner()

	dooEet(ply, ent, {
		key      = self:GetClientNumber("key"),
		toggle   = self:GetClientNumber("toggle") == 1, -- тут чекни
		reversed = self:GetClientNumber("reversed") == 1,
		noEffect = self:GetClientNumber("noeffect") == 1
	})

	undo.Create("Fading_Door")
		undo.AddFunction(doUndo, ent)
		undo.SetPlayer(ply)
	undo.Finish()

	return true
end
