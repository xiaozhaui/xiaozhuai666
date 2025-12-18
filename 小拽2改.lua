-- 核心服务（极简，仅保留必要）
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10)

-- 强制清理旧UI（彻底避免冲突）
if PlayerGui:FindFirstChild("MobileFloatingWindow") then
    PlayerGui.MobileFloatingWindow:Destroy()
end

-- 全局变量（极简状态）
local autofarm, autoCollectingCubes, farmMoving, keepUnanchor
local mainColor = Color3.fromRGB(139, 101, 64)
local isOpen = false -- 仅用一个状态标记，避免冲突

-- 主GUI（层级拉满，无遮挡）
local gui = Instance.new("ScreenGui")
gui.Name = "MobileFloatingWindow"
gui.ResetOnSpawn = false
gui.DisplayOrder = 99999 -- 极致置顶
gui.IgnoreGuiInset = true
gui.Parent = PlayerGui

-- ======================== 标题椭圆（极致小：180×45，核心触发）========================
local titleOval = Instance.new("TextButton")
titleOval.Name = "Title"
titleOval.Size = UDim2.new(0, 180, 0, 45) -- 缩小标题尺寸
titleOval.Position = UDim2.new(0.2, 0, 0.1, 0)
titleOval.BackgroundColor3 = mainColor
titleOval.Text = "小拽吃吃世界"
titleOval.TextColor3 = Color3.new(1,1,1)
titleOval.Font = Enum.Font.SourceSansBold
titleOval.TextSize = 16 -- 小号文字适配
titleOval.ZIndex = 100
titleOval.Active = true -- 强制启用交互
titleOval.Selectable = true -- 确保触摸识别
titleOval.AutoButtonColor = false
titleOval.Parent = gui
-- 椭圆圆角
local titleCorner = Instance.new("UICorner", titleOval)
titleCorner.CornerRadius = UDim.new(0.5, 0)

-- ======================== 最小化按钮（迷你：25×25，标题右侧）========================
local miniBtn = Instance.new("TextButton")
miniBtn.Name = "Mini"
miniBtn.Size = UDim2.new(0, 25, 0, 25) -- 极致小的圆形按钮
miniBtn.Position = UDim2.new(0.2, 190, 0.1, 10) -- 标题右侧10像素
miniBtn.BackgroundColor3 = mainColor
miniBtn.Text = "-"
miniBtn.TextColor3 = Color3.new(1,1,1)
miniBtn.Font = Enum.Font.SourceSansBold
miniBtn.TextSize = 16
miniBtn.ZIndex = 100
miniBtn.Visible = false
miniBtn.Active = true
miniBtn.Selectable = true
miniBtn.AutoButtonColor = false
miniBtn.Parent = gui
-- 正圆圆角
local miniCorner = Instance.new("UICorner", miniBtn)
miniCorner.CornerRadius = UDim.new(0.5, 0)

-- ======================== 功能面板（和标题同尺寸，展开后高度100，极致紧凑）========================
local funcPanel = Instance.new("Frame")
funcPanel.Name = "FuncPanel"
funcPanel.Size = UDim2.new(0, 180, 0, 0) -- 初始高度0，完全紧贴标题
funcPanel.Position = UDim2.new(0.2, 0, 0.1, 45) -- 标题下方0像素，无间隙
funcPanel.BackgroundColor3 = mainColor
funcPanel.ZIndex = 100
funcPanel.Visible = true -- 始终可见，仅改高度
funcPanel.Parent = gui
-- 椭圆圆角（和标题一致）
local panelCorner = Instance.new("UICorner", funcPanel)
panelCorner.CornerRadius = UDim.new(0.5, 0)

-- 功能按钮布局（无滚动框，固定布局更简洁）
local btnFrame = Instance.new("Frame", funcPanel)
btnFrame.Size = UDim2.new(1, -5, 1, -5)
btnFrame.Position = UDim2.new(0, 2.5, 0, 2.5)
btnFrame.BackgroundTransparency = 1
btnFrame.ZIndex = 101

-- 第一行按钮布局
local row1 = Instance.new("UIListLayout", btnFrame)
row1.FillDirection = Enum.FillDirection.Horizontal
row1.Padding = UDim.new(0, 2)
row1.HorizontalAlignment = Enum.HorizontalAlignment.Center
row1.VerticalAlignment = Enum.VerticalAlignment.Top

-- 第二行按钮布局
local row2 = Instance.new("Frame", btnFrame)
row2.Size = UDim2.new(1, 0, 0, 22)
row2.Position = UDim2.new(0, 0, 0, 25)
row2.BackgroundTransparency = 1
row2.ZIndex = 101
local row2Layout = Instance.new("UIListLayout", row2)
row2Layout.FillDirection = Enum.FillDirection.Horizontal
row2Layout.Padding = UDim.new(0, 2)
row2Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- ======================== 功能按钮（极致小：80×20）========================
local function createBtn(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 80, 0, 20) -- 极小按钮尺寸
    btn.BackgroundColor3 = mainColor:lerp(Color3.new(0,0,0), 0.4)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 10 -- 超小字体适配
    btn.ZIndex = 101
    btn.Active = true
    btn.Selectable = true
    btn.AutoButtonColor = false
    btn.Parent = parent
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0.2, 0)

    -- 点击逻辑（直接绑定，无冗余）
    btn.MouseButton1Click:Connect(function()
        local isOn = not btn:GetAttribute("IsOn")
        btn:SetAttribute("IsOn", isOn)
        btn.BackgroundColor3 = isOn and Color3.fromRGB(40,200,100) or mainColor:lerp(Color3.new(0,0,0), 0.4)
        callback(isOn)
    end)
    btn:SetAttribute("IsOn", false)
    return btn
end

-- 第一行按钮
createBtn(btnFrame, "自动刷", function(enabled)
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
                    local maxSize = LocalPlayer.Upgrades and LocalPlayer.Upgrades.MaxSize.Value or 100
                    if size.Value >= maxSize then
                        sell:FireServer()
                        game:GetService("ReplicatedStorage").Events.SetServerSettings:FireServer({MapTime=-1,Paused=true})
                    end
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

createBtn(btnFrame, "自动收", function(enabled)
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
                            pcall(function() v.CFrame = root.CFrame end)
                        end
                    end
                end
            end
        end
    end)()
end)

-- 第二行按钮
createBtn(row2, "取消锚固", function(enabled)
    keepUnanchor = enabled
    if not enabled then return end
    coroutine.wrap(function()
        while keepUnanchor do
            task.wait()
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then root.Anchored = false end
        end
    end)()
end)

createBtn(row2, "移动模式", function(enabled)
    farmMoving = enabled
end)

-- ======================== 修复点击展开/收起（极简逻辑，无动画冲突）========================
local function togglePanel()
    isOpen = not isOpen
    -- 直接改高度，避免缓动动画导致的点击失效
    if isOpen then
        funcPanel.Size = UDim2.new(0, 180, 0, 100) -- 展开后高度100（极致小）
        titleOval.Visible = false
        miniBtn.Visible = true
    else
        funcPanel.Size = UDim2.new(0, 180, 0, 0) -- 收起后高度0
        titleOval.Visible = true
        miniBtn.Visible = false
    end
end

-- 强制绑定点击事件，确保触发
titleOval.MouseButton1Click:Connect(togglePanel)
miniBtn.MouseButton1Click:Connect(togglePanel)
-- 增加触摸点击冗余绑定，防止移动端识别失败
titleOval.TouchTap:Connect(togglePanel)
miniBtn.TouchTap:Connect(togglePanel)

-- ======================== 修复拖动（极简触摸逻辑）========================
local dragTarget, startX, startY, startPosX, startPosY

UserInputService.TouchStarted:Connect(function(input)
    local x, y = input.Position.X, input.Position.Y
    -- 判断是否点中UI
    local target = nil
    if x > titleOval.AbsolutePosition.X and x < titleOval.AbsolutePosition.X + titleOval.AbsoluteSize.X and y > titleOval.AbsolutePosition.Y and y < titleOval.AbsolutePosition.Y + titleOval.AbsoluteSize.Y then
        target = titleOval
    elseif x > miniBtn.AbsolutePosition.X and x < miniBtn.AbsolutePosition.X + miniBtn.AbsoluteSize.X and y > miniBtn.AbsolutePosition.Y and y < miniBtn.AbsolutePosition.Y + miniBtn.AbsoluteSize.Y then
        target = miniBtn
    elseif x > funcPanel.AbsolutePosition.X and x < funcPanel.AbsolutePosition.X + funcPanel.AbsoluteSize.X and y > funcPanel.AbsolutePosition.Y and y < funcPanel.AbsolutePosition.Y + funcPanel.AbsoluteSize.Y then
        target = funcPanel
    end

    if target then
        dragTarget = target
        startX, startY = x, y
        startPosX = target.Position.X.Offset
        startPosY = target.Position.Y.Offset
    end
end)

UserInputService.TouchMoved:Connect(function(input)
    if dragTarget then
        local x, y = input.Position.X, input.Position.Y
        local dx = x - startX
        local dy = y - startY
        -- 直接更新位置，无冗余计算
        dragTarget.Position = UDim2.new(0, startPosX + dx, 0, startPosY + dy)
        -- 同步关联UI
        if dragTarget == titleOval then
            funcPanel.Position = UDim2.new(0, startPosX + dx, 0, startPosY + dy + 45)
            miniBtn.Position = UDim2.new(0, startPosX + dx + 190, 0, startPosY + dy + 10)
        elseif dragTarget == funcPanel then
            titleOval.Position = UDim2.new(0, startPosX + dx, 0, startPosY + dy - 45)
            miniBtn.Position = UDim2.new(0, startPosX + dx + 190, 0, startPosY + dy - 35)
        elseif dragTarget == miniBtn then
            titleOval.Position = UDim2.new(0, startPosX + dx - 190, 0, startPosY + dy - 10)
            funcPanel.Position = UDim2.new(0, startPosX + dx - 190, 0, startPosY + dy + 35)
        end
    end
end)

UserInputService.TouchEnded:Connect(function()
    dragTarget = nil
end)

-- ======================== 初始化（确保默认状态正确）========================
titleOval.Visible = true
miniBtn.Visible = false
funcPanel.Size = UDim2.new(0, 180, 0, 0)
-- 强制激活所有按钮交互
for _, btn in btnFrame:GetDescendants() do
    if btn:IsA("TextButton") then
        btn.Active = true
        btn.Selectable = true
    end
end
