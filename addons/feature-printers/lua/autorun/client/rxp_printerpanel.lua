local PANEL = {}
	
function PANEL:Init()
	self:SetTitle("")
	self:ShowCloseButton(false)
	self:SetDraggable(false)
end

function PANEL:SetUp(Ent,Stat,DefaultStat,TB)
	local CloseButton = vgui.Create("DButton",self)
	CloseButton:SetPos(self:GetWide()-102,2)
	CloseButton:SetSize(100,30)
	CloseButton:SetText("")
	CloseButton.Paint = function(slf)
		surface.SetDrawColor(0,100,180,255)
		surface.DrawRect(0,0,slf:GetWide(),slf:GetTall())
		draw.SimpleText("Закрыть", "RXPV_Header", slf:GetWide()/2,slf:GetTall()/2, Color(255,255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end
	CloseButton.DoClick = function(slf)
		if true then
			self:Remove()
			return
		end
		if RXP_PrinterPanel and RXP_PrinterPanel:IsValid() then
			RXP_PrinterPanel:Remove()
		end
		RXP_PrinterPanel = vgui.Create("RXP_PrinterPanel")
		RXP_PrinterPanel:SetSize(600,400)
		RXP_PrinterPanel:Center()
		RXP_PrinterPanel:SetUp(Ent,Stat,DefaultStat,TB)
		RXP_PrinterPanel:MakePopup()
	end
	
	
	local LeftBG = vgui.Create("DPanel",self)
	LeftBG:SetPos(6,40)
	LeftBG:SetSize(self:GetWide()/2-9,self:GetTall()-46)
	LeftBG.Paint = function(slf)
		surface.SetDrawColor(40,40,40,255)
		surface.DrawRect(0,0,slf:GetWide(),slf:GetTall())
	end
	
	local LeftLister = vgui.Create("DPanelList",LeftBG)
	LeftLister:SetPos(2,2)
	LeftLister:SetSize(LeftBG:GetWide()-4,LeftBG:GetTall()-4)
	LeftLister:EnableHorizontal( false )
	LeftLister:EnableVerticalScrollbar( true )
	LeftLister:SetSpacing(3)
	
	for k,v in pairs(Stat) do
		local Updates = vgui.Create("DButton")
		Updates:SetSize(LeftLister:GetWide()-20,50)
		Updates:SetText("")
		Updates.Paint = function(slf)
			if slf:IsHovered() then
				surface.SetDrawColor(120,255,120,80)
			else
				surface.SetDrawColor(120,255,120,50)
			end
			surface.DrawRect(0,0,slf:GetWide(),slf:GetTall())
			surface.SetDrawColor(0,0,0,50)
			surface.DrawRect(0,slf:GetTall()/2,slf:GetWide(),slf:GetTall()/2)
			draw.SimpleText(k, "RXPV_Text1", 5,0, Color(200,220,255,255))
			draw.SimpleText(v .. " / " .. DefaultStat[k], "RXPV_Text1", 5,25, Color(200,220,255,255))
		end
		LeftLister:AddItem(Updates)
	end
	
	
	local RightBG = vgui.Create("DPanel",self)
	RightBG:SetPos(self:GetWide()/2+3,40)
	RightBG:SetSize(self:GetWide()/2-9,self:GetTall()-46)
	RightBG.Paint = function(slf)
		surface.SetDrawColor(40,40,40,255)
		surface.DrawRect(0,0,slf:GetWide(),slf:GetTall())
	end
	
	local RightLister = vgui.Create("DPanelList",RightBG)
	RightLister:SetPos(2,2)
	RightLister:SetSize(RightBG:GetWide()-4,RightBG:GetTall()-4)
	RightLister:EnableHorizontal( false )
	RightLister:EnableVerticalScrollbar( true )
	RightLister:SetSpacing(3)
	
	for k,v in pairs(RXP_Tuners) do
		local CurLevel,MaxLevel = TB.TuneLevel[k] or 0 , v.MaxLevel
		local Rate = CurLevel/MaxLevel
		
		local Updates = vgui.Create("DButton")
		Updates:SetSize(RightLister:GetWide()-20,50)
		Updates:SetText("")
		Updates.Paint = function(slf)
			if slf:IsHovered() then
				surface.SetDrawColor(0,180,255,80)
			else
				surface.SetDrawColor(0,180,255,50)
			end
			surface.DrawRect(0,0,slf:GetWide(),slf:GetTall())
			surface.SetDrawColor(0,0,0,50)
			surface.DrawRect(0,slf:GetTall()/2,slf:GetWide(),slf:GetTall()/2)
			draw.SimpleText(v.PrintName .. " ", "RXPV_Text1", 5,0, Color(200,220,255,255))
			draw.SimpleText("₮" .. v.Price, "RXPV_Text1", slf:GetWide()-5,0, Color(240,240,240,255),TEXT_ALIGN_RIGHT)
			draw.SimpleText(CurLevel .. " / " .. MaxLevel, "RXPV_Text1", slf:GetWide()-5,25, Color(240,240,240,255),TEXT_ALIGN_RIGHT)
			
			local PX,PY,SX,SY = 10,slf:GetTall()/2+2,slf:GetWide()-100,slf:GetTall()/2-4
			surface.SetDrawColor(0,150,255,100)
			surface.DrawRect(PX,PY,SX,SY)
			surface.SetDrawColor(0,0,0,240)
			surface.DrawRect(PX+2,PY+2,SX-4,SY-4)
			surface.SetDrawColor(0,150,255,240)
			surface.DrawRect(PX+4,PY+4,(SX-8)*Rate,SY-8)
		end
		Updates.DoClick = function(slf)
			RXP_DoUpgrade(Ent,v.LuaName)
		end
		RightLister:AddItem(Updates)
	end
end

function PANEL:Paint()
	surface.SetDrawColor(70,70,70,255)
	surface.DrawRect(0,0,self:GetWide(),self:GetTall())
	surface.SetDrawColor(40,40,40,255)
	surface.DrawRect(2,2,self:GetWide()-4,32)
	draw.SimpleText("Меню улучшений", "RXPV_Header", 10,18, Color(255,255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)

end

vgui.Register("RXP_PrinterPanel",PANEL,"DFrame")