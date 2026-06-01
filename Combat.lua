local Combat = {}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer

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

function Combat:Kill(target)
    local remote = GetDiamondRemote()
    if not remote then return false end
    local hum = target.Character and target.Character:FindFirstChildOfClass("Humanoid")
    if hum and hum.Health > 0 then
        pcall(function() remote:InvokeServer(7, hum, 9999999) end)
        return true
    end
    return false
end

function Combat:GiveInf(target)
    local remote = GetDiamondRemote()
    if not remote then return false end
    local hum = target.Character and target.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        pcall(function() remote:InvokeServer(7, hum, -math.huge) end)
        return true
    end
    return false
end

function Combat:GodMode()
    local remote = GetDiamondRemote()
    if not remote then return false end
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        pcall(function() remote:InvokeServer(7, hum, -math.huge) end)
        return true
    end
    return false
end

function Combat:ApplyNan(target)
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
        return true
    end
    return false
end

function Combat:Blind(target)
    local blindRemote = ReplicatedStorage:FindFirstChild("e7f1b238-1d59-4ae8-89f5-1f5c9c22759f")
    if not blindRemote then return false end
    local remote = GetDiamondRemote()
    local char = target.Character
    if not char then return false end
    
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum and hum.Health > 0 and remote then
        pcall(function() remote:InvokeServer(7, hum, 9999999) end)
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

function Combat:PermaBlind(target)
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

function Combat:Grab(targetName)
    local targetPlayer = nil
    for _, plr in ipairs(Players:GetPlayers()) do
        if string.lower(plr.Name) == string.lower(targetName) or string.lower(plr.DisplayName or "") == string.lower(targetName) then
            targetPlayer = plr
            break
        end
    end
    if not targetPlayer then return end
    if targetPlayer == player then return end
    
    local remoteDetonator = FindTool("Remote Explosive Detonator")
    local megaphone = FindTool("Mega Annoying Megaphone")
    if not remoteDetonator or not megaphone then return end
    
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    
    local targetChar = targetPlayer.Character
    if not targetChar then return end
    local targetHead = targetChar:FindFirstChild("Head")
    if not targetHead then return end
    
    if remoteDetonator.Parent == player:FindFirstChild("Backpack") then
        pcall(function() hum:EquipTool(remoteDetonator) end)
        task.wait(0.5)
    end
    
    local remoteEvent = remoteDetonator:FindFirstChild("RemoteEvent")
    if remoteEvent then
        pcall(function() remoteEvent:FireServer("Activate", targetHead.Position) end)
    end
    
    task.wait(0.3)
    pcall(function() hum:UnequipTools() end)
    task.wait(0.2)
    
    if megaphone.Parent == player:FindFirstChild("Backpack") then
        pcall(function() hum:EquipTool(megaphone) end)
        task.wait(0.5)
    end
end

function Combat:GrabV2(targetName)
    local targetPlayer = nil
    for _, plr in ipairs(Players:GetPlayers()) do
        if string.lower(plr.Name) == string.lower(targetName) or string.lower(plr.DisplayName or "") == string.lower(targetName) then
            targetPlayer = plr
            break
        end
    end
    if not targetPlayer then return end
    if targetPlayer == player then return end
    
    local remoteDetonator = FindTool("Remote Explosive Detonator")
    local turkeyLeg = FindTool("Turkey Leg")
    if not remoteDetonator or not turkeyLeg then return end
    
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
    end
    
    task.wait(0.5)
    pcall(function() hum:UnequipTools() end)
    task.wait(0.2)
    
    if turkeyLeg.Parent == player:FindFirstChild("Backpack") then
        pcall(function() hum:EquipTool(turkeyLeg) end)
    end
end

function Combat:Snowball(targetName)
    local targetPlayer = nil
    for _, plr in ipairs(Players:GetPlayers()) do
        if string.lower(plr.Name) == string.lower(targetName) or string.lower(plr.DisplayName or "") == string.lower(targetName) then
            targetPlayer = plr
            break
        end
    end
    if not targetPlayer then return end
    if targetPlayer == player then return end
    
    local dracovin = FindTool("Dracovin Spellbook")
    local hyperlaser = FindTool("Hyperlaser Gun")
    if not dracovin or not hyperlaser then return end
    
    local function isFrozen(char)
        if not char then return false end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return false end
        if hum.WalkSpeed < 5 or hum.JumpPower < 10 then return true end
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            for _, child in ipairs(root:GetChildren()) do
                if child:IsA("Attachment") then
                    if string.find(string.lower(child.Name), "frost") or string.find(string.lower(child.Name), "snow") or string.find(string.lower(child.Name), "ice") then
                        return true
                    end
                end
            end
        end
        return false
    end
    
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    
    local targetChar = targetPlayer.Character
    if not targetChar then return end
    
    local startTime = tick()
    while tick() - startTime < 30 do
        if isFrozen(targetChar) then break end
        task.wait(0.5)
    end
    
    if not isFrozen(targetChar) then return end
    
    if dracovin.Parent == player:FindFirstChild("Backpack") then
        pcall(function() hum:EquipTool(dracovin) end)
        task.wait(0.5)
    end
    
    local dracovinRemote = dracovin:FindFirstChild("ClientInput")
    if dracovinRemote then
        pcall(function() dracovinRemote:FireServer(Enum.KeyCode.E) end)
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
    while shootCount < 20 and isFrozen(targetChar) do
        pcall(function() hyperlaserRemote:FireServer() end)
        shootCount = shootCount + 1
        task.wait(0.3)
    end
    
    pcall(function() hum:UnequipTools() end)
end

function Combat:ESPLockOn(targetName)
    local targetPlayer = nil
    for _, plr in ipairs(Players:GetPlayers()) do
        if string.lower(plr.Name) == string.lower(targetName) or string.lower(plr.DisplayName or "") == string.lower(targetName) then
            targetPlayer = plr
            break
        end
    end
    if not targetPlayer then return end
    if targetPlayer == player then return end
    
    local lockOn = FindTool("Lock On Launcher")
    local spartan = FindTool("Spartan Sword and Shield")
    if not lockOn or not spartan then return end
    
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    
    local targetChar = targetPlayer.Character
    if not targetChar then return end
    local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
    if not targetHRP then return end
    
    if lockOn.Parent == player:FindFirstChild("Backpack") then
        pcall(function() hum:EquipTool(lockOn) end)
        task.wait(0.2)
    end
    
    local lockOnRemote = lockOn:FindFirstChild("Remote")
    if lockOnRemote then
        pcall(function() lockOnRemote:FireServer(targetHRP.Position) end)
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
    end
    
    task.wait(0.3)
    pcall(function() hum:UnequipTools() end)
end

function Combat:Egg(targetName)
    local targetPlayer = nil
    for _, plr in ipairs(Players:GetPlayers()) do
        if string.lower(plr.Name) == string.lower(targetName) or string.lower(plr.DisplayName or "") == string.lower(targetName) then
            targetPlayer = plr
            break
        end
    end
    if not targetPlayer then return end
    if targetPlayer == player then return end
    
    local eggTool = FindTool("Joyful Periastron")
    if not eggTool then return end
    
    local function isFloating(char)
        if not char then return false end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root then return false end
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Blacklist
        params.FilterDescendantsInstances = {char}
        local result = Workspace:Raycast(root.Position, Vector3.new(0, -5, 0), params)
        if not result then return true end
        if hum.FloorMaterial == Enum.Material.Air then return true end
        return false
    end
    
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    
    local targetChar = targetPlayer.Character
    if not targetChar then return end
    if not isFloating(targetChar) then return end
    
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
    else
        local originalHandleCFrame = eggHandle.CFrame
        pcall(function() eggHandle.CFrame = targetHRP.CFrame * CFrame.new(0, 2, 0) end)
        task.wait(0.1)
        pcall(function() eggHandle.CFrame = originalHandleCFrame end)
    end
    
    task.wait(0.5)
    pcall(function() myHRP.CFrame = originalCFrame end)
    task.wait(0.3)
    pcall(function() hum:UnequipTools() end)
end

function Combat:AnchorV2()
    local sword = FindTool("SwordOfLight")
    if not sword then return end
    
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
    task.wait(0.3)
    pcall(function() hum:UnequipTools() end)
end

return Combat