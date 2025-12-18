local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage:WaitForChild("Events")
local LocalPlayer = Players.LocalPlayer

-- 全局变量初始化
local autofarm, autoCollectingCubes, autoClaimRewards, farmMoving, showMap, autoeat
local autoUpgradeSize, autoUpgradeSpd, autoUpgradeMulti, autoUpgradeEat
local keepUnanchor, boundProtect

-- 清理旧窗口
if LocalPlayer.PlayerGui:FindFirstChild("MobileFloatingWindow") then
    LocalPlayer.PlayerGui.MobileFloatingWindow:Destroy()
end

-- 主GUI（置顶不遮挡）
local gui = Instance.new("ScreenGui")
gui.Name = "MobileFloatingWindow"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999
gui.Parent = LocalPlayer.PlayerGui

-- ======================== 全局彩虹光带配置（统一色调，流动同步）========================
local hue = 0
-- 光带更新循环（只跑一次，所有光带共用，不卡顿）
RunService.RenderStepped:Connect(function(dt)
    hue = (hue + 1.2) % 360 -- 统一流动速度
end)

-- 创建彩虹光带框架（通用函数）
local function createRainbowBorder(parent, size, offset)
    local border = Instance.new("Frame")
    border.Size = size
    border.Position = offset or UDim2.new(0, 0, 0, 0)
    border.BackgroundTransparency = 1
    border.ZIndex = parent.ZIndex + 1
    border.Parent = parent.Parent
    
    local uiStroke = Instance.new("UIStroke", border)
    uiStroke.Thickness = 3 -- 光带厚度
    uiStroke.LineJoinMode = Enum.LineJoinMode.Round -- 圆角衔接
    uiStroke.LineCapMode = Enum.LineCapMode.Round
    
    -- 绑定彩虹色循环
    RunService.RenderStepped:Connect(function()
        uiStroke.Color = Color3.fromHSV(hue / 360, 0.9, 1)
    end)
    
    return border
end

-- ======================== 主悬浮窗（带彩色光带）========================
-- 光带外层框架（包裹主窗口，实现整体光带）
local mainBorder = Instance.new("Frame")
mainBorder.Size = UDim2.new(0, 326, 0, 456) -- 比主窗口大6像素，容纳光带
mainBorder.Position = UDim2.new(0, 57, 0, 57) -- 对应主窗口位置偏移
mainBorder.BackgroundTransparency = 1
mainBorder.ZIndex = 999
mainBorder.Parent = gui

-- 主窗口光带（流动彩虹边框）
local mainRainbowBorder = createRainbowBorder(mainBorder, UDim2.new(1, 0, 1, 0))
local mainUISTroke = mainRainbowBorder:FindFirstChildOfClass("UIStroke")
mainUISTroke.Thickness = 4 -- 主窗口光带更粗

-- 主窗口（内部内容容器）
local frame = Instance.new("Frame", mainBorder)
frame.Size = UDim2.new(1, -6, 1, -6) -- 向内缩6像素，留出光带空间
frame.Position = UDim2.new(0, 3, 0, 3)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0 -- 去掉原边框，用光带替代
frame.ClipsDescendants = true
frame.ZIndex = 1000

-- 标题栏+拖动
local dragArea = Instance.new("TextButton", frame)
dragArea.Size = UDim2.new(1, 0, 0, 30)
dragArea.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
dragArea.Text = "吃吃世界工具"
dragArea.TextColor3 = Color3.new(1,1,1)
dragArea.Font = Enum.Font.SourceSansBold
dragArea.TextSize = 18
dragArea.AutoButtonColor = true
dragArea.ZIndex = 1001

-- 最小化按钮（平躺椭圆形）
local miniBtn = Instance.new("TextButton", dragArea)
miniBtn.Size = UDim2.new(0, 40, 0, 20) -- 平躺椭圆：宽40，高20
miniBtn.Position = UDim2.new(1, -45, 0.5, -10)
miniBtn.Text = "-"
miniBtn.TextColor3 = Color3.new(1,1,1)
miniBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
miniBtn.AutoButtonColor = true
miniBtn.TextSize = 18
-- 变成平躺椭圆形
local miniBtnCorner = Instance.new("UICorner", miniBtn)
miniBtnCorner.CornerRadius = UDim.new(0.5, 0) -- 圆角=高度的一半，完美椭圆
-- 最小化按钮光带
createRainbowBorder(miniBtn, UDim2.new(1, 6, 1, 6), UDim2.new(0, -3, 0, -3))

-- 内容区（白色滚动条）
local scrollFrame = Instance.new("ScrollingFrame", frame)
scrollFrame.Size = UDim2.new(1, 0, 1, -30)
scrollFrame.Position = UDim2.new(0, 0, 0, 30)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 8 -- 滚动条加粗，更易点击
scrollFrame.ScrollBarImageColor3 = Color3.new(1, 1, 1) -- 白色滚动条
scrollFrame.ScrollBarBackgroundColor3 = Color3.fromRGB(40, 40, 40) -- 背景色，对比明显
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 820)
scrollFrame.ZIndex = 1000

local contentUI = Instance.new("UIListLayout", scrollFrame)
contentUI.Padding = UDim.new(0, 10)
contentUI.HorizontalAlignment = Enum.HorizontalAlignment.Center
contentUI.VerticalAlignment = Enum.VerticalAlignment.Top

-- 缩放按钮（保留原功能，优化样式）
local resizeBtn = Instance.new("ImageButton", frame)
resizeBtn.Size = UDim2.new(0, 36, 0, 36)
resizeBtn.Position = UDim2.new(1, -18, 1, -18)
resizeBtn.AnchorPoint = Vector2.new(1,1)
resizeBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
resizeBtn.Image = "rbxassetid://3926305904"
resizeBtn.ImageRectOffset = Vector2.new(84, 284)
resizeBtn.ImageRectSize = Vector2.new(36, 36)
resizeBtn.AutoButtonColor = true
resizeBtn.ZIndex = 1001
-- 缩放按钮光带
createRainbowBorder(resizeBtn, UDim2.new(1, 6, 1, 6), UDim2.new(0, -3, 0, -3))

-- ======================== 最小化后的平躺椭圆形按钮（带彩色流动光圈）========================
local miniOval = Instance.new("TextButton", gui)
miniOval.Size = UDim2.new(0, 100, 0, 50) -- 平躺椭圆：宽100，高50
miniOval.Position = UDim2.new(0, 30, 1, -80) -- 左下角，不遮挡操作
miniOval.BackgroundColor3 = Color3.fromRGB(25,25,25)
miniOval.Text = "+"
miniOval.TextSize = 28
miniOval.TextColor3 = Color3.new(1,1,1)
miniOval.Visible = false
miniOval.AutoButtonColor = true
miniOval.ZIndex = 1000
-- 平躺椭圆形
local miniOvalCorner = Instance.new("UICorner", miniOval)
miniOvalCorner.CornerRadius = UDim.new(0.5, 0)

-- 流动光圈（双层光带，模拟流动效果）
-- 内层光带（跟随主色调）
local miniInnerBorder = createRainbowBorder(miniOval, UDim2.new(1, -4, 1, -4), UDim2.new(0, 2, 0, 2))
local innerStroke = miniInnerBorder:FindFirstChildOfClass("UIStroke")
innerStroke.Thickness = 2

-- 外层光带（延迟色调，模拟流动）
local miniOuterBorder = createRainbowBorder(miniOval, UDim2.new(1, 8, 1, 8), UDim2.new(0, -4, 0, -4))
local outerStroke = miniOuterBorder:FindFirstChildOfClass("UIStroke")
outerStroke.Thickness = 3
-- 外层光带延迟流动
RunService.RenderStepped:Connect(function()
    local delayedHue = (hue + 60) % 360 -- 延迟60度，形成流动感
    outerStroke.Color = Color3.fromHSV(delayedHue / 360, 0.9, 1)
end)

-- ======================== 核心功能函数（不变）========================
local function getRoot()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end

local function changeMap()
    local args = {{MapTime = -1, Paused = true}}
    Events.SetServerSettings:FireServer(unpack(args))
end

local function checkLoaded()
    return (LocalPlayer.Character
        and LocalPlayer.Character:FindFirstChild("Humanoid")
        and LocalPlayer.Character:FindFirstChild("Size")
        and LocalPlayer.Character:FindFirstChild("Events")
        and LocalPlayer.Character.Events:FindFirstChild("Grab")
        and LocalPlayer.Character.Events:FindFirstChild("Eat")
        and LocalPlayer.Character.Events:FindFirstChild("Sell")
        and LocalPlayer.Character:FindFirstChild("CurrentChunk")) ~= nil
end

local function sizeGrowth(level) return math.floor(((level + 0.5) ^ 2 - 0.25) / 2 * 100) end
local function speedGrowth(level) return math.floor(level * 2 + 10) end
local function multiplierGrowth(level) return math.floor(level) end
local function eatSpeedGrowth(level) return math.floor((1 + (level - 1) * 0.2) * 10) / 10 end
local function sizePrice(level) return math.floor(level ^ 3 / 2) * 20 end
local function speedPrice(level) return math.floor((level * 3) ^ 3 / 200) * 1000 end
local function multiplierPrice(level) return math.floor((level * 10) ^ 3 / 200) * 1000 end
local function eatSpeedPrice(level) return math.floor((level * 10) ^ 3 / 200) * 2000 end

-- ======================== 功能按钮（平躺椭圆形+彩色光带）========================
local function createToggle(parent, text, callback)
    -- 按钮容器（承载按钮和光带）
    local btnContainer = Instance.new("Frame")
    btnContainer.Size = UDim2.new(0, 272, 0, 38) -- 比按钮大6像素，容纳光带
    btnContainer.BackgroundTransparency = 1
    btnContainer.Parent = parent
    
    -- 功能按钮（平躺椭圆形）
    local btn = Instance.new("TextButton", btnContainer)
    btn.Size = UDim2.new(1, -6, 1, -6)
    btn.Position = UDim2.new(0, 3, 0, 3)
    btn.BackgroundColor3 = Color3.fromRGB(60, 100, 180)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Text = text
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 16 -- 适配小尺寸按钮
    btn.AutoButtonColor = true
    btn.ZIndex = 1001
    -- 平躺椭圆形
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0.5, 0)
    
    -- 按钮彩色光带
    createRainbowBorder(btn, UDim2.new(1, 0, 1, 0))
    
    -- 开关逻辑
    local isEnabled = false
    btn.MouseButton1Click:Connect(function()
        isEnabled = not isEnabled
        btn.BackgroundColor3 = isEnabled and Color3.fromRGB(40, 200, 100) or Color3.fromRGB(60, 100, 180)
        callback(isEnabled)
    end)
    return btnContainer
end

local function createButton(parent, text, callback)
    -- 按钮容器
    local btnContainer = Instance.new("Frame")
    btnContainer.Size = UDim2.new(0, 272, 0, 38)
    btnContainer.BackgroundTransparency = 1
    btnContainer.Parent = parent
    
    -- 功能按钮（平躺椭圆形）
    local btn = Instance.new("TextButton", btnContainer)
    btn.Size = UDim2.new(1, -6, 1, -6)
    btn.Position = UDim2.new(0, 3, 0, 3)
    btn.BackgroundColor3 = Color3.fromRGB(180, 80, 120)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Text = text
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 16
    btn.AutoButtonColor = true
    btn.ZIndex = 1001
    -- 平躺椭圆形
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0.5, 0)
    
    -- 按钮彩色光带
    createRainbowBorder(btn, UDim2.new(1, 0, 1, 0))
    
    btn.MouseButton1Click:Connect(callback)
    return btnContainer
end

-- ======================== 所有功能按钮创建（不变）========================
-- 自动组按钮
createToggle(scrollFrame, "自动刷", function(enabled)
    autofarm = enabled
    if not enabled then return end
    coroutine.wrap(function()
        local text = Drawing.new("Text")
        text.Outline = true
        text.OutlineColor = Color3.new(0,0,0)
        text.Color = Color3.new(1,1,1)
        text.Position = Vector2.new(64, 64)
        text.Size = 14
        text.Visible = true
        
        local startTime = tick()
        local eatTime = 0
        local lastEatTime = tick()
        local timer = 0
        local grabTimer = 0
        local sellDebounce = false
        local sellCount = 0
        local numChunks = 0
        
        local bedrock = Instance.new("Part")
        bedrock.Anchored = true
        bedrock.Size = Vector3.new(2048, 10, 2048)
        bedrock.Position = Vector3.new(0, -5, 0)
        bedrock.BrickColor = BrickColor.Black()
        bedrock.Parent = workspace
        
        local map, chunks = workspace:FindFirstChild("Map"), workspace:FindFirstChild("Chunks")
        if map and chunks then map.Parent, chunks.Parent = nil, nil end
        
        local hum, root, size, events, eat, grab, sell, sendTrack, chunk, radius, autoConn
        
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
            
            autoConn = RunService.Heartbeat:Connect(function(dt)
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
                local secondEarn = math.floor(sizeGrowth(LocalPlayer.Upgrades.MaxSize.Value) / sellTime)
                
                text.Text = string.format(
                    "运行时间: %ih%im%is\n实际时间: %im%is\n大约时间: %im%is\n每秒收益: %i\n块数: %i",
                    hours, minutes % 60, seconds % 60,
                    eatMinutes % 60, eatSeconds % 60,
                    math.floor(sellTime / 60), math.floor(sellTime) % 60,
                    secondEarn, numChunks
                )
                
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
                    if timer < 8 then sell:FireServer() if not sellDebounce then changeMap() end sellDebounce = true
                    else changeMap() end
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
            
            hum.Died:Connect(function() if autoConn then autoConn:Disconnect() end changeMap() end)
            char:WaitForChild("LocalChunkManager").Enabled = false
            char:WaitForChild("Animate").Enabled = false
        end
        
        if LocalPlayer.Character then task.spawn(onCharAdd, LocalPlayer.Character)
        else task.spawn(onCharAdd, LocalPlayer.CharacterAdded:Wait()) end
        
        local charAddConn = LocalPlayer.CharacterAdded:Connect(onCharAdd)
        while autofarm do
            task.wait()
            if workspace:FindFirstChild("Loading") then workspace.Loading:Destroy() end
            if map and chunks then
                map.Parent, chunks.Parent = showMap and workspace or nil, showMap and workspace or nil
            end
        end
        
        charAddConn:Disconnect()
        if autoConn then autoConn:Disconnect() end
        if map and chunks then map.Parent, chunks.Parent = workspace, workspace end
        if hum then hum:ChangeState(Enum.HumanoidStateType.GettingUp) end
        bedrock:Destroy()
        if LocalPlayer.Character then
            LocalPlayer.Character.LocalChunkManager.Enabled = true
            LocalPlayer.Character.Animate.Enabled = true
        end
        text:Destroy()
    end)()
end)

createToggle(scrollFrame, "自动收", function(enabled)
    autoCollectingCubes = enabled
    if not enabled then return end
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

createToggle(scrollFrame, "自动领", function(enabled)
    autoClaimRewards = enabled
    if not enabled then return end
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

createToggle(scrollFrame, "移动模式", function(enabled) farmMoving = enabled end)
createToggle(scrollFrame, "显示地图", function(enabled) showMap = enabled end)
createToggle(scrollFrame, "自动吃", function(enabled)
    autoeat = enabled
    if not enabled then return end
    coroutine.wrap(function()
        while autoeat do
            task.wait()
            if checkLoaded() then
                LocalPlayer.Character.HumanoidRootPart.Anchored = false
                LocalPlayer.Character.Events.Grab:FireServer()
                LocalPlayer.Character.Events.Eat:FireServer()
            end
        end
    end)()
end)

createToggle(scrollFrame, "自动升级大小", function(enabled)
    autoUpgradeSize = enabled
    if not enabled then return end
    coroutine.wrap(function()
        game.CoreGui.PurchasePromptApp.Enabled = false
        while autoUpgradeSize do
            task.wait(1)
            Events.PurchaseEvent:FireServer("MaxSize")
        end
        game.CoreGui.PurchasePromptApp.Enabled = true
    end)()
end)

createToggle(scrollFrame, "自动升级移速", function(enabled)
    autoUpgradeSpd = enabled
    if not enabled then return end
    coroutine.wrap(function()
        game.CoreGui.PurchasePromptApp.Enabled = false
        while autoUpgradeSpd do
            task.wait(1)
            Events.PurchaseEvent:FireServer("Speed")
        end
        game.CoreGui.PurchasePromptApp.Enabled = true
    end)()
end)

createToggle(scrollFrame, "自动升级乘数", function(enabled)
    autoUpgradeMulti = enabled
    if not enabled then return end
    coroutine.wrap(function()
        game.CoreGui.PurchasePromptApp.Enabled = false
        while autoUpgradeMulti do
            task.wait(1)
            Events.PurchaseEvent:FireServer("Multiplier")
        end
        game.CoreGui.PurchasePromptApp.Enabled = true
    end)()
end)

createToggle(scrollFrame, "自动升级吃速", function(enabled)
    autoUpgradeEat = enabled
    if not enabled then return end
    coroutine.wrap(function()
        game.CoreGui.PurchasePromptApp.Enabled = false
        while autoUpgradeEat do
            task.wait(1)
            Events.PurchaseEvent:FireServer("EatSpeed")
        end
        game.CoreGui.PurchasePromptApp.Enabled = true
    end)()
end)

createToggle(scrollFrame, "取消锚固", function(enabled)
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

createToggle(scrollFrame, "边界保护", function(enabled)
    boundProtect = enabled
    if not enabled then return end
    coroutine.wrap(function()
        while boundProtect do
            task.wait()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local root = LocalPlayer.Character.HumanoidRootPart
                local pos = root.Position
                local mapSize = workspace.Map.Bedrock.Size * Vector3.new(1, 0, 1)
                local clampedPos = Vector3.new(
                    math.clamp(pos.X, -mapSize.X/2, mapSize.X/2),
                    pos.Y,
                    math.clamp(pos.Z, -mapSize.Z/2, mapSize.Z/2)
                )
                root.CFrame = CFrame.new(clampedPos) * root.CFrame.Rotation
            end
        end
    end)()
end)

createButton(scrollFrame, "查看玩家数据", function()
    local localization = {MaxSize = "体积", Speed = "移速", Multiplier = "乘数", EatSpeed = "吃速"}
    local growthFunctions = {MaxSize = sizeGrowth, Speed = speedGrowth, Multiplier = multiplierGrowth, EatSpeed = eatSpeedGrowth}
    local priceFunctions = {MaxSize = sizePrice, Speed = speedPrice, Multiplier = multiplierPrice, EatSpeed = eatSpeedPrice}
    
    for _, player in Players:GetPlayers() do
        print()
        for _, upg in player.Upgrades:GetChildren() do
            local cost = 0
            for l = 2, upg.Value do cost += priceFunctions[upg.Name](l) end
            print(string.format(
                "%s：%s %i级；%i值；%i花费",
                player.Name, localization[upg.Name], upg.Value,
                growthFunctions[upg.Name](upg.Value), cost
            ))
        end
    end
    game.StarterGui:SetCore("DevConsoleVisible", true)
end)

createToggle(scrollFrame, "竖屏模式", function(enabled)
    LocalPlayer.PlayerGui.ScreenOrientation = enabled and Enum.ScreenOrientation.Portrait or Enum.ScreenOrientation.LandscapeRight
end)

-- ======================== 悬浮窗基础功能（不变）========================
-- 拖动逻辑
local dragging, draggingMini = false, false
local dragStart, startPos, miniStart, miniPos

dragArea.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainBorder.Position -- 拖动光带框架，同步窗口和光带
    end
end)

dragArea.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

miniOval.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        draggingMini = true
        miniStart = input.Position
        miniPos = miniOval.Position
    end
end)

miniOval.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then draggingMini = false end
end)

UserInputService.TouchMoved:Connect(function(input)
    if dragging then
        local delta = input.Position - dragStart
        mainBorder.Position = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
    elseif draggingMini then
        local delta = input.Position - miniStart
        miniOval.Position = UDim2.new(0, miniPos.X.Offset + delta.X, 0, miniPos.Y.Offset + delta.Y)
    end
end)

-- 缩放逻辑
local resizing = false
local resizeStartPos, resizeStartSize

resizeBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        resizing = true
        resizeStartPos = input.Position
        resizeStartSize = mainBorder.Size -- 缩放光带框架
    end
end)

resizeBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then resizing = false end
end)

UserInputService.TouchMoved:Connect(function(input)
    if resizing then
        local delta = input.Position - resizeStartPos
        local newW = math.max(290, resizeStartSize.X.Offset + delta.X)
        local newH = math.max(420, resizeStartSize.Y.Offset + delta.Y)
        mainBorder.Size = UDim2.new(0, newW, 0, newH)
        frame.Size = UDim2.new(1, -6, 1, -6) -- 同步主窗口大小
    end
end)

-- 最小化/双击打开逻辑
miniBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        frame.Visible = false
        mainRainbowBorder.Visible = false -- 隐藏主窗口光带
        miniOval.Visible = true
    end
end)

local lastClickTime = 0
local doubleClickDelay = 400
miniOval.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        local currentTime = tick()
        if currentTime - lastClickTime < doubleClickDelay then
            miniOval.Visible = false
            frame.Visible = true
            mainRainbowBorder.Visible = true -- 恢复主窗口光带
        end
        lastClickTime = currentTime
    end
end)
