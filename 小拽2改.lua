local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- 全局变量初始化（仅保留功能变量）
local autofarm, autoCollectingCubes, farmMoving, keepUnanchor
-- 固定UI主色调（移除颜色自定义）
local mainColor = Color3.fromRGB(139, 101, 64)

-- 清理旧窗口（容错处理）
pcall(function()
    if LocalPlayer.PlayerGui:FindFirstChild("MobileFloatingWindow") then
        LocalPlayer.PlayerGui.MobileFloatingWindow:Destroy()
    end
end)

-- 主GUI（确保注入后能创建）
local gui = Instance.new("ScreenGui")
gui.Name = "MobileFloatingWindow"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999
gui.IgnoreGuiInset = true
-- 容错：优先PlayerGui，失败则用CoreGui
pcall(function()
    gui.Parent = LocalPlayer.PlayerGui
end)
if not gui.Parent then
    gui.Parent = CoreGui
end

-- ======================== 彩虹光带（简化版）========================
local hue = 0
RunService.RenderStepped:Connect(function(dt)
    hue = (hue + 1.2) % 360
end)

local function createRainbowBorder(parent)
    local border = Instance.new("Frame")
    border.Size = UDim2.new(1, 0, 1, 0)
    border.BackgroundTransparency = 1
    border.ZIndex = parent.ZIndex + 1
    border.Parent = parent.Parent
    border.ClipsDescendants = true

    local uiStroke = Instance.new("UIStroke", border)
    uiStroke.Thickness = 2
    uiStroke.LineJoinMode = Enum.LineJoinMode.Round
    uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Inside

    RunService.RenderStepped:Connect(function()
        uiStroke.Color = Color3.fromHSV(hue / 360, 0.9, 1)
    end)
    return border
end

-- ======================== 标题椭圆（核心触发按钮）========================
local titleOval = Instance.new("TextButton")
titleOval.Size = UDim2.new(0, 200, 0, 50)
titleOval.Position = UDim2.new(0.2, 0, 0.2, 0)
titleOval.BackgroundColor3 = mainColor
titleOval.Text = "小拽吃吃世界"
titleOval.TextColor3 = Color3.new(1,1,1)
titleOval.Font = Enum.Font.SourceSansBold
titleOval.TextSize = 18
titleOval.ZIndex = 1000
titleOval.Parent = gui
local titleCorner = Instance.new("UICorner", titleOval)
titleCorner.CornerRadius = UDim.new(0.5, 0)
createRainbowBorder(titleOval)

-- ======================== 主悬浮窗面板（窄版）========================
local mainPanel = Instance.new("Frame")
mainPanel.Size = UDim2.new(0, 300, 0, 150)
mainPanel.Position = UDim2.new(0.2, 0, 0.2, 60)
mainPanel.BackgroundColor3 = mainColor
mainPanel.BorderSizePixel = 0
mainPanel.ClipsDescendants = true
mainPanel.ZIndex = 1000
mainPanel.Visible = false
mainPanel.Parent = gui
local panelCorner = Instance.new("UICorner", mainPanel)
panelCorner.CornerRadius = UDim.new(0.3, 0)
createRainbowBorder(mainPanel)

-- 内容滚动区（简化）
local scrollFrame = Instance.new("ScrollingFrame", mainPanel)
scrollFrame.Size = UDim2.new(1, -10, 1, -10)
scrollFrame.Position = UDim2.new(0, 5, 0, 5)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 4
scrollFrame.ScrollBarImageColor3 = Color3.new(1, 1, 1)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 300)
scrollFrame.ZIndex = 1001

local menuLayout = Instance.new("UIListLayout", scrollFrame)
menuLayout.Padding = UDim.new(0, 5)
menuLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- ======================== 最小化椭圆按钮========================
local miniOval = Instance.new("TextButton", gui)
miniOval.Size = UDim2.new(0, 80, 0, 40)
miniOval.Position = UDim2.new(0.1, 0, 0.8, 0)
miniOval.BackgroundColor3 = mainColor
miniOval.Text = "-"
miniOval.TextSize = 24
miniOval.TextColor3 = Color3.new(1,1,1)
miniOval.Visible = false
miniOval.ZIndex = 1000
local miniOvalCorner = Instance.new("UICorner", miniOval)
miniOvalCorner.CornerRadius = UDim.new(0.5, 0)
createRainbowBorder(miniOval)

-- ======================== 核心功能（容错简化）========================
local function waitForInstance(parent, name, timeout)
    local start = tick()
    while not parent:FindFirstChild(name) and tick() - start < timeout do
        task.wait()
    end
    return parent:FindFirstChild(name)
end

-- 依赖项容错获取
local Events = waitForInstance(ReplicatedStorage, "Events", 3)
local SetServerSettings = Events and Events:FindFirstChild("SetServerSettings")
local PurchaseEvent = Events and Events:FindFirstChild("PurchaseEvent")
local Upgrades = LocalPlayer and waitForInstance(LocalPlayer, "Upgrades", 3)

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
end

-- ======================== 菜单创建（移除颜色相关）========================
local function createCategory(parent, title, titleColor)
    local categoryFrame = Instance.new("Frame")
    categoryFrame.Size = UDim2.new(0, 280, 0, 40)
    categoryFrame.BackgroundColor3 = mainColor:lerp(Color3.fromRGB(0,0,0), 0.2)
    categoryFrame.ZIndex = 1001
    categoryFrame.Parent = parent
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

    return {frame = categoryFrame, subMenu = subMenu}
end

local function createSubButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 260, 0, 30)
    btn.BackgroundColor3 = mainColor:lerp(Color3.fromRGB(0,0,0), 0.4)
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
        btn.BackgroundColor3 = isEnabled and Color3.fromRGB(40, 200, 100) or mainColor:lerp(Color3.fromRGB(0,0,0), 0.4)
        pcall(callback, isEnabled)
    end)
    return btn
end

-- ======================== 创建核心功能菜单（仅保留关键）========================
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

        local bedrock = Instance.new("Part")
        bedrock.Anchored = true
        bedrock.Size = Vector3.new(2048, 10, 2048)
        bedrock.Position = Vector3.new(0, -5, 0)
        bedrock.BrickColor = BrickColor.Black()
        bedrock.Parent = workspace

        local map, chunks = workspace:FindFirstChild("Map"), workspace:FindFirstChild("Chunks")
        if map and chunks then map.Parent, chunks.Parent = nil, nil end

        local function onCharAdd(char)
            local hum = char:FindFirstChild("Humanoid")
            local root = char:FindFirstChild("HumanoidRootPart")
            local size = char:FindFirstChild("Size")
            local events = char:FindFirstChild("Events")
            if not hum or not root or not size or not events then return end
            local eat = events:FindFirstChild("Eat")
            local grab = events:FindFirstChild("Grab")
            local sell = events:FindFirstChild("Sell")
            if not eat or not grab or not sell then return end

            local autoConn = RunService.Heartbeat:Connect(function(dt)
                if not autofarm then autoConn:Disconnect() return end
                pcall(function()
                    hum:ChangeState(Enum.HumanoidStateType.Physics)
                    grab:FireServer()
                    root.Anchored = false
                    eat:FireServer()

                    if size.Value >= (Upgrades and Upgrades.MaxSize and Upgrades.MaxSize.Value or 100) then
                        sell:FireServer()
                        changeMap()
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

createSubButton(autoFuncCat.subMenu, "自动收", function(enabled)
    autoCollectingCubes = enabled
    if not enabled then return end
    coroutine.wrap(function()
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
    end)()
end)

-- 2. 人物功能分类
local playerFuncCat = createCategory(scrollFrame, "人物功能", Color3.fromRGB(0, 255, 0))
createSubButton(playerFuncCat.subMenu, "取消锚固", function(enabled)
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

createSubButton(playerFuncCat.subMenu, "移动模式", function(enabled)
    farmMoving = enabled
end)

-- ======================== 点击与拖动逻辑（简化）========================
-- 单击展开/收起
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

-- 拖动功能
local dragging, currentDragTarget, dragStart, startPos = false, nil, nil, nil

local function startDrag(target, input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        currentDragTarget = target
        dragStart = input.Position or Vector2.new(input.X, input.Y)
        startPos = target.Position
    end
end

titleOval.InputBegan:Connect(function(input) startDrag(titleOval, input) end)
mainPanel.InputBegan:Connect(function(input) startDrag(mainPanel, input) end)
miniOval.InputBegan:Connect(function(input) startDrag(miniOval, input) end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
        currentDragTarget = nil
    end
end)

UserInputService.TouchMoved:Connect(function(input)
    if dragging and currentDragTarget then
        local delta = input.Position - dragStart
        currentDragTarget.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        if currentDragTarget == titleOval then
            mainPanel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + 60)
        elseif currentDragTarget == mainPanel then
            titleOval.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset - 60)
        end
    end
end)

-- 强制显示标题按钮
titleOval.Visible = true
