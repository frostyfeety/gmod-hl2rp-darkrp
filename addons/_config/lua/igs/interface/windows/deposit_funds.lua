local function niceSum(i, iFallback)
	return math.Truncate(tonumber(i) or iFallback, 2)
end

local m
function IGS.WIN.Deposit(iRealSum)
	if IsValid(m) then return end -- не даем открыть 2 фрейма
	iRealSum = tonumber(iRealSum)

	surface.PlaySound("ambient/weather/rain_drip1.wav")
	hook.Run("IGS.OnDepositWinOpen",iRealSum)

	local cd = !IGS.IsCurrencyEnabled() -- cd = currency disabled. Bool
	local realSum = iRealSum and niceSum(iRealSum) or IGS.GetMinCharge()

	m = uigs.Create("igs_frame", function(self)
		self:SetSize(455,155)
		self:RememberLocation("igs_deposit")
		self:Center()
		self:SetDraggable(false)

		self:SetTitle("Пополнение счёта через gm-donate.ru")

		self:MakePopup()
		self:Focus()
		self:SetBackgroundBlur(true)

		--[[-------------------------------------
			Левая колонка. Реальная валюта
		---------------------------------------]]
		uigs.Create("DLabel", function(real)
			real:SetSize(cd and 450 or 180,25)
			real:SetPos(cd and 0 or 10,self:GetTitleHeight())
			real:SetText(cd and "Введите ниже сумму пополнения счета" or "Рубли")
			real:SetFont("igs.22")
			real:SetTextColor(IGS.col.HIGHLIGHTING)
			real:SetContentAlignment(2)
		end, self)

		self.real_m = uigs.Create("DTextEntry", self)
		self.real_m:SetPos(10,50)
		self.real_m:SetSize(cd and 450 - 10 - 10 or 180,30)
		self.real_m:SetNumeric(true)
		self.real_m.OnChange = function(s)
			if cd then return end
			self.curr_m:SetValue(IGS.PriceInCurrency( niceSum(s:GetValue(),0) )) -- бля
		end
		self.real_m.Think = function()
			if cd then
				self.purchase:SetText(
					"Пополнить счет на " .. niceSum(self.real_m:GetValue(),0) .. " руб"
				)
			else
				self.purchase:SetText(
					"Пополнить на " .. IGS.SignPrice( niceSum(self.curr_m:GetValue(),0) ) ..
					" за " .. niceSum(self.real_m:GetValue(),0) .. " руб"
				)
			end
		end

		--[[-------------------------------------
			Середина. Знак равности и кнопка покупки
		---------------------------------------]]
		self.purchase = uigs.Create("igs_button", function(p)
			local _,ry = self.real_m:GetPos()

			p:SetSize(270,40)
			p:SetActive(true) -- выделяет синим
			p:SetPos((self:GetWide() - p:GetWide()) / 2,ry + self.real_m:GetTall() + 15)

			p.DoClick = function()
				local want_money = niceSum(self.real_m:GetValue())
				if !want_money then
					return

				elseif want_money < realSum then
					return
				end

				IGS.GetPaymentURL(want_money,function(url)
					IGS.OpenURL(url,"Процедура пополнения счета")
				end)
			end
		end, self)

		--[[-------------------------------------
			Правая колонка. Донат валюта
		---------------------------------------]]
		if !cd then
			uigs.Create("DLabel", function(curr)
				curr:SetSize(180,25)
				curr:SetPos(self:GetWide() - 10 - curr:GetWide(),self:GetTitleHeight())
				curr:SetText(IGS.C.CURRENCY_NAME)
				curr:SetFont("igs.22")
				curr:SetTextColor(IGS.col.HIGHLIGHTING)
				curr:SetContentAlignment(2)
			end, self)

			self.curr_m = uigs.Create("DTextEntry", self)
			self.curr_m:SetPos(self:GetWide() - 10 - self.real_m:GetWide(),50)
			self.curr_m:SetSize(self.real_m:GetWide(),self.real_m:GetTall())
			self.curr_m:SetNumeric(true)
			self.curr_m.OnChange = function(s)
				self.real_m:SetValue(IGS.RealPrice( niceSum(s:GetValue(),0) )) -- тоже бля
			end
		end

		--[[-------------------------------------------------------------------------
			Должно быть после self.curr_m
		---------------------------------------------------------------------------]]
		self.real_m:SetValue( realSum )
		self.real_m:OnChange()
	end)

	return m
end


hook.Add("IGS.PaymentStatusUpdated","UpdatePaymentStatus",function(dat)
	local extra_inf = IGS.IsCurrencyEnabled() and (" (" .. PL_MONEY( IGS.RealPrice(dat.orderSum) ) .. ")") or ""

	local text =
		dat.method == "check" and ("Проверка возможности платежа через " .. dat.paymentType) or
		dat.method == "pay"   and ("Начислено " .. PL_IGS(dat.orderSum) ..  extra_inf) or
		dat.method == "error" and ("Ошибка пополнения счета: " .. dat.errorMessage) or
		"С сервера пришел неизвестный метод " .. tostring(dat.method) .. " и возникла ошибка"

	if !IsValid(m) then
		IGS.ShowNotify(text,"Обновление статуса платежа")
		return
	end

	local pay = nil
	if dat.method == "pay" then
		pay = true
	elseif dat.method == "error" then
		pay = false
	end

	m.log:AddRecord(text,pay)
end)



-- if IsValid(IGS_CHARGE) then
-- 	IGS_CHARGE:Remove()
-- end

-- IGS_CHARGE = IGS.WIN.Deposit()
-- local p = IGS_CHARGE
-- -- timer.Simple(1,function()
-- -- 	p.log:AddRecord("Kek lol heh mda", false)
-- -- end)

-- timer.Simple(600,function()
-- 	if IsValid(p) then
-- 		p:Remove()
-- 		p = nil
-- 	end
-- end)
