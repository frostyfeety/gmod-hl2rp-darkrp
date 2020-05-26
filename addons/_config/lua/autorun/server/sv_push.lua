local PushKaifSounds = {
	"physics/body/body_medium_impact_soft1.wav",
	"physics/body/body_medium_impact_soft2.wav",
	"physics/body/body_medium_impact_soft3.wav",
	"physics/body/body_medium_impact_soft4.wav",
	"physics/body/body_medium_impact_soft5.wav",
	"physics/body/body_medium_impact_soft6.wav",
	"physics/body/body_medium_impact_soft7.wav",
}

local push = {}
local cntpush = {}

hook.Add( "KeyPress", "rp_push_player", function( ply, key )
	if key == IN_USE and !(push[ply:UserID()]) && !cntpush[ ply:UserID() ] then
		local ent = ply:GetEyeTrace().Entity
		if ply and ply:IsValid() and ent and ent:IsValid() and not ply:GetNWBool("Ghost") then
			if ply:IsPlayer() and ent:IsPlayer() and ply:isOTA() and ply:GetModel() ~= "models/player/soldier_stripped.mdl" then
				if ply:GetPos():Distance( ent:GetPos() ) <= 100 then
					if ent:Alive() and ent:GetMoveType() == MOVETYPE_WALK then
						ply:EmitSound( PushKaifSounds[math.random(#PushKaifSounds) ], 50, 100 )

						local velAng = ply:EyeAngles():Forward()

						velAng.z = 0.3

						ent:SetVelocity( velAng * 500 )
						ent:ViewPunch( Angle( math.random( -5, 5 ), math.random( -5, 5 ), 0 ) )

						push[ply:UserID()] = true

						timer.Simple( 0.1, function() push[ ply:UserID() ] = false end )

						cntpush[ ply:UserID() ] = true

						timer.Simple( 2, function() cntpush[ ply:UserID() ] = false end )
					end
				end
			end
		end
	end
end)
