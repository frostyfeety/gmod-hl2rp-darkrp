
local matClose = Material("shenesis/f4menu/close.png", "noclamp smooth")
local matUser = Material("shenesis/f4menu/user.png", "noclamp smooth")
local matInfo = Material("shenesis/f4menu/info.png", "noclamp smooth")
local matBack = Material("shenesis/f4menu/previous.png", "noclamp smooth")

local function ShowModelPrompt(self, job)
	if (IsValid(_LOUNGE_F4_MDLSEL)) then
		_LOUNGE_F4_MDLSEL:Remove()
	end

	local scale = _LOUNGE_F4_SCALE

	local wi, he = 400 * scale, 600 * scale

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
		draw.RoundedBox(4, 0, 0, w, h, self.Style.bg)
	end
	pnl.Close = function(me)
		if (me.m_bClosing) then
			return end

		me.m_bClosing = true
		me:AlphaTo(0, 0.1, 0, function()
			me:Remove()
		end)
	end
	pnl.OnFocusChanged = function(me, gained)
		if (!gained) then
			me:Close()
		end
	end
	_LOUNGE_F4_MDLSEL = pnl

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
			draw.RoundedBoxEx(4, 0, 0, w, h, self.Style.header, true, true, false, false)
		end

			local titlelbl = L_QuickLabel(self.Language.model_selection .. " - " .. job.name, "F4_LOUNGE_Larger", self.Style.text, header)
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

		local curmdl = ""
		if (DarkRP and DarkRP.getPreferredJobModel) then
			curmdl = DarkRP.getPreferredJobModel(job.team)
		end

		if (!curmdl or curmdl == "" or curmdl == "m") then
			curmdl = job.model[1]
		end

		local mdl = vgui.Create("DModelPanel", pnl)
		mdl:SetModel(curmdl)
		mdl:SetMouseInputEnabled(false)
		mdl:SetDrawBackground(false)
		mdl:SetFOV(50)
		mdl:Dock(FILL)
		mdl:DockMargin(m, m, m, m)
		mdl.Entity:SetAngles(Angle(0, 45, 0))
		mdl.LayoutEntity = function() end
		mdl.OldPaint = mdl.Paint
		mdl.Paint = function(me, w, h)
			draw.RoundedBox(4, 0, 0, w, h, self.Style.inbg)
			me:OldPaint(w, h)
		end

		local buttons = vgui.Create("DPanel", pnl)
		buttons:SetDrawBackground(false)
		buttons:SetTall(48 * scale)
		buttons:Dock(BOTTOM)
		buttons:DockMargin(m, 0, m, m)

			local prev = vgui.Create("DButton", buttons)
			prev:SetText("")
			prev:SetWide(buttons:GetTall())
			prev:Dock(LEFT)
			prev.Paint = function(me, w, h)
				draw.RoundedBox(4, 0, 0, w, h, self.Style.inbg)

				if (me.Hovered) then
					draw.RoundedBox(4, 0, 0, w, h, self.Style.hover)
				end

				if (me:IsDown()) then
					draw.RoundedBox(4, 0, 0, w, h, self.Style.hover)
				end

				surface.SetDrawColor(self.Style.text)
				surface.SetMaterial(matBack)
				surface.DrawTexturedRectRotated(w * 0.5, h * 0.5, 32 * scale, 32 * scale, 0)
			end
			prev.DoClick = function(me)
				local prevModel = table.FindPrev(job.model, curmdl)
				mdl:SetModel(prevModel)
				mdl.Entity:SetAngles(Angle(0, 45, 0))
				curmdl = prevModel

				if (DarkRP and DarkRP.setPreferredJobModel) then
					DarkRP.setPreferredJobModel(job.team, curmdl)
				end
			end

			local become = vgui.Create("DButton", buttons)
			if (job.vote) or (job.RequiresVote and job.RequiresVote(LocalPlayer(), job.team)) then
				become:SetText(string.format(self.Language.vote_to_become_x, job.name))
			else
				become:SetText(string.format(self.Language.become_x, job.name))
			end
			become:SetColor(self.Style.text)
			become:SetFont("F4_LOUNGE_LargeB")
			become:Dock(FILL)
			become:DockMargin(m, 0, m, 0)
			become.Paint = function(me, w, h)
				draw.RoundedBox(4, 0, 0, w, h, self.Style.inbg)

				if (me.Hovered) then
					draw.RoundedBox(4, 0, 0, w, h, self.Style.hover)
				end

				if (me:IsDown()) then
					draw.RoundedBox(4, 0, 0, w, h, self.Style.hover)
				end
			end
			become.DoClick = function(me)
				local oldasshit = GAMEMODE.Version == "2.4.3"
				local pref = oldasshit and "/" or ""
				
				if (oldasshit) then
					RunConsoleCommand("rp_playermodel", curmdl)
					RunConsoleCommand("_rp_ChosenModel", curmdl)
				end

				if (job.vote) or (job.RequiresVote and job.RequiresVote(LocalPlayer(), job.team)) then
					RunConsoleCommand("darkrp", pref .. "vote" .. job.command)
				else
					RunConsoleCommand("darkrp", pref .. job.command)
				end
				pnl:Close()
			end

			local nextb = vgui.Create("DButton", buttons)
			nextb:SetText("")
			nextb:SetWide(buttons:GetTall())
			nextb:Dock(RIGHT)
			nextb.Paint = function(me, w, h)
				draw.RoundedBox(4, 0, 0, w, h, self.Style.inbg)

				if (me.Hovered) then
					draw.RoundedBox(4, 0, 0, w, h, self.Style.hover)
				end

				if (me:IsDown()) then
					draw.RoundedBox(4, 0, 0, w, h, self.Style.hover)
				end

				surface.SetDrawColor(self.Style.text)
				surface.SetMaterial(matBack)
				surface.DrawTexturedRectRotated(w * 0.5, h * 0.5, 32 * scale, 32 * scale, 180)
			end
			nextb.DoClick = function(me)
				local prevModel = table.FindNext(job.model, curmdl)
				mdl:SetModel(prevModel)
				mdl.Entity:SetAngles(Angle(0, 45, 0))
				curmdl = prevModel

				if (DarkRP and DarkRP.setPreferredJobModel) then
					DarkRP.setPreferredJobModel(job.team, curmdl)
				end
			end

	pnl:SetAlpha(0)
	pnl:AlphaTo(255, 0.1)
end

LOUNGE_F4.Tabs.jobs = function(self, contents)
	contents:Clear()

	local scale = _LOUNGE_F4_SCALE

	local b = contents.m_iBorder
	local b5 = b * 0.5

	local infopnl = contents:Add("DScrollPanel")
	L_PaintScroll(infopnl)
	infopnl:GetCanvas():DockPadding(b5, b5, b5, b5)
	infopnl.Show = function(me, job, jobspnl)
		me:Clear()

		local top = vgui.Create("DPanel", me)
		top:SetDrawBackground(false)
		top:Dock(TOP)
		top:SetTall(32 * scale)

			local back = vgui.Create("DButton", top)
			back:SetText("")
			back:SetWide(32 * scale)
			back:Dock(LEFT)
			back.Paint = function(me, w, h)
				surface.SetDrawColor(self.Style.text)
				surface.SetMaterial(matBack)
				surface.DrawTexturedRect(0, 0, w, h)
			end
			back.DoClick = function(me)
				local wi = infopnl:GetWide()

				jobspnl:Dock(FILL)

				infopnl:Clear()
				infopnl:Dock(NODOCK)
				infopnl:NewAnimation(0.4).Think = function(_, me, frac)
					me:SetWide(wi * (1 - frac))
					me:AlignRight(b)
					jobspnl:DockMargin(0, 0, me:GetWide(), 0)
				end
			end

		local lbl = L_QuickLabel(job.name, "F4_LOUNGE_LargerB", self.Style.text, me)
		lbl:Dock(TOP)
		lbl:DockMargin(0, b5, 0, b5)
		lbl:SetAlpha(0)
		lbl:AlphaTo(255, 0.1, 0.3)

		if (!self.NoMoneyLabels) then
			local lbl = L_QuickLabel(self.Language.salary .. ": " .. LOUNGE_F4.formatMoney(job.salary), "F4_LOUNGE_LargeB", self.Style.text, me)
			lbl:Dock(TOP)
			lbl:DockMargin(0, 0, 0, b5)
			lbl:SetAlpha(0)
			lbl:AlphaTo(255, 0.1, 0.3)
		end

		local lbl = L_QuickLabel(job.description, "F4_LOUNGE_Medium", self.Style.text, me)
		lbl:SetAutoStretchVertical(true)
		lbl:SetWrap(true)
		lbl:Dock(TOP)
		lbl:DockMargin(0, 0, 0, b5)
		lbl:SetAlpha(0)
		lbl:AlphaTo(255, 0.1, 0.4)

		local weps = {}
		for _, wep in pairs (job.weapons) do
			local SWEP = weapons.Get(wep)
			if (SWEP) then
				table.insert(weps, SWEP.PrintName or wep)
			end
		end

		local wepstr = table.concat(weps, "\n- ")
		if (wepstr ~= "") then
			wepstr = self.Language.weapons .. ":\n- " .. wepstr

			local lbl = L_QuickLabel(wepstr, "F4_LOUNGE_Medium", self.Style.text, me)
			lbl:SetAutoStretchVertical(true)
			lbl:SetWrap(true)
			lbl:Dock(TOP)
			lbl:DockMargin(0, 0, 0, b5)
			lbl:SetAlpha(0)
			lbl:AlphaTo(255, 0.1, 0.5)
		end
	end
	infopnl.Paint = function(me, w, h)
		if (#me:GetCanvas():GetChildren() == 0) then
			return end

		draw.RoundedBox(4, 0, 0, w, h, self.Style.inbg)
	end

	local jobs = contents:Add("DPanel")
	jobs:SetDrawBackground(false)
	jobs:Dock(FILL)

		local search = jobs:Add("DPanel")
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
				jobs:Update(nil, val)
			end

		local joblist = jobs:Add("DScrollPanel")
		L_PaintScroll(joblist)
		joblist:GetCanvas():DockPadding(b5, b5, b5, b5)
		joblist:Dock(FILL)
		joblist.Paint = function(me, w, h)
			draw.RoundedBox(4, 0, 0, w, h, self.Style.inbg)
		end
		search.Paint = joblist.Paint

	jobs.Update = function(me, update, filter)
		joblist:Clear()

		local cats = {}
		if (DarkRP.getCategories and DarkRP.getCategories() and DarkRP.getCategories().jobs) then
			cats = DarkRP.getCategories().jobs
		else -- Old DarkRP...
			cats = {
				{name = "", members = RPExtraTeams}
			}
		end

		for _, cat in pairs (cats) do
			local lbl = L_QuickLabel(cat.name, "F4_LOUNGE_LargerB", self.Style.text, joblist)
			lbl:Dock(TOP)
			lbl:DockMargin(0, 0, 0, b5)

			if (cat.name == "") then
				lbl:Remove()
			end

			local jobz = table.Copy(cat.members)

			local sort = self.JobsSortingOrder
			if (sort == 1) then
				table.sort(jobz, function(a, b)
					return a.name < b.name
				end)
			elseif (sort == 2) then
				table.sort(jobz, function(a, b)
					return a.name > b.name
				end)
			elseif (sort == 3) then
				table.sort(jobz, function(a, b)
					return a.salary > b.salary
				end)
			elseif (sort == 4) then
				table.sort(jobz, function(a, b)
					return a.salary < b.salary
				end)
			end

			local added = false
			for __, job in pairs (jobz) do
				if (filter and filter ~= "" and !string.find(job.name:lower(), filter)) then
					continue end

				if (job.NeedToChangeFrom and LocalPlayer():Team() ~= job.NeedToChangeFrom and update ~= job.NeedToChangeFrom) then
					continue end

				local failedcheck = (job.customCheck and !job.customCheck(LocalPlayer()) and !self.KeepFailedCustomCheckJobs) or
									(job.lvl and LocalPlayer().lvl and LocalPlayer():lvl() < job.lvl and self.HideHighLevelJobs) or
									(job.level and (LocalPlayer():getDarkRPVar("level") or 0) < job.level and self.HideHighLevelJobs)
				if (failedcheck) then
					continue end

				local sameteam = job.team == LocalPlayer():Team()
				if (!update and sameteam) then
					continue end

				added = true

				local pnl = vgui.Create("DButton", joblist)
				pnl:SetText("")
				pnl:SetTall((56 + b5 * 2) * scale)
				pnl:Dock(TOP)
				pnl:DockMargin(0, 0, 0, b5)
				pnl:DockPadding(b5, b5, b5, b5)
				pnl.Paint = function(me, w, h)
					if (failedcheck) then
						local nope = self.PaintJobFailedCheck(me, w, h)
						if (nope) then
							return end
					end

					draw.RoundedBox(4, 0, 0, w, h, self.Style.bg)

					if (me.Hovered) then
						draw.RoundedBox(4, 0, 0, w, h, self.Style.hover2)
					end

					if (me:IsDown()) then
						draw.RoundedBox(4, 0, 0, w, h, self.Style.hover2)
					end
				end
				pnl.DoClick = function(me)
					if (me.m_bRemoving) then
						return end

					if (istable(job.model) and #job.model > 1) then
						ShowModelPrompt(self, job)
					else
						local pref = GAMEMODE.Version == "2.4.3" and "/" or ""

						if (job.vote) or (job.RequiresVote and job.RequiresVote(LocalPlayer(), job.team)) then
							RunConsoleCommand("darkrp", pref .. "vote" .. job.command)
						else
							RunConsoleCommand("darkrp", pref .. job.command)
						end
					end
				end
				pnl.DoRightClick = function()
					local wi = jobs:GetWide()

					infopnl:Show(job, jobs)
					infopnl:Dock(FILL)
					infopnl:DockMargin(500, 0, 0, 0)

					jobs:Dock(NODOCK)
					jobs:NewAnimation(0.4).Think = function(_, me, frac)
						me:SetWide(wi * (1 - frac))
						infopnl:DockMargin(me:GetWide(), 0, 0, 0)
					end
				end

					local back = vgui.Create("DButton", pnl)
					back:SetText("")
					back:SetWide(32 * scale)
					back:Dock(RIGHT)
					back.Paint = function(me, w, h)
						surface.SetDrawColor(self.Style.text)
						surface.SetMaterial(matInfo)
						surface.DrawTexturedRect(0, h * 0.5 - 12 * scale, 24 * scale, 24 * scale)
					end
					back.DoClick = function(me)
						pnl:DoRightClick()
					end

					local bg = vgui.Create("DPanel", pnl)
					bg:SetMouseInputEnabled(false)
					bg:SetWide(56 * scale)
					bg:Dock(LEFT)
					bg:DockPadding(b5, b5, b5, b5)
					bg.Paint = function(me, w, h)
						draw.RoundedBox(4, 0, 0, w, h, self.Style.inbg)
					end

						local icon = vgui.Create("SpawnIcon", bg)
						icon:SetModel(istable(job.model) and job.model[1] or job.model)
						icon:Dock(FILL)

					local tx = vgui.Create("DPanel", pnl)
					tx:SetMouseInputEnabled(false)
					tx:SetDrawBackground(false)
					tx:Dock(FILL)
					tx:DockMargin(b5, 0, b5, 0)

						local lbl = L_QuickLabel(job.name, "F4_LOUNGE_LargeB", self.Style.text, tx)
						lbl:Dock(TOP)
						
						local tb = {}
						if (!self.NoMoneyLabels) then
							table.insert(tb, self.Language.salary .. ": " .. LOUNGE_F4.formatMoney(job.salary))
						end
						if (job.level or job.lvl) then
							table.insert(tb, string.format(self.Language.level_x, job.level or job.lvl))
						end

						local txt = table.concat(tb, " - ")
						if (txt ~= "") then
							local lbl = L_QuickLabel(txt, "F4_LOUNGE_Medium", self.Style.text, tx)
							lbl:Dock(TOP)
						end

						local users = vgui.Create("DPanel", tx)
						users:Dock(FILL)
						users.Paint = function(me, w, h)
							local str = team.NumPlayers(job.team)
							local col = str > 0 and self.Style.text or self.Style.menu

							if (job.max and job.max > 0) then
								if (str >= job.max) then
									col = self.Style.close_hover
								end

								str = str .. "/" .. job.max
							end

							local is = 14 * scale

							surface.SetMaterial(matUser)
							surface.SetDrawColor(col)
							surface.DrawTexturedRect(0, b5 * 0.5, is, is)

							draw.SimpleText(str, "F4_LOUNGE_Medium", is + b5 * 0.5, is * 0.5 + b5 * 0.5, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
						end

				if (update) then
					if (sameteam or (job.NeedToChangeFrom and update == job.NeedToChangeFrom and LocalPlayer():Team() ~= job.NeedToChangeFrom)) then
						pnl.m_bRemoving = true
						pnl:Stop()
						pnl:SizeTo(-1, 1, 0.2, nil, nil, function(_, me)
							me:Remove()
						end)
					elseif (job.team == update or job.NeedToChangeFrom == LocalPlayer():Team()) then
						local h = pnl:GetTall()

						pnl:SetTall(1)
						pnl:SizeTo(-1, h, 0.2)
					end
				end
			end

			if (!added) then
				lbl:Remove()
			end
		end
	end

	jobs.m_iLastTeam = nil
	jobs.Think = function(me)
		local t = LocalPlayer():Team()
		if (me.m_iLastTeam ~= t) then
			local before = me.m_iLastTeam

			me.m_iLastTeam = t
			me:Update(before)
		end
	end

	jobs:SetAlpha(0)
	jobs:AlphaTo(255, 0.1)
end
