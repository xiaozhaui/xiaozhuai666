-- 强制清理旧实例（避免冲突）
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")

-- 直接删除旧窗口（不依赖pcall，确保清理）
if PlayerGui:FindFirstChild("MobileFloatingWindow") then
    PlayerGui.MobileFloatingWindow:Destroy()
end

-- 全局变量（极简）
local autofarm, autoCollectingCubes, farmMoving, keepUnanchor
local mainColor = Color3.fromRGB(139, 101, 64)

-- 主GUI（极简配置）
local gui = Instance.new("ScreenGui")
gui.Name = "MobileFloatingWindow"
gui.ResetOnSpawn = false
gui.DisplayOrder = 9999 -- 强制置顶，不被遮挡
gui.IgnoreGuiInset = false -- 适应屏幕边距，避免点击错位
gui.Parent = PlayerGui

-- ======================== 核心UI（最小尺寸，仅比标题大一点）========================
-- 标题椭圆（触发按钮：200×50）
local titleOval = Instance.new("TextButton")
titleOval.Name = "Title"
titleOval.Size = UDim2.new(0, 200, 0, 50)
titleOval.Position = UDim2.new(0.1, 0, 0.1, 0) -- 左上角，易点击
titleOval.BackgroundColor3 = mainColor
titleOval.Text = "小拽吃吃世界"
titleOval.TextColor3 = Color3.new(1,1,1)
titleOval.Font = Enum.Font.SourceSansBold
titleOval.TextSize = 18
titleOval.ZIndex = 100
titleOval.BackgroundTransparency = 0
titleOval.Parent = gui
-- 椭圆圆角
local titleCorner = Instance.new("UICorner", titleOval)
titleCorner.CornerRadius = UDim.new(0.5, 0)

-- 主悬浮窗（210×60，仅比标题宽10、高10）
local mainPanel = Instance.new("Frame")
mainPanel.Name = "MainPanel"
mainPanel.Size = UDim2.new(0, 210, 0, 60)
mainPanel.Position = UDim2.new(0.1, -5, 0.1, 55) -- 紧贴标题下方
mainPanel.BackgroundColor3 = mainColor
mainPanel.ZIndex = 100
mainPanel.Visible = false -- 默认隐藏
mainPanel.Parent = gui
-- 椭圆圆角
local panelCorner = Instance.new("UICorner", mainPanel)
panelCorner.CornerRadius = UDim.new(0.4, 0)

-- 最小化椭圆（80×35，极小尺寸）
local miniOval = Instance.new("TextButton")
miniOval.Name = "Mini"
miniOval.Size = UDim2.new(0, 80, 0, 35)
miniOval.Position = UDim2.new(0.1, 0, 0.8, 0)
miniOval.BackgroundColor3 = mainColor
miniOval.Text = "-"
miniOval.TextColor3 = Color3.new(1,1,1)
miniOval.Font = Enum.Font.SourceSansBold
miniOval.TextSize = 20
miniOval.ZIndex = 100
miniOval.Visible = false
miniOval.Parent = gui
local miniCorner = Instance.new("UICorner", miniOval)
miniCorner.CornerRadius = UDim.new(0.5, 0)

-- ======================== 功能按钮（极小尺寸，适配面板）========================
-- 自动刷按钮（190×25）
local autoFarmBtn = Instance.new("TextButton")
autoFarmBtn.Name = "AutoFarm"
autoFarmBtn.Size = UDim2.new(0, 190, 0, 25)
autoFarmBtn.Position = UDim2.new(0.5, -95, 0.1, 0)
autoFarmBtn.BackgroundColor3 = mainColor:lerp(Color3.fromRGB(0,0,0), 0.4)
autoFarmBtn.TextColor3 = Color3.new(1,1,1)
autoFarmBtn.Text = "自动刷"
autoFarmBtn.Font = Enum.Font.SourceSans
autoFarmBtn.TextSize = 12
autoFarmBtn.ZIndex = 101
autoFarmBtn.Parent = mainPanel
local farmCorner = Instance.new("UICorner", autoFarmBtn)
farmCorner.CornerRadius = UDim.new(0.1, 0)

-- 自动收按钮（190×25）
local autoCollectBtn = Instance.new("TextButton")
autoCollectBtn.Name = "AutoCollect"
autoCollectBtn.Size = UDim2.new(0, 190, 0, 25)
autoCollectBtn.Position = UDim2.new(0.5, -95, 0.5, -12)
autoCollectBtn.BackgroundColor3 = mainColor:lerp(Color3.fromRGB(0,0,0), 0.4)
autoCollectBtn.TextColor3 = Color3.new(1,1,1)
autoCollectBtn.Text = "自动收"
autoCollectBtn.Font = Enum.Font.SourceSans
autoCollectBtn.TextSize = 12
autoCollectBtn.ZIndex = 101
autoCollectBtn.Parent = mainPanel
local collectCorner = Instance.new("UICorner", autoCollectBtn)
collectCorner.CornerRadius = UDim.new(0.1, 0)

-- ======================== 核心功能（极简容错）========================
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage:FindFirstChild("Events") or ReplicatedStorage:WaitForChild("Events", 5)
local SetServerSettings = Events and Events:FindFirstChild("SetServerSettings")
local Upgrades = LocalPlayer:FindFirstChild("Upgrades")

local function getRoot()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end

local function changeMap()
    if SetServerSettings then
        pcall(function() SetServerSettings:FireServer({MapTime = -1, Paused = true}) end)
    end
end

-- 自动刷逻辑
autoFarmBtn.MouseButton1Click:Connect(function()
    autofarm = not autofarm
    autoFarmBtn.BackgroundColor3 = autofarm and Color3.fromRGB(40, 200, 100) or mainColor:lerp(Color3.fromRGB(0,0,0), 0.4)
    
    if autofarm then
        coroutine.wrap(function()
            local bedrock = Instance.new("Part")
            bedrock.Anchored = true
            bedrock.Size = Vector3.new(2048, 10, 2048)
            bedrock.Position = Vector3.new(0, -5, 0)
            bedrock.Parent = workspace
            
            local function onChar(char)
                local hum = char:WaitForChild("Humanoid")
                local root = char:WaitForChild("HumanoidRootPart")
                local size = char:WaitForChild("Size")
                local events = char:WaitForChild("Events")
                local eat = events:WaitForChild("Eat")
                local grab = events:WaitForChild("Grab")
                local sell = events:WaitForChild("Sell")
                
                local conn = RunService.Heartbeat:Connect(function()
                    if not autofarm then conn:Disconnect() return end
                    pcall(function()
                        hum:ChangeState(Enum.HumanoidStateType.Physics)
                        grab:FireServer()
                        root.Anchored = false
                        eat:FireServer()
                        
                        local maxSize = Upgrades and Upgrades.MaxSize and Upgrades.MaxSize.Value or 100
                        if size.Value >= maxSize then
                            sell:FireServer()
                            changeMap()
                        end
                    end)
                end)
                
                hum.Died:Connect(function() conn:Disconnect() changeMap() end)
            end
            
            if LocalPlayer.Character then onChar(LocalPlayer.Character) end
            LocalPlayer.CharacterAdded:Connect(onChar)
            
            while autofarm do task.wait() end
            bedrock:Destroy()
        end)()
    end
end)

-- 自动收逻辑
autoCollectBtn.MouseButton1Click:Connect(function()
    autoCollectingCubes = not autoCollectingCubes
    autoCollectBtn.BackgroundColor3 = autoCollectingCubes and Color3.fromRGB(40, 200, 100) or mainColor:lerp(Color3.fromRGB(0,0,0), 0.4)
    
    if autoCollectingCubes then
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
    end
end)

-- ======================== 修复点击展开/收起（极简逻辑）========================
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

-- ======================== 修复拖动（仅保留触摸，适配移动端）========================
local dragging = false
local dragTarget = nil
local startPos = Vector2.new(0, 0)
local elemStartPos = UDim2.new(0, 0, 0, 0)

-- 开始拖动
local function onInputBegan(input, elem)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragTarget = elem
        startPos = input.Position
        elemStartPos = elem.Position
    end
end

-- 绑定拖动触发
titleOval.InputBegan:Connect(function(input) onInputBegan(input, titleOval) end)
mainPanel.InputBegan:Connect(function(input) onInputBegan(input, mainPanel) end)
miniOval.InputBegan:Connect(function(input) onInputBegan(input, miniOval) end)

-- 结束拖动
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
        dragTarget = nil
    end
end)

-- 拖动更新（无冗余计算）
UserInputService.TouchMoved:Connect(function(input)
    if dragging and dragTarget then
        local delta = input.Position - startPos
        dragTarget.Position = UDim2.new(
            0, elemStartPos.X.Offset + delta.X,
            0, elemStartPos.Y.Offset + delta.Y
        )
        -- 同步关联元素
        if dragTarget == titleOval then
            mainPanel.Position = UDim2.new(0, elemStartPos.X.Offset + delta.X -5, 0, elemStartPos.Y.Offset + delta.Y +55)
        elseif dragTarget == mainPanel then
            titleOval.Position = UDim2.new(0, elemStartPos.X.Offset + delta.X +5, 0, elemStartPos.Y.Offset + delta.Y -55)
        end
    end
end)

-- 强制显示标题
titleOval.Visible = true
