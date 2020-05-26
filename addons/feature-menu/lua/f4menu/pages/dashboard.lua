
local matUser = Material("icon16/group.png", "noclamp smooth")

local function GetUserGroup(ply)
	if (LOUNGE_F4.UsergroupMode == 1) then
		return serverguard.player:GetRank(ply)
	else
		return ply:GetUserGroup()
	end
end

LOUNGE_F4.Tabs.dashboard = function(self, contents)
	contents:Clear()

	local ug = GetUserGroup(LocalPlayer())
	local scale = _LOUNGE_F4_SCALE

	local b = contents.m_iBorder
	local b5 = b * 0.5

	local iw = contents:GetWide() * 0.33

	local top = vgui.Create("DPanel", contents)
	top:SetDrawBackground(false)
	top:SetTall((64 + b * 2) * scale)
	top:Dock(TOP)

		local playerinfo = top:Add("DPanel")
		playerinfo:SetSize(iw, top:GetTall())
		playerinfo:Dock(LEFT)
		playerinfo:DockPadding(b5, b5, b5, b5)
		playerinfo.Paint = function(me, w, h)
			draw.RoundedBox(4, 0, 0, w, h, self.Style.inbg)
		end

			local s = (64 + b) * scale

			local image = vgui.Create("DPanel", playerinfo)
			image:SetSize(s, s)
			image:Dock(LEFT)
			image:DockMargin(0, 0, b5, 0)
			image:DockPadding(b5, b5, b5, b5)
			image.Paint = function(me, w, h)
				draw.RoundedBox(4, 0, 0, w, h, self.Style.bg)
			end

			local tx = vgui.Create("DPanel", playerinfo)
			tx:SetDrawBackground(false)
			tx:Dock(FILL)

				local name = L_QuickLabel(LocalPlayer():Nick(), "F4_LOUNGE_LargerB", self.Style.text, tx)
				name:Dock(TOP)

				local sep = vgui.Create("DPanel", tx)
				sep:SetTall(b * 0.25)
				sep:Dock(TOP)
				sep:DockMargin(0, 0, 0, b5)
				sep.Paint = function(me, w, h)
					draw.RoundedBox(0, 0, 0, w, h, self.Style.menu)
				end

				local usg = L_QuickLabel(self.CleanUsergroups[ug] or ug, "F4_LOUNGE_Large", self.Style.text, tx)
				usg:Dock(TOP)

				if (!self.NoMoneyLabels) then
					local cash = L_QuickLabel("$0", "F4_LOUNGE_Large", self.Style.text, tx)
					cash:Dock(TOP)
					cash.m_iCash = 0
					cash.Think = function(me)
						local mo = LocalPlayer():getDarkRPVar("money") or 0
						if (me.m_iCash ~= mo) then
							me.m_iCurrentCash = me.m_iCash
							me.m_iCash = mo
							me:Stop()
							me:NewAnimation(1).Think = function(_, __, frac)
								me.m_iCurrentCash = math.Round(Lerp(frac, me.m_iCurrentCash, mo))
								me:SetText(LOUNGE_F4.formatMoney(me.m_iCurrentCash))
							end
						end
					end
				end

		local serverinfo = top:Add("DPanel")
		serverinfo:SetSize(contents:GetWide() - iw - b * 3, (64 + b * 2) * scale)
		serverinfo:Dock(FILL)
		serverinfo:DockMargin(b, 0, 0, 0)
		serverinfo:DockPadding(b5, b5, b5, b5)
		serverinfo.Paint = function(me, w, h)
			draw.RoundedBox(4, 0, 0, w, h, self.Style.inbg)
		end

			local hostname = L_QuickLabel(GetHostName(), "F4_LOUNGE_LargerB", self.Style.text, serverinfo)
			hostname:Dock(TOP)

			local sep = vgui.Create("DPanel", serverinfo)
			sep:SetTall(b * 0.25)
			sep:Dock(TOP)
			sep:DockMargin(0, 0, 0, b5)
			sep.Paint = function(me, w, h)
				draw.RoundedBox(0, 0, 0, w, h, self.Style.menu)
			end

			local players = L_QuickLabel(self.Language.players .. ": " .. #player.GetAll() .. "/" .. game.MaxPlayers(), "F4_LOUNGE_Large", self.Style.text, serverinfo)
			players:Dock(TOP)

			local staff = L_QuickLabel(self.Language.staff_online .. ": " .. 0, "F4_LOUNGE_Large", self.Style.text, serverinfo)
			staff:Dock(TOP)

		serverinfo.Think = function(me)
			local to, cnt = 0, 0
			for _, v in ipairs (player.GetAll()) do
				if (self.StaffUsergroups[GetUserGroup(v)]) then
					cnt = cnt + 1
				end
				to = to + 1
			end

			players:SetText(self.Language.players .. ": " .. to .. "/" .. game.MaxPlayers())
			staff:SetText(self.Language.staff_online .. ": " .. cnt)
		end

	local middle = vgui.Create("DPanel", contents)
	middle:SetDrawBackground(false)
	middle:Dock(FILL)
	middle:DockMargin(0, b, 0, 0)

		local teamrep = middle:Add("DPanel")
		teamrep:Dock(FILL)
		teamrep:DockPadding(b5, b5, b5, b5)
		teamrep.Paint = function(me, w, h)
			draw.RoundedBox(4, 0, 0, w, h, self.Style.inbg)
		end

			local lbl = L_QuickLabel(self.Language.job_graph, "F4_LOUNGE_LargeB", self.Style.text, teamrep)
			lbl:Dock(TOP)

			local showcats = self.JobGraphCategories

			local catcolors = {}
			if (showcats and DarkRP.getCategories) then
				for _, cat in pairs (DarkRP.getCategories().jobs) do
					catcolors[cat.name] = cat.color
				end
			end

			local numply = #player.GetAll()
			local catz, jobz = {}, {}
			local mycat = ""
			for _, v in ipairs (player.GetAll()) do
				local t = v:Team()
				if (showcats and DarkRP.getCategories) then
					local te = RPExtraTeams[t]
					if (te and te.category) then
						catz[te.category] = (catz[te.category] or 0) + 1

						if (v == LocalPlayer()) then
							mycat = te.category
						end
					end
				else
					jobz[t] = (jobz[t] or 0) + 1
				end
			end

			local scrollp = vgui.Create("DScrollPanel", teamrep)
			L_PaintScroll(scrollp)
			scrollp:GetCanvas():DockPadding(b5, b5, b5, b5)
			scrollp:Dock(FILL)
			scrollp:DockMargin(0, b5, 0, 0)
			scrollp.Paint = function(me, w, h)
				draw.RoundedBox(4, 0, 0, w, h, self.Style.bg)
			end

				local j = 0
				for job, num in SortedPairsByValue (showcats and catz or jobz, true) do
					local col = team.GetColor(job)

					local pnl = vgui.Create("DButton", scrollp)
					pnl:SetText("")
					pnl:SetTall(24 * scale)
					pnl:Dock(TOP)
					pnl:DockMargin(0, 0, 0, b5)
					pnl.Paint = function() end

						local lbl = L_QuickLabel(showcats and job or team.GetName(job) .. " ", "F4_LOUNGE_Medium", self.Style.text, pnl)
						lbl:SetContentAlignment(6)
						lbl:SetWide(128)
						lbl:Dock(LEFT)
						lbl:DockMargin(0, 0, b5, 0)

						local bar = vgui.Create("DPanel", pnl)
						bar:SetMouseInputEnabled(false)
						bar:Dock(FILL)
						bar.Paint = function(me, w, h)
							local frac = me.m_fFrac or 0
							w = w * frac
							draw.RoundedBox(4, 0, 0, w, h, col)

							if (LocalPlayer():Team() == job) or (mycat == job) then
								surface.SetDrawColor(self.Style.text.r, self.Style.text.g, self.Style.text.b, 255 * math.Clamp((bar.m_fAnimFrac or 0) / 0.25, 0, 1))
								surface.SetMaterial(matUser)
								surface.DrawTexturedRect(b5, h * 0.5 - 6, 12, 12)
							end

							draw.SimpleText(pnl.Hovered and math.Round(num / numply * 100) .. "%" or num, "F4_LOUNGE_MediumB", w - b5, h * 0.5, self.Style.text, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
						end

					j = j + 1
					pnl:SetAlpha(0)
					pnl:AlphaTo(255, 0.1, 0.3 + j * 0.1, function()
						bar:NewAnimation(2).Think = function(anim, me, frac)
							bar.m_fFrac = (num / numply) * frac
							bar.m_fAnimFrac = frac
						end
					end)
				end

	local bottom = vgui.Create("DPanel", contents)
	bottom:SetDrawBackground(false)
	bottom:SetTall((80 + b * 2) * scale)
	bottom:Dock(BOTTOM)
	bottom:DockMargin(0, b, 0, 0)

		local _wi = contents:GetWide() * 0.5 - b * 2

		local economy
		if (!self.NoMoneyLabels) then
			economy = bottom:Add("DPanel")
			economy:Dock(FILL)
			economy:DockPadding(b5, b5, b5, b5)
			economy:InvalidateParent(true)

				local lbl = L_QuickLabel(self.Language.server_economy, "F4_LOUNGE_LargeB", self.Style.text, economy)
				lbl:Dock(TOP)
				lbl:DockMargin(0, 0, 0, b5)

				local allserver = vgui.Create("DPanel", economy)
				allserver:SetDrawBackground(false)
				allserver:SetWide(_wi)
				allserver:Dock(LEFT)
				allserver.Paint = function(me, w, h)
					draw.RoundedBox(4, 0, 0, w, h, self.Style.bg)
				end

					local lbl = L_QuickLabel(self.Language.money_in_circulation, "F4_LOUNGE_Medium", self.Style.text, allserver)
					lbl:SetContentAlignment(5)
					lbl:Dock(BOTTOM)
					lbl:DockMargin(0, 0, 0, b5)

					local totalmoney = L_QuickLabel(LOUNGE_F4.formatMoney(0), "F4_LOUNGE_LargestB", self.Style.text, allserver)
					totalmoney:SetContentAlignment(5)
					totalmoney:Dock(FILL)

				local richest = vgui.Create("DPanel", economy)
				richest:SetDrawBackground(false)
				richest:SetSize(_wi, bottom:GetTall() - b * 2 - b5 - draw.GetFontHeight("F4_LOUNGE_LargestB"))
				richest:Dock(RIGHT)
				richest.Paint = function(me, w, h)
					draw.RoundedBox(4, 0, 0, w, h, self.Style.bg)
				end

					local lbl = L_QuickLabel(self.Language.richest_player_online, "F4_LOUNGE_Medium", self.Style.text, richest)
					lbl:SetContentAlignment(5)
					lbl:Dock(BOTTOM)
					lbl:DockMargin(0, 0, 0, b5)

			local pinfo
			economy.Update = function(me, man)
				local total = 0
				local richestp, am = NULL, 0
				for _, v in ipairs (player.GetAll()) do
					local mo = v:getDarkRPVar("money") or 0
					total = total + mo

					if (mo > 0 and mo > am) then
						richestp = v
						am = mo
					end
				end

				if (totalmoney.m_iMoney ~= total) then
					local bef = totalmoney.m_iMoney or 0
					totalmoney.m_iMoney = total
					totalmoney:NewAnimation(1, man and 0 or 0.4).Think = function(_, me, frac)
						me:SetText(LOUNGE_F4.formatMoney(math.Round(Lerp(frac, bef, total))))
					end
				end

				if (IsValid(richestp)) then
					if (!IsValid(pinfo) or pinfo.m_Player ~= richestp) then
						if (IsValid(pinfo)) then
							pinfo:Remove()
						end

						pinfo = vgui.Create("DPanel", richest)
						pinfo:SetDrawBackground(false)
						pinfo:SetSize(32 * scale, 32 * scale)
						pinfo:AlignTop(b5)
						pinfo.m_Player = richestp
							local name = L_QuickLabel(richestp:Nick(), "F4_LOUNGE_LargeB", self.Style.text, pinfo)
							name:Dock(FILL)
							name:DockMargin(b5, 0, b5, 0)
							pinfo.m_Name = name

							local money = L_QuickLabel(LOUNGE_F4.formatMoney(am), "F4_LOUNGE_LargestB", self.Style.text, pinfo)
							money:Dock(RIGHT)
							pinfo.m_Money = money
					else
						pinfo.m_Name:SetText(richestp:Nick())
						pinfo.m_Name:SizeToContentsX()
						pinfo.m_Money:SetText(LOUNGE_F4.formatMoney(am))
						pinfo.m_Money:SizeToContentsX()
					end

					local tw = 32 * scale + pinfo.m_Name:GetWide() + pinfo.m_Money:GetWide() + b5 * 2
					pinfo:SetWide(math.min(tw, _wi))

					pinfo:CenterHorizontal()
				else
					local lbl = L_QuickLabel("?", "F4_LOUNGE_LargestB", self.Style.text, richest)
					lbl:SetContentAlignment(5)
					lbl:Dock(FILL)
				end
			end

			economy.Think = function(me)
				if (!me.m_fNextUpdate or CurTime() >= me.m_fNextUpdate) then
					me.m_fNextUpdate = CurTime() + 5
					me:Update(true)
				end
			end
			local _tw = 0
			economy.Paint = function(me, w, h)
				draw.RoundedBox(4, 0, 0, w, h, self.Style.inbg)

				if (_tw ~= w) then
					_tw = w
					_wi = _tw * 0.5 - b5 * 1.5
					allserver:SetWide(_wi)
					richest:SetWide(_wi)

					if (IsValid(pinfo)) then
						pinfo:CenterHorizontal()
					end
				end
			end
		else
			bottom:Remove()
		end

	-- Anims
	playerinfo:SetAlpha(0)
	serverinfo:SetAlpha(0)
	teamrep:SetAlpha(0)
	if (economy) then
		economy:SetAlpha(0)
	end

	playerinfo:AlphaTo(255, 0.1, 0.1)
	serverinfo:AlphaTo(255, 0.1, 0.2)
	teamrep:AlphaTo(255, 0.1, 0.3)
	if (economy) then
		economy:AlphaTo(255, 0.1, 0.4)
	end
end
