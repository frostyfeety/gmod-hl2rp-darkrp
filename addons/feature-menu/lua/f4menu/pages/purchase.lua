
local TYPE_SHIPMENT = 1
local TYPE_WEAPON = 2
local TYPE_AMMO = 3
local TYPE_FOOD = 4
local TYPE_VEHICLE = 5

LOUNGE_F4.Tabs.purchase = function(self, contents)
	contents:Clear()

	local scale = _LOUNGE_F4_SCALE

	local b = contents.m_iBorder
	local b5 = b * 0.5

	local curfilter

	local ents = contents:Add("DPanel")
	ents:SetDrawBackground(false)
	ents:Dock(FILL)

		local search = ents:Add("DPanel")
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
				curfilter = val

				ents:Update()
			end

		local entlist = ents:Add("DScrollPanel")
		L_PaintScroll(entlist)
		entlist:GetCanvas():DockPadding(b5, b5, b5, b5)
		entlist:Dock(FILL)
		entlist.Paint = function(me, w, h)
			draw.RoundedBox(4, 0, 0, w, h, self.Style.inbg)
		end
		search.Paint = entlist.Paint

		local function AddCategory(tab, name, typ)
			if (typ == TYPE_FOOD and !self.EnableFoodTab) then
				return end

			local entz = table.Copy(tab)

			local toadd = {}
			if (self.PurchaseByCategories and DarkRP and DarkRP.getCategories) then
				for _, v in pairs (tab) do
					local n = name .. " - " .. (v.category or "Other")
					if (toadd[n]) then
						table.insert(toadd[n], v)
					else
						toadd[n] = {v}
					end
				end
			else
				toadd = {[name] = entz}
			end

			for k, entities in SortedPairs(toadd) do
				local added = false

				local lbl = L_QuickLabel(k, "F4_LOUNGE_LargerB", self.Style.text, entlist)
				lbl:Dock(TOP)
				lbl:DockMargin(0, 0, 0, b5)

				local function GetName(o)
					-- if (typ == TYPE_VEHICLE) then
						return o.label or o.name
					-- end

					-- return o.name
				end

				local function GetPrice(o)
					if (typ == TYPE_WEAPON) and (o.separate or o.seperate) then
						return o.pricesep or o.price
					else
						return o.price
					end
				end

				local sort = self.ItemsSortingOrder
				if (sort == 1) then
					table.sort(entities, function(a, b)
						return GetName(a) < GetName(b)
					end)
				elseif (sort == 2) then
					table.sort(entities, function(a, b)
						return GetName(a) > GetName(b)
					end)
				elseif (sort == 3) then
					table.sort(entities, function(a, b)
						return GetPrice(a) > GetPrice(b)
					end)
				elseif (sort == 4) then
					table.sort(entities, function(a, b)
						return GetPrice(a) < GetPrice(b)
					end)
				end

				for _, v in pairs (entities) do
					local disallowedteam = v.allowed and istable(v.allowed) and !table.HasValue(v.allowed, LocalPlayer():Team())
					if (disallowedteam) then
						continue end

					if (v.customCheck and !v.customCheck(LocalPlayer()) and !self.KeepFailedCustomCheckEnts) then
						continue end

					local failedcheck = (v.customCheck and !v.customCheck(LocalPlayer()) and !self.KeepFailedCustomCheckEnts) or
										(v.lvl and LocalPlayer().lvl and LocalPlayer():lvl() < v.lvl and self.HideHighLevelEnts) or
										(v.level and (LocalPlayer():getDarkRPVar("level") or 0) < v.level and self.HideHighLevelEnts)
					if (failedcheck) then
						continue end

					if (typ == TYPE_SHIPMENT and v.noship) then
						continue end

					if (typ == TYPE_WEAPON) and ((!v.seperate and !v.separate) or (GAMEMODE.Config.restrictbuypistol and disallowedteam)) then
						continue end

					if (typ == TYPE_FOOD) and (LocalPlayer().isCook and v.requiresCook ~= false and !LocalPlayer():isCook()) then
						continue end

					if (curfilter and curfilter ~= "" and !string.find(GetName(v):lower(), curfilter)) then
						continue end

					added = true

					local pr = GetPrice(v)

					local pnl = vgui.Create("DButton", entlist)
					pnl:SetText("")
					pnl:SetTall((56 + b5 * 2) * scale)
					pnl:Dock(TOP)
					pnl:DockMargin(0, 0, 0, b5)
					pnl:DockPadding(b5, b5, b5, b5)
					pnl.Paint = function(me, w, h)
						draw.RoundedBox(4, 0, 0, w, h, self.Style.bg)

						if (me.Hovered) then
							draw.RoundedBox(4, 0, 0, w, h, self.Style.hover2)
						end

						if (me:IsDown()) then
							draw.RoundedBox(4, 0, 0, w, h, self.Style.hover2)
						end
					end
					pnl.DoClick = function(me)
						local canbuy, suppress, message, price
						canbuy = true

						if (LocalPlayer().canAfford and !LocalPlayer():canAfford(pr)) or (LocalPlayer().CanAfford and !LocalPlayer():CanAfford(pr)) then
							GAMEMODE:AddNotify(DarkRP.getPhrase("cant_afford", ""):Trim(), 1, 5)
							surface.PlaySound("buttons/lightswitch2.wav")
							return
						end

						local pref = GAMEMODE.Version == "2.4.3" and "/" or ""

						if (typ == TYPE_SHIPMENT) then
							RunConsoleCommand("darkrp", pref .. "buyshipment", v.name)
						elseif (typ == TYPE_WEAPON) then
							RunConsoleCommand("darkrp", pref .. "buy", v.name)
						elseif (typ == TYPE_AMMO) then
							RunConsoleCommand("darkrp", pref .. "buyammo", v.ammoType)
						elseif (typ == TYPE_FOOD) then
							RunConsoleCommand("darkrp", pref .. "buyfood", v.name)
						elseif (typ == TYPE_VEHICLE) then
							RunConsoleCommand("darkrp", pref .. "buyvehicle", v.name)
						else
							RunConsoleCommand("darkrp", (v.cmd:StartWith("/") and "" or pref) .. v.cmd)
						end
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
							icon:SetModel(v.model)
							icon:Dock(FILL)

						local tx = vgui.Create("DPanel", pnl)
						tx:SetMouseInputEnabled(false)
						tx:SetDrawBackground(false)
						tx:Dock(FILL)
						tx:DockMargin(b5, 0, b5, 0)

							local lbl = L_QuickLabel(GetName(v), "F4_LOUNGE_LargeB", self.Style.text, tx)
							lbl:Dock(TOP)

							local lbl = L_QuickLabel(pr > 0 and LOUNGE_F4.formatMoney(pr) or self.Language.free, "F4_LOUNGE_Medium", self.Style.text, tx)
							lbl:Dock(TOP)
				end

				if (!added) then
					lbl:Remove()
				end
			end
		end

		ents.Update = function(me)
			entlist:Clear()

			AddCategory(DarkRPEntities, self.Language.entities)
			AddCategory(CustomShipments, self.Language.shipments, TYPE_SHIPMENT)
			AddCategory(CustomShipments, self.Language.weapons, TYPE_WEAPON)
			AddCategory(GAMEMODE.AmmoTypes, self.Language.ammo, TYPE_AMMO)
			if (FoodItems) then
				AddCategory(FoodItems, self.Language.food, TYPE_FOOD)
			end
			if (CustomVehicles) then
				AddCategory(CustomVehicles, self.Language.vehicles, TYPE_VEHICLE)
			end
		end

	ents:Update()

	ents:SetAlpha(0)
	ents:AlphaTo(255, 0.1)
end
