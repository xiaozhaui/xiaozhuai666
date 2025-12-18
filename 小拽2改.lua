local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- 全局变量初始化（避免未定义报错）
local autofarm, autoCollectingCubes, autoClaimRewards, farmMoving, showMap, autoeat
local autoUpgradeSize, autoUpgradeSpd, autoUpgradeMulti, autoUpgradeEat
local keepUnanchor, boundProtect
local currentUIColor = Color3.fromRGB(139, 101, 64)
local colorPresets = {
    棕色调 = Color3.fromRGB(139, 101, 64),
    蓝调 = Color3.fromRGB(60, 100, 180),
    红调 = Color3.fromRGB(180, 60, 80),
    绿调 = Color3.fromRGB(60, 180, 100),
    紫调 = Color3.fromRGB(120, 60, 180)
}

-- 清理旧窗口（容错处理）
pcall(function()
    if LocalPlayer.PlayerGui:FindFirstChild("MobileFloatingWindow") then
        LocalPlayer.PlayerGui.MobileFloatingWindow:Destroy()
    end
end)

-- 主GUI（容错创建，确保PlayerGui可用）
local gui = Instance.new("ScreenGui")
gui.Name = "MobileFloatingWindow"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999
gui.IgnoreGuiInset = true
-- 容错：如果PlayerGui不可用，降级到CoreGui（仅作为备用）
pcall(function()
    gui.Parent = LocalPlayer.PlayerGui
end)
if not gui.Parent then
    gui.Parent = CoreGui
end

-- ======================== 彩虹光带（简化，避免性能问题）========================
local hue = 0
RunService.RenderStepped:Connect(function(dt)
    hue = (hue + 1.2) % 360
end)

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

-- ======================== 标题椭圆（核心触发按钮，确保创建成功）========================
local titleOval = Instance.new("TextButton")
titleOval.Size = UDim2.new(0, 200, 0, 50)
titleOval.Position = UDim2.new(0.2, 0, 0.2, 0)
titleOval.BackgroundColor3 = currentUIColor
titleOval.Text = "小拽吃吃世界"
titleOval.TextColor3 = Color3.new(1,1,1)
titleOval.Font = Enum.Font.SourceSansBold
titleOval.TextSize = 18
titleOval.ZIndex = 1000
titleOval.Parent = gui
local titleCorner = Instance.new("UICorner", titleOval)
titleCorner.CornerRadius = UDim.new(0.5, 0)
createRainbowBorder(titleOval)

-- ======================== 主面板（简化UI，避免复杂布局报错）========================
local mainPanel = Instance.new("Frame")
mainPanel.Size = UDim2.new(0, 300, 0, 150)
mainPanel.Position = UDim2.new(0.2, 0, 0.2, 60)
mainPanel.BackgroundColor3 = currentUIColor
mainPanel.BorderSizePixel = 0
mainPanel.ClipsDescendants = true
mainPanel.ZIndex = 1000
mainPanel.Visible = false
mainPanel.Parent = gui
local panelCorner = Instance.new("UICorner", mainPanel)
panelCorner.CornerRadius = UDim.new(0.3, 0)
createRainbowBorder(mainPanel)

-- 内容区（简化滚动框，避免布局报错）
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

local categoryFrames = {}

-- ======================== 最小化椭圆（简化）========================
local miniOval = Instance.new("TextButton", gui)
miniOval.Size = UDim2.new(0, 80, 0, 40)
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

-- ======================== 核心功能（加容错，避免依赖项缺失报错）========================
-- 容错：等待关键实例，超时跳过
local function waitForInstance(parent, name, timeout)
    local start = tick()
    while not parent:FindFirstChild(name) and tick() - start < timeout do
        task.wait()
    end
    return parent:FindFirstChild(name)
end

-- 依赖项检查（避免空引用）
local Events = waitForInstance(ReplicatedStorage, "Events", 3)
local SetServerSettings = Events and Events:FindFirstChild("SetServerSettings")
local PurchaseEvent = Events and Events:FindFirstChild("PurchaseEvent")
local RewardEvent = Events and Events:FindFirstChild("RewardEvent")
local SpinEvent = Events and Events:FindFirstChild("SpinEvent")
local Upgrades = LocalPlayer and waitForInstance(LocalPlayer, "Upgrades", 3)
local TimedRewards = LocalPlayer and waitForInstance(LocalPlayer, "TimedRewards", 3)

local function getRoot()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end

local function changeMap()
    if SetServerSettings then
        pcall(function()
            SetServerSettings:FireServer({MapTime = -1, Paused = true})
        end)
    end
end

local function checkLoaded()
    if not LocalPlayer.Character then return false end
    local char = LocalPlayer.Character
    return char:FindFirstChild("Humanoid")
        and char:FindFirstChild("Size")
        and char:FindFirstChild("Events")
        and char.Events:FindFirstChild("Grab")
        and char.Events:FindFirstChild("Eat")
        and char.Events:FindFirstChild("Sell")
        and char:FindFirstChild("CurrentChunk")
end

-- 升级相关函数（加容错）
local function sizeGrowth(level) return math.floor(((level + 0.5) ^ 2 - 0.25) / 2 * 100) end
local function speedGrowth(level) return math.floor(level * 2 + 10) end
local function multiplierGrowth(level) return math.floor(level) end
local function eatSpeedGrowth(level) return math.floor((1 + (level - 1) * 0.2) * 10) / 10 end

-- ======================== 菜单创建（简化，避免复杂逻辑报错）========================
local function createCategory(parent, title, titleColor)
    local categoryFrame = Instance.new("Frame")
    categoryFrame.Size = UDim2.new(0, 280, 0, 40)
    categoryFrame.BackgroundColor3 = currentUIColor:lerp(Color3.fromRGB(0,0,0), 0.2)
    categoryFrame.ZIndex = 1001
    categoryFrame.Parent = parent
    table.insert(categoryFrames, categoryFrame)
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

    local isExpanded = false
    categoryFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
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

    return {frame = categoryFrame, subMenu = subMenu, subLayout = subLayout}
end

local function createSubButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 260, 0, 30)
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
        pcall(callback, isEnabled) -- 容错：避免回调函数报错
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
        currentUIColor = color
        titleOval.BackgroundColor3 = color
        mainPanel.BackgroundColor3 = color
        miniOval.BackgroundColor3 = color
        for _, cat in ipairs(categoryFrames) do
            cat.BackgroundColor3 = color:lerp(Color3.fromRGB(0,0,0), 0.2)
        end
    end)
    return btn
end

-- ======================== 创建菜单（仅保留关键功能，避免冗余报错）========================
-- 1. 自动功能（加容错）
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
        local numChunks = 0
        local bedrock = Instance.new("Part")
        bedrock.Anchored = true
        bedrock.Size = Vector3.new(2048, 10, 2048)
        bedrock.Position = Vector3.new(0, -5, 0)
        bedrock.BrickColor = BrickColor.Black()
        bedrock.Parent = workspace

        local map, chunks = workspace:FindFirstChild("Map"), workspace:FindFirstChild("Chunks")
        if map and chunks then map.Parent, chunks.Parent = nil, nil end

        local function onCharAdd(char)
            numChunks = 0
            local hum = char:FindFirstChild("Humanoid")
            local root = char:FindFirstChild("HumanoidRootPart")
            local size = char:FindFirstChild("Size")
            local events = char:FindFirstChild("Events")
            if not hum or not root or not size or not events then return end
            local eat = events:FindFirstChild("Eat")
            local grab = events:FindFirstChild("Grab")
            local sell = events:FindFirstChild("Sell")
            local chunk = char:FindFirstChild("CurrentChunk")
            local sendTrack = char:FindFirstChild("SendTrack")
            if not eat or not grab or not sell or not chunk or not sendTrack then return end

            local autoConn = RunService.Heartbeat:Connect(function(dt)
                if not autofarm then autoConn:Disconnect() return end
                pcall(function()
                    hum:ChangeState(Enum.HumanoidStateType.Physics)
                    grab:FireServer()
                    root.Anchored = false
                    eat:FireServer()
                    sendTrack:FireServer()

                    local ran = tick() - startTime
                    local hours = math.floor(ran / 60 / 60)
                    local minutes = math.floor(ran / 60)
                    local seconds = math.floor(ran)
                    text.Text = string.format("运行时间: %ih%im%is\n块数: %i", hours, minutes % 60, seconds % 60, numChunks)

                    if chunk.Value then
                        numChunks += 1
                    end
                    if size.Value >= (Upgrades and Upgrades.MaxSize and Upgrades.MaxSize.Value or 100) then
                        sell:FireServer()
                        changeMap()
                        numChunks = 0
                    end
                end)
            end)

            hum.Died:Connect(function()
                if autoConn then autoConn:Disconnect() end
                changeMap()
            end)
            pcall(function()
                char:FindFirstChild("LocalChunkManager").Enabled = false
                char:FindFirstChild("Animate").Enabled = false
            end)
        end

        if LocalPlayer.Character then
            task.spawn(onCharAdd, LocalPlayer.Character)
        end
        LocalPlayer.CharacterAdded:Connect(onCharAdd)

        while autofarm do
            task.wait()
            pcall(function()
                if workspace:FindFirstChild("Loading") then workspace.Loading:Destroy() end
            end)
        end

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

-- 2. 颜色自定义（核心功能，确保可用）
local colorCat = createCategory(scrollFrame, "颜色自定义", Color3.fromRGB(255, 0, 255))
local colorLayout = Instance.new("UIListLayout", colorCat.subMenu)
colorLayout.FillDirection = Enum.FillDirection.Horizontal
colorLayout.Padding = UDim.new(0, 5)

for name, color in pairs(colorPresets) do
    createColorButton(colorCat.subMenu, name, color)
end

-- ======================== 点击逻辑（简化，确保触发）========================
titleOval.MouseButton1Click:Connect(function()
    mainPanel.Visible = true
    titleOval.Visible = false
    miniOval.Visible = true
end)

miniOval.MouseButton1Click:Connect(function()
    mainPanel.Visible = false
    miniOval.Visible = false
    titleOval.Visible = true
end)

-- ======================== 拖动功能（简化，避免事件冲突）========================
local dragging = false
local dragStart, startPos, currentDragTarget

local function setDragTarget(target)
    currentDragTarget = target
    dragging = true
    dragStart = UserInputService:GetMouseLocation()
    startPos = target.Position
end

titleOval.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        setDragTarget(titleOval)
    end
end)

mainPanel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        setDragTarget(mainPanel)
    end
end)

miniOval.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        setDragTarget(miniOval)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
        currentDragTarget = nil
    end
end)

UserInputService.TouchMoved:Connect(function(input)
    if dragging and currentDragTarget then
        local delta = input.Position - dragStart
        currentDragTarget.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
        -- 同步关联元素位置
        if currentDragTarget == titleOval then
            mainPanel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + 60)
        elseif currentDragTarget == mainPanel then
            titleOval.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset - 60)
        end
    end
end)

UserInputService.MouseMoved:Connect(function(x, y)
    if dragging and currentDragTarget then
        local delta = Vector2.new(x, y) - dragStart
        currentDragTarget.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
        if currentDragTarget == titleOval then
            mainPanel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + 60)
        elseif currentDragTarget == mainPanel then
            titleOval.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset - 60)
        end
    end
end)

-- 强制显示标题椭圆（确保用户能看到触发按钮）
pcall(function()
    titleOval.Visible = true
end)
