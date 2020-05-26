local pnl

surface.CreateFont("rp_22sf", {
    font = "Roboto", 
    extended = true, 
    size = 22, 
    antialias = true
})

local function Icon(x, y, w, h, color, icon)
	surface.SetMaterial(icon)
	surface.SetDrawColor(color)
	surface.DrawTexturedRect(x, y, w, h)
end

local card_close = Material("icon16/cancel.png")
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

net.Receive("rp_viewcard", function()

	if (IsValid(pnl)) then return end

	local nick = net.ReadString()
	local cid = net.ReadString()
	local ol = net.ReadString()
	if ol == "0" then
		ol = "Отсутствует"
	end

	pnl = vgui.Create("DFrame")
	pnl:SetSize(590, 220)
	pnl:Center()
	pnl:SetTitle("")
	pnl:ShowCloseButton(false)
	pnl:SetDraggable(false)
	pnl:MakePopup()
	pnl.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, 40, Color(200,200,200, 155))
        matafakablur( self, 5, 5, 155 )
		draw.RoundedBox(0, 0, 40, w, h - 40, Color(99,99,99, 155))
		draw.SimpleText("Идентификационная карта #"..cid, "rp_22sf", 17, 20, Color(55,55,55), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	pnl.cls = vgui.Create("DButton", pnl)
	pnl.cls:SetSize(16, 16)
	pnl.cls:SetPos(pnl:GetWide() - 32, 12)
	pnl.cls:SetText("")
	pnl.cls.Paint = function(self, w, h)
		Icon(0, 0, w, h, Color(155,155,155), card_close)
	end
	pnl.cls.DoClick = function()
		pnl:Close()
		surface.PlaySound("common/wpn_select.wav")
		pnl = nil
	end

	pnl.pnl_mdl = vgui.Create("DPanel", pnl)
	pnl.pnl_mdl:SetSize(122, 144)
	pnl.pnl_mdl:SetPos(36, 76)
	pnl.pnl_mdl.Paint = function(self, w, h)
	end

	pnl.pnl1 = vgui.Create("DPanel", pnl)
	pnl.pnl1:SetSize(185, 190)
	pnl.pnl1:SetPos(90, 76)
	pnl.pnl1.Paint = function(self, w, h)
		draw.SimpleText("Имя лица", "rp_22sf", 0, 7, Color(200,200,200))
		draw.SimpleText("Идентификатор", "rp_22sf", 0, 41, Color(200,200,200))
		draw.SimpleText("Очки Лояльности", "rp_22sf", 0, 75, Color(200,200,200))	
	end

	pnl.pnl2 = vgui.Create("DPanel", pnl)
	pnl.pnl2:SetSize(300, 190)
	pnl.pnl2:SetPos(270, 76)
	pnl.pnl2.Paint = function(self, w, h)
		draw.RoundedBox(0, 10, 28, w - 10, 1, Color(155,155,155))
		draw.SimpleText(nick, "rp_22sf", 9, 7, Color(255,255,255))

		draw.RoundedBox(0, 10, 62, w - 10, 1, Color(155,155,155))
		draw.SimpleText("#"..cid, "rp_22sf", 9, 41, Color(255,255,255))

		draw.RoundedBox(0, 10, 98, w - 10, 1, Color(155,155,155))
		draw.SimpleText(ol, "rp_22sf", 9, 75, Color(255,255,255))
	end

end)
