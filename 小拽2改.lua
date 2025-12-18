-- 稳定核心服务（沿用测试脚本框架）
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")

-- 清理旧UI（容错）
pcall(function() PlayerGui:FindFirstChild("FinalFunctionalWindow"):Destroy() end)

-- 全局变量（功能开关+状态）
local autofarm, autoCollectingCubes, autoClaimRewards, farmMoving, showMap, autoeat
local autoUpgradeSize, autoUpgradeSpd, autoUpgradeMulti, autoUpgradeEat
local keepUnanchor, boundProtect
local isOpen = false
local mainColor = Color3.fromRGB(139, 101, 64)

-- 主GUI（稳定配置）
local gui = Instance.new("ScreenGui")
gui.Name = "FinalFunctionalWindow"
gui.DisplayOrder = 999999
gui.IgnoreGuiInset = true
gui.Parent = PlayerGui

-- ======================== 触发标题（150×35，紧凑尺寸）========================
local trigger = Instance.new("TextButton")
trigger.Name = "Trigger"
trigger.Size = UDim2.new(0, 150, 0, 35)
trigger.Position = UDim2.new(0.2, 0, 0.1, 0)
trigger.BackgroundColor3 = mainColor
trigger.Text = "小拽吃吃世界"
trigger.TextColor3 = Color3.new(1, 1, 1)
trigger.Font = Enum.Font.SourceSansBold
trigger.TextSize = 14
trigger.ZIndex = 10
trigger.Parent = gui
Instance.new("UICorner", trigger).CornerRadius = UDim.new(0.5, 0)

-- ======================== 圆柱功能面板（150宽，刚好装下所有功能）========================
local cylinderPanel = Instance.new("Frame")
cylinderPanel.Name = "CylinderPanel"
cylinderPanel.Size = UDim2.new(0, 150, 0, 0) -- 初始高度0
cylinderPanel.Position = UDim2.new(0.2, 0, 0.1, 35) -- 标题正下方
cylinderPanel.BackgroundColor3 = mainColor
cylinderPanel.ZIndex = 10
cylinderPanel.ClipsDescendants = true
cylinderPanel.Parent = gui
Instance.new("UICorner", cylinderPanel).CornerRadius = UDim.new(0.5, 0)

-- 内容容器（紧凑内边距）
local content = Instance.new("Frame", cylinderPanel)
content.Size = UDim2.new(1, -6, 1, -6)
content.Position = UDim2.new(0, 3, 0, 3)
content.BackgroundTransparency = 1

-- 布局（紧凑间距）
local layout = Instance.new("UIListLayout", content)
layout.Padding = UDim.new(0, 3)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- ======================== 功能按钮创建（稳定逻辑）========================
local function createBtn(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 135, 0, 20) -- 紧凑尺寸
    btn.BackgroundColor3 = Color3.fromRGB(70, 50, 30) -- 深色按钮
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 10
    btn.ZIndex = 11
    btn.Parent = content
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0.2, 0)

    -- 稳定点击逻辑（带状态反馈）
    local isOn = false
    btn.MouseButton1Click:Connect(function()
        isOn = not isOn
        btn.BackgroundColor3 = isOn and Color3.fromRGB(40, 200, 100) or Color3.fromRGB(70, 50, 30)
        pcall(callback, isOn) -- 容错，避免功能报错影响UI
    end)
    return btn
end

-- ======================== 全功能恢复（原排序，稳定执行）========================
-- 1. 自动功能（原排序）
createBtn("自动刷", function(enabled)
    autofarm = enabled
    if not enabled then return end
    coroutine.wrap(function()
        local bedrock = Instance.new("Part")
        bedrock.Anchored = true
        bedrock.Size = Vector3.new(2048, 10, 2048)
        bedrock.Position = Vector3.new(0, -5, 0)
        bedrock.Parent = workspace

        local Events = ReplicatedStorage:FindFirstChild("Events")
        local SetServerSettings = Events and Events:FindFirstChild("SetServerSettings")

        local function onChar(char)
            local hum = char:FindFirstChild("Humanoid")
            local root = char:FindFirstChild("HumanoidRootPart")
            local size = char:FindFirstChild("Size")
            local events = char:FindFirstChild("Events")
            if not hum or not root or not size or not events then return end

            local eat = events:FindFirstChild("Eat")
            local grab = events:FindFirstChild("Grab")
            local sell = events:FindFirstChild("Sell")
            if not eat or not grab or not sell then return end

            local conn = RunService.Heartbeat:Connect(function()
                if not autofarm then conn:Disconnect() return end
                pcall(function()
                    hum:ChangeState(Enum.HumanoidStateType.Physics)
                    grab:FireServer()
                    root.Anchored = false
                    eat:FireServer()
                    local maxSize = LocalPlayer.Upgrades and LocalPlayer.Upgrades.MaxSize.Value or 100
                    if size.Value >= maxSize then
                        sell:FireServer()
                        SetServerSettings and SetServerSettings:FireServer({MapTime = -1, Paused = true})
                    end
                end)
            end)

            hum.Died:Connect(function() conn:Disconnect() end)
        end

        LocalPlayer.Character and onChar(LocalPlayer.Character)
        LocalPlayer.CharacterAdded:Connect(onChar)
        while autofarm do task.wait() end
        pcall(function() bedrock:Destroy() end)
    end)()
end)

createBtn("自动收", function(enabled)
    autoCollectingCubes = enabled
    if not enabled then return end
    coroutine.wrap(function()
        while autoCollectingCubes do
            task.wait()
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                for _, v in workspace:GetChildren() do
                    if v.Name == "Cube" and v:FindFirstChild("Owner") then
                        local owner = v.Owner.Value
                        (owner == LocalPlayer.Name or owner == "") and pcall(function() v.CFrame = root.CFrame end)
                    end
                end
            end
        end
    end)()
end)

createBtn("自动领", function(enabled)
    autoClaimRewards = enabled
    if not enabled then return end
    coroutine.wrap(function()
        local Events = ReplicatedStorage:FindFirstChild("Events")
        local RewardEvent = Events and Events:FindFirstChild("RewardEvent")
        local SpinEvent = Events and Events:FindFirstChild("SpinEvent")
        local TimedRewards = LocalPlayer:FindFirstChild("TimedRewards")
        if not RewardEvent or not SpinEvent or not TimedRewards then return end

        while autoClaimRewards do
            task.wait(1)
            for _, r in TimedRewards:GetChildren() do
                r.Value > 0 and pcall(function() RewardEvent:FireServer(r) end)
            end
            pcall(function() SpinEvent:FireServer() end)
        end
    end)()
end)

createBtn("移动模式", function(enabled) farmMoving = enabled end)

createBtn("显示地图", function(enabled)
    showMap = enabled
    local map, chunks = workspace:FindFirstChild("Map"), workspace:FindFirstChild("Chunks")
    if map and chunks then
        map.Parent, chunks.Parent = showMap and workspace or nil, showMap and workspace or nil
    end
end)

createBtn("自动吃", function(enabled)
    autoeat = enabled
    if not enabled then return end
    coroutine.wrap(function()
        while autoeat do
            task.wait()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Events") then
                local events = char.Events
                events:FindFirstChild("Grab") and pcall(function() events.Grab:FireServer() end)
                events:FindFirstChild("Eat") and pcall(function() events.Eat:FireServer() end)
            end
        end
    end)()
end)

-- 2. 升级功能（原排序）
createBtn("升级大小", function(enabled)
    autoUpgradeSize = enabled
    if not enabled then return end
    coroutine.wrap(function()
        local Events = ReplicatedStorage:FindFirstChild("Events")
        local PurchaseEvent = Events and Events:FindFirstChild("PurchaseEvent")
        if not PurchaseEvent then return end

        game.CoreGui.PurchasePromptApp.Enabled = false
        while autoUpgradeSize do
            task.wait(1)
            pcall(function() PurchaseEvent:FireServer("MaxSize") end)
        end
        game.CoreGui.PurchasePromptApp.Enabled = true
    end)()
end)

createBtn("升级移速", function(enabled)
    autoUpgradeSpd = enabled
    if not enabled then return end
    coroutine.wrap(function()
        local Events = ReplicatedStorage:FindFirstChild("Events")
        local PurchaseEvent = Events and Events:FindFirstChild("PurchaseEvent")
        if not PurchaseEvent then return end

        game.CoreGui.PurchasePromptApp.Enabled = false
        while autoUpgradeSpd do
            task.wait(1)
            pcall(function() PurchaseEvent:FireServer("Speed") end)
        end
        game.CoreGui.PurchasePromptApp.Enabled = true
    end)()
end)

createBtn("升级乘数", function(enabled)
    autoUpgradeMulti = enabled
    if not enabled then return end
    coroutine.wrap(function()
        local Events = ReplicatedStorage:FindFirstChild("Events")
        local PurchaseEvent = Events and Events:FindFirstChild("PurchaseEvent")
        if not PurchaseEvent then return end

        game.CoreGui.PurchasePromptApp.Enabled = false
        while autoUpgradeMulti do
            task.wait(1)
            pcall(function() PurchaseEvent:FireServer("Multiplier") end)
        end
        game.CoreGui.PurchasePromptApp.Enabled = true
    end)()
end)

createBtn("升级吃速", function(enabled)
    autoUpgradeEat = enabled
    if not enabled then return end
    coroutine.wrap(function()
        local Events = ReplicatedStorage:FindFirstChild("Events")
        local PurchaseEvent = Events and Events:FindFirstChild("PurchaseEvent")
        if not PurchaseEvent then return end

        game.CoreGui.PurchasePromptApp.Enabled = false
        while autoUpgradeEat do
            task.wait(1)
            pcall(function() PurchaseEvent:FireServer("EatSpeed") end)
        end
        game.CoreGui.PurchasePromptApp.Enabled = true
    end)()
end)

-- 3. 人物功能（原排序）
createBtn("取消锚固", function(enabled)
    keepUnanchor = enabled
    if not enabled then return end
    coroutine.wrap(function()
        while keepUnanchor do
            task.wait()
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            root and pcall(function() root.Anchored = false end)
        end
    end)()
end)

createBtn("边界保护", function(enabled)
    boundProtect = enabled
    if not enabled then return end
    coroutine.wrap(function()
        while boundProtect do
            task.wait()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local root = char.HumanoidRootPart
                local map = workspace:FindFirstChild("Map")
                if map and map:FindFirstChild("Bedrock") then
                    local bedrock = map.Bedrock
                    local mapSize = bedrock.Size * Vector3.new(1, 0, 1)
                    local clamped = Vector3.new(
                        math.clamp(root.Position.X, -mapSize.X/2, mapSize.X/2),
                        root.Position.Y,
                        math.clamp(root.Position.Z, -mapSize.Z/2, mapSize.Z/2)
                    )
                    pcall(function() root.CFrame = CFrame.new(clamped) * root.CFrame.Rotation end)
                end
            end
        end
    end)()
end)

-- 4. 其它功能（原排序）
createBtn("玩家数据", function()
    local loc = {MaxSize = "体积", Speed = "移速", Multiplier = "乘数", EatSpeed = "吃速"}
    local growth = {
        MaxSize = function(lv) return math.floor(((lv+0.5)^2 - 0.25)/2 * 100) end,
        Speed = function(lv) return math.floor(lv*2 + 10) end,
        Multiplier = function(lv) return math.floor(lv) end,
        EatSpeed = function(lv) return math.floor((1+(lv-1)*0.2)*10)/10 end
    }
    for _, p in Players:GetPlayers() do
        print("\n["..p.Name.."]")
        local upg = p:FindFirstChild("Upgrades")
        if upg then
            for _, u in upg:GetChildren() do
                print(string.format("%s：%i级 | 数值：%s", loc[u.Name] or u.Name, u.Value, growth[u.Name](u.Value)))
            end
        end
    end
    game.StarterGui:SetCore("DevConsoleVisible", true)
end)

createBtn("竖屏模式", function(enabled)
    pcall(function()
        LocalPlayer.PlayerGui.ScreenOrientation = enabled and Enum.ScreenOrientation.Portrait or Enum.ScreenOrientation.LandscapeRight
    end)
end)

-- ======================== 稳定点击展开/收起（无动画冲突）========================
local function togglePanel()
    isOpen = not isOpen
    if isOpen then
        -- 计算精确高度，刚好装下所有按钮
        local totalH = 0
        for _, btn in content:GetChildren() do
            totalH += btn.AbsoluteSize.Y + layout.Padding.Offset
        end
        cylinderPanel.Size = UDim2.new(0, 150, 0, totalH + 12) -- 加必要内边距
    else
        cylinderPanel.Size = UDim2.new(0, 150, 0, 0)
    end
end

-- 稳定绑定点击事件（沿用测试脚本逻辑）
trigger.MouseButton1Click:Connect(togglePanel)
trigger.TouchTap:Connect(togglePanel)

-- ======================== 稳定拖动功能（沿用测试脚本逻辑）========================
local isDragging = false
local startPos = Vector2.new(0, 0)
local triggerStartPos = trigger.Position
local panelStartPos = cylinderPanel.Position

trigger.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        startPos = input.Position
        triggerStartPos = trigger.Position
        panelStartPos = cylinderPanel.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - startPos
        -- 更新触发按钮位置
        trigger.Position = UDim2.new(
            0, triggerStartPos.X.Offset + delta.X,
            0, triggerStartPos.Y.Offset + delta.Y
        )
        -- 同步圆柱面板位置
        cylinderPanel.Position = UDim2.new(
            0, triggerStartPos.X.Offset + delta.X,
            0, triggerStartPos.Y.Offset + delta.Y + 35
        )
        startPos = input.Position
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        isDragging = false
    end
end)

-- 强制显示触发按钮
trigger.Visible = true
print("=== 全功能脚本加载完成 ===")
print("左上角'小拽吃吃世界'按钮，点击展开圆柱功能面板")
print("所有功能按钮点击即生效，绿色=启用，深色=禁用")
