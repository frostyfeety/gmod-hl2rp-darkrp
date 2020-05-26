local STR = RXP_Tuners_CreateStruct("cooler")
STR.PrintName = "Кулер"
STR.Description = "Скорость уменьшения жизней на 10%"
STR.MaxLevel = 3
STR.Price = 1500

	function STR:OnBuy(ply,printer,newlevel)
		local Rate = 10 * newlevel
		Rate = 100 - Rate
		Rate = Rate/100
		printer.Stats["HullDecreSpeed"] = printer.Stats_Default["HullDecreSpeed"] * Rate
	end
	
	function STR:CL_Render(printer,curlevel,DIST)
		printer:RenderModel("models/props_wasteland/prison_heater001a.mdl",Vector(10,10,10),Angle(90,0,0),Vector(0.2,0.2,0.15),Color(255,255,255,255),nil)
	end
	
STR:Regist()