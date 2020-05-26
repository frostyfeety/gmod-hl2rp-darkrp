local blur = Material( "pp/blurscreen" )

local function matafakablur( panel, layers, density, alpha )

	local x, y = panel:LocalToScreen(0, 0)

	surface.SetDrawColor( 255, 255, 255, alpha )
	surface.SetMaterial( blur )

	for i = 1, 3 do
	blur:SetFloat( "$blur", ( i / layers ) * density )
	blur:Recompute()

	render.UpdateScreenEffectTexture()
	surface.DrawTexturedRect( -x, -y, ScrW(), ScrH() )
	end

end

local rp_ranks = {
	['vip'] = {
		name = 'VIP', 
		icon = 'icon16/ruby.png'
	},
	['founder'] = {
		name = 'Основатель', 
		icon = 'icon16/bullet_key.png'
	},
	['dev'] = {
		name = 'Разработчик', 
		icon = 'icon16/bullet_wrench.png'
	},
	['admin'] = {
		name = 'Администратор', 
		icon = 'icon16/asterisk_orange.png'
	},
	['manager'] = {
		name = 'Менеджер', 
		icon = 'icon16/asterisk_yellow.png'
	},
}

surface.CreateFont( "rp_player_text", {
	extended = true,
	font = "Roboto",
	size = 20,
	weight = 500,
	antialias = true,
})

surface.CreateFont( "rp_scoreboard_title", {
	extended = true,
	font = "Calibri",
	size = 35,
	weight = 800,
	antialias = true,
})

do
	local PANEL = {}
	AccessorFunc( PANEL, "rp_scoreboard_base", "Player")

	function PANEL:Init()
		self:Dock(TOP)
		self:SetTall(24)

		self.imgHeart = self:Add("DImage")
		self.imgHeart:SetImage("icon16/heart.png")
		self.imgHeart:SetSize(16, 11)
		self.imgHeart:Dock(LEFT)
		self.imgHeart:DockMargin(5,6.5,0,6.5)
		self.imgHeart:SetTooltip("")
		self.imgHeart:SetMouseInputEnabled(true)
		self.imgHeart:SetVisible(false)

		self.Name = self:Add("DLabel")
		self.Name:Dock(LEFT)
		self.Name:DockMargin(5,0,0,0)
		self.Name:SetFont("rp_player_text")
		self.Name:SetText("Unnamed")
		self.Name:SetWide(300)

	end

	function PANEL:Paint(w,h)
		local ply = self:GetPlayer()
		draw.RoundedBox(0,0,0,w,h-0.1,team.GetColor( IsValid(ply) and ply:Team() or (self.LastTeam or nil) ))

		if IsValid(self:GetPlayer()) then
			local ply = self:GetPlayer()
			draw.DrawText( team.GetName(ply:Team()), "rp_player_text", w-35, 0, Color(255,255,255), TEXT_ALIGN_RIGHT )
			draw.DrawText( "#"..ply:GetRP_ID(), "rp_player_text", ScrW()/3.8, 0, Color(255,255,255), TEXT_ALIGN_RIGHT )
			self.Name:SetText(ply:Name())
			self.LastTeam = ply:Team()
			self.LastID64 = ply:SteamID64()
			local rp_group = self.Player:GetUserGroup()
			
			if rp_group ~= "user" then
				if rp_ranks[rp_group] and rp_ranks[rp_group].icon then
			        self.imgHeart:SetImage(rp_ranks[rp_group].icon)
			        self.imgHeart:SetTooltip(rp_ranks[rp_group].name)
			        self.imgHeart:SetVisible(true)
		    	end
			end
		else
			if not self.Hidden then
				self.Hidden = true
				self:AlphaTo(0, 1)
			end
		end
		
	end

	function PANEL:DoClick()
		print(1)
	end

	function PANEL:SetupPlayer(ply)
		self:SetPlayer(ply)
		self.Name:SetText(ply:GetName())
		self.Player = ply	
	end

	vgui.Register( "ScoreboardPlayer", PANEL, "EditablePanel" )
end

do
	local PANEL = {}

	function PANEL:UpdateList(sort)
		self:Clear()

		local tbl = player.GetAll()

		table.sort( tbl, sort or function(f,l)
			return f:Team() > l:Team()
		end)

		for k,v in pairs(tbl) do
			self:Add("ScoreboardPlayer"):SetupPlayer(v)
		end
	end

	vgui.Register("ScoreboardList", PANEL, "DScrollPanel")
end

do
	local PANEL = {}
	function PANEL:Init()
		self:SetSize(ScrW()*0.50,ScrH()*0.90)
		self:SetTitle("")
		self:Center()
		self:ShowCloseButton(false)		
		self.PlayerList = self:Add("ScoreboardList")
		self.PlayerList:Dock(FILL)
		self.PlayerList:DockMargin(0,25,0,0)
		self.PlayerList:UpdateList()
		self.PlayerList.Paint = function(self,w,h)
			surface.SetDrawColor( 70, 68, 90, 255 )
			surface.DrawOutlinedRect( 0, 0, self:GetWide(), self:GetTall() )
		end

	end

local function showWindow(self)
	if not self.oldPos then
		self.oldPos = { self:GetPos() }
		self.oldPos[2] = self.oldPos[2] - 10
	end

	self:SetVisible(true)
	if self.showFunc then self:showFunc(true) end
	self:MoveToFront()
	self:MoveTo(self.oldPos[1], self.oldPos[2], 0.2, 0, 0.5)
	self:AlphaTo(255, 0.2, 0)
end

function PANEL:Paint(w,h)
		matafakablur( self, 5, 10, 150 )
		surface.SetDrawColor( 70, 68, 90, 255 )
		surface.DrawOutlinedRect( 0, 0, self:GetWide(), self:GetTall() )
		surface.SetDrawColor( 0, 0, 50, 50 )
		surface.DrawRect( 1, 1, self:GetWide() - 2, self:GetTall() - 2 )

		surface.SetFont( "rp_scoreboard_title" )

		local message = "Онлайн: ("..#player.GetAll().."/"..game.MaxPlayers()..")"
		local width1, height1 = surface.GetTextSize( message )
		draw.RoundedBox(0,0,0,w,h,Color(0,0,0,140))

		draw.DrawText(message, "rp_scoreboard_title", w/2, 10, Color(255,255,255), TEXT_ALIGN_CENTER)
		showWindow(self)
	end
	

	function PANEL:Think()
		if not vgui.CursorVisible() then
				self.CursorActivatedFromTab = true
				gui.EnableScreenClicker(true)
		end
	end

	function PANEL:HideOverride()
		self:Hide()
		if self.CursorActivatedFromTab then
			self.CursorActivatedFromTab = nil
			gui.EnableScreenClicker(false)
		end
	end

	vgui.Register("Scoreboard", PANEL, "DFrame")
end

if IsValid(Scoreboard) then
	Scoreboard:Remove()
end

hook.Add( "ScoreboardShow", "CustomScoreboard", function()
	if not IsValid(Scoreboard) then
		Scoreboard = vgui.Create("Scoreboard")
	else
		Scoreboard:Show()
		Scoreboard.PlayerList:UpdateList()
	end

	return false
end)

hook.Add( "ScoreboardHide", "CustomScoreboard", function()
	if IsValid(Scoreboard) then
		Scoreboard:HideOverride()
	end
	return false
end)