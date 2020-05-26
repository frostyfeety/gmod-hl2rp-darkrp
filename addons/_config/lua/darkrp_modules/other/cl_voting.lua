local QuestionVGUI = {}
local PanelNum = 0
local VoteVGUI = {}

local currentVotes = {}

local function MsgDoVote(msg)
	local question = msg:ReadString()
	local voteid = msg:ReadShort()
	local timeleft = msg:ReadFloat()
	print(voteid)
	if timeleft == 0 then
		timeleft = 100
	end
	if not IsValid(LocalPlayer()) then return end -- Sent right before player initialisation
	table.insert ( currentVotes, {quest = question, id = voteid, timeneed = timeleft, oldtime = CurTime()})
	LocalPlayer():EmitSound("Town.d1_town_02_elevbell1", 100, 100)
end
usermessage.Hook("DoVote", MsgDoVote)

local voteSizeX = 460
local voteSizeY = 30
local voteBackAlpha = 200
local voteLineColor = {134,252,75}
local voteLineHeight = 4
local voteTextColor = {r=255,g=255,b=255,a=255}
local blockSize = 55
local betweenBlockAndBack = 12
local betweenBlocks = 10
local lastPressed = CurTime()

local function DrawVotesStuff()
	if #currentVotes > 0 then
		local removeID = nil
		for i, v in ipairs ( currentVotes ) do
			--i = i+3
			if v.timeneed - (CurTime() - v.oldtime) > 0 then
				surface.SetDrawColor( 0, 0, 0, voteBackAlpha) -- задник
				surface.SetFont( "default" )
				local size = surface.GetTextSize( v.quest )+blockSize*2+betweenBlocks*3
				if size < voteSizeX then
					size = voteSizeX
				end
				surface.DrawRect(20, 20+(i-1)*(voteSizeY+10), size, voteSizeY )
				
				surface.SetDrawColor( voteLineColor[1],voteLineColor[2],voteLineColor[3], 255) -- полоска времени
				surface.DrawRect(20, 20+(i-1)*(voteSizeY+10), (size/v.timeneed*(v.timeneed - (CurTime() - v.oldtime))), voteLineHeight )
				
				draw.SimpleText(v.quest, "default", 25, 20+(i-1)*(voteSizeY+10)+voteSizeY/2-7, voteTextColor)
				
				surface.SetDrawColor( 255,100,100, 255) -- задник у "нет"
				surface.DrawRect(20+size-blockSize-betweenBlocks, 20+(i-1)*(voteSizeY+10)+betweenBlockAndBack/2, blockSize, (voteSizeY-betweenBlockAndBack) )
				
				draw.SimpleText("Нет (F7)", "Default", 20+size-blockSize-betweenBlocks+5, 20+(i-1)*(voteSizeY+10)+betweenBlockAndBack/2+3, {r=0,g=0,b=0,a=255})
				
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawOutlinedRect(20+size-blockSize-betweenBlocks, 20+(i-1)*(voteSizeY+10)+betweenBlockAndBack/2, blockSize, (voteSizeY-betweenBlockAndBack))
				
				surface.SetDrawColor( voteLineColor[1],voteLineColor[2],voteLineColor[3], 255) -- задник у "да"
				surface.DrawRect(20+size-blockSize-betweenBlocks-blockSize-betweenBlocks, 20+(i-1)*(voteSizeY+10)+betweenBlockAndBack/2, blockSize, (voteSizeY-betweenBlockAndBack) )
				
				draw.SimpleText("Да (F6)", "Default", 20+size-blockSize-betweenBlocks+5-blockSize-betweenBlocks, 20+(i-1)*(voteSizeY+10)+betweenBlockAndBack/2+3, {r=0,g=0,b=0,a=255})
				
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawOutlinedRect(20+size-blockSize-betweenBlocks-blockSize-betweenBlocks, 20+(i-1)*(voteSizeY+10)+betweenBlockAndBack/2, blockSize, (voteSizeY-betweenBlockAndBack))
				
				
				--surface.SetDrawColor( voteLineColor[1],voteLineColor[2],voteLineColor[3], 255) -- полоска времени
				--surface.DrawRect(20, 20+(i-1)*(voteSizeY+10), (size/v.timeneed*(v.timeneed - (CurTime() - v.oldtime))), voteLineHeight )
				
				surface.SetDrawColor( 0, 0, 0, 255 ) -- опоясывающие полоски
				surface.DrawOutlinedRect( 20, 20+(i-1)*(voteSizeY+10), size, voteSizeY)
				
			else
				removeID = i
			end
		end
		if removeID then
			table.remove ( currentVotes, removeID )
		end
		if input.IsKeyDown( KEY_F6 ) or input.IsKeyDown( KEY_F7 ) then
			if lastPressed+1 < CurTime() then
				lastPressed = CurTime()
				local answer
				if input.IsKeyDown( KEY_F6 ) then
					answer = 1
				elseif input.IsKeyDown( KEY_F7 ) then
					answer = 0
				end
				if answer and currentVotes[1].id then
					if answer == 1 then
						LocalPlayer():ConCommand("vote " .. currentVotes[1].id .. " yea\n")
					else
						LocalPlayer():ConCommand("vote " .. currentVotes[1].id .. " nay\n")
					end
					table.remove(currentVotes,1)
				end
			end	
		end
	end
end
hook.Add("HUDPaint", "DrawVotesStuff", DrawVotesStuff)


local function KillVoteVGUI(msg)
	local id = msg:ReadShort()

	if VoteVGUI[id .. "vote"] and VoteVGUI[id .. "vote"]:IsValid() then
		VoteVGUI[id.."vote"]:Close()

	end
end
usermessage.Hook("KillVoteVGUI", KillVoteVGUI)

local function MsgDoQuestion(msg)
	local question = msg:ReadString()
	local quesid = msg:ReadString()
	local timeleft = msg:ReadFloat()
	if timeleft == 0 then
		timeleft = 100
	end
	local OldTime = CurTime()
	LocalPlayer():EmitSound("Town.d1_town_02_elevbell1", 100, 100)
	local panel = vgui.Create("DFrame")
	panel:SetPos(3 + PanelNum, ScrH() / 2 - 50)--Times 140 because if the quesion is the second screen, the first screen is always a vote screen.
	panel:SetSize(300, 140)
	panel:SetSizable(false)
	panel.btnClose:SetVisible(false)
	panel:SetKeyboardInputEnabled(false)
	panel:SetMouseInputEnabled(true)
	panel:SetVisible(true)

	function panel:Close()
		PanelNum = PanelNum - 300
		QuestionVGUI[quesid .. "ques"] = nil
		local num = 0
		for k,v in SortedPairs(VoteVGUI) do
			v:SetPos(num, ScrH() / 2 - 50)
			num = num + 140
		end

		for k,v in SortedPairs(QuestionVGUI) do
			v:SetPos(num, ScrH() / 2 - 50)
			num = num + 300
		end

		self:Remove()
	end

	function panel:Think()
		self:SetTitle(DarkRP.getPhrase("time", math.Clamp(math.ceil(timeleft - (CurTime() - OldTime)), 0, 9999)))
		if timeleft - (CurTime() - OldTime) <= 0 then
			panel:Close()
		end
	end

	local label = vgui.Create("DLabel")
	label:SetParent(panel)
	label:SetPos(5, 30)
	label:SetSize(380, 40)
	label:SetText(DarkRP.deLocalise(question))
	label:SetVisible(true)

	local divider = vgui.Create("Divider")
	divider:SetParent(panel)
	divider:SetPos(2, 80)
	divider:SetSize(380, 2)
	divider:SetVisible(true)

	local ybutton = vgui.Create("DButton")
	ybutton:SetParent(panel)
	ybutton:SetPos(105, 100)
	ybutton:SetSize(40, 20)
	ybutton:SetText(DarkRP.getPhrase("yes"))
	ybutton:SetVisible(true)
	ybutton.DoClick = function()
		LocalPlayer():ConCommand("ans " .. quesid .. " 1\n")
		panel:Close()
	end

	local nbutton = vgui.Create("DButton")
	nbutton:SetParent(panel)
	nbutton:SetPos(155, 100)
	nbutton:SetSize(40, 20)
	nbutton:SetText(DarkRP.getPhrase("no"))
	nbutton:SetVisible(true)
	nbutton.DoClick = function()
		LocalPlayer():ConCommand("ans " .. quesid .. " 2\n")
		panel:Close()
	end

	PanelNum = PanelNum + 300
	QuestionVGUI[quesid .. "ques"] = panel

	panel:SetSkin(GAMEMODE.Config.DarkRPSkin)
end
usermessage.Hook("DoQuestion", MsgDoQuestion)

local function KillQuestionVGUI(msg)
	local id = msg:ReadString()

	if QuestionVGUI[id .. "ques"] and QuestionVGUI[id .. "ques"]:IsValid() then
		QuestionVGUI[id .. "ques"]:Close()
	end
end
usermessage.Hook("KillQuestionVGUI", KillQuestionVGUI)

local function DoVoteAnswerQuestion(ply, cmd, args)
	if not args[1] then return end

	local vote = 0
	if tonumber(args[1]) == 1 or string.lower(args[1]) == "yes" or string.lower(args[1]) == "true" then vote = 1 end

	for k,v in pairs(VoteVGUI) do
		if ValidPanel(v) then
			local ID = string.sub(k, 1, -5)
			VoteVGUI[k]:Close()
			RunConsoleCommand("vote", ID, vote)
			return
		end
	end

	for k,v in pairs(QuestionVGUI) do
		if ValidPanel(v) then
			local ID = string.sub(k, 1, -5)
			QuestionVGUI[k]:Close()
			RunConsoleCommand("ans", ID, vote)
			return
		end
	end
end
concommand.Add("rp_vote", DoVoteAnswerQuestion)
