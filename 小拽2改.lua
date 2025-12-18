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
-- 颜色自定义全局变量
local currentUIColor = Color3.fromRGB(139, 101, 64) -- 默认棕色调
local colorPresets = {
    棕色调 = Color3.fromRGB(139, 101, 64),
    蓝调 = Color3.fromRGB(60, 100, 180),
    红调 = Color3.fromRGB(180, 60, 80),
    绿调 = Color3.fromRGB(60, 180, 100),
    紫调 = Color3.fromRGB(120, 60, 180)
}

-- 清理旧窗口
if LocalPlayer.PlayerGui:FindFirstChild("MobileFloatingWindow") then
    LocalPlayer.PlayerGui.MobileFloatingWindow:Destroy()
end

-- 主GUI（置顶+忽略边距）
local gui = Instance.new("ScreenGui")
gui.Name = "MobileFloatingWindow"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999
gui.IgnoreGuiInset = true
gui.Parent = LocalPlayer.PlayerGui

-- ======================== 全局彩虹光带配置 ========================
local hue = 0
RunService.RenderStepped:Connect(function(dt)
    hue = (hue + 1.2) % 360
end)

-- 创建彩虹光带框架（内部描边，避免成线）
local function createRainbowBorder(parent, size, offset)
    local border = Instance.new("Frame")
    border.Size = size or UDim2.new(1, 0, 1, 0)
    border.Position = offset or UDim2.new(0, 0, 0, 0)
    border.BackgroundTransparency = 1
    border.ZIndex = parent.ZIndex + 1
    border.Parent = parent.Parent
    border.ClipsDescendants = true

    local uiStroke = Instance.new("UIStroke", border)
    uiStroke.Thickness = 2
    uiStroke.LineJoinMode = Enum.LineJoinMode.Round
    uiStroke.LineCapMode = Enum.LineCapMode.Round
    uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Inside

    RunService.RenderStepped:Connect(function()
        uiStroke.Color = Color3.fromHSV(hue / 360, 0.9, 1)
    end)
    return border
end

-- 更新UI颜色函数（颜色自定义核心）
local function updateUIColor(color)
    currentUIColor = color
    -- 更新标题椭圆颜色
    titleOval.BackgroundColor3 = color
    -- 更新主面板颜色
    mainPanel.BackgroundColor3 = color
    -- 更新分类按钮颜色
    for _, cat in ipairs(categoryFrames) do
        cat.BackgroundColor3 = color:lerp(Color3.fromRGB(0,0,0), 0.2)
    end
    -- 更新最小化椭圆颜色
    miniOval.BackgroundColor3 = color
end

-- ======================== 标题椭圆（小尺寸+包裹“小拽吃吃世界”）========================
local titleOval = Instance.new("TextButton")
titleOval.Size = UDim2.new(0, 200, 0, 50) -- 小尺寸横向椭圆：200×50
titleOval.Position = UDim2.new(0.2, 0, 0.2, 0) -- 屏幕上方偏左，不遮挡游戏UI
titleOval.BackgroundColor3 = currentUIColor
titleOval.Text = "小拽吃吃世界"
titleOval.TextColor3 = Color3.new(1,1,1)
titleOval.Font = Enum.Font.SourceSansBold
titleOval.TextSize = 18
titleOval.ZIndex = 1000
titleOval.Parent = gui
-- 横向椭圆圆角（高度的一半）
local titleCorner = Instance.new("UICorner", titleOval)
titleCorner.CornerRadius = UDim.new(0.5, 0)
-- 标题椭圆彩虹光带
createRainbowBorder(titleOval)

-- ======================== 主悬浮窗面板（窄版+标题椭圆下方展开）========================
local mainPanel = Instance.new("Frame")
mainPanel.Size = UDim2.new(0, 300, 0, 150) -- 窄版：宽300（不要太宽），高150
mainPanel.Position = UDim2.new(0.2, 0, 0.2, 60) -- 在标题椭圆下方60像素展开
mainPanel.BackgroundColor3 = currentUIColor
mainPanel.BorderSizePixel = 0
mainPanel.ClipsDescendants = true
mainPanel.ZIndex = 1000
mainPanel.Visible = false -- 默认隐藏，点击标题椭圆展开
mainPanel.Parent = gui
-- 主面板横向椭圆圆角
local panelCorner = Instance.new("UICorner", mainPanel)
panelCorner.CornerRadius = UDim.new(0.3, 0) -- 浅椭圆，不夸张
-- 主面板彩虹光带
createRainbowBorder(mainPanel)

-- ======================== 主面板内容区（窄版适配）========================
local scrollFrame = Instance.new("ScrollingFrame", mainPanel)
scrollFrame.Size = UDim2.new(1, -10, 1, -10)
scrollFrame.Position = UDim2.new(0, 5, 0, 5)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 4
scrollFrame.ScrollBarImageColor3 = Color3.new(1, 1, 1)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 400)
scrollFrame.ZIndex = 1001
scrollFrame.ScrollBarBackgroundTransparency = 1

local menuLayout = Instance.new("UIListLayout", scrollFrame)
menuLayout.Padding = UDim.new(0, 5)
menuLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
menuLayout.VerticalAlignment = Enum.VerticalAlignment.Top

-- 分类按钮存储（用于颜色更新）
local categoryFrames = {}

-- ======================== 最小化后的小椭圆（点击隐藏主面板）========================
local miniOval = Instance.new("TextButton", gui)
miniOval.Size = UDim2.new(0, 80, 0, 40) -- 更小的椭圆：80×40
miniOval.Position = UDim2.new(0.1, 0, 0.8, 0)
miniOval.BackgroundColor3 = currentUIColor
miniOval.Text = "-"
miniOval.TextSize = 24
miniOval.TextColor3 = Color3.new(1,1,1)
miniOval.Visible = false
miniOval.ZIndex = 1000
local miniOvalCorner = Instance.new("UICorner", miniOval)
miniOvalCorner.CornerRadius = UDim.new(0.5, 0)
createRainbowBorder(miniOval)

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

-- ======================== 菜单创建函数（窄版适配）========================
local function createCategory(parent, title, titleColor)
    local categoryFrame = Instance.new("Frame")
    categoryFrame.Size = UDim2.new(0, 280, 0, 40) -- 窄版分类按钮
    categoryFrame.BackgroundColor3 = currentUIColor:lerp(Color3.fromRGB(0,0,0), 0.2)
    categoryFrame.ZIndex = 1001
    categoryFrame.Parent = parent
    table.insert(categoryFrames, categoryFrame) -- 加入颜色更新列表
    local categoryCorner = Instance.new("UICorner", categoryFrame)
    categoryCorner.CornerRadius = UDim.new(0.1, 0)

    local titleLabel = Instance.new("TextLabel", categoryFrame)
    titleLabel.Size = UDim2.new(1, -30, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = titleColor
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.TextSize = 16
    titleLabel.ZIndex = 1001

    local arrow = Instance.new("TextLabel", categoryFrame)
    arrow.Size = UDim2.new(0, 20, 0, 20)
    arrow.Position = UDim2.new(1, -25, 0.5, -10)
    arrow.BackgroundTransparency = 1
    arrow.Text = "v"
    arrow.TextColor3 = Color3.new(1,1,1)
    arrow.Font = Enum.Font.SourceSansBold
    arrow.TextSize = 18
    arrow.ZIndex = 1001

    local subMenu = Instance.new("Frame")
    subMenu.Size = UDim2.new(0, 270, 0, 0)
    subMenu.Position = UDim2.new(0, 5, 0, 45)
    subMenu.BackgroundTransparency = 1
    subMenu.ZIndex = 1001
    subMenu.Parent = categoryFrame

    local subLayout = Instance.new("UIListLayout", subMenu)
    subLayout.Padding = UDim.new(0, 3)
    subLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    subLayout.VerticalAlignment = Enum.VerticalAlignment.Top

    local isExpanded = false
    categoryFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            isExpanded = not isExpanded
            arrow.Text = isExpanded and "^" or "v"
            local totalHeight = 0
            for _, child in subMenu:GetChildren() do
                if child:IsA("TextButton") then
                    totalHeight += child.AbsoluteSize.Y + 3
                end
            end
            subMenu.Size = UDim2.new(0, 270, 0, isExpanded and totalHeight or 0)
        end
    end)

    return {
        frame = categoryFrame,
        subMenu = subMenu,
        subLayout = subLayout
    }
end

local function createSubButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 260, 0, 30) -- 窄版功能按钮
    btn.BackgroundColor3 = currentUIColor:lerp(Color3.fromRGB(0,0,0), 0.4)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Text = text
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    btn.AutoButtonColor = true
    btn.ZIndex = 1001
    btn.Parent = parent
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0.1, 0)

    local isEnabled = false
    btn.MouseButton1Click:Connect(function()
        isEnabled = not isEnabled
        btn.BackgroundColor3 = isEnabled and Color3.fromRGB(40, 200, 100) or currentUIColor:lerp(Color3.fromRGB(0,0,0), 0.4)
        callback(isEnabled)
    end)
    return btn
end

local function createColorButton(parent, text, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 120, 0, 30)
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Text = text
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    btn.AutoButtonColor = true
    btn.ZIndex = 1001
    btn.Parent = parent
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0.1, 0)

    btn.MouseButton1Click:Connect(function()
        updateUIColor(color)
    end)
    return btn
end

-- ======================== 创建功能菜单（含颜色自定义）========================
-- 1. 自动功能分类
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

-- 2. 移动速度分类
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

-- 3. 其它工具分类
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

-- 4. 颜色自定义分类（核心需求）
local colorCat = createCategory(scrollFrame, "颜色自定义", Color3.fromRGB(255, 0, 255))
-- 颜色预设按钮（横向排列）
local colorLayout = Instance.new("UIListLayout", colorCat.subMenu)
colorLayout.FillDirection = Enum.FillDirection.Horizontal
colorLayout.Padding = UDim.new(0, 5)
colorLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

for name, color in pairs(colorPresets) do
    createColorButton(colorCat.subMenu, name, color)
end

-- ======================== 点击逻辑（单击展开/隐藏）========================
-- 点击标题椭圆：展开主面板，隐藏标题椭圆，显示最小化椭圆
titleOval.MouseButton1Click:Connect(function()
    mainPanel.Visible = true
    titleOval.Visible = false
    miniOval.Visible = true
end)

-- 点击最小化椭圆：隐藏主面板，显示标题椭圆，隐藏最小化椭圆
miniOval.MouseButton1Click:Connect(function()
    mainPanel.Visible = false
    miniOval.Visible = false
    titleOval.Visible = true
end)

-- ======================== 拖动功能（保留）========================
local dragging = false
local dragStart, startPos

-- 拖动标题椭圆
titleOval.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = titleOval.Position
    end
end)

titleOval.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

-- 拖动主面板
mainPanel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainPanel.Position
    end
end)

mainPanel.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

-- 拖动最小化椭圆
miniOval.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = miniOval.Position
    end
end)

miniOval.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

UserInputService.TouchMoved:Connect(function(input)
    if dragging then
        local delta = input.Position - dragStart
        -- 判断当前拖动的是哪个元素
        if titleOval.Visible then
            titleOval.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            mainPanel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + 60)
        elseif mainPanel.Visible then
            mainPanel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            titleOval.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset - 60)
        else
            miniOval.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end
end)
