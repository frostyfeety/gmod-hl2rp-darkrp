local function intToIp(int)
	local a = bit.band(int, 0xFF000000)
	local b = bit.band(int, 0x00FF0000)
	local c = bit.band(int, 0x0000FF00)
	local d = bit.band(int, 0x000000FF)

	a = bit.rshift(a, 24)
	b = bit.rshift(b, 16)
	c = bit.rshift(c, 8)

	local ip = a .. "." .. b .. "." .. c .. "." .. d
	return ip
end

local function getHostIp()
	return intToIp( GetConVarString("hostip") ) -- game.GetIPAddress():Split(":")[1] (0.0.0.0)
end

local function getHostPort()
	return tonumber( game.GetIPAddress():match(":(.+)$") )
end




-- После вызова этой функции загружается вторая часть скрипта
-- Т.е. не вызвать функцию - не запустится скрипт
-- Она не вызывается, если сервер отключен или произошла ошибка в ходе выполнения запроса на получение списка серверов
local function onReady()
	IGS.SERVERS.Broadcast()
	hook.Run("IGS.ServersLoaded")
	IGS.SetServerVersion(IGS.Version)
end

local function addServerLocally(id, serv_name, enabled)
	if true    then IGS.SERVERS.TOTAL   = IGS.SERVERS.TOTAL   + 1 end
	if enabled then IGS.SERVERS.ENABLED = IGS.SERVERS.ENABLED + 1 end

	IGS.SERVERS.MAP[id] = serv_name
end

local function addCurrentServerLocally(id, serv_name, sock_port)
	IGS.SERVERS.CURRENT = id
	addServerLocally(id, serv_name, true)

	IGS.C.SOCKETPORT = sock_port
end

local function registerCurrentServer(local_ip,port, fOnSuccess)
	IGS.AddServer(local_ip, port, function(id)
		IGS.print(
			"CEPBEP 3APEruCTPuPOBAH nOg ig: " .. id .. "\n" ..
			"HACTPOuKu B gm-donate.ru/panel/projects/" .. IGS.C.ProjectID
		)

		local sock_port = port + 10
		local serv_name = GetConVarString("hostname")
		addCurrentServerLocally(id, serv_name, sock_port) -- нужно снаружи SetServerSocketPort для IGS.SERVERS:ID()
		IGS.SetServerName( serv_name )
		IGS.SetServerSocketPort(sock_port, function()
			fOnSuccess()

			IGS.print(
				"COKET CEPBEPA HACTpOEH. nOPT: " .. sock_port .. "\n" ..
				"ECJIu C4ET nOnOJIH9ETC9 HE MrHOBEHHO, TO CMEHuTE IP HA 6OJIEE 6JIU3Kuu K nOPTy CEPBEPA"
			)
		end)

		bib.set("igs:serverid", id)
	end)
end

local function loadServersOrRegisterCurrent(d, local_ip)
	local serv_port = getHostPort()

	-- reset
	IGS.SERVERS.TOTAL   = 0
	IGS.SERVERS.ENABLED = 0

	local maxVisibleServerId = 0 -- больший ид может быть архивированным
	local isCurrentDisabled
	for _,v in ipairs(d) do -- -- `ID`,`Name`,`IP`,`Port`,`SocketPort`,`Disabled`
		local disabled = tobool(v.Disabled)
		maxVisibleServerId = math.max(v.ID, maxVisibleServerId)

		-- Текущий сервер
		if v.IP == local_ip and v.Port == serv_port then
			if disabled then isCurrentDisabled = true end
			addCurrentServerLocally(v.ID, v.Name, v.SocketPort) -- sock may be nil
		else
			addServerLocally(v.ID, v.Name, !disabled)
		end
	end

	-- limit 50
	if maxVisibleServerId > 40 then
		IGS.print(Color(255,50,50),
			"y IIpoekTa 6oJIee 40 3arerucTpuPoBaHHbIx cepBepoB.\n" ..
			"IIo gocTu}{eHuIO 50 cepBepoB HoBbIe IIepectaHyT co3gaBaTbC9 u 3tot He 3arpy3uTc9.\n" ..
			"O6HoBJI9uTe IP IIpowJIbIX uJIu co3gauTe HoBbIu IIpoeKT"
		)
	end

	if isCurrentDisabled then
		IGS.print(Color(255,50,50), "3TOT CEPBEP OTKJII04EH. 3ArPy3KA nPEKPAwEHA")
		return -- не даем выполнить onReady()
	end

	-- Сервер не зарегистрирован
	if !IGS.SERVERS.CURRENT then
		local id_before = bib.getNum("igs:serverid")
		if id_before and IGS.SERVERS(id_before) then
			IGS.print("IIOXO}{E 3TOT CEPBEP IIEPEEXAJI (CMEHA IP)")
			IGS.UpdateServerAddress(id_before, local_ip, serv_port, function()
				IGS.GetServers(function(dat)
					loadServersOrRegisterCurrent(dat, local_ip)
				end, true)
			end)

		else
			IGS.print("3TOT CEPBEP HE 3APEruCTPuPOBAH. CO39AEM!")
			registerCurrentServer(local_ip,serv_port, onReady)
		end
	else
		onReady()
	end
end




local function ipToInt(ip)
	local int = 0
	local p1,p2,p3,p4 = ip:match("(%d+)%.(%d+)%.(%d+)%.(%d+)")
	int = int + bit.lshift(p1,24)
	int = int + bit.lshift(p2,16)
	int = int + bit.lshift(p3,8)
	int = int + p4
	return int
end

local function maskHasIP(mask, ip)
	local maskip,bits = mask:match("(%d+.%d+.%d+.%d+)/(%d+)")
	maskip = ipToInt(maskip)

	local netmask = bit.lshift(0xFFFFFFFF, 32 - bits)
	return bit.band(maskip,netmask) == bit.band(ipToInt(ip),netmask)
end

-- NAT?
local function isIpInternal(ip)
	for _,mask in ipairs({"192.168.0.0/16", "172.16.0.0/12", "10.0.0.0/8"}) do
		if maskHasIP(mask, ip) then
			return true
		end
	end
end




local function getAndLoadServers(local_ip)
	IGS.GetServers(function(dat)
		loadServersOrRegisterCurrent(dat, local_ip)
	end, true) -- include disabled
end

timer.Simple(0,function() -- фетч заработает только так в этот момент
	local ip = getHostIp()
	-- ip = "192.168.5.6"

	if isIpInternal(ip) then
		IGS.GetExternalIP(getAndLoadServers)
	else
		getAndLoadServers(ip)
	end
end)

local function renewAddressAndReloadServers(ip)
	IGS.UpdateServerAddress(IGS.SERVERS:ID(), ip, getHostPort(), function()
		IGS.GetServers(function(dat)
			loadServersOrRegisterCurrent(dat, ip)
		end, true)
	end)
end

hook.Add("IGS.OnApiError","UpdateIPIfChanged",function(_, error_uid)
	if error_uid == "ip_not_whitelisted" then
		IGS.print(Color(250,50,50), "IIoxo}{e IP xocTa cMeHuJIc9. O6HoBJI9eM B IIaHeJIu")
		IGS.GetExternalIP(renewAddressAndReloadServers)
	end
end)

hook.Add("IGS.OnApiError", "IncorrectAuth", function(_, error_uid)
	if error_uid == "invalid_auth" then
		IGS.print(Color(255,0,0), "YKa3aH HeKoppeKTHblu KJlIO4 uJlu ID IIpoeKTa B config_sv.lua")
	end
end)

hook.Add("IGS.OnApiError","NotifyAboutImpossibleLoading",function(sMethod)
	if sMethod == "/servers/get" then
		IGS.print(Color(255,0,0), "NEVOZMOZNO ZAGRUZIT SKRIPT. VAZNIE DANNIE NE POLUCHENI")
	end
end)
