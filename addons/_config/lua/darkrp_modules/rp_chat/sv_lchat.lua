local function itChat(ply, args)
	if args == "" then return "" end
	DarkRP.talkToRange(ply, args.." ("..ply:Nick()..")","", 200)
	return ""
end
DarkRP.defineChatCommand("it", itChat)