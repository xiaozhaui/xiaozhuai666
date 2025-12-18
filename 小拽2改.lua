local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- 全局变量初始化
local autofarm, autoCollectingCubes, farmMoving, keepUnanchor
-- 固定UI色调
local mainColor = Color3.fromRGB(139, 101, 64)

-- 清理旧窗口（容错）
pcall(function()
    if LocalPlayer.PlayerGui:FindFirstChild("MobileFloatingWindow") then
        LocalPlayer.PlayerGui.MobileFloatingWindow:Destroy()
    end
end)

-- 主GUI创建
local gui = Instance.new("ScreenGui")
gui.Name = "MobileFloatingWindow"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999
gui.IgnoreGuiInset = true
-- 父级容错
pcall(function()
    gui.Parent = LocalPlayer.PlayerGui
end)
if not gui.Parent then
    gui.Parent = CoreGui
end

-- ======================== 彩虹光带（保留）========================
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

-- ======================== 标题椭圆（200×50，核心触发）========================
local titleOval = Instance.new("TextButton")
titleOval.Name = "TitleOval"
titleOval.Size = UDim2.new(0, 200, 0, 50)  -- 标题尺寸
titleOval.Position = UDim2.new(0.2, 0, 0.2, 0)
titleOval.BackgroundColor3 = mainColor
titleOval.Text = "小拽吃吃世界"
titleOval.TextColor3 = Color3.new(1,1,1)
titleOval.Font = Enum.Font.SourceSansBold
titleOval.TextSize = 18
titleOval.ZIndex = 1002  -- 提高层级避免遮挡
titleOval.AutoButtonColor = false  -- 关闭自动变色防止干扰
titleOval.Parent = gui
-- 椭圆圆角
local titleCorner = Instance.new("UICorner", titleOval)
titleCorner.CornerRadius = UDim.new(0.5, 0)
-- 彩虹光带
createRainbowBorder(titleOval)

-- ======================== 主悬浮窗面板（220×80，仅比标题大一点）========================
local mainPanel = Instance.new("Frame")
mainPanel.Name = "MainPanel"
mainPanel.Size = UDim2.new(0, 220, 0, 80)  -- 比标题宽20、高30
mainPanel.Position = UDim2.new(0.2, -10, 0.2, 60)  -- 与标题对齐，下方偏移60
mainPanel.BackgroundColor3 = mainColor
mainPanel.BorderSizePixel = 0
mainPanel.ClipsDescendants = true
mainPanel.ZIndex = 1002
mainPanel.Visible = false  -- 默认隐藏
mainPanel.Parent = gui
-- 椭圆圆角
local panelCorner = Instance.new("UICorner", mainPanel)
panelCorner.CornerRadius = UDim.new(0.4, 0)
-- 彩虹光带
createRainbowBorder(mainPanel)

-- 内容滚动区（适配小尺寸）
local scrollFrame = Instance.new("ScrollingFrame", mainPanel)
scrollFrame.Size = UDim2.new(1, -8, 1, -8)
scrollFrame.Position = UDim2.new(0, 4, 0, 4)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 3
scrollFrame.ScrollBarImageColor3 = Color3.new(1, 1, 1)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 200)
scrollFrame.ZIndex = 1003
scrollFrame.ScrollBarBackgroundTransparency = 1

-- 菜单布局
local menuLayout = Instance.new("UIListLayout", scrollFrame)
menuLayout.Padding = UDim.new(0, 3)
menuLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
menuLayout.VerticalAlignment = Enum.VerticalAlignment.Top

-- ======================== 最小化椭圆（90×40，小尺寸）========================
local miniOval = Instance.new("TextButton")
miniOval.Name = "MiniOval"
miniOval.Size = UDim2.new(0, 90, 0, 40)  -- 小尺寸最小化按钮
miniOval.Position = UDim2.new(0.1, 0, 0.8, 0)
miniOval.BackgroundColor3 = mainColor
miniOval.Text = "-"
miniOval.TextSize = 22
miniOval.TextColor3 = Color3.new(1,1,1)
miniOval.ZIndex = 1002
miniOval.Visible = false
miniOval.AutoButtonColor = false
miniOval.Parent = gui
-- 椭圆圆角
local miniOvalCorner = Instance.new("UICorner", miniOval)
miniOvalCorner.CornerRadius = UDim.new(0.5, 0)
-- 彩虹光带
createRainbowBorder(miniOval)

-- ======================== 核心功能（容错+完整逻辑）========================
-- 实例等待函数
local function waitForInstance(parent, name, timeout)
    local start = tick()
    while not parent:FindFirstChild(name) and tick() - start < timeout do
        task.wait()
    end
    return parent:FindFirstChild(name)
end

-- 依赖项获取
local Events = waitForInstance(ReplicatedStorage, "Events", 3)
local SetServerSettings = Events and Events:FindFirstChild("SetServerSettings")
local PurchaseEvent = Events and Events:FindFirstChild("PurchaseEvent")
local Upgrades = LocalPlayer and waitForInstance(LocalPlayer, "Upgrades", 3)

-- 工具函数
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

-- ======================== 菜单创建（适配小尺寸）========================
-- 创建分类按钮
local function createCategory(parent, title, titleColor)
    local categoryFrame = Instance.new("Frame")
    categoryFrame.Size = UDim2.new(0, 200, 0, 30)  -- 小尺寸分类框
    categoryFrame.BackgroundColor3 = mainColor:lerp(Color3.fromRGB(0,0,0), 0.2)
    categoryFrame.ZIndex = 1003
    categoryFrame.Parent = parent
    -- 圆角
    local categoryCorner = Instance.new("UICorner", categoryFrame)
    categoryCorner.CornerRadius = UDim.new(0.1, 0)

    -- 分类标题
    local titleLabel = Instance.new("TextLabel", categoryFrame)
    titleLabel.Size = UDim2.new(1, -25, 1, 0)
    titleLabel.Position = UDim2.new(0, 5, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = titleColor
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.TextSize = 14  -- 小字体适配
    titleLabel.ZIndex = 1003

    -- 展开箭头
    local arrow = Instance.new("TextLabel", categoryFrame)
    arrow.Size = UDim2.new(0, 15, 0, 15)
    arrow.Position = UDim2.new(1, -20, 0.5, -7.5)
    arrow.BackgroundTransparency = 1
    arrow.Text = "v"
    arrow.TextColor3 = Color3.new(1,1,1)
    arrow.Font = Enum.Font.SourceSansBold
    arrow.TextSize = 16
    arrow.ZIndex = 1003

    -- 子菜单容器
    local subMenu = Instance.new("Frame")
    subMenu.Size = UDim2.new(0, 190, 0, 0)
    subMenu.Position = UDim2.new(0, 5, 0, 35)
    subMenu.BackgroundTransparency = 1
    subMenu.ZIndex = 1003
    subMenu.Parent = categoryFrame

    -- 子菜单布局
    local subLayout = Instance.new("UIListLayout", subMenu)
    subLayout.Padding = UDim.new(0, 2)
    subLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    -- 展开/收起逻辑（修复点击）
    local isExpanded = false
    categoryFrame.MouseButton1Click:Connect(function()
        isExpanded = not isExpanded
        arrow.Text = isExpanded and "^" or "v"
        -- 计算子菜单高度
        local totalHeight = 0
        for _, child in subMenu:GetChildren() do
            if child:IsA("TextButton") then
                totalHeight += child.AbsoluteSize.Y + 2
            end
        end
        subMenu.Size = UDim2.new(0, 190, 0, isExpanded and totalHeight or 0)
    end)

    return {frame = categoryFrame, subMenu = subMenu}
end

-- 创建功能按钮
local function createSubButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 180, 0, 25)  -- 小尺寸功能按钮
    btn.BackgroundColor3 = mainColor:lerp(Color3.fromRGB(0,0,0), 0.4)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Text = text
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 12  -- 小字体
    btn.ZIndex = 1003
    btn.AutoButtonColor = false  -- 关闭自动变色
    btn.Parent = parent
    -- 圆角
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0.1, 0)

    -- 开关逻辑
    local isEnabled = false
    btn.MouseButton1Click:Connect(function()
        isEnabled = not isEnabled
        -- 颜色反馈
        btn.BackgroundColor3 = isEnabled and Color3.fromRGB(40, 200, 100) or mainColor:lerp(Color3.fromRGB(0,0,0), 0.4)
        -- 执行回调（容错）
        pcall(callback, isEnabled)
    end)
    return btn
end

-- ======================== 创建功能菜单（完整）========================
-- 1. 自动功能分类
local autoFuncCat = createCategory(scrollFrame, "自动功能", Color3.fromRGB(255, 165, 0))
-- 自动刷
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

        -- 创建基础部件
        local bedrock = Instance.new("Part")
        bedrock.Anchored = true
        bedrock.Size = Vector3.new(2048, 10, 2048)
        bedrock.Position = Vector3.new(0, -5, 0)
        bedrock.BrickColor = BrickColor.Black()
        bedrock.Parent = workspace

        -- 地图暂存
        local map, chunks = workspace:FindFirstChild("Map"), workspace:FindFirstChild("Chunks")
        if map and chunks then map.Parent, chunks.Parent = nil, nil end

        -- 角色加载处理
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

            -- 心跳更新
            local autoConn = RunService.Heartbeat:Connect(function(dt)
                if not autofarm then autoConn:Disconnect() return end
                pcall(function()
                    hum:ChangeState(Enum.HumanoidStateType.Physics)
                    grab:FireServer()
                    root.Anchored = false
                    eat:FireServer()

                    -- 自动售卖
                    local maxSize = Upgrades and Upgrades.MaxSize and Upgrades.MaxSize.Value or 100
                    if size.Value >= maxSize then
                        sell:FireServer()
                        changeMap()
                    end
                end)
            end)

            -- 角色死亡处理
            hum.Died:Connect(function()
                if autoConn then autoConn:Disconnect() end
                changeMap()
            end)

            -- 关闭原生逻辑
            pcall(function()
                char:FindFirstChild("LocalChunkManager").Enabled = false
                char:FindFirstChild("Animate").Enabled = false
            end)
        end

        -- 绑定角色加载
        if LocalPlayer.Character then
            task.spawn(onCharAdd, LocalPlayer.Character)
        end
        LocalPlayer.CharacterAdded:Connect(onCharAdd)

        -- 主循环
        while autofarm do
            task.wait()
            pcall(function()
                if workspace:FindFirstChild("Loading") then workspace.Loading:Destroy() end
            end)
        end

        -- 清理资源
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
createSubButton(autoFuncCat.subMenu, "自动收", function(enabled)
    autoCollectingCubes = enabled
    if not enabled then return end
    coroutine.wrap(function()
        while autoCollectingCubes do
            task.wait()
            local root = getRoot()
            if root then
                for _, v in workspace:GetChildren() do
                    if v.Name == "Cube" and v:FindFirstChild("Owner") then
                        local owner = v.Owner.Value
                        if owner == LocalPlayer.Name or owner == "" then
                            v.CFrame = root.CFrame
                        end
                    end
                end
            end
        end
    end)()
end)

-- 2. 人物功能分类
local playerFuncCat = createCategory(scrollFrame, "人物功能", Color3.fromRGB(0, 255, 0))
-- 取消锚固
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

-- 移动模式
createSubButton(playerFuncCat.subMenu, "移动模式", function(enabled)
    farmMoving = enabled
end)

-- ======================== 修复点击逻辑（核心）========================
-- 标题椭圆点击：展开主面板
titleOval.MouseButton1Click:Connect(function()
    mainPanel.Visible = true
    titleOval.Visible = false
    miniOval.Visible = true
    print("标题椭圆点击，展开主面板") -- 调试用，可删除
end)

-- 最小化椭圆点击：收起主面板
miniOval.MouseButton1Click:Connect(function()
    mainPanel.Visible = false
    miniOval.Visible = false
    titleOval.Visible = true
    print("最小化椭圆点击，收起主面板") -- 调试用，可删除
end)

-- ======================== 修复拖动逻辑（核心）========================
local dragging = false
local currentDragTarget = nil
local dragStartPos = Vector2.new(0, 0)
local elementStartPos = UDim2.new(0, 0, 0, 0)

-- 开始拖动
local function startDrag(input, target)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        currentDragTarget = target
        dragStartPos = input.Position -- 记录点击位置
        elementStartPos = target.Position -- 记录元素初始位置
        print("开始拖动：", target.Name) -- 调试用，可删除
    end
end

-- 绑定拖动开始事件
titleOval.InputBegan:Connect(function(input)
    startDrag(input, titleOval)
end)

mainPanel.InputBegan:Connect(function(input)
    startDrag(input, mainPanel)
end)

miniOval.InputBegan:Connect(function(input)
    startDrag(input, miniOval)
end)

-- 结束拖动
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
        currentDragTarget = nil
        print("结束拖动") -- 调试用，可删除
    end
end)

-- 拖动更新（触摸+鼠标）
UserInputService.TouchMoved:Connect(function(input)
    if dragging and currentDragTarget then
        local delta = input.Position - dragStartPos -- 计算偏移
        -- 更新元素位置
        currentDragTarget.Position = UDim2.new(
            elementStartPos.X.Scale,
            elementStartPos.X.Offset + delta.X,
            elementStartPos.Y.Scale,
            elementStartPos.Y.Offset + delta.Y
        )
        -- 同步关联元素位置
        if currentDragTarget == titleOval then
            mainPanel.Position = UDim2.new(
                elementStartPos.X.Scale,
                elementStartPos.X.Offset + delta.X,
                elementStartPos.Y.Scale,
                elementStartPos.Y.Offset + 60 + delta.Y
            )
        elseif currentDragTarget == mainPanel then
            titleOval.Position = UDim2.new(
                elementStartPos.X.Scale,
                elementStartPos.X.Offset + delta.X,
                elementStartPos.Y.Scale,
                elementStartPos.Y.Offset - 60 + delta.Y
            )
        end
    end
end)

-- 鼠标拖动适配
UserInputService.MouseMoved:Connect(function(x, y)
    if dragging and currentDragTarget and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        local mousePos = Vector2.new(x, y)
        local delta = mousePos - dragStartPos
        currentDragTarget.Position = UDim2.new(
            elementStartPos.X.Scale,
            elementStartPos.X.Offset + delta.X,
            elementStartPos.Y.Scale,
            elementStartPos.Y.Offset + delta.Y
        )
        if currentDragTarget == titleOval then
            mainPanel.Position = UDim2.new(
                elementStartPos.X.Scale,
                elementStartPos.X.Offset + delta.X,
                elementStartPos.Y.Scale,
                elementStartPos.Y.Offset + 60 + delta.Y
            )
        elseif currentDragTarget == mainPanel then
            titleOval.Position = UDim2.new(
                elementStartPos.X.Scale,
                elementStartPos.X.Offset + delta.X,
                elementStartPos.Y.Scale,
                elementStartPos.Y.Offset - 60 + delta.Y
            )
        end
    end
end)

-- ======================== 强制显示标题椭圆 ========================
titleOval.Visible = true
print("脚本加载完成，标题椭圆已显示") -- 调试用，可删除
