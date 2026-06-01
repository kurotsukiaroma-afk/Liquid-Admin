local Core = {}

function Core:Execute(cmd, args, liquid)
    local parts = {}
    for part in string.gmatch(cmd, "[^/]+") do
        table.insert(parts, part)
    end
    local mainCmd = parts[1]
    
    if mainCmd == "kill" or mainCmd == "k" then
        local targets = liquid.Utility:GetTargets(args, true)
        if #targets > 0 then
            local count = 0
            for _, target in ipairs(targets) do
                if liquid.Combat:Kill(target) then count = count + 1 end
                task.wait(0.05)
            end
            liquid:CreateNotification("Liquid", "Killed " .. count .. " player(s)", 3)
        else
            liquid:CreateNotification("Liquid", "Usage: kill <target>", 3, "alert")
        end
    
    elseif mainCmd == "inf" or mainCmd == "i" then
        local targets = liquid.Utility:GetTargets(args, true)
        if #targets > 0 then
            local count = 0
            for _, target in ipairs(targets) do
                if liquid.Combat:GiveInf(target) then count = count + 1 end
                task.wait(0.1)
            end
            liquid:CreateNotification("Liquid", "Infinite health given to " .. count .. " player(s)", 3)
        else
            liquid:CreateNotification("Liquid", "Usage: inf <target>", 3, "alert")
        end
    
    elseif mainCmd == "god" then
        if liquid.Combat:GodMode() then
            liquid:CreateNotification("Liquid", "Godmode activated", 3)
        else
            liquid:CreateNotification("Liquid", "Godmode failed", 3, "alert")
        end
    
    elseif mainCmd == "nan" or mainCmd == "n" then
        local targets = liquid.Utility:GetTargets(args, false)
        if #targets > 0 then
            local count = 0
            for _, target in ipairs(targets) do
                if liquid.Combat:ApplyNan(target) then count = count + 1 end
                task.wait(0.5)
            end
            liquid:CreateNotification("Liquid", "Nan health applied to " .. count .. " player(s)", 3)
        else
            liquid:CreateNotification("Liquid", "Usage: nan <target>", 3, "alert")
        end
    
    elseif mainCmd == "blind" or mainCmd == "b" then
        local targets = liquid.Utility:GetTargets(args, false)
        if #targets > 0 then
            local count = 0
            for _, target in ipairs(targets) do
                if liquid.Combat:Blind(target) then count = count + 1 end
                task.wait(0.1)
            end
            liquid:CreateNotification("Liquid", "Blinded " .. count .. " player(s)", 3)
        else
            liquid:CreateNotification("Liquid", "Usage: blind <target>", 3, "alert")
        end
    
    elseif mainCmd == "perm" or mainCmd == "p" then
        local targets = liquid.Utility:GetTargets(args, false)
        if #targets > 0 then
            local count = 0
            for _, target in ipairs(targets) do
                if liquid.Combat:PermaBlind(target) then count = count + 1 end
                task.wait(0.2)
            end
            liquid:CreateNotification("Liquid", "Permablinded " .. count .. " player(s)", 3)
        else
            liquid:CreateNotification("Liquid", "Usage: perm <target>", 3, "alert")
        end
    
    elseif mainCmd == "grab" or mainCmd == "gr" then
        if args and args ~= "" then
            liquid.Combat:Grab(args)
        else
            liquid:CreateNotification("Liquid", "Usage: grab <name>", 3, "alert")
        end
    
    elseif mainCmd == "grabv2" or mainCmd == "gr2" then
        if args and args ~= "" then
            liquid.Combat:GrabV2(args)
        else
            liquid:CreateNotification("Liquid", "Usage: grabv2 <name>", 3, "alert")
        end
    
    elseif mainCmd == "snowball" or mainCmd == "sb" then
        if args and args ~= "" then
            liquid.Combat:Snowball(args)
        else
            liquid:CreateNotification("Liquid", "Usage: snowball <name>", 3, "alert")
        end
    
    elseif mainCmd == "espls" or mainCmd == "el" then
        if args and args ~= "" then
            liquid.Combat:ESPLockOn(args)
        else
            liquid:CreateNotification("Liquid", "Usage: espls <name>", 3, "alert")
        end
    
    elseif mainCmd == "egg" or mainCmd == "e" then
        if args and args ~= "" then
            liquid.Combat:Egg(args)
        else
            liquid:CreateNotification("Liquid", "Usage: egg <name>", 3, "alert")
        end
    
    elseif mainCmd == "anchorv2" or mainCmd == "av2" then
        liquid.Combat:AnchorV2()
    
    elseif mainCmd == "agpp" then
        liquid.Vars.AntiPauseEnabled = not liquid.Vars.AntiPauseEnabled
        if liquid.Vars.AntiPauseEnabled then
            liquid.AntiPause:Start()
            liquid:CreateNotification("Liquid", "Anti-Pause ENABLED", 2)
        else
            liquid.AntiPause:Stop()
            liquid:CreateNotification("Liquid", "Anti-Pause DISABLED", 2)
        end
    
    elseif mainCmd == "skintone" or mainCmd == "st" then
        local target = liquid.Utility:GetPlayer(args) or game:GetService("Players").LocalPlayer
        local skin = liquid.SkinTone:Get(target.Character)
        liquid:CreateNotification("Liquid", target.Name .. ": " .. skin, 3)
    
    elseif mainCmd == "skintoneall" or mainCmd == "sta" then
        liquid.SkinTone:LogAll()
        liquid:CreateNotification("Liquid", "Logged all skin tones", 3)
    
    elseif mainCmd == "viewskintones" or mainCmd == "vst" then
        liquid.SkinTone:View()
        liquid:CreateNotification("Liquid", "Skin tones printed to console", 3)
    
    elseif mainCmd == "clearskintones" or mainCmd == "cst" then
        liquid.SkinTone:Clear()
        liquid:CreateNotification("Liquid", "Skin tone log cleared", 2)
    
    elseif mainCmd == "wl" then
        local sub = parts[2]
        local name = parts[3]
        if sub == "add" and name then
            liquid.Whitelist:Add(name)
        elseif sub == "remove" and name then
            liquid.Whitelist:Remove(name)
        elseif sub == "list" then
            liquid.Whitelist:List()
        else
            liquid:CreateNotification("Liquid", "Usage: wl add/remove/list <name>", 3, "alert")
        end
    
    elseif mainCmd == "uwl" then
        liquid.Whitelist:Remove(args)
    
    elseif mainCmd == "bl" then
        local sub = parts[2]
        local name = parts[3]
        if sub == "add" and name then
            liquid.Blacklist:Add(name)
        elseif sub == "remove" and name then
            liquid.Blacklist:Remove(name)
        elseif sub == "list" then
            liquid.Blacklist:List()
        else
            liquid:CreateNotification("Liquid", "Usage: bl add/remove/list <name>", 3, "alert")
        end
    
    elseif mainCmd == "ubl" then
        liquid.Blacklist:Remove(args)
    
    elseif mainCmd == "save" then
        liquid:Save()
        liquid:CreateNotification("Liquid", "Data saved", 2)
    
    elseif mainCmd == "ak" then
        liquid.Vars.Auto.Kill = not liquid.Vars.Auto.Kill
        if liquid.Vars.Auto.Kill then liquid.Auto:Start(liquid) else liquid.Auto:Stop() end
        liquid:CreateNotification("Liquid", "Auto kill " .. (liquid.Vars.Auto.Kill and "ON" or "OFF"), 2)
    
    elseif mainCmd == "ab" then
        liquid.Vars.Auto.Blind = not liquid.Vars.Auto.Blind
        if liquid.Vars.Auto.Blind then liquid.Auto:Start(liquid) else liquid.Auto:Stop() end
        liquid:CreateNotification("Liquid", "Auto blind " .. (liquid.Vars.Auto.Blind and "ON" or "OFF"), 2)
    
    elseif mainCmd == "ai" then
        liquid.Vars.Auto.Inf = not liquid.Vars.Auto.Inf
        if liquid.Vars.Auto.Inf then liquid.Auto:Start(liquid) else liquid.Auto:Stop() end
        liquid:CreateNotification("Liquid", "Auto inf " .. (liquid.Vars.Auto.Inf and "ON" or "OFF"), 2)
    
    elseif mainCmd == "ap" then
        liquid.Vars.Auto.Perm = not liquid.Vars.Auto.Perm
        if liquid.Vars.Auto.Perm then liquid.Auto:Start(liquid) else liquid.Auto:Stop() end
        liquid:CreateNotification("Liquid", "Auto permablind " .. (liquid.Vars.Auto.Perm and "ON" or "OFF"), 2)
    
    elseif mainCmd == "an" then
        liquid.Vars.Auto.Nan = not liquid.Vars.Auto.Nan
        if liquid.Vars.Auto.Nan then liquid.Auto:Start(liquid) else liquid.Auto:Stop() end
        liquid:CreateNotification("Liquid", "Auto nan " .. (liquid.Vars.Auto.Nan and "ON" or "OFF"), 2)
    
    elseif mainCmd == "astop" then
        liquid.Vars.Auto.Kill = false
        liquid.Vars.Auto.Blind = false
        liquid.Vars.Auto.Inf = false
        liquid.Vars.Auto.Perm = false
        liquid.Vars.Auto.Nan = false
        liquid.Auto:Stop()
        liquid:CreateNotification("Liquid", "All auto features stopped", 2)
    
    elseif mainCmd == "at" then
        if args and args ~= "" then
            liquid.Vars.Auto.Target = args
            liquid:CreateNotification("Liquid", "Auto target set to: " .. args, 2)
        else
            liquid:CreateNotification("Liquid", "Current auto target: " .. liquid.Vars.Auto.Target, 2)
        end
    
    elseif mainCmd == "loopinf" then
        liquid.Loops:StartInf(args, liquid)
        liquid:CreateNotification("Liquid", "Loop inf started on: " .. (args or "others"), 2)
    
    elseif mainCmd == "stoploopinf" then
        liquid.Loops:StopInf()
        liquid:CreateNotification("Liquid", "Loop inf stopped", 2)
    
    elseif mainCmd == "loopnan" then
        liquid.Loops:StartNan(args, liquid)
        liquid:CreateNotification("Liquid", "Loop nan started on: " .. (args or "others"), 2)
    
    elseif mainCmd == "stoploopnan" then
        liquid.Loops:StopNan()
        liquid:CreateNotification("Liquid", "Loop nan stopped", 2)
    
    elseif mainCmd == "loopgod" then
        liquid.Loops:StartGod(liquid)
        liquid:CreateNotification("Liquid", "Loop godmode started", 2)
    
    elseif mainCmd == "stoploopgod" then
        liquid.Loops:StopGod()
        liquid:CreateNotification("Liquid", "Loop godmode stopped", 2)
    
    elseif mainCmd == "health" or mainCmd == "hp" then
        local target = liquid.Utility:GetPlayer(args) or game:GetService("Players").LocalPlayer
        liquid.Utility:CheckHealth(target)
    
    elseif mainCmd == "healthall" or mainCmd == "hpa" then
        liquid.Utility:CheckAllHealth()
    
    elseif mainCmd == "testgod" or mainCmd == "test" then
        liquid.Utility:TestGodMode(args)
    
    elseif mainCmd == "gc" then
        liquid.Utility:CheckBackpack()
    
    elseif mainCmd == "clear" then
        liquid.Utility:ClearScreen()
        liquid:CreateNotification("Liquid", "Screen clutter removed", 2)
    
    elseif mainCmd == "rejoin" or mainCmd == "rj" then
        liquid:CreateNotification("Liquid", "Rejoining...", 2)
        game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
    
    elseif mainCmd == "hop" then
        liquid:CreateNotification("Liquid", "Hopping server...", 2)
        game:GetService("TeleportService"):Teleport(game.PlaceId)
    
    elseif mainCmd == "ping" then
        local ping = math.floor(game:GetService("Players").LocalPlayer:GetNetworkPing() * 1000)
        liquid:CreateNotification("Liquid", "Ping: " .. ping .. "ms", 2)
    
    elseif mainCmd == "debug" or mainCmd == "d" then
        liquid.Vars.Debug = not liquid.Vars.Debug
        liquid:CreateNotification("Liquid", "Debug mode " .. (liquid.Vars.Debug and "ON" or "OFF"), 2)
    
    elseif mainCmd == "prefix" then
        if args and args ~= "" then
            liquid.Vars.Prefix = args
            liquid:Save()
            liquid:CreateNotification("Liquid", "Prefix changed to: " .. args, 2)
        else
            liquid:CreateNotification("Liquid", "Current prefix: " .. liquid.Vars.Prefix, 2)
        end
    
    elseif mainCmd == "help" or mainCmd == "cmds" then
        liquid.Utility:ShowHelp(liquid)
    
    elseif mainCmd == "explain" then
        liquid.Utility:Explain(liquid)
    
    elseif mainCmd == "requirements" or mainCmd == "req" then
        liquid.Utility:ShowRequirements()
    
    elseif mainCmd == "spy" then
        loadstring(game:HttpGet('https://raw.githubusercontent.com/Liquid-Admin/Modules/main/SimpleSpy.lua'))()
        liquid:CreateNotification("Liquid", "Loading remote spy...", 2)
    
    elseif mainCmd == "cobalt" then
        loadstring(game:HttpGet('https://raw.githubusercontent.com/Liquid-Admin/Modules/main/Cobalt.lua'))()
        liquid:CreateNotification("Liquid", "Loading cobalt...", 2)
    
    elseif mainCmd == "hydro" then
        loadstring(game:HttpGet('https://raw.githubusercontent.com/Liquid-Admin/Modules/main/Hydroxide.lua'))()
        liquid:CreateNotification("Liquid", "Loading hydroxide...", 2)
    
    elseif mainCmd == "dex" then
        loadstring(game:HttpGet('https://raw.githubusercontent.com/Liquid-Admin/Modules/main/Dex.lua'))()
        liquid:CreateNotification("Liquid", "Loading dex explorer...", 2)
    
    else
        liquid:CreateNotification("Liquid", "Unknown command: " .. mainCmd .. ". Type " .. liquid.Vars.Prefix .. "help", 3, "alert")
    end
end

return Core