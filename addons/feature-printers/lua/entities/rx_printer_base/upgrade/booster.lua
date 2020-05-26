RXP_Additional_AnimationSpeed_Booster_Upgrade = 10
-- This is special setting for booster upgrade. So printing animation speed will be incresed 10% for each 1 level.
-- So 5 booster upgrade : 50 % more faster printing animations
-- 10 level upgrade -> 100% more faster. so 2X Speed

local STR = RXP_Tuners_CreateStruct("booster")
STR.PrintName = "Бустер"
STR.Description = "Принтер зарабатывает на 10% быстрей."
STR.MaxLevel = 3
STR.Price = 2000

	function STR:OnBuy(ply,printer,newlevel)
		local Rate = 10 * newlevel
		Rate = Rate/100
		Rate = Rate + 1
		printer.Stats["RPM"] = printer.Stats_Default["RPM"] * Rate
	end
	
	function STR:CL_Render(printer,curlevel,DIST)
		printer:RenderModel("models/props_wasteland/laundry_washer003.mdl",Vector(10,0,10),Angle(0,90,0),Vector(0.1,0.12,0.1),Color(255,255,255,255),nil)
	end
	
STR:Regist()