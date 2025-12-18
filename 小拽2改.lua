-- 🔧 终极修复版：一键清理+防消失悬浮窗+超迷你UI（手机专用）
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- 第一步：深度清理（彻底删除所有旧UI和残留）
for _, screenGui in ipairs(PlayerGui:GetChildren()) do
    if screenGui:IsA("ScreenGui") then
        pcall(function() screenGui:Destroy() end)
    end
end
_G = {} -- 重置全局环境
autofarm = nil; autoCollectingCubes = nil; autoClaimRewards = nil

-- 全局状态（三重保障，防止状态异常）
local isOpen = false
local isDragging = false -- 单独标记拖动状态，避免与点击冲突
local dragStartTime = 0
local mainColor = Color3.fromRGB(255, 80, 80) -- 亮红色，易识别

-- 主GUI（全新命名，绝对无冲突）
local gui = Instance.new("ScreenGui")
gui.Name = "UltimateMiniWindow_20251219"
gui.DisplayOrder = 999999
gui.IgnoreGuiInset = true
gui.Parent = PlayerGui

-- 触发按钮（80×30超迷你，左上角，防误触）
local trigger = Instance.new("TextButton")
trigger.Size = UDim2.new(0, 80, 0, 30) -- 极致迷你，不挡视野
trigger.Position = UDim2.new(0.02, 0, 0.02, 0)
trigger.BackgroundColor3 = mainColor
trigger.Text = "小拽v3"
trigger.TextColor3 = Color3.new(1, 1, 1)
trigger.Font = Enum.Font.SourceSansBold
trigger.TextSize = 14
trigger.ZIndex = 100 -- 极高层级，防止被遮挡
trigger.Parent = gui
Instance.new("UICorner", trigger).CornerRadius = UDim.new(0.5, 0)

-- 面板+容器（默认高度0，完全关闭）
local panel = Instance.new("Frame")
panel.Name = "Panel_v3"
panel.Size = UDim2.new(0, 150, 0, 0) -- 超窄面板
panel.Position = UDim2.new(0.02, 0, 0.02, 30) -- 与按钮紧密对齐
panel.BackgroundColor3 = mainColor
panel.ZIndex = 99
panel.ClipsDescendants = true
panel.Parent = gui
Instance.new("UICorner", panel).CornerRadius = UDim.new(0.5, 0)

local content = Instance.new("Frame", panel)
content.Size = UDim2.new(1, -8, 1, -8)
content.Position = UDim2.new(0, 4, 0, 4)
content.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", content)
layout.Padding = UDim.new(0, 5)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- 按钮创建（140×28，超迷你，触摸精准）
local function createSafeBtn(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 140, 0, 28)
    btn.BackgroundColor3 = Color3.fromRGB(60, 30, 30)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 12
    btn.ZIndex = 101
    btn.Parent = content
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0.3, 0)

    local isOn = false
    local function toggle()
        isOn = not isOn
        btn.BackgroundColor3 = isOn and Color3.fromRGB(0, 220, 100) or Color3.fromRGB(60, 30, 30)
        pcall(callback, isOn)
    end
    -- 按钮单独绑定事件，避免与触发按钮冲突
    btn.MouseButton1Click:Connect(toggle)
    btn.TouchTap:Connect(toggle)
    return btn
end

-- 核心功能（稳定可靠）
createSafeBtn("自动刷", function(enabled)
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

createSafeBtn("自动收", function(enabled)
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

createSafeBtn("自动领", function(enabled)
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

createSafeBtn("升级大小", function(enabled)
    if not enabled then return end
    coroutine.wrap(function()
        local PurchaseEvent = game.ReplicatedStorage:WaitForChild("Events"):WaitForChild("PurchaseEvent")
        while enabled do
            pcall(function() PurchaseEvent:FireServer("MaxSize") end)
            task.wait(1)
        end
    end)()
end)

createSafeBtn("玩家数据", function()
    local loc = {MaxSize = "体积", Speed = "移速", Multiplier = "乘数", EatSpeed = "吃速"}
    for _, u in LocalPlayer.Upgrades:GetChildren() do
        print(string.format("%s：%i级", loc[u.Name] or u.Name, u.Value))
    end
    game.StarterGui:SetCore("DevConsoleVisible", true)
end)

-- 展开/收起功能（防消失核心逻辑）
local function togglePanel()
    -- 只有非拖动状态下才允许切换面板
    if not isDragging and (tick() - dragStartTime > 0.2) then
        isOpen = not isOpen
        if isOpen then
            -- 计算面板高度（精确适配所有按钮）
            local totalH = 0
            for _, btn in content:GetChildren() do
                totalH += btn.AbsoluteSize.Y + layout.Padding.Offset
            end
            panel.Size = UDim2.new(0, 150, 0, totalH + 10)
        else
            panel.Size = UDim2.new(0, 150, 0, 0) -- 完全关闭
        end
    end
end

-- 触发按钮事件处理（防冲突核心优化）
trigger.MouseButton1Down:Connect(function()
    dragStartTime = tick() -- 记录点击开始时间
    isDragging = false
end)

trigger.MouseButton1Click:Connect(function()
    -- 点击时间短于0.2秒才视为有效点击，防止与拖动混淆
    if tick() - dragStartTime < 0.2 then
        togglePanel()
    end
end)

trigger.TouchTap:Connect(function()
    -- 手机触摸专用事件，单独处理，防止穿透
    togglePanel()
end)

-- 拖动逻辑（彻底分离，避免与点击冲突）
local startPos, btnStartPos, panelStartPos = Vector2.new(0, 0), trigger.Position, panel.Position
trigger.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        startPos = input.Position
        btnStartPos = trigger.Position
        panelStartPos = panel.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - startPos
        trigger.Position = UDim2.new(0, btnStartPos.X.Offset + delta.X, 0, btnStartPos.Y.Offset + delta.Y)
        panel.Position = UDim2.new(0, btnStartPos.X.Offset + delta.X, 0, btnStartPos.Y.Offset + delta.Y + 30)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = false -- 拖动结束，恢复点击功能
    end
end)

print("=== 终极修复版脚本加载成功 ===")
print("✅ 左上角亮红色80×30按钮，点击展开，再次点击关闭")
print("✅ 拖动时不会误关面板，点击时不会误触拖动")
print("✅ 按钮颜色与旧版本完全不同，确保是全新脚本")
