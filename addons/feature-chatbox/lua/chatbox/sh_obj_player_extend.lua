
local meta = FindMetaTable("Player")

meta.IsTyping = meta.OldIsTyping or meta.IsTyping

function meta:IsTyping()
	return self:GetNWBool("LOUNGE_CHAT.Typing")
end
