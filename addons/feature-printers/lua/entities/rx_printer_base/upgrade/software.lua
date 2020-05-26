local STR = RXP_Tuners_CreateStruct("software")
STR.PrintName = "Анти-Перегрев"
STR.Description = "Уменьшает на 10 процентов шанс ломания принтера"
STR.MaxLevel = 3
STR.Price = 2000

	function STR:OnBuy(ply,printer,newlevel)
		local Rate = 10 * newlevel
		Rate = 100 - Rate
		Rate = Rate/100
		printer.Stats["BreakDownRate"] = printer.Stats_Default["BreakDownRate"] * Rate
	end
	
	function STR:CL_Render(printer,curlevel,DIST)
		printer:RenderModel("models/props_lab/reciever01d.mdl",Vector(9,-10,11),Angle(0,0,0),Vector(0.7,0.6,0.3),Color(255,255,255,255),nil)
	end
	
STR:Regist()