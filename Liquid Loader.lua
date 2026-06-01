-- Services
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local TeleportService = game:GetService("TeleportService")
local TextChatService = game:GetService("TextChatService")

local player = Players.LocalPlayer
local isRunning = true

-- Create Top Status Bar (White Text)
local statusGui = Instance.new("ScreenGui")
statusGui.Name = "LiquidStatus"
statusGui.Parent = CoreGui
statusGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local statusBar = Instance.new("Frame")
statusBar.Size = UDim2.new(1, 0, 0, 30)
statusBar.Position = UDim2.new(0, 0, 0, 0)
statusBar.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
statusBar.BackgroundTransparency = 0.15
statusBar.BorderSizePixel = 0
statusBar.Parent = statusGui

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, 0, 1, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "Liquid Admin - Initializing..."
statusText.TextColor3 = Color3.fromRGB(255, 255, 255)
statusText.TextSize = 14
statusText.Font = Enum.Font.GothamBold
statusText.Parent = statusBar

-- Function to update status text
local function updateStatus(message)
    statusText.Text = "Liquid Admin - " .. message
    print("[Liquid] " .. message)
end

-- Notification System
local function Notify(title, message, duration, style)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "LiquidNotif"
    screenGui.Parent = CoreGui

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
    leftBar.BackgroundColor3 = stroke.Color
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

    local fadeIn = TweenService:Create(notif, TweenInfo.new(0.25), {BackgroundTransparency = 0.05, Position = UDim2.new(1, -330, 0, 10)})
    fadeIn:Play()

    task.spawn(function()
        task.wait(duration or 4)
        local fadeOut = TweenService:Create(notif, TweenInfo.new(0.25), {BackgroundTransparency = 0.2, Position = UDim2.new(1, -330, 0, 5)})
        fadeOut:Play()
        fadeOut.Completed:Connect(function() screenGui:Destroy() end)
    end)
end

-- Function to download a module from GitHub
local function downloadModule(url, path)
    if not isfolder("Liquid") then makefolder("Liquid") end
    if not isfolder("Liquid/Modules") then makefolder("Liquid/Modules") end
    if not isfolder("Liquid/Auto") then makefolder("Liquid/Auto") end
    if not isfolder("Liquid/Loops") then makefolder("Liquid/Loops") end
    
    if not isfile(path) then
        local success, result = pcall(function()
            return game:HttpGet(url, true)
        end)
        if success then
            writefile(path, result)
            return true
        else
            updateStatus("Failed to download: " .. path)
            return false
        end
    end
    return true
end

-- List of all modules to download
local modules = {
    -- Core Modules
    {url = "https://raw.githubusercontent.com/kurotsukiaroma-afk/Liquid-Admin/main/Core.lua", path = "Liquid/Modules/Core.lua"},
    {url = "https://raw.githubusercontent.com/kurotsukiaroma-afk/Liquid-Admin/main/UI%20Manager.lua", path = "Liquid/Modules/UIManager.lua"},
    {url = "https://raw.githubusercontent.com/kurotsukiaroma-afk/Liquid-Admin/main/Combat.lua", path = "Liquid/Modules/Combat.lua"},
    {url = "https://raw.githubusercontent.com/kurotsukiaroma-afk/Liquid-Admin/main/Protection.lua", path = "Liquid/Modules/Protection.lua"},
    {url = "https://raw.githubusercontent.com/kurotsukiaroma-afk/Liquid-Admin/main/Utility.lua", path = "Liquid/Modules/Utility.lua"},
    {url = "https://raw.githubusercontent.com/kurotsukiaroma-afk/Liquid-Admin/main/Whitelist.lua", path = "Liquid/Modules/Whitelist.lua"},
    {url = "https://raw.githubusercontent.com/kurotsukiaroma-afk/Liquid-Admin/main/Blacklist.lua", path = "Liquid/Modules/Blacklist.lua"},
    {url = "https://raw.githubusercontent.com/kurotsukiaroma-afk/Liquid-Admin/main/AntiPause.lua", path = "Liquid/Modules/AntiPause.lua"},
    {url = "https://raw.githubusercontent.com/kurotsukiaroma-afk/Liquid-Admin/main/SkinTone.lua", path = "Liquid/Modules/SkinTone.lua"},
    
    -- Auto Modules
    {url = "https://raw.githubusercontent.com/kurotsukiaroma-afk/Liquid-Admin/main/AutoKill.lua", path = "Liquid/Auto/AutoKill.lua"},
    {url = "https://raw.githubusercontent.com/kurotsukiaroma-afk/Liquid-Admin/main/AutoBlind.lua", path = "Liquid/Auto/AutoBlind.lua"},
    {url = "https://raw.githubusercontent.com/kurotsukiaroma-afk/Liquid-Admin/main/AutoInf.lua", path = "Liquid/Auto/AutoInf.lua"},
    {url = "https://raw.githubusercontent.com/kurotsukiaroma-afk/Liquid-Admin/main/AutoPerm.lua", path = "Liquid/Auto/AutoPerm.lua"},
    {url = "https://raw.githubusercontent.com/kurotsukiaroma-afk/Liquid-Admin/main/AutoNaN.lua", path = "Liquid/Auto/AutoNan.lua"},
    {url = "https://raw.githubusercontent.com/kurotsukiaroma-afk/Liquid-Admin/main/AutoManager.lua", path = "Liquid/Auto/AutoManager.lua"},
}

-- Download all modules with progress updates
updateStatus("Downloading required modules...")

local totalModules = #modules
local loadedModules = 0

for _, module in ipairs(modules) do
    if downloadModule(module.url, module.path) then
        loadedModules = loadedModules + 1
        updateStatus(string.format("Downloading modules... (%d/%d)", loadedModules, totalModules))
    end
    task.wait()
end

updateStatus("All modules downloaded! Loading...")

-- Load all modules
local Core = loadfile("Liquid/Modules/Core.lua")()
local UIManager = loadfile("Liquid/Modules/UIManager.lua")()
local Combat = loadfile("Liquid/Modules/Combat.lua")()
local Protection = loadfile("Liquid/Modules/Protection.lua")()
local Utility = loadfile("Liquid/Modules/Utility.lua")()
local WhitelistModule = loadfile("Liquid/Modules/Whitelist.lua")()
local BlacklistModule = loadfile("Liquid/Modules/Blacklist.lua")()
local AntiPause = loadfile("Liquid/Modules/AntiPause.lua")()
local SkinTone = loadfile("Liquid/Modules/SkinTone.lua")()

local AutoManager = loadfile("Liquid/Auto/AutoManager.lua")()

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

-- Stats Panel (Bottom Left)
local StatsPanel = Instance.new("ScreenGui")
StatsPanel.Name = "LiquidStats"
StatsPanel.Parent = CoreGui

local panelFrame = Instance.new("Frame")
panelFrame.Size = UDim2.new(0, 220, 0, 110)
panelFrame.Position = UDim2.new(0, 10, 1, -120)
panelFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
panelFrame.BackgroundTransparency = 0.1
panelFrame.BorderSizePixel = 0
panelFrame.Parent = StatsPanel

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 6)
panelCorner.Parent = panelFrame

local panelStroke = Instance.new("UIStroke")
panelStroke.Color = Color3.fromRGB(35, 35, 45)
panelStroke.Thickness = 1
panelStroke.Parent = panelFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -10, 0, 22)
titleLabel.Position = UDim2.new(0, 8, 0, 4)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "LIQUID ADMIN"
titleLabel.TextColor3 = Color3.fromRGB(65, 180, 245)
titleLabel.TextSize = 12
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = panelFrame

local killsLabel = Instance.new("TextLabel")
killsLabel.Size = UDim2.new(1, -10, 0, 18)
killsLabel.Position = UDim2.new(0, 8, 0, 28)
killsLabel.BackgroundTransparency = 1
killsLabel.Text = "Kills: 0"
killsLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
killsLabel.TextSize = 11
killsLabel.Font = Enum.Font.Gotham
killsLabel.TextXAlignment = Enum.TextXAlignment.Left
killsLabel.Parent = panelFrame

local attacksLabel = Instance.new("TextLabel")
attacksLabel.Size = UDim2.new(1, -10, 0, 18)
attacksLabel.Position = UDim2.new(0, 8, 0, 46)
attacksLabel.BackgroundTransparency = 1
attacksLabel.Text = "Attacks: 0"
attacksLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
attacksLabel.TextSize = 11
attacksLabel.Font = Enum.Font.Gotham
attacksLabel.TextXAlignment = Enum.TextXAlignment.Left
attacksLabel.Parent = panelFrame

local whitelistLabel = Instance.new("TextLabel")
whitelistLabel.Size = UDim2.new(1, -10, 0, 18)
whitelistLabel.Position = UDim2.new(0, 8, 0, 64)
whitelistLabel.BackgroundTransparency = 1
whitelistLabel.Text = "Whitelist: 0"
whitelistLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
whitelistLabel.TextSize = 11
whitelistLabel.Font = Enum.Font.Gotham
whitelistLabel.TextXAlignment = Enum.TextXAlignment.Left
whitelistLabel.Parent = panelFrame

local blacklistLabel = Instance.new("TextLabel")
blacklistLabel.Size = UDim2.new(1, -10, 0, 18)
blacklistLabel.Position = UDim2.new(0, 8, 0, 82)
blacklistLabel.BackgroundTransparency = 1
blacklistLabel.Text = "Blacklist: 0"
blacklistLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
blacklistLabel.TextSize = 11
blacklistLabel.Font = Enum.Font.Gotham
blacklistLabel.TextXAlignment = Enum.TextXAlignment.Left
blacklistLabel.Parent = panelFrame

-- Update stat labels function
local function UpdateStatLabels()
    whitelistLabel.Text = "Whitelist: " .. #Vars.Whitelist
    blacklistLabel.Text = "Blacklist: " .. #Vars.Blacklist
    killsLabel.Text = "Kills: " .. Vars.Stats.Kills
    attacksLabel.Text = "Attacks: " .. Vars.Stats.Attacks
end

-- Load saved data
pcall(function()
    if isfile("Liquid/data.json") then
        local data = HttpService:JSONDecode(readfile("Liquid/data.json"))
        Vars.Whitelist = data.Whitelist or {}
        Vars.Blacklist = data.Blacklist or {}
        Vars.Stats = data.Stats or {Start = tick(), Kills = 0, Attacks = 0}
        Vars.Prefix = data.Prefix or ","
        UpdateStatLabels()
    end
end)

-- Initialize Anti-Pause
AntiPause:Start()

-- Setup Chat Command Handler
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
    
    -- Simple commands for now
    if cmd == "help" then
        print("Liquid Admin Commands:")
        print("  kill/k <target> - Kill player")
        print("  inf/i <target> - Give infinite health")
        print("  god - Godmode on self")
        print("  ping - Check ping")
        print("  clear - Clear screen clutter")
        Notify("Liquid", "Commands printed to console", 3)
    elseif cmd == "ping" then
        local ping = math.floor(player:GetNetworkPing() * 1000)
        Notify("Liquid", "Ping: " .. ping .. "ms", 2)
    elseif cmd == "clear" then
        pcall(function()
            for _, v in ipairs(StarterGui:GetChildren()) do
                if v.Name == "SignUI" or v.Name == "Notifications" then v:Destroy() end
            end
        end)
        Notify("Liquid", "Screen clutter removed", 2)
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
        )
    else
        player.Chatted:Connect(HandleCommand)
    end
end

-- Finalize
updateStatus("Ready!")
SetupChat()
Notify("Liquid Admin", "Ready! Type " .. Vars.Prefix .. "help", 4)

-- Update status bar with stats
task.spawn(function()
    while isRunning do
        task.wait(1)
        local autoStr = ""
        if Vars.Auto.Kill then autoStr = autoStr .. "K " end
        if Vars.Auto.Inf then autoStr = autoStr .. "I " end
        if autoStr == "" then autoStr = "None" end
        updateStatus("Kills: " .. Vars.Stats.Kills .. " | Auto: " .. autoStr)
    end
end)
