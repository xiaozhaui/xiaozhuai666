-- 核心服务（保留完整功能依赖）
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10)

-- 清理旧UI（彻底避免冲突）
if PlayerGui:FindFirstChild("MobileFloatingWindow") then
    PlayerGui.MobileFloatingWindow:Destroy()
end

-- 全局变量（恢复所有功能开关）
local autofarm, autoCollectingCubes, autoClaimRewards, farmMoving, showMap, autoeat
local autoUpgradeSize, autoUpgradeSpd, autoUpgradeMulti, autoUpgradeEat
local keepUnanchor, boundProtect
local mainColor = Color3.fromRGB(139, 101, 64)
local isExpanded = false -- 控制圆柱展开/收起

-- 主GUI（置顶无遮挡）
local gui = Instance.new("ScreenGui")
gui.Name = "MobileFloatingWindow"
gui.ResetOnSpawn = false
gui.DisplayOrder = 99999
gui.IgnoreGuiInset = true
gui.Parent = PlayerGui

-- ======================== 触发标题（180×45，圆柱顶部触发点）========================
local titleOval = Instance.new("TextButton")
titleOval.Name = "TitleOval"
titleOval.Size = UDim2.new(0, 180, 0, 45)
titleOval.Position = UDim2.new(0.2, 0, 0.1, 0)
titleOval.BackgroundColor3 = mainColor
titleOval.Text = "小拽吃吃世界"
titleOval.TextColor3 = Color3.new(1,1,1)
titleOval.Font = Enum.Font.SourceSansBold
titleOval.TextSize = 16
titleOval.ZIndex = 100
titleOval.Active = true
titleOval.Selectable = true
titleOval.AutoButtonColor = false
titleOval.Parent = gui
-- 标题圆角（与圆柱顶部对齐）
local titleCorner = Instance.new("UICorner", titleOval)
titleCorner.CornerRadius = UDim.new(0.5, 0)

-- ======================== 圆柱形状功能面板（向下衍生，刚好装下所有功能）========================
local cylinderPanel = Instance.new("Frame")
cylinderPanel.Name = "CylinderPanel"
cylinderPanel.Size = UDim2.new(0, 180, 0, 0) -- 初始高度0，未展开
cylinderPanel.Position = UDim2.new(0.2, 0, 0.1, 45) -- 标题正下方，无缝衔接
cylinderPanel.BackgroundColor3 = mainColor
cylinderPanel.ZIndex = 100
cylinderPanel.ClipsDescendants = true
cylinderPanel.Parent = gui
-- 圆柱形状关键：顶部圆角=标题圆角，底部圆角=0（展开后底部圆角随高度适配）
local cylinderCorner = Instance.new("UICorner", cylinderPanel)
cylinderCorner.CornerRadius = UDim.new(0.5, 0) -- 初始顶部圆角，与标题对齐

-- 圆柱内容容器（带内边距，避免内容贴边）
local contentContainer = Instance.new("Frame", cylinderPanel)
contentContainer.Size = UDim2.new(1, -10, 1, -10)
contentContainer.Position = UDim2.new(0, 5, 0, 5)
contentContainer.BackgroundTransparency = 1
contentContainer.ZIndex = 101

-- 内容布局（垂直排列，适配圆柱高度）
local contentLayout = Instance.new("UIListLayout", contentContainer)
contentLayout.Padding = UDim.new(0, 5)
contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
contentLayout.VerticalAlignment = Enum.VerticalAlignment.Top

-- ======================== 功能分类标题（还原原排序，颜色区分）========================
local function createCategoryTitle(text, color)
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0, 160, 0, 20)
    title.BackgroundTransparency = 1
    title.Text = "【" .. text .. "】"
    title.TextColor3 = color
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 13
    title.TextXAlignment = Enum.TextXAlignment.Center
    title.ZIndex = 101
    title.Parent = contentContainer
    return title
end

-- ======================== 功能按钮（统一尺寸，原排序排列）========================
local function createFuncButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 160, 0, 28) -- 适配圆柱宽度，按钮无多余空间
    btn.BackgroundColor3 = mainColor:lerp(Color3.fromRGB(0,0,0), 0.4)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 12
    btn.ZIndex = 101
    btn.Active = true
    btn.Selectable = true
    btn.AutoButtonColor = false
    btn.Parent = contentContainer
    -- 按钮圆角（与圆柱风格统一）
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0.2, 0)

    -- 点击状态反馈（绿色=启用，深棕=禁用）
    local isEnabled = false
    btn.MouseButton1Click:Connect(function()
        isEnabled = not isEnabled
        btn.BackgroundColor3 = isEnabled and Color3.fromRGB(40, 200, 100) or mainColor:lerp(Color3.fromRGB(0,0,0), 0.4)
        pcall(callback, isEnabled)
    end)
    return btn
end

-- ======================== 恢复全功能+原排序（自动→升级→人物→其它）========================
-- 1. 自动功能分类（原排序：自动刷→自动收→自动领→移动模式→显示地图→自动吃）
createCategoryTitle("自动功能", Color3.fromRGB(255, 165, 0)) -- 橙色分类标题

-- 自动刷
createFuncButton("自动刷", function(enabled)
    autofarm = enabled
    if not enabled then return end
    coroutine.wrap(function()
        local text = Drawing.new("Text")
        text.Outline = true
        text.OutlineColor3 = Color3.new(0,0,0)
        text.Color3 = Color3.new(1,1,1)
        text.Position = Vector2.new(64, 64)
        text.Size = 14
        text.Visible = true

        local bedrock = Instance.new("Part")
        bedrock.Anchored = true
        bedrock.Size = Vector3.new(2048, 10, 2048)
        bedrock.Position = Vector3.new(0, -5, 0)
        bedrock.BrickColor = BrickColor.Black()
        bedrock.Parent = workspace

        local map, chunks = workspace:FindFirstChild("Map"), workspace:FindFirstChild("Chunks")
        if map and chunks then map.Parent, chunks.Parent = nil, nil end

        local Events = ReplicatedStorage:FindFirstChild("Events") or ReplicatedStorage:WaitForChild("Events", 5)
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
            local chunk = char:WaitForChild("CurrentChunk")
            local sendTrack = char:WaitForChild("SendTrack")
            if not eat or not grab or not sell or not chunk or not sendTrack then return end

            local autoConn = RunService.Heartbeat:Connect(function(dt)
                if not autofarm then autoConn:Disconnect() return end
                pcall(function()
                    hum:ChangeState(Enum.HumanoidStateType.Physics)
                    grab:FireServer()
                    root.Anchored = false
                    eat:FireServer()
                    sendTrack:FireServer()

                    local ran = tick() - text.Visible and tick() or 0
                    local hours = math.floor(ran / 60 / 60)
                    local minutes = math.floor(ran / 60)
                    local seconds = math.floor(ran)
                    text.Text = string.format("运行时间: %ih%im%is\n块数: %i", hours, minutes%60, seconds%60, chunk.Value and 1 or 0)

                    if size.Value >= (LocalPlayer.Upgrades and LocalPlayer.Upgrades.MaxSize.Value or 100) then
                        sell:FireServer()
                        if SetServerSettings then SetServerSettings:FireServer({MapTime=-1,Paused=true}) end
                    end
                end)
            end)

            hum.Died:Connect(function()
                if autoConn then autoConn:Disconnect() end
                if SetServerSettings then SetServerSettings:FireServer({MapTime=-1,Paused=true}) end
            end)
            pcall(function()
                char:FindFirstChild("LocalChunkManager").Enabled = false
                char:FindFirstChild("Animate").Enabled = false
            end)
        end

        if LocalPlayer.Character then task.spawn(onCharAdd, LocalPlayer.Character) end
        LocalPlayer.CharacterAdded:Connect(onCharAdd)

        while autofarm do task.wait() end
        pcall(function()
            if map and chunks then map.Parent, chunks.Parent = workspace, workspace end
            bedrock:Destroy()
            if LocalPlayer.Character then
                LocalPlayer.Character.LocalChunkManager.Enabled = true
                LocalPlayer.Character.Animate.Enabled = true
            end
            text:Destroy()
        end)
    end)()
end)

-- 自动收
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
                        if owner == LocalPlayer.Name or owner == "" then
                            pcall(function() v.CFrame = root.CFrame end)
                        end
                    end
                end
            end
        end
    end)()
end)

-- 自动领
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
                if reward.Value > 0 then RewardEvent:FireServer(reward) end
            end
            SpinEvent:FireServer()
        end
    end)()
end)

-- 移动模式
createFuncButton("移动模式", function(enabled)
    farmMoving = enabled
end)

-- 显示地图
createFuncButton("显示地图", function(enabled)
    showMap = enabled
    local map, chunks = workspace:FindFirstChild("Map"), workspace:FindFirstChild("Chunks")
    if map and chunks then
        map.Parent, chunks.Parent = showMap and workspace or nil, showMap and workspace or nil
    end
end)

-- 自动吃
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
                if grab and eat then
                    grab:FireServer()
                    eat:FireServer()
                end
            end
        end
    end)()
end)

-- 2. 升级功能分类（原排序：大小→移速→乘数→吃速）
createCategoryTitle("升级功能", Color3.fromRGB(0, 255, 0)) -- 绿色分类标题

-- 自动升级大小
createFuncButton("自动升级大小", function(enabled)
    autoUpgradeSize = enabled
    if not enabled then return end
    coroutine.wrap(function()
        local Events = ReplicatedStorage:FindFirstChild("Events")
        local PurchaseEvent = Events and Events:FindFirstChild("PurchaseEvent")
        if not PurchaseEvent then return end

        game.CoreGui.PurchasePromptApp.Enabled = false
        while autoUpgradeSize do
            task.wait(1)
            PurchaseEvent:FireServer("MaxSize")
        end
        game.CoreGui.PurchasePromptApp.Enabled = true
    end)()
end)

-- 自动升级移速
createFuncButton("自动升级移速", function(enabled)
    autoUpgradeSpd = enabled
    if not enabled then return end
    coroutine.wrap(function()
        local Events = ReplicatedStorage:FindFirstChild("Events")
        local PurchaseEvent = Events and Events:FindFirstChild("PurchaseEvent")
        if not PurchaseEvent then return end

        game.CoreGui.PurchasePromptApp.Enabled = false
        while autoUpgradeSpd do
            task.wait(1)
            PurchaseEvent:FireServer("Speed")
        end
        game.CoreGui.PurchasePromptApp.Enabled = true
    end)()
end)

-- 自动升级乘数
createFuncButton("自动升级乘数", function(enabled)
    autoUpgradeMulti = enabled
    if not enabled then return end
    coroutine.wrap(function()
        local Events = ReplicatedStorage:FindFirstChild("Events")
        local PurchaseEvent = Events and Events:FindFirstChild("PurchaseEvent")
        if not PurchaseEvent then return end

        game.CoreGui.PurchasePromptApp.Enabled = false
        while autoUpgradeMulti do
            task.wait(1)
            PurchaseEvent:FireServer("Multiplier")
        end
        game.CoreGui.PurchasePromptApp.Enabled = true
    end)()
end)

-- 自动升级吃速
createFuncButton("自动升级吃速", function(enabled)
    autoUpgradeEat = enabled
    if not enabled then return end
    coroutine.wrap(function()
        local Events = ReplicatedStorage:FindFirstChild("Events")
        local PurchaseEvent = Events and Events:FindFirstChild("PurchaseEvent")
        if not PurchaseEvent then return end

        game.CoreGui.PurchasePromptApp.Enabled = false
        while autoUpgradeEat do
            task.wait(1)
            PurchaseEvent:FireServer("EatSpeed")
        end
        game.CoreGui.PurchasePromptApp.Enabled = true
    end)()
end)

-- 3. 人物功能分类（原排序：取消锚固→边界保护）
createCategoryTitle("人物功能", Color3.fromRGB(0, 255, 127)) -- 亮绿色分类标题

-- 取消锚固
createFuncButton("取消锚固", function(enabled)
    keepUnanchor = enabled
    if not enabled then return end
    coroutine.wrap(function()
        while keepUnanchor do
            task.wait()
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then root.Anchored = false end
        end
    end)()
end)

-- 边界保护
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

-- 4. 其它功能分类（原排序：查看玩家数据→竖屏模式）
createCategoryTitle("其它功能", Color3.fromRGB(100, 149, 237)) -- 蓝色分类标题

-- 查看玩家数据
createFuncButton("查看玩家数据", function()
    local localization = {MaxSize = "体积", Speed = "移速", Multiplier = "乘数", EatSpeed = "吃速"}
    local growthFuncs = {
        MaxSize = function(lv) return math.floor(((lv+0.5)^2 -0.25)/2 *100) end,
        Speed = function(lv) return math.floor(lv*2 +10) end,
        Multiplier = function(lv) return math.floor(lv) end,
        EatSpeed = function(lv) return math.floor((1+(lv-1)*0.2)*10)/10 end
    }
    local priceFuncs = {
        MaxSize = function(lv) return math.floor(lv^3/2)*20 end,
        Speed = function(lv) return math.floor((lv*3)^3/200)*1000 end,
        Multiplier = function(lv) return math.floor((lv*10)^3/200)*1000 end,
        EatSpeed = function(lv) return math.floor((lv*10)^3/200)*2000 end
    }

    for _, player in Players:GetPlayers() do
        print("\n【" .. player.Name .. "】")
        local upgrades = player:FindFirstChild("Upgrades")
        if upgrades then
            for _, upg in upgrades:GetChildren() do
                local lv = upg.Value
                local growth = growthFuncs[upg.Name] and growthFuncs[upg.Name](lv) or 0
                local cost = 0
                for l=2, lv do cost += priceFuncs[upg.Name](l) end
                print(string.format(
                    "%s：%i级 | 数值：%s | 总花费：%i",
                    localization[upg.Name] or upg.Name,
                    lv,
                    growth,
                    cost
                ))
            end
        end
    end
    game.StarterGui:SetCore("DevConsoleVisible", true)
end)

-- 竖屏模式
createFuncButton("竖屏模式", function(enabled)
    LocalPlayer.PlayerGui.ScreenOrientation = enabled 
        and Enum.ScreenOrientation.Portrait 
        or Enum.ScreenOrientation.LandscapeRight
end)

-- ======================== 圆柱向下衍生动画（核心视觉效果）========================
-- 计算圆柱总高度（刚好装下所有功能）
local function getTotalContentHeight()
    local totalHeight = 0
    for _, child in contentContainer:GetChildren() do
        totalHeight += child.AbsoluteSize.Y + contentLayout.Padding.Offset
    end
    return totalHeight + 20 -- 加内边距补偿
end

local cylinderTotalHeight = getTotalContentHeight()

-- 展开/收起圆柱
local function toggleCylinder()
    isExpanded = not isExpanded
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    if isExpanded then
        -- 向下衍生：高度从0过渡到总高度，底部圆角从0过渡到半圆（圆柱形状）
        TweenService:Create(cylinderPanel, tweenInfo, {
            Size = UDim2.new(0, 180, 0, cylinderTotalHeight)
        }):Play()
        task.delay(0.1, function()
            cylinderCorner.CornerRadius = UDim.new(0.5, 0) -- 展开后底部也为半圆，完整圆柱
        end)
    else
        -- 向上收起：高度从总高度过渡到0，底部圆角从半圆过渡到0
        cylinderCorner.CornerRadius = UDim.new(0.5, 0, 0, 0) -- 收起时底部变直角，贴合标题
        TweenService:Create(cylinderPanel, tweenInfo, {
            Size = UDim2.new(0, 180, 0, 0)
        }):Play()
    end
end

-- 绑定标题点击触发圆柱衍生
titleOval.MouseButton1Click:Connect(toggleCylinder)
titleOval.TouchTap:Connect(toggleCylinder)

-- ======================== 拖动功能（标题+圆柱同步移动）========================
local dragTarget = nil
local startPos = Vector2.new(0, 0)
local titleStartPos = titleOval.Position
local cylinderStartPos = cylinderPanel.Position

-- 触摸开始（识别拖动目标）
UserInputService.TouchStarted:Connect(function(input)
    if input.UserInputType ~= Enum.UserInputType.Touch then return end
    local touchPos = input.Position

    -- 判断触摸是否命中标题或圆柱
    local function isTouchOn(target)
        local absPos = target.AbsolutePosition
        local absSize = target.AbsoluteSize
        return touchPos.X >= absPos.X and touchPos.X <= absPos.X + absSize.X
            and touchPos.Y >= absPos.Y and touchPos.Y <= absPos.Y + absSize.Y
    end

    if isTouchOn(titleOval) then
        dragTarget = "title"
    elseif isTouchOn(cylinderPanel) then
        dragTarget = "cylinder"
    else
        return
    end

    startPos = touchPos
    titleStartPos = titleOval.Position
    cylinderStartPos = cylinderPanel.Position
end)

-- 触摸移动（同步更新位置）
UserInputService.TouchMoved:Connect(function(input)
    if not dragTarget or input.UserInputType ~= Enum.UserInputType.Touch then return end
    local delta = input.Position - startPos

    -- 同步标题和圆柱位置
    if dragTarget == "title" then
        titleOval.Position = UDim2.new(
            0, titleStartPos.X.Offset + delta.X,
            0, titleStartPos.Y.Offset + delta.Y
        )
        cylinderPanel.Position = UDim2.new(
            0, titleStartPos.X.Offset + delta.X,
            0, titleStartPos.Y.Offset + delta.Y + 45 -- 保持圆柱在标题正下方
        )
    elseif dragTarget == "cylinder" then
        cylinderPanel.Position = UDim2.new(
            0, cylinderStartPos.X.Offset + delta.X,
            0, cylinderStartPos.Y.Offset + delta.Y
        )
        titleOval.Position = UDim2.new(
            0, cylinderStartPos.X.Offset + delta.X,
            0, cylinderStartPos.Y.Offset + delta.Y - 45 -- 保持标题在圆柱正上方
        )
    end
end)

-- 触摸结束（清理拖动状态）
UserInputService.TouchEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragTarget = nil
    end
end)

-- ======================== 初始化（确保圆柱初始状态正确）========================
cylinderPanel.Size = UDim2.new(0, 180, 0, 0)
cylinderCorner.CornerRadius = UDim.new(0.5, 0, 0, 0) -- 初始底部直角，贴合标题
