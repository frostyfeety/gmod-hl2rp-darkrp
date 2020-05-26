RXP_Tuners = {}

if SERVER then
	function ENT:SetTuneLevel(luaname,amount)
		self.TuneLevel[luaname] = amount
		self:SetNWInt("tlv_"..luaname,amount)
	end
	function ENT:AddTuneLevel(luaname,amount)
		local A = self:GetTuneLevel(luaname)
		A = A + amount
		A = math.max(A,0)
		self:SetTuneLevel(luaname,A)
	end
	
end

function ENT:GetTuneLevel(luaname)
	return self:GetNWInt("tlv_"..luaname)
end

function RXP_Tuners_CreateStruct(LuaName)
	local STR = {}
	STR.LuaName = LuaName
	STR.MaxLevel = 5
	STR.Price = 100
	
	STR.PrintName = "Tune"
	STR.Description = "Description"
	
	function STR:OnBuy(ply,printer,newlevel)
	end
	function STR:CL_Render(printer,curlevel,DIST)
	end
	function STR:Regist()
		RXP_Tuners[self.LuaName] = self
	end
	
	return table.Copy(STR)
end

function RXPTunerElement_Include()
	local path = ENT.Folder.."/upgrade/"
	for _, file in pairs(  file.Find( ENT.Folder.."/upgrade/*.lua", "LUA" ) ) do
		if SERVER then
			AddCSLuaFile(path .. file)
		end
		include(path .. file)
		
		MsgN(path .. file)
	end
end
RXPTunerElement_Include()


//=============================//
if SERVER then
	util.AddNetworkString( "RXP_OpenTuneGUI_S2C" )
	util.AddNetworkString( "RXP_ApplyTune_C2S" )
	function ENT:OpenTuneGUI(ply)
		net.Start( "RXP_OpenTuneGUI_S2C" )
			net.WriteTable({Ent = self,Stat=self.Stats,DefaultStat=self.Stats_Default,TuneLevel=self.TuneLevel})
		net.Send(ply)
	end
	net.Receive( "RXP_ApplyTune_C2S", function( len,ply )
		local TB = net.ReadTable()
		local Ent = TB.Ent
		local StatLuaName = TB.StatLuaName
		Ent = ents.GetByIndex(Ent)
		
		if !Ent or !Ent:IsValid() or !Ent.RXPrinter then 
			DarkRP.notify( ply, 2,5, "Error : Printer is missing or something is wrong.")
			return 
		end
		local STB = RXP_Tuners[StatLuaName]
		if !STB then 
			DarkRP.notify( ply, 2,5, "Error : Something wrong.")
			return 
		end
		
		local PlyMoney = (ply.DarkRPVars.money or 0)
		if PlyMoney < STB.Price then
			DarkRP.notify( ply, 2,5, "Не хватает денег!")
			return
		end
		if Ent:GetTuneLevel(StatLuaName) >= STB.MaxLevel then
			DarkRP.notify( ply, 2,5, "Уже максимум!")
			return
		end
		
		ply:addMoney(-STB.Price)
		
		Ent:AddTuneLevel(StatLuaName,1)
		STB:OnBuy(ply,Ent,Ent:GetTuneLevel(StatLuaName))
		Ent:OpenTuneGUI(ply)
	end)
else
	net.Receive( "RXP_OpenTuneGUI_S2C", function( len,ply )
		local TB = net.ReadTable()
		local Ent = TB.Ent
		local Stat = TB.Stat
		local DefaultStat = TB.DefaultStat
		
		if RXP_PrinterPanel and RXP_PrinterPanel:IsValid() then
			RXP_PrinterPanel:Remove()
		end
		RXP_PrinterPanel = vgui.Create("RXP_PrinterPanel")
		RXP_PrinterPanel:SetSize(600,400)
		RXP_PrinterPanel:Center()
		RXP_PrinterPanel:SetUp(Ent,Stat,DefaultStat,TB)
		RXP_PrinterPanel:MakePopup()
	end)
	function RXP_DoUpgrade(Ent,StatLuaName)
		net.Start( "RXP_ApplyTune_C2S" )
			net.WriteTable({Ent=Ent:EntIndex(),StatLuaName=StatLuaName})
		net.SendToServer()
	end
end