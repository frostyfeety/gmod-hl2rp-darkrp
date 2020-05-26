
local matClose = Material("icon16/cancel.png", "noclamp smooth")
local matList = Material("icon16/bullet_toggle_plus.png", "noclamp smooth")

local font = LOUNGE_F4.Font
local font_bold = LOUNGE_F4.FontBold

--
local F4Bind

function L_QuickLabel(t, f, c, p)
	local l = vgui.Create("DLabel", p)
	l:SetText(t)
	l:SetFont(f)
	l:SetColor(c)
	l:SizeToContents()

	return l
end

function L_PaintScroll(panel)
	local styl = LOUNGE_F4.Style

	local scr = panel:GetVBar()
	scr.Paint = function(_, w, h)
		draw.RoundedBox(4, 0, 0, w, h, styl.bg)
	end

	scr.btnUp.Paint = function(_, w, h)
		draw.RoundedBox(4, 2, 0, w - 4, h - 2, styl.inbg)
	end
	scr.btnDown.Paint = function(_, w, h)
		draw.RoundedBox(4, 2, 2, w - 4, h - 2, styl.inbg)
	end

	scr.btnGrip.Paint = function(me, w, h)
		draw.RoundedBox(4, 2, 0, w - 4, h, styl.inbg)

		if (me.Hovered) then
			draw.RoundedBox(4, 2, 0, w - 4, h, styl.hover2)
		end

		if (me.Depressed) then
			draw.RoundedBox(4, 2, 0, w - 4, h, styl.hover2)
		end
	end
end

function L_StringRequest(title, text, callback)
	local styl = LOUNGE_F4.Style

	if (IsValid(_LOUNGE_F4_STRREQ)) then
		_LOUNGE_F4_STRREQ:Remove()
	end

	local scale = _LOUNGE_F4_SCALE
	local wi, he = 600 * scale, 160 * scale

	local cancel = vgui.Create("DPanel")
	cancel:SetDrawBackground(false)
	cancel:StretchToParent(0, 0, 0, 0)
	cancel:MoveToFront()
	cancel:MakePopup()

	local pnl = vgui.Create("EditablePanel")
	pnl:SetSize(wi, he)
	pnl:Center()
	pnl:MakePopup()
	pnl.m_fCreateTime = SysTime()
	pnl.Paint = function(me, w, h)
		Derma_DrawBackgroundBlur(me, me.m_fCreateTime)
		draw.RoundedBox(4, 0, 0, w, h, styl.bg)
	end
	pnl.Close = function(me)
		if (me.m_bClosing) then
			return end

		me.m_bClosing = true
		me:AlphaTo(0, 0.1, 0, function()
			me:Remove()
		end)
	end
	_LOUNGE_F4_STRREQ = pnl

	cancel.OnMouseReleased = function(me, mc)
		if (mc == MOUSE_LEFT) then
			pnl:Close()
		end
	end
	cancel.Think = function(me)
		if (!IsValid(pnl)) then
			me:Remove()
		end
	end

		local th = 48 * scale
		local m = th * 0.25

		local header = vgui.Create("DPanel", pnl)
		header:SetTall(th)
		header:Dock(TOP)
		header.Paint = function(me, w, h)
			draw.RoundedBoxEx(4, 0, 0, w, h, styl.header, true, true, false, false)
		end

			local titlelbl = L_QuickLabel(title, "F4_LOUNGE_Larger", styl.text, header)
			titlelbl:Dock(LEFT)
			titlelbl:DockMargin(m, 0, 0, 0)

			local close = vgui.Create("DButton", header)
			close:SetText("")
			close:SetWide(th)
			close:Dock(RIGHT)
			close.Paint = function(me, w, h)
				if (me.Hovered) then
					draw.RoundedBoxEx(4, 0, 0, w, h, styl.close_hover, false, true, false, false)
				end

				if (me:IsDown()) then
					draw.RoundedBoxEx(4, 0, 0, w, h, styl.hover, false, true, false, false)
				end

				surface.SetDrawColor(me:IsDown() and styl.text_down or styl.text)
				surface.SetMaterial(matClose)
				surface.DrawTexturedRectRotated(w * 0.5, h * 0.5, 16 * scale, 16 * scale, 0)
			end
			close.DoClick = function(me)
				pnl:Close()
			end

		local body = vgui.Create("DPanel", pnl)
		body:SetDrawBackground(false)
		body:Dock(FILL)
		body:DockPadding(m, m, m, m)

			local tx = L_QuickLabel(text, "F4_LOUNGE_Large", styl.text, body)
			tx:SetContentAlignment(5)
			tx:SetWrap(tx:GetWide() > wi - m * 2)
			tx:Dock(FILL)

			local apply = vgui.Create("DButton", body)
			apply:SetText("OK")
			apply:SetColor(styl.text)
			apply:SetFont("F4_LOUNGE_Medium")
			apply:Dock(BOTTOM)
			apply.Paint = function(me, w, h)
				draw.RoundedBox(4, 0, 0, w, h, styl.inbg)

				if (me.Hovered) then
					surface.SetDrawColor(styl.hover)
					surface.DrawRect(0, 0, w, h)
				end

				if (me:IsDown()) then
					surface.SetDrawColor(styl.hover)
					surface.DrawRect(0, 0, w, h)
				end
			end

			local entry = vgui.Create("DTextEntry", body)
			entry:RequestFocus()
			entry:SetFont("F4_LOUNGE_Medium")
			entry:SetDrawLanguageID(false)
			entry:Dock(BOTTOM)
			entry:DockMargin(0, m, 0, m)
			entry.Paint = function(me, w, h)
				draw.RoundedBox(4, 0, 0, w, h, styl.textentry)
				me:DrawTextEntryText(me:GetTextColor(), me:GetHighlightColor(), me:GetCursorColor())
			end
			entry.OnEnter = function()
				apply:DoClick()
			end

			apply.DoClick = function()
				pnl:Close()
				callback(entry:GetValue())
			end

	pnl.OnFocusChanged = function(me, gained)
		if (!gained) then
			timer.Simple(0, function()
				if (!IsValid(me) or vgui.GetKeyboardFocus() == entry) then
					return end

				me:Close()
			end)
		end
	end

	pnl:SetWide(math.min(tx:GetWide() + m * 2, pnl:GetWide()))
	pnl:CenterHorizontal()

	pnl:SetAlpha(0)
	pnl:AlphaTo(255, 0.1)
end

function L_Menu()
	local styl = LOUNGE_F4.Style

	if (IsValid(_LOUNGE_F4_MENU)) then
		_LOUNGE_F4_MENU:Remove()
	end

	local th = 48 * _LOUNGE_F4_SCALE
	local m = th * 0.25

	local cancel = vgui.Create("DPanel")
	cancel:SetDrawBackground(false)
	cancel:StretchToParent(0, 0, 0, 0)
	cancel:MoveToFront()
	cancel:MakePopup()

	local pnl = vgui.Create("DPanel")
	pnl:SetDrawBackground(false)
	pnl:SetSize(20, 1)
	pnl.AddOption = function(me, text, callback)
		surface.SetFont("F4_LOUNGE_MediumB")
		local wi, he = surface.GetTextSize(text)
		wi = wi + m * 2
		he = he + m

		me:SetWide(math.max(wi, me:GetWide()))
		me:SetTall(pnl:GetTall() + he)

		local btn = vgui.Create("DButton", me)
		btn:SetText(text)
		btn:SetFont("F4_LOUNGE_MediumB")
		btn:SetColor(styl.text)
		btn:Dock(TOP)
		btn:SetSize(wi, he)
		btn.Paint = function(me, w, h)
			surface.SetDrawColor(styl.menu)
			surface.DrawRect(0, 0, w, h)

			if (me.Hovered) then
				surface.SetDrawColor(styl.hover)
				surface.DrawRect(0, 0, w, h)
			end

			if (me:IsDown()) then
				surface.SetDrawColor(styl.hover)
				surface.DrawRect(0, 0, w, h)
			end
		end
		btn.DoClick = function(me)
			callback()
			pnl:Close()
		end
	end
	pnl.Open = function(me)
		me:SetPos(gui.MouseX(), gui.MouseY())
		me:MakePopup()
	end
	pnl.Close = function(me)
		if (me.m_bClosing) then
			return end

		me.m_bClosing = true
		me:AlphaTo(0, 0.1, 0, function()
			me:Remove()
		end)
	end
	_LOUNGE_F4_MENU = pnl

	cancel.OnMouseReleased = function(me, mc)
		pnl:Close()
	end
	cancel.Think = function(me)
		if (!IsValid(pnl)) then
			me:Remove()
		end
	end

	return pnl
end

local function attachCurrency(str)
    local config = GAMEMODE.Config
	if (!config) then
		return "T" .. str
	end

	local cr = config.currency or "T"
    return config.currencyLeft and cr .. str or str .. cr
end

function LOUNGE_F4.formatMoney(n)
	if (DarkRP and DarkRP.formatMoney) then
		return DarkRP.formatMoney(n)
	else
		if not n then return attachCurrency("0") end

		if n >= 1e14 then return attachCurrency(tostring(n)) end
		if n <= -1e14 then return "-" .. attachCurrency(tostring(math.abs(n))) end

		local negative = n < 0

		n = tostring(math.abs(n))
		local sep = sep or ","
		local dp = string.find(n, "%.") or #n + 1

		for i = dp - 4, 1, -3 do
			n = n:sub(1, i) .. sep .. n:sub(i + 1)
		end

		return (negative and "-" or "") .. attachCurrency(n)
	end
end

function LOUNGE_F4:Show()
	if (IsValid(_LOUNGE_F4)) then
		_LOUNGE_F4:Remove()
	end
	if (IsValid(_LOUNGE_F4_MDLSEL)) then
		_LOUNGE_F4_MDLSEL:Remove()
	end

	local curpage

	local scale = math.Clamp(ScrH() / 1080, 0.7, 1)
	_LOUNGE_F4_SCALE = scale

	surface.CreateFont("F4_LOUNGE_Medium", {font = font, size = 16 * scale})
	surface.CreateFont("F4_LOUNGE_Large", {font = font, size = 20 * scale})
	surface.CreateFont("F4_LOUNGE_Larger", {font = font, size = 24 * scale})
	surface.CreateFont("F4_LOUNGE_MediumB", {font = font_bold, size = 16 * scale})
	surface.CreateFont("F4_LOUNGE_LargeB", {font = font_bold, size = 20 * scale})
	surface.CreateFont("F4_LOUNGE_LargerB", {font = font_bold, size = 24 * scale})
	surface.CreateFont("F4_LOUNGE_LargestB", {font = font_bold, size = 32 * scale})

	local wi, he = 1000 * scale, 650 * scale

	local pnl = vgui.Create("EditablePanel")
	pnl:SetSize(wi, he)
	pnl:Center()
	pnl:MakePopup()
	pnl.m_bF4Down = true
	pnl.Think = function(me)
		F4Bind = F4Bind or input.KeyNameToNumber(input.LookupBinding("gm_showspare2"))
		if (!F4Bind) then
			return end

		if (me.m_bF4Down and not input.IsKeyDown(F4Bind)) then
			me.m_bF4Down = false
			return
		elseif (!me.m_bF4Down and input.IsKeyDown(F4Bind)) then
			me.m_bF4Down = true
			me:Close()
		end
	end
	pnl.Paint = function(me, w, h)
		-- draw.RoundedBox(4, 0, 0, w, h, self.Style.bg)
	end
	pnl.Close = function(me)
		if (me.m_bClosing) then
			return end

		me.m_bClosing = true
		me:AlphaTo(0, 0.1, 0, function()
			me:Remove()
			_F4_LOUNGE_RESIZING = false
		end)

		me:OnClose()
	end
	pnl.OnClose = function()
		if (IsValid(_LOUNGE_F4_MDLSEL)) then
			_LOUNGE_F4_MDLSEL:Close()
		end
	end
	_LOUNGE_F4 = pnl

		local th = 48 * scale
		local m = th * 0.25

		local header = vgui.Create("DPanel", pnl)
		header:SetTall(th)
		header:Dock(TOP)
		header.Paint = function(me, w, h)
			draw.RoundedBoxEx(4, 0, 0, w, h, self.Style.header, true, true, false, false)
		end

			local title = self.Title .. " - "

			local titlelbl = L_QuickLabel(title, "F4_LOUNGE_Larger", self.Style.text, header)
			titlelbl:Dock(LEFT)
			titlelbl:DockMargin(m, 0, 0, 0)

			local close = vgui.Create("DButton", header)
			close:SetText("")
			close:SetWide(th)
			close:Dock(RIGHT)
			close.Paint = function(me, w, h)
				if (me.Hovered) then
					draw.RoundedBoxEx(4, 0, 0, w, h, self.Style.close_hover, false, true, false, false)
				end

				if (me:IsDown()) then
					draw.RoundedBoxEx(4, 0, 0, w, h, self.Style.hover, false, true, false, false)
				end

				surface.SetDrawColor(me:IsDown() and self.Style.text_down or self.Style.text)
				surface.SetMaterial(matClose)
				surface.DrawTexturedRectRotated(w * 0.5, h * 0.5, 16 * scale, 16 * scale, 0)
			end
			close.DoClick = function(me)
				pnl:Close()
			end

		local body = vgui.Create("DPanel", pnl)
		body:SetDrawBackground(false)
		body:Dock(FILL)

			local curbg

			local contents = vgui.Create("DPanel", body)
			contents:SetDrawBackground(false)
			contents:SetWide(wi - th)
			contents:DockPadding(m, m, m, m)
			contents:Dock(FILL)
			contents.m_iBorder = m
			contents.Paint = function(me, w, h)
				if (curbg) then
					draw.RoundedBoxEx(4, 0, 0, w, h, curbg, false, false, false, true)
				end
			end

			local toggled = cookie.GetNumber("LoungeF4_ToggleOff", 0) == 0

			local navbar = vgui.Create("DScrollPanel", body)
			navbar:GetVBar():Dock(NODOCK)
			navbar:GetVBar():SetWide(0)
			navbar:GetVBar():SetPos(500, 500) -- get the fuck out
			navbar:SetWide(toggled and th * 3 or th)
			navbar:Dock(LEFT)
			navbar:DockPadding(0, th, 0, 0)
			navbar.Paint = function(me, w, h)
				draw.RoundedBoxEx(4, 0, 0, w, h, self.Style.inbg, false, false, true, false)
			end

				local togglenavbar = vgui.Create("DButton", navbar)
				togglenavbar:SetText("")
				togglenavbar:SetToolTip(LOUNGE_F4.Language.toggle)
				togglenavbar:SetSize(th, th)
				togglenavbar:Dock(TOP)
				togglenavbar.Paint = function(me, w, h)
					surface.SetDrawColor(self.Style.text)
					surface.SetMaterial(matList)
					surface.DrawTexturedRectRotated(24 * scale, h * 0.5, 24 * scale, 24 * scale, 0)
				end
				togglenavbar.DoClick = function()
					toggled = !toggled
					cookie.Set("LoungeF4_ToggleOff", toggled and 0 or 1)

					_F4_LOUNGE_RESIZING = true
					navbar:Stop()
					navbar:SizeTo(toggled and th * 3 or th, -1, 0.1, 0, 0.2, function()
						_F4_LOUNGE_RESIZING = false
					end)
				end

				local switchfrom

				local pages = {}
				local bottom = {}
				for _, v in pairs (LOUNGE_F4.Pages) do
					table.insert(v.bottom and bottom or pages, v)
				end

				if (DarkRP and DarkRP.addF4MenuTab) then
					function DarkRP.addF4MenuTab(title, pnl)
						if (!ispanel(pnl)) then
							return end

						pnl:SetVisible(false)

						table.insert(pages, {
							text = title,
							id = "c_" .. title,
							icon = self.CustomTabNameIcon[title],
							switchfrom = function(me, cont)
								if (!IsValid(pnl)) then
									return end

								pnl:SetVisible(false)
								pnl:SetParent(NULL)
							end,
							callback = function(me, cont)
								cont:Clear()

								if (!IsValid(pnl)) then
									return end

								if (pnl.Refresh and !pnl.m_bRefreshed) then
									pnl:Refresh()
									pnl.m_bRefreshed = true
								end

								pnl:SetVisible(true)
								pnl:SetParent(cont)
								pnl:Dock(FILL)
							end,
						})
					end

					hook.Call("F4MenuTabs")
				end

				table.Add(pages, bottom)

				for _, page in ipairs (pages) do
					if (page.display and !page.display()) or (page.enable == false) then
						continue end

					local tx = LOUNGE_F4.Language[page.text] or page.text

					local btn = vgui.Create("DButton", navbar)
					btn:SetText("")
					btn:SetToolTip(tx)
					btn:SetTall(th)
					btn:Dock(TOP)
					btn.Paint = function(me, w, h)
						if (me.Hovered) then
							surface.SetDrawColor(self.Style.hover)
							surface.DrawRect(0, 0, w, h)
						end

						if (me:IsDown()) then
							surface.SetDrawColor(self.Style.hover)
							surface.DrawRect(0, 0, w, h)
						end

						if (page.icon) then
							surface.SetDrawColor(self.Style.text)
							surface.SetMaterial(page.icon)
							surface.DrawTexturedRectRotated(24 * scale, 24 * scale, 24 * scale, 24 * scale, 0)
						end

						if (curpage == page.id) then
							surface.SetDrawColor(self.Style.header)
							surface.DrawRect(0, 0, th * 0.1, h)
						end
					end
					btn.DoClick = function()
						if (curpage == page.id) then
							return end

						if (switchfrom) then
							switchfrom(self, contents)
						end

						if ((page.callback and page.callback(self, contents)) == false or (self.Tabs[page.id] and self.Tabs[page.id](self, contents)) == false) then
							return end

						curbg = page.bg or self.Style.bg
						curpage = page.id
						switchfrom = page.switchfrom

						titlelbl:SetText(title .. tx)
						titlelbl:SizeToContents()
					end

						local lbl = L_QuickLabel(tx, "F4_LOUNGE_Medium", self.Style.text, btn)
						lbl:Dock(LEFT)
						lbl:DockMargin(th, 0, 0, 0)

					if (!curpage) then
						btn:DoClick()
					end
				end

	pnl:SetAlpha(0)
	pnl:AlphaTo(255, 0.1)
end

local keyNames
local function KeyNameToNumber(str)
    if not keyNames then
        keyNames = {}
        for i = 1, 107, 1 do
            keyNames[input.GetKeyName(i)] = i
        end
    end

    return keyNames[str]
end

hook.Add("PlayerBindPress", "LOUNGE_F4_Bind", function(ply, bind, pressed)
    if (string.find(bind, "gm_showspare2", 1, true)) then
        F4Bind = KeyNameToNumber(input.LookupBinding(bind))
		if (!DarkRP.toggleF4Menu) then
			LOUNGE_F4:Show()
		else
			DarkRP.openF4Menu()
		end
    end
end)

hook.Add("InitPostEntity", "LOUNGE_F4_Override", function()
	function DarkRP.openF4Menu()
		LOUNGE_F4:Show()
	end

	function DarkRP.closeF4Menu()
		if (IsValid(_LOUNGE_F4)) then
			_LOUNGE_F4:Close()
		end
	end

	hook.Remove("PlayerBindPress", "DarkRPF4Bind")
end)
