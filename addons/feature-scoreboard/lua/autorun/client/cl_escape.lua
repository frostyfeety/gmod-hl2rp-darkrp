local rp_esc
local blur = Material( "pp/blurscreen" )
rp_esc_opened = false

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

local function CloseMenu()
	if IsValid(rp_esc) then
		rp_esc:Close()
		rp_esc = nil
	end
end

local buttons = {
	{"Продолжить игру", function() CloseMenu() surface.PlaySound("ambient/water/rain_drip3.wav") rp_esc_opened = false end},
	{"Настройки", function() surface.PlaySound("ambient/water/rain_drip3.wav") CloseMenu() gui.ActivateGameUI() RunConsoleCommand("gamemenucommand", "openoptionsdialog") rp_esc_opened = false end},
	{"Отключиться", function() RunConsoleCommand("gamemenucommand", "disconnect") surface.PlaySound("ambient/water/rain_drip3.wav")  end},
	{"Выйти", function() RunConsoleCommand("gamemenucommand", "quit") surface.PlaySound("ambient/water/rain_drip3.wav") end}
}

local function OpenMenu()

	if IsValid(rp_esc) then rp_esc:Remove() end

	rp_esc = vgui.Create("DFrame")
	rp_esc:SetSize(ScrW(), ScrH())
	rp_esc:Center()
	rp_esc:SetTitle("")
	rp_esc:ShowCloseButton(false)
	rp_esc:SetDraggable(false)
	rp_esc:MakePopup()
	rp_esc.Paint = function(self, w, h)
		matafakablur( self, 5, 10, 255 )
		draw.RoundedBox(0, 0, 0, w, h, Color(50,50,50,55))
	end

	rp_esc.rp_esc = vgui.Create("DPanel", rp_esc)
	rp_esc.rp_esc:SetSize(300, #buttons * 50)
	rp_esc.rp_esc:SetPos(25, rp_esc:GetTall() * 0.75)
	rp_esc.rp_esc.Paint = function() end

	for k, v in pairs(buttons) do
		rp_esc.btn_pnl = vgui.Create("DButton", rp_esc.rp_esc)
		rp_esc.btn_pnl:SetSize(rp_esc.rp_esc:GetWide(), 30)
		rp_esc.btn_pnl:SetPos(0, (k - 1) *  50)
		rp_esc.btn_pnl:SetText("")
		rp_esc.btn_pnl.Paint = function(self, w, h)
			if self:IsHovered() then
				draw.SimpleText(v[1], "rp_scoreboard_title", 13, h * 0.5, Color(255, 255, 255), 0, 1)
			else
				draw.SimpleText(v[1], "rp_scoreboard_title", 13, h * 0.5, Color(170, 170, 170), 0, 1)
			end
		end
		rp_esc.btn_pnl.DoClick = v[2]
	end

end

hook.Add("PreRender", "rp_escape_open_close", function()
	if input.IsKeyDown(70) and gui.IsGameUIVisible() then
		gui.HideGameUI()

		if IsValid(rp_esc) then
			CloseMenu()
			rp_esc_opened = false
		else
			OpenMenu()
			rp_esc_opened = true
		end

		return true
	end
end)

