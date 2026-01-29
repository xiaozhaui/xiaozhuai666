-- ROBLOX 悬浮窗 UI
-- 现代化设计的游戏开发工具界面

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 白名单系统
local whitelist = {
    "xiaozhuai666",
    "xiaozhuai778",
    "CninaNo1rewq",
    "SBB_1234。",
    "zhenghonghao345",
    "91_SBCCB",
    "ipoo2022",
    "GOVCLDX",
    "zydang6699",
    "zydang66999",
    "zydang669999",
    "sdfghjkplm5566",
    "qw540889",
    "das8836",
    "KARDS932",
    "91vip0837",
    "skszthb",
    "KARDS2391",   
    }
-- 验证状态变量
local isWhitelisted = false

-- 验证窗口函数
local function showVerificationWindow()
    -- 创建验证窗口
    local verificationGui = Instance.new("ScreenGui")
    verificationGui.Name = "VerificationWindow"
    verificationGui.ResetOnSpawn = false
    verificationGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    verificationGui.Parent = playerGui
    
    -- 主窗口框架
    local verificationFrame = Instance.new("Frame")
    verificationFrame.Name = "VerificationFrame"
    verificationFrame.Size = UDim2.new(0, 400, 0, 280)
    verificationFrame.Position = UDim2.new(0.5, -200, 0.5, -140)
    verificationFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
    verificationFrame.BorderSizePixel = 0
    verificationFrame.Active = true
    verificationFrame.Draggable = true
    verificationFrame.Parent = verificationGui
    
    -- 圆角效果
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = verificationFrame
    
    -- 边框效果
    local border = Instance.new("UIStroke")
    border.Color = Color3.fromRGB(100, 150, 255)
    border.Thickness = 3
    border.Parent = verificationFrame
    
    -- 标题栏
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = verificationFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = titleBar
    
    -- 标题文本
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "🔐 账号验证"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 18
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar
    
    -- 当前日期时间显示
    local datetimeLabel = Instance.new("TextLabel")
    datetimeLabel.Size = UDim2.new(1, -20, 0, 25)
    datetimeLabel.Position = UDim2.new(0, 10, 0, 50)
    datetimeLabel.BackgroundTransparency = 1
    datetimeLabel.Text = ""
    datetimeLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    datetimeLabel.TextSize = 16
    datetimeLabel.Font = Enum.Font.GothamBold
    datetimeLabel.TextXAlignment = Enum.TextXAlignment.Left
    datetimeLabel.Parent = verificationFrame
    
    -- 作者信息
    local authorLabel = Instance.new("TextLabel")
    authorLabel.Size = UDim2.new(1, -20, 0, 25)
    authorLabel.Position = UDim2.new(0, 10, 0, 80)
    authorLabel.BackgroundTransparency = 1
    authorLabel.Text = "作者：小拽游戏用户名xiaozhuai666"
    authorLabel.TextColor3 = Color3.fromRGB(100, 255, 200)
    authorLabel.TextSize = 14
    authorLabel.Font = Enum.Font.Gotham
    authorLabel.TextXAlignment = Enum.TextXAlignment.Left
    authorLabel.Parent = verificationFrame
    
    -- 欢迎信息
    local welcomeLabel = Instance.new("TextLabel")
    welcomeLabel.Size = UDim2.new(1, -20, 0, 25)
    welcomeLabel.Position = UDim2.new(0, 10, 0, 105)
    welcomeLabel.BackgroundTransparency = 1
    welcomeLabel.Text = "欢迎使用小拽脚本"
    welcomeLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
    welcomeLabel.TextSize = 16
    welcomeLabel.Font = Enum.Font.GothamBold
    welcomeLabel.TextXAlignment = Enum.TextXAlignment.Left
    welcomeLabel.Parent = verificationFrame
    
    -- 白名单信息
    local whitelistLabel = Instance.new("TextLabel")
    whitelistLabel.Size = UDim2.new(1, -20, 0, 40)
    whitelistLabel.Position = UDim2.new(0, 10, 0, 140)
    whitelistLabel.BackgroundTransparency = 1
    whitelistLabel.Text = "白名单用户：xiaozhuai666, xioazhuai778"
    whitelistLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    whitelistLabel.TextSize = 12
    whitelistLabel.Font = Enum.Font.Gotham
    whitelistLabel.TextXAlignment = Enum.TextXAlignment.Left
    whitelistLabel.TextWrapped = true
    whitelistLabel.Parent = verificationFrame
    
    -- 验证状态
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, -20, 0, 30)
    statusLabel.Position = UDim2.new(0, 10, 0, 190)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "正在验证账号..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
    statusLabel.TextSize = 16
    statusLabel.Font = Enum.Font.GothamBold
    statusLabel.TextXAlignment = Enum.TextXAlignment.Center
    statusLabel.Parent = verificationFrame
    
    -- 关闭按钮
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 100, 0, 35)
    closeBtn.Position = UDim2.new(0.5, -50, 1, -45)
    closeBtn.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
    closeBtn.Text = "关闭"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 16
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = verificationFrame
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeBtn
    
    -- 更新时间显示
    local function updateDateTime()
        local currentTime = os.date("%Y年%m月%d日 %I:%M:%S %p")
        datetimeLabel.Text = "当前时间：" .. currentTime
    end
    
    -- 验证账号
    local function verifyAccount()
        local playerName = player.Name
        local displayName = player.DisplayName
        
        -- 检查白名单
        isWhitelisted = false
        for _, whitelistedName in ipairs(whitelist) do
            if playerName == whitelistedName or displayName == whitelistedName then
                isWhitelisted = true
                break
            end
        end
        
        if isWhitelisted then
            statusLabel.Text = "✅ 验证成功！欢迎使用脚本"
            statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            
            -- 验证成功后3秒自动关闭验证窗口
            task.delay(3, function()
                verificationGui:Destroy()
            end)
        else
            statusLabel.Text = "❌ 验证失败！非白名单用户"
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            
            -- 非白名单用户无法使用脚本
            closeBtn.Text = "退出悬浮窗"
            closeBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            
            -- 验证失败后4秒自动关闭验证窗口
            task.delay(4, function()
                verificationGui:Destroy()
            end)
        end
    end
    
    -- 按钮事件
    closeBtn.MouseButton1Click:Connect(function()
        if closeBtn.Text == "退出悬浮窗" then
            -- 非白名单用户关闭验证窗口
            verificationGui:Destroy()
        else
            verificationGui:Destroy()
        end
    end)
    
    -- 实时更新时间
    local datetimeConnection
    datetimeConnection = RunService.Heartbeat:Connect(function()
        updateDateTime()
    end)
    
    -- 开始验证
    task.wait(1) -- 等待1秒显示窗口
    verifyAccount()
    
    -- 返回验证结果
    return verificationGui
end

-- 执行验证
local verificationWindow = showVerificationWindow()

-- 等待验证窗口完全关闭
local function waitForVerificationWindowClose()
    local startTime = tick()
    while tick() - startTime < 10 do -- 最多等待10秒
        -- 检查验证窗口是否还存在
        if not verificationWindow or not verificationWindow.Parent then
            return true -- 验证窗口已关闭
        end
        task.wait(0.1)
    end
    return false -- 超时
end

-- 等待验证窗口关闭
local windowClosed = waitForVerificationWindowClose()

-- 检查验证结果
if not isWhitelisted then
    print("❌ 验证失败，脚本停止执行")
    return -- 停止脚本
end

print("✅ 验证成功，验证窗口已关闭，开始加载脚本功能")

-- 清理上次注入的所有内容
for _, gui in pairs(playerGui:GetChildren()) do
    if gui.Name == "FloatingUI" then
        gui:Destroy()
    end
end

-- 清理所有玩家头顶的BillboardGui
for _, targetPlayer in pairs(Players:GetPlayers()) do
    if targetPlayer.Character then
        for _, obj in pairs(targetPlayer.Character:GetDescendants()) do
            if obj:IsA("BillboardGui") and obj.Name == "HeadStatsGui" then
                obj:Destroy()
            end
        end
    end
end

-- 强制等待确保清理完成
task.wait(0.1)

-- 断开之前的连接
if shared.XiaoZhuaiConnections then
    for _, connection in pairs(shared.XiaoZhuaiConnections) do
        pcall(function() connection:Disconnect() end)
    end
end
shared.XiaoZhuaiConnections = {}

-- 配置保存（shared表+文件双重保存）
if not shared.XiaoZhuaiConfig then
    shared.XiaoZhuaiConfig = {
        flySpeed = 50,
        walkSpeed = 16,
        mainFrameColor = {150, 200, 255},
        titleBarColor = {120, 160, 204},
        infoFrameColor = {90, 120, 153},
        borderColor = {150, 200, 255},
        fpsPositionX = 1, -- FPS位置X坐标（0-1）
        fpsPositionY = 0, -- FPS位置Y坐标（0-1）
        -- 吃吃世界功能状态
        autofarm = false,
        autoCollectingCubes = false,
        autoClaimRewards = false,
        farmMoving = false,
        showMap = false,
        autoeat = false,
        autoUpgradeSize = false,
        autoUpgradeSpd = false,
        autoUpgradeMulti = false,
        autoUpgradeEat = false,
        keepUnanchor = false,
        boundProtect = false
    }
    -- 尝试从文件加载
    pcall(function()
        if isfile and readfile and isfile("XiaoZhuai.txt") then
            local data = readfile("XiaoZhuai.txt")
            local loaded = HttpService:JSONDecode(data)
            for k, v in pairs(loaded) do
                shared.XiaoZhuaiConfig[k] = v
            end
            print("✅ 从文件加载配置成功")
        end
    end)
end

local savedConfig = shared.XiaoZhuaiConfig

print("✅ 配置已加载 - 飞行速度:" .. savedConfig.flySpeed .. " 人物速度:" .. savedConfig.walkSpeed)

local function saveConfig()
    shared.XiaoZhuaiConfig = savedConfig
    -- 尝试保存到文件
    pcall(function()
        if writefile then
            writefile("XiaoZhuai.txt", HttpService:JSONEncode(savedConfig))
        end
    end)
    print("✅ 配置已保存 - 飞行:" .. savedConfig.flySpeed .. " 人物:" .. savedConfig.walkSpeed)
end

-- 重置人物状态函数
local function resetPlayerState()
    if player.Character then
        local character = player.Character
        local humanoid = character:FindFirstChild("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        
        -- 重置移动速度
        if humanoid then
            humanoid.WalkSpeed = 16
            humanoid.JumpPower = 50
            humanoid.PlatformStand = false
        end
        
        -- 清除所有飞行相关的BodyVelocity和BodyAngularVelocity
        if rootPart then
            for _, obj in pairs(rootPart:GetChildren()) do
                if obj:IsA("BodyVelocity") or obj:IsA("BodyAngularVelocity") or obj:IsA("BodyPosition") or obj:IsA("BodyForce") then
                    obj:Destroy()
                end
            end
        end
        
        -- 清除其他可能的修改
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                for _, obj in pairs(part:GetChildren()) do
                    if obj:IsA("BodyVelocity") or obj:IsA("BodyAngularVelocity") or obj:IsA("BodyPosition") or obj:IsA("BodyForce") then
                        obj:Destroy()
                    end
                end
            end
        end
        
        print("人物状态已重置")
    end
end

-- 删除之前的悬浮窗实例并重置状态
-- (已在开头清理)

-- 重置人物状态（但不重置速度）
if player.Character then
    local character = player.Character
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if humanoid then
        humanoid.JumpPower = 50
        humanoid.PlatformStand = false
    end
    
    if rootPart then
        for _, obj in pairs(rootPart:GetChildren()) do
            if obj:IsA("BodyVelocity") or obj:IsA("BodyAngularVelocity") or obj:IsA("BodyPosition") or obj:IsA("BodyForce") then
                obj:Destroy()
            end
        end
    end
    
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            for _, obj in pairs(part:GetChildren()) do
                if obj:IsA("BodyVelocity") or obj:IsA("BodyAngularVelocity") or obj:IsA("BodyPosition") or obj:IsA("BodyForce") then
                    obj:Destroy()
                end
            end
        end
    end
end

-- 应用保存的配置
if player.Character and player.Character:FindFirstChild("Humanoid") then
    player.Character.Humanoid.WalkSpeed = savedConfig.walkSpeed
    print("✅ 已应用保存的速度: " .. savedConfig.walkSpeed)
end

player.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid").WalkSpeed = savedConfig.walkSpeed
    print("✅ 角色重生，已应用保存的速度: " .. savedConfig.walkSpeed)
end)

-- 创建主界面
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FloatingUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
screenGui.Parent = playerGui

-- 危险玩家警告系统
local warningFrame = Instance.new("Frame")
warningFrame.Name = "DangerWarning"
warningFrame.Size = UDim2.new(0, 300, 0, 80)
warningFrame.Position = UDim2.new(0.5, -150, 0, 20)
warningFrame.BackgroundTransparency = 1
warningFrame.Visible = false
warningFrame.Parent = screenGui

local warningIcon = Instance.new("TextLabel")
warningIcon.Size = UDim2.new(0, 60, 0, 60)
warningIcon.Position = UDim2.new(0.5, -30, 0, 0)
warningIcon.BackgroundTransparency = 1
warningIcon.Text = "⚠"
warningIcon.TextColor3 = Color3.fromRGB(255, 0, 0)
warningIcon.TextSize = 50
warningIcon.Font = Enum.Font.GothamBold
warningIcon.TextStrokeTransparency = 0
warningIcon.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
warningIcon.Parent = warningFrame

local warningText = Instance.new("TextLabel")
warningText.Size = UDim2.new(1, 0, 0, 20)
warningText.Position = UDim2.new(0, 0, 0, 60)
warningText.BackgroundTransparency = 1
warningText.Text = ""
warningText.TextColor3 = Color3.fromRGB(255, 255, 0)
warningText.TextSize = 16
warningText.Font = Enum.Font.GothamBold
warningText.TextStrokeTransparency = 0
warningText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
warningText.Parent = warningFrame

-- 修改点1: 警告函数改为显示 DisplayName (昵称)
local function showDangerWarning(targetPlayer)
    -- 获取 DisplayName，如果没有则回退到 Name
    local displayName = targetPlayer.DisplayName ~= "" and targetPlayer.DisplayName or targetPlayer.Name
    warningText.Text = displayName
    warningFrame.Visible = true
    local startTime = tick()
    local connection
    connection = RunService.Heartbeat:Connect(function()
        local elapsed = tick() - startTime
        if elapsed >= 3 then
            warningFrame.Visible = false
            connection:Disconnect()
        else
            warningIcon.Visible = (math.floor(elapsed * 4) % 2 == 0)
        end
    end)
end

-- 右上角永久帧率显示器
local permanentFpsFrame = Instance.new("Frame")
permanentFpsFrame.Name = "PermanentFPS"
permanentFpsFrame.Size = UDim2.new(0, 100, 0, 35)
-- 自动适配设备：电脑显示在右上角最顶部，手机显示在右上角
local screenSize = workspace.CurrentCamera.ViewportSize
local isMobile = screenSize.X < screenSize.Y or UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
if isMobile then
    permanentFpsFrame.Position = UDim2.new(1, -110, 0, 5)
else
    permanentFpsFrame.Position = UDim2.new(1, -360, 0, -35)  -- 电脑端往右移50像素（半个宽度）
end
permanentFpsFrame.BackgroundTransparency = 1  -- 完全透明，去掉背景
permanentFpsFrame.BorderSizePixel = 0
permanentFpsFrame.Parent = screenGui

local permanentFpsLabel = Instance.new("TextLabel")
permanentFpsLabel.Size = UDim2.new(1, 0, 1, 0)
permanentFpsLabel.BackgroundTransparency = 1
permanentFpsLabel.Text = "60 FPS"
permanentFpsLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
permanentFpsLabel.TextSize = 18
permanentFpsLabel.Font = Enum.Font.GothamBold
permanentFpsLabel.TextStrokeTransparency = 0  -- 添加文字描边
permanentFpsLabel.TextStrokeColor3 = Color3.fromRGB(255, 100, 100)  -- 彩色描边，会动态变化
permanentFpsLabel.Parent = permanentFpsFrame

-- 保存描边引用以便后续更新颜色
local permanentFpsStroke = permanentFpsLabel

-- 窗口层级管理
local currentZIndex = 1
local function bringToFront(frame)
    currentZIndex = currentZIndex + 1
    frame.ZIndex = currentZIndex
    for _, child in pairs(frame:GetDescendants()) do
        if child:IsA("GuiObject") then
            child.ZIndex = currentZIndex
        end
    end
end

-- 创建缩放手柄函数
local function createResizeHandle(frame)
    local resizeHandle = Instance.new("TextButton")
    resizeHandle.Size = UDim2.new(0, 20, 0, 20)
    resizeHandle.Position = UDim2.new(1, -20, 1, -20)
    resizeHandle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    resizeHandle.Text = "⟲"
    resizeHandle.TextColor3 = Color3.fromRGB(255, 255, 255)
    resizeHandle.TextSize = 12
    resizeHandle.Font = Enum.Font.GothamBold
    resizeHandle.BorderSizePixel = 0
    resizeHandle.Active = false
    resizeHandle.Parent = frame
    
    local resizeCorner = Instance.new("UICorner")
    resizeCorner.CornerRadius = UDim.new(0, 3)
    resizeCorner.Parent = resizeHandle
    
    local dragging = false
    local startSize = frame.Size
    local startPos = Vector2.new(0, 0)
    
    resizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            startSize = frame.Size
            startPos = Vector2.new(input.Position.X, input.Position.Y)
            bringToFront(frame)
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local currentPos = Vector2.new(input.Position.X, input.Position.Y)
            local delta = currentPos - startPos
            
            local newWidth = math.max(200, startSize.X.Offset + delta.X)
            local newHeight = math.max(150, startSize.Y.Offset + delta.Y)
            
            frame.Size = UDim2.new(0, newWidth, 0, newHeight)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- 主窗口框架
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 350, 0, 450)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(savedConfig.mainFrameColor[1], savedConfig.mainFrameColor[2], savedConfig.mainFrameColor[3])
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- 主窗口点击置顶
mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        bringToFront(mainFrame)
    end
end)

-- 添加圆角和光带效果（去掉灰色阴影）
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- 流动光带边框
local lightBorder = Instance.new("UIStroke")
lightBorder.Color = Color3.fromRGB(savedConfig.borderColor[1], savedConfig.borderColor[2], savedConfig.borderColor[3])
lightBorder.Thickness = 3
lightBorder.Parent = mainFrame

-- 主窗口缩放手柄
createResizeHandle(mainFrame)

-- 标题栏
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(savedConfig.titleBarColor[1], savedConfig.titleBarColor[2], savedConfig.titleBarColor[3])
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

-- 缩小时的当前时间显示（左边）
local minimizedTime = Instance.new("TextLabel")
minimizedTime.Size = UDim2.new(0, 60, 1, 0)
minimizedTime.Position = UDim2.new(0, 10, 0, 0)
minimizedTime.BackgroundTransparency = 1
minimizedTime.Text = "12:00"
minimizedTime.TextColor3 = Color3.fromRGB(255, 200, 100)
minimizedTime.TextSize = 12
minimizedTime.Font = Enum.Font.GothamBold
minimizedTime.Visible = false
minimizedTime.Parent = titleBar

-- 标题文本（居中）
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, -80, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "小拽脚本"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- 缩小时的FPS显示（右边）
local minimizedFPS = Instance.new("TextLabel")
minimizedFPS.Size = UDim2.new(0, 60, 1, 0)
minimizedFPS.Position = UDim2.new(1, -130, 0, 0)
minimizedFPS.BackgroundTransparency = 1
minimizedFPS.Text = "60 FPS"
minimizedFPS.TextColor3 = Color3.fromRGB(100, 255, 100)
minimizedFPS.TextSize = 12
minimizedFPS.Font = Enum.Font.GothamBold
minimizedFPS.Visible = false
minimizedFPS.Parent = titleBar

-- 最小化按钮
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Name = "MinimizeButton"
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -70, 0, 5)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
minimizeBtn.Text = "—"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.TextScaled = true
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Parent = titleBar

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0.5, 0)
minimizeCorner.Parent = minimizeBtn

-- 关闭按钮
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseButton"
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

-- 内容区域
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -20, 1, -60)
contentFrame.Position = UDim2.new(0, 10, 0, 50)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- 游戏信息区域（上半部分）
local infoFrame = Instance.new("Frame")
infoFrame.Name = "InfoFrame"
infoFrame.Size = UDim2.new(1, 0, 0, 150)
infoFrame.Position = UDim2.new(0, 0, 0, 0)
infoFrame.BackgroundColor3 = Color3.fromRGB(savedConfig.infoFrameColor[1], savedConfig.infoFrameColor[2], savedConfig.infoFrameColor[3])
infoFrame.BorderSizePixel = 0
infoFrame.Parent = contentFrame

local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 8)
infoCorner.Parent = infoFrame

-- 信息标题
local infoTitle = Instance.new("TextLabel")
infoTitle.Name = "InfoTitle"
infoTitle.Size = UDim2.new(1, -20, 0, 25)
infoTitle.Position = UDim2.new(0, 10, 0, 5)
infoTitle.BackgroundTransparency = 1
infoTitle.Text = "📊 游戏信息"
infoTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
infoTitle.TextScaled = true
infoTitle.Font = Enum.Font.GothamBold
infoTitle.Parent = infoFrame

-- 玩家信息
local playerInfo = Instance.new("TextLabel")
playerInfo.Name = "PlayerInfo"
playerInfo.Size = UDim2.new(1, -20, 0, 25)
playerInfo.Position = UDim2.new(0, 10, 0, 30)
playerInfo.BackgroundTransparency = 1
playerInfo.Text = "玩家: " .. player.Name
playerInfo.TextColor3 = Color3.fromRGB(200, 200, 200)
playerInfo.TextScaled = true
playerInfo.Font = Enum.Font.Gotham
playerInfo.TextXAlignment = Enum.TextXAlignment.Left
playerInfo.Parent = infoFrame

-- FPS显示
local fpsLabel = Instance.new("TextLabel")
fpsLabel.Name = "FPSLabel"
fpsLabel.Size = UDim2.new(1, -20, 0, 25)
fpsLabel.Position = UDim2.new(0, 10, 0, 55)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Text = "帧率: 60 FPS"
fpsLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
fpsLabel.TextScaled = true
fpsLabel.Font = Enum.Font.Gotham
fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
fpsLabel.Parent = infoFrame

-- 移动速度显示
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, -20, 0, 25)
speedLabel.Position = UDim2.new(0, 10, 0, 80)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "速度: 16"
speedLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = infoFrame

-- 当前时间显示
local currentTimeLabel = Instance.new("TextLabel")
currentTimeLabel.Size = UDim2.new(1, -20, 0, 25)
currentTimeLabel.Position = UDim2.new(0, 10, 0, 105)
currentTimeLabel.BackgroundTransparency = 1
currentTimeLabel.Text = "时间: 12:00:00"
currentTimeLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
currentTimeLabel.TextScaled = true
currentTimeLabel.Font = Enum.Font.Gotham
currentTimeLabel.TextXAlignment = Enum.TextXAlignment.Left
currentTimeLabel.Parent = infoFrame

-- 功能按钮区域（下半部分，两列布局）
local buttonFrame = Instance.new("Frame")
buttonFrame.Name = "ButtonFrame"
buttonFrame.Size = UDim2.new(1, 0, 0, 120)
buttonFrame.Position = UDim2.new(0, 0, 0, 160)
buttonFrame.BackgroundTransparency = 1
buttonFrame.Parent = contentFrame

-- 飞行变量
local flying = false
local bodyVelocity = nil
local bodyAngularVelocity = nil
local flySpeed = savedConfig.flySpeed or 50

-- 飞行功能
local function toggleFly()
    flying = not flying
    
    if flying then
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = player.Character.HumanoidRootPart
            
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.Parent = rootPart
            
            bodyAngularVelocity = Instance.new("BodyAngularVelocity")
            bodyAngularVelocity.MaxTorque = Vector3.new(0, math.huge, 0)
            bodyAngularVelocity.AngularVelocity = Vector3.new(0, 0, 0)
            bodyAngularVelocity.Parent = rootPart
            
            print("飞行模式已开启")
        end
    else
        if bodyVelocity then 
            bodyVelocity:Destroy() 
            bodyVelocity = nil
        end
        if bodyAngularVelocity then
            bodyAngularVelocity:Destroy()
            bodyAngularVelocity = nil
        end
        print("飞行模式已关闭")
    end
end

-- 屏幕左侧飞行控制按钮（可拖动，不可缩放）
local leftControlFrame = Instance.new("Frame")
leftControlFrame.Size = UDim2.new(0, 200, 0, 230)
leftControlFrame.Position = UDim2.new(0, 10, 0.5, -115)
leftControlFrame.BackgroundTransparency = 1
leftControlFrame.Visible = false
leftControlFrame.Active = true
leftControlFrame.Draggable = true
leftControlFrame.Parent = screenGui

-- 飞行控制窗口点击置顶
leftControlFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        bringToFront(leftControlFrame)
    end
end)

-- 飞行速度标签
local flySpeedLabel = Instance.new("TextLabel")
flySpeedLabel.Size = UDim2.new(1, 0, 0, 20)
flySpeedLabel.Position = UDim2.new(0, 0, 0, 0)
flySpeedLabel.BackgroundTransparency = 1
flySpeedLabel.Text = "飞行速度: " .. flySpeed
flySpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
flySpeedLabel.TextSize = 12
flySpeedLabel.Font = Enum.Font.Gotham
flySpeedLabel.Parent = leftControlFrame

-- 飞行速度输入框
local flySpeedInput = Instance.new("TextBox")
flySpeedInput.Size = UDim2.new(0, 80, 0, 25)
flySpeedInput.Position = UDim2.new(0, 10, 0, 20)
flySpeedInput.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
flySpeedInput.Text = tostring(flySpeed)
flySpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
flySpeedInput.TextSize = 12
flySpeedInput.Font = Enum.Font.Gotham
flySpeedInput.BorderSizePixel = 0
flySpeedInput.Parent = leftControlFrame
local flySpeedInputCorner = Instance.new("UICorner")
flySpeedInputCorner.CornerRadius = UDim.new(0, 4)
flySpeedInputCorner.Parent = flySpeedInput

local flySpeedSetBtn = Instance.new("TextButton")
flySpeedSetBtn.Size = UDim2.new(0, 60, 0, 25)
flySpeedSetBtn.Position = UDim2.new(0, 100, 0, 20)
flySpeedSetBtn.BackgroundColor3 = Color3.fromRGB(40, 167, 69)
flySpeedSetBtn.Text = "设置"
flySpeedSetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
flySpeedSetBtn.TextSize = 12
flySpeedSetBtn.Font = Enum.Font.GothamBold
flySpeedSetBtn.BorderSizePixel = 0
flySpeedSetBtn.Parent = leftControlFrame
local flySpeedSetBtnCorner = Instance.new("UICorner")
flySpeedSetBtnCorner.CornerRadius = UDim.new(0, 4)
flySpeedSetBtnCorner.Parent = flySpeedSetBtn

flySpeedSetBtn.MouseButton1Click:Connect(function()
    local newSpeed = tonumber(flySpeedInput.Text)
    if newSpeed and newSpeed > 0 then
        flySpeed = newSpeed
        flySpeedLabel.Text = "飞行速度: " .. flySpeed
        savedConfig.flySpeed = flySpeed
        saveConfig()
        print("✅ 飞行速度已设置为: " .. flySpeed)
    else
        flySpeedInput.Text = tostring(flySpeed)
    end
end)

-- 开启/关闭飞天按钮（最上方中央）
local toggleFlyBtn = Instance.new("TextButton")
toggleFlyBtn.Size = UDim2.new(0, 120, 0, 35)
toggleFlyBtn.Position = UDim2.new(0, 40, 0, 50)
toggleFlyBtn.BackgroundColor3 = Color3.fromRGB(255, 193, 7)
toggleFlyBtn.Text = "开启飞天"
toggleFlyBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
toggleFlyBtn.TextSize = 14
toggleFlyBtn.Font = Enum.Font.GothamBold
toggleFlyBtn.BorderSizePixel = 0
toggleFlyBtn.Parent = leftControlFrame

local toggleFlyCorner = Instance.new("UICorner")
toggleFlyCorner.CornerRadius = UDim.new(0, 8)
toggleFlyCorner.Parent = toggleFlyBtn

-- 上下控制（左边）
local upBtn = Instance.new("TextButton")
upBtn.Size = UDim2.new(0, 80, 0, 40)
upBtn.Position = UDim2.new(0, 0, 0, 95)
upBtn.BackgroundColor3 = Color3.fromRGB(0, 123, 255)
upBtn.Text = "上升\n(空格)"
upBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
upBtn.TextSize = 12
upBtn.Font = Enum.Font.GothamBold
upBtn.BorderSizePixel = 0
upBtn.Parent = leftControlFrame

local upCorner = Instance.new("UICorner")
upCorner.CornerRadius = UDim.new(0, 8)
upCorner.Parent = upBtn

local downBtn = Instance.new("TextButton")
downBtn.Size = UDim2.new(0, 80, 0, 40)
downBtn.Position = UDim2.new(0, 0, 0, 145)
downBtn.BackgroundColor3 = Color3.fromRGB(0, 123, 255)
downBtn.Text = "下降\n(C键)"
downBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
downBtn.TextSize = 12
downBtn.Font = Enum.Font.GothamBold
downBtn.BorderSizePixel = 0
downBtn.Parent = leftControlFrame

local downCorner = Instance.new("UICorner")
downCorner.CornerRadius = UDim.new(0, 8)
downCorner.Parent = downBtn

-- 前后控制（右边）
local forwardBtn = Instance.new("TextButton")
forwardBtn.Size = UDim2.new(0, 80, 0, 40)
forwardBtn.Position = UDim2.new(0, 100, 0, 95)
forwardBtn.BackgroundColor3 = Color3.fromRGB(40, 167, 69)
forwardBtn.Text = "前进\n(W键)"
forwardBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
forwardBtn.TextSize = 12
forwardBtn.Font = Enum.Font.GothamBold
forwardBtn.BorderSizePixel = 0
forwardBtn.Parent = leftControlFrame

local forwardCorner = Instance.new("UICorner")
forwardCorner.CornerRadius = UDim.new(0, 8)
forwardCorner.Parent = forwardBtn

local backwardBtn = Instance.new("TextButton")
backwardBtn.Size = UDim2.new(0, 80, 0, 40)
backwardBtn.Position = UDim2.new(0, 100, 0, 145)
backwardBtn.BackgroundColor3 = Color3.fromRGB(40, 167, 69)
backwardBtn.Text = "后退\n(S键)"
backwardBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
backwardBtn.TextSize = 12
backwardBtn.Font = Enum.Font.GothamBold
backwardBtn.BorderSizePixel = 0
backwardBtn.Parent = leftControlFrame

local backwardCorner = Instance.new("UICorner")
backwardCorner.CornerRadius = UDim.new(0, 8)
backwardCorner.Parent = backwardBtn

-- 持续性飞行控制
local flyingUp = false
local flyingDown = false
local flyingForward = false
local flyingBackward = false

-- 开启/关闭飞天按钮
toggleFlyBtn.MouseButton1Click:Connect(function()
    toggleFly()
    if flying then
        toggleFlyBtn.Text = "关闭飞天"
        toggleFlyBtn.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
        toggleFlyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        toggleFlyBtn.Text = "开启飞天"
        toggleFlyBtn.BackgroundColor3 = Color3.fromRGB(255, 193, 7)
        toggleFlyBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    end
end)

-- 上升按钮
upBtn.MouseButton1Down:Connect(function()
    flyingUp = true
end)
upBtn.MouseButton1Up:Connect(function()
    flyingUp = false
end)

-- 下降按钮
downBtn.MouseButton1Down:Connect(function()
    flyingDown = true
end)
downBtn.MouseButton1Up:Connect(function()
    flyingDown = false
end)

-- 前进按钮
forwardBtn.MouseButton1Down:Connect(function()
    flyingForward = true
end)
forwardBtn.MouseButton1Up:Connect(function()
    flyingForward = false
end)

-- 后退按钮
backwardBtn.MouseButton1Down:Connect(function()
    flyingBackward = true
end)
backwardBtn.MouseButton1Up:Connect(function()
    flyingBackward = false
end)

-- 飞行控制循环
local function flyControl()
    if not flying or not bodyVelocity then return end
    
    local character = player.Character
    if not character then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    local camera = workspace.CurrentCamera
    local moveVector = Vector3.new(0, 0, 0)
    
    -- 按钮控制
    if flyingUp then
        moveVector = moveVector + Vector3.new(0, 1, 0)
    end
    if flyingDown then
        moveVector = moveVector - Vector3.new(0, 1, 0)
    end
    if flyingForward then
        moveVector = moveVector + camera.CFrame.LookVector
    end
    if flyingBackward then
        moveVector = moveVector - camera.CFrame.LookVector
    end
    
    -- 键盘控制（电脑专用）
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        moveVector = moveVector + Vector3.new(0, 1, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.C) then
        moveVector = moveVector - Vector3.new(0, 1, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        moveVector = moveVector + camera.CFrame.LookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
        moveVector = moveVector - camera.CFrame.LookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
        moveVector = moveVector - camera.CFrame.RightVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
        moveVector = moveVector + camera.CFrame.RightVector
    end
    
    bodyVelocity.Velocity = moveVector * flySpeed
end

-- 启动飞行控制循环
RunService.Heartbeat:Connect(flyControl)

-- 移速设置窗口（可拖动，可缩放）
local speedWindow = Instance.new("Frame")
speedWindow.Size = UDim2.new(0, 400, 0, 500)
speedWindow.Position = UDim2.new(0, 370, 0, 20)
speedWindow.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
speedWindow.BorderSizePixel = 0
speedWindow.Visible = false
speedWindow.Active = true
speedWindow.Draggable = true
speedWindow.Parent = screenGui

-- 移速窗口点击置顶
speedWindow.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        bringToFront(speedWindow)
    end
end)

local speedWindowCorner = Instance.new("UICorner")
speedWindowCorner.CornerRadius = UDim.new(0, 10)
speedWindowCorner.Parent = speedWindow

local speedWindowBorder = Instance.new("UIStroke")
speedWindowBorder.Color = Color3.fromRGB(savedConfig.borderColor[1], savedConfig.borderColor[2], savedConfig.borderColor[3]) -- 使用保存的边框颜色
speedWindowBorder.Thickness = 2
speedWindowBorder.Parent = speedWindow

-- 移速窗口缩放手柄
createResizeHandle(speedWindow)

local speedTitle = Instance.new("TextLabel")
speedTitle.Size = UDim2.new(1, -25, 0, 30)
speedTitle.Position = UDim2.new(0, 5, 0, 5)
speedTitle.BackgroundTransparency = 1
speedTitle.Text = "⚡ 移动速度设置"
speedTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
speedTitle.TextSize = 14
speedTitle.Font = Enum.Font.GothamBold
speedTitle.Parent = speedWindow

local speedCloseBtn = Instance.new("TextButton")
speedCloseBtn.Size = UDim2.new(0, 20, 0, 20)
speedCloseBtn.Position = UDim2.new(1, -25, 0, 5)
speedCloseBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
speedCloseBtn.Text = "×"
speedCloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
speedCloseBtn.TextSize = 12
speedCloseBtn.BorderSizePixel = 0
speedCloseBtn.Parent = speedWindow

local speedCloseBtnCorner = Instance.new("UICorner")
speedCloseBtnCorner.CornerRadius = UDim.new(0, 3)
speedCloseBtnCorner.Parent = speedCloseBtn

-- 自定义移速区域（移到顶部）
local customSpeedFrame = Instance.new("Frame")
customSpeedFrame.Size = UDim2.new(1, -20, 0, 80)
customSpeedFrame.Position = UDim2.new(0, 10, 0, 40)
customSpeedFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
customSpeedFrame.BorderSizePixel = 0
customSpeedFrame.Parent = speedWindow

local customSpeedCorner = Instance.new("UICorner")
customSpeedCorner.CornerRadius = UDim.new(0, 8)
customSpeedCorner.Parent = customSpeedFrame

local customSpeedLabel = Instance.new("TextLabel")
customSpeedLabel.Size = UDim2.new(1, 0, 0, 25)
customSpeedLabel.Position = UDim2.new(0, 0, 0, 5)
customSpeedLabel.BackgroundTransparency = 1
customSpeedLabel.Text = "自定义移速"
customSpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
customSpeedLabel.TextSize = 14
customSpeedLabel.Font = Enum.Font.GothamBold
customSpeedLabel.Parent = customSpeedFrame

local customSpeedInput = Instance.new("TextBox")
customSpeedInput.Size = UDim2.new(0, 200, 0, 30)
customSpeedInput.Position = UDim2.new(0, 10, 0, 30)
customSpeedInput.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
customSpeedInput.Text = "输入速度值"
customSpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
customSpeedInput.TextSize = 12
customSpeedInput.Font = Enum.Font.Gotham
customSpeedInput.BorderSizePixel = 0
customSpeedInput.Parent = customSpeedFrame

local customSpeedInputCorner = Instance.new("UICorner")
customSpeedInputCorner.CornerRadius = UDim.new(0, 5)
customSpeedInputCorner.Parent = customSpeedInput

local customSpeedSetBtn = Instance.new("TextButton")
customSpeedSetBtn.Size = UDim2.new(0, 80, 0, 30)
customSpeedSetBtn.Position = UDim2.new(0, 220, 0, 30)
customSpeedSetBtn.BackgroundColor3 = Color3.fromRGB(40, 167, 69)
customSpeedSetBtn.Text = "设置"
customSpeedSetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
customSpeedSetBtn.TextSize = 12
customSpeedSetBtn.Font = Enum.Font.GothamBold
customSpeedSetBtn.BorderSizePixel = 0
customSpeedSetBtn.Parent = customSpeedFrame

local customSpeedSetBtnCorner = Instance.new("UICorner")
customSpeedSetBtnCorner.CornerRadius = UDim.new(0, 5)
customSpeedSetBtnCorner.Parent = customSpeedSetBtn

customSpeedSetBtn.MouseButton1Click:Connect(function()
    local speedValue = tonumber(customSpeedInput.Text)
    if speedValue and speedValue > 0 then
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = speedValue
            savedConfig.walkSpeed = speedValue
            saveConfig()
            print("自定义移动速度已设置为: " .. speedValue)
        end
    else
        print("请输入有效的数字")
    end
end)

-- 滚动框
local speedScrollFrame = Instance.new("ScrollingFrame")
speedScrollFrame.Size = UDim2.new(1, -20, 1, -130)
speedScrollFrame.Position = UDim2.new(0, 10, 0, 130)
speedScrollFrame.BackgroundTransparency = 1
speedScrollFrame.ScrollBarThickness = 8
speedScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 460)
speedScrollFrame.Parent = speedWindow

-- 预设速度
local speedValues = {100, 200, 300, 400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 2000, 3000, 4000}

for i, speed in ipairs(speedValues) do
    local speedBtn = Instance.new("TextButton")
    speedBtn.Size = UDim2.new(0, 180, 0, 35)
    speedBtn.Position = UDim2.new(0, 10 + ((i-1) % 2) * 190, 0, 10 + math.floor((i-1) / 2) * 45)
    speedBtn.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
    speedBtn.Text = "速度: " .. speed
    speedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedBtn.TextSize = 12
    speedBtn.Font = Enum.Font.Gotham
    speedBtn.BorderSizePixel = 0
    speedBtn.Parent = speedScrollFrame
    
    local speedBtnCorner = Instance.new("UICorner")
    speedBtnCorner.CornerRadius = UDim.new(0, 5)
    speedBtnCorner.Parent = speedBtn
    
    speedBtn.MouseButton1Click:Connect(function()
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = speed
            savedConfig.walkSpeed = speed
            saveConfig()
            print("移动速度已设置为: " .. speed)
        end
    end)
end

-- 颜色选择窗口（可拖动，可缩放）
local colorWindow = Instance.new("Frame")
colorWindow.Size = UDim2.new(0, 320, 0, 300)
colorWindow.Position = UDim2.new(0, 370, 0, 20)
colorWindow.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
colorWindow.BorderSizePixel = 0
colorWindow.Visible = false
colorWindow.Active = true
colorWindow.Draggable = true
colorWindow.Parent = screenGui

-- 颜色窗口点击置顶
colorWindow.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        bringToFront(colorWindow)
    end
end)

local colorWindowCorner = Instance.new("UICorner")
colorWindowCorner.CornerRadius = UDim.new(0, 10)
colorWindowCorner.Parent = colorWindow

local colorWindowBorder = Instance.new("UIStroke")
colorWindowBorder.Color = Color3.fromRGB(savedConfig.borderColor[1], savedConfig.borderColor[2], savedConfig.borderColor[3]) -- 使用保存的边框颜色
colorWindowBorder.Thickness = 2
colorWindowBorder.Parent = colorWindow

-- 颜色窗口缩放手柄
createResizeHandle(colorWindow)

local colorTitle = Instance.new("TextLabel")
colorTitle.Size = UDim2.new(1, -25, 0, 30)
colorTitle.Position = UDim2.new(0, 5, 0, 5)
colorTitle.BackgroundTransparency = 1
colorTitle.Text = "🎨 自定义悬浮窗颜色"
colorTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
colorTitle.TextSize = 14
colorTitle.Font = Enum.Font.GothamBold
colorTitle.Parent = colorWindow

local colorCloseBtn = Instance.new("TextButton")
colorCloseBtn.Size = UDim2.new(0, 20, 0, 20)
colorCloseBtn.Position = UDim2.new(1, -25, 0, 5)
colorCloseBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
colorCloseBtn.Text = "×"
colorCloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
colorCloseBtn.TextSize = 12
colorCloseBtn.BorderSizePixel = 0
colorCloseBtn.Parent = colorWindow

local colorCloseBtnCorner = Instance.new("UICorner")
colorCloseBtnCorner.CornerRadius = UDim.new(0, 3)
colorCloseBtnCorner.Parent = colorCloseBtn

-- 创建滚动框架用于颜色选择
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -10, 1, -40)
scrollFrame.Position = UDim2.new(0, 5, 0, 35)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 6
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)  -- 会根据内容自动调整
scrollFrame.Parent = colorWindow

local scrollFrameCorner = Instance.new("UICorner")
scrollFrameCorner.CornerRadius = UDim.new(0, 5)
scrollFrameCorner.Parent = scrollFrame

local layout = Instance.new("UIGridLayout")
layout.CellSize = UDim2.new(0, 95, 0, 35)
layout.CellPadding = UDim2.new(0, 5, 0, 5)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = scrollFrame

local padding = Instance.new("UIPadding")
padding.PaddingLeft = UDim.new(0, 5)
padding.PaddingTop = UDim.new(0, 5)
padding.Parent = scrollFrame

-- 更多颜色选择
local colors = {
    -- 基础颜色
    {Color3.fromRGB(100, 200, 255), "天空蓝"},
    {Color3.fromRGB(255, 100, 100), "樱花红"},
    {Color3.fromRGB(100, 255, 100), "翡翠绿"},
    {Color3.fromRGB(255, 200, 100), "夕阳橙"},
    {Color3.fromRGB(200, 100, 255), "薰衣紫"},
    {Color3.fromRGB(255, 255, 100), "柠檬黄"},
    {Color3.fromRGB(255, 150, 200), "粉玫瑰"},
    {Color3.fromRGB(150, 255, 200), "薄荷绿"},
    {Color3.fromRGB(200, 255, 150), "青草绿"},
    {Color3.fromRGB(255, 200, 150), "蜜桃橙"},
    {Color3.fromRGB(150, 200, 255), "海洋蓝"},
    {Color3.fromRGB(255, 150, 255), "梦幻紫"},
    
    -- 更多流行颜色
    {Color3.fromRGB(255, 255, 255), "纯白色"},
    {Color3.fromRGB(0, 0, 0), "纯黑色"},
    {Color3.fromRGB(128, 128, 128), "灰色"},
    {Color3.fromRGB(192, 192, 192), "银色"},
    {Color3.fromRGB(128, 0, 0), "深红"},
    {Color3.fromRGB(128, 128, 0), "橄榄绿"},
    {Color3.fromRGB(0, 128, 0), "森林绿"},
    {Color3.fromRGB(128, 0, 128), "紫色"},
    {Color3.fromRGB(0, 128, 128), "青色"},
    {Color3.fromRGB(0, 0, 128), "海军蓝"},
    {Color3.fromRGB(255, 165, 0), "橙色"},
    {Color3.fromRGB(255, 192, 203), "粉色"},
    {Color3.fromRGB(139, 69, 19), "棕色"},
    {Color3.fromRGB(240, 230, 140), "卡其色"},
    {Color3.fromRGB(173, 216, 230), "浅蓝"},
    {Color3.fromRGB(144, 238, 144), "浅绿"},
    {Color3.fromRGB(221, 160, 221), "梅红色"},
    {Color3.fromRGB(255, 218, 185), "桃色"},
    {Color3.fromRGB(255, 105, 180), "热粉色"},
    {Color3.fromRGB(30, 144, 255), "道奇蓝"},
    {Color3.fromRGB(0, 255, 255), "青色"},
    {Color3.fromRGB(50, 205, 50), "石灰绿"},
    {Color3.fromRGB(255, 20, 147), "深粉色"},
    {Color3.fromRGB(0, 191, 255), "深天蓝"},
    {Color3.fromRGB(218, 112, 214), "紫罗兰"},
    {Color3.fromRGB(255, 105, 180), "浅粉色"},
    {Color3.fromRGB(255, 182, 193), "浅粉红"},
    {Color3.fromRGB(175, 238, 238), "浅青色"},
    {Color3.fromRGB(152, 251, 152), "浅绿色"},
    {Color3.fromRGB(176, 196, 222), "浅钢蓝"},
    {Color3.fromRGB(230, 230, 250), "薰衣草"},
    {Color3.fromRGB(255, 228, 225), "薄雾玫瑰"},
    {Color3.fromRGB(250, 250, 210), "象牙白"},
    {Color3.fromRGB(253, 245, 230), "亚麻色"},
    {Color3.fromRGB(245, 255, 250), "蜜瓜色"},
    {Color3.fromRGB(240, 255, 240), "蜜瓜白"},
    {Color3.fromRGB(248, 248, 255), "幽灵白"},
    {Color3.fromRGB(245, 245, 245), "烟白色"},
    {Color3.fromRGB(220, 220, 220), "亮灰色"},
    {Color3.fromRGB(105, 105, 105), "暗灰色"},
    {Color3.fromRGB(47, 79, 79), "暗海绿"},
    {Color3.fromRGB(119, 136, 153), "暗灰蓝"},
    {Color3.fromRGB(112, 128, 144), "石板灰"},
    {Color3.fromRGB(25, 25, 112), "中海蓝"},
    {Color3.fromRGB(0, 0, 139), "深蓝色"},
    {Color3.fromRGB(138, 43, 226), "蓝紫色"},
    {Color3.fromRGB(75, 0, 130), "深紫色"},
    {Color3.fromRGB(123, 104, 238), "中紫色"},
    {Color3.fromRGB(147, 112, 219), "中紫罗兰色"},
    {Color3.fromRGB(186, 85, 211), "紫罗兰色"},
    {Color3.fromRGB(238, 130, 238), "紫水晶色"},
    {Color3.fromRGB(216, 191, 216), "苍白紫罗兰色"},
    {Color3.fromRGB(255, 0, 255), "洋红色"},
    {Color3.fromRGB(255, 20, 147), "深粉色"},
    {Color3.fromRGB(255, 105, 180), "热粉色"},
    {Color3.fromRGB(199, 21, 133), "深粉色"},
    {Color3.fromRGB(219, 112, 147), "苍白紫红色"},
    {Color3.fromRGB(255, 182, 193), "浅粉红"},
    {Color3.fromRGB(255, 192, 203), "粉色"},
    {Color3.fromRGB(255, 160, 122), "浅珊瑚色"},
    {Color3.fromRGB(240, 128, 128), "淡珊瑚色"},
    {Color3.fromRGB(233, 150, 122), "浅鲑鱼色"},
    {Color3.fromRGB(250, 128, 114), "鲑鱼色"},
    {Color3.fromRGB(255, 99, 71), "番茄色"},
    {Color3.fromRGB(255, 69, 0), "橙红色"},
    {Color3.fromRGB(255, 140, 0), "深橙色"},
    {Color3.fromRGB(255, 165, 0), "橙色"},
    {Color3.fromRGB(255, 215, 0), "金色"},
    {Color3.fromRGB(238, 232, 170), "淡金色"},
    {Color3.fromRGB(189, 183, 107), "深卡其色"},
    {Color3.fromRGB(240, 230, 140), "卡其色"},
    {Color3.fromRGB(230, 230, 0), "橄榄色"},
    {Color3.fromRGB(184, 134, 11), "暗金黄色"},
    {Color3.fromRGB(255, 255, 0), "黄色"},
    {Color3.fromRGB(154, 205, 50), "黄绿色"},
    {Color3.fromRGB(85, 107, 47), "橄榄土褐色"},
    {Color3.fromRGB(107, 142, 35), "橄榄军服绿"},
    {Color3.fromRGB(128, 128, 0), "橄榄色"},
    {Color3.fromRGB(124, 252, 0), "草绿色"},
    {Color3.fromRGB(0, 255, 0), "纯绿色"},
    {Color3.fromRGB(34, 139, 34), "森林绿"},
    {Color3.fromRGB(0, 250, 154), "春绿色"},
    {Color3.fromRGB(0, 255, 127), "春天绿"},
    {Color3.fromRGB(143, 188, 143), "暗海绿"},
    {Color3.fromRGB(46, 139, 87), "海绿色"},
    {Color3.fromRGB(60, 179, 113), "中海绿"},
    {Color3.fromRGB(32, 178, 170), "浅海绿"},
    {Color3.fromRGB(0, 128, 128), "青色"},
    {Color3.fromRGB(0, 206, 209), "深青色"},
    {Color3.fromRGB(72, 209, 204), "中青色"},
    {Color3.fromRGB(64, 224, 208), "碧绿色"},
    {Color3.fromRGB(0, 139, 139), "深青色"},
    {Color3.fromRGB(0, 0, 255), "纯蓝色"},
    {Color3.fromRGB(30, 144, 255), "道奇蓝"},
    {Color3.fromRGB(135, 206, 250), "浅天蓝"},
    {Color3.fromRGB(135, 206, 235), "天空蓝"},
    {Color3.fromRGB(70, 130, 180), "钢蓝色"},
    {Color3.fromRGB(176, 196, 222), "浅钢蓝"},
    {Color3.fromRGB(100, 149, 237), "玉米花蓝"},
    {Color3.fromRGB(25, 25, 112), "中海蓝"},
    {Color3.fromRGB(0, 0, 139), "深蓝色"},
    {Color3.fromRGB(0, 0, 128), "海军蓝"},
    {Color3.fromRGB(240, 248, 255), "爱丽丝蓝"},
    {Color3.fromRGB(230, 240, 250), "钢青色"},
    {Color3.fromRGB(255, 240, 245), "雪花色"},
    {Color3.fromRGB(248, 248, 255), "幽灵白"},
    {Color3.fromRGB(245, 245, 245), "烟白色"},
    {Color3.fromRGB(255, 250, 250), "雪白色"}
}

for i, colorData in ipairs(colors) do
    local colorBtn = Instance.new("TextButton")
    colorBtn.BackgroundColor3 = colorData[1]
    colorBtn.Text = colorData[2]
    colorBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    colorBtn.TextSize = 10
    colorBtn.Font = Enum.Font.Gotham
    colorBtn.BorderSizePixel = 0
    colorBtn.LayoutOrder = i  -- 设置布局顺序
    colorBtn.Parent = scrollFrame
    
    local colorBtnCorner = Instance.new("UICorner")
    colorBtnCorner.CornerRadius = UDim.new(0, 5)
    colorBtnCorner.Parent = colorBtn
    
    colorBtn.MouseButton1Click:Connect(function()
        -- 更新主窗口颜色
        mainFrame.BackgroundColor3 = colorData[1]
        titleBar.BackgroundColor3 = Color3.new(colorData[1].R * 0.8, colorData[1].G * 0.8, colorData[1].B * 0.8)
        infoFrame.BackgroundColor3 = Color3.new(colorData[1].R * 0.6, colorData[1].G * 0.6, colorData[1].B * 0.6)
        lightBorder.Color = colorData[1]
        
        -- 更新其他窗口颜色（除了飞行模式窗口）
        if speedWindow then
            -- 使用相同颜色作为速度窗口背景
            speedWindow.BackgroundColor3 = colorData[1]
            -- 更新速度窗口边框颜色
            local speedWindowBorder = speedWindow:FindFirstChild("UIStroke")
            if speedWindowBorder then
                speedWindowBorder.Color = colorData[1]
            end
        end
        
        if colorWindow then
            -- 使用相同颜色作为颜色窗口背景
            colorWindow.BackgroundColor3 = colorData[1]
            -- 更新颜色窗口边框颜色
            local colorWindowBorder = colorWindow:FindFirstChild("UIStroke")
            if colorWindowBorder then
                colorWindowBorder.Color = colorData[1]
            end
        end
        
        -- 查找并更新名称窗口颜色
        local nameWindow = screenGui:FindFirstChild("NameWindow")
        if nameWindow then
            -- 使用相同颜色作为名称窗口背景
            nameWindow.BackgroundColor3 = colorData[1]
            -- 更新名称窗口边框颜色
            local nameWindowBorder = nameWindow:FindFirstChild("UIStroke")
            if nameWindowBorder then
                nameWindowBorder.Color = colorData[1] -- 使用主窗口边框颜色
            end
        end
        
        -- 查找并更新白名单窗口颜色
        local whitelistFrame = screenGui:FindFirstChild("WhitelistWindow")
        if whitelistFrame then
            -- 使用相同颜色作为白名单窗口背景
            whitelistFrame.BackgroundColor3 = colorData[1]
            -- 更新白名单窗口边框颜色
            local whitelistBorder = whitelistFrame:FindFirstChild("UIStroke")
            if whitelistBorder then
                whitelistBorder.Color = colorData[1]
            end
        end
        
        -- 查找并更新FPS位置窗口颜色
        local fpsPosWindow = screenGui:FindFirstChild("FPSPositionWindow")
        if fpsPosWindow then
            -- 使用相同颜色作为FPS位置窗口背景
            fpsPosWindow.BackgroundColor3 = colorData[1]
            -- 更新FPS位置窗口边框颜色
            local fpsPosBorder = fpsPosWindow:FindFirstChild("UIStroke")
            if fpsPosBorder then
                fpsPosBorder.Color = colorData[1]
            end
        end
        
        -- 保存配置
        savedConfig.mainFrameColor = {math.floor(colorData[1].R * 255), math.floor(colorData[1].G * 255), math.floor(colorData[1].B * 255)}
        savedConfig.titleBarColor = {math.floor(colorData[1].R * 0.8 * 255), math.floor(colorData[1].G * 0.8 * 255), math.floor(colorData[1].B * 0.8 * 255)}
        savedConfig.infoFrameColor = {math.floor(colorData[1].R * 0.6 * 255), math.floor(colorData[1].G * 0.6 * 255), math.floor(colorData[1].B * 0.6 * 255)}
        savedConfig.borderColor = {math.floor(colorData[1].R * 255), math.floor(colorData[1].G * 255), math.floor(colorData[1].B * 255)}
        saveConfig()
        print("颜色已更改为: " .. colorData[2])
    end)
end

-- 更新CanvasSize以适应所有颜色按钮
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

-- 创建两列按钮函数
local function createSmallButton(text, color, icon, position, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 155, 0, 35)
    button.Position = position
    button.BackgroundColor3 = color
    button.Text = icon .. " " .. text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 12
    button.Font = Enum.Font.Gotham
    button.BorderSizePixel = 0
    button.Parent = buttonFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = button
    
    button.MouseEnter:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.new(color.R + 0.1, color.G + 0.1, color.B + 0.1)})
        tween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = color})
        tween:Play()
    end)
    
    if callback then
        button.MouseButton1Click:Connect(callback)
    end
    
    return button
end

-- 创建两列三个按钮
createSmallButton("飞行模式", Color3.fromRGB(0, 123, 255), "✈️", UDim2.new(0, 5, 0, 5), function()
    leftControlFrame.Visible = not leftControlFrame.Visible
end)

createSmallButton("移速设置", Color3.fromRGB(220, 53, 69), "⚡", UDim2.new(0, 170, 0, 5), function()
    speedWindow.Visible = not speedWindow.Visible
    colorWindow.Visible = false
end)

createSmallButton("自定义颜色", Color3.fromRGB(138, 43, 226), "🎨", UDim2.new(0, 5, 0, 50), function()
    colorWindow.Visible = not colorWindow.Visible
    speedWindow.Visible = false
end)

local showHeadStats = savedConfig.showHeadStats or false
local playerStatsGuis = {}
local playerStatsConnections = {}

local function sizeGrowth(level) return math.floor(((level + 0.5) ^ 2 - 0.25) / 2 * 100) end
local function eatSpeedGrowth(level) return math.floor((1 + (level - 1) * 0.2) * 10) / 10 end

local warnedPlayers = {}

-- 修改点2: 优化危险玩家检测逻辑（只在加入/重生时检测）
local function checkDangerousPlayersOnJoin(targetPlayer)
    if targetPlayer ~= player and not warnedPlayers[targetPlayer.UserId] and targetPlayer:FindFirstChild("Upgrades") then
        local maxSize = targetPlayer.Upgrades:FindFirstChild("MaxSize")
        if maxSize then
            local volume = sizeGrowth(maxSize.Value)
            if volume >= 10000000 then
                warnedPlayers[targetPlayer.UserId] = true
                showDangerWarning(targetPlayer)
            end
        end
    end
end

Players.PlayerRemoving:Connect(function(removingPlayer)
    warnedPlayers[removingPlayer.UserId] = nil
end)

Players.PlayerAdded:Connect(function(newPlayer)
    task.wait(1)
    checkDangerousPlayersOnJoin(newPlayer)
    newPlayer.CharacterAdded:Connect(function(char)
        task.wait(1)
        checkDangerousPlayersOnJoin(newPlayer)
    end)
end)

-- 初始化时检查已存在的玩家
for _, existingPlayer in pairs(Players:GetPlayers()) do
    checkDangerousPlayersOnJoin(existingPlayer)
    existingPlayer.CharacterAdded:Connect(function(char)
        task.wait(1)
        checkDangerousPlayersOnJoin(existingPlayer)
    end)
end

local function updateHeadStats()
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("Head") then
            local existingGui = p.Character.Head:FindFirstChild("HeadStatsGui")
            if existingGui then
                local statsLabel = existingGui:FindFirstChildOfClass("TextLabel")
                if statsLabel then
                    statsLabel.TextColor3 = savedConfig.headTextColor and Color3.fromRGB(savedConfig.headTextColor[1], savedConfig.headTextColor[2], savedConfig.headTextColor[3]) or Color3.fromRGB(255, 255, 255)
                    statsLabel.TextSize = savedConfig.headTextSize or 12
                end
            end
        end
    end
end

local function createHeadStatsForPlayer(targetPlayer)
    if targetPlayer == player then return end
    if not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("Head") then return end
    if playerStatsGuis[targetPlayer.UserId] then playerStatsGuis[targetPlayer.UserId]:Destroy() end
    if playerStatsConnections[targetPlayer.UserId] then playerStatsConnections[targetPlayer.UserId]:Disconnect() end
    local gui = Instance.new("BillboardGui")
    gui.Name = "HeadStatsGui"
    gui.Adornee = targetPlayer.Character.Head

    gui.Size = UDim2.new(0, 150, 0, 120)
    gui.StudsOffset = Vector3.new(0, 2.5, 0)
    gui.AlwaysOnTop = true
    gui.Parent = targetPlayer.Character.Head
    local statsLabel = Instance.new("TextLabel")
    statsLabel.Size = UDim2.new(1, 0, 1, 0)
    statsLabel.BackgroundTransparency = 1
    statsLabel.TextColor3 = savedConfig.headTextColor and Color3.fromRGB(savedConfig.headTextColor[1], savedConfig.headTextColor[2], savedConfig.headTextColor[3]) or Color3.fromRGB(255, 255, 255)
    statsLabel.TextSize = savedConfig.headTextSize or 12
    statsLabel.Font = Enum.Font.GothamBold
    statsLabel.RichText = true
    statsLabel.TextStrokeTransparency = 0
    statsLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    statsLabel.TextYAlignment = Enum.TextYAlignment.Top
    statsLabel.Parent = gui
    playerStatsGuis[targetPlayer.UserId] = gui
    
    -- 彩虹颜色数组
    local rainbowColors = {
        "#FF0000", -- 红
        "#FF7F00", -- 橙
        "#FFFF00", -- 黄
        "#00FF00", -- 绿
        "#00FFFF", -- 青
        "#0000FF", -- 蓝
        "#8B00FF"  -- 紫
    }
    local colorIndex = 1
    local colorChangeTime = 0
    
    local connection = RunService.Heartbeat:Connect(function(deltaTime)
        if not showHeadStats or not targetPlayer.Character or not gui.Parent then
            if playerStatsGuis[targetPlayer.UserId] then playerStatsGuis[targetPlayer.UserId]:Destroy() playerStatsGuis[targetPlayer.UserId] = nil end
            if playerStatsConnections[targetPlayer.UserId] then playerStatsConnections[targetPlayer.UserId]:Disconnect() playerStatsConnections[targetPlayer.UserId] = nil end
            return
        end
        
        -- 定期切换颜色（每0.2秒切换一次）
        colorChangeTime = colorChangeTime + deltaTime
        if colorChangeTime >= 0.2 then
            colorIndex = colorIndex + 1
            if colorIndex > #rainbowColors then
                colorIndex = 1
            end
            colorChangeTime = 0
        end
        
        local humanoid = targetPlayer.Character:FindFirstChild("Humanoid")
        if humanoid and targetPlayer:FindFirstChild("Upgrades") then
            local maxSize = targetPlayer.Upgrades:FindFirstChild("MaxSize")
            local multiplier = targetPlayer.Upgrades:FindFirstChild("Multiplier")
            local eatSpeed = targetPlayer.Upgrades:FindFirstChild("EatSpeed")
            local speed = humanoid.WalkSpeed
            local maxSizeLevel = maxSize and maxSize.Value or 0
            local maxSizeValue = sizeGrowth(maxSizeLevel)
            local multiplierValue = multiplier and multiplier.Value or 0
            local eatSpeedLevel = eatSpeed and eatSpeed.Value or 0
            local eatSpeedValue = eatSpeedGrowth(eatSpeedLevel)
            local colorHex = maxSizeValue >= 10000000 and "#FF0000" or (maxSizeValue >= 100000 and "#FFFF00" or "#00FF00")
            local currentRainbowColor = rainbowColors[colorIndex]
            -- 在速度上方添加彩虹色玩家昵称
            statsLabel.Text = string.format("<font color='%s'>%s</font>\n速度: %d\n乘数: %dx\n最大体积: <font color='%s'>%d</font>\n吃速: %.1f", currentRainbowColor, targetPlayer.DisplayName, math.floor(speed), multiplierValue, colorHex, maxSizeValue, eatSpeedValue)
        end
    end)
    playerStatsConnections[targetPlayer.UserId] = connection
end

local function createAllPlayersStats()
    for _, targetPlayer in pairs(Players:GetPlayers()) do
        if targetPlayer.Character then createHeadStatsForPlayer(targetPlayer) end
    end
end

local function removeAllPlayersStats()
    for userId, gui in pairs(playerStatsGuis) do gui:Destroy() playerStatsGuis[userId] = nil end
    for userId, connection in pairs(playerStatsConnections) do connection:Disconnect() playerStatsConnections[userId] = nil end
end

function toggleHeadStats(enabled)
    showHeadStats = enabled
    savedConfig.showHeadStats = enabled
    saveConfig()
    if enabled then createAllPlayersStats() else removeAllPlayersStats() end
end

if showHeadStats then
    createAllPlayersStats()
end

Players.PlayerAdded:Connect(function(newPlayer)
    newPlayer.CharacterAdded:Connect(function()
        task.wait(0.5)
        if showHeadStats then createHeadStatsForPlayer(newPlayer) end
    end)
end)

for _, existingPlayer in pairs(Players:GetPlayers()) do
    existingPlayer.CharacterAdded:Connect(function()
        task.wait(0.5)
        if showHeadStats then createHeadStatsForPlayer(existingPlayer) end
    end)
end

-- ========== 修改后的自定义名称功能 ==========
createSmallButton("自定义名称", Color3.fromRGB(255, 165, 0), "📝", UDim2.new(0, 170, 0, 50), function()
    if not screenGui:FindFirstChild("NameWindow") then
        local nameWindow = Instance.new("Frame")
        nameWindow.Name = "NameWindow"
        -- 修改点4: 增加窗口总高度 (440) 以容纳所有颜色按钮
        nameWindow.Size = UDim2.new(0, 320, 0, 440)
        nameWindow.Position = UDim2.new(0, 370, 0, 20)
        nameWindow.BackgroundColor3 = mainFrame.BackgroundColor3 -- 同步主窗口颜色
        nameWindow.BorderSizePixel = 0
        nameWindow.Visible = true
        nameWindow.Active = true
        nameWindow.Draggable = true
        nameWindow.Parent = screenGui
        nameWindow.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then bringToFront(nameWindow) end
        end)
        local nameWindowCorner = Instance.new("UICorner")
        nameWindowCorner.CornerRadius = UDim.new(0, 10)
        nameWindowCorner.Parent = nameWindow
        local nameWindowBorder = Instance.new("UIStroke")
        nameWindowBorder.Color = lightBorder.Color -- 使用主窗口边框颜色
        nameWindowBorder.Thickness = 2
        nameWindowBorder.Parent = nameWindow
        createResizeHandle(nameWindow)
        local nameTitle = Instance.new("TextLabel")
        nameTitle.Size = UDim2.new(1, -25, 0, 30)
        nameTitle.Position = UDim2.new(0, 5, 0, 5)
        nameTitle.BackgroundTransparency = 1
        nameTitle.Text = "📝 自定义名称"
        nameTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameTitle.TextSize = 14
        nameTitle.Font = Enum.Font.GothamBold
        nameTitle.Parent = nameWindow
        local nameCloseBtn = Instance.new("TextButton")
        nameCloseBtn.Size = UDim2.new(0, 20, 0, 20)
        nameCloseBtn.Position = UDim2.new(1, -25, 0, 5)
        nameCloseBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
        nameCloseBtn.Text = "×"
        nameCloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameCloseBtn.TextSize = 12
        nameCloseBtn.BorderSizePixel = 0
        nameCloseBtn.Parent = nameWindow
        local nameCloseBtnCorner = Instance.new("UICorner")
        nameCloseBtnCorner.CornerRadius = UDim.new(0, 3)
        nameCloseBtnCorner.Parent = nameCloseBtn
        nameCloseBtn.MouseButton1Click:Connect(function() nameWindow:Destroy() end)
        
        local sizeLabel = Instance.new("TextLabel")
        sizeLabel.Size = UDim2.new(1, -20, 0, 25)
        sizeLabel.Position = UDim2.new(0, 10, 0, 45)
        sizeLabel.BackgroundTransparency = 1
        sizeLabel.Text = "文字大小: " .. (savedConfig.headTextSize or 12)
        sizeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        sizeLabel.TextSize = 14
        sizeLabel.Font = Enum.Font.GothamBold
        sizeLabel.TextXAlignment = Enum.TextXAlignment.Left
        sizeLabel.Parent = nameWindow
        
        local sizeSlider = Instance.new("Frame")
        sizeSlider.Size = UDim2.new(1, -20, 0, 30)
        sizeSlider.Position = UDim2.new(0, 10, 0, 75)
        sizeSlider.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
        sizeSlider.BorderSizePixel = 0
        sizeSlider.Parent = nameWindow
        local sizeSliderCorner = Instance.new("UICorner")
        sizeSliderCorner.CornerRadius = UDim.new(0, 5)
        sizeSliderCorner.Parent = sizeSlider
        
        for i, size in ipairs({8, 10, 12, 14, 16, 18}) do
            local sizeBtn = Instance.new("TextButton")
            sizeBtn.Size = UDim2.new(0, 45, 0, 25)
            sizeBtn.Position = UDim2.new(0, 5 + (i-1) * 48, 0, 2.5)
            sizeBtn.BackgroundColor3 = size == (savedConfig.headTextSize or 12) and Color3.fromRGB(40, 167, 69) or Color3.fromRGB(60, 60, 80)
            sizeBtn.Text = tostring(size)
            sizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            sizeBtn.TextSize = 12
            sizeBtn.Font = Enum.Font.Gotham
            sizeBtn.BorderSizePixel = 0
            sizeBtn.Parent = sizeSlider
            local sizeBtnCorner = Instance.new("UICorner")
            sizeBtnCorner.CornerRadius = UDim.new(0, 4)
            sizeBtnCorner.Parent = sizeBtn
            sizeBtn.MouseButton1Click:Connect(function()
                savedConfig.headTextSize = size
                saveConfig()
                updateHeadStats()
                sizeLabel.Text = "文字大小: " .. size
                for _, btn in pairs(sizeSlider:GetChildren()) do
                    if btn:IsA("TextButton") then btn.BackgroundColor3 = Color3.fromRGB(60, 60, 80) end
                end
                sizeBtn.BackgroundColor3 = Color3.fromRGB(40, 167, 69)
            end)
        end
        
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Size = UDim2.new(1, -20, 0, 40)
        toggleFrame.Position = UDim2.new(0, 10, 0, 115)
        toggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        toggleFrame.BorderSizePixel = 0
        toggleFrame.Parent = nameWindow
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(0, 6)
        toggleCorner.Parent = toggleFrame
        local toggleLabel = Instance.new("TextLabel")
        toggleLabel.Size = UDim2.new(1, -55, 1, 0)
        toggleLabel.Position = UDim2.new(0, 10, 0, 0)
        toggleLabel.BackgroundTransparency = 1
        toggleLabel.Text = "头顶显示"
        toggleLabel.TextColor3 = Color3.new(1, 1, 1)
        toggleLabel.TextSize = 14
        toggleLabel.Font = Enum.Font.Gotham
        toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        toggleLabel.Parent = toggleFrame
        local toggle = Instance.new("TextButton")
        toggle.Size = UDim2.new(0, 45, 0, 25)
        toggle.Position = UDim2.new(1, -50, 0.5, -12.5)
        toggle.BackgroundColor3 = showHeadStats and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
        toggle.BorderSizePixel = 0
        toggle.Text = ""
        toggle.Parent = toggleFrame
        local toggleCorner2 = Instance.new("UICorner")
        toggleCorner2.CornerRadius = UDim.new(1, 0)
        toggleCorner2.Parent = toggle
        local indicator = Instance.new("Frame")
        indicator.Size = UDim2.new(0, 19, 0, 19)
        indicator.Position = showHeadStats and UDim2.new(1, -22, 0.5, -9.5) or UDim2.new(0, 3, 0.5, -9.5)
        indicator.BackgroundColor3 = Color3.new(1, 1, 1)
        indicator.BorderSizePixel = 0
        indicator.Parent = toggle
        local indicatorCorner = Instance.new("UICorner")
        indicatorCorner.CornerRadius = UDim.new(1, 0)
        indicatorCorner.Parent = indicator
        toggle.MouseButton1Click:Connect(function()
            showHeadStats = not showHeadStats
            if showHeadStats then
                toggle.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
                indicator.Position = UDim2.new(1, -22, 0.5, -9.5)
            else
                toggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                indicator.Position = UDim2.new(0, 3, 0.5, -9.5)
            end
            toggleHeadStats(showHeadStats)
        end)
        
        local colorLabel = Instance.new("TextLabel")
        colorLabel.Size = UDim2.new(1, -20, 0, 25)
        colorLabel.Position = UDim2.new(0, 10, 0, 165)
        colorLabel.BackgroundTransparency = 1
        colorLabel.Text = "文字颜色"
        colorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        colorLabel.TextSize = 14
        colorLabel.Font = Enum.Font.GothamBold
        colorLabel.TextXAlignment = Enum.TextXAlignment.Left
        colorLabel.Parent = nameWindow
        
        local colorFrame = Instance.new("Frame")
        -- 修改点5: 增加颜色区域高度 (240) 以容纳所有按钮，防止超出
        colorFrame.Size = UDim2.new(1, -20, 0, 240)
        colorFrame.Position = UDim2.new(0, 10, 0, 195)
        colorFrame.BackgroundTransparency = 1
        colorFrame.Parent = nameWindow
        
        -- 扩充颜色列表到18种
        local headColors = {
            {255,255,255,"白色"}, {255,100,100,"红色"}, {100,255,100,"绿色"}, 
            {100,200,255,"蓝色"}, {255,255,100,"黄色"}, {255,150,255,"紫色"},
            {0,0,0,"黑色"},     {0,255,255,"青色"}, {255,165,0,"橙色"},
            {255,105,180,"粉色"}, {128,0,128,"深紫"}, {255,215,0,"金色"},
            {50,205,50,"酸橙"}, {220,20,60,"深红"}, {30,144,255,"天蓝"},
            {238,130,238,"紫罗兰"},{169,169,169,"灰色"}, {255,250,205,"柠檬绸"}
        }
        
        for i, c in ipairs(headColors) do
            local colorBtn = Instance.new("TextButton")
            colorBtn.Size = UDim2.new(0, 95, 0, 35)
            colorBtn.Position = UDim2.new(0, ((i-1) % 3) * 100, 0, math.floor((i-1) / 3) * 40)
            colorBtn.BackgroundColor3 = Color3.fromRGB(c[1], c[2], c[3])
            colorBtn.Text = c[4]
            -- 智能判断文字颜色：深色背景用白色文字，浅色背景用黑色文字
            local brightness = (c[1] * 299 + c[2] * 587 + c[3] * 114) / 1000
            colorBtn.TextColor3 = brightness < 128 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
            colorBtn.TextSize = 12
            colorBtn.Font = Enum.Font.Gotham
            colorBtn.BorderSizePixel = 0
            colorBtn.Parent = colorFrame
            local colorBtnCorner = Instance.new("UICorner")
            colorBtnCorner.CornerRadius = UDim.new(0, 5)
            colorBtnCorner.Parent = colorBtn
            colorBtn.MouseButton1Click:Connect(function()
                savedConfig.headTextColor = {c[1], c[2], c[3]}
                saveConfig()
                updateHeadStats()
            end)
        end
        
        Players.PlayerRemoving:Connect(function(removingPlayer)
            if playerStatsGuis[removingPlayer.UserId] then playerStatsGuis[removingPlayer.UserId]:Destroy() playerStatsGuis[removingPlayer.UserId] = nil end
            if playerStatsConnections[removingPlayer.UserId] then playerStatsConnections[removingPlayer.UserId]:Disconnect() playerStatsConnections[removingPlayer.UserId] = nil end
        end)
    else
        local existing = screenGui:FindFirstChild("NameWindow")
        existing.Visible = not existing.Visible
    end
end)

-- 功能实现
local isMinimized = false
local frameCount = 0
local lastTime = tick()

-- 光带颜色数组
local lightColors = {
    Color3.fromRGB(255, 100, 100),
    Color3.fromRGB(255, 200, 100),
    Color3.fromRGB(255, 255, 100),
    Color3.fromRGB(100, 255, 100),
    Color3.fromRGB(100, 200, 255),
    Color3.fromRGB(200, 100, 255),
}

local colorIndex = 1
local colorProgress = 0

-- 最小化功能
minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    local targetSize = isMinimized and UDim2.new(0, 150, 0, 40) or UDim2.new(0, 350, 0, 450)
    local tween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = targetSize})
    tween:Play()
    
    contentFrame.Visible = not isMinimized
    minimizeBtn.Text = isMinimized and "+" or "—"
end)

-- 关闭功能
closeBtn.MouseButton1Click:Connect(function()
    if flying then 
        toggleFly()
        leftControlFrame.Visible = false
    end
    -- 关闭时重置人物状态
    resetPlayerState()
    local tween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    })
    tween:Play()
    
    tween.Completed:Connect(function()
        screenGui:Destroy()
    end)
end)

speedCloseBtn.MouseButton1Click:Connect(function()
    speedWindow.Visible = false
end)

colorCloseBtn.MouseButton1Click:Connect(function()
    colorWindow.Visible = false
end)

-- 实时更新信息和光带流动效果
RunService.Heartbeat:Connect(function(deltaTime)
    frameCount = frameCount + 1
    local currentTime = tick()
    
    -- 更新FPS
    if currentTime - lastTime >= 1 then
        local fps = math.floor(frameCount / (currentTime - lastTime))
        fpsLabel.Text = "帧率: " .. fps .. " FPS"
        minimizedFPS.Text = fps .. " FPS"
        permanentFpsLabel.Text = fps .. " FPS"  -- 更新永久帧率显示
        -- 根据FPS值改变颜色
        if fps >= 50 then
            permanentFpsLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        elseif fps >= 30 then
            permanentFpsLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
        else
            permanentFpsLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
        frameCount = 0
        lastTime = currentTime
    end
    
    -- 更新移动速度
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        local speed = player.Character.Humanoid.WalkSpeed
        speedLabel.Text = "速度: " .. math.floor(speed)
    end
    
    -- 更新当前时间
    local realTime = os.date("*t")
    local timeString = string.format("%02d:%02d:%02d", realTime.hour, realTime.min, realTime.sec)
    currentTimeLabel.Text = "时间: " .. timeString
    
    -- 缩小时显示简化时间
    local shortTime = string.format("%02d:%02d", realTime.hour, realTime.min)
    minimizedTime.Text = shortTime
    
    -- 光带流动效果
    colorProgress = colorProgress + deltaTime * 2
    
    if colorProgress >= 1 then
        colorIndex = colorIndex + 1
        if colorIndex > #lightColors then
            colorIndex = 1
        end
        colorProgress = 0
    end
    
    local currentColor = lightColors[colorIndex]
    local nextIndex = colorIndex + 1
    if nextIndex > #lightColors then
        nextIndex = 1
    end
    local nextColor = lightColors[nextIndex]
    
    local r = currentColor.R + (nextColor.R - currentColor.R) * colorProgress
    local g = currentColor.G + (nextColor.G - currentColor.G) * colorProgress
    local b = currentColor.B + (nextColor.B - currentColor.B) * colorProgress
    
    lightBorder.Color = Color3.new(r, g, b)
    -- 更新FPS描边为彩色光带
    permanentFpsLabel.TextStrokeColor3 = Color3.new(r, g, b)
end)

-- 添加淡入动画
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)

local openTween = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
    Size = UDim2.new(0, 350, 0, 450),
    Position = UDim2.new(0.5, -175, 0.5, -225)
})
openTween:Play()

print("🎮 小拽脚本已加载完成! - 人物状态已重置")


-- ========== 吃吃世界功能 ==========
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage:WaitForChild("Events")
local LocalPlayer = Players.LocalPlayer

local autofarm = savedConfig.autofarm or false
local autoCollectingCubes = savedConfig.autoCollectingCubes or false
local autoClaimRewards = savedConfig.autoClaimRewards or false
local farmMoving = savedConfig.farmMoving or false
local showMap = savedConfig.showMap or false
local autoeat = savedConfig.autoeat or false
local autoUpgradeSize = savedConfig.autoUpgradeSize or false
local autoUpgradeSpd = savedConfig.autoUpgradeSpd or false
local autoUpgradeMulti = savedConfig.autoUpgradeMulti or false
local autoUpgradeEat = savedConfig.autoUpgradeEat or false
local keepUnanchor = savedConfig.keepUnanchor ~= nil and savedConfig.keepUnanchor or false
local boundProtect = savedConfig.boundProtect ~= nil and savedConfig.boundProtect or false

local function getRoot()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end

local function checkLoaded()
    return (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character:FindFirstChild("Size") and LocalPlayer.Character:FindFirstChild("Events") and LocalPlayer.Character.Events:FindFirstChild("Grab") and LocalPlayer.Character.Events:FindFirstChild("Eat") and LocalPlayer.Character.Events:FindFirstChild("Sell") and LocalPlayer.Character:FindFirstChild("CurrentChunk")) ~= nil
end

local function changeMap()
    local args = {{MapTime = -1, Paused = true}}
    Events.SetServerSettings:FireServer(unpack(args))
end

local function sizeGrowth(level) return math.floor(((level + 0.5) ^ 2 - 0.25) / 2 * 100) end
local function speedGrowth(level) return math.floor(level * 2 + 10) end
local function multiplierGrowth(level) return math.floor(level) end
local function eatSpeedGrowth(level) return math.floor((1 + (level - 1) * 0.2) * 10) / 10 end
local function sizePrice(level) return math.floor(level ^ 3 / 2) * 20 end
local function speedPrice(level) return math.floor((level * 3) ^ 3 / 200) * 1000 end
local function multiplierPrice(level) return math.floor((level * 10) ^ 3 / 200) * 1000 end
local function eatSpeedPrice(level) return math.floor((level * 10) ^ 3 / 200) * 2000 end

local function createEatWorldWindow(title, width, height)
    local popup = Instance.new("Frame")
    popup.Name = title .. "Window"
    popup.Size = UDim2.new(0, width, 0, height)
    popup.Position = UDim2.new(0.5, -width/2, 0.5, -height/2)
    popup.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    popup.BorderSizePixel = 0
    popup.Visible = false
    popup.Active = true
    popup.Draggable = true
    popup.Parent = screenGui
    popup.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then bringToFront(popup) end
    end)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = popup
    local border = Instance.new("UIStroke")
    border.Color = Color3.fromRGB(100, 150, 255)
    border.Thickness = 2
    border.Parent = popup
    createResizeHandle(popup)
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 35)
    titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = popup
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = titleBar
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -40, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -32, 0, 2.5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.TextSize = 18
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = titleBar
    local closeBtnCorner = Instance.new("UICorner")
    closeBtnCorner.CornerRadius = UDim.new(0, 6)
    closeBtnCorner.Parent = closeBtn
    closeBtn.MouseButton1Click:Connect(function() popup.Visible = false end)
    local content = Instance.new("ScrollingFrame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -20, 1, -50)
    content.Position = UDim2.new(0, 10, 0, 40)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 6
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.Parent = popup
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 8)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = content
    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        content.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
    end)
    return popup, content
end

local function createEatToggle(parent, text, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -55, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 45, 0, 25)
    toggle.Position = UDim2.new(1, -50, 0.5, -12.5)
    toggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    toggle.BorderSizePixel = 0
    toggle.Text = ""
    toggle.Parent = frame
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggle
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 19, 0, 19)
    indicator.Position = UDim2.new(0, 3, 0.5, -9.5)
    indicator.BackgroundColor3 = Color3.new(1, 1, 1)
    indicator.BorderSizePixel = 0
    indicator.Parent = toggle
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(1, 0)
    indicatorCorner.Parent = indicator
    local enabled = false
    toggle.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            toggle.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            indicator.Position = UDim2.new(1, -22, 0.5, -9.5)
        else
            toggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            indicator.Position = UDim2.new(0, 3, 0.5, -9.5)
        end
        callback(enabled)
    end)
    return frame
end

local function createEatButton(parent, text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 40)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextSize = 14
    button.Font = Enum.Font.Gotham
    button.Parent = parent
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button
    button.MouseButton1Click:Connect(callback)
    button.MouseEnter:Connect(function() button.BackgroundColor3 = Color3.fromRGB(80, 80, 100) end)
    button.MouseLeave:Connect(function() button.BackgroundColor3 = Color3.fromRGB(60, 60, 80) end)
    return button
end

local autoWindow, autoContent = createEatWorldWindow("自动", 300, 400)

createEatToggle(autoContent, "自动刷", function(enabled)
    autofarm = enabled
    savedConfig.autofarm = enabled
    saveConfig()
    coroutine.wrap(function()
    	local text = Drawing.new("Text")
    	text.Outline = true
    	text.OutlineColor = Color3.new(0, 0, 0)
    	text.Color = Color3.new(1, 1, 1)
    	text.Center = false
    	text.Position = Vector2.new(64, 64)
    	text.Text = ""
    	text.Size = 14
    	text.Visible = true
    	local startTime = tick()
    	local eatTime = 0
    	local lastEatTime = tick()
        local timer = 0
        local grabTimer = 0
        local sellDebounce = false
        local sellCount = 0
        local bedrock = Instance.new("Part")
        bedrock.Anchored = true
        bedrock.Size = Vector3.new(2048, 10, 2048)
        bedrock.Position = Vector3.new(0, -5, 0)
        bedrock.BrickColor = BrickColor.Black()
        bedrock.Parent = workspace
        local map, chunks = workspace:FindFirstChild("Map"), workspace:FindFirstChild("Chunks")
        if map and chunks then map.Parent, chunks.Parent = nil, nil end
        local numChunks = 0
        local hum, root, size, events, eat, grab, sell, sendTrack, chunk, radius, autoConn, sizeConn
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
            autoConn = game["Run Service"].Heartbeat:Connect(function(dt)
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
                local sellMinutes = math.floor(sellTime / 60)
                local sellSeconds = math.floor(sellTime)
                local secondEarn = math.floor(sizeGrowth(LocalPlayer.Upgrades.MaxSize.Value) / sellTime)
                local minuteEarn = secondEarn * 60
                local hourEarn = minuteEarn * 60
                local dayEarn = hourEarn * 24
                text.Text = "\n运行时间: " .. string.format("%ih%im%is", hours, minutes % 60, seconds % 60) .. "\n实际时间: " .. string.format("%im%is", eatMinutes % 60, eatSeconds % 60) .. "\n大约时间: " .. string.format("%im%is", sellMinutes % 60, sellSeconds % 60) .. "\n每天: " .. dayEarn .. "\n块数: " .. numChunks
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
                    if timer < 8 then
                        sell:FireServer()
                        if not sellDebounce then changeMap() end
                        sellDebounce = true
                    else
                        changeMap()
                    end
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
            hum.Died:Connect(function() autoConn:Disconnect() changeMap() end)
            char:WaitForChild("LocalChunkManager").Enabled = false
            char:WaitForChild("Animate").Enabled = false
        end
        if LocalPlayer.Character then task.spawn(onCharAdd, LocalPlayer.Character) else task.spawn(onCharAdd, LocalPlayer.CharacterAdded:Wait()) end
        local charAddConn = LocalPlayer.CharacterAdded:Connect(onCharAdd)
        while autofarm do
            local dt = task.wait()
            if workspace:FindFirstChild("Loading") then workspace.Loading:Destroy() end
            if map and chunks then
                if showMap then map.Parent, chunks.Parent = workspace, workspace else map.Parent, chunks.Parent = nil, nil end
            end
        end
        charAddConn:Disconnect()
        if autoConn then autoConn:Disconnect() end
        if map and chunks then map.Parent, chunks.Parent = workspace, workspace end
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        bedrock:Destroy()
        LocalPlayer.Character.LocalChunkManager.Enabled = true
        LocalPlayer.Character.Animate.Enabled = true
        text:Destroy()
    end)()
end)

createEatToggle(autoContent, "自动收", function(enabled)
    autoCollectingCubes = enabled
    savedConfig.autoCollectingCubes = enabled
    saveConfig()
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

createEatToggle(autoContent, "自动领", function(enabled)
    autoClaimRewards = enabled
    savedConfig.autoClaimRewards = enabled
    saveConfig()
    coroutine.wrap(function()
        while autoClaimRewards do
            task.wait(1)
            for _, reward in LocalPlayer.TimedRewards:GetChildren() do
                if reward.Value > 0 then Events.RewardEvent:FireServer(reward) end
            end
            Events.SpinEvent:FireServer()
        end
    end)()
end)

createEatToggle(autoContent, "移动模式", function(enabled) farmMoving = enabled savedConfig.farmMoving = enabled saveConfig() end)
createEatToggle(autoContent, "显示地图", function(enabled) showMap = enabled savedConfig.showMap = enabled saveConfig() end)

createEatToggle(autoContent, "自动吃", function(enabled)
    autoeat = enabled
    savedConfig.autoeat = enabled
    saveConfig()
    coroutine.wrap(function()
        while autoeat do
            local dt = task.wait()
            if checkLoaded() then
                LocalPlayer.Character.HumanoidRootPart.Anchored = false
                LocalPlayer.Character.Events.Grab:FireServer()
                LocalPlayer.Character.Events.Eat:FireServer()
            end
        end
    end)()
end)

local upgradeWindow, upgradeContent = createEatWorldWindow("升级", 300, 300)

createEatToggle(upgradeContent, "大小", function(enabled)
    autoUpgradeSize = enabled
    savedConfig.autoUpgradeSize = enabled
    saveConfig()
    coroutine.wrap(function()
        game.CoreGui.PurchasePromptApp.Enabled = false
        while autoUpgradeSize do task.wait(1) Events.PurchaseEvent:FireServer("MaxSize") end
        game.CoreGui.PurchasePromptApp.Enabled = true
    end)()
end)

createEatToggle(upgradeContent, "移速", function(enabled)
    autoUpgradeSpd = enabled
    savedConfig.autoUpgradeSpd = enabled
    saveConfig()
    coroutine.wrap(function()
        game.CoreGui.PurchasePromptApp.Enabled = false
        while autoUpgradeSpd do task.wait(1) Events.PurchaseEvent:FireServer("Speed") end
        game.CoreGui.PurchasePromptApp.Enabled = true
    end)()
end)

createEatToggle(upgradeContent, "乘数", function(enabled)
    autoUpgradeMulti = enabled
    savedConfig.autoUpgradeMulti = enabled
    saveConfig()
    coroutine.wrap(function()
        game.CoreGui.PurchasePromptApp.Enabled = false
        while autoUpgradeMulti do task.wait(1) Events.PurchaseEvent:FireServer("Multiplier") end
        game.CoreGui.PurchasePromptApp.Enabled = true
    end)()
end)

createEatToggle(upgradeContent, "吃速", function(enabled)
    autoUpgradeEat = enabled
    savedConfig.autoUpgradeEat = enabled
    saveConfig()
    coroutine.wrap(function()
        game.CoreGui.PurchasePromptApp.Enabled = false
        while autoUpgradeEat do task.wait(1) Events.PurchaseEvent:FireServer("EatSpeed") end
        game.CoreGui.PurchasePromptApp.Enabled = true
    end)()
end)

local figureWindow, figureContent = createEatWorldWindow("人物", 300, 250)

createEatToggle(figureContent, "取消锚固", function(enabled)
    keepUnanchor = enabled
    savedConfig.keepUnanchor = enabled
    saveConfig()
    coroutine.wrap(function()
        while keepUnanchor do
            task.wait()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.Anchored = false
            end
        end
    end)()
end)

createEatToggle(figureContent, "边界保护", function(enabled)
    boundProtect = enabled
    savedConfig.boundProtect = enabled
    saveConfig()
    coroutine.wrap(function()
        while boundProtect do
            task.wait()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local root = LocalPlayer.Character.HumanoidRootPart
                local pos = root.Position
                local mapSize = workspace.Map.Bedrock.Size * Vector3.new(1, 0, 1)
                local clampedPos = Vector3.new(math.clamp(pos.X, -mapSize.X / 2, mapSize.X / 2), pos.Y, math.clamp(pos.Z, -mapSize.Z / 2, mapSize.Z / 2))
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(clampedPos) * root.CFrame.Rotation
            end
        end
    end)()
end)

local otherWindow, otherContent = createEatWorldWindow("其它", 300, 250)

createEatButton(otherContent, "查看玩家数据", function()
    local localization = {MaxSize = "体积", Speed = "移速", Multiplier = "乘数", EatSpeed = "吃速"}
    local growthFunctions = {MaxSize = sizeGrowth, Speed = speedGrowth, Multiplier = multiplierGrowth, EatSpeed = eatSpeedGrowth}
    local priceFunctions = {MaxSize = sizePrice, Speed = speedPrice, Multiplier = multiplierPrice, EatSpeed = eatSpeedPrice}
    for _, player in Players:GetPlayers() do
        print()
        for _, upg in player.Upgrades:GetChildren() do
            local content = player.Name .. "："
            local cost = 0
            for l = 2, upg.Value do cost += priceFunctions[upg.Name](l) end
            content = content .. " " .. localization[upg.Name] .. "：" .. upg.Value .. "级；" .. growthFunctions[upg.Name](upg.Value) .. "值；" .. cost .. "花费；"
            print(content)
        end
    end
    game.StarterGui:SetCore("DevConsoleVisible", true)
end)

createEatToggle(otherContent, "竖屏", function(enabled)
    LocalPlayer.PlayerGui.ScreenOrientation = enabled and Enum.ScreenOrientation.Portrait or Enum.ScreenOrientation.LandscapeRight
end)

buttonFrame.Size = UDim2.new(1, 0, 0, 210)

local eatWorldY = 95
createSmallButton("自动", Color3.fromRGB(255, 165, 0), "🤖", UDim2.new(0, 5, 0, eatWorldY), function()
    autoWindow.Visible = not autoWindow.Visible
    speedWindow.Visible = false
    colorWindow.Visible = false
    upgradeWindow.Visible = false
    figureWindow.Visible = false
    otherWindow.Visible = false
end)

createSmallButton("升级", Color3.fromRGB(34, 139, 34), "⬆️", UDim2.new(0, 170, 0, eatWorldY), function()
    upgradeWindow.Visible = not upgradeWindow.Visible
    speedWindow.Visible = false
    colorWindow.Visible = false
    autoWindow.Visible = false
    figureWindow.Visible = false
    otherWindow.Visible = false
end)

createSmallButton("人物", Color3.fromRGB(138, 43, 226), "👤", UDim2.new(0, 5, 0, eatWorldY + 45), function()
    figureWindow.Visible = not figureWindow.Visible
    speedWindow.Visible = false
    colorWindow.Visible = false
    autoWindow.Visible = false
    upgradeWindow.Visible = false
    otherWindow.Visible = false
end)

createSmallButton("其它", Color3.fromRGB(70, 130, 180), "📋", UDim2.new(0, 170, 0, eatWorldY + 45), function()
    otherWindow.Visible = not otherWindow.Visible
    speedWindow.Visible = false
    colorWindow.Visible = false
    autoWindow.Visible = false
    upgradeWindow.Visible = false
    figureWindow.Visible = false
end)

print("🎮 小拽脚本 + 吃吃世界功能已加载完成!")


-- 重置所有功能函数
local function resetAllFeatures()
    if flying then
        flying = false
        if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
        if bodyAngularVelocity then bodyAngularVelocity:Destroy() bodyAngularVelocity = nil end
        toggleFlyBtn.Text = "开启飞天"
        toggleFlyBtn.BackgroundColor3 = Color3.fromRGB(255, 193, 7)
        toggleFlyBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        leftControlFrame.Visible = false
    end
    autofarm = false
    autoCollectingCubes = false
    autoClaimRewards = false
    farmMoving = false
    showMap = false
    autoeat = false
    autoUpgradeSize = false
    autoUpgradeSpd = false
    autoUpgradeMulti = false
    autoUpgradeEat = false
    keepUnanchor = false
    boundProtect = false
    resetPlayerState()
    local map, chunks = workspace:FindFirstChild("Map"), workspace:FindFirstChild("Chunks")
    if map and chunks and (map.Parent == nil or chunks.Parent == nil) then
        map.Parent, chunks.Parent = workspace, workspace
    end
    if player.Character then
        local localChunkManager = player.Character:FindFirstChild("LocalChunkManager")
        local animate = player.Character:FindFirstChild("Animate")
        if localChunkManager then localChunkManager.Enabled = true end
        if animate then animate.Enabled = true end
    end
    print("✅ 所有功能已重置")
end

buttonFrame.Size = UDim2.new(1, 0, 0, 255)

-- 将重置功能按钮横向排到FPS位置按钮前方并保持同一行
createSmallButton("重置功能", Color3.fromRGB(220, 53, 69), "🔄", UDim2.new(0, 5, 0, eatWorldY + 90), function()
    resetAllFeatures()
end)

-- 白名单管理功能按钮
createSmallButton("白名单", Color3.fromRGB(100, 150, 255), "👥", UDim2.new(0, 170, 0, eatWorldY + 90), function()
    -- 创建白名单管理窗口
    local whitelistGui = Instance.new("ScreenGui")
    whitelistGui.Name = "WhitelistManager"
    whitelistGui.ResetOnSpawn = false
    whitelistGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    whitelistGui.Parent = playerGui
    
    -- 主窗口框架
    local whitelistFrame = Instance.new("Frame")
    whitelistFrame.Name = "WhitelistFrame"
    whitelistFrame.Size = UDim2.new(0, 450, 0, 400)
    whitelistFrame.Position = UDim2.new(0.5, -225, 0.5, -200)
    whitelistFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
    whitelistFrame.BorderSizePixel = 0
    whitelistFrame.Active = true
    whitelistFrame.Draggable = true
    whitelistFrame.Parent = whitelistGui
    
    -- 圆角效果
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = whitelistFrame
    
    -- 边框效果
    local border = Instance.new("UIStroke")
    border.Color = Color3.fromRGB(100, 150, 255)
    border.Thickness = 3
    border.Parent = whitelistFrame
    
    -- 标题栏
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = whitelistFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = titleBar
    
    -- 标题文本
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "👥 白名单管理"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 18
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar
    
    -- 关闭按钮
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextScaled = true
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = titleBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeBtn
    
    -- 内容区域
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, -20, 1, -60)
    contentFrame.Position = UDim2.new(0, 10, 0, 50)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = whitelistFrame
    
    -- 当前白名单列表标题
    local listTitle = Instance.new("TextLabel")
    listTitle.Size = UDim2.new(1, 0, 0, 25)
    listTitle.Position = UDim2.new(0, 0, 0, 10)
    listTitle.BackgroundTransparency = 1
    listTitle.Text = "当前白名单用户："
    listTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    listTitle.TextSize = 16
    listTitle.Font = Enum.Font.GothamBold
    listTitle.TextXAlignment = Enum.TextXAlignment.Left
    listTitle.Parent = contentFrame
    
    -- 白名单列表显示
    local whitelistList = Instance.new("TextLabel")
    whitelistList.Size = UDim2.new(1, 0, 0, 80)
    whitelistList.Position = UDim2.new(0, 0, 0, 35)
    whitelistList.BackgroundTransparency = 1
    whitelistList.Text = table.concat(whitelist, ", ")
    whitelistList.TextColor3 = Color3.fromRGB(200, 255, 200)
    whitelistList.TextSize = 14
    whitelistList.Font = Enum.Font.Gotham
    whitelistList.TextXAlignment = Enum.TextXAlignment.Left
    whitelistList.TextWrapped = true
    whitelistList.Parent = contentFrame
    
    -- 添加新用户区域
    local addTitle = Instance.new("TextLabel")
    addTitle.Size = UDim2.new(1, 0, 0, 25)
    addTitle.Position = UDim2.new(0, 0, 0, 125)
    addTitle.BackgroundTransparency = 1
    addTitle.Text = "添加新用户："
    addTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    addTitle.TextSize = 16
    addTitle.Font = Enum.Font.GothamBold
    addTitle.TextXAlignment = Enum.TextXAlignment.Left
    addTitle.Parent = contentFrame
    
    -- 用户名输入框
    local usernameInput = Instance.new("TextBox")
    usernameInput.Size = UDim2.new(0.7, 0, 0, 35)
    usernameInput.Position = UDim2.new(0, 0, 0, 155)
    usernameInput.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    usernameInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    usernameInput.PlaceholderText = "输入用户名..."
    usernameInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    usernameInput.TextSize = 14
    usernameInput.Font = Enum.Font.Gotham
    usernameInput.TextXAlignment = Enum.TextXAlignment.Left
    usernameInput.Parent = contentFrame
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 6)
    inputCorner.Parent = usernameInput
    
    -- 添加按钮
    local addBtn = Instance.new("TextButton")
    addBtn.Size = UDim2.new(0.25, 0, 0, 35)
    addBtn.Position = UDim2.new(0.75, 10, 0, 155)
    addBtn.BackgroundColor3 = Color3.fromRGB(40, 167, 69)
    addBtn.Text = "添加"
    addBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    addBtn.TextSize = 14
    addBtn.Font = Enum.Font.GothamBold
    addBtn.BorderSizePixel = 0
    addBtn.Parent = contentFrame
    
    local addCorner = Instance.new("UICorner")
    addCorner.CornerRadius = UDim.new(0, 6)
    addCorner.Parent = addBtn
    
    -- 状态信息
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, 0, 0, 25)
    statusLabel.Position = UDim2.new(0, 0, 0, 200)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = ""
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
    statusLabel.TextSize = 14
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.Parent = contentFrame
    
    -- 清空白名单按钮
    local clearBtn = Instance.new("TextButton")
    clearBtn.Size = UDim2.new(0.8, 0, 0, 35)
    clearBtn.Position = UDim2.new(0.1, 0, 0, 235)
    clearBtn.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
    clearBtn.Text = "清空白名单"
    clearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    clearBtn.TextSize = 14
    clearBtn.Font = Enum.Font.GothamBold
    clearBtn.BorderSizePixel = 0
    clearBtn.Parent = contentFrame
    
    local clearCorner = Instance.new("UICorner")
    clearCorner.CornerRadius = UDim.new(0, 6)
    clearCorner.Parent = clearBtn
    
    -- 重置为默认按钮
    local resetBtn = Instance.new("TextButton")
    resetBtn.Size = UDim2.new(0.8, 0, 0, 35)
    resetBtn.Position = UDim2.new(0.1, 0, 0, 280)
    resetBtn.BackgroundColor3 = Color3.fromRGB(255, 193, 7)
    resetBtn.Text = "重置为默认"
    resetBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    resetBtn.TextSize = 14
    resetBtn.Font = Enum.Font.GothamBold
    resetBtn.BorderSizePixel = 0
    resetBtn.Parent = contentFrame
    
    local resetCorner = Instance.new("UICorner")
    resetCorner.CornerRadius = UDim.new(0, 6)
    resetCorner.Parent = resetBtn
    
    -- 更新白名单列表显示
    local function updateWhitelistDisplay()
        whitelistList.Text = table.concat(whitelist, ", ")
    end
    
    -- 添加用户函数
    local function addUser(username)
        if username == "" then
            statusLabel.Text = "❌ 用户名不能为空"
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            return
        end
        
        -- 检查是否已存在
        for _, existingUser in ipairs(whitelist) do
            if existingUser == username then
                statusLabel.Text = "❌ 用户已存在"
                statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
                return
            end
        end
        
        -- 添加到白名单
        table.insert(whitelist, username)
        updateWhitelistDisplay()
        statusLabel.Text = "✅ 用户添加成功：" .. username
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        usernameInput.Text = ""
    end
    
    -- 清空白名单函数
    local function clearWhitelist()
        whitelist = {}
        updateWhitelistDisplay()
        statusLabel.Text = "✅ 白名单已清空"
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    end
    
    -- 重置为默认函数
    local function resetToDefault()
        whitelist = {"xiaozhuai666", "xioazhuai778", "xiaozhuai778"}
        updateWhitelistDisplay()
        statusLabel.Text = "✅ 已重置为默认白名单"
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    end
    
    -- 按钮事件
    closeBtn.MouseButton1Click:Connect(function()
        whitelistGui:Destroy()
    end)
    
    addBtn.MouseButton1Click:Connect(function()
        addUser(usernameInput.Text)
    end)
    
    usernameInput.FocusLost:Connect(function()
        if usernameInput.Text ~= "" then
            addUser(usernameInput.Text)
        end
    end)
    
    clearBtn.MouseButton1Click:Connect(function()
        clearWhitelist()
    end)
    
    resetBtn.MouseButton1Click:Connect(function()
        resetToDefault()
    end)
    
    -- 初始化显示
    updateWhitelistDisplay()
end)

-- FPS位置调节功能
local function updateFPSPosition()
    permanentFpsFrame.Position = UDim2.new(savedConfig.fpsPositionX, -110, savedConfig.fpsPositionY, 5)
end

-- 创建FPS位置调节窗口（可拖动）
local fpsPosWindow = Instance.new("Frame")
fpsPosWindow.Name = "FPSPositionWindow"
fpsPosWindow.Size = UDim2.new(0, 320, 0, 320) -- 增加窗口高度到320像素，确保完整包裹重置按钮
fpsPosWindow.Position = UDim2.new(0.5, -160, 0.5, -160)
fpsPosWindow.BackgroundColor3 = Color3.fromRGB(savedConfig.mainFrameColor[1], savedConfig.mainFrameColor[2], savedConfig.mainFrameColor[3])
fpsPosWindow.BorderSizePixel = 0
fpsPosWindow.Visible = false
fpsPosWindow.Active = true
fpsPosWindow.Draggable = true
fpsPosWindow.Parent = screenGui

-- 添加圆角和边框
local fpsPosCorner = Instance.new("UICorner")
fpsPosCorner.CornerRadius = UDim.new(0, 12)
fpsPosCorner.Parent = fpsPosWindow

local fpsPosBorder = Instance.new("UIStroke")
fpsPosBorder.Color = Color3.fromRGB(savedConfig.borderColor[1], savedConfig.borderColor[2], savedConfig.borderColor[3])
fpsPosBorder.Thickness = 3
fpsPosBorder.Parent = fpsPosWindow

-- FPS位置窗口点击置顶
fpsPosWindow.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        bringToFront(fpsPosWindow)
    end
end)

-- FPS位置窗口标题栏
local fpsPosTitleBar = Instance.new("Frame")
fpsPosTitleBar.Name = "fpsPosTitleBar"
fpsPosTitleBar.Size = UDim2.new(1, 0, 0, 40)
fpsPosTitleBar.BackgroundColor3 = Color3.fromRGB(savedConfig.titleBarColor[1], savedConfig.titleBarColor[2], savedConfig.titleBarColor[3])
fpsPosTitleBar.BorderSizePixel = 0
fpsPosTitleBar.Parent = fpsPosWindow

local fpsPosTitleCorner = Instance.new("UICorner")
fpsPosTitleCorner.CornerRadius = UDim.new(0, 12)
fpsPosTitleCorner.Parent = fpsPosTitleBar

local fpsPosTitle = Instance.new("TextLabel")
fpsPosTitle.Size = UDim2.new(1, -80, 1, 0)
fpsPosTitle.Position = UDim2.new(0, 10, 0, 0)
fpsPosTitle.BackgroundTransparency = 1
fpsPosTitle.Text = "🎮 FPS位置调节"
fpsPosTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
fpsPosTitle.TextScaled = true
fpsPosTitle.Font = Enum.Font.GothamBold
fpsPosTitle.Parent = fpsPosTitleBar

-- 关闭按钮
local fpsPosCloseBtn = Instance.new("TextButton")
fpsPosCloseBtn.Size = UDim2.new(0, 30, 0, 30)
fpsPosCloseBtn.Position = UDim2.new(1, -35, 0, 5)
fpsPosCloseBtn.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
fpsPosCloseBtn.Text = "✕"
fpsPosCloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
fpsPosCloseBtn.TextScaled = true
fpsPosCloseBtn.Font = Enum.Font.GothamBold
fpsPosCloseBtn.BorderSizePixel = 0
fpsPosCloseBtn.Parent = fpsPosTitleBar

local fpsPosCloseCorner = Instance.new("UICorner")
fpsPosCloseCorner.CornerRadius = UDim.new(0, 6)
fpsPosCloseCorner.Parent = fpsPosCloseBtn

fpsPosCloseBtn.MouseButton1Click:Connect(function()
    fpsPosWindow.Visible = false
end)

-- 添加FPS位置小按钮（在重置功能按钮右侧）
createSmallButton("FPS位置", Color3.fromRGB(100, 255, 100), "🎮", UDim2.new(0, 170, 0, eatWorldY + 90), function()
    fpsPosWindow.Visible = not fpsPosWindow.Visible
    -- 确保窗口显示在最前面
    bringToFront(fpsPosWindow)
    -- 关闭其他可能打开的窗口
    autoWindow.Visible = false
    speedWindow.Visible = false
    colorWindow.Visible = false
    upgradeWindow.Visible = false
    figureWindow.Visible = false
    otherWindow.Visible = false
end)

-- 创建内容框架
local fpsPosContent = Instance.new("Frame")
fpsPosContent.Name = "FPSPositionContent"
fpsPosContent.Size = UDim2.new(1, -20, 1, -70)
fpsPosContent.Position = UDim2.new(0, 10, 0, 50)
fpsPosContent.BackgroundTransparency = 1
fpsPosContent.Visible = true
fpsPosContent.Parent = fpsPosWindow

-- 当前位置显示
local positionLabel = Instance.new("TextLabel")
positionLabel.Name = "PositionLabel"
positionLabel.Size = UDim2.new(1, 0, 0, 40)
positionLabel.Position = UDim2.new(0, 0, 0, 10)
positionLabel.BackgroundTransparency = 1
positionLabel.Text = "🎮 FPS位置: X=" .. string.format("%.2f", savedConfig.fpsPositionX) .. " Y=" .. string.format("%.2f", savedConfig.fpsPositionY)
positionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
positionLabel.TextSize = 18
positionLabel.Font = Enum.Font.GothamBold
positionLabel.TextXAlignment = Enum.TextXAlignment.Center
positionLabel.Visible = true
positionLabel.Parent = fpsPosContent

-- 控制按钮容器
local controlButtonsFrame = Instance.new("Frame")
controlButtonsFrame.Name = "ControlButtonsFrame"
controlButtonsFrame.Size = UDim2.new(0.8, 0, 0, 150)
controlButtonsFrame.Position = UDim2.new(0.1, 0, 0, 60)
controlButtonsFrame.BackgroundTransparency = 1
controlButtonsFrame.Visible = true
controlButtonsFrame.Parent = fpsPosContent

-- 按钮尺寸
local buttonSize = UDim2.new(0, 60, 0, 60)

-- 上按钮
local upButton = Instance.new("TextButton")
upButton.Name = "UpButton"
upButton.Size = buttonSize
upButton.Position = UDim2.new(0.5, -30, 0, 0)
upButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
upButton.BorderSizePixel = 0
upButton.Text = "⬆"
upButton.TextColor3 = Color3.fromRGB(255, 255, 255)
upButton.TextSize = 30
upButton.Font = Enum.Font.GothamBold
upButton.AutoButtonColor = true
upButton.Visible = true
local upCorner = Instance.new("UICorner")
upCorner.CornerRadius = UDim.new(0, 10)
upCorner.Parent = upButton
upButton.Parent = controlButtonsFrame

-- 左按钮
local leftButton = Instance.new("TextButton")
leftButton.Name = "LeftButton"
leftButton.Size = buttonSize
leftButton.Position = UDim2.new(0, 30, 0, 70)
leftButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
leftButton.BorderSizePixel = 0
leftButton.Text = "⬅"
leftButton.TextColor3 = Color3.fromRGB(255, 255, 255)
leftButton.TextSize = 30
leftButton.Font = Enum.Font.GothamBold
leftButton.AutoButtonColor = true
leftButton.Visible = true
local leftCorner = Instance.new("UICorner")
leftCorner.CornerRadius = UDim.new(0, 10)
leftCorner.Parent = leftButton
leftButton.Parent = controlButtonsFrame

-- 下按钮
local downButton = Instance.new("TextButton")
downButton.Name = "DownButton"
downButton.Size = buttonSize
downButton.Position = UDim2.new(0.5, -30, 0, 70)
downButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
downButton.BorderSizePixel = 0
downButton.Text = "⬇"
downButton.TextColor3 = Color3.fromRGB(255, 255, 255)
downButton.TextSize = 30
downButton.Font = Enum.Font.GothamBold
downButton.AutoButtonColor = true
downButton.Visible = true
local downCorner = Instance.new("UICorner")
downCorner.CornerRadius = UDim.new(0, 10)
downCorner.Parent = downButton
downButton.Parent = controlButtonsFrame

-- 右按钮
local rightButton = Instance.new("TextButton")
rightButton.Name = "RightButton"
rightButton.Size = buttonSize
rightButton.Position = UDim2.new(1, -90, 0, 70)
rightButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
rightButton.BorderSizePixel = 0
rightButton.Text = "➡"
rightButton.TextColor3 = Color3.fromRGB(255, 255, 255)
rightButton.TextSize = 30
rightButton.Font = Enum.Font.GothamBold
rightButton.AutoButtonColor = true
rightButton.Visible = true
local rightCorner = Instance.new("UICorner")
rightCorner.CornerRadius = UDim.new(0, 10)
rightCorner.Parent = rightButton
rightButton.Parent = controlButtonsFrame

-- 重置位置按钮
local resetPosBtn = Instance.new("TextButton")
resetPosBtn.Name = "ResetPositionButton"
resetPosBtn.Size = UDim2.new(0.7, 0, 0, 45)
resetPosBtn.Position = UDim2.new(0.15, 0, 0, 220)
resetPosBtn.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
resetPosBtn.BorderSizePixel = 0
resetPosBtn.Text = "🔄 重置FPS位置"
resetPosBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
resetPosBtn.TextSize = 18
resetPosBtn.Font = Enum.Font.GothamBold
resetPosBtn.AutoButtonColor = true
resetPosBtn.Visible = true
local resetBtnCorner = Instance.new("UICorner")
resetBtnCorner.CornerRadius = UDim.new(0, 10)
resetBtnCorner.Parent = resetPosBtn
resetPosBtn.Parent = fpsPosContent

-- 更新位置显示
local function updatePositionLabel()
    positionLabel.Text = "🎮 FPS位置: X=" .. string.format("%.2f", savedConfig.fpsPositionX) .. " Y=" .. string.format("%.2f", savedConfig.fpsPositionY)
end

-- 按钮点击逻辑
local function adjustPosition(xDelta, yDelta)
    savedConfig.fpsPositionX = math.clamp(savedConfig.fpsPositionX + xDelta, 0, 1)
    savedConfig.fpsPositionY = math.clamp(savedConfig.fpsPositionY + yDelta, 0, 1)
    updatePositionLabel()
    updateFPSPosition()
    saveConfig()
end

-- 设置按钮事件
upButton.MouseButton1Click:Connect(function()
    adjustPosition(0, -0.05)  -- 往上移动（Y值减小）
end)

downButton.MouseButton1Click:Connect(function()
    adjustPosition(0, 0.05)  -- 往下移动（Y值增大）
end)

leftButton.MouseButton1Click:Connect(function()
    adjustPosition(-0.05, 0)  -- 往左移动（X值减小）
end)

rightButton.MouseButton1Click:Connect(function()
    adjustPosition(0.05, 0)  -- 往右移动（X值增大）
end)

-- 重置位置按钮事件
resetPosBtn.MouseButton1Click:Connect(function()
    -- 重置到默认位置
    savedConfig.fpsPositionX = 1
    savedConfig.fpsPositionY = 0
    
    -- 更新显示
    updatePositionLabel()
    updateFPSPosition()
    saveConfig()
end)



-- 应用初始FPS位置
updateFPSPosition()