local emote = "** "

local function RollTheDice( ply, args )
	local DoSay = function( text )
		local roll = math.random( 0, 100 )
		local name, text = ply:Nick() .. " имеет шанс", roll .. " из 100"
		DarkRP.talkToRange( ply, name, text, 350 )
		hook.Run('saycommands', ply, name .. ": " .. text)
	end
	return args, DoSay
end
DarkRP.defineChatCommand( "roll", RollTheDice )

local function DoubleDice( ply, args )
	local DoSay = function( text )
		local roll = math.random( 1, 6 )
		local rolltwo = math.random( 1, 6 )
		-- local rolltotal = roll + rolltwo
		local name, text = ply:Nick() .. " бросил кости", roll .. " и " .. rolltwo
		DarkRP.talkToRange( ply, name, text, 350 )
		hook.Run('saycommands', ply, name .. ": " .. text)
	end
	return args, DoSay
end
DarkRP.defineChatCommand( "dice", DoubleDice )

local function RandomCard( ply, args )
	local DoSay = function( text )
		local cards = {
			"туз крестей",
			"двойка крестей",
			"тройка крестей",
			"четвёрка крестей",
			"пятёрка крестей",
			"шестёрка крестей",
			"семёрка крестей",
			"восьмёрка крестей",
			"девятка крестей",
			"десятка крестей",
			"валет крестей",
			"дама крестей",
			"король крестей",
			"туз бубен",
			"двойка бубен",
			"тройка бубен",
			"четвёрка бубен",
			"пятёрка бубен",
			"шестёрка бубен",
			"семёрка бубен",
			"восьмёрка бубен",
			"девятка бубен",
			"десятка бубен",
			"валет бубен",
			"дама бубен",
			"король бубен",
			"туз черв",
			"двойка черв",
			"тройка черв",
			"четвёрка черв",
			"пятёрка черв",
			"шестёрка черв",
			"семёрка черв",
			"восьмёрка черв",
			"девятка черв",
			"десятка черв ",
			"валет черв",
			"дама черв",
			"король черв",
			"туз пик",
			"двойка пик",
			"тройка пик",
			"четвёрка пик",
			"пятёрка пик",
			"шестёрка пик",
			"семёрка пик",
			"восьмёрка пик",
			"девятка пик",
			"десятка пик ",
			"валет пик",
			"дама пик",
			"король пик"
		}
		
		local name, text = ply:Nick() .. " вытащил карту", table.Random( cards )
		DarkRP.talkToRange( ply, name, text, 350 )
		hook.Run('saycommands', ply, name .. ": " .. text)
	end
	return args, DoSay
end
DarkRP.defineChatCommand( "card", RandomCard )

local function RockPaperScissors( ply, args )
	local DoSay = function( text )
		local gestures = {
			"камень",
			"ножницы",
			"бумагу"
		}
		
		local name, text = ply:Nick() .. " показал", table.Random( gestures )
		DarkRP.talkToRange( ply, name, text, 350 )
		hook.Run('saycommands', ply, name .. ": " .. text)
	end
	return args, DoSay
end
DarkRP.defineChatCommand( "rockpaperscissors", RockPaperScissors )