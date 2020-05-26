local STR = RXP_Tuners_CreateStruct("hull")
STR.PrintName = "Вместимость"
STR.Description = "Дает на 10% больше вместимости"
STR.MaxLevel = 3
STR.Price = 1000

	function STR:OnBuy(ply,printer,newlevel)
		printer.V_Hull = printer.V_Hull + printer.Hull*0.1
	end
	
	function STR:CL_Render(printer,curlevel,DIST)
	end
	
STR:Regist()