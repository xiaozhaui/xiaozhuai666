-- 超纯净手机核心脚本（2025年12月最新适配）
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- 全局状态
local isOpen = false
local mainColor = Color3.fromRGB(139, 101, 64)

-- 主GUI（极简设计，只保留必要元素）
local gui = Instance.new("ScreenGui")
gui.Name = "FinalFunctionalWindow"
gui.DisplayOrder = 999999
gui.IgnoreGuiInset = true
gui.Parent = PlayerGui

-- 触发按钮（手机超大：240×55，触摸零失误）
local trigger = Instance.new("TextButton")
trigger.Size = UDim2.new(0, 240, 0, 55)
trigger.Position = UDim2.new(0.02, 0, 0.02, 0)
trigger.BackgroundColor3 = mainColor
trigger.Text = "小拽吃吃世界"
trigger.TextColor3 = Color3.new(1, 1, 1)
trigger.Font = Enum.Font.SourceSansBold
trigger.TextSize = 20
trigger.ZIndex = 10
trigger.Parent = gui
Instance.new("UICorner", trigger).CornerRadius = UDim.new(0.5, 0)

-- 面板+容器
local panel = Instance.new("Frame")
panel.Name = "Panel"
panel.Size = UDim2.new(0, 240, 0, 0)
panel.Position = UDim2.new(0.02, 0, 0.02, 55)
panel.BackgroundColor3 = mainColor
panel.ZIndex = 10
panel.ClipsDescendants = true
panel.Parent = gui
Instance.new("UICorner", panel).CornerRadius = UDim.new(0.5, 0)

local content = Instance.new("Frame", panel)
content.Size = UDim2.new(1, -8, 1, -8)
content.Position = UDim2.new(0, 4, 0, 4)
content.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", content)
layout.Padding = UDim.new(0, 7)

-- 按钮创建（手机专用：200×40，触摸友好）
local function createBtn(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 200, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(70, 50, 30)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    btn.ZIndex = 11
    btn.Parent = content
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0.3, 0)

    local isOn = false
    local function toggle()
        isOn = not isOn
        btn.BackgroundColor3 = isOn and Color3.fromRGB(40, 200, 100) or Color3.fromRGB(70, 50, 30)
        pcall(callback, isOn)
    end
    btn.MouseButton1Click:Connect(toggle)
    btn.TouchTap:Connect(toggle) -- 手机触摸必备！
    return btn
end

-- 核心功能（保留最实用的5个，其他功能可后续添加）
createBtn("自动刷", function(enabled)
    if not enabled then return end
    coroutine.wrap(function()
        while true do
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Events") then
                local events = char.Events
                local grab = events:FindFirstChild("Grab")
                local eat = events:FindFirstChild("Eat")
                local sell = events:FindFirstChild("Sell")
                if grab and eat and sell then
                    grab:FireServer()
                    eat:FireServer()
                    local size = char:FindFirstChild("Size")
                    local maxSize = LocalPlayer.Upgrades:FindFirstChild("MaxSize")
                    if size and maxSize and size.Value >= maxSize.Value then
                        sell:FireServer()
                    end
                end
            end
            task.wait(0.1)
            if not enabled then break end
        end
    end)()
end)

createBtn("自动收", function(enabled)
    if not enabled then return end
    coroutine.wrap(function()
        while enabled do
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                for _, v in workspace:GetChildren() do
                    if v.Name == "Cube" and v:FindFirstChild("Owner") and (v.Owner.Value == LocalPlayer.Name or v.Owner.Value == "") then
                        pcall(function() v.CFrame = root.CFrame end)
                    end
                end
            end
            task.wait(0.5)
        end
    end)()
end)

createBtn("自动领", function(enabled)
    if not enabled then return end
    coroutine.wrap(function()
        local RewardEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("RewardEvent")
        local TimedRewards = LocalPlayer:WaitForChild("TimedRewards")
        while enabled do
            for _, r in TimedRewards:GetChildren() do
                if r.Value > 0 then
                    pcall(function() RewardEvent:FireServer(r) end)
                end
            end
            task.wait(5)
        end
    end)()
end)

createBtn("升级大小", function(enabled)
    if not enabled then return end
    coroutine.wrap(function()
        local PurchaseEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("PurchaseEvent")
        while enabled do
            pcall(function() PurchaseEvent:FireServer("MaxSize") end)
            task.wait(1)
        end
    end)()
end)

createBtn("玩家数据", function()
    local loc = {MaxSize = "体积", Speed = "移速", Multiplier = "乘数", EatSpeed = "吃速"}
    for _, u in LocalPlayer.Upgrades:GetChildren() do
        print(string.format("%s：%i级", loc[u.Name] or u.Name, u.Value))
    end
    game.StarterGui:SetCore("DevConsoleVisible", true)
end)

-- 展开/收起功能
local function togglePanel()
    isOpen = not isOpen
    if isOpen then
        local totalH = 0
        for _, btn in content:GetChildren() do
            totalH += btn.AbsoluteSize.Y + layout.Padding.Offset
        end
        panel.Size = UDim2.new(0, 240, 0, totalH + 12)
    else
        panel.Size = UDim2.new(0, 240, 0, 0)
    end
end

trigger.MouseButton1Click:Connect(togglePanel)
trigger.TouchTap:Connect(togglePanel) -- 手机触摸必须！

print("=== 超纯净脚本加载成功 ===")
print("左上角240×55棕色按钮，触摸点击展开功能")
