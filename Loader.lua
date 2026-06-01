-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local TeleportService = game:GetService("TeleportService")
local TextChatService = game:GetService("TextChatService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local Prefixes = {",", ".", "$"}

-- Simple Notification System
local function Notify(title, message, duration, style)
    local CoreGui = game:GetService("CoreGui")
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "LiquidNotif"
    screenGui.Parent = CoreGui
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 320, 0, 45)
    notif.Position = UDim2.new(1, -330, 0, 10)
    notif.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
    notif.BackgroundTransparency = 0.05
    notif.BorderSizePixel = 0
    notif.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = notif
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = style == "alert" and Color3.fromRGB(255, 70, 70) or Color3.fromRGB(65, 180, 245)
    stroke.Thickness = 1
    stroke.Transparency = 0.2
    stroke.Parent = notif
    
    local leftBar = Instance.new("Frame")
    leftBar.Size = UDim2.new(0, 3, 1, 0)
    leftBar.Position = UDim2.new(0, 0, 0, 0)
    leftBar.BackgroundColor3 = style == "alert" and Color3.fromRGB(255, 70, 70) or Color3.fromRGB(65, 180, 245)
    leftBar.BorderSizePixel = 0
    leftBar.Parent = notif
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -25, 0, 20)
    titleLabel.Position = UDim2.new(0, 15, 0, 6)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(220, 220, 245)
    titleLabel.TextSize = 13
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = notif
    
    local msgLabel = Instance.new("TextLabel")
    msgLabel.Size = UDim2.new(1, -25, 0, 16)
    msgLabel.Position = UDim2.new(0, 15, 0, 26)
    msgLabel.BackgroundTransparency = 1
    msgLabel.Text = message
    msgLabel.TextColor3 = Color3.fromRGB(160, 160, 185)
    msgLabel.TextSize = 11
    msgLabel.Font = Enum.Font.Gotham
    msgLabel.TextXAlignment = Enum.TextXAlignment.Left
    msgLabel.TextWrapped = true
    msgLabel.Parent = notif
    
    local cmdText = Instance.new("TextLabel")
    cmdText.Size = UDim2.new(0, 60, 1, 0)
    cmdText.Position = UDim2.new(1, -70, 0, 0)
    cmdText.BackgroundTransparency = 1
    cmdText.Text = "LIQUID"
    cmdText.TextColor3 = Color3.fromRGB(65, 180, 245)
    cmdText.TextSize = 9
    cmdText.Font = Enum.Font.GothamBold
    cmdText.TextXAlignment = Enum.TextXAlignment.Right
    cmdText.TextTransparency = 0.5
    cmdText.Parent = notif
    
    notif.Position = UDim2.new(1, -330, 0, 5)
    notif.BackgroundTransparency = 0.2
    
    local fadeIn = TweenService:Create(notif, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.05, Position = UDim2.new(1, -330, 0, 10)})
    fadeIn:Play()
    
    task.spawn(function()
        task.wait(duration or 4)
        local fadeOut = TweenService:Create(notif, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.2, Position = UDim2.new(1, -330, 0, 5)})
        fadeOut:Play()
        fadeOut.Completed:Connect(function() screenGui:Destroy() end)
    end)
end

-- Main Variables
local Vars = {
    Prefix = ",",
    Debug = true,
    AntiPause = true,
    Whitelist = {},
    Blacklist = {},
    Auto = {
        Kill = false, Blind = false, Inf = false, Perm = false, Nan = false, Target = "others"
    },
    Stats = {
        Start = tick(), Kills = 0, Attacks = 0
    }
}

-- Anti-Gameplay-Pause System
local AntiPauseConnection = nil

local function StartAntiPause()
    pcall(function()
        if AntiPauseConnection then AntiPauseConnection:Disconnect() end
        local RobloxGui = CoreGui:FindFirstChild("RobloxGui")
        if not RobloxGui then return end
        pcall(function()
            local networkPause = RobloxGui:FindFirstChild("CoreScripts/NetworkPause")
            if networkPause then networkPause:Destroy() end
        end)
        AntiPauseConnection = RobloxGui.ChildAdded:Connect(function(obj)
            pcall(function()
                if obj.Name == "CoreScripts/NetworkPause" or string.find(obj.Name, "NetworkPause") then
                    obj:Destroy()
                end
            end)
        end)
    end)
end

-- Utility Functions
local function GetPlayer(input)
    if not input then return nil end
    input = string.lower(tostring(input))
    for _, plr in ipairs(Players:GetPlayers()) do
        if string.lower(plr.Name) == input or string.lower(plr.DisplayName or "") == input then
            return plr
        end
        if string.sub(string.lower(plr.Name), 1, #input) == input then return plr end
        if tostring(plr.UserId) == input then return plr end
    end
    return nil
end

local function GetTargets(param, includeSelf)
    local targets = {}
    if not param or param == "" then return targets end
    local low = string.lower(param)
    
    if low == "all" then
        for _, plr in ipairs(Players:GetPlayers()) do
            if includeSelf or plr ~= player then
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
        local plr = GetPlayer(param)
        if plr and (includeSelf or plr ~= player) then
            table.insert(targets, plr)
        end
    end
    return targets
end

local function FindTool(name)
    local char = player.Character
    local bp = player:FindFirstChild("Backpack")
    local tool = bp and bp:FindFirstChild(name)
    if not tool and char then tool = char:FindFirstChild(name) end
    return tool
end

local function GetDiamondRemote()
    local tool = FindTool("Diamond Blade Sword")
    if not tool then return nil end
    local script = tool:FindFirstChild("GearScript") or tool:FindFirstChildWhichIsA("Script")
    if script then return script:FindFirstChild("Controller") end
    return nil
end

-- Combat Functions
local function KillTarget(target)
    local remote = GetDiamondRemote()
    if not remote then return false end
    local hum = target.Character and target.Character:FindFirstChildOfClass("Humanoid")
    if hum and hum.Health > 0 then
        pcall(function() remote:InvokeServer(7, hum, 9999999) end)
        Vars.Stats.Kills = Vars.Stats.Kills + 1
        return true
    end
    return false
end

local function GiveInfiniteHealth(target)
    local remote = GetDiamondRemote()
    if not remote then return false end
    local hum = target.Character and target.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        pcall(function() remote:InvokeServer(7, hum, -math.huge) end)
        return true
    end
    return false
end

-- Whitelist/Blacklist Functions
local function IsWhitelisted(id)
    for _, v in pairs(Vars.Whitelist) do if v == id then return true end end
    return false
end

local function IsBlacklisted(id)
    for _, v in pairs(Vars.Blacklist) do if v == id then return true end end
    return false
end

-- Auto Features
local autoThreads = {Kill = nil, Blind = nil, Inf = nil, Perm = nil, Nan = nil}
local autoRunning = {Kill = false, Blind = false, Inf = false, Perm = false, Nan = false}
local autoTarget = "others"

local function startAutoKill()
    if autoRunning.Kill then return end
    autoRunning.Kill = true
    autoThreads.Kill = task.spawn(function()
        while autoRunning.Kill do
            task.wait(0.5)
            local targets = GetTargets(autoTarget, false)
            for _, t in ipairs(targets) do KillTarget(t) end
        end
    end)
end

local function startAutoInf()
    if autoRunning.Inf then return end
    autoRunning.Inf = true
    autoThreads.Inf = task.spawn(function()
        while autoRunning.Inf do
            task.wait(0.5)
            local targets = GetTargets(autoTarget, false)
            for _, t in ipairs(targets) do GiveInfiniteHealth(t) end
        end
    end)
end

-- Command Handler
local function HandleCommand(msg)
    if type(msg) ~= "string" then return end
    if string.sub(msg, 1, 1) ~= Vars.Prefix then return end
    
    local parts = {}
    for part in string.gmatch(string.sub(msg, 2), "%S+") do
        table.insert(parts, part)
    end
    if #parts == 0 then return end
    
    local cmd = string.lower(parts[1])
    local args = table.concat(parts, " ", 2)
    
    if cmd == "kill" or cmd == "k" then
        local targets = GetTargets(args, true)
        local count = 0
        for _, t in ipairs(targets) do if KillTarget(t) then count = count + 1 end end
        Notify("Liquid", "Killed " .. count .. " player(s)", 3)
    
    elseif cmd == "inf" or cmd == "i" then
        local targets = GetTargets(args, true)
        local count = 0
        for _, t in ipairs(targets) do if GiveInfiniteHealth(t) then count = count + 1 end end
        Notify("Liquid", "Infinite health given to " .. count .. " player(s)", 3)
    
    elseif cmd == "ak" then
        Vars.Auto.Kill = not Vars.Auto.Kill
        if Vars.Auto.Kill then startAutoKill() else autoRunning.Kill = false end
        Notify("Liquid", "Auto kill " .. (Vars.Auto.Kill and "ON" or "OFF"), 2)
    
    elseif cmd == "ai" then
        Vars.Auto.Inf = not Vars.Auto.Inf
        if Vars.Auto.Inf then startAutoInf() else autoRunning.Inf = false end
        Notify("Liquid", "Auto inf " .. (Vars.Auto.Inf and "ON" or "OFF"), 2)
    
    elseif cmd == "astop" then
        Vars.Auto.Kill = false
        Vars.Auto.Inf = false
        for k in pairs(autoRunning) do autoRunning[k] = false end
        Notify("Liquid", "All auto features stopped", 2)
    
    elseif cmd == "at" then
        if args and args ~= "" then
            autoTarget = args
            Notify("Liquid", "Auto target set to: " .. args, 2)
        end
    
    elseif cmd == "agpp" then
        Vars.AntiPause = not Vars.AntiPause
        if Vars.AntiPause then StartAntiPause() end
        Notify("Liquid", "Anti-Pause " .. (Vars.AntiPause and "ON" or "OFF"), 2)
    
    elseif cmd == "ping" then
        local ping = math.floor(player:GetNetworkPing() * 1000)
        Notify("Liquid", "Ping: " .. ping .. "ms", 2)
    
    elseif cmd == "clear" then
        pcall(function()
            for _, v in ipairs(StarterGui:GetChildren()) do
                if v.Name == "SignUI" or v.Name == "Notifications" then v:Destroy() end
            end
            local bp = player:FindFirstChild("Backpack")
            if bp and bp:FindFirstChild("Sign") then bp.Sign:Destroy() end
        end)
        Notify("Liquid", "Screen clutter removed", 2)
    
    elseif cmd == "rejoin" or cmd == "rj" then
        Notify("Liquid", "Rejoining...", 2)
        TeleportService:Teleport(game.PlaceId, player)
    
    elseif cmd == "hop" then
        Notify("Liquid", "Hopping server...", 2)
        TeleportService:Teleport(game.PlaceId)
    
    elseif cmd == "wl" then
        local sub = parts[2]
        local name = parts[3]
        if sub == "add" and name then
            local target = GetPlayer(name)
            if target then
                if not IsWhitelisted(target.UserId) then
                    table.insert(Vars.Whitelist, target.UserId)
                    Notify("Liquid", "Added " .. target.Name .. " to whitelist", 3)
                else
                    Notify("Liquid", target.Name .. " is already whitelisted", 3, "alert")
                end
            else
                Notify("Liquid", "Player not found: " .. name, 3, "alert")
            end
        elseif sub == "remove" and name then
            local target = GetPlayer(name)
            if target then
                for i, id in pairs(Vars.Whitelist) do
                    if id == target.UserId then
                        table.remove(Vars.Whitelist, i)
                        Notify("Liquid", "Removed " .. target.Name .. " from whitelist", 3)
                        return
                    end
                end
                Notify("Liquid", target.Name .. " is not in whitelist", 3, "alert")
            else
                Notify("Liquid", "Player not found: " .. name, 3, "alert")
            end
        elseif sub == "list" then
            local count = #Vars.Whitelist
            Notify("Liquid", "Whitelist: " .. count .. " user(s)", 3)
        end
    
    elseif cmd == "bl" then
        local sub = parts[2]
        local name = parts[3]
        if sub == "add" and name then
            local target = GetPlayer(name)
            if target then
                if not IsBlacklisted(target.UserId) then
                    table.insert(Vars.Blacklist, target.UserId)
                    Notify("Liquid", "Added " .. target.Name .. " to blacklist", 3)
                else
                    Notify("Liquid", target.Name .. " is already blacklisted", 3, "alert")
                end
            else
                Notify("Liquid", "Player not found: " .. name, 3, "alert")
            end
        elseif sub == "remove" and name then
            local target = GetPlayer(name)
            if target then
                for i, id in pairs(Vars.Blacklist) do
                    if id == target.UserId then
                        table.remove(Vars.Blacklist, i)
                        Notify("Liquid", "Removed " .. target.Name .. " from blacklist", 3)
                        return
                    end
                end
                Notify("Liquid", target.Name .. " is not in blacklist", 3, "alert")
            else
                Notify("Liquid", "Player not found: " .. name, 3, "alert")
            end
        elseif sub == "list" then
            local count = #Vars.Blacklist
            Notify("Liquid", "Blacklist: " .. count .. " user(s)", 3)
        end
    
    elseif cmd == "help" or cmd == "cmds" then
        print("\n-- Liquid Admin Commands --")
        print("  kill/k <target> - Kill player(s)")
        print("  inf/i <target> - Give infinite health")
        print("  ak - Auto kill toggle")
        print("  ai - Auto inf toggle")
        print("  astop - Stop all auto")
        print("  at <target> - Set auto target")
        print("  agpp - Toggle Anti-Pause")
        print("  ping - Check ping")
        print("  clear - Remove screen clutter")
        print("  rejoin/rj - Rejoin game")
        print("  hop - Hop server")
        print("  wl add/remove/list <name> - Whitelist manager")
        print("  bl add/remove/list <name> - Blacklist manager")
        print("  help - Show this list")
        Notify("Liquid", "Commands printed to console", 3)
    
    else
        Notify("Liquid", "Unknown command. Type " .. Vars.Prefix .. "help", 3, "alert")
    end
end

-- Setup Chat
local function SetupChat()
    local textChannels = TextChatService:FindFirstChild("TextChannels")
    if textChannels and textChannels:FindFirstChild("RBXLGeneral") then
        textChannels.RBXLGeneral.OnIncomingMessage:Connect(function(msg)
            if msg and msg.TextSource and msg.TextSource == player and msg.Text then
                HandleCommand(msg.Text)
            end
        end)
    else
        player.Chatted:Connect(HandleCommand)
    end
end

-- Initialize
Notify("Liquid Admin", "Loading...", 2)
StartAntiPause()
SetupChat()
Notify("Liquid Admin", "Ready! Type " .. Vars.Prefix .. "help", 4)