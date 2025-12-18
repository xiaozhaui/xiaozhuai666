-- 专用清理脚本（先执行，彻底清除旧残留）
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- 删除所有旧UI和残留
pcall(function() PlayerGui.FinalFunctionalWindow:Destroy() end)
pcall(function() PlayerGui.TestWindow:Destroy() end)
pcall(function() PlayerGui.MiniWindow:Destroy() end)
pcall(function() PlayerGui.TestUI:Destroy() end)
pcall(function() PlayerGui.ClickTest:Destroy() end)
pcall(function() PlayerGui:FindFirstChildWhichIsA("ScreenGui"):Destroy() end)

-- 清理全局变量
autofarm = nil
autoCollectingCubes = nil
autoClaimRewards = nil
autoUpgradeSize = nil

print("✅ 旧脚本残留已彻底清除！")

-- 超精简修复版脚本（默认关闭+尺寸优化）
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- 全局状态（默认关闭）
local isOpen = false
local mainColor = Color3.fromRGB(139, 101, 64)

-- 主GUI
local gui = Instance.new("ScreenGui")
gui.Name = "FinalFunctionalWindow"
gui.DisplayOrder = 999999
gui.IgnoreGuiInset = true
gui.Parent = PlayerGui

-- 触发按钮（缩小到120×40，左上角，不挡操作）
local trigger = Instance.new("TextButton")
trigger.Size = UDim2.new(0, 120, 0, 40)
trigger.Position = UDim2.new(0.02, 0, 0.02, 0)
trigger.BackgroundColor3 = mainColor
trigger.Text = "小拽功能"
trigger.TextColor3 = Color3.new(1, 1, 1)
trigger.Font = Enum.Font.SourceSansBold
trigger.TextSize = 16
trigger.ZIndex = 10
trigger.Parent = gui
Instance.new("UICorner", trigger).CornerRadius = UDim.new(0.5, 0)

-- 面板+容器（默认高度0，完全关闭）
local panel = Instance.new("Frame")
panel.Name = "Panel"
panel.Size = UDim2.new(0, 180, 0, 0) -- 默认关闭
panel.Position = UDim2.new(0.02, 0, 0.02, 40)
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
layout.Padding = UDim.new(0, 6)

-- 按钮创建（180×35，触摸友好）
local function createBtn(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 180, 0, 35)
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
    btn.TouchTap:Connect(toggle) -- 手机触摸必备
    return btn
end

-- 核心功能（保留5个实用功能）
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

-- 展开/收起功能（默认关闭）
local function togglePanel()
    isOpen = not isOpen
    if isOpen then
        local totalH = 0
        for _, btn in content:GetChildren() do
            totalH += btn.AbsoluteSize.Y + layout.Padding.Offset
        end
        panel.Size = UDim2.new(0, 180, 0, totalH + 12)
    else
        panel.Size = UDim2.new(0, 180, 0, 0) -- 完全关闭
    end
end

trigger.MouseButton1Click:Connect(togglePanel)
trigger.TouchTap:Connect(togglePanel) -- 手机触摸必须

-- 触摸拖动优化（防误触）
local isDragging, startPos, triggerStartPos, panelStartPos = false, Vector2.new(0, 0), trigger.Position, panel.Position
trigger.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        startPos = input.Position
        triggerStartPos = trigger.Position
        panelStartPos = panel.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - startPos
        trigger.Position = UDim2.new(0, triggerStartPos.X.Offset + delta.X, 0, triggerStartPos.Y.Offset + delta.Y)
        panel.Position = UDim2.new(0, triggerStartPos.X.Offset + delta.X, 0, triggerStartPos.Y.Offset + delta.Y + 40)
        startPos = input.Position
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = false
    end
end)

print("=== 修复版脚本加载成功 ===")
print("左上角120×40棕色按钮，点击展开功能，再次点击关闭")
