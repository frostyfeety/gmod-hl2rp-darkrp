
local function GetUserGroup(ply)
	if (LOUNGE_F4.UsergroupMode == 1) then
		return serverguard.player:GetRank(ply)
	else
		return ply:GetUserGroup()
	end
end

LOUNGE_F4.Tabs.commands = function(self, contents)
	contents:Clear()

	local scale = _LOUNGE_F4_SCALE

	local b = contents.m_iBorder
	local b5 = b * 0.5

	local cmds = contents:Add("DPanel")
	cmds:SetDrawBackground(false)
	cmds:Dock(FILL)

		local search = cmds:Add("DPanel")
		search:SetTall(20 * scale + b5 * 2)
		search:Dock(TOP)
		search:DockPadding(b5, b5, b5, b5)
		search:DockMargin(0, 0, 0, b5)

			local entry = vgui.Create("DTextEntry", search)
			entry:SetUpdateOnType(true)
			entry:SetFont("F4_LOUNGE_Medium")
			entry:SetDrawLanguageID(false)
			entry:Dock(FILL)
			entry.Paint = function(me, w, h)
				local b = me:HasFocus()
				draw.RoundedBox(4, 0, 0, w, h, b and self.Style.textentry or self.Style.bg)
				if (!b) then
					if (input.IsKeyDown(KEY_F)) and (input.IsKeyDown(KEY_LCONTROL) or input.IsKeyDown(KEY_RCONTROL)) then
						me:RequestFocus()
					end

					if (me:GetText() == "") then
						draw.SimpleText(self.Language.search .. ".. (Ctrl+F)", "F4_LOUNGE_Medium", 4, h * 0.5, self.Style.text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
					end
				end

				me:SetTextColor(b and self.Style.text_down or self.Style.text)
				me:DrawTextEntryText(me:GetTextColor(), me:GetHighlightColor(), me:GetCursorColor())
			end
			entry.OnValueChange = function(me)
				local val = me:GetValue():lower()
				cmds:Update(val)
			end

		local cmdlist = cmds:Add("DScrollPanel")
		L_PaintScroll(cmdlist)
		cmdlist:GetCanvas():DockPadding(b5, b5, b5, b5)
		cmdlist:Dock(FILL)
		cmdlist.Paint = function(me, w, h)
			draw.RoundedBox(4, 0, 0, w, h, self.Style.inbg)
		end
		search.Paint = cmdlist.Paint

	cmds.Update = function(me, filter)
		cmdlist:Clear()

		for _, cat in pairs (self.Commands) do
			if (#cat.commands <= 0) then
				continue end

			if (cat.teams and !cat.teams[team.GetName(LocalPlayer():Team())]) then
				continue end

			if (cat.usergroups and !cat.usergroups[GetUserGroup(LocalPlayer())]) then
				continue end

			if (cat.customCheck and !cat.customCheck(LocalPlayer())) then
				continue end

			local lbl = L_QuickLabel(cat.name, "F4_LOUNGE_LargerB", self.Style.text, cmdlist)
			lbl:Dock(TOP)
			lbl:DockMargin(0, 0, 0, b5)

			local pnl = vgui.Create("DPanel", cmdlist)
			pnl:Dock(TOP)
			pnl:DockPadding(b5, b5, b5, b5)
			pnl.Paint = function(me, w, h)
				draw.RoundedBox(4, 0, 0, w, h, self.Style.bg)
			end

			local added = false
			for __, cmd in pairs (cat.commands) do
				if (filter and filter ~= "" and !string.find(cmd.name:lower(), filter)) then
					continue end

				added = true

				local btn = vgui.Create("DButton", pnl)
				btn:SetText(cmd.name)
				btn:SetColor(self.Style.text)
				btn:SetFont("F4_LOUNGE_Medium")
				btn:Dock(TOP)
				btn:DockMargin(0, 0, 0, b5)
				btn.Paint = function(me, w, h)
					draw.RoundedBox(4, 0, 0, w, h, self.Style.inbg)

					if (me.Hovered) then
						surface.SetDrawColor(self.Style.hover)
						surface.DrawRect(0, 0, w, h)
					end

					if (me:IsDown()) then
						surface.SetDrawColor(self.Style.hover)
						surface.DrawRect(0, 0, w, h)
					end
				end
				btn.DoClick = function()
					cmd.cmd()
				end
			end

			if (added) then
				pnl:InvalidateLayout(true)
				pnl:SizeToChildren(false, true)
			else
				lbl:Remove()
				pnl:Remove()
			end
		end
	end

	cmds:Update()

	cmds:SetAlpha(0)
	cmds:AlphaTo(255, 0.1)
end
