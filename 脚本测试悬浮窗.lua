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

-- 主GUI（确保在PlayerGui，不被拦截）
local gui = Instance.new("ScreenGui")
gui.Name = "MobileFloatingWindow"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999 -- 置顶，避免被遮挡
gui.Parent = LocalPlayer.PlayerGui

-- 主窗口
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 320, 0, 450)
frame.Position = UDim2.new(0, 60, 0, 60)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
frame.ClipsDescendants = true

-- 标题栏+拖动
local dragArea = Instance.new("TextButton", frame)
dragArea.Size = UDim2.new(1, 0, 0, 30)
dragArea.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
dragArea.Text = "吃吃世界工具"
dragArea.TextColor3 = Color3.new(1,1,1)
dragArea.Font = Enum.Font.SourceSansBold
dragArea.TextSize = 18
dragArea.AutoButtonColor = true

-- 最小化按钮（优化点击反馈）
local miniBtn = Instance.new("TextButton", dragArea)
miniBtn.Size = UDim2.new(0, 40, 0, 30)
miniBtn.Position = UDim2.new(1, -40, 0, 0)
miniBtn.Text = "-"
miniBtn.TextColor3 = Color3.new(1,1,1)
miniBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
miniBtn.AutoButtonColor = true
miniBtn.TextSize = 22

-- 内容区（滚动容器）
local scrollFrame = Instance.new("ScrollingFrame", frame)
scrollFrame.Size = UDim2.new(1, 0, 1, -30)
scrollFrame.Position = UDim2.new(0, 0, 0, 30)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 6
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(80,80,80)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 800)

local contentUI = Instance.new("UIListLayout", scrollFrame)
contentUI.Padding = UDim.new(0, 8)
contentUI.HorizontalAlignment = Enum.HorizontalAlignment.Center
contentUI.VerticalAlignment = Enum.VerticalAlignment.Top

-- 缩放按钮
local resizeBtn = Instance.new("ImageButton", frame)
resizeBtn.Size = UDim2.new(0, 36, 0, 36)
resizeBtn.Position = UDim2.new(1, -18, 1, -18)
resizeBtn.AnchorPoint = Vector2.new(1,1)
resizeBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
resizeBtn.Image = "rbxassetid://3926305904"
resizeBtn.ImageRectOffset = Vector2.new(84, 284)
resizeBtn.ImageRectSize = Vector2.new(36, 36)
resizeBtn.AutoButtonColor = true

-- ======================== 关键修复：迷你圆形按钮（彩虹光带+可见性）========================
local miniCircle = Instance.new("TextButton", gui)
miniCircle.Size = UDim2.new(0, 70, 0, 70) -- 放大按钮，更容易看到
-- 调整位置到左下角（绝对可见，不会超出屏幕）
miniCircle.Position = UDim2.new(0, 30, 1, -100)
miniCircle.BackgroundColor3 = Color3.fromRGB(25,25,25)
miniCircle.Text = "+"
miniCircle.TextSize = 36 -- 放大文字，更显眼
miniCircle.TextColor3 = Color3.new(1,1,1)
miniCircle.BorderSizePixel = 4 -- 加粗边框，彩虹效果更明显
miniCircle.Visible = false
miniCircle.AutoButtonColor = true
miniCircle.ZIndex = 10 -- 确保在最上层
Instance.new("UICorner", miniCircle).CornerRadius = UDim.new(1,0)

-- 🌈 彩虹边框动画（强制运行，确保光带显示）
local hue = 0
RunService.RenderStepped:Connect(function()
    if miniCircle.Visible then
        hue = (hue + 2) % 360 -- 加快速度，光带更明显
        miniCircle.BorderColor3 = Color3.fromHSV(hue / 360, 1, 1)
        -- 额外添加背景微光，更易识别
        miniCircle.BackgroundColor3 = Color3.fromHSV(hue / 360, 0.3, 0.2)
    end
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

-- ======================== 功能按钮创建（不变）========================
local function createToggle(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0, 280, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(60, 100, 180)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Text = text
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 18
    btn.AutoButtonColor = true
    
    local isEnabled = false
    btn.MouseButton1Click:Connect(function()
        isEnabled = not isEnabled
        btn.BackgroundColor3 = isEnabled and Color3.fromRGB(40, 200, 100) or Color3.fromRGB(60, 100, 180)
        callback(isEnabled)
    end)
    return btn
end

local function createButton(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0, 280, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(180, 80, 120)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Text = text
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 18
    btn.AutoButtonColor = true
    btn.MouseButton1Click:Connect(callback)
    return btn
end

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

-- ======================== 悬浮窗基础功能（关键修复）========================
-- 拖动逻辑
local dragging, draggingMini = false, false
local dragStart, startPos, miniStart, miniPos

dragArea.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

dragArea.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

miniCircle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        draggingMini = true
        miniStart = input.Position
        miniPos = miniCircle.Position
    end
end)

miniCircle.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then draggingMini = false end
end)

UserInputService.TouchMoved:Connect(function(input)
    if dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
    elseif draggingMini then
        local delta = input.Position - miniStart
        miniCircle.Position = UDim2.new(0, miniPos.X.Offset + delta.X, 0, miniPos.Y.Offset + delta.Y)
    end
end)

-- 缩放逻辑
local resizing = false
local resizeStartPos, resizeStartSize

resizeBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        resizing = true
        resizeStartPos = input.Position
        resizeStartSize = frame.Size
    end
end)

resizeBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then resizing = false end
end)

UserInputService.TouchMoved:Connect(function(input)
    if resizing then
        local delta = input.Position - resizeStartPos
        local newW = math.max(280, resizeStartSize.X.Offset + delta.X)
        local newH = math.max(400, resizeStartSize.Y.Offset + delta.Y)
        frame.Size = UDim2.new(0, newW, 0, newH)
    end
end)

-- ======================== 关键修复：最小化/双击打开逻辑 =======================
-- 最小化：隐藏主窗口，强制显示圆形按钮
miniBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        frame.Visible = false
        miniCircle.Visible = true -- 强制显示，避免被覆盖
        print("最小化成功，圆形按钮已显示") -- 调试用，可删除
    end
end)

-- 双击圆形按钮打开（延长间隔到400ms，更易触发）
local lastClickTime = 0
local doubleClickDelay = 400 -- 延长双击间隔，适配移动端操作
miniCircle.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        local currentTime = tick()
        print("点击圆形按钮，间隔：", currentTime - lastClickTime) -- 调试用，可删除
        if currentTime - lastClickTime < doubleClickDelay then
            -- 双击成功，恢复窗口
            miniCircle.Visible = false
            frame.Visible = true
        end
        lastClickTime = currentTime
    end
end)
