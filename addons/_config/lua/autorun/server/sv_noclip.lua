hook.Add("PlayerNoClip", "rp_noclip_access", function(ply)
    if IsValid(ply) and ( ply:GetUserGroup() == "founder" or ply:Team() == TEAM_ADMIN ) then
       return true
    else
        return false
    end
end)