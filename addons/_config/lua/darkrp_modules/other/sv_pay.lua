hook.Add("OnNPCKilled", "rp_pay_in_kill_npc", function(victim, attacker, weapon)
    if victim:GetClass() == "npc_antlion" then
        local amount = math.floor(math.random(50,100))
        attacker:addMoney(amount) 
        DarkRP.notify(attacker, 0, 4, DarkRP.getPhrase("npc_killpay", DarkRP.formatMoney(amount)))
    end

    if victim:GetClass() == "npc_antlionguard" then
        local amount = math.floor(math.random(100,500))
        attacker:addMoney(amount) 
        DarkRP.notify(attacker, 0, 4, DarkRP.getPhrase("npc_killpay", DarkRP.formatMoney(amount)))
    end
    
    if victim:GetClass() == "npc_antlionguardian" then
        local amount = math.floor(math.random(1000,2500))
        attacker:addMoney(amount) 
        DarkRP.notify(attacker, 0, 4, DarkRP.getPhrase("npc_killpay", DarkRP.formatMoney(amount)))
    end

    if victim:GetClass() == "npc_barnacle" then
        local amount = math.floor(math.random(50,100))
        attacker:addMoney(amount) 
        DarkRP.notify(attacker, 0, 4, DarkRP.getPhrase("npc_killpay", DarkRP.formatMoney(amount)))
    end

    if victim:GetClass() == "npc_headcrab_fast" then
        local amount = math.floor(math.random(50,100))
        attacker:addMoney(amount) 
        DarkRP.notify(attacker, 0, 4, DarkRP.getPhrase("npc_killpay", DarkRP.formatMoney(amount)))
    end

    if victim:GetClass() == "npc_fastzombie" then
        local amount = math.floor(math.random(50,100))
        attacker:addMoney(amount) 
        DarkRP.notify(attacker, 0, 4, DarkRP.getPhrase("npc_killpay", DarkRP.formatMoney(amount)))
    end

    if victim:GetClass() == "npc_fastzombie_torso" then
        local amount = math.floor(math.random(50,100))
        attacker:addMoney(amount) 
        DarkRP.notify(attacker, 0, 4, DarkRP.getPhrase("npc_killpay", DarkRP.formatMoney(amount)))
    end

    if victim:GetClass() == "npc_headcrab" then
        local amount = math.floor(math.random(50,100))
        attacker:addMoney(amount) 
        DarkRP.notify(attacker, 0, 4, DarkRP.getPhrase("npc_killpay", DarkRP.formatMoney(amount)))
    end

    if victim:GetClass() == "npc_headcrab_black" then
        local amount = math.floor(math.random(50,100))
        attacker:addMoney(amount) 
        DarkRP.notify(attacker, 0, 4, DarkRP.getPhrase("npc_killpay", DarkRP.formatMoney(amount)))
    end

    if victim:GetClass() == "npc_poisonzombie" then
        local amount = math.floor(math.random(50,100))
        attacker:addMoney(amount) 
        DarkRP.notify(attacker, 0, 4, DarkRP.getPhrase("npc_killpay", DarkRP.formatMoney(amount)))
    end

    if victim:GetClass() == "npc_zombie" then
        local afsdadsgfv = 70
        attacker:addMoney(afsdadsgfv) 
        DarkRP.notify(attacker, 0, 4, DarkRP.getPhrase("npc_killpay", DarkRP.formatMoney(afsdadsgfv)))
    end

    if victim:GetClass() == "npc_zombie_torso" then
        local amount = math.floor(math.random(50,100))
        attacker:addMoney(amount) 
        DarkRP.notify(attacker, 0, 4, DarkRP.getPhrase("npc_killpay", DarkRP.formatMoney(amount)))
    end
end)