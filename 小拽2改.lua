-- 核心服务（新增TweenService实现缓动）
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10)

-- 强制清理旧UI
if PlayerGui:FindFirstChild("MobileFloatingWindow") then
    PlayerGui.MobileFloatingWindow:Destroy()
end

-- 全局变量
local autofarm, autoCollectingCubes, farmMoving, keepUnanchor
local mainColor = Color3.fromRGB(139, 101, 64)
local touchId = nil
local isExpanded = false -- 标记是否展开功能

-- 主GUI
local gui = Instance.new("ScreenGui")
gui.Name = "MobileFloatingWindow"
gui.ResetOnSpawn = false
gui.DisplayOrder = 9999
gui.IgnoreGuiInset = true
gui.Parent = PlayerGui

-- ======================== 标题椭圆（核心，200×50）========================
local titleOval = Instance.new("TextButton")
titleOval.Name = "TitleOval"
titleOval.Size = UDim2.new(0, 200, 0, 50)
titleOval.Position = UDim2.new(0.2, 0, 0.1, 0)
titleOval.BackgroundColor3 = mainColor
titleOval.Text = "小拽吃吃世界"
titleOval.TextColor3 = Color3.new(1,1,1)
titleOval.Font = Enum.Font.SourceSansBold
titleOval.TextSize = 18
titleOval.ZIndex = 100
titleOval.Active = true
titleOval.AutoButtonColor = false
titleOval.ClipsDescendants = true
titleOval.Parent = gui
-- 椭圆圆角
local titleCorner = Instance.new("UICorner", titleOval)
titleCorner.CornerRadius = UDim.new(0.5, 0)

-- ======================== 最小化按钮（缩小为30×30小圆，标题右侧）========================
local miniBtn = Instance.new("TextButton")
miniBtn.Name = "MiniBtn"
miniBtn.Size = UDim2.new(0, 30, 0, 30) -- 缩小为小圆
miniBtn.Position = UDim2.new(0.2, 210, 0.1, 10) -- 标题右侧10像素，垂直居中
miniBtn.BackgroundColor3 = mainColor
miniBtn.Text = "-"
miniBtn.TextColor3 = Color3.new(1,1,1)
miniBtn.Font = Enum.Font.SourceSansBold
miniBtn.TextSize = 20 -- 小号减号
miniBtn.ZIndex = 100
miniBtn.Visible = false
miniBtn.AutoButtonColor = false
miniBtn.Parent = gui
-- 圆形圆角（正圆）
local miniCorner = Instance.new("UICorner", miniBtn)
miniCorner.CornerRadius = UDim.new(0.5, 0)

-- ======================== 功能面板（紧贴标题，缓动展开）========================
local funcPanel = Instance.new("Frame")
funcPanel.Name = "FuncPanel"
funcPanel.Size = UDim2.new(0, 200, 0, 0) -- 初始高度为0，紧贴标题
funcPanel.Position = UDim2.new(0.2, 0, 0.1, 50) -- 标题下方0像素，完全紧贴
funcPanel.BackgroundColor3 = mainColor
funcPanel.ZIndex = 100
funcPanel.ClipsDescendants = true
funcPanel.Parent = gui
-- 椭圆圆角（和标题一致）
local panelCorner = Instance.new("UICorner", funcPanel)
panelCorner.CornerRadius = UDim.new(0.5, 0)

-- 滚动容器（适配缓动展开的高度）
local scrollFrame = Instance.new("ScrollingFrame", funcPanel)
scrollFrame.Size = UDim2.new(1, -5, 1, -5)
scrollFrame.Position = UDim2.new(0, 2.5, 0, 2.5)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 2
scrollFrame.ScrollBarImageColor3 = Color3.new(1,1,1)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 200)
scrollFrame.ZIndex = 101

-- 菜单布局
local menuLayout = Instance.new("UIListLayout", scrollFrame)
menuLayout.Padding = UDim.new(0, 3)
menuLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
menuLayout.VerticalAlignment = Enum.VerticalAlignment.Top

-- ======================== 功能分类（恢复分层菜单，适配小尺寸）========================
-- 创建分类函数
local function createCategory(title, titleColor)
    local catFrame = Instance.new("Frame")
    catFrame.Size = UDim2.new(0, 190, 0, 30)
    catFrame.BackgroundColor3 = mainColor:lerp(Color3.new(0,0,0), 0.2)
    catFrame.ZIndex = 101
    catFrame.Parent = scrollFrame
    local catCorner = Instance.new("UICorner", catFrame)
    catCorner.CornerRadius = UDim.new(0.1, 0)

    -- 分类标题
    local titleLabel = Instance.new("TextLabel", catFrame)
    titleLabel.Size = UDim2.new(1, -20, 1, 0)
    titleLabel.Position = UDim2.new(0, 5, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = titleColor
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.TextSize = 14
    titleLabel.ZIndex = 101

    -- 展开箭头
    local arrow = Instance.new("TextLabel", catFrame)
    arrow.Size = UDim2.new(0, 15, 0, 15)
    arrow.Position = UDim2.new(1, -18, 0.5, -7.5)
    arrow.BackgroundTransparency = 1
    arrow.Text = "v"
    arrow.TextColor3 = Color3.new(1,1,1)
    arrow.Font = Enum.Font.SourceSansBold
    arrow.TextSize = 16
    arrow.ZIndex = 101

    -- 子菜单容器
    local subMenu = Instance.new("Frame")
    subMenu.Size = UDim2.new(0, 180, 0, 0)
    subMenu.Position = UDim2.new(0, 5, 0, 35)
    subMenu.BackgroundTransparency = 1
    subMenu.ZIndex = 101
    subMenu.Parent = catFrame

    -- 子菜单布局
    local subLayout = Instance.new("UIListLayout", subMenu)
    subLayout.Padding = UDim.new(0, 2)
    subLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    -- 展开/收起逻辑
    local isCatExpanded = false
    catFrame.MouseButton1Click:Connect(function()
        isCatExpanded = not isCatExpanded
        arrow.Text = isCatExpanded and "^" or "v"
        -- 计算子菜单高度
        local totalH = 0
        for _, child in subMenu:GetChildren() do
            if child:IsA("TextButton") then totalH += child.AbsoluteSize.Y + 2 end
        end
        -- 缓动更新子菜单高度
        TweenService:Create(subMenu, TweenInfo.new(0.2), {Size = UDim2.new(0, 180, 0, isCatExpanded and totalH or 0)}):Play()
    end)

    return subMenu
end

-- 创建功能按钮函数
local function createFuncBtn(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 170, 0, 22)
    btn.BackgroundColor3 = mainColor:lerp(Color3.new(0,0,0), 0.4)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 12
    btn.ZIndex = 101
    btn.AutoButtonColor = false
    btn.Parent = parent
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0.1, 0)

    local isOn = false
    btn.MouseButton1Click:Connect(function()
        isOn = not isOn
        btn.BackgroundColor3 = isOn and Color3.fromRGB(40,200,100) or mainColor:lerp(Color3.new(0,0,0), 0.4)
        pcall(callback, isOn)
    end)
    return btn
end

-- 1. 自动功能分类
local autoSub = createCategory("自动功能", Color3.fromRGB(255,165,0))
createFuncBtn(autoSub, "自动刷", function(enabled)
    autofarm = enabled
    if not enabled then return end
    coroutine.wrap(function()
        local bedrock = Instance.new("Part")
        bedrock.Anchored = true
        bedrock.Size = Vector3.new(2048,10,2048)
        bedrock.Position = Vector3.new(0,-5,0)
        bedrock.Parent = workspace

        local function onChar(char)
            local hum = char:WaitForChild("Humanoid",5)
            local root = char:WaitForChild("HumanoidRootPart",5)
            local size = char:WaitForChild("Size",5)
            local events = char:WaitForChild("Events",5)
            if not hum or not root or not size or not events then return end
            local eat = events:WaitForChild("Eat",5)
            local grab = events:WaitForChild("Grab",5)
            local sell = events:WaitForChild("Sell",5)
            if not eat or not grab or not sell then return end

            local conn = RunService.Heartbeat:Connect(function()
                if not autofarm then conn:Disconnect() return end
                pcall(function()
                    hum:ChangeState(Enum.HumanoidStateType.Physics)
                    grab:FireServer()
                    root.Anchored = false
                    eat:FireServer()
                    local maxSize = LocalPlayer.Upgrades and LocalPlayer.Upgrades.MaxSize and LocalPlayer.Upgrades.MaxSize.Value or 100
                    if size.Value >= maxSize then sell:FireServer() game:GetService("ReplicatedStorage").Events.SetServerSettings:FireServer({MapTime=-1,Paused=true}) end
                end)
            end)
            hum.Died:Connect(function() conn:Disconnect() end)
        end

        if LocalPlayer.Character then onChar(LocalPlayer.Character) end
        LocalPlayer.CharacterAdded:Connect(onChar)
        while autofarm do task.wait() end
        bedrock:Destroy()
    end)()
end)
createFuncBtn(autoSub, "自动收", function(enabled)
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
                        if owner == LocalPlayer.Name or owner == "" then pcall(function() v.CFrame = root.CFrame end) end
                    end
                end
            end
        end
    end)()
end)

-- 2. 人物功能分类
local playerSub = createCategory("人物功能", Color3.fromRGB(0,255,0))
createFuncBtn(playerSub, "取消锚固", function(enabled)
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
createFuncBtn(playerSub, "移动模式", function(enabled)
    farmMoving = enabled
end)

-- ======================== 缓动展开/收起功能面板（核心需求）========================
local function toggleFuncPanel()
    isExpanded = not isExpanded
    titleOval.Visible = not isExpanded
    miniBtn.Visible = isExpanded
    -- 缓动动画：Y轴偏移+高度增加（缓慢向下展开）
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    if isExpanded then
        TweenService:Create(funcPanel, tweenInfo, {
            Size = UDim2.new(0, 200, 0, 150), -- 展开后高度150
            Position = UDim2.new(0.2, 0, 0.1, 50) -- 紧贴标题下方
        }):Play()
    else
        TweenService:Create(funcPanel, tweenInfo, {
            Size = UDim2.new(0, 200, 0, 0), -- 收起后高度0
            Position = UDim2.new(0.2, 0, 0.1, 50)
        }):Play()
    end
end

-- 标题点击触发缓动展开
titleOval.MouseButton1Click:Connect(toggleFuncPanel)
-- 最小化按钮点击触发缓动收起
miniBtn.MouseButton1Click:Connect(toggleFuncPanel)

-- ======================== 触摸拖动（同步标题/面板/最小化按钮）========================
local dragTarget = nil
local startPos = Vector2.new(0,0)
local elemStartPos = UDim2.new(0,0,0,0)

UserInputService.TouchStarted:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        local uiPos = input.Position
        local target = gui:FindFirstChildWhichIsA("GuiObject", true)
        if not target then return end
        local absPos = target.AbsolutePosition
        local absSize = target.AbsoluteSize
        if uiPos.X >= absPos.X and uiPos.X <= absPos.X+absSize.X and uiPos.Y >= absPos.Y and uiPos.Y <= absPos.Y+absSize.Y then
            touchId = input.UserInputId
            dragTarget = target
            startPos = uiPos
            elemStartPos = target.Position
        end
    end
end)

UserInputService.TouchMoved:Connect(function(input)
    if input.UserInputId == touchId and dragTarget then
        local delta = input.Position - startPos
        dragTarget.Position = UDim2.new(0, elemStartPos.X.Offset+delta.X, 0, elemStartPos.Y.Offset+delta.Y)
        -- 同步关联元素
        if dragTarget == titleOval then
            funcPanel.Position = UDim2.new(0, elemStartPos.X.Offset+delta.X, 0, elemStartPos.Y.Offset+delta.Y+50)
            miniBtn.Position = UDim2.new(0, elemStartPos.X.Offset+delta.X+210, 0, elemStartPos.Y.Offset+delta.Y+10)
        elseif dragTarget == funcPanel then
            titleOval.Position = UDim2.new(0, elemStartPos.X.Offset+delta.X, 0, elemStartPos.Y.Offset+delta.Y-50)
            miniBtn.Position = UDim2.new(0, elemStartPos.X.Offset+delta.X+210, 0, elemStartPos.Y.Offset+delta.Y-40)
        elseif dragTarget == miniBtn then
            titleOval.Position = UDim2.new(0, elemStartPos.X.Offset+delta.X-210, 0, elemStartPos.Y.Offset+delta.Y-10)
            funcPanel.Position = UDim2.new(0, elemStartPos.X.Offset+delta.X-210, 0, elemStartPos.Y.Offset+delta.Y+40)
        end
    end
end)

UserInputService.TouchEnded:Connect(function(input)
    if input.UserInputId == touchId then
        touchId = nil
        dragTarget = nil
    end
end)

-- ======================== 初始化状态========================
titleOval.Visible = true
miniBtn.Visible = false
funcPanel.Size = UDim2.new(0,200,0,0)
-- 清理极小元素避免线条
for _, child in gui:GetChildren() do
    if child:IsA("Frame") and (child.Size.X.Offset <5 or child.Size.Y.Offset <5) then child:Destroy() end
end
