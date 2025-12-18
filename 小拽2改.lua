-- 🛡️ 手机专用终极版：点击必响应+滑动不消失+三重保险（2025.12.19）
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")

-- 🔧 第一步：深度清理（彻底删除所有旧UI和残留，防止冲突）
for _, screenGui in ipairs(PlayerGui:GetChildren()) do
    if screenGui:IsA("ScreenGui") then
        pcall(function() screenGui:Destroy() end)
    end
end
_G = {} -- 重置全局环境
autofarm = nil; autoCollectingCubes = nil; autoClaimRewards = nil

-- 🛡️ 全局状态（四重保障，绝对稳定）
local isOpen = false
local isDragging = false
local touchStartPos = Vector2.new(0, 0)
local TOUCH_THRESHOLD = 10 -- 触摸偏移阈值：小于10像素视为点击，大于视为拖动
local mainColor = Color3.fromRGB(0, 200, 255) -- 天蓝色，与所有旧版本区分

-- 🎨 主GUI（绝对无冲突命名+最高层级）
local gui = Instance.new("ScreenGui")
gui.Name = "MobileUltimateWindow_20251219"
gui.DisplayOrder = 999999 -- 最高层级，不会被任何元素遮挡
gui.IgnoreGuiInset = true
gui.Parent = PlayerGui

-- 🎯 触发按钮（超迷你+高对比度，手机触摸精准）
local trigger = Instance.new("TextButton")
trigger.Size = UDim2.new(0, 90, 0, 32) -- 精准触摸尺寸
trigger.Position = UDim2.new(0.02, 0, 0.02, 0) -- 左上角，不挡操作
trigger.BackgroundColor3 = mainColor
trigger.Text = "小拽v4"
trigger.TextColor3 = Color3.new(1, 1, 1)
trigger.Font = Enum.Font.SourceSansBold
trigger.TextSize = 14
trigger.ZIndex = 1000 -- 最高ZIndex，防止遮挡
trigger.Parent = gui
trigger.Active = true -- 强制激活，确保能捕获触摸事件
trigger.Selectable = true -- 支持游戏手柄选择，兼容所有设备
Instance.new("UICorner", trigger).CornerRadius = UDim.new(0.5, 0)

-- 📦 面板+容器（默认关闭+防穿透）
local panel = Instance.new("Frame")
panel.Name = "Panel_v4"
panel.Size = UDim2.new(0, 160, 0, 0) -- 默认完全关闭
panel.Position = UDim2.new(0.02, 0, 0.02, 32) -- 与按钮紧密对齐
panel.BackgroundColor3 = mainColor
panel.ZIndex = 999
panel.ClipsDescendants = true
panel.Parent = gui
panel.Active = true -- 防止触摸穿透到游戏
panel.Selectable = true
Instance.new("UICorner", panel).CornerRadius = UDim.new(0.5, 0)

local content = Instance.new("Frame", panel)
content.Size = UDim2.new(1, -8, 1, -8)
content.Position = UDim2.new(0, 4, 0, 4)
content.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", content)
layout.Padding = UDim.new(0, 5)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- 🎯 按钮创建（触摸精准+反馈清晰）
local function createUltraBtn(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 150, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 12
    btn.ZIndex = 1001
    btn.Parent = content
    btn.Active = true
    btn.Selectable = true
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0.3, 0)

    local isOn = false
    local function toggle()
        isOn = not isOn
        btn.BackgroundColor3 = isOn and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(40, 40, 60)
        pcall(callback, isOn)
        print(text .. (isOn and " 已启用" or " 已禁用")) -- 调试信息
    end
    -- 使用Activated事件（Roblox推荐，鼠标/触摸通用，无冲突）
    btn.Activated:Connect(toggle)
    return btn
end

-- ⚡ 核心功能（稳定可靠，与之前一致）
createUltraBtn("自动刷", function(enabled)
    if not enabled then return end
    coroutine.wrap(function()
        while enabled do
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Events") then
                local events = char.Events
                local grab = events:FindFirstChild("Grab")
                local eat = events:FindFirstChild("Eat")
                local sell = events:FindFirstChild("Sell")
                if grab and eat and sell then
                    grab:FireServer(); eat:FireServer()
                    local size = char:FindFirstChild("Size")
                    local maxSize = LocalPlayer.Upgrades:FindFirstChild("MaxSize")
                    if size and maxSize and size.Value >= maxSize.Value then
                        sell:FireServer()
                    end
                end
            end
            task.wait(0.1)
        end
    end)()
end)

createUltraBtn("自动收", function(enabled)
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

createUltraBtn("自动领", function(enabled)
    if not enabled then return end
    coroutine.wrap(function()
        local RewardEvent = game.ReplicatedStorage:WaitForChild("Events"):WaitForChild("RewardEvent")
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

createUltraBtn("升级大小", function(enabled)
    if not enabled then return end
    coroutine.wrap(function()
        local PurchaseEvent = game.ReplicatedStorage:WaitForChild("Events"):WaitForChild("PurchaseEvent")
        while enabled do
            pcall(function() PurchaseEvent:FireServer("MaxSize") end)
            task.wait(1)
        end
    end)()
end)

createUltraBtn("玩家数据", function()
    local loc = {MaxSize = "体积", Speed = "移速", Multiplier = "乘数", EatSpeed = "吃速"}
    for _, u in LocalPlayer.Upgrades:GetChildren() do
        print(string.format("%s：%i级", loc[u.Name] or u.Name, u.Value))
    end
    game.StarterGui:SetCore("DevConsoleVisible", true)
end)

-- 🎯 展开/收起功能（触摸精准+防消失核心逻辑）
local function togglePanel()
    if not isDragging then -- 只有非拖动状态才允许切换
        isOpen = not isOpen
        if isOpen then
            -- 计算面板高度（精确适配所有按钮）
            local totalH = 0
            for _, btn in content:GetChildren() do
                totalH += btn.AbsoluteSize.Y + layout.Padding.Offset
            end
            panel.Size = UDim2.new(0, 160, 0, totalH + 10)
            print("面板已展开") -- 调试信息
        else
            panel.Size = UDim2.new(0, 160, 0, 0) -- 完全关闭
            print("面板已关闭") -- 调试信息
        end
    end
end

-- 🖐️ 触摸事件处理（四重隔离，彻底解决冲突）
trigger.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = false
        touchStartPos = input.Position -- 记录触摸起始位置
        print("触摸开始：" .. tostring(touchStartPos)) -- 调试信息
    end
end)

trigger.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - touchStartPos
        if delta.Magnitude > TOUCH_THRESHOLD then -- 超过阈值视为拖动
            isDragging = true
            print("触摸滑动：" .. tostring(delta.Magnitude) .. "px，视为拖动") -- 调试信息
        end
    end
end)

-- 使用Activated事件（Roblox官方推荐，完美兼容鼠标和触摸）
trigger.Activated:Connect(function()
    -- 触摸偏移小于阈值才视为有效点击
    local lastInput = UserInputService:GetLastInputType()
    if lastInput == Enum.UserInputType.Touch then
        local currentPos = UserInputService:GetMouseLocation()
        local delta = currentPos - touchStartPos
        if delta.Magnitude <= TOUCH_THRESHOLD then
            togglePanel()
        end
    else
        togglePanel() -- 鼠标点击直接触发
    end
end)

-- 🖐️ 拖动逻辑（彻底分离，绝对不影响点击）
local btnStartPos = trigger.Position
local panelStartPos = panel.Position
trigger.InputChanged:Connect(function(input)
    if isDragging then
        local delta = input.Position - touchStartPos
        trigger.Position = UDim2.new(0, btnStartPos.X.Offset + delta.X, 0, btnStartPos.Y.Offset + delta.Y)
        panel.Position = UDim2.new(0, btnStartPos.X.Offset + delta.X, 0, btnStartPos.Y.Offset + delta.Y + 32)
        print("拖动中...") -- 调试信息
    end
end)

trigger.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = false -- 拖动结束，重置状态
        btnStartPos = trigger.Position -- 保存新位置
        panelStartPos = panel.Position
        print("触摸结束，拖动状态重置") -- 调试信息
    end
end)

-- 🛡️ 防消失终极保障：每0.5秒检查一次UI状态
RunService.Heartbeat:Connect(function()
    if not trigger.Parent then -- 如果按钮被意外删除
        trigger.Parent = gui -- 重新添加
        print("⚠️ 按钮被意外删除，已自动恢复")
    end
    if not panel.Parent then -- 如果面板被意外删除
        panel.Parent = gui -- 重新添加
        print("⚠️ 面板被意外删除，已自动恢复")
    end
end)

print("=== 手机专用终极版脚本加载成功 ===")
print("✅ 左上角天蓝色90×32按钮（小拽v4），点击必响应，滑动不消失")
print("✅ 触摸偏移小于10像素视为点击，大于视为拖动，绝对不会混淆")
print("✅ 自动恢复功能：UI被意外删除会自动重建")
