local Utility = {}

local Players = game:GetService("Players")
local player = Players.LocalPlayer

function Utility:GetPlayer(input)
    if not input then return nil end
    input = string.lower(tostring(input))
    for _, plr in ipairs(Players:GetPlayers()) do
        if string.lower(plr.Name) == input or string.lower(plr.DisplayName or "") == input then
            return plr
        end
        if string.sub(string.lower(plr.Name), 1, #input) == input then
            return plr
        end
        if tostring(plr.UserId) == input then
            return plr
        end
    end
    return nil
end

function Utility:GetTargets(param, includeSelf)
    local targets = {}
    if not param or param == "" then return targets end
    local low = string.lower(param)
    
    if low == "all" then
        for _, plr in ipairs(Players:GetPlayers()) do
            if (includeSelf or plr ~= player) then
                table.insert(targets, plr)
            end
        end
    elseif low == "others" then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player then
                table.insert(targets, plr)
            end
        end
    elseif low == "me" then
        table.insert(targets, player)
    else
        local plr = self:GetPlayer(param)
        if plr and (includeSelf or plr ~= player) then
            table.insert(targets, plr)
        end
    end
    return targets
end

function Utility:CheckHealth(target)
    if not target then return end
    local char = target.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    print(string.format("[Health] %s - HP: %.0f/%.0f | Speed: %.0f", target.Name, hum.Health, hum.MaxHealth, hum.WalkSpeed))
end

function Utility:CheckAllHealth()
    for _, plr in ipairs(Players:GetPlayers()) do
        self:CheckHealth(plr)
    end
end

function Utility:TestGodMode(targetName)
    local target = self:GetPlayer(targetName) or player
    self:CheckHealth(target)
    print("[Test] Testing godmode on " .. target.Name)
end

function Utility:CheckBackpack()
    local bp = player:FindFirstChild("Backpack")
    local char = player.Character
    print("\n-- Backpack Check --")
    if bp then
        for _, tool in ipairs(bp:GetChildren()) do
            if tool:IsA("Tool") then print("  Found: " .. tool.Name) end
        end
    end
    if char then
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") then print("  Found: " .. tool.Name) end
        end
    end
    print("")
end

function Utility:ClearScreen()
    pcall(function()
        local starterGui = game:GetService("StarterGui")
        for _, v in ipairs(starterGui:GetChildren()) do
            if v.Name == "SignUI" or v.Name == "Notifications" or v.Name == "JoinGroupFrame" or v.Name == "Staff" then
                v:Destroy()
            end
        end
        local bp = player:FindFirstChild("Backpack")
        if bp and bp:FindFirstChild("Sign") then bp.Sign:Destroy() end
    end)
end

function Utility:ShowHelp(liquid)
    print("\n" .. string.rep("-", 50))
    print("Liquid Admin Commands (Prefix: " .. liquid.Vars.Prefix .. ")")
    print(string.rep("-", 50))
    print("\n[Combat]")
    print("  kill/k <target> - Kill player(s)")
    print("  inf/i <target> - Give infinite health")
    print("  god - Godmode on self")
    print("  nan/n <target> - Apply NaN health")
    print("  blind/b <target> - Blind player(s)")
    print("  perm/p <target> - Permanently blind player(s)")
    print("  grab/gr <name> - Grab player by head")
    print("  grabv2/gr2 <name> - Grab v2 with turkey leg")
    print("  snowball/sb <name> - Snowball attack")
    print("  espls/el <name> - ESP lock-on")
    print("  egg/e <name> - Egg touch")
    print("  anchorv2/av2 - Anchor yourself")
    print("\n[Auto Features]")
    print("  ak - Auto kill toggle")
    print("  ab - Auto blind toggle")
    print("  ai - Auto inf toggle")
    print("  ap - Auto permablind toggle")
    print("  an - Auto nan toggle")
    print("  astop - Stop all auto")
    print("  at <target> - Set auto target")
    print("\n[Loops]")
    print("  loopinf <target> - Loop infinite health")
    print("  stoploopinf - Stop loop inf")
    print("  loopnan <target> - Loop nan health")
    print("  stoploopnan - Stop loop nan")
    print("  loopgod - Loop godmode")
    print("  stoploopgod - Stop loop god")
    print("\n[Protection]")
    print("  agpp - Toggle Anti-Gameplay-Pause")
    print("  wl add/remove/list <name> - Whitelist manager")
    print("  uwl <name> - Remove from whitelist")
    print("  bl add/remove/list <name> - Blacklist manager")
    print("  ubl <name> - Remove from blacklist")
    print("  save - Save data")
    print("\n[Utility]")
    print("  skintone/st <name> - Check skin tone")
    print("  skintoneall/sta - Log all skin tones")
    print("  viewskintones/vst - View skin tone log")
    print("  clearskintones/cst - Clear skin tone log")
    print("  health/hp <name> - Check health")
    print("  healthall/hpa - Check all health")
    print("  testgod/test <name> - Test godmode")
    print("  ping - Check ping")
    print("  gc - Check backpack")
    print("  clear - Remove screen clutter")
    print("  rejoin/rj - Rejoin game")
    print("  hop - Hop server")
    print("  prefix <char> - Change command prefix")
    print("  debug/d - Toggle debug mode")
    print("\n[External Tools]")
    print("  spy - Load remote spy")
    print("  cobalt - Load cobalt")
    print("  hydro - Load hydroxide")
    print("  dex - Load dex explorer")
    print("\n[Help]")
    print("  help/cmds - Show this list")
    print("  explain - Detailed help")
    print("  requirements/req - Tool requirements")
    print("\n" .. string.rep("-", 50))
end

function Utility:Explain(liquid)
    self:ShowHelp(liquid)
end

function Utility:ShowRequirements()
    print("\n" .. string.rep("-", 60))
    print("Liquid Admin - Tool Requirements")
    print(string.rep("-", 60))
    print("\nCommands requiring Diamond Blade Sword:")
    print("  kill, inf, god, blind, perm")
    print("\nCommands requiring Chartreuse Periastron Gamma + Lock On Launcher:")
    print("  nan")
    print("\nCommands requiring Remote Explosive Detonator + Mega Annoying Megaphone:")
    print("  grab")
    print("\nCommands requiring Remote Explosive Detonator + Turkey Leg:")
    print("  grabv2")
    print("\nCommands requiring Lock On Launcher + Spartan Sword and Shield:")
    print("  espls")
    print("\nCommands requiring Dracovin Spellbook + Hyperlaser Gun:")
    print("  snowball")
    print("\nCommands requiring SwordOfLight:")
    print("  anchorv2")
    print("\nCommands requiring Joyful Periastron:")
    print("  egg")
    print("\n" .. string.rep("-", 60) .. "\n")
end

return Utility