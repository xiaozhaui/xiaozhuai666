-- 核心服务获取
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10)

-- 强制清理旧UI
if PlayerGui:FindFirstChild("MobileFloatingWindow") then
    PlayerGui.MobileFloatingWindow:Destroy()
end

-- 全局变量（恢复所有功能）
local autofarm, autoCollectingCubes, farmMoving, keepUnanchor, autoUpgradeSize, autoUpgradeSpd
local mainColor = Color3.fromRGB(139, 101, 64)
local touchId = nil

-- 主GUI（无多余层级）
local gui = Instance.new("ScreenGui")
gui.Name = "MobileFloatingWindow"
gui.ResetOnSpawn = false
gui.DisplayOrder = 9999
gui.IgnoreGuiInset = true
gui.Parent = PlayerGui

-- ======================== 标题容器（实现包裹感，仅比文字大一点）========================
-- 外层包裹框（210×60，比文字椭圆大10像素，形成包裹）
local wrapFrame = Instance.new("Frame")
wrapFrame.Name = "WrapFrame"
wrapFrame.Size = UDim2.new(0, 210, 0, 60) -- 仅比内部文字椭圆大10像素
wrapFrame.Position = UDim2.new(0.2, 0, 0.1, 0)
wrapFrame.BackgroundColor3 = mainColor:lerp(Color3.new(0,0,0), 0.1) -- 浅底色显包裹
wrapFrame.ZIndex = 99
wrapFrame.ClipsDescendants = true
wrapFrame.Parent = gui
-- 包裹框椭圆圆角
local wrapCorner = Instance.new("UICorner", wrapFrame)
wrapCorner.CornerRadius = UDim.new(0.5, 0)

-- 内部文字椭圆（200×50，核心触发）
local titleOval = Instance.new("TextButton")
titleOval.Name = "TitleOval"
titleOval.Size = UDim2.new(0, 200, 0, 50)
titleOval.Position = UDim2.new(0.5, -100, 0.5, -25) -- 居中在包裹框内
titleOval.BackgroundColor3 = mainColor
titleOval.Text = "小拽吃吃世界"
titleOval.TextColor3 = Color3.new(1,1,1)
titleOval.Font = Enum.Font.SourceSansBold
titleOval.TextSize = 18
titleOval.ZIndex = 100
titleOval.Active = true
titleOval.AutoButtonColor = false
titleOval.Parent = wrapFrame
-- 文字椭圆圆角
local titleCorner = Instance.new("UICorner", titleOval)
titleCorner.CornerRadius = UDim.new(0.5, 0)

-- ======================== 最小化按钮（标题右侧，圆形包裹+白色减号）========================
local miniBtn = Instance.new("TextButton")
miniBtn.Name = "MiniBtn"
miniBtn.Size = UDim2.new(0, 50, 0, 50) -- 圆形（宽高相等）
miniBtn.Position = UDim2.new(0.2, 220, 0.1, 5) -- 标题右侧220像素，垂直居中
miniBtn.BackgroundColor3 = mainColor
miniBtn.Text = "-"
miniBtn.TextColor3 = Color3.new(1,1,1) -- 白色减号
miniBtn.Font = Enum.Font.SourceSansBold
miniBtn.TextSize = 30 -- 大号减号更显眼
miniBtn.ZIndex = 100
miniBtn.Visible = false
miniBtn.AutoButtonColor = false
miniBtn.Parent = gui
-- 圆形圆角（宽高相等时，0.5圆角就是正圆）
local miniCorner = Instance.new("UICorner", miniBtn)
miniCorner.CornerRadius = UDim.new(0.5, 0)

-- ======================== 主悬浮窗（和包裹框同尺寸，贴合包裹感）========================
local mainPanel = Instance.new("Frame")
mainPanel.Name = "MainPanel"
mainPanel.Size = UDim2.new(0, 210, 0, 60) -- 和包裹框同尺寸，实现贴合
mainPanel.Position = UDim2.new(0.2, 0, 0.1, 65) -- 包裹框下方65像素
mainPanel.BackgroundColor3 = mainColor
mainPanel.ZIndex = 100
mainPanel.Visible = false
mainPanel.ClipsDescendants = true
mainPanel.Parent = gui
-- 主面板椭圆圆角（和包裹框一致）
local panelCorner = Instance.new("UICorner", mainPanel)
panelCorner.CornerRadius = UDim.new(0.5, 0)

-- ======================== 功能按钮（适配小尺寸面板，恢复全部功能）========================
-- 按钮布局容器
local btnLayout = Instance.new("UIListLayout", mainPanel)
btnLayout.FillDirection = Enum.FillDirection.Horizontal
btnLayout.Padding = UDim.new(0, 3)
btnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
btnLayout.VerticalAlignment = Enum.VerticalAlignment.Center

-- 自动刷
local autoFarmBtn = Instance.new("TextButton")
autoFarmBtn.Name = "AutoFarmBtn"
autoFarmBtn.Size = UDim2.new(0, 95, 0, 25)
autoFarmBtn.BackgroundColor3 = mainColor:lerp(Color3.new(0,0,0), 0.3)
autoFarmBtn.Text = "自动刷"
autoFarmBtn.TextColor3 = Color3.new(1,1,1)
autoFarmBtn.Font = Enum.Font.SourceSans
autoFarmBtn.TextSize = 12
autoFarmBtn.ZIndex = 101
autoFarmBtn.AutoButtonColor = false
autoFarmBtn.Parent = mainPanel
local farmCorner = Instance.new("UICorner", autoFarmBtn)
farmCorner.CornerRadius = UDim.new(0.2, 0)

-- 自动收
local autoCollectBtn = Instance.new("TextButton")
autoCollectBtn.Name = "AutoCollectBtn"
autoCollectBtn.Size = UDim2.new(0, 95, 0, 25)
autoCollectBtn.BackgroundColor3 = mainColor:lerp(Color3.new(0,0,0), 0.3)
autoCollectBtn.Text = "自动收"
autoCollectBtn.TextColor3 = Color3.new(1,1,1)
autoCollectBtn.Font = Enum.Font.SourceSans
autoCollectBtn.TextSize = 12
autoCollectBtn.ZIndex = 101
autoCollectBtn.AutoButtonColor = false
autoCollectBtn.Parent = mainPanel
local collectCorner = Instance.new("UICorner", autoCollectBtn)
collectCorner.CornerRadius = UDim.new(0.2, 0)

-- 第二行功能按钮（换行布局）
local btnLayout2 = Instance.new("Frame", mainPanel)
btnLayout2.Size = UDim2.new(0, 200, 0, 25)
btnLayout2.Position = UDim2.new(0.5, -100, 0.6, 0)
btnLayout2.BackgroundTransparency = 1
btnLayout2.ZIndex = 101
local layout2 = Instance.new("UIListLayout", btnLayout2)
layout2.FillDirection = Enum.FillDirection.Horizontal
layout2.Padding = UDim.new(0, 3)
layout2.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- 取消锚固
local unanchorBtn = Instance.new("TextButton")
unanchorBtn.Name = "UnanchorBtn"
unanchorBtn.Size = UDim2.new(0, 95, 0, 25)
unanchorBtn.BackgroundColor3 = mainColor:lerp(Color3.new(0,0,0), 0.3)
unanchorBtn.Text = "取消锚固"
unanchorBtn.TextColor3 = Color3.new(1,1,1)
unanchorBtn.Font = Enum.Font.SourceSans
unanchorBtn.TextSize = 12
unanchorBtn.ZIndex = 101
unanchorBtn.AutoButtonColor = false
unanchorBtn.Parent = btnLayout2
local unanchorCorner = Instance.new("UICorner", unanchorBtn)
unanchorCorner.CornerRadius = UDim.new(0.2, 0)

-- 移动模式
local moveBtn = Instance.new("TextButton")
moveBtn.Name = "MoveBtn"
moveBtn.Size = UDim2.new(0, 95, 0, 25)
moveBtn.BackgroundColor3 = mainColor:lerp(Color3.new(0,0,0), 0.3)
moveBtn.Text = "移动模式"
moveBtn.TextColor3 = Color3.new(1,1,1)
moveBtn.Font = Enum.Font.SourceSans
moveBtn.TextSize = 12
moveBtn.ZIndex = 101
moveBtn.AutoButtonColor = false
moveBtn.Parent = btnLayout2
local moveCorner = Instance.new("UICorner", moveBtn)
moveCorner.CornerRadius = UDim.new(0.2, 0)

-- ======================== 核心功能逻辑（恢复全部）========================
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage:FindFirstChild("Events") or ReplicatedStorage:WaitForChild("Events", 5)
local SetServerSettings = Events and Events:FindFirstChild("SetServerSettings")
local PurchaseEvent = Events and Events:FindFirstChild("PurchaseEvent")
local Upgrades = LocalPlayer:FindFirstChild("Upgrades")

local function getRoot()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end

local function changeMap()
    if SetServerSettings then
        pcall(function() SetServerSettings:FireServer({MapTime = -1, Paused = true}) end)
    end
end

-- 自动刷
autoFarmBtn.MouseButton1Click:Connect(function()
    autofarm = not autofarm
    autoFarmBtn.BackgroundColor3 = autofarm and Color3.fromRGB(40, 200, 100) or mainColor:lerp(Color3.new(0,0,0), 0.3)
    if autofarm then
        coroutine.wrap(function()
            local bedrock = Instance.new("Part")
            bedrock.Anchored = true
            bedrock.Size = Vector3.new(2048, 10, 2048)
            bedrock.Position = Vector3.new(0, -5, 0)
            bedrock.Parent = workspace

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
                        local maxSize = Upgrades and Upgrades.MaxSize and Upgrades.MaxSize.Value or 100
                        if size.Value >= maxSize then sell:FireServer() changeMap() end
                    end)
                end)
                hum.Died:Connect(function() conn:Disconnect() changeMap() end)
            end

            if LocalPlayer.Character then onCharacter(LocalPlayer.Character) end
            LocalPlayer.CharacterAdded:Connect(onCharacter)
            while autofarm do task.wait() end
            bedrock:Destroy()
        end)()
    end
end)

-- 自动收
autoCollectBtn.MouseButton1Click:Connect(function()
    autoCollectingCubes = not autoCollectingCubes
    autoCollectBtn.BackgroundColor3 = autoCollectingCubes and Color3.fromRGB(40, 200, 100) or mainColor:lerp(Color3.new(0,0,0), 0.3)
    if autoCollectingCubes then
        coroutine.wrap(function()
            while autoCollectingCubes do
                task.wait()
                local root = getRoot()
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
    end
end)

-- 取消锚固
unanchorBtn.MouseButton1Click:Connect(function()
    keepUnanchor = not keepUnanchor
    unanchorBtn.BackgroundColor3 = keepUnanchor and Color3.fromRGB(40, 200, 100) or mainColor:lerp(Color3.new(0,0,0), 0.3)
    if keepUnanchor then
        coroutine.wrap(function()
            while keepUnanchor do
                task.wait()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.Anchored = false
                end
            end
        end)()
    end
end)

-- 移动模式
moveBtn.MouseButton1Click:Connect(function()
    farmMoving = not farmMoving
    moveBtn.BackgroundColor3 = farmMoving and Color3.fromRGB(40, 200, 100) or mainColor:lerp(Color3.new(0,0,0), 0.3)
end)

-- ======================== 点击展开/收起（关联包裹框）========================
titleOval.MouseButton1Click:Connect(function()
    mainPanel.Visible = true
    wrapFrame.Visible = false
    miniBtn.Visible = true
end)

miniBtn.MouseButton1Click:Connect(function()
    mainPanel.Visible = false
    miniBtn.Visible = false
    wrapFrame.Visible = true
end)

-- ======================== 触摸拖动（适配包裹框+最小化按钮）========================
local dragTarget = nil
local startPos = Vector2.new(0, 0)
local elemStartPos = UDim2.new(0, 0, 0, 0)

UserInputService.TouchStarted:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        local uiPos = input.Position
        local target = gui:FindFirstChildWhichIsA("GuiObject", true)
        if not target then return end
        local absPos = target.AbsolutePosition
        local absSize = target.AbsoluteSize
        if uiPos.X >= absPos.X and uiPos.X <= absPos.X + absSize.X and uiPos.Y >= absPos.Y and uiPos.Y <= absPos.Y + absSize.Y then
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
        dragTarget.Position = UDim2.new(0, elemStartPos.X.Offset + delta.X, 0, elemStartPos.Y.Offset + delta.Y)
        -- 同步关联元素
        if dragTarget == wrapFrame then
            mainPanel.Position = UDim2.new(0, elemStartPos.X.Offset + delta.X, 0, elemStartPos.Y.Offset + delta.Y + 65)
            miniBtn.Position = UDim2.new(0, elemStartPos.X.Offset + delta.X + 220, 0, elemStartPos.Y.Offset + delta.Y + 5)
        elseif dragTarget == mainPanel then
            wrapFrame.Position = UDim2.new(0, elemStartPos.X.Offset + delta.X, 0, elemStartPos.Y.Offset + delta.Y - 65)
            miniBtn.Position = UDim2.new(0, elemStartPos.X.Offset + delta.X + 220, 0, elemStartPos.Y.Offset + delta.Y - 60)
        elseif dragTarget == miniBtn then
            wrapFrame.Position = UDim2.new(0, elemStartPos.X.Offset + delta.X - 220, 0, elemStartPos.Y.Offset + delta.Y - 5)
            mainPanel.Position = UDim2.new(0, elemStartPos.X.Offset + delta.X - 220, 0, elemStartPos.Y.Offset + delta.Y + 60)
        end
    end
end)

UserInputService.TouchEnded:Connect(function(input)
    if input.UserInputId == touchId then
        touchId = nil
        dragTarget = nil
    end
end)

-- ======================== 强制显示，无多余元素========================
wrapFrame.Visible = true
miniBtn.Visible = false
-- 清理极小元素避免线条
for _, child in gui:GetChildren() do
    if child:IsA("Frame") and (child.Size.X.Offset < 5 or child.Size.Y.Offset < 5) then
        child:Destroy()
    end
end
