local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage:WaitForChild("Events")
local LocalPlayer = Players.LocalPlayer

-- 全局变量初始化
local autofarm, autoCollectingCubes, autoClaimRewards, farmMoving, showMap, autoeat
local autoUpgradeSize, autoUpgradeSpd, autoUpgradeMulti, autoUpgradeEat
local keepUnanchor, boundProtect

-- 清理旧窗口
if LocalPlayer.PlayerGui:FindFirstChild("MobileFloatingWindow") then
    LocalPlayer.PlayerGui.MobileFloatingWindow:Destroy()
end

-- 主GUI（置顶不遮挡）
local gui = Instance.new("ScreenGui")
gui.Name = "MobileFloatingWindow"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999
gui.Parent = LocalPlayer.PlayerGui

-- ======================== 全局彩虹光带配置 ========================
local hue = 0
RunService.RenderStepped:Connect(function(dt)
    hue = (hue + 1.2) % 360
end)

-- 创建彩虹光带框架
local function createRainbowBorder(parent, size, offset)
    local border = Instance.new("Frame")
    border.Size = size
    border.Position = offset or UDim2.new(0, 0, 0, 0)
    border.BackgroundTransparency = 1
    border.ZIndex = parent.ZIndex + 1
    border.Parent = parent.Parent

    local uiStroke = Instance.new("UIStroke", border)
    uiStroke.Thickness = 3
    uiStroke.LineJoinMode = Enum.LineJoinMode.Round
    uiStroke.LineCapMode = Enum.LineCapMode.Round

    RunService.RenderStepped:Connect(function()
        uiStroke.Color = Color3.fromHSV(hue / 360, 0.9, 1)
    end)
    return border
end

-- ======================== 主面板（棕色调+圆角）========================
-- 光带外层框架
local mainBorder = Instance.new("Frame")
mainBorder.Size = UDim2.new(0, 286, 0, 506) -- 竖向窄面板，贴合示例
mainBorder.Position = UDim2.new(0, 100, 0, 50)
mainBorder.BackgroundTransparency = 1
mainBorder.ZIndex = 999
mainBorder.Parent = gui

-- 主窗口光带
local mainRainbowBorder = createRainbowBorder(mainBorder, UDim2.new(1, 0, 1, 0))
local mainUISTroke = mainRainbowBorder:FindFirstChildOfClass("UIStroke")
mainUISTroke.Thickness = 4

-- 主面板（棕色调背景）
local frame = Instance.new("Frame", mainBorder)
frame.Size = UDim2.new(1, -6, 1, -6)
frame.Position = UDim2.new(0, 3, 0, 3)
frame.BackgroundColor3 = Color3.fromRGB(139, 101, 64) -- 棕色调
frame.BorderSizePixel = 0
frame.ClipsDescendants = true
frame.ZIndex = 1000
-- 主面板圆角
local frameCorner = Instance.new("UICorner", frame)
frameCorner.CornerRadius = UDim.new(0.05, 0)

-- ======================== 顶部标题栏 ========================
local titleBar = Instance.new("Frame", frame)
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(110, 78, 46)
titleBar.ZIndex = 1001

-- 标题文字
local titleText = Instance.new("TextLabel", titleBar)
titleText.Size = UDim2.new(1, -40, 1, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "吃吃世界Pro"
titleText.TextColor3 = Color3.fromRGB(255, 0, 255) -- 粉紫色标题
titleText.Font = Enum.Font.SourceSansBold
titleText.TextSize = 20
titleText.ZIndex = 1001

-- 最小化按钮（平躺椭圆）
local miniBtn = Instance.new("TextButton", titleBar)
miniBtn.Size = UDim2.new(0, 30, 0, 20)
miniBtn.Position = UDim2.new(1, -35, 0.5, -10)
miniBtn.Text = "-"
miniBtn.TextColor3 = Color3.new(1,1,1)
miniBtn.BackgroundColor3 = Color3.fromRGB(90, 62, 35)
miniBtn.AutoButtonColor = true
miniBtn.ZIndex = 1001
local miniBtnCorner = Instance.new("UICorner", miniBtn)
miniBtnCorner.CornerRadius = UDim.new(0.5, 0)
createRainbowBorder(miniBtn, UDim2.new(1, 6, 1, 6), UDim2.new(0, -3, 0, -3))

-- ======================== 内容滚动区（分层菜单）========================
local scrollFrame = Instance.new("ScrollingFrame", frame)
scrollFrame.Size = UDim2.new(1, 0, 1, -40)
scrollFrame.Position = UDim2.new(0, 0, 0, 40)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 6
scrollFrame.ScrollBarImageColor3 = Color3.new(1, 1, 1)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 600)
scrollFrame.ZIndex = 1000

-- 菜单列表布局
local menuLayout = Instance.new("UIListLayout", scrollFrame)
menuLayout.Padding = UDim.new(0, 5)
menuLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
menuLayout.VerticalAlignment = Enum.VerticalAlignment.Top

-- ======================== 最小化后的平躺椭圆按钮 ========================
local miniOval = Instance.new("TextButton", gui)
miniOval.Size = UDim2.new(0, 100, 0, 50)
miniOval.Position = UDim2.new(0, 30, 1, -80)
miniOval.BackgroundColor3 = Color3.fromRGB(139, 101, 64)
miniOval.Text = "+"
miniOval.TextSize = 28
miniOval.TextColor3 = Color3.new(1,1,1)
miniOval.Visible = false
miniOval.AutoButtonColor = true
miniOval.ZIndex = 1000
local miniOvalCorner = Instance.new("UICorner", miniOval)
miniOvalCorner.CornerRadius = UDim.new(0.5, 0)

-- 椭圆按钮双层光带
local miniInnerBorder = createRainbowBorder(miniOval, UDim2.new(1, -4, 1, -4), UDim2.new(0, 2, 0, 2))
local innerStroke = miniInnerBorder:FindFirstChildOfClass("UIStroke")
innerStroke.Thickness = 2

local miniOuterBorder = createRainbowBorder(miniOval, UDim2.new(1, 8, 1, 8), UDim2.new(0, -4, 0, -4))
local outerStroke = miniOuterBorder:FindFirstChildOfClass("UIStroke")
outerStroke.Thickness = 3
RunService.RenderStepped:Connect(function()
    local delayedHue = (hue + 60) % 360
    outerStroke.Color = Color3.fromHSV(delayedHue / 360, 0.9, 1)
end)

-- ======================== 核心功能函数 ========================
local function getRoot()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end

local function changeMap()
    local args = {{MapTime = -1, Paused = true}}
    Events.SetServerSettings:FireServer(unpack(args))
end

local function checkLoaded()
    return (LocalPlayer.Character
        and LocalPlayer.Character:FindFirstChild("Humanoid")
        and LocalPlayer.Character:FindFirstChild("Size")
        and LocalPlayer.Character:FindFirstChild("Events")
        and LocalPlayer.Character.Events:FindFirstChild("Grab")
        and LocalPlayer.Character.Events:FindFirstChild("Eat")
        and LocalPlayer.Character.Events:FindFirstChild("Sell")
        and LocalPlayer.Character:FindFirstChild("CurrentChunk")) ~= nil
end

local function sizeGrowth(level) return math.floor(((level + 0.5) ^ 2 - 0.25) / 2 * 100) end
local function speedGrowth(level) return math.floor(level * 2 + 10) end
local function multiplierGrowth(level) return math.floor(level) end
local function eatSpeedGrowth(level) return math.floor((1 + (level - 1) * 0.2) * 10) / 10 end
local function sizePrice(level) return math.floor(level ^ 3 / 2) * 20 end
local function speedPrice(level) return math.floor((level * 3) ^ 3 / 200) * 1000 end
local function multiplierPrice(level) return math.floor((level * 10) ^ 3 / 200) * 1000 end
local function eatSpeedPrice(level) return math.floor((level * 10) ^ 3 / 200) * 2000 end

-- ======================== 分层菜单创建函数 ========================
-- 创建分类按钮（带展开/收起箭头）
local function createCategory(parent, title, titleColor)
    local categoryFrame = Instance.new("Frame")
    categoryFrame.Size = UDim2.new(0, 250, 0, 40)
    categoryFrame.BackgroundColor3 = Color3.fromRGB(110, 78, 46)
    categoryFrame.ZIndex = 1001
    categoryFrame.Parent = parent
    local categoryCorner = Instance.new("UICorner", categoryFrame)
    categoryCorner.CornerRadius = UDim.new(0.05, 0)

    -- 分类标题
    local titleLabel = Instance.new("TextLabel", categoryFrame)
    titleLabel.Size = UDim2.new(1, -40, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = titleColor
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.TextSize = 18
    titleLabel.ZIndex = 1001

    -- 箭头图标
    local arrow = Instance.new("TextLabel", categoryFrame)
    arrow.Size = UDim2.new(0, 20, 0, 20)
    arrow.Position = UDim2.new(1, -30, 0.5, -10)
    arrow.BackgroundTransparency = 1
    arrow.Text = ">"
    arrow.TextColor3 = Color3.new(1,1,1)
    arrow.Font = Enum.Font.SourceSansBold
    arrow.TextSize = 20
    arrow.ZIndex = 1001

    -- 子菜单容器
    local subMenu = Instance.new("Frame")
    subMenu.Size = UDim2.new(0, 250, 0, 0)
    subMenu.BackgroundTransparency = 1
    subMenu.ZIndex = 1001
    subMenu.Parent = parent
    -- 子菜单布局
    local subLayout = Instance.new("UIListLayout", subMenu)
    subLayout.Padding = UDim.new(0, 3)
    subLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    subLayout.VerticalAlignment = Enum.VerticalAlignment.Top

    -- 展开/收起逻辑
    local isExpanded = false
    categoryFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            isExpanded = not isExpanded
            arrow.Text = isExpanded and "v" or ">"
            -- 自动计算子菜单高度
            local totalHeight = 0
            for _, child in subMenu:GetChildren() do
                if child:IsA("Frame") or child:IsA("TextButton") then
                    totalHeight += child.AbsoluteSize.Y + 3
                end
            end
            subMenu.Size = UDim2.new(0, 250, 0, isExpanded and totalHeight or 0)
        end
    end)

    return {
        frame = categoryFrame,
        subMenu = subMenu,
        subLayout = subLayout
    }
end

-- 创建子功能按钮
local function createSubButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 230, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(70, 50, 30)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Text = text
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 16
    btn.AutoButtonColor = true
    btn.ZIndex = 1001
    btn.Parent = parent
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0.05, 0)

    local isEnabled = false
    btn.MouseButton1Click:Connect(function()
        isEnabled = not isEnabled
        btn.BackgroundColor3 = isEnabled and Color3.fromRGB(40, 200, 100) or Color3.fromRGB(70, 50, 30)
        callback(isEnabled)
    end)
    return btn
end

-- 创建普通功能按钮（无开关）
local function createNormalButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 230, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(70, 50, 30)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Text = text
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 16
    btn.AutoButtonColor = true
    btn.ZIndex = 1001
    btn.Parent = parent
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0.05, 0)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ======================== 创建分层菜单（和示例一致）========================
-- 1. 自动功能分类（橙色）
local autoFuncCat = createCategory(scrollFrame, "自动功能", Color3.fromRGB(255, 165, 0))
createSubButton(autoFuncCat.subMenu, "自动刷", function(enabled)
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

        local startTime = tick()
        local eatTime = 0
        local lastEatTime = tick()
        local timer = 0
        local grabTimer = 0
        local sellDebounce = false
        local sellCount = 0
        local numChunks = 0

        local bedrock = Instance.new("Part")
        bedrock.Anchored = true
        bedrock.Size = Vector3.new(2048, 10, 2048)
        bedrock.Position = Vector3.new(0, -5, 0)
        bedrock.BrickColor = BrickColor.Black()
        bedrock.Parent = workspace

        local map, chunks = workspace:FindFirstChild("Map"), workspace:FindFirstChild("Chunks")
        if map and chunks then map.Parent, chunks.Parent = nil, nil end

        local hum, root, size, events, eat, grab, sell, sendTrack, chunk, radius, autoConn

        local function onCharAdd(char)
            numChunks = 0
            hum = char:WaitForChild("Humanoid")
            root = char:WaitForChild("HumanoidRootPart")
            size = char:WaitForChild("Size")
            events = char:WaitForChild("Events")
            eat = events:WaitForChild("Eat")
            grab = events:WaitForChild("Grab")
            sell = events:WaitForChild("Sell")
            chunk = char:WaitForChild("CurrentChunk")
            sendTrack = char:WaitForChild("SendTrack")
            radius = char:WaitForChild("Radius")

            autoConn = RunService.Heartbeat:Connect(function(dt)
                if not autofarm then autoConn:Disconnect() return end

                local ran = tick() - startTime
                local hours = math.floor(ran / 60 / 60)
                local minutes = math.floor(ran / 60)
                local seconds = math.floor(ran)
                local eatMinutes = math.floor(eatTime / 60)
                local eatSeconds = math.floor(eatTime)
                local y = bedrock.Position.Y + bedrock.Size.Y / 2 + hum.HipHeight + root.Size.Y / 2
                local sizeAdd = LocalPlayer.Upgrades.Multiplier.Value / 100
                local addAmount = LocalPlayer.Upgrades.MaxSize.Value / sizeAdd
                local sellTime = addAmount / 2
                local secondEarn = math.floor(sizeGrowth(LocalPlayer.Upgrades.MaxSize.Value) / sellTime)

                text.Text = string.format(
                    "运行时间: %ih%im%is\n实际时间: %im%is\n大约时间: %im%is\n每秒收益: %i\n块数: %i",
                    hours, minutes % 60, seconds % 60,
                    eatMinutes % 60, eatSeconds % 60,
                    math.floor(sellTime / 60), math.floor(sellTime) % 60,
                    secondEarn, numChunks
                )

                hum:ChangeState(Enum.HumanoidStateType.Physics)
                grab:FireServer()
                root.Anchored = false
                eat:FireServer()
                sendTrack:FireServer()

                if chunk.Value then
                    if timer > 0 then numChunks += 1 end
                    timer = 0
                    grabTimer += dt
                else
                    timer += dt
                    grabTimer = 0
                end

                if timer > 60 then hum.Health = 0 timer = 0 numChunks = 0 end
                if grabTimer > 15 then size.Value = LocalPlayer.Upgrades.MaxSize.Value end

                if (size.Value >= LocalPlayer.Upgrades.MaxSize.Value) or timer > 8 then
                    if timer < 8 then sell:FireServer() if not sellDebounce then changeMap() end sellDebounce = true
                    else changeMap() end
                    numChunks = 0
                elseif size.Value == 0 then
                    if sellDebounce then
                        local currentEatTime = tick()
                        eatTime = currentEatTime - lastEatTime
                        lastEatTime = currentEatTime
                        sellCount += 1
                    end
                    sellDebounce = false
                end

                if farmMoving then
                    local bound = 300
                    local startPos = CFrame.new(-bound/2, y, -bound/2)
                    local r = radius.Value * 1.1
                    local dist = (r * numChunks)
                    local x = dist % bound
                    local z = math.floor(dist / bound) * r
                    local offset = CFrame.new(x, 0, z + r * 2)
                    if z > bound then changeMap() numChunks = 0 end
                    root.CFrame = startPos * offset
                else
                    root.CFrame = CFrame.new(0, y, 0)
                end
            end)

            hum.Died:Connect(function() if autoConn then autoConn:Disconnect() end changeMap() end)
            char:WaitForChild("LocalChunkManager").Enabled = false
            char:WaitForChild("Animate").Enabled = false
        end

        if LocalPlayer.Character then task.spawn(onCharAdd, LocalPlayer.Character)
        else task.spawn(onCharAdd, LocalPlayer.CharacterAdded:Wait()) end

        local charAddConn = LocalPlayer.CharacterAdded:Connect(onCharAdd)
        while autofarm do
            task.wait()
            if workspace:FindFirstChild("Loading") then workspace.Loading:Destroy() end
            if map and chunks then
                map.Parent, chunks.Parent = showMap and workspace or nil, showMap and workspace or nil
            end
        end

        charAddConn:Disconnect()
        if autoConn then autoConn:Disconnect() end
        if map and chunks then map.Parent, chunks.Parent = workspace, workspace end
        if hum then hum:ChangeState(Enum.HumanoidStateType.GettingUp) end
        bedrock:Destroy()
        if LocalPlayer.Character then
            LocalPlayer.Character.LocalChunkManager.Enabled = true
            LocalPlayer.Character.Animate.Enabled = true
        end
        text:Destroy()
    end)()
end)
createSubButton(autoFuncCat.subMenu, "自动收", function(enabled)
    autoCollectingCubes = enabled
    if not enabled then return end
    coroutine.wrap(function()
        LocalPlayer.PlayerScripts.CubeVis.Enabled = false
        while autoCollectingCubes do
            task.wait()
            local root = getRoot()
            if root then
                for _, v in workspace:GetChildren() do
                    if v.Name == "Cube" and v:FindFirstChild("Owner") and (v.Owner.Value == LocalPlayer.Name or v.Owner.Value == "") then
                        v.CFrame = root.CFrame
                    end
                end
            end
        end
        LocalPlayer.PlayerScripts.CubeVis.Enabled = true
    end)()
end)
createSubButton(autoFuncCat.subMenu, "自动领", function(enabled)
    autoClaimRewards = enabled
    if not enabled then return end
    coroutine.wrap(function()
        while autoClaimRewards do
            task.wait(1)
            for _, reward in LocalPlayer.TimedRewards:GetChildren() do
                if reward.Value > 0 then Events.RewardEvent:FireServer(reward) end
            end
            Events.SpinEvent:FireServer()
        end
    end)()
end)
createSubButton(autoFuncCat.subMenu, "自动吃", function(enabled)
    autoeat = enabled
    if not enabled then return end
    coroutine.wrap(function()
        while autoeat do
            task.wait()
            if checkLoaded() then
                LocalPlayer.Character.HumanoidRootPart.Anchored = false
                LocalPlayer.Character.Events.Grab:FireServer()
                LocalPlayer.Character.Events.Eat:FireServer()
            end
        end
    end)()
end)

-- 2. 移动速度分类（绿色）
local moveSpeedCat = createCategory(scrollFrame, "移动速度", Color3.fromRGB(0, 255, 0))
createSubButton(moveSpeedCat.subMenu, "自动升级移速", function(enabled)
    autoUpgradeSpd = enabled
    if not enabled then return end
    coroutine.wrap(function()
        game.CoreGui.PurchasePromptApp.Enabled = false
        while autoUpgradeSpd do
            task.wait(1)
            Events.PurchaseEvent:FireServer("Speed")
        end
        game.CoreGui.PurchasePromptApp.Enabled = true
    end)()
end)
createSubButton(moveSpeedCat.subMenu, "移动模式", function(enabled)
    farmMoving = enabled
end)

-- 3. 其它工具分类（亮绿色）
local otherToolsCat = createCategory(scrollFrame, "其它工具", Color3.fromRGB(0, 255, 127))
createSubButton(otherToolsCat.subMenu, "取消锚固", function(enabled)
    keepUnanchor = enabled
    if not enabled then return end
    coroutine.wrap(function()
        while keepUnanchor do
            task.wait()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.Anchored = false
            end
        end
    end)()
end)
createSubButton(otherToolsCat.subMenu, "边界保护", function(enabled)
    boundProtect = enabled
    if not enabled then return end
    coroutine.wrap(function()
        while boundProtect do
            task.wait()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local root = LocalPlayer.Character.HumanoidRootPart
                local pos = root.Position
                local mapSize = workspace.Map.Bedrock.Size * Vector3.new(1, 0, 1)
                local clampedPos = Vector3.new(
                    math.clamp(pos.X, -mapSize.X/2, mapSize.X/2),
                    pos.Y,
                    math.clamp(pos.Z, -mapSize.Z/2, mapSize.Z/2)
                )
                root.CFrame = CFrame.new(clampedPos) * root.CFrame.Rotation
            end
        end
    end)()
end)
createNormalButton(otherToolsCat.subMenu, "人物数据榜", function()
    local localization = {MaxSize = "体积", Speed = "移速", Multiplier = "乘数", EatSpeed = "吃速"}
    local growthFunctions = {MaxSize = sizeGrowth, Speed = speedGrowth, Multiplier = multiplierGrowth, EatSpeed = eatSpeedGrowth}
    local priceFunctions = {MaxSize = sizePrice, Speed = speedPrice, Multiplier = multiplierPrice, EatSpeed = eatSpeedPrice}

    for _, player in Players:GetPlayers() do
        print()
        for _, upg in player.Upgrades:GetChildren() do
            local cost = 0
            for l = 2, upg.Value do cost += priceFunctions[upg.Name](l) end
            print(string.format(
                "%s：%s %i级；%i值；%i花费",
                player.Name, localization[upg.Name], upg.Value,
                growthFunctions[upg.Name](upg.Value), cost
            ))
        end
    end
    game.StarterGui:SetCore("DevConsoleVisible", true)
end)

-- 4. 记忆分区分类（浅蓝色）
local memoryCat = createCategory(scrollFrame, "记忆分区", Color3.fromRGB(100, 149, 237))
createSubButton(memoryCat.subMenu, "自动升级大小", function(enabled)
    autoUpgradeSize = enabled
    if not enabled then return end
    coroutine.wrap(function()
        game.CoreGui.PurchasePromptApp.Enabled = false
        while autoUpgradeSize do
            task.wait(1)
            Events.PurchaseEvent:FireServer("MaxSize")
        end
        game.CoreGui.PurchasePromptApp.Enabled = true
    end)()
end)
createSubButton(memoryCat.subMenu, "自动升级乘数", function(enabled)
    autoUpgradeMulti = enabled
    if not enabled then return end
    coroutine.wrap(function()
        game.CoreGui.PurchasePromptApp.Enabled = false
        while autoUpgradeMulti do
            task.wait(1)
            Events.PurchaseEvent:FireServer("Multiplier")
        end
        game.CoreGui.PurchasePromptApp.Enabled = true
    end)()
end)
createSubButton(memoryCat.subMenu, "自动升级吃速", function(enabled)
    autoUpgradeEat = enabled
    if not enabled then return end
    coroutine.wrap(function()
        game.CoreGui.PurchasePromptApp.Enabled = false
        while autoUpgradeEat do
            task.wait(1)
            Events.PurchaseEvent:FireServer("EatSpeed")
        end
        game.CoreGui.PurchasePromptApp.Enabled = true
    end)()
end)
createSubButton(memoryCat.subMenu, "显示地图", function(enabled)
    showMap = enabled
end)

-- 5. 动作特效分类（深蓝色）
local effectCat = createCategory(scrollFrame, "动作特效", Color3.fromRGB(0, 0, 255))
createSubButton(effectCat.subMenu, "竖屏模式", function(enabled)
    LocalPlayer.PlayerGui.ScreenOrientation = enabled and Enum.ScreenOrientation.Portrait or Enum.ScreenOrientation.LandscapeRight
end)

-- 6. 主题颜色分类（粉紫色）
local themeCat = createCategory(scrollFrame, "主题颜色", Color3.fromRGB(255, 0, 255))
createNormalButton(themeCat.subMenu, "彩虹光带加速", function()
    hue = (hue + 5) % 360 -- 临时加速光带
end)

-- ======================== 悬浮窗基础功能（拖动/缩放/最小化）========================
-- 拖动逻辑
local dragging, draggingMini = false, false
local dragStart, startPos, miniStart, miniPos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainBorder.Position
    end
end)

titleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

miniOval.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        draggingMini = true
        miniStart = input.Position
        miniPos = miniOval.Position
    end
end)

miniOval.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then draggingMini = false end
end)

UserInputService.TouchMoved:Connect(function(input)
    if dragging then
        local delta = input.Position - dragStart
        mainBorder.Position = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
    elseif draggingMini then
        local delta = input.Position - miniStart
        miniOval.Position = UDim2.new(0, miniPos.X.Offset + delta.X, 0, miniPos.Y.Offset + delta.Y)
    end
end)

-- 缩放按钮（右下角）
local resizeBtn = Instance.new("ImageButton", frame)
resizeBtn.Size = UDim2.new(0, 30, 0, 30)
resizeBtn.Position = UDim2.new(1, -15, 1, -15)
resizeBtn.AnchorPoint = Vector2.new(1,1)
resizeBtn.BackgroundColor3 = Color3.fromRGB(90, 62, 35)
resizeBtn.Image = "rbxassetid://3926305904"
resizeBtn.ImageRectOffset = Vector2.new(84, 284)
resizeBtn.ImageRectSize = Vector2.new(36, 36)
resizeBtn.AutoButtonColor = true
resizeBtn.ZIndex = 1001
local resizeCorner = Instance.new("UICorner", resizeBtn)
resizeCorner.CornerRadius = UDim.new(0.5, 0)
createRainbowBorder(resizeBtn, UDim2.new(1, 6, 1, 6), UDim2.new(0, -3, 0, -3))

-- 缩放逻辑
local resizing = false
local resizeStartPos, resizeStartSize

resizeBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        resizing = true
        resizeStartPos = input.Position
        resizeStartSize = mainBorder.Size
    end
end)

resizeBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then resizing = false end
end)

UserInputService.TouchMoved:Connect(function(input)
    if resizing then
        local delta = input.Position - resizeStartPos
        local newW = math.max(250, resizeStartSize.X.Offset + delta.X)
        local newH = math.max(400, resizeStartSize.Y.Offset + delta.Y)
        mainBorder.Size = UDim2.new(0, newW, 0, newH)
        frame.Size = UDim2.new(1, -6, 1, -6)
    end
end)

-- 最小化/双击打开逻辑
miniBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        frame.Visible = false
        mainRainbowBorder.Visible = false
        miniOval.Visible = true
    end
end)

local lastClickTime = 0
local doubleClickDelay = 400
miniOval.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        local currentTime = tick()
        if currentTime - lastClickTime < doubleClickDelay then
            miniOval.Visible = false
            frame.Visible = true
            mainRainbowBorder.Visible = true
        end
        lastClickTime = currentTime
    end
end)
