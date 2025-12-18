-- 核心服务（仅保留必要，无冗余依赖）
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10)

-- 暴力清理旧UI（杜绝残留冲突）
if PlayerGui:FindFirstChild("CompactCylinderWindow") then
    PlayerGui.CompactCylinderWindow:Destroy()
end

-- 全局变量（极简状态，避免冲突）
local autofarm, autoCollectingCubes, autoClaimRewards, farmMoving, showMap, autoeat
local autoUpgradeSize, autoUpgradeSpd, autoUpgradeMulti, autoUpgradeEat
local keepUnanchor, boundProtect
local mainColor = Color3.fromRGB(139, 101, 64)
local isExpanded = false -- 仅一个状态标记

-- 主GUI（超置顶，无遮挡）
local gui = Instance.new("ScreenGui")
gui.Name = "CompactCylinderWindow"
gui.DisplayOrder = 999999
gui.IgnoreGuiInset = true
gui.Parent = PlayerGui

-- ======================== 触发标题（160×40，紧凑尺寸）========================
local titleOval = Instance.new("TextButton")
titleOval.Name = "TitleOval"
titleOval.Size = UDim2.new(0, 160, 0, 40) -- 压缩标题尺寸
titleOval.Position = UDim2.new(0.2, 0, 0.1, 0)
titleOval.BackgroundColor3 = mainColor
titleOval.Text = "小拽吃吃世界"
titleOval.TextColor3 = Color3.new(1,1,1)
titleOval.Font = Enum.Font.SourceSansBold
titleOval.TextSize = 14 -- 小号文字适配
titleOval.ZIndex = 100
titleOval.Active = true -- 强制启用交互
titleOval.Selectable = true -- 移动端必开
titleOval.AutoButtonColor = false -- 避免触摸反馈干扰
titleOval.Parent = gui
-- 标题圆角（与圆柱顶部对齐）
local titleCorner = Instance.new("UICorner", titleOval)
titleCorner.CornerRadius = UDim.new(0.5, 0)

-- ======================== 紧凑圆柱面板（160宽，高度刚好装下功能）========================
local cylinderPanel = Instance.new("Frame")
cylinderPanel.Name = "CylinderPanel"
cylinderPanel.Size = UDim2.new(0, 160, 0, 0) -- 初始高度0
cylinderPanel.Position = UDim2.new(0.2, 0, 0.1, 40) -- 标题正下方，无缝衔接
cylinderPanel.BackgroundColor3 = mainColor
cylinderPanel.ZIndex = 100
cylinderPanel.ClipsDescendants = true -- 裁剪多余内容
cylinderPanel.Parent = gui
-- 圆柱圆角（初始顶部半圆，底部直角）
local cylinderCorner = Instance.new("UICorner", cylinderPanel)
cylinderCorner.CornerRadius = UDim.new(0.5, 0, 0, 0)

-- 内容容器（压缩内边距）
local contentContainer = Instance.new("Frame", cylinderPanel)
contentContainer.Size = UDim2.new(1, -8, 1, -8)
contentContainer.Position = UDim2.new(0, 4, 0, 4)
contentContainer.BackgroundTransparency = 1
contentContainer.ZIndex = 101

-- 内容布局（压缩间距）
local contentLayout = Instance.new("UIListLayout", contentContainer)
contentLayout.Padding = UDim.new(0, 3) -- 缩小间距
contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
contentLayout.VerticalAlignment = Enum.VerticalAlignment.Top

-- ======================== 精简功能元素（压缩尺寸，保留全功能+原排序）========================
-- 分类标题（压缩高度）
local function createCategoryTitle(text, color)
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0, 140, 0, 16) -- 压缩分类标题高度
    title.BackgroundTransparency = 1
    title.Text = text
    title.TextColor3 = color
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 11 -- 超小字体
    title.TextXAlignment = Enum.TextXAlignment.Center
    title.ZIndex = 101
    title.Parent = contentContainer
    return title
end

-- 功能按钮（压缩尺寸：140×22，紧凑无冗余）
local function createFuncButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 140, 0, 22) -- 极致紧凑按钮
    btn.BackgroundColor3 = mainColor:lerp(Color3.fromRGB(0,0,0), 0.4)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 10 -- 超小字体适配
    btn.ZIndex = 101
    btn.Active = true
    btn.Selectable = true
    btn.AutoButtonColor = false
    btn.Parent = contentContainer
    -- 按钮圆角
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0.2, 0)

    -- 点击逻辑（无多余状态，直接切换）
    local isEnabled = false
    btn.MouseButton1Click:Connect(function()
        isEnabled = not isEnabled
        btn.BackgroundColor3 = isEnabled and Color3.fromRGB(40, 200, 100) or mainColor:lerp(Color3.fromRGB(0,0,0), 0.4)
        pcall(callback, isEnabled)
    end)
    return btn
end

-- 1. 自动功能分类（原排序，压缩布局）
createCategoryTitle("自动功能", Color3.fromRGB(255, 165, 0))
createFuncButton("自动刷", function(enabled)
    autofarm = enabled
    if not enabled then return end
    coroutine.wrap(function()
        local text = Drawing.new("Text")
        text.Outline = true
        text.OutlineColor3 = Color3.new(0,0,0)
        text.Color3 = Color3.new(1,1,1)
        text.Position = Vector2.new(64, 64)
        text.Size = 12
        text.Visible = true

        local bedrock = Instance.new("Part")
        bedrock.Anchored = true
        bedrock.Size = Vector3.new(2048, 10, 2048)
        bedrock.Position = Vector3.new(0, -5, 0)
        bedrock.Parent = workspace

        local Events = ReplicatedStorage:FindFirstChild("Events") or ReplicatedStorage:WaitForChild("Events", 3)
        local SetServerSettings = Events and Events:FindFirstChild("SetServerSettings")

        local function onCharAdd(char)
            local hum = char:WaitForChild("Humanoid")
            local root = char:WaitForChild("HumanoidRootPart")
            local size = char:WaitForChild("Size")
            local events = char:WaitForChild("Events")
            if not hum or not root or not size or not events then return end

            local eat = events:WaitForChild("Eat")
            local grab = events:WaitForChild("Grab")
            local sell = events:WaitForChild("Sell")
            if not eat or not grab or not sell then return end

            local autoConn = RunService.Heartbeat:Connect(function()
                if not autofarm then autoConn:Disconnect() return end
                pcall(function()
                    hum:ChangeState(Enum.HumanoidStateType.Physics)
                    grab:FireServer()
                    root.Anchored = false
                    eat:FireServer()
                    if size.Value >= (LocalPlayer.Upgrades and LocalPlayer.Upgrades.MaxSize.Value or 100) then
                        sell:FireServer()
                        SetServerSettings and SetServerSettings:FireServer({MapTime=-1,Paused=true})
                    end
                end)
            end)

            hum.Died:Connect(function() autoConn and autoConn:Disconnect() end)
        end

        LocalPlayer.Character and onCharAdd(LocalPlayer.Character)
        LocalPlayer.CharacterAdded:Connect(onCharAdd)
        while autofarm do task.wait() end
        pcall(function() bedrock:Destroy() text:Destroy() end)
    end)()
end)
createFuncButton("自动收", function(enabled)
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
createFuncButton("自动领", function(enabled)
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
            for _, reward in TimedRewards:GetChildren() do
                reward.Value > 0 and RewardEvent:FireServer(reward)
            end
            SpinEvent:FireServer()
        end
    end)()
end)
createFuncButton("移动模式", function(enabled) farmMoving = enabled end)
createFuncButton("显示地图", function(enabled)
    showMap = enabled
    local map, chunks = workspace:FindFirstChild("Map"), workspace:FindFirstChild("Chunks")
    if map and chunks then
        map.Parent, chunks.Parent = showMap and workspace or nil, showMap and workspace or nil
    end
end)
createFuncButton("自动吃", function(enabled)
    autoeat = enabled
    if not enabled then return end
    coroutine.wrap(function()
        while autoeat do
            task.wait()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Events") then
                local events = char.Events
                local grab = events:FindFirstChild("Grab")
                local eat = events:FindFirstChild("Eat")
                grab and grab:FireServer()
                eat and eat:FireServer()
            end
        end
    end)()
end)

-- 2. 升级功能分类（原排序）
createCategoryTitle("升级功能", Color3.fromRGB(0, 255, 0))
createFuncButton("自动升级大小", function(enabled)
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
createFuncButton("自动升级移速", function(enabled)
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
createFuncButton("自动升级乘数", function(enabled)
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
createFuncButton("自动升级吃速", function(enabled)
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

-- 3. 人物功能分类（原排序）
createCategoryTitle("人物功能", Color3.fromRGB(0, 255, 127))
createFuncButton("取消锚固", function(enabled)
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
createFuncButton("边界保护", function(enabled)
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
                    local clampedPos = Vector3.new(
                        math.clamp(root.Position.X, -mapSize.X/2, mapSize.X/2),
                        root.Position.Y,
                        math.clamp(root.Position.Z, -mapSize.Z/2, mapSize.Z/2)
                    )
                    root.CFrame = CFrame.new(clampedPos) * root.CFrame.Rotation
                end
            end
        end
    end)()
end)

-- 4. 其它功能分类（原排序）
createCategoryTitle("其它功能", Color3.fromRGB(100, 149, 237))
createFuncButton("查看玩家数据", function()
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
                local lv = u.Value
                print(string.format("%s：%i级 | 数值：%s", loc[u.Name] or u.Name, lv, growth[u.Name](lv)))
            end
        end
    end
    game.StarterGui:SetCore("DevConsoleVisible", true)
end)
createFuncButton("竖屏模式", function(enabled)
    LocalPlayer.PlayerGui.ScreenOrientation = enabled and Enum.ScreenOrientation.Portrait or Enum.ScreenOrientation.LandscapeRight
end)

-- ======================== 核心修复：点击必开+紧凑圆柱衍生 =======================
-- 计算精确圆柱高度（刚好装下所有功能，无多余）
local function getExactCylinderHeight()
    local totalH = 0
    for _, child in contentContainer:GetChildren() do
        totalH += child.AbsoluteSize.Y + contentLayout.Padding.Offset
    end
    return totalH + 16 -- 仅加必要内边距
end
local exactHeight = getExactCylinderHeight()

-- 简化展开/收起逻辑（无动画冲突）
local function toggleCylinder()
    isExpanded = not isExpanded
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Linear) -- 简化动画

    if isExpanded then
        -- 向下衍生：直接到精确高度
        TweenService:Create(cylinderPanel, tweenInfo, {
            Size = UDim2.new(0, 160, 0, exactHeight)
        }):Play()
        task.delay(0.05, function()
            cylinderCorner.CornerRadius = UDim.new(0.5, 0) -- 完整圆柱
        end)
    else
        -- 向上收起：高度归0
        cylinderCorner.CornerRadius = UDim.new(0.5, 0, 0, 0)
        TweenService:Create(cylinderPanel, tweenInfo, {
            Size = UDim2.new(0, 160, 0, 0)
        }):Play()
    end
end

-- 双重绑定点击事件（确保触发）
titleOval.MouseButton1Click:Connect(toggleCylinder)
titleOval.TouchTap:Connect(toggleCylinder)

-- 额外冗余绑定（防止移动端识别失败）
titleOval.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        toggleCylinder()
    end
end)

-- ======================== 拖动功能（同步移动，无错位）========================
local dragTarget = nil
local startPos = Vector2.new(0, 0)
local titleStart = titleOval.Position
local cylinderStart = cylinderPanel.Position

UserInputService.TouchStarted:Connect(function(input)
    if input.UserInputType ~= Enum.UserInputType.Touch then return end
    local touchPos = input.Position

    local function isOnElem(elem)
        local absP = elem.AbsolutePosition
        local absS = elem.AbsoluteSize
        return touchPos.X >= absP.X and touchPos.X <= absP.X+absS.X and touchPos.Y >= absP.Y and touchPos.Y <= absP.Y+absS.Y
    end

    dragTarget = isOnElem(titleOval) and "title" or isOnElem(cylinderPanel) and "cylinder" or nil
    if dragTarget then
        startPos = touchPos
        titleStart = titleOval.Position
        cylinderStart = cylinderPanel.Position
    end
end)

UserInputService.TouchMoved:Connect(function(input)
    if not dragTarget or input.UserInputType ~= Enum.UserInputType.Touch then return end
    local delta = input.Position - startPos

    if dragTarget == "title" then
        titleOval.Position = UDim2.new(0, titleStart.X.Offset+delta.X, 0, titleStart.Y.Offset+delta.Y)
        cylinderPanel.Position = UDim2.new(0, titleStart.X.Offset+delta.X, 0, titleStart.Y.Offset+delta.Y+40)
    elseif dragTarget == "cylinder" then
        cylinderPanel.Position = UDim2.new(0, cylinderStart.X.Offset+delta.X, 0, cylinderStart.Y.Offset+delta.Y)
        titleOval.Position = UDim2.new(0, cylinderStart.X.Offset+delta.X, 0, cylinderStart.Y.Offset+delta.Y-40)
    end
end)

UserInputService.TouchEnded:Connect(function(input)
    input.UserInputType == Enum.UserInputType.Touch and (dragTarget = nil)
end)

-- ======================== 初始化（确保状态正确）========================
cylinderPanel.Size = UDim2.new(0, 160, 0, 0)
cylinderCorner.CornerRadius = UDim.new(0.5, 0, 0, 0)
-- 强制激活所有按钮
for _, btn in contentContainer:GetDescendants() do
    if btn:IsA("TextButton") then
        btn.Active = true
        btn.Selectable = true
    end
end
