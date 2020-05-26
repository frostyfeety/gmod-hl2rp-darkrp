--[[
DEVELOPMENTAL VERSION

Based on pon 1.2.2 dev https://github.com/thelastpenguin/gLUA-Library
Copyright thelastpenguin 2016

DATA TYPES SUPPORTED:
 - tables  - 		k,v - pointers
 - strings - 		k,v - pointers
 - numbers -		k,v
 - booleans- 		k,v
 - Vectors - 		k,v
 - Angles  -		k,v
 - Entities- 		k,v
 - Players - 		k,v

Кодирование в 16-х дает преимущество
- В некоторых случаях заметно увеличивает скорость сериализации.
- Уменьшает размер строки на массивах с числовыми данными.
- Немного уменьшает скорость декодирования, но по сравнению с приростом незначительно.

По умолчанию смешанные таблицы записываются
начиная с последовательностей, после как пара ключ-значение.
в данной реализации если в таблице есть ключ 0 то next вернет 0.
в результате чего вся таблица будет записана как пара ключ-значение
]]
local pon = {}
_G.pon = pon

local type = type
local tonumber = tonumber
local format = string.format
local insert = table.insert

do
	local encode = {}

	local cacheSize = 0

	encode["table"] = function(tbl, output, cache)
		if cache[tbl] then
			insert(output, format("(%u)", cache[tbl]))
			return
		else
			cacheSize = cacheSize + 1
			cache[tbl] = cacheSize
		end

		local first = next(tbl)
		local predictedNumeric = 1

		-- starts with a sequential type
		if first == 1 then
			insert(output, "{")

			for k, v in next, tbl do
				if k == predictedNumeric then
					predictedNumeric = predictedNumeric + 1

					local tv = type(v)
					if tv == "string" then
						local pid = cache[v]
						if pid then
							insert(output, format("(%u)", pid))
						else
							cacheSize = cacheSize + 1
							cache[v] = cacheSize
							encode.string(v, output)
						end
					else
						encode[tv](v, output, cache)
					end
				else
					break
				end
			end

			predictedNumeric = predictedNumeric - 1
		else
			predictedNumeric = nil
		end

		-- start with dictionary type
		if predictedNumeric == nil then
			insert(output, "[")
		else
			-- break sequential for dictionary
			local kv = next(tbl, predictedNumeric)
			if kv then
				insert(output, "~")
			end
		end

		for k, v in next, tbl, predictedNumeric do
			local tk, tv = type(k), type(v)

			-- WRITE KEY
			if tk == "string" then
				local pid = cache[k]
				if pid then
					insert(output, format("(%u)", pid))
				else
					cacheSize = cacheSize + 1
					cache[k] = cacheSize

					encode.string(k, output)
				end
			else
				encode[tk](k, output, cache)
			end

			-- WRITE VALUE
			if tv == "string" then
				local pid = cache[v]
				if pid then
					insert(output, format("(%u)", pid))
				else
					cacheSize = cacheSize + 1
					cache[v] = cacheSize

					encode.string(v, output)
				end
			else
				encode[tv](v, output, cache)
			end
		end

		insert(output, "}")
	end
	--    ENCODE STRING
	local gsub = string.gsub
	encode["string"] = function(str, output)
		local estr, count = gsub(str, ";", "\\;")
		if count == 0 then
			insert(output, "'" .. str .. ";")
		else
			insert(output, '"' .. estr .. '";')
		end
	end
	--    ENCODE NUMBER
	encode["number"] = function(num, output)
		if num % 1 == 0 then
			if num < 0 then
				insert(output, format("x%x;", -num))
			else
				insert(output, format("X%x;", num))
			end
		else
			insert(output, tonumber(num) .. ";")
		end
	end
	--    ENCODE BOOLEAN
	encode["boolean"] = function(val, output)
		insert(output, val and "t" or "f")
	end
	--    ENCODE VECTOR
	encode["Vector"] = function(val, output)
		insert(output, "v" .. val.x .. "," .. val.y .. "," .. val.z .. ";")
	end
	--    ENCODE ANGLE
	encode["Angle"] = function(val, output)
		insert(output, "a" .. val.p .. "," .. val.y .. "," .. val.r .. ";")
	end
	encode["Entity"] = function(val, output)
		insert(output, "E" .. (IsValid(val) and (val:EntIndex() .. ";") or "#"))
	end
	encode["Player"] = encode["Entity"]
	encode["Vehicle"] = encode["Entity"]
	encode["Weapon"] = encode["Entity"]
	encode["NPC"] = encode["Entity"]
	encode["NextBot"] = encode["Entity"]
	encode["PhysObj"] = encode["Entity"]

	-- untransmittable values fix
	encode["function"] = function(val, output)
		insert(output, 'w')
		-- assert(false, "Invalid type function.")
	end
	encode["userdata"] = function(val, output)
		insert(output, 'u')
		-- assert(false, "Invalid type userdata.")
	end
	encode["thread"] = function(val, output)
		insert(output, 'h')
		-- assert(false, "Invalid type thread.")
	end

	do
		local concat = table.concat
		function pon.encode(tbl)
			assert(istable(tbl), "Table excepted for encode.")

			local output = {}
			cacheSize = 0
			encode["table"](tbl, output, {})
			local res = concat(output)

			return res
		end
	end
end

do
	local tonumber = tonumber
	local find, sub, gsub, Explode = string.find, string.sub, string.gsub, string.Explode
	local Vector, Angle, Entity = Vector, Angle, Entity

	local decode = {}

	-- sequential or mixed table
	decode["{"] = function(index, str, cache)
		local cur = {}
		insert(cache, cur)

		local k = 1
		local v, tv
		while true do
			tv = sub(str, index, index)
			if not tv or tv == "~" then
				index = index + 1
				break
			end
			if tv == "}" then
				return index + 1, cur
			end

			index = index + 1
			index, v = decode[tv](index, str, cache)

			cur[k] = v

			k = k + 1
		end

		-- dictionary after sequential
		local tk
		while true do
			tk = sub(str, index, index)
			if not tk or tk == "}" then
				index = index + 1
				break
			end

			index = index + 1
			index, k = decode[tk](index, str, cache)

			tv = sub(str, index, index)
			index = index + 1
			index, v = decode[tv](index, str, cache)

			cur[k] = v
		end

		return index, cur
	end

	-- dictionary table
	decode["["] = function(index, str, cache)
		local cur = {}
		insert(cache, cur)

		local k, v, tk, tv
		while true do
			tk = sub(str, index, index)
			if not tk or tk == "}" then
				index = index + 1
				break
			end

			index = index + 1
			index, k = decode[tk](index, str, cache)

			tv = sub(str, index, index)
			index = index + 1
			index, v = decode[tv](index, str, cache)

			cur[k] = v
		end

		return index, cur
	end

	-- pointer
	decode["("] = function(index, str, cache)
		local finish = find(str, ")", index, true)
		local num = tonumber(sub(str, index, finish - 1))
		index = finish + 1
		return index, cache[num]
	end

	-- string
	decode["'"] = function(index, str, cache)
		local finish = find(str, ";", index, true)
		local res = sub(str, index, finish - 1)
		index = finish + 1

		insert(cache, res)
		return index, res
	end
	-- escaped string
	decode['"'] = function(index, str, cache)
		local finish = find(str, '";', index, true)
		local res = gsub(sub(str, index, finish - 1), "\\;", ";")
		index = finish + 2

		insert(cache, res)
		return index, res
	end

	-- number
	decode["n"] = function(index, str)
		index = index - 1
		local finish = find(str, ";", index, true)
		local num = tonumber(sub(str, index, finish - 1))
		index = finish + 1
		return index, num
	end
	decode["0"] = decode["n"]
	decode["1"] = decode["n"]
	decode["2"] = decode["n"]
	decode["3"] = decode["n"]
	decode["4"] = decode["n"]
	decode["5"] = decode["n"]
	decode["6"] = decode["n"]
	decode["7"] = decode["n"]
	decode["8"] = decode["n"]
	decode["9"] = decode["n"]
	decode["-"] = decode["n"]
	-- positive hex
	decode["X"] = function(index, str)
		local finish = find(str, ";", index, true)
		local num = tonumber(sub(str, index, finish - 1), 16)
		index = finish + 1
		return index, num
	end
	-- negative hex
	decode["x"] = function(index, str)
		local finish = find(str, ";", index, true)
		local num = -tonumber(sub(str, index, finish - 1), 16)
		index = finish + 1
		return index, num
	end

	-- boolean
	decode["t"] = function(index)
		return index, true
	end
	decode["f"] = function(index)
		return index, false
	end

	-- Vector
	decode["v"] = function(index, str)
		local finish = find(str, ";", index, true)
		local vecStr = sub(str, index, finish - 1)
		index = finish + 1 -- update the index.
		local segs = Explode(",", vecStr, false)
		return index, Vector(tonumber(segs[1]), tonumber(segs[2]), tonumber(segs[3]))
	end
	-- Angle
	decode["a"] = function(index, str)
		local finish = find(str, ";", index, true)
		local angStr = sub(str, index, finish - 1)
		index = finish + 1 -- update the index.
		local segs = Explode(",", angStr, false)
		return index, Angle(tonumber(segs[1]), tonumber(segs[2]), tonumber(segs[3]))
	end
	-- Entity
	decode["E"] = function(index, str)
		if str[index] == "#" then
			index = index + 1
			return index, NULL
		else
			local finish = find(str, ";", index, true)
			local num = tonumber(sub(str, index, finish - 1))
			index = finish + 1
			return index, Entity(num)
		end
	end

	-- untransmittable values fix
	decode["w"] = function(index)
		return index, 'function'
	end
	decode["u"] = function(index)
		return index, 'userdata'
	end
	decode["h"] = function(index)
		return index, 'thread'
	end

	function pon.decode(data)
		assert(isstring(data), "String excepted for decode.")

		local _, res = decode[sub(data, 1, 1)](2, data, {})
		return res
	end
end
