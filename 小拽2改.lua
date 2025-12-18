-- 仅保留必需服务
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")

-- 暴力清理旧UI
pcall(function() PlayerGui:FindFirstChild("FinalWindow"):Destroy() end)

-- 全局变量（仅功能开关，无多余状态）
local autofarm, autoCollectingCubes, autoClaimRewards, farmMoving, showMap, autoeat
local autoUpgradeSize, autoUpgradeSpd, autoUpgradeMulti, autoUpgradeEat
local keepUnanchor, boundProtect
local isOpen = false

-- 主GUI（极简配置）
local gui = Instance.new("ScreenGui")
gui.Name = "FinalWindow"
gui.DisplayOrder = 999999
gui.IgnoreGuiInset = true
gui.Parent = PlayerGui

-- ======================== 触发按钮（150×35，最小可点）========================
local trigger = Instance.new("TextButton")
trigger.Name = "Trigger"
trigger.Size = UDim2.new(0, 150, 0, 35)
trigger.Position = UDim2.new(0.2, 0, 0.1, 0)
trigger.BackgroundColor3 = Color3.fromRGB(139, 101, 64)
trigger.Text = "小拽吃吃世界"
trigger.TextColor3 = Color3.new(1,1,1)
trigger.Font = Enum.Font.SourceSansBold
trigger.TextSize = 14
trigger.ZIndex = 10
trigger.AutoButtonColor = false
trigger.Parent = gui
Instance.new("UICorner", trigger).CornerRadius = UDim.new(0.5, 0)

-- ======================== 功能面板（150宽，刚好装下功能）========================
local panel = Instance.new("Frame")
panel.Name = "Panel"
panel.Size = UDim2.new(0, 150, 0, 0)
panel.Position = UDim2.new(0.2, 0, 0.1, 35)
panel.BackgroundColor3 = Color3.fromRGB(139, 101, 64)
panel.ZIndex = 10
panel.Visible = true
panel.Parent = gui
Instance.new("UICorner", panel).CornerRadius = UDim.new(0.5, 0)

-- 内容容器
local content = Instance.new("Frame", panel)
content.Size = UDim2.new(1, -6, 1, -6)
content.Position = UDim2.new(0, 3, 0, 3)
content.BackgroundTransparency = 1

-- 布局
local layout = Instance.new("UIListLayout", content)
layout.Padding = UDim.new(0, 3)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- ======================== 功能按钮（极简创建）========================
local function createBtn(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 135, 0, 20)
    btn.BackgroundColor3 = Color3.fromRGB(70, 50, 30)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 10
    btn.AutoButtonColor = false
    btn.Parent = content
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0.2, 0)

    local isOn = false
    btn.MouseButton1Click:Connect(function()
        isOn = not isOn
        btn.BackgroundColor3 = isOn and Color3.fromRGB(40, 200, 100) or Color3.fromRGB(70, 50, 30)
        pcall(callback, isOn)
    end)
    return btn
end

-- 快速创建所有功能（原排序，无多余逻辑）
-- 自动功能
createBtn("自动刷", function(enabled)
    autofarm = enabled
    if not enabled then return end
    coroutine.wrap(function()
        local bedrock = Instance.new("Part")
        bedrock.Anchored = true
        bedrock.Size = Vector3.new(2048,10,2048)
        bedrock.Position = Vector3.new(0,-5,0)
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
                        SetServerSettings and SetServerSettings:FireServer({MapTime=-1,Paused=true})
                    end
                end)
            end)
            hum.Died:Connect(function() conn:Disconnect() end)
        end

        LocalPlayer.Character and onChar(LocalPlayer.Character)
        LocalPlayer.CharacterAdded:Connect(onChar)
        while autofarm do task.wait() end
        bedrock:Destroy()
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
            for _, r in TimedRewards:GetChildren() do r.Value > 0 and RewardEvent:FireServer(r) end
            SpinEvent:FireServer()
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
                events:FindFirstChild("Grab") and events.Grab:FireServer()
                events:FindFirstChild("Eat") and events.Eat:FireServer()
            end
        end
    end)()
end)

-- 升级功能
createBtn("升级大小", function(enabled)
    autoUpgradeSize = enabled
    if not enabled then return end
    coroutine.wrap(function()
        local Events = ReplicatedStorage:FindFirstChild("Events")
        local PurchaseEvent = Events and Events:FindFirstChild("PurchaseEvent")
        if not PurchaseEvent then return end
        game.CoreGui.PurchasePromptApp.Enabled = false
        while autoUpgradeSize do task.wait(1) PurchaseEvent:FireServer("MaxSize") end
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
        while autoUpgradeSpd do task.wait(1) PurchaseEvent:FireServer("Speed") end
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
        while autoUpgradeMulti do task.wait(1) PurchaseEvent:FireServer("Multiplier") end
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
        while autoUpgradeEat do task.wait(1) PurchaseEvent:FireServer("EatSpeed") end
        game.CoreGui.PurchasePromptApp.Enabled = true
    end)()
end)

-- 人物功能
createBtn("取消锚固", function(enabled)
    keepUnanchor = enabled
    if not enabled then return end
    coroutine.wrap(function()
        while keepUnanchor do
            task.wait()
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            root and (root.Anchored = false)
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
                    local mapSize = bedrock.Size * Vector3.new(1,0,1)
                    local clamped = Vector3.new(
                        math.clamp(root.Position.X, -mapSize.X/2, mapSize.X/2),
                        root.Position.Y,
                        math.clamp(root.Position.Z, -mapSize.Z/2, mapSize.Z/2)
                    )
                    root.CFrame = CFrame.new(clamped) * root.CFrame.Rotation
                end
            end
        end
    end)()
end)

-- 其它功能
createBtn("玩家数据", function()
    local loc = {MaxSize="体积", Speed="移速", Multiplier="乘数", EatSpeed="吃速"}
    local growth = {
        MaxSize = function(lv) return math.floor(((lv+0.5)^2-0.25)/2*100) end,
        Speed = function(lv) return math.floor(lv*2+10) end,
        Multiplier = function(lv) return math.floor(lv) end,
        EatSpeed = function(lv) return math.floor((1+(lv-1)*0.2)*10)/10 end
    }
    for _, p in Players:GetPlayers() do
        print("\n["..p.Name.."]")
        local upg = p:FindFirstChild("Upgrades")
        if upg then
            for _, u in upg:GetChildren() do
                print(string.format("%s：%i级 | %s", loc[u.Name] or u.Name, u.Value, growth[u.Name](u.Value)))
            end
        end
    end
    game.StarterGui:SetCore("DevConsoleVisible", true)
end)

createBtn("竖屏模式", function(enabled)
    LocalPlayer.PlayerGui.ScreenOrientation = enabled and Enum.ScreenOrientation.Portrait or Enum.ScreenOrientation.LandscapeRight
end)

-- ======================== 点击展开/收起（无动画，瞬时响应）========================
local function togglePanel()
    isOpen = not isOpen
    if isOpen then
        -- 计算精确高度，刚好装下所有按钮
        local totalH = 0
        for _, btn in content:GetChildren() do
            totalH += btn.AbsoluteSize.Y + layout.Padding.Offset
        end
        panel.Size = UDim2.new(0, 150, 0, totalH + 12)
        trigger.Visible = false
    else
        panel.Size = UDim2.new(0, 150, 0, 0)
        trigger.Visible = true
    end
end

-- 绑定点击（仅保留最直接的触发）
trigger.MouseButton1Click:Connect(togglePanel)
trigger.TouchTap:Connect(togglePanel)

-- ======================== 拖动功能（极简逻辑）========================
local dragTarget = nil
local startX, startY, elemX, elemY

UserInputService.TouchStarted:Connect(function(input)
    local x, y = input.Position.X, input.Position.Y
    if x > trigger.AbsolutePosition.X and x < trigger.AbsolutePosition.X+trigger.AbsoluteSize.X and y > trigger.AbsolutePosition.Y and y < trigger.AbsolutePosition.Y+trigger.AbsoluteSize.Y then
        dragTarget = trigger
    elseif x > panel.AbsolutePosition.X and x < panel.AbsolutePosition.X+panel.AbsoluteSize.X and y > panel.AbsolutePosition.Y and y < panel.AbsolutePosition.Y+panel.AbsoluteSize.Y then
        dragTarget = panel
    end
    if dragTarget then
        startX, startY = x, y
        elemX = dragTarget.Position.X.Offset
        elemY = dragTarget.Position.Y.Offset
    end
end)

UserInputService.TouchMoved:Connect(function(input)
    if dragTarget then
        local x, y = input.Position.X, input.Position.Y
        local dx = x - startX
        local dy = y - startY
        dragTarget.Position = UDim2.new(0, elemX+dx, 0, elemY+dy)
        if dragTarget == trigger then
            panel.Position = UDim2.new(0, elemX+dx, 0, elemY+dy+35)
        else
            trigger.Position = UDim2.new(0, elemX+dx, 0, elemY+dy-35)
        end
    end
end)

UserInputService.TouchEnded:Connect(function() dragTarget = nil end)

-- 强制显示触发按钮
trigger.Visible = true
