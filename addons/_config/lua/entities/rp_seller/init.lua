AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
include("shared.lua");

local vodka_no_sound = {
	"vo/npc/male01/gethellout.wav",
	"vo/npc/male01/no02.wav",
	"vo/npc/male01/no01.wav",
	"vo/npc/male01/ohno.wav"	
}

local vodka_yes_n = {
	"Принеси мне что-то.",
	"Ну, а что мне брать?!",
	"Опять с пустыми руками?"
}

local vodka_yes_e = {
	"Хорошая работа",
	"Спасибо",
	"Угу"
}

local vodka_yes_sound = {
	"vo/npc/male01/yeah02.wav",
	"vo/npc/male01/finally.wav",
	"vo/npc/male01/oneforme.wav",
}


local metalprice = 150
local vodkaprice = 100

function ENT:Initialize()
	self:SetModel("models/odessa.mdl");
	self:SetHullType(HULL_HUMAN);
	self:SetHullSizeNormal();
	self:SetNPCState(NPC_STATE_SCRIPT);
	self:SetSolid(SOLID_BBOX);
	self:SetUseType(SIMPLE_USE);
	self:SetBloodColor(BLOOD_COLOR_RED);
end

function ENT:AcceptInput(name, activator, caller)	
	if (!self.nextUse or CurTime() >= self.nextUse) then
		if (name == "Use" and caller:IsPlayer() and (caller:GetNWInt("rp_electro") == 0) and (caller:GetNWInt("rp_metal") == 0)) then
			caller:SendLua("local tab = {Color(1,241,249,255), [[Артем: ]], Color(255,255,255), [["..table.Random(vodka_yes_n).."]] } chat.AddText(unpack(tab))");
			timer.Simple(0.25, function() self:EmitSound(table.Random(vodka_no_sound), 50, 100) end);
		elseif (name == "Use") and (caller:IsPlayer()) or (caller:GetNWInt("rp_electro") > 0) and (caller:GetNWInt("rp_metal") > 0) then	
			caller:addMoney(caller:GetNWInt("rp_electro")*vodkaprice+caller:GetNWInt("rp_metal")*metalprice);

			caller:SendLua("local tab = {Color(1,241,249,255), [[Артем: ]], Color(255,255,255), [["..table.Random(vodka_yes_e)..", вот, ]], Color(128, 255, 128), [["..caller:GetNWInt("rp_metal")*metalprice+caller:GetNWInt("rp_electro")*vodkaprice.."$.]] } chat.AddText(unpack(tab))");
			caller:SetNWInt("rp_electro", 0);
			caller:SetNWInt("rp_metal", 0);
			timer.Simple(0.25, function() self:EmitSound(table.Random(vodka_yes_sound), 50, 100) end);
			timer.Simple(2.5, function() self:EmitSound("vo/npc/male01/moan0"..math.random(1, 5)..".wav", 50, 100) end);
		end	
		self.nextUse = CurTime() + 1;
	end;
end;