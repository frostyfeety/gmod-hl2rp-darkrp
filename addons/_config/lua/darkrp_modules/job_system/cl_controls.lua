local panelMeta = FindMetaTable("Panel")
function panelMeta:FadeOut(time, removeOnEnd, callback)
	self:AlphaTo(0, time, 0, function()
		if removeOnEnd then
			if self.OnRemove then
				self:OnRemove()
			end
			self:Remove()
		end
		if callback then
			callback(self)
		end
	end)
end

function panelMeta:FadeIn(time, callback)
	self:SetAlpha(0)
	self:AlphaTo(255, time, 0, function()
		if callback then
			callback(self)
		end
	end)
end

function panelMeta:OnClick(leftClick, rightClick)
	self.OnMousePressed = function(self, type)
		if type == MOUSE_LEFT then
			leftClick(self)
		elseif rightClick && type == MOUSE_RIGHT then
			rightClick(self)
		end
	end
end

/*
	MGradient
*/
local PANEL = {}

function PANEL:Init()
	self.multiplayer = 0
	self:SetSize(ScrW(), ScrH())
end

function PANEL:Paint()
	self.multiplayer = self:GetAlpha()/255

	local tab = {}
	tab[ "$pp_colour_addr" ] = 0
	tab[ "$pp_colour_addg" ] = 0
	tab[ "$pp_colour_addb" ] = 0
	tab[ "$pp_colour_brightness" ] = math.Clamp(-self.multiplayer*0.2, -0.06, 1)
	tab[ "$pp_colour_contrast" ] = math.Clamp(1+self.multiplayer*0.3, 1, 1.1)
	tab[ "$pp_colour_colour" ] = math.Clamp(1+self.multiplayer*0.2, 1, 1.1)
	tab[ "$pp_colour_mulr" ] = 0
	tab[ "$pp_colour_mulg" ] = 0
	tab[ "$pp_colour_mulb" ] = 0
	DrawColorModify( tab )

	if ENABLE_GRADIENT then
		surface.SetDrawColor(255, 255, 255, self.multiplayer * 215)
		surface.SetMaterial(Material("overlay_final.png"))
		surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
	end
end
derma.DefineControl( "MGradient", "", PANEL)


/*
	MPanelList
*/
local PANEL = {}

AccessorFunc(PANEL, "Spacing", "Spacing")
AccessorFunc(PANEL, "Offset", "Offset")
AccessorFunc(PANEL, "Horizontal", "Horizontal")
AccessorFunc(PANEL, "AutoHeight", "AutoHeight")
AccessorFunc(PANEL, "Alpha", "Alpha")

function PANEL:Init()
	self.Items = {}
	self:SetSpacing(4)
	self:SetOffset(10)
	self:SetTall(ScrH())
	self:SetAlpha(255)
	self:SetDrawBackground(true)

	self.ScrollOffset = 0

	self:SetHorizontal(false)
end

function PANEL:AddItem(item)
	item:SetParent(self)
	if self:GetHorizontal() then
		self:SetWide(self:GetWide() + item:GetWide() + self:GetSpacing())
	else
	    /*Famouse*/
		if item:GetWide()+ self:GetOffset() * 2 > self:GetWide() then
			self:SetWide(item:GetWide() + self:GetOffset() * 2)
		end
	end
	if self:GetAutoHeight() then
		self:SetTall(self:GetRealHeight() + item:GetTall() + self:GetSpacing())
	end
	table.insert(self.Items, item)
	self:Rebuild()
end

function PANEL:SetAlpha(alpha)
	for k, v in pairs(self.Items) do
		v:SetAlpha(alpha)
	end
	self.Alpha = alpha
end

function PANEL:Clear()
	for k, v in pairs(self.Items) do
		v:Remove()
	end
	self.ScrollOffset = 0
	self.Items = {}
end

function PANEL:OnMouseWheeled(dlta)
	self:Rebuild(dlta)
end

function PANEL:RemoveItem(item)
	local key = table.KeyFromValue(self.Items,item)
	self.Items[key]:Remove()
	table.remove(self.Items, key)
	self:Rebuild()
end

function PANEL:GetRealHeight()
	local height = self:GetSpacing()
	for k, v in pairs(self.Items) do
		height = height + v:GetTall() + self:GetSpacing()
	end
	return height
end

function PANEL:Rebuild(dlta)
	if dlta && !self:GetHorizontal() then
		if dlta < 0 then
			local height = self:GetRealHeight()
			if (height + self.ScrollOffset > ScrH()) then
				self.ScrollOffset = math.Clamp(self.ScrollOffset + (dlta or 0) * 35, ScrH() - height, 0)
			end
		elseif self.ScrollOffset < 0 then
			self.ScrollOffset = math.min(self.ScrollOffset + (dlta or 0) * 35, 0)
		else
			return
		end
	end
	if self:GetHorizontal() then
		local posX = 0
		for k, v in pairs(self.Items) do
			v:SetPos(posX, self:GetOffset())
			posX = posX + v:GetWide() + self:GetSpacing()
		end
	else
		local posY = 0
		for k, v in pairs(self.Items) do
			v:SetPos(self:GetOffset(), posY + self:GetSpacing() + self.ScrollOffset)
			posY = posY + v:GetTall() + self:GetSpacing()
		end
	end
end

function PANEL:SetDrawBackground(bool)
	self.DrawBackground = bool
end

function PANEL:Paint()
	if self.DrawBackground then
		local multiplayer = self:GetAlpha()/255
		draw.DrawLine(0, 0, 0, self:GetTall(), Color(0, 0, 0, 255*multiplayer))
		draw.DrawLine(self:GetWide()-1, 0, self:GetWide()-1, self:GetTall(), Color(0, 0, 0, 255*multiplayer))
		draw.DrawRect(1, 0, self:GetWide()-2, self:GetTall(), Color(0, 0, 0, 150*multiplayer))
	end
end
derma.DefineControl( "MPanelList", "", PANEL, "EditablePanel")


/*
	MPanel
*/

local PANEL = {}

AccessorFunc(PANEL, "DrawBackground", "DrawBackground")

function PANEL:Init()
	self:SetDrawBackground(true)
end

function PANEL:Paint()
	if self:GetDrawBackground() then
		draw.DrawOutlinedRoundedRect(self:GetWide(), self:GetTall(), Color(0, 0, 0, 255))
		draw.DrawRect(1, 1, self:GetWide()-2, self:GetTall()-2, Color(0, 0, 0, 200))
	end
end

derma.DefineControl("MPanel", "", PANEL, "EditablePanel")


/*
	MModel
*/

local PANEL = {}

AccessorFunc(PANEL, "Hover", "Hover")
AccessorFunc(PANEL, "Alpha", "Alpha")
AccessorFunc(PANEL, "Rotation", "Rotation")

function PANEL:Init()
	self:SetSize(64, 64)
	self:InvalidateLayout( true )
	
	self:SetPos(10, 10)
	self:SetCursor("hand")

	self:SetAlpha(255)

	self:SetFOV( 30 )
	self:SetCamPos( Vector( 60, 30, 30 ) )
	self:SetLookAt( Vector( 0, 0, 0 ) )

	self:SetRotation(true)
end

function PANEL:SetAlpha(alpha)
	self.Alpha = alpha
end

function PANEL:OnCursorEntered(outside)
	self:SetHover(true)
	if !outside then
		self:GetParent():OnCursorEntered()
	end
end

function PANEL:OnCursorExited(outside)
	self:SetHover(false)
	if !outside then
		self:GetParent():OnCursorExited()
	end
end

function PANEL:Paint()
	if ( !IsValid( self.Entity ) ) then return end
	
	local x, y = self:LocalToScreen( 0, 0 )
	
	if self:GetHover() && self:GetRotation() then
		self:LayoutEntity( self.Entity )
	end
	
	local ang = self.aLookAngle
	if ( !ang ) then
	    ang = (self.vLookatPos-self.vCamPos):Angle()
	end
	
	local w, h = self:GetSize()
	cam.Start3D( self.vCamPos, ang, self.fFOV, x, y, w, h, 5, 4096 )
	cam.IgnoreZ( true )
	
	render.SuppressEngineLighting( true )
	render.SetLightingOrigin( self.Entity:GetPos() )
	render.ResetModelLighting( self.colAmbientLight.r/255, self.colAmbientLight.g/255, self.colAmbientLight.b/255 )
	render.SetColorModulation( self.colColor.r/255, self.colColor.g/255, self.colColor.b/255 )
	render.SetBlend( self:GetAlpha()/255 )
	for i=0, 6 do
		local col = self.DirectionalLight[ i ]
		if ( col ) then
			render.SetModelLighting( i, col.r/255, col.g/255, col.b/255 )
		end
	end

	self.Entity:DrawModel()
	render.SuppressEngineLighting( false )
	cam.IgnoreZ( false )
	cam.End3D()

	self.LastPaint = RealTime()
end

function PANEL:OnMousePressed(code)
	self:GetParent():OnMousePressed(code)
end

function PANEL:LayoutEntity( Entity )
    if ( self.bAnimated ) then
        self:RunAnimation()
    end
    
    self.LastAngle = (self.LastAngle or 0) + 0.25
    Entity:SetAngles( Angle( 0, self.LastAngle,  0) )
end

derma.DefineControl( "MModel", "", PANEL, "DModelPanel")


/*
	MModelPanel
*/

local PANEL = {}

AccessorFunc(PANEL, "HeaderText", "HeaderText")
AccessorFunc(PANEL, "DescText", "DescText")
AccessorFunc(PANEL, "BGColor", "BGColor")
AccessorFunc(PANEL, "OldBGColor", "OldBGColor")
AccessorFunc(PANEL, "HeaderColor", "HeaderColor")

function PANEL:Init()
	self:SetSize(1000, 80)
	self:SetHeaderText("Label")
	self:SetDescText("Label")

	self.Model = vgui.Create("MModel")
	self:SetModel("models/weapons/w_rif_galil.mdl")
	self.Model:SetParent(self)

	self:SetBGColor(Color(30, 30, 30, 210))
	self:SetOldBGColor(Color(30, 30, 30, 210))

	self:SetHeaderColor(COLOR_HOVER)

	self:SetCursor("hand")

	self.oldAFunc = self.SetAlpha
	self.SetAlpha = function(self, alpha)
		self:oldAFunc(alpha)
	end

end

function PANEL:SetHeaderText(text)
	self.HeaderText = string.upper(text)
end

function PANEL:SetDescText(text)
	self.DescText = text

	local x, y = surface.GetTextWidth(text, "TextFont")
	self:SetTall(math.max(y + 45, 80))
end

function PANEL:SetBGColor(color)
	self:SetOldBGColor(self:GetBGColor() or color)
	self.BGColor = color
end

function PANEL:OnCursorEntered()
	self:SetBGColor(Color(30, 30, 30, 235))
	self.Model:OnCursorEntered(true)
end

function PANEL:OnCursorExited()
	self:SetBGColor(Color(30, 30, 30, 200))
	self.Model:OnCursorExited(true)
end

function PANEL:SetModel(model)
	self.Model:SetModel(model)
end

function PANEL:OnMousePressed()
end

function PANEL:Paint()
	draw.DrawOutlinedRoundedRect(self:GetWide(), self:GetTall(), Color(0, 0, 0, 255))

	self:SetOldBGColor(LerpColor(0.2, self:GetOldBGColor(), self:GetBGColor()))
	draw.DrawRect(1, 1, self:GetWide()-2, self:GetTall()-2, self:GetOldBGColor())

	surface.DrawShadowText(self:GetHeaderText(), "HeaderFont2", 90, 3, self:GetHeaderColor(), COLOR_BLACK, TEXT_ALIGN_LEFT)

	local r,g,b,a = tostring(COLOR_BLACK.r), tostring(COLOR_BLACK.g), tostring(COLOR_BLACK.b), tostring(COLOR_BLACK.a)
	local text = markup.Parse("<font=TextFont><color="..r..","..g..","..b..","..a..">"..self:GetDescText().."</color></font>")

	text:Draw(91, 35)
	
	local r,g,b,a = tostring(COLOR_WHITE.r), tostring(COLOR_WHITE.g), tostring(COLOR_WHITE.b), tostring(COLOR_WHITE.a)
	local text = markup.Parse("<font=TextFont><color="..r..","..g..","..b..","..a..">"..self:GetDescText().."</color></font>")

	text:Draw(90, 34)

	return true
end
derma.DefineControl( "MModelPanel", "", PANEL)


/*
	MButton
*/

local PANEL = {}

AccessorFunc(PANEL, "Text", "Text")
AccessorFunc(PANEL, "Font", "Font")
AccessorFunc(PANEL, "Color", "Color")
AccessorFunc(PANEL, "OldColor", "OldColor")
AccessorFunc(PANEL, "Uppercase", "Uppercase")

function PANEL:Init()
	self:SetColor(COLOR_WHITE)
	self:SetFont("HeaderFont")
	self:SetUppercase(false)
	self:SetCursor("hand")
	self:SetColor(COLOR_WHITE)
end

function PANEL:SetText(text)
	if self:GetUppercase() || string.find(self:GetFont(), "HeaderFont") then
		text = string.upper(text)
	end
	self:SetSize(surface.GetTextWidth(text, self:GetFont()))
	self.Text = text
end

function PANEL:SetColor(color)
	self:SetOldColor(self:GetColor() or color)
	self.Color = color
end

function PANEL:OnCursorEntered()
	self:SetColor(COLOR_HOVER)
end

function PANEL:OnCursorExited()
	self:SetColor(COLOR_WHITE)
end

function PANEL:Paint()
	self:SetOldColor(LerpColor(0.1, self:GetOldColor(), self:GetColor()))
	surface.DrawShadowText(self:GetText(), self:GetFont(), 0, 0, self:GetOldColor(), COLOR_BLACK, TEXT_ALIGN_LEFT)
end
derma.DefineControl( "MButton", "", PANEL)


/*
	MLabel
*/

local PANEL = {}

AccessorFunc(PANEL, "Text", "Text")
AccessorFunc(PANEL, "Font", "Font")
AccessorFunc(PANEL, "Color", "Color")
AccessorFunc(PANEL, "Uppercase", "Uppercase")
AccessorFunc(PANEL, "TextAlign", "TextAlign")
function PANEL:Init()
	self:SetColor(COLOR_WHITE)
	self:SetFont("HeaderFont")
	self:SetUppercase(false)
	self:SetColor(COLOR_WHITE)
	self:SetTextAlign(TEXT_ALIGN_LEFT)
end

function PANEL:SetText(text)
	if self:GetUppercase() || string.find(self:GetFont(), "HeaderFont") then
		text = string.upper(text)
	end
	self:SetSize(surface.GetTextWidth(text, self:GetFont()))
	self.Text = text
end

function PANEL:Paint()
	surface.DrawShadowText(self:GetText(), self:GetFont(), 0, 0, self:GetColor(), COLOR_BLACK, self:GetTextAlign())
end
derma.DefineControl( "MLabel", "", PANEL)


local lastItem
function RemoveLastItem()
	if lastItem && lastItem:IsValid() then lastItem:FadeOut(FADE_DELAY, true) end
end
hook.Add("VGUIMousePressed", "RemoveLastItem", function(panel)
	if lastItem && lastItem:IsValid() && !((panel == lastItem) || (panel:GetParent() && panel:GetParent():IsValid() && panel:GetParent() == lastItem)) then RemoveLastItem() end
end)

/*
	MList
*/
local PANEL = {}

AccessorFunc(PANEL, "Parent", "Parent")
AccessorFunc(PANEL, "Hover", "Hover")

function PANEL:Init()
	self.Items = {}
	self:SetSize(0, 0)

	self:FadeIn(FADE_DELAY/2)

	//self:MakePopup()

	RemoveLastItem()
	lastItem = self

	self:MakePopup()
end

function PANEL:SetParent(parent)
	self.Parent = parent
end

function PANEL:AddItem(text, func)
	local button
	if func then
		button = vgui.Create("MButton")
		button:SetFont("TextFont")
		button:SetUppercase(false)
		button:SetText(text)
		button:OnClick(function(self)
			func(self)
			self:GetParent():FadeOut(FADE_DELAY, true)
		end)
	else
		button = vgui.Create("MLabel")
		button:SetFont("TextFont")
		button:SetUppercase(false)
		button:SetText(text)
	end
	button:SetParent(self)
	table.insert(self.Items, button)
	self:Rebuild()
end

function PANEL:Clear()
	for k, v in pairs(self.Items) do
		v:Remove()
	end
	self:Rebuild()
end

function PANEL:Rebuild()
	local posY = 7
	for k,v in pairs(self.Items) do
		v:SetPos(8, posY)
		posY = posY + v:GetTall() + 1
		if v:GetWide() > self:GetWide() - 16 then self:SetWide(v:GetWide() + 16) end
	end
	self:SetSize(self:GetWide(), posY + 7)
	self:SetPos(math.Clamp(gui.MouseX() + 1, 0, ScrW() - self:GetWide()), math.Clamp(gui.MouseY()-self:GetTall()/2, 0, ScrH() - self:GetTall()))
end

function PANEL:OnRemove()
	for k, v in pairs(self.Items) do
		v:Remove()
	end
end

function PANEL:Paint()
	draw.DrawRect(0, 0, self:GetWide(), self:GetTall(), Color(0, 0, 0, 250))
end

derma.DefineControl("MList", "", PANEL, "EditablePanel")
