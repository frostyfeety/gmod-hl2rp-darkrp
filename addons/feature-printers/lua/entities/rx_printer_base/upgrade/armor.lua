local STR = RXP_Tuners_CreateStruct("armor")
STR.PrintName = "Броня"
STR.Description = "Дает больше хп"
STR.MaxLevel = 3
STR.Price = 500

	function STR:OnBuy(ply,printer,newlevel)
		printer.Stats["HP"] = printer.Stats["HP"] + 100
	end
	
	function STR:CL_Render(printer,curlevel,DIST)
	end
	
STR:Regist()