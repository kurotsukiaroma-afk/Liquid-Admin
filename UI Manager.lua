local UIManager = {}
local UI = nil

function UIManager:Create()
    local CoreGui = game:GetService("CoreGui")
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "LiquidUI"
    screenGui.Parent = CoreGui
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.BackgroundTransparency = 1
    mainFrame.Parent = screenGui
    
    UI = {Gui = screenGui, Frame = mainFrame}
    return UI
end

function UIManager:Destroy()
    if UI and UI.Gui then UI.Gui:Destroy() end
end

return UIManager