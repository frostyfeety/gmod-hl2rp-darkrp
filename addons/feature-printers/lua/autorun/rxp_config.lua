RXPrinters_Config = {}
//================ FONTS ================//
if CLIENT then
	surface.CreateFont( "RXP_Header", {
			font = "Tahoma",
			size = 22,
			weight = 300,
			antialias = true
		} )	
	surface.CreateFont( "RXP_Money", {
			font = "Tahoma",
			size = 36,
			weight = 300,
			antialias = true
		} )	
	surface.CreateFont( "RXP_Hull", {
			font = "Tahoma",
			size = 15,
			weight = 100,
			antialias = true,
			outline = true
		} )	
		
	-- VGUI
	surface.CreateFont( "RXPV_Header", {font = "Tahoma",size = 25,weight = 300,antialias = true} )	
	surface.CreateFont( "RXPV_Text1", {font = "Tahoma",size = 23,weight = 300,antialias = true} )	
end

//================ ADVANCED ================//
-- Define Admin
function RXP_IsAdmin(ply)
	local ULXRank = ply:GetNWString("usergroup")
	local VIPs = { "superadmin" , "admin" , "vip" } -- you can add more.
	if table.HasValue(VIPs,ULXRank) then
		return true
	end
	return false
end

//================ PERFORMANCE SETTING ================//
-- Since RXPrinter is made with many small props, It is recommended to optimize them. so save FPS

RXPrinters_Config.RenderDist = 1000 -- Maximim Render Distance.
RXPrinters_Config.RenderDetailDist = 1000 -- Will not render detail. like moving printer parts and lights and 3d2d texts

RXPrinters_Config.RenderDetaliMax = 2 -- Will not render detail if there are 10 printes around you. ( save FPS )
RXPrinters_Config.RenderCoolingFanR = true -- Will Render cooling fan located at right side
RXPrinters_Config.RenderCoolingFanL = true -- Will Render cooling fan located at left side

//================ PRINTERS COMMON SETTING ================//
RXPrinters_Config.CanStealMoney = false -- ( true / false ) 
--People can steal money from others printers. 

RXPrinters_Config.ErrorCodeMessage = {}
RXPrinters_Config.ErrorCodeMessage[1] = "ПОЛНЫЙ"
RXPrinters_Config.ErrorCodeMessage[2] = "СЛОМАН"
RXPrinters_Config.ErrorCodeMessage[3] = "Изношеннен"

-- NOTICE
RXPrinters_Config.Notice_BreakDown = true -- Send a message to owner if printer is breakdown
RXPrinters_Config.Notice_Explode = true -- Send a message to owner if printer is exploded