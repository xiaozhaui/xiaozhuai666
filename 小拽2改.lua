-- 核心服务（保留完整功能所需）
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10)

-- 彻底清理旧UI（避免残留冲突）
if PlayerGui:FindFirstChild("MobileFloatingWindow") then
    PlayerGui.MobileFloatingWindow:Destroy()
end

-- 全局变量（保留所有功能开关）
local autofarm, autoCollectingCubes, farmMoving, keepUnanchor, autoUpgradeSize, autoUpgradeSpd
local mainColor = Color3.fromRGB(139, 101, 64)
local isPanelOpen = false -- 单一状态标记，避免冲突

-- 主GUI（层级置顶，无遮挡）
local gui = Instance.new("ScreenGui")
gui.Name = "MobileFloatingWindow"
gui.ResetOnSpawn = false
gui.DisplayOrder = 99999 -- 超置顶，杜绝遮挡
gui.IgnoreGuiInset = true
gui.Parent = PlayerGui

-- ======================== 触发按钮（160×40，紧凑尺寸，手指可点）========================
local triggerBtn = Instance.new("TextButton")
triggerBtn.Name = "TriggerBtn"
triggerBtn.Size = UDim2.new(0, 160, 0, 40) -- 紧凑尺寸，不占空间
triggerBtn.Position = UDim2.new(0.2, 0, 0.1, 0)
triggerBtn.BackgroundColor3 = mainColor
triggerBtn.Text = "小拽吃吃世界"
triggerBtn.TextColor3 = Color3.new(1,1,1)
triggerBtn.Font = Enum.Font.SourceSansBold
triggerBtn.TextSize = 15
triggerBtn.ZIndex = 100
triggerBtn.Active = true -- 强制启用交互
triggerBtn.Selectable = true -- 确保移动端识别
triggerBtn.AutoButtonColor = false
triggerBtn.Parent = gui
-- 椭圆圆角（贴合按钮尺寸）
local triggerCorner = Instance.new("UICorner", triggerBtn)
triggerCorner.CornerRadius = UDim.new(0.5, 0)

-- ======================== 最小化按钮（22×22，迷你圆，触发按钮右侧）========================
local miniBtn = Instance.new("TextButton")
miniBtn.Name = "MiniBtn"
miniBtn.Size = UDim2.new(0, 22, 0, 22) -- 迷你尺寸，不突兀
miniBtn.Position = UDim2.new(0.2, 170, 0.1, 9) -- 触发按钮右侧10像素，垂直居中
miniBtn.BackgroundColor3 = mainColor
miniBtn.Text = "-"
miniBtn.TextColor3 = Color3.new(1,1,1)
miniBtn.Font = Enum.Font.SourceSansBold
miniBtn.TextSize = 14
miniBtn.ZIndex = 100
miniBtn.Visible = false
miniBtn.Active = true
miniBtn.Selectable = true
miniBtn.AutoButtonColor = false
miniBtn.Parent = gui
-- 正圆圆角
local miniCorner = Instance.new("UICorner", miniBtn)
miniCorner.CornerRadius = UDim.new(0.5, 0)

-- ======================== 功能面板（160×120，和触发按钮同宽，紧凑不拥挤）========================
local funcPanel = Instance.new("Frame")
funcPanel.Name = "FuncPanel"
funcPanel.Size = UDim2.new(0, 160, 0, 0) -- 初始高度0，完全紧贴触发按钮
funcPanel.Position = UDim2.new(0.2, 0, 0.1, 40) -- 触发按钮下方0像素，无间隙
funcPanel.BackgroundColor3 = mainColor
funcPanel.ZIndex = 100
funcPanel.ClipsDescendants = true
funcPanel.Parent = gui
-- 椭圆圆角（和触发按钮一致）
local panelCorner = Instance.new("UICorner", funcPanel)
panelCorner.CornerRadius = UDim.new(0.5, 0)

-- 功能面板内容容器（带内边距）
local contentFrame = Instance.new("Frame", funcPanel)
contentFrame.Size = UDim2.new(1, -8, 1, -8)
contentFrame.Position = UDim2.new(0, 4, 0, 4)
contentFrame.BackgroundTransparency = 1
contentFrame.ZIndex = 101

-- 菜单布局（垂直排列，紧凑间距）
local menuLayout = Instance.new("UIListLayout", contentFrame)
menuLayout.Padding = UDim.new(0, 4)
menuLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
menuLayout.VerticalAlignment = Enum.VerticalAlignment.Top

-- ======================== 功能分类与按钮（完整功能，适配紧凑面板）========================
-- 创建分类标题（简洁样式）
local function createCategoryTitle(text, color)
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0, 140, 0, 18)
    title.BackgroundTransparency = 1
    title.Text = text
    title.TextColor3 = color
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 12
    title.ZIndex = 101
    title.Parent = contentFrame
    return title
end

-- 创建功能按钮（75×22，紧凑尺寸，一行两个）
local function createFuncButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 75, 0, 22)
    btn.BackgroundColor3 = mainColor:lerp(Color3.new(0,0,0), 0.4)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 10
    btn.ZIndex = 101
    btn.Active = true
    btn.Selectable = true
    btn.AutoButtonColor = false
    btn.Parent = contentFrame
    -- 圆角
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0.2, 0)

    -- 点击逻辑（明确状态切换）
    local isEnabled = false
    btn.MouseButton1Click:Connect(function()
        isEnabled = not isEnabled
        btn.BackgroundColor3 = isEnabled and Color3.fromRGB(40, 200, 100) or mainColor:lerp(Color3.new(0,0,0), 0.4)
        pcall(callback, isEnabled)
    end)
    return btn
end

-- 创建按钮行（一行两个按钮，紧凑排列）
local function createBtnRow(btn1Text, btn1Callback, btn2Text, btn2Callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(0, 150, 0, 22)
    row.BackgroundTransparency = 1
    row.ZIndex = 101
    row.Parent = contentFrame

    local layout = Instance.new("UIListLayout", row)
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.Padding = UDim.new(0, 5)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    createFuncButton(btn1Text, btn1Callback).Parent = row
    createFuncButton(btn2Text, btn2Callback).Parent = row
end

-- 1. 自动功能分类
createCategoryTitle("自动功能", Color3.fromRGB(255, 165, 0))
createBtnRow("自动刷", function(enabled)
    autofarm = enabled
    if not enabled then return end
    coroutine.wrap(function()
        local bedrock = Instance.new("Part")
        bedrock.Anchored = true
        bedrock.Size = Vector3.new(2048, 10, 2048)
        bedrock.Position = Vector3.new(0, -5, 0)
        bedrock.Parent = workspace

        local Events = ReplicatedStorage:FindFirstChild("Events") or ReplicatedStorage:WaitForChild("Events", 5)
        local SetServerSettings = Events and Events:FindFirstChild("SetServerSettings")

        local function onCharacter(char)
            local hum = char:WaitForChild("Humanoid", 5)
            local root = char:WaitForChild("HumanoidRootPart", 5)
            local size = char:WaitForChild("Size", 5)
            local events = char:WaitForChild("Events", 5)
            if not hum or not root or not size or not events then return end

            local eat = events:WaitForChild("Eat", 5)
            local grab = events:WaitForChild("Grab", 5)
            local sell = events:WaitForChild("Sell", 5)
            if not eat or not grab or not sell then return end

            local conn = RunService.Heartbeat:Connect(function()
                if not autofarm then conn:Disconnect() return end
                pcall(function()
                    hum:ChangeState(Enum.HumanoidStateType.Physics)
                    grab:FireServer()
                    root.Anchored = false
                    eat:FireServer()

                    local maxSize = LocalPlayer.Upgrades and LocalPlayer.Upgrades.MaxSize and LocalPlayer.Upgrades.MaxSize.Value or 100
                    if size.Value >= maxSize then
                        sell:FireServer()
                        if SetServerSettings then
                            SetServerSettings:FireServer({MapTime = -1, Paused = true})
                        end
                    end
                end)
            end)

            hum.Died:Connect(function()
                if conn then conn:Disconnect() end
                if SetServerSettings then
                    SetServerSettings:FireServer({MapTime = -1, Paused = true})
                end
            end)
        end

        if LocalPlayer.Character then
            onCharacter(LocalPlayer.Character)
        end
        LocalPlayer.CharacterAdded:Connect(onCharacter)

        while autofarm do
            task.wait()
        end
        bedrock:Destroy()
    end)()
end, "自动收", function(enabled)
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
                            pcall(function()
                                v.CFrame = root.CFrame
                            end)
                        end
                    end
                end
            end
        end
    end)()
end)

-- 2. 人物功能分类
createCategoryTitle("人物功能", Color3.fromRGB(0, 255, 0))
createBtnRow("取消锚固", function(enabled)
    keepUnanchor = enabled
    if not enabled then return end
    coroutine.wrap(function()
        while keepUnanchor do
            task.wait()
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                root.Anchored = false
            end
        end
    end)()
end, "移动模式", function(enabled)
    farmMoving = enabled
end)

-- 3. 升级功能分类
createCategoryTitle("升级功能", Color3.fromRGB(100, 149, 237))
createBtnRow("升级大小", function(enabled)
    autoUpgradeSize = enabled
    if not enabled then return end
    coroutine.wrap(function()
        local Events = ReplicatedStorage:FindFirstChild("Events")
        local PurchaseEvent = Events and Events:FindFirstChild("PurchaseEvent")
        if not PurchaseEvent then return end

        game.CoreGui.PurchasePromptApp.Enabled = false
        while autoUpgradeSize do
            task.wait(1)
            pcall(function()
                PurchaseEvent:FireServer("MaxSize")
            end)
        end
        game.CoreGui.PurchasePromptApp.Enabled = true
    end)()
end, "升级移速", function(enabled)
    autoUpgradeSpd = enabled
    if not enabled then return end
    coroutine.wrap(function()
        local Events = ReplicatedStorage:FindFirstChild("Events")
        local PurchaseEvent = Events and Events:FindFirstChild("PurchaseEvent")
        if not PurchaseEvent then return end

        game.CoreGui.PurchasePromptApp.Enabled = false
        while autoUpgradeSpd do
            task.wait(1)
            pcall(function()
                PurchaseEvent:FireServer("Speed")
            end)
        end
        game.CoreGui.PurchasePromptApp.Enabled = true
    end)()
end)

-- ======================== 修复点击展开/收起（无动画冲突，明确逻辑）========================
local function togglePanel()
    isPanelOpen = not isPanelOpen
    -- 直接修改高度，避免动画导致的点击失效
    if isPanelOpen then
        funcPanel.Size = UDim2.new(0, 160, 0, 120) -- 展开后高度120，紧凑不拥挤
        triggerBtn.Visible = false
        miniBtn.Visible = true
    else
        funcPanel.Size = UDim2.new(0, 160, 0, 0) -- 收起后高度0，完全隐藏
        triggerBtn.Visible = true
        miniBtn.Visible = false
    end
end

-- 双重绑定点击事件，确保触发（PC+移动端）
triggerBtn.MouseButton1Click:Connect(togglePanel)
miniBtn.MouseButton1Click:Connect(togglePanel)
triggerBtn.TouchTap:Connect(togglePanel)
miniBtn.TouchTap:Connect(togglePanel)

-- ======================== 修复拖动功能（简洁逻辑，同步位置）========================
local dragTarget = nil
local startPos = Vector2.new(0, 0)
local elemStartPos = UDim2.new(0, 0, 0, 0)

UserInputService.TouchStarted:Connect(function(input)
    if input.UserInputType ~= Enum.UserInputType.Touch then return end
    local touchPos = input.Position

    -- 判断触摸是否命中UI元素
    local function isTouchOnElem(elem)
        local absPos = elem.AbsolutePosition
        local absSize = elem.AbsoluteSize
        return touchPos.X >= absPos.X and touchPos.X <= absPos.X + absSize.X and
               touchPos.Y >= absPos.Y and touchPos.Y <= absPos.Y + absSize.Y
    end

    if isTouchOnElem(triggerBtn) then
        dragTarget = triggerBtn
    elseif isTouchOnElem(miniBtn) then
        dragTarget = miniBtn
    elseif isTouchOnElem(funcPanel) then
        dragTarget = funcPanel
    else
        return
    end

    startPos = touchPos
    elemStartPos = dragTarget.Position
end)

UserInputService.TouchMoved:Connect(function(input)
    if not dragTarget or input.UserInputType ~= Enum.UserInputType.Touch then return end
    local delta = input.Position - startPos

    -- 更新拖动元素位置
    dragTarget.Position = UDim2.new(
        0, elemStartPos.X.Offset + delta.X,
        0, elemStartPos.Y.Offset + delta.Y
    )

    -- 同步关联元素位置
    if dragTarget == triggerBtn then
        funcPanel.Position = UDim2.new(0, elemStartPos.X.Offset + delta.X, 0, elemStartPos.Y.Offset + delta.Y + 40)
        miniBtn.Position = UDim2.new(0, elemStartPos.X.Offset + delta.X + 170, 0, elemStartPos.Y.Offset + delta.Y + 9)
    elseif dragTarget == miniBtn then
        triggerBtn.Position = UDim2.new(0, elemStartPos.X.Offset + delta.X - 170, 0, elemStartPos.Y.Offset + delta.Y - 9)
        funcPanel.Position = UDim2.new(0, elemStartPos.X.Offset + delta.X - 170, 0, elemStartPos.Y.Offset + delta.Y + 31)
    elseif dragTarget == funcPanel then
        triggerBtn.Position = UDim2.new(0, elemStartPos.X.Offset + delta.X, 0, elemStartPos.Y.Offset + delta.Y - 40)
        miniBtn.Position = UDim2.new(0, elemStartPos.X.Offset + delta.X + 170, 0, elemStartPos.Y.Offset + delta.Y - 31)
    end
end)

UserInputService.TouchEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragTarget = nil
    end
end)

-- ======================== 初始化状态（确保点击有效）========================
triggerBtn.Visible = true
miniBtn.Visible = false
funcPanel.Size = UDim2.new(0, 160, 0, 0)
-- 强制激活所有按钮交互
for _, btn in contentFrame:GetDescendants() do
    if btn:IsA("TextButton") then
        btn.Active = true
        btn.Selectable = true
    end
end
