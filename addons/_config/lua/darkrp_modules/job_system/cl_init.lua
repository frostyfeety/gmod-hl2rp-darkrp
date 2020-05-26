local SELECTED_TYPE

Job.Unlocks = temp || {}
local temp = temp || {}


net.Receive("Job.UnlocksUpdate", function()
	Job.Unlocks = net.ReadTable()
	temp = table.Copy(Job.Unlocks)
	if Job:GetMenu() then
		Job:Rebuild(SELECTED_TYPE)
	end 
end)

net.Receive("Job.OpenMenu", function()
	Job:CreteMenu(net.ReadString())
end)

function Job:CreteMenu(type)
	if Job:GetMenu() then return end
	Job.Menu = vgui.Create("MPanelList")
	Job.Menu:SetPos(170, 0)

	SELECTED_TYPE = type

	hook.Add("PlayerBindPress", "Job.PlayerBindPress", function() Job:RemoveMenu() end)
	self:Rebuild()

	gui.EnableScreenClicker(true)
	
	Job.Menu:FadeIn(FADE_DELAY*1.5, function()
		
	end)
end

function Job:RemoveMenu()
	Job.Menu:FadeOut(FADE_DELAY, true)
	gui.EnableScreenClicker(false)
	hook.Remove("PlayerBindPress", "Job.PlayerBindPress")
end

function Job:GetMenu()
	return Job.Menu && Job.Menu:IsValid()
end

function Job:Rebuild()
	Job.Menu:Clear()

	for k, v in pairs(RPExtraTeams) do
		if !v.type || v.type == SELECTED_TYPE then

			if v.customCheck and not v.customCheck(LocalPlayer()) then
				continue
			end

			if (type(v.NeedToChangeFrom) == "number" and LocalPlayer():Team() ~= v.NeedToChangeFrom) or (type(v.NeedToChangeFrom) == "table" and not table.HasValue(v.NeedToChangeFrom, LocalPlayer():Team())) then
				continue
			end

			local panel = vgui.Create("MModelPanel")
			if type(v.model) == "table" then
				panel:SetModel(table.Random(v.model))
			else
				panel:SetModel(v.model)
			end
			panel:SetHeaderText(v.name)

			local function selectModel(Model, cmd, tnum, vote)
				local frame = vgui.Create("DFrame")
				frame:SetTitle("Выберите желаемую одежду")
				frame:SetVisible(true)
				frame:MakePopup()

				local levels = 1
				local IconsPerLevel = math.floor(ScrW()/64)

				while #Model * (64/levels) > ScrW() do
					levels = levels + 1
				end
				frame:SetSize(math.Min(#Model * 64, IconsPerLevel*64), math.Min(90+(64*(levels-1)), ScrH()))
				frame:Center()

				local CurLevel = 1
				for k,v in pairs(Model) do
					local icon = vgui.Create("SpawnIcon", frame)
					if (k-IconsPerLevel*(CurLevel-1)) > IconsPerLevel then
						CurLevel = CurLevel + 1
					end
					icon:SetPos((k-1-(CurLevel-1)*IconsPerLevel) * 64, 25+(64*(CurLevel-1)))
					icon:SetModel(v)
					icon:SetSize(64, 64)
					icon:SetToolTip()
					icon.DoClick = function()
						if vote then
							LocalPlayer():ConCommand("say /vote"..cmd)
						else
							LocalPlayer():ConCommand("say /"..cmd)
						end
						frame:Remove()
						net.Start("DarkRP_preferredjobmodel")
							net.WriteUInt(tnum, 8)
							net.WriteString(v)
						net.SendToServer()
					end
				end
			end

			local desc = ""
			if  !v.unlockCost || (v.unlockCost && table.HasValue(Job.Unlocks, v.command)) then
			
				desc = v.description
				if type(v.model) == "table" then
					panel:OnClick(function() selectModel(v.model, v.command, k, v.vote) end)
				elseif v.vote then
					panel:OnClick(function() LocalPlayer():ConCommand("say /vote"..v.command) end)
				else
					panel:OnClick(function() LocalPlayer():ConCommand("say /"..v.command) end)
				end
			elseif v.requireUnlock && !table.HasValue(Job.Unlocks, RPExtraTeams[v.requireUnlock].command) then
					desc = "Сначало разблокируйте "..RPExtraTeams[v.requireUnlock].name.."."
					panel:OnClick(function() LocalPlayer():ConCommand("Job.Unlock "..v.command) end)
			else
				desc = "Разблокировать за ₮"..v.unlockCost
				panel:OnClick(function()
					local list = vgui.Create("MList")
					list:AddItem("Вы уверены?")
					list:AddItem("")
					list:AddItem("Да, уверен", function()
						LocalPlayer():ConCommand("Job.Unlock "..v.command)
					end)
					list:AddItem("Я передумал", function() end)
				end)
			end

			panel:SetDescText(desc)
			panel:SetHeaderColor(v.color)
			panel.Model:SetCamPos(Vector( 70, -20, 50 ))
			panel.Model:SetLookAt(Vector( 0, 0, 65 ))
			panel.Model:SetFOV(10)
			panel.Model.Entity:SetSequence(panel.Model.Entity:LookupSequence(table.Random({"idle_all_01", "idle_all_02", "idle_passive"})))
			panel.Model:SetRotation(false)
			Job.Menu:AddItem(panel)
		end
	end
end
