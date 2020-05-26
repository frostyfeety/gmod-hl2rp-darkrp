local conf = {
	tchatmsg = "[Сервер]",
	TimeMsg = "300",
}

rank_allowed_msg = "founder"
local function PlayerServ(ply, args)
    if table.HasValue({rank_allowed_msg}, ply:GetNWString("usergroup")) then
            if args == "" then
                    DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", "argument", ""))
                    return ""
        end
        local DoSay = function(text)
                if text == "" then
                        DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", "argument", ""))
                        return
                end
                for k,v in pairs(player.GetAll()) do
                    local col = Color(255,0,0,255)
                    DarkRP.talkToPerson(v, col, conf.tchatmsg, Color(255, 255, 100, 255), text, ply)
            end
        end
        return args, DoSay
    else
        return ""
    end
end

DarkRP.defineChatCommand("msg", PlayerServ, 1.5)

DarkRP.declareChatCommand{
    command = "msg",
    description = "server announcement",
    delay = 1.5
}
