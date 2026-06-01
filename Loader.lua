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

-- Skin Tone Detection System
local SkinToneLog = {}
local SkinToneLogFile = "Liquid/SkinToneLog.txt"

local function GetSkinColorName(Character)
    if not Character then return "Unknown" end
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    if not Humanoid then return "Unknown" end
    local BodyColors = Character:FindFirstChild("BodyColors")
    if not BodyColors then return "Unknown" end
    
    local headColor = BodyColors.HeadColor
    local r, g, b = headColor.R, headColor.G, headColor.B
    
    if r > 0.95 and g > 0.85 and b > 0.75 then
        return "Porcelain/Albino"
    elseif r > 0.85 and g > 0.75 and b > 0.65 then
        return "Fair/Pale"
    elseif r > 0.78 and g > 0.68 and b > 0.58 then
        return "Light Beige"
    elseif r > 0.72 and g > 0.62 and b > 0.52 then
        return "Warm Ivory"
    elseif r > 0.65 and g > 0.55 and b > 0.45 then
        return "Golden/Tan"
    elseif r > 0.58 and g > 0.48 and b > 0.38 then
        return "Olive/Tan"
    elseif r > 0.52 and g > 0.42 and b > 0.32 then
        return "Caramel/Light Brown"
    elseif r > 0.45 and g > 0.35 and b > 0.28 then
        return "Honey Brown"
    elseif r > 0.38 and g > 0.30 and b > 0.24 then
        return "Chestnut/Brown"
    elseif r > 0.32 and g > 0.25 and b > 0.20 then
        return "Rich Brown"
    elseif r > 0.26 and g > 0.20 and b > 0.16 then
        return "Dark Brown"
    elseif r > 0.20 and g > 0.15 and b > 0.12 then
        return "Espresso"
    elseif r > 0.14 and g > 0.10 and b > 0.08 then
        return "Deep Brown"
    elseif r < 0.14 and g < 0.10 and b < 0.08 then
        return "Ebony/Very Dark"
    elseif r < 0.05 and g < 0.05 and b < 0.05 then
        return "Black/Darkest"
    else
        return "Custom - RGB: " .. string.format("%.2f,%.2f,%.2f", r, g, b)
    end
end

local function LogSkinTone(PlayerName, SkinTone)
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    local logEntry = string.format("[%s] %s - %s", timestamp, PlayerName, SkinTone)
    table.insert(SkinToneLog, logEntry)
    pcall(function() writefile(SkinToneLogFile, table.concat(SkinToneLog, "\n")) end)
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

local function GetChartreuseRemote()
    local tool = FindTool("Chartreuse Periastron Gamma")
    if not tool then return nil end
    return tool:FindFirstChild("Remote")
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

local function GiveGodMode()
    local remote = GetDiamondRemote()
    if not remote then return false end
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        pcall(function() remote:InvokeServer(7, hum, -math.huge) end)
        return true
    end
    return false
end

local function ApplyNanHealth(target)
    local chartreuse = GetChartreuseRemote()
    if not chartreuse then return false end
    local lockOn = FindTool("Lock On Launcher")
    if not lockOn then return false end
    local lockOnRemote = lockOn:FindFirstChild("Remote")
    if not lockOnRemote then return false end
    
    local targetChar = target.Character
    local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
    if targetHRP then
        pcall(function() chartreuse:FireServer(Enum.KeyCode.Q) end)
        task.wait(0.3)
        local feetPos = targetHRP.Position - Vector3.new(0, 3, 0)
        pcall(function() lockOnRemote:FireServer(feetPos) end)
        Vars.Stats.Attacks = Vars.Stats.Attacks + 1
        return true
    end
    return false
end

local function BlindTarget(target)
    local blindRemote = ReplicatedStorage:FindFirstChild("e7f1b238-1d59-4ae8-89f5-1f5c9c22759f")
    if not blindRemote then return false end
    local remote = GetDiamondRemote()
    local char = target.Character
    if not char then return false end
    
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum and hum.Health > 0 and remote then
        pcall(function() remote:InvokeServer(7, hum, 9999999) end)
        Vars.Stats.Kills = Vars.Stats.Kills + 1
        task.wait(0.1)
    end
    
    char = target.Character
    if char then
        hum = char:FindFirstChildOfClass("Humanoid")
        local head = char:FindFirstChild("Head")
        if hum and head and hum.Health == 0 then
            pcall(function() blindRemote:FireServer(target) end)
            head.Anchored = true
            head.CFrame = CFrame.new(0, -1000, 0)
            head.Size = Vector3.new(100, 5, 50)
            head.CanCollide = false
            head.Transparency = 1
            return true
        end
    end
    return false
end

local function PermaBlindTarget(target)
    local firePart, staff = nil, nil
    local staffTool = FindTool("Hades Staff of Darkness")
    if staffTool and staffTool:FindFirstChild("Handle") then
        firePart = staffTool.Handle:FindFirstChild("FirePart")
        staff = staffTool
    end
    if not firePart then return false end
    
    local remote = GetDiamondRemote()
    local blindRemote = ReplicatedStorage:FindFirstChild("e7f1b238-1d59-4ae8-89f5-1f5c9c22759f")
    
    local targetChar = target.Character
    if targetChar then
        local targetHum = targetChar:FindFirstChildOfClass("Humanoid")
        if targetHum and targetHum.Health > 0 and remote then
            pcall(function() remote:InvokeServer(7, targetHum, 9999999) end)
            Vars.Stats.Kills = Vars.Stats.Kills + 1
        end
    end
    
    task.wait(0.05)
    targetChar = target.Character
    
    if targetChar then
        local targetHum = targetChar:FindFirstChildOfClass("Humanoid")
        if targetHum and targetHum.Health == 0 then
            if staff then
                local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
                if staff.Parent == player:FindFirstChild("Backpack") and hum then
                    pcall(function() hum:EquipTool(staff) end)
                end
                task.wait(0.2)
            end
            
            if blindRemote then pcall(function() blindRemote:FireServer(target) end) end
            
            local targetHead = targetChar:FindFirstChild("Head")
            if targetHead and firePart then
                firePart.CFrame = targetHead.CFrame
                targetHead.Anchored = true
                targetHead.CFrame = CFrame.new(0, -10000, 0)
                targetHead.Size = Vector3.new(100, 5, 50)
                targetHead.CanCollide = false
                targetHead.Transparency = 1
            end
            
            if staff then
                local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:UnequipTools() end) end
            end
            return true
        end
    end
    return false
end

local function IsPlayerFrozen(Character)
    if not Character then return false end
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    if not Humanoid then return false end
    if Humanoid.WalkSpeed < 5 or Humanoid.JumpPower < 10 then return true end
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    if HumanoidRootPart then
        for _, child in ipairs(HumanoidRootPart:GetChildren()) do
            if child:IsA("Attachment") then
                if string.find(string.lower(child.Name), "frost") or string.find(string.lower(child.Name), "snow") or string.find(string.lower(child.Name), "ice") then
                    return true
                end
            end
        end
    end
    return false
end

local function IsPlayerFloating(Character)
    if not Character then return false end
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    if not Humanoid or not HumanoidRootPart then return false end
    local RayOrigin = HumanoidRootPart.Position
    local RayDirection = Vector3.new(0, -5, 0)
    local RaycastParams = RaycastParams.new()
    RaycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    RaycastParams.FilterDescendantsInstances = {Character}
    local RayResult = Workspace:Raycast(RayOrigin, RayDirection, RaycastParams)
    if not RayResult then return true end
    if Humanoid.FloorMaterial == Enum.Material.Air then return true end
    return false
end

local function GrabCommand(targetName)
    local targetPlayer = GetPlayer(targetName)
    if not targetPlayer then Notify("Liquid", "Player not found: " .. targetName, 3, "alert") return end
    if targetPlayer == player then Notify("Liquid", "Cannot grab yourself", 3, "alert") return end
    
    local remoteDetonator = FindTool("Remote Explosive Detonator")
    local megaphone = FindTool("Mega Annoying Megaphone")
    if not remoteDetonator or not megaphone then
        Notify("Liquid", "Missing tools: Remote Explosive Detonator or Mega Annoying Megaphone", 4, "alert")
        return
    end
    
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    
    local targetChar = targetPlayer.Character
    if not targetChar then Notify("Liquid", "Target has no character", 3, "alert") return end
    local targetHead = targetChar:FindFirstChild("Head")
    if not targetHead then Notify("Liquid", "Target has no head", 3, "alert") return end
    
    if remoteDetonator.Parent == player:FindFirstChild("Backpack") then
        pcall(function() hum:EquipTool(remoteDetonator) end)
        task.wait(0.5)
    end
    
    local remoteEvent = remoteDetonator:FindFirstChild("RemoteEvent")
    if remoteEvent then
        pcall(function() remoteEvent:FireServer("Activate", targetHead.Position) end)
        Vars.Stats.Attacks = Vars.Stats.Attacks + 1
    end
    
    task.wait(0.3)
    pcall(function() hum:UnequipTools() end)
    task.wait(0.2)
    
    if megaphone.Parent == player:FindFirstChild("Backpack") then
        pcall(function() hum:EquipTool(megaphone) end)
        task.wait(0.5)
    end
    
    Notify("Liquid", "Grabbed " .. targetPlayer.Name, 3)
end

local function GrabV2Command(targetName)
    local targetPlayer = GetPlayer(targetName)
    if not targetPlayer then Notify("Liquid", "Player not found: " .. targetName, 3, "alert") return end
    if targetPlayer == player then Notify("Liquid", "Cannot grab yourself", 3, "alert") return end
    
    local remoteDetonator = FindTool("Remote Explosive Detonator")
    local turkeyLeg = FindTool("Turkey Leg")
    if not remoteDetonator or not turkeyLeg then
        Notify("Liquid", "Missing tools: Remote Explosive Detonator or Turkey Leg", 4, "alert")
        return
    end
    
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    
    if remoteDetonator.Parent == player:FindFirstChild("Backpack") then
        pcall(function() hum:EquipTool(remoteDetonator) end)
        task.wait(0.3)
    end
    
    local remoteEvent = remoteDetonator:FindFirstChild("RemoteEvent")
    if remoteEvent then
        pcall(function() remoteEvent:FireServer("Activate") end)
        Vars.Stats.Attacks = Vars.Stats.Attacks + 1
    end
    
    task.wait(0.5)
    pcall(function() hum:UnequipTools() end)
    task.wait(0.2)
    
    if turkeyLeg.Parent == player:FindFirstChild("Backpack") then
        pcall(function() hum:EquipTool(turkeyLeg) end)
    end
    
    Notify("Liquid", "Grab V2 completed on " .. targetPlayer.Name, 3)
end

local function SnowballCommand(targetName)
    local targetPlayer = GetPlayer(targetName)
    if not targetPlayer then Notify("Liquid", "Player not found: " .. targetName, 3, "alert") return end
    if targetPlayer == player then Notify("Liquid", "Cannot use snowball on yourself", 3, "alert") return end
    
    local dracovin = FindTool("Dracovin Spellbook")
    local hyperlaser = FindTool("Hyperlaser Gun")
    if not dracovin or not hyperlaser then
        Notify("Liquid", "Missing tools: Dracovin Spellbook or Hyperlaser Gun", 4, "alert")
        return
    end
    
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    
    local targetChar = targetPlayer.Character
    if not targetChar then Notify("Liquid", "Target has no character", 3, "alert") return end
    
    Notify("Liquid", "Waiting for target to freeze...", 3)
    local startTime = tick()
    while tick() - startTime < 30 do
        if IsPlayerFrozen(targetChar) then break end
        task.wait(0.5)
    end
    
    if not IsPlayerFrozen(targetChar) then
        Notify("Liquid", "Timeout - target did not freeze", 3, "alert")
        return
    end
    
    if dracovin.Parent == player:FindFirstChild("Backpack") then
        pcall(function() hum:EquipTool(dracovin) end)
        task.wait(0.5)
    end
    
    local dracovinRemote = dracovin:FindFirstChild("ClientInput")
    if dracovinRemote then
        pcall(function() dracovinRemote:FireServer(Enum.KeyCode.E) end)
        Vars.Stats.Attacks = Vars.Stats.Attacks + 1
    end
    
    task.wait(0.5)
    pcall(function() hum:UnequipTools() end)
    task.wait(0.5)
    
    if hyperlaser.Parent == player:FindFirstChild("Backpack") then
        pcall(function() hum:EquipTool(hyperlaser) end)
        task.wait(0.5)
    end
    
    local hyperlaserRemote = hyperlaser:FindFirstChild("Remote")
    if not hyperlaserRemote then
        pcall(function() hum:UnequipTools() end)
        return
    end
    
    local shootCount = 0
    while shootCount < 20 and IsPlayerFrozen(targetChar) do
        pcall(function() hyperlaserRemote:FireServer() end)
        Vars.Stats.Attacks = Vars.Stats.Attacks + 1
        shootCount = shootCount + 1
        task.wait(0.3)
    end
    
    pcall(function() hum:UnequipTools() end)
    Notify("Liquid", "Snowball completed on " .. targetPlayer.Name .. " - " .. shootCount .. " shots", 4)
end

local function ESPLockOnSystem(targetName)
    local targetPlayer = GetPlayer(targetName)
    if not targetPlayer then Notify("Liquid", "Player not found: " .. targetName, 3, "alert") return end
    if targetPlayer == player then Notify("Liquid", "Cannot use ESP on yourself", 3, "alert") return end
    
    local lockOn = FindTool("Lock On Launcher")
    local spartan = FindTool("Spartan Sword and Shield")
    if not lockOn or not spartan then
        Notify("Liquid", "Missing tools: Lock On Launcher or Spartan Sword and Shield", 4, "alert")
        return
    end
    
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    
    local targetChar = targetPlayer.Character
    if not targetChar then Notify("Liquid", "Target has no character", 3, "alert") return end
    local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
    if not targetHRP then Notify("Liquid", "Target has no HumanoidRootPart", 3, "alert") return end
    
    if lockOn.Parent == player:FindFirstChild("Backpack") then
        pcall(function() hum:EquipTool(lockOn) end)
        task.wait(0.2)
    end
    
    local lockOnRemote = lockOn:FindFirstChild("Remote")
    if lockOnRemote then
        pcall(function() lockOnRemote:FireServer(targetHRP.Position) end)
        Vars.Stats.Attacks = Vars.Stats.Attacks + 1
    end
    
    task.wait(0.3)
    pcall(function() hum:UnequipTools() end)
    task.wait(0.1)
    
    if spartan.Parent == player:FindFirstChild("Backpack") then
        pcall(function() hum:EquipTool(spartan) end)
        task.wait(0.2)
    end
    
    local spartanRemote = spartan:FindFirstChild("Remote") or spartan:FindFirstChild("Activate")
    if spartanRemote then
        pcall(function()
            if spartanRemote:IsA("RemoteEvent") then
                spartanRemote:FireServer("Activate")
            else
                spartanRemote:FireServer()
            end
        end)
        Vars.Stats.Attacks = Vars.Stats.Attacks + 1
    end
    
    task.wait(0.3)
    pcall(function() hum:UnequipTools() end)
    Notify("Liquid", "ESP lock-on completed on " .. targetPlayer.Name, 3)
end

local function AnchorV2Command()
    local sword = FindTool("SwordOfLight")
    if not sword then Notify("Liquid", "SwordOfLight not found", 3, "alert") return end
    
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    
    if sword.Parent == player:FindFirstChild("Backpack") then
        pcall(function() hum:EquipTool(sword) end)
        task.wait(0.3)
    end
    
    local swordRemote = sword:FindFirstChild("Remote")
    if not swordRemote then
        pcall(function() hum:UnequipTools() end)
        return
    end
    
    pcall(function() swordRemote:FireServer(Enum.KeyCode.E) end)
    Vars.Stats.Attacks = Vars.Stats.Attacks + 1
    task.wait(0.3)
    pcall(function() hum:UnequipTools() end)
    Notify("Liquid", "Anchor V2 completed", 3)
end

local function EggCommand(targetName)
    local targetPlayer = GetPlayer(targetName)
    if not targetPlayer then Notify("Liquid", "Player not found: " .. targetName, 3, "alert") return end
    if targetPlayer == player then Notify("Liquid", "Cannot use egg on yourself", 3, "alert") return end
    
    local eggTool = FindTool("Joyful Periastron")
    if not eggTool then Notify("Liquid", "Joyful Periastron not found", 3, "alert") return end
    
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    
    local targetChar = targetPlayer.Character
    if not targetChar then Notify("Liquid", "Target has no character", 3, "alert") return end
    if not IsPlayerFloating(targetChar) then
        Notify("Liquid", "Target is not floating, cannot use egg", 3, "alert")
        return
    end
    
    if eggTool.Parent == player:FindFirstChild("Backpack") then
        pcall(function() hum:EquipTool(eggTool) end)
        task.wait(0.5)
    end
    
    local eggHandle = eggTool:FindFirstChild("Handle")
    if not eggHandle then
        pcall(function() hum:UnequipTools() end)
        return
    end
    
    local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
    local myHRP = char:FindFirstChild("HumanoidRootPart")
    if not targetHRP or not myHRP then
        pcall(function() hum:UnequipTools() end)
        return
    end
    
    local originalCFrame = myHRP.CFrame
    pcall(function() myHRP.CFrame = CFrame.new(targetHRP.Position + Vector3.new(0, 2, 0)) end)
    task.wait(0.2)
    
    local touchInterest = eggHandle:FindFirstChild("TouchInterest")
    if touchInterest then
        pcall(function() touchInterest:Fire() end)
        Vars.Stats.Attacks = Vars.Stats.Attacks + 1
    else
        local originalHandleCFrame = eggHandle.CFrame
        pcall(function() eggHandle.CFrame = targetHRP.CFrame * CFrame.new(0, 2, 0) end)
        task.wait(0.1)
        pcall(function() eggHandle.CFrame = originalHandleCFrame end)
        Vars.Stats.Attacks = Vars.Stats.Attacks + 1
    end
    
    task.wait(0.5)
    pcall(function() myHRP.CFrame = originalCFrame end)
    task.wait(0.3)
    pcall(function() hum:UnequipTools() end)
    Notify("Liquid", "Egg command completed on " .. targetPlayer.Name, 3)
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

local function startAutoBlind()
    if autoRunning.Blind then return end
    autoRunning.Blind = true
    autoThreads.Blind = task.spawn(function()
        while autoRunning.Blind do
            task.wait(0.5)
            local targets = GetTargets(autoTarget, false)
            for _, t in ipairs(targets) do BlindTarget(t) end
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

local function startAutoPerm()
    if autoRunning.Perm then return end
    autoRunning.Perm = true
    autoThreads.Perm = task.spawn(function()
        while autoRunning.Perm do
            task.wait(0.5)
            local targets = GetTargets(autoTarget, false)
            for _, t in ipairs(targets) do PermaBlindTarget(t) end
        end
    end)
end

local function startAutoNan()
    if autoRunning.Nan then return end
    autoRunning.Nan = true
    autoThreads.Nan = task.spawn(function()
        while autoRunning.Nan do
            task.wait(0.5)
            local targets = GetTargets(autoTarget, false)
            for _, t in ipairs(targets) do ApplyNanHealth(t) end
        end
    end)
end

-- Loop Features
local loopThreads = {Inf = nil, Nan = nil, God = nil}
local loopRunning = {Inf = false, Nan = false, God = false}

local function startLoopInf(targetParam)
    if loopRunning.Inf then return end
    loopRunning.Inf = true
    loopThreads.Inf = task.spawn(function()
        while loopRunning.Inf do
            local targets = GetTargets(targetParam or "others", false)
            for _, t in ipairs(targets) do GiveInfiniteHealth(t) end
            task.wait(3)
        end
    end)
end

local function stopLoopInf()
    loopRunning.Inf = false
    loopThreads.Inf = nil
end

local function startLoopNan(targetParam)
    if loopRunning.Nan then return end
    loopRunning.Nan = true
    loopThreads.Nan = task.spawn(function()
        while loopRunning.Nan do
            local targets = GetTargets(targetParam or "others", false)
            for _, t in ipairs(targets) do ApplyNanHealth(t) end
            task.wait(4)
        end
    end)
end

local function stopLoopNan()
    loopRunning.Nan = false
    loopThreads.Nan = nil
end

local function startLoopGod()
    if loopRunning.God then return end
    loopRunning.God = true
    loopThreads.God = task.spawn(function()
        while loopRunning.God do
            GiveGodMode()
            task.wait(5)
        end
    end)
end

local function stopLoopGod()
    loopRunning.God = false
    loopThreads.God = nil
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

    -- Combat Commands
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

    elseif cmd == "god" then
        if GiveGodMode() then
            Notify("Liquid", "Godmode activated", 3)
        else
            Notify("Liquid", "Godmode failed - Diamond Blade Sword not found", 3, "alert")
        end

    elseif cmd == "nan" or cmd == "n" then
        local targets = GetTargets(args, false)
        local count = 0
        for _, t in ipairs(targets) do if ApplyNanHealth(t) then count = count + 1 end end
        Notify("Liquid", "Nan health applied to " .. count .. " player(s)", 3)

    elseif cmd == "blind" or cmd == "b" then
        local targets = GetTargets(args, false)
        local count = 0
        for _, t in ipairs(targets) do if BlindTarget(t) then count = count + 1 end end
        Notify("Liquid", "Blinded " .. count .. " player(s)", 3)

    elseif cmd == "perm" or cmd == "p" then
        local targets = GetTargets(args, false)
        local count = 0
        for _, t in ipairs(targets) do if PermaBlindTarget(t) then count = count + 1 end end
        Notify("Liquid", "Permablinded " .. count .. " player(s)", 3)

    -- Grab/Movement Commands
    elseif cmd == "grab" or cmd == "gr" then
        if args and args ~= "" then GrabCommand(args) else Notify("Liquid", "Usage: grab <name>", 3, "alert") end

    elseif cmd == "grabv2" or cmd == "gr2" then
        if args and args ~= "" then GrabV2Command(args) else Notify("Liquid", "Usage: grabv2 <name>", 3, "alert") end

    elseif cmd == "snowball" or cmd == "sb" then
        if args and args ~= "" then SnowballCommand(args) else Notify("Liquid", "Usage: snowball <name>", 3, "alert") end

    elseif cmd == "espls" or cmd == "el" then
        if args and args ~= "" then ESPLockOnSystem(args) else Notify("Liquid", "Usage: espls <name>", 3, "alert") end

    elseif cmd == "egg" or cmd == "e" then
        if args and args ~= "" then EggCommand(args) else Notify("Liquid", "Usage: egg <name>", 3, "alert") end

    elseif cmd == "anchorv2" or cmd == "av2" then
        AnchorV2Command()

    -- Auto Commands
    elseif cmd == "ak" then
        Vars.Auto.Kill = not Vars.Auto.Kill
        if Vars.Auto.Kill then startAutoKill() else autoRunning.Kill = false end
        Notify("Liquid", "Auto kill " .. (Vars.Auto.Kill and "ON" or "OFF"), 2)

    elseif cmd == "ab" then
        Vars.Auto.Blind = not Vars.Auto.Blind
        if Vars.Auto.Blind then startAutoBlind() else autoRunning.Blind = false end
        Notify("Liquid", "Auto blind " .. (Vars.Auto.Blind and "ON" or "OFF"), 2)

    elseif cmd == "ai" then
        Vars.Auto.Inf = not Vars.Auto.Inf
        if Vars.Auto.Inf then startAutoInf() else autoRunning.Inf = false end
        Notify("Liquid", "Auto inf " .. (Vars.Auto.Inf and "ON" or "OFF"), 2)

    elseif cmd == "ap" then
        Vars.Auto.Perm = not Vars.Auto.Perm
        if Vars.Auto.Perm then startAutoPerm() else autoRunning.Perm = false end
        Notify("Liquid", "Auto permablind " .. (Vars.Auto.Perm and "ON" or "OFF"), 2)

    elseif cmd == "an" then
        Vars.Auto.Nan = not Vars.Auto.Nan
        if Vars.Auto.Nan then startAutoNan() else autoRunning.Nan = false end
        Notify("Liquid", "Auto nan " .. (Vars.Auto.Nan and "ON" or "OFF"), 2)

    elseif cmd == "astop" then
        Vars.Auto.Kill = false
        Vars.Auto.Blind = false
        Vars.Auto.Inf = false
        Vars.Auto.Perm = false
        Vars.Auto.Nan = false
        for k in pairs(autoRunning) do autoRunning[k] = false end
        Notify("Liquid", "All auto features stopped", 2)

    elseif cmd == "at" then
        if args and args ~= "" then
            autoTarget = args
            Notify("Liquid", "Auto target set to: " .. args, 2)
        else
            Notify("Liquid", "Current auto target: " .. autoTarget, 2)
        end

    -- Loop Commands
    elseif cmd == "loopinf" then
        startLoopInf(args)
        Notify("Liquid", "Loop inf started on: " .. (args or "others"), 2)

    elseif cmd == "stoploopinf" then
        stopLoopInf()
        Notify("Liquid", "Loop inf stopped", 2)

    elseif cmd == "loopnan" then
        startLoopNan(args)
        Notify("Liquid", "Loop nan started on: " .. (args or "others"), 2)

    elseif cmd == "stoploopnan" then
        stopLoopNan()
        Notify("Liquid", "Loop nan stopped", 2)

    elseif cmd == "loopgod" then
        startLoopGod()
        Notify("Liquid", "Loop godmode started", 2)

    elseif cmd == "stoploopgod" then
        stopLoopGod()
        Notify("Liquid", "Loop godmode stopped", 2)

    -- Protection Commands
    elseif cmd == "agpp" then
        Vars.AntiPause = not Vars.AntiPause
        if Vars.AntiPause then StartAntiPause() else if AntiPauseConnection then AntiPauseConnection:Disconnect() end end
        Notify("Liquid", "Anti-Pause " .. (Vars.AntiPause and "ON" or "OFF"), 2)

    -- Skin Tone Commands
    elseif cmd == "skintone" or cmd == "st" then
        local target = GetPlayer(args) or player
        local skin = GetSkinColorName(target.Character)
        Notify("Liquid", target.Name .. ": " .. skin, 3)

    elseif cmd == "skintoneall" or cmd == "sta" then
        for _, plr in ipairs(Players:GetPlayers()) do
            local skin = GetSkinColorName(plr.Character)
            LogSkinTone(plr.Name, skin)
        end
        Notify("Liquid", "Logged skin tones for all players", 3)

    elseif cmd == "viewskintones" or cmd == "vst" then
        if #SkinToneLog == 0 then
            Notify("Liquid", "No skin tones logged yet", 3)
        else
            Notify("Liquid", "Skin tone log has " .. #SkinToneLog .. " entries (check console)", 3)
            print("\n-- Skin Tone Log --")
            for _, entry in ipairs(SkinToneLog) do print(entry) end
            print("")
        end

    elseif cmd == "clearskintones" or cmd == "cst" then
        local count = #SkinToneLog
        for i = 1, count do table.remove(SkinToneLog, 1) end
        pcall(function() writefile(SkinToneLogFile, "") end)
        Notify("Liquid", "Cleared " .. count .. " skin tone log entries", 2)

    -- Whitelist Commands
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
            print("\n-- Whitelist --")
            for i, id in pairs(Vars.Whitelist) do print("  " .. i .. ". " .. id) end
        else
            Notify("Liquid", "Usage: wl add/remove/list <name>", 3, "alert")
        end

    elseif cmd == "uwl" then
        local target = GetPlayer(args)
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
            Notify("Liquid", "Player not found: " .. args, 3, "alert")
        end

    -- Blacklist Commands
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
            print("\n-- Blacklist --")
            for i, id in pairs(Vars.Blacklist) do print("  " .. i .. ". " .. id) end
        else
            Notify("Liquid", "Usage: bl add/remove/list <name>", 3, "alert")
        end

    elseif cmd == "ubl" then
        local target = GetPlayer(args)
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
            Notify("Liquid", "Player not found: " .. args, 3, "alert")
        end

    -- Save Command
    elseif cmd == "save" then
        pcall(function()
            local data = {
                Whitelist = Vars.Whitelist,
                Blacklist = Vars.Blacklist,
                Stats = Vars.Stats,
                Prefix = Vars.Prefix
            }
            if not isfolder("Liquid") then makefolder("Liquid") end
            writefile("Liquid/data.json", HttpService:JSONEncode(data))
            Notify("Liquid", "Data saved", 2)
        end)

    -- Utility Commands
    elseif cmd == "health" or cmd == "hp" then
        local target = GetPlayer(args) or player
        local char = target.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                Notify("Liquid", target.Name .. ": " .. math.floor(hum.Health) .. "/" .. math.floor(hum.MaxHealth) .. " HP", 3)
            end
        end

    elseif cmd == "healthall" or cmd == "hpa" then
        for _, plr in ipairs(Players:GetPlayers()) do
            local char = plr.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    print(plr.Name .. ": " .. math.floor(hum.Health) .. "/" .. math.floor(hum.MaxHealth) .. " HP")
                end
            end
        end
        Notify("Liquid", "Health stats printed to console", 3)

    elseif cmd == "testgod" or cmd == "test" then
        local target = GetPlayer(args) or player
        Notify("Liquid", "Testing godmode on " .. target.Name, 3)
        
        local function testDamage()
            local remote = GetDiamondRemote()
            if remote then
                local hum = target.Character and target.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    local healthBefore = hum.Health
                    pcall(function() remote:InvokeServer(7, hum, 10) end)
                    task.wait(0.2)
                    if hum.Health >= healthBefore then
                        Notify("Liquid", "Godmode WORKING on " .. target.Name, 3)
                    else
                        Notify("Liquid", "Godmode NOT working on " .. target.Name, 3, "alert")
                    end
                end
            end
        end
        testDamage()

    elseif cmd == "ping" then
        local ping = math.floor(player:GetNetworkPing() * 1000)
        Notify("Liquid", "Ping: " .. ping .. "ms", 2)

    elseif cmd == "gc" then
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
        Notify("Liquid", "Backpack check complete - check console", 3)

    elseif cmd == "clear" then
        pcall(function()
            for _, v in ipairs(StarterGui:GetChildren()) do
                if v.Name == "SignUI" or v.Name == "Notifications" or v.Name == "JoinGroupFrame" or v.Name == "Staff" then
                    v:Destroy()
                end
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

    elseif cmd == "prefix" then
        if args and args ~= "" then
            Vars.Prefix = args
            Notify("Liquid", "Prefix changed to: " .. args, 2)
        else
            Notify("Liquid", "Current prefix: " .. Vars.Prefix, 2)
        end

    elseif cmd == "debug" or cmd == "d" then
        Vars.Debug = not Vars.Debug
        Notify("Liquid", "Debug mode " .. (Vars.Debug and "ON" or "OFF"), 2)

    -- External Tools
    elseif cmd == "spy" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ltseverydayyou/uuuuuuu/refs/heads/main/SimpleSpyRework.luau"))()
        Notify("Liquid", "Loading remote spy...", 2)

    elseif cmd == "cobalt" then
        loadstring(game:HttpGet("https://github.com/notpoiu/cobalt/releases/latest/download/Cobalt.luau"))()
        Notify("Liquid", "Loading cobalt...", 2)

    elseif cmd == "hydro" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Upbolt/Hydroxide/revision/init.lua"))()
        Notify("Liquid", "Loading hydroxide...", 2)

    elseif cmd == "dex" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ltseverydayyou/uuuuuuu/refs/heads/main/DexPlusBackup.luau"))()
        Notify("Liquid", "Loading dex explorer...", 2)

    -- Help Commands
    elseif cmd == "help" or cmd == "cmds" then
        print("\n" .. string.rep("-", 50))
        print("Liquid Admin Commands (Prefix: " .. Vars.Prefix .. ")")
        print(string.rep("-", 50))
        print("\n[Combat]")
        print("  kill/k <target> - Kill player(s)")
        print("  inf/i <target> - Give infinite health")
        print("  god - Godmode on self")
        print("  nan/n <target> - Apply NaN health")
        print("  blind/b <target> - Blind player(s)")
        print("  perm/p <target> - Permanently blind player(s)")
        print("\n[Grab/Movement]")
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
        print("\n[Loop Features]")
        print("  loopinf <target> - Loop infinite health")
        print("  stoploopinf - Stop loop inf")
        print("  loopnan <target> - Loop nan health")
        print("  stoploopnan - Stop loop nan")
        print("  loopgod - Loop godmode")
        print("  stoploopgod - Stop loop god")
        print("\n[Protection]")
        print("  agpp - Toggle Anti-Pause")
        print("  wl add/remove/list <name> - Whitelist manager")
        print("  uwl <name> - Remove from whitelist")
        print("  bl add/remove/list <name> - Blacklist manager")
        print("  ubl <name> - Remove from blacklist")
        print("  save - Save data")
        print("\n[Skin Tone]")
        print("  skintone/st <name> - Check skin tone")
        print("  skintoneall/sta - Log all skin tones")
        print("  viewskintones/vst - View skin tone log")
        print("  clearskintones/cst - Clear skin tone log")
        print("\n[Utility]")
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
        print(string.rep("-", 50))
        Notify("Liquid", "Commands printed to console", 3)

    elseif cmd == "explain" then
        print("\n-- Liquid Admin Explained --")
        print("Liquid Admin is a powerful admin script for Roblox")
        print("Target options: all, others, me, or player name")
        print("Use '" .. Vars.Prefix .. "help' to see all commands")
        print("Use '" .. Vars.Prefix .. "requirements' to see tool requirements")
        Notify("Liquid", "Help info printed to console", 3)

    elseif cmd == "requirements" or cmd == "req" then
        print("\n-- Tool Requirements --")
        print("Commands requiring Diamond Blade Sword:")
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
        Notify("Liquid", "Requirements printed to console", 3)

    else
        Notify("Liquid", "Unknown command. Type " .. Vars.Prefix .. "help", 3, "alert")
    end
end

-- Player Join Handler
local function OnPlayerAdded(NewPlayer)
    task.wait(1)
    if IsBlacklisted(NewPlayer.UserId) then
        Notify("Liquid", "Blacklisted player joined: " .. NewPlayer.Name, 5, "alert")
    end
    if IsWhitelisted(NewPlayer.UserId) then
        Notify("Liquid", "Whitelisted player joined: " .. NewPlayer.Name, 3)
    end
    local skin = GetSkinColorName(NewPlayer.Character)
    LogSkinTone(NewPlayer.Name, skin)
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

-- Load Saved Data
pcall(function()
    if isfile("Liquid/data.json") then
        local data = HttpService:JSONDecode(readfile("Liquid/data.json"))
        Vars.Whitelist = data.Whitelist or {}
        Vars.Blacklist = data.Blacklist or {}
        Vars.Stats = data.Stats or {Start = tick(), Kills = 0, Attacks = 0}
        Vars.Prefix = data.Prefix or ","
    end
end)

-- Initialize
Notify("Liquid Admin", "Loading...", 2)
StartAntiPause()
SetupChat()

for _, plr in ipairs(Players:GetPlayers()) do
    task.spawn(function()
        local skin = GetSkinColorName(plr.Character)
        LogSkinTone(plr.Name, skin)
    end)
end

Players.PlayerAdded:Connect(OnPlayerAdded)

Notify("Liquid Admin", "Ready! Type " .. Vars.Prefix .. "help", 4)

-- Top Bar UI
local topBar = Instance.new("ScreenGui")
topBar.Name = "LiquidTopBar"
topBar.Parent = CoreGui
topBar.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local barFrame = Instance.new("Frame")
barFrame.Size = UDim2.new(1, 0, 0, 25)
barFrame.Position = UDim2.new(0, 0, 0, 0)
barFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
barFrame.BackgroundTransparency = 0.1
barFrame.BorderSizePixel = 0
barFrame.Parent = topBar

local barText = Instance.new("TextLabel")
barText.Size = UDim2.new(1, 0, 1, 0)
barText.BackgroundTransparency = 1
barText.Text = "Liquid Admin - Ready"
barText.TextColor3 = Color3.fromRGB(255, 255, 255)
barText.TextSize = 12
barText.Font = Enum.Font.Gotham
barText.Parent = barFrame

task.spawn(function()
    while true do
        task.wait(1)
        local autoStr = ""
        if Vars.Auto.Kill then autoStr = autoStr .. "K " end
        if Vars.Auto.Blind then autoStr = autoStr .. "B " end
        if Vars.Auto.Inf then autoStr = autoStr .. "I " end
        if Vars.Auto.Perm then autoStr = autoStr .. "P " end
        if Vars.Auto.Nan then autoStr = autoStr .. "N " end
        if autoStr == "" then autoStr = "None" end
        barText.Text = "Liquid Admin - Kills: " .. Vars.Stats.Kills .. " | Attacks: " .. Vars.Stats.Attacks .. " | WL: " .. #Vars.Whitelist .. " | BL: " .. #Vars.Blacklist .. " | Auto: " .. autoStr
    end
end)
