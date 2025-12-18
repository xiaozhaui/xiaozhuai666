-- 🆕 全新独立脚本：迷你悬浮窗v2.0（2025.12.19 最新版）
-- 重命名所有元素，避免与旧脚本冲突
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- 全局状态（默认关闭）
local isOpen = false
local mainColor = Color3.fromRGB(255, 100, 100) -- 改为红色，区别旧版本

-- 主GUI（全新命名，避免冲突）
local miniGui = Instance.new("ScreenGui")
miniGui.Name = "MiniWindow_v2_20251219" -- 唯一名称，绝对不会冲突
miniGui.DisplayOrder = 999999
miniGui.IgnoreGuiInset = true
miniGui.Parent = PlayerGui

-- 触发按钮（迷你版：100×35，位置调整到右上角）
local triggerBtn = Instance.new("TextButton")
triggerBtn.Size = UDim2.new(0, 100, 0, 35) -- 比之前更小！
triggerBtn.Position = UDim2.new(0.98, -100, 0.02, 0) -- 右上角，不挡操作
triggerBtn.BackgroundColor3 = mainColor
triggerBtn.Text = "小拽v2"
triggerBtn.TextColor3 = Color3.new(1, 1, 1)
triggerBtn.Font = Enum.Font.SourceSansBold
triggerBtn.TextSize = 14
triggerBtn.ZIndex = 10
triggerBtn.Parent = miniGui
Instance.new("UICorner", triggerBtn).CornerRadius = UDim.new(0.5, 0)

-- 面板+容器（默认高度0，完全关闭）
local panelFrame = Instance.new("Frame")
panelFrame.Name = "Panel_v2"
panelFrame.Size = UDim2.new(0, 160, 0, 0) -- 更窄的面板
panelFrame.Position = UDim2.new(0.98, -160, 0.02, 35) -- 与按钮对齐
panelFrame.BackgroundColor3 = mainColor
panelFrame.ZIndex = 10
panelFrame.ClipsDescendants = true
panelFrame.Parent = miniGui
Instance.new("UICorner", panelFrame).CornerRadius = UDim.new(0.5, 0)

local contentFrame = Instance.new("Frame", panelFrame)
contentFrame.Size = UDim2.new(1, -8, 1, -8)
contentFrame.Position = UDim2.new(0, 4, 0, 4)
contentFrame.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", contentFrame)
layout.Padding = UDim.new(0, 5)

-- 按钮创建（150×30，迷你尺寸）
local function createMiniBtn(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 150, 0, 30) -- 更小的按钮
    btn.BackgroundColor3 = Color3.fromRGB(50, 30, 20)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 12 -- 更小的字体
    btn.ZIndex = 11
    btn.Parent = contentFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0.3, 0)

    local isOn = false
    local function toggle()
        isOn = not isOn
        btn.BackgroundColor3 = isOn and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(50, 30, 20)
        pcall(callback, isOn)
    end
    btn.MouseButton1Click:Connect(toggle)
    btn.TouchTap:Connect(toggle) -- 手机触摸必备
    return btn
end

-- 核心功能（与之前相同，但完全独立）
createMiniBtn("自动刷", function(enabled)
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

createMiniBtn("自动收", function(enabled)
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

createMiniBtn("自动领", function(enabled)
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

createMiniBtn("升级大小", function(enabled)
    if not enabled then return end
    coroutine.wrap(function()
        local PurchaseEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("PurchaseEvent")
        while enabled do
            pcall(function() PurchaseEvent:FireServer("MaxSize") end)
            task.wait(1)
        end
    end)()
end)

createMiniBtn("玩家数据", function()
    local loc = {MaxSize = "体积", Speed = "移速", Multiplier = "乘数", EatSpeed = "吃速"}
    for _, u in LocalPlayer.Upgrades:GetChildren() do
        print(string.format("%s：%i级", loc[u.Name] or u.Name, u.Value))
    end
    game.StarterGui:SetCore("DevConsoleVisible", true)
end)

-- 展开/收起功能（默认关闭）
local function togglePanel()
    isOpen = not isOpen
    if isOpen then
        local totalH = 0
        for _, btn in contentFrame:GetChildren() do
            totalH += btn.AbsoluteSize.Y + layout.Padding.Offset
        end
        panelFrame.Size = UDim2.new(0, 160, 0, totalH + 10)
    else
        panelFrame.Size = UDim2.new(0, 160, 0, 0) -- 完全关闭
    end
end

triggerBtn.MouseButton1Click:Connect(togglePanel)
triggerBtn.TouchTap:Connect(togglePanel) -- 手机触摸必须

-- 触摸拖动优化（防误触）
local isDragging, startPos, btnStartPos, panelStartPos = false, Vector2.new(0, 0), triggerBtn.Position, panelFrame.Position
triggerBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        startPos = input.Position
        btnStartPos = triggerBtn.Position
        panelStartPos = panelFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - startPos
        triggerBtn.Position = UDim2.new(0, btnStartPos.X.Offset + delta.X, 0, btnStartPos.Y.Offset + delta.Y)
        panelFrame.Position = UDim2.new(0, btnStartPos.X.Offset + delta.X - 60, 0, btnStartPos.Y.Offset + delta.Y + 35)
        startPos = input.Position
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = false
    end
end)

print("=== 全新迷你脚本加载成功 ===")
print("右上角显示100×35红色按钮，点击展开功能，再次点击关闭")
print("按钮可按住拖动到任意位置，不遮挡游戏画面")
