include("shared.lua")
ENT.RenderGroup = RENDERGROUP_OPAQUE

surface.CreateFont( "rp_sales_f1", {
	font = "Roboto",
	size = 35,
	weight = 500,
	extended = true
} )

surface.CreateFont( "rp_sales_f2", {
	font = "Roboto",
	size = 40,
	weight = 500,
	extended = true
} )

surface.CreateFont( "rp_sales_f3", {
	font = "Roboto",
	size = 25,
	weight = 500,
	extended = true
} )

function ENT:Draw()
	self:DrawModel()
end

local function MenuProdavca()
	local menu = vgui.Create( "DPanel" )
	menu:SetPos( 0, 0 )
	menu:SetSize(ScrW(), ScrH())
	menu:MakePopup()

	local anim1 = 0
	local anim2 = 0
	local anim3 = 0

	local firstModel = "models/bioshockinfinite/topcorn_bag.mdl"
	local firstName = "Попкорн"
	local firstX = -175
	local firstPrice = 250
	local secondModel = "models/bioshockinfinite/porn_on_cob.mdl"
	local secondName = "Кукуруза"
	local secondX = -175
	local secondPrice = 350

	function menu:Paint( w, h )
		anim2 = Lerp(FrameTime() * 0.85, anim2, 200)
		anim3 = Lerp(FrameTime() * 0.85, anim2, 150)
		draw.RoundedBox( 0,  0, 0, w, h, Color( 0, 0, 0, anim2 ) )

		draw.RoundedBox( 0, ScrW() / 2 - 395, 383, 740, 2, Color( 200,200, 200, anim3-50 ) )
		draw.RoundedBox( 0, ScrW() / 2 - 395, 570, 740, 2, Color( 200,200, 200, anim3-50 ) )

		local icon = vgui.Create( "ModelImage", self )
		icon:SetSize( 200, 100 )
		icon:SetModel( firstModel )
		icon:SetPos(ScrW() /2 - 395, 225)
		icon.LayoutEntity = function( ent ) return end

		draw.SimpleText(firstName, "rp_sales_f2", ScrW() /2 + firstX, 210, Color(255,255,255,anim2))

		local icon = vgui.Create( "ModelImage", self )
		icon:SetSize( 200, 100 )
		icon:SetModel( secondModel )
		icon:SetPos(ScrW() /2 - 395, 425)
		icon.LayoutEntity = function( ent ) return end

		draw.SimpleText(secondName, "rp_sales_f2", ScrW() /2 + secondX, 410, Color(255,255,255,anim2))

		local icon = vgui.Create( "ModelImage", self )
		icon:SetSize( 200, 100 )
		icon:SetModel( "models/bioshockinfinite/hext_candy_chocolate.mdl" )
		icon:SetPos(ScrW() /2 - 395, 625)
		icon.LayoutEntity = function( ent ) return end

		draw.SimpleText("Шоколад", "rp_sales_f2", ScrW() /2 + secondX, 610, Color(255,255,255,anim2))

	end

	local buyFirstTovar = vgui.Create("DButton", menu) -- кнопка покупки для первого товара
	buyFirstTovar:SetPos(ScrW() / 2 + 100, 300)
	buyFirstTovar:SetSize(325, 85)
	buyFirstTovar:SetText("")
	function buyFirstTovar:DoClick()
		net.Start("rp_buyfirst")
			net.WriteString(firstPrice)
		net.SendToServer()
	end
	function buyFirstTovar:Paint( w, h)

		if self:IsHovered() then
			draw.RoundedBox(0, 20, 20, 200, 40, Color(45,45,45, 200))
			draw.SimpleText("Купить за ₮"..firstPrice, "rp_sales_f3", 50, 0 + 25, Color(230,230,230, 230))
		else
			draw.RoundedBox(0, 20, 20, 200, 40, Color(35,35,35, 200))
			draw.SimpleText("Купить", "rp_sales_f3", 80, 0 + 25, Color(255,255,255, 255))
		end
	end


	local buySecTovar = vgui.Create("DButton", menu) -- кнопка покупки для первого товара
	buySecTovar:SetPos(ScrW() / 2 + 100, 475)
	buySecTovar:SetSize(325, 85)
	buySecTovar:SetText("")
	function buySecTovar:DoClick()
		net.Start("rp_buysecond")
			net.WriteString(secondPrice)
		net.SendToServer()
		
	end
	function buySecTovar:Paint( w, h)

		if self:IsHovered() then
			draw.RoundedBox(0, 20, 20, 200, 40, Color(45,45,45, 200))
			draw.SimpleText("Купить за ₮"..secondPrice, "rp_sales_f3", 50, 0 + 25, Color(230,230,230, 230))
		else
			draw.RoundedBox(0, 20, 20, 200, 40, Color(35,35,35, 200))
			draw.SimpleText("Купить", "rp_sales_f3", 80, 0 + 25, Color(255,255,255, 255))
		end
	end

	local buyThirdTovar = vgui.Create("DButton", menu) -- кнопка покупки для первого товара
	buyThirdTovar:SetPos(ScrW() / 2 + 100, 650)
	buyThirdTovar:SetSize(325, 85)
	buyThirdTovar:SetText("")
	function buyThirdTovar:DoClick()
		net.Start("rp_buythird")
			net.WriteString("450")
		net.SendToServer()
	end

	function buyThirdTovar:Paint( w, h)

		if self:IsHovered() then
			draw.RoundedBox(0, 20, 20, 200, 40, Color(45,45,45, 200))
			draw.SimpleText("Купить за ₮"..secondPrice, "rp_sales_f3", 50, 0 + 25, Color(230,230,230, 230))
		else
			draw.RoundedBox(0, 20, 20, 200, 40, Color(35,35,35, 200))
			draw.SimpleText("Купить", "rp_sales_f3", 80, 0 + 25, Color(255,255,255, 255))
		end
	end

	local leavebutton1 = vgui.Create("DButton", menu) -- кнопка выхода
	leavebutton1:SetPos(ScrW() / 2 - 60, ScrH() / 2 + 350)
	leavebutton1:SetSize(325, 85)
	leavebutton1:SetText("")

	function leavebutton1:DoClick()
		menu:Remove()
	end
	function leavebutton1:Paint( w, h)

		anim2 = Lerp(FrameTime() * 0.85, anim2, 225)
		if self:IsHovered() then
			draw.SimpleText("Закрыть", "rp_sales_f3", 0, 0 + 25, Color(255,55,55, anim2))
		else
			draw.SimpleText("Закрыть", "rp_sales_f3", 0, 0 + 25, Color(255,255,255, anim2))
		end
	end

	timer.Simple(60, function()
		menu:Remove()
	end)
end

net.Receive("rp_salesman_food", MenuProdavca)