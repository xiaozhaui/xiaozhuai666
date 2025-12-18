-- 核心服务获取（极简）
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10) -- 等待PlayerGui加载

-- 强制清理旧UI（避免残留导致线条）
if PlayerGui:FindFirstChild("MobileFloatingWindow") then
    PlayerGui.MobileFloatingWindow:Destroy()
end

-- 全局变量
local autofarm, autoCollectingCubes
local mainColor = Color3.fromRGB(139, 101, 64)
local touchId = nil -- 记录触摸ID，避免多触摸干扰

-- 主GUI（无多余层级，避免线条）
local gui = Instance.new("ScreenGui")
gui.Name = "MobileFloatingWindow"
gui.ResetOnSpawn = false
gui.DisplayOrder = 9999 -- 强制置顶
gui.IgnoreGuiInset = true -- 忽略屏幕边距，避免错位
gui.Parent = PlayerGui

-- ======================== 标题椭圆（核心触发，无多余描边）========================
local titleOval = Instance.new("TextButton")
titleOval.Name = "TitleOval"
titleOval.Size = UDim2.new(0, 200, 0, 50) -- 标题尺寸
titleOval.Position = UDim2.new(0.2, 0, 0.1, 0) -- 调整位置，避开游戏UI
titleOval.BackgroundColor3 = mainColor
titleOval.Text = "小拽吃吃世界"
titleOval.TextColor3 = Color3.new(1,1,1)
titleOval.Font = Enum.Font.SourceSansBold
titleOval.TextSize = 18
titleOval.ZIndex = 100
titleOval.Active = true -- 启用交互
titleOval.AutoButtonColor = false -- 关闭自动变色
titleOval.ClipsDescendants = true -- 裁剪超出内容，避免线条
titleOval.Parent = gui
-- 椭圆圆角（仅内部圆角，无外描边）
local titleCorner = Instance.new("UICorner", titleOval)
titleCorner.CornerRadius = UDim.new(0.5, 0)

-- ======================== 主悬浮窗（仅比标题大5像素，无多余元素）========================
local mainPanel = Instance.new("Frame")
mainPanel.Name = "MainPanel"
mainPanel.Size = UDim2.new(0, 205, 0, 55) -- 仅比标题大5像素
mainPanel.Position = UDim2.new(0.2, -2.5, 0.1, 55) -- 与标题对齐，下方偏移
mainPanel.BackgroundColor3 = mainColor
mainPanel.ZIndex = 100
mainPanel.Visible = false -- 默认隐藏
mainPanel.ClipsDescendants = true -- 裁剪超出，避免线条
mainPanel.Parent = gui
-- 椭圆圆角
local panelCorner = Instance.new("UICorner", mainPanel)
panelCorner.CornerRadius = UDim.new(0.5, 0)

-- ======================== 功能按钮（适配小面板，无多余边框）========================
-- 自动刷按钮
local autoFarmBtn = Instance.new("TextButton")
autoFarmBtn.Name = "AutoFarmBtn"
autoFarmBtn.Size = UDim2.new(0, 95, 0, 22)
autoFarmBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
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

-- 自动收按钮
local autoCollectBtn = Instance.new("TextButton")
autoCollectBtn.Name = "AutoCollectBtn"
autoCollectBtn.Size = UDim2.new(0, 95, 0, 22)
autoCollectBtn.Position = UDim2.new(0.5, 0, 0.1, 0)
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

-- ======================== 最小化按钮（小尺寸，无线条）========================
local miniBtn = Instance.new("TextButton")
miniBtn.Name = "MiniBtn"
miniBtn.Size = UDim2.new(0, 60, 0, 30)
miniBtn.Position = UDim2.new(0.1, 0, 0.8, 0)
miniBtn.BackgroundColor3 = mainColor
miniBtn.Text = "-"
miniBtn.TextColor3 = Color3.new(1,1,1)
miniBtn.Font = Enum.Font.SourceSansBold
miniBtn.TextSize = 18
miniBtn.ZIndex = 100
miniBtn.Visible = false
miniBtn.AutoButtonColor = false
miniBtn.Parent = gui
local miniCorner = Instance.new("UICorner", miniBtn)
miniCorner.CornerRadius = UDim.new(0.5, 0)

-- ======================== 核心功能逻辑（适配游戏实例）========================
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage:FindFirstChild("Events") or ReplicatedStorage:WaitForChild("Events", 5)
local SetServerSettings = Events and Events:FindFirstChild("SetServerSettings")
local Upgrades = LocalPlayer:FindFirstChild("Upgrades")

-- 获取角色根部件
local function getRoot()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end

-- 切换地图
local function changeMap()
    if SetServerSettings then
        pcall(function()
            SetServerSettings:FireServer({MapTime = -1, Paused = true})
        end)
    end
end

-- 自动刷功能
autoFarmBtn.MouseButton1Click:Connect(function()
    autofarm = not autofarm
    -- 颜色反馈
    autoFarmBtn.BackgroundColor3 = autofarm and Color3.fromRGB(40, 200, 100) or mainColor:lerp(Color3.new(0,0,0), 0.3)

    if autofarm then
        coroutine.wrap(function()
            -- 创建基础部件
            local bedrock = Instance.new("Part")
            bedrock.Anchored = true
            bedrock.Size = Vector3.new(2048, 10, 2048)
            bedrock.Position = Vector3.new(0, -5, 0)
            bedrock.Parent = workspace

            -- 角色逻辑
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

                -- 心跳更新
                local conn = RunService.Heartbeat:Connect(function()
                    if not autofarm then conn:Disconnect() return end
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

                -- 角色死亡清理
                hum.Died:Connect(function()
                    conn:Disconnect()
                    changeMap()
                end)
            end

            -- 绑定角色加载
            if LocalPlayer.Character then
                onCharacter(LocalPlayer.Character)
            end
            LocalPlayer.CharacterAdded:Connect(onCharacter)

            -- 主循环
            while autofarm do
                task.wait()
            end

            -- 清理资源
            bedrock:Destroy()
        end)()
    end
end)

-- 自动收功能
autoCollectBtn.MouseButton1Click:Connect(function()
    autoCollectingCubes = not autoCollectingCubes
    -- 颜色反馈
    autoCollectBtn.BackgroundColor3 = autoCollectingCubes and Color3.fromRGB(40, 200, 100) or mainColor:lerp(Color3.new(0,0,0), 0.3)

    if autoCollectingCubes then
        coroutine.wrap(function()
            while autoCollectingCubes do
                task.wait()
                local root = getRoot()
                if root then
                    -- 遍历拾取方块
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
    end
end)

-- ======================== 修复移动端点击展开/收起========================
-- 标题点击展开
titleOval.MouseButton1Click:Connect(function()
    mainPanel.Visible = true
    titleOval.Visible = false
    miniBtn.Visible = true
end)

-- 最小化点击收起
miniBtn.MouseButton1Click:Connect(function()
    mainPanel.Visible = false
    miniBtn.Visible = false
    titleOval.Visible = true
end)

-- ======================== 修复移动端触摸拖动（精准适配）========================
local dragTarget = nil
local startPos = Vector2.new(0, 0)
local elemStartPos = UDim2.new(0, 0, 0, 0)

-- 触摸开始（记录触摸ID和初始位置）
UserInputService.TouchStarted:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        -- 获取触摸位置对应的UI
        local uiPos = input.Position
        local target = gui:FindFirstChildWhichIsA("GuiObject", true)
        if not target then return end

        -- 判断触摸是否在UI范围内
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

-- 触摸移动（精准拖动）
UserInputService.TouchMoved:Connect(function(input)
    if input.UserInputId == touchId and dragTarget then
        local delta = input.Position - startPos
        -- 更新UI位置（仅用Offset，避免Scale导致错位）
        dragTarget.Position = UDim2.new(
            0, elemStartPos.X.Offset + delta.X,
            0, elemStartPos.Y.Offset + delta.Y
        )
        -- 同步关联UI位置
        if dragTarget == titleOval then
            mainPanel.Position = UDim2.new(0, elemStartPos.X.Offset + delta.X - 2.5, 0, elemStartPos.Y.Offset + delta.Y + 55)
        elseif dragTarget == mainPanel then
            titleOval.Position = UDim2.new(0, elemStartPos.X.Offset + delta.X + 2.5, 0, elemStartPos.Y.Offset + delta.Y - 55)
        end
    end
end)

-- 触摸结束（清理状态）
UserInputService.TouchEnded:Connect(function(input)
    if input.UserInputId == touchId then
        touchId = nil
        dragTarget = nil
    end
end)

-- ======================== 强制显示标题，无多余元素========================
titleOval.Visible = true
-- 确保无隐藏的小框架导致线条
for _, child in gui:GetChildren() do
    if child:IsA("Frame") and child.Size.X.Offset < 5 and child.Size.Y.Offset < 5 then
        child:Destroy()
    end
end
