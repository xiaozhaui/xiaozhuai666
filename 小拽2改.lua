--[[
吃吃世界 — 悬浮窗（可拖拽/最小化/RightShift切换）+ 原功能 UI 接管版
说明：
1) 仅替换 UI 与交互层，保留原逻辑（自动刷/自动收/自动领/升级/人物/其它等）；
2) RightShift 可显示/隐藏整个悬浮窗；标题栏可拖拽；支持最小化；
3) 各功能开关、按钮均迁移至新悬浮窗的 Content 区域；
]]

-- ========= 环境 / 原逻辑依赖 =========
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local playerGui = LocalPlayer:WaitForChild("PlayerGui")
local Events = ReplicatedStorage:WaitForChild("Events")

-- ========= 悬浮窗（替换成你提供的样式） =========
-- 如果已有同名 GUI，避免重复
local old = playerGui:FindFirstChild("FloatingWin")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "FloatingWin"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = playerGui

local win = Instance.new("Frame")
win.Name = "Window"
win.Size = UDim2.fromOffset(360, 260)
win.Position = UDim2.fromOffset(120, 120)
win.BackgroundColor3 = Color3.fromRGB(24, 26, 32)
win.BackgroundTransparency = 0.05
win.BorderSizePixel = 0
win.ZIndex = 50
win.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = win

-- 阴影（可选）
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.Position = UDim2.fromScale(0.5, 0.5)
shadow.Size = UDim2.new(1, 60, 1, 60)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://5028857084"
shadow.ImageTransparency = 0.35
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(24, 24, 276, 276)
shadow.ZIndex = 40
shadow.Parent = win

-- 标题栏
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 36)
titleBar.BackgroundTransparency = 0.8
titleBar.BackgroundColor3 = Color3.fromRGB(255,255,255)
titleBar.BorderSizePixel = 0
titleBar.ZIndex = 60
titleBar.Parent = win

local title = Instance.new("TextLabel")
title.Text = "吃吃世界 — 悬浮窗"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextColor3 = Color3.fromRGB(240, 240, 240)
title.BackgroundTransparency = 1
title.Position = UDim2.fromOffset(12, 0)
title.Size = UDim2.new(1, -120, 1, 0)
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 60
title.Parent = titleBar

local btnClose = Instance.new("TextButton")
btnClose.Text = "×"
btnClose.Font = Enum.Font.GothamBold
btnClose.TextSize = 16
btnClose.TextColor3 = Color3.fromRGB(230,230,230)
btnClose.BackgroundTransparency = 0.85
btnClose.Size = UDim2.fromOffset(32, 24)
btnClose.Position = UDim2.new(1, -36, 0, 6)
btnClose.ZIndex = 70
btnClose.Parent = titleBar

local btnMin = Instance.new("TextButton")
btnMin.Text = "—"
btnMin.Font = Enum.Font.GothamBold
btnMin.TextSize = 16
btnMin.TextColor3 = Color3.fromRGB(230,230,230)
btnMin.BackgroundTransparency = 0.85
btnMin.Size = UDim2.fromOffset(32, 24)
btnMin.Position = UDim2.new(1, -72, 0, 6)
btnMin.ZIndex = 70
btnMin.Parent = titleBar

-- 内容区容器
local content = Instance.new("Frame")
content.Name = "Content"
content.Position = UDim2.fromOffset(12, 44)
content.Size = UDim2.new(1, -24, 1, -56)
content.BackgroundTransparency = 1
content.ZIndex = 50
content.Parent = win

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 4)
padding.PaddingBottom = UDim.new(0, 8)
padding.PaddingLeft = UDim.new(0, 8)
padding.PaddingRight = UDim.new(0, 8)
padding.Parent = content

local list = Instance.new("UIListLayout")
list.SortOrder = Enum.SortOrder.LayoutOrder
list.Padding = UDim.new(0, 6)
list.Parent = content

-- 拖拽逻辑（支持鼠标与触屏）
do
    local dragging, dragStart, startPos
    local function updateDrag(input)
        local delta = input.Position - dragStart
        win.Position = UDim2.fromOffset(startPos.X.Offset + delta.X, startPos.Y.Offset + delta.Y)
    end

    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = win.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            updateDrag(input)
        end
    end)
end

-- 关闭 / 最小化 / 快捷键切换
btnClose.MouseButton1Click:Connect(function()
    gui.Enabled = false
end)
local collapsed = false
local originalSize = win.Size
btnMin.MouseButton1Click:Connect(function()
    collapsed = not collapsed
    if collapsed then
        content.Visible = false
        win.Size = UDim2.fromOffset(originalSize.X.Offset, 40)
    else
        content.Visible = true
        win.Size = originalSize
    end
end)
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        gui.Enabled = not gui.Enabled
    end
end)

-- ============ UI 工具：分区 / 开关 / 按钮 =============
local function addSection(titleText)
    local sec = Instance.new("TextLabel")
    sec.Size = UDim2.new(1, 0, 0, 20)
    sec.BackgroundTransparency = 1
    sec.Font = Enum.Font.GothamBold
    sec.TextSize = 13
    sec.TextXAlignment = Enum.TextXAlignment.Left
    sec.TextColor3 = Color3.fromRGB(170, 200, 255)
    sec.Text = titleText
    sec.LayoutOrder = 0
    sec.Parent = content
end

local function createToggle(labelText, defaultOn, onChanged)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 28)
    row.BackgroundTransparency = 0.8
    row.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    row.LayoutOrder = 1
    row.Parent = content

    local rcorner = Instance.new("UICorner")
    rcorner.CornerRadius = UDim.new(0, 8)
    rcorner.Parent = row

    local lab = Instance.new("TextLabel")
    lab.BackgroundTransparency = 1
    lab.Position = UDim2.fromOffset(10, 0)
    lab.Size = UDim2.new(1, -90, 1, 0)
    lab.Font = Enum.Font.Gotham
    lab.TextSize = 14
    lab.TextXAlignment = Enum.TextXAlignment.Left
    lab.TextColor3 = Color3.fromRGB(30, 30, 30)
    lab.Text = labelText
    lab.Parent = row

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromOffset(64, 24)
    btn.Position = UDim2.new(1, -74, 0.5, -12)
    btn.BackgroundColor3 = Color3.fromRGB(40, 120, 255)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.Text = "开"
    btn.Parent = row

    local bcorner = Instance.new("UICorner")
    bcorner.CornerRadius = UDim.new(0, 6)
    bcorner.Parent = btn

    local state = defaultOn and true or false
    local function render()
        if state then
            btn.Text = "开"
            btn.BackgroundColor3 = Color3.fromRGB(40, 120, 255)
        else
            btn.Text = "关"
            btn.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
        end
    end
    render()

    btn.MouseButton1Click:Connect(function()
        state = not state
        render()
        if onChanged then
            task.spawn(onChanged, state)
        end
    end)

    return {
        Set = function(v)
            state = v and true or false
            render()
            if onChanged then task.spawn(onChanged, state) end
        end
    }
end

local function createButton(labelText, onClick)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 28)
    row.BackgroundTransparency = 0.8
    row.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    row.LayoutOrder = 1
    row.Parent = content

    local rcorner = Instance.new("UICorner")
    rcorner.CornerRadius = UDim.new(0, 8)
    rcorner.Parent = row

    local lab = Instance.new("TextLabel")
    lab.BackgroundTransparency = 1
    lab.Position = UDim2.fromOffset(10, 0)
    lab.Size = UDim2.new(1, -100, 1, 0)
    lab.Font = Enum.Font.Gotham
    lab.TextSize = 14
    lab.TextXAlignment = Enum.TextXAlignment.Left
    lab.TextColor3 = Color3.fromRGB(30, 30, 30)
    lab.Text = labelText
    lab.Parent = row

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromOffset(80, 24)
    btn.Position = UDim2.new(1, -90, 0.5, -12)
    btn.BackgroundColor3 = Color3.fromRGB(20, 160, 140)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.Text = "执行"
    btn.Parent = row

    local bcorner = Instance.new("UICorner")
    bcorner.CornerRadius = UDim.new(0, 6)
    bcorner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        if onClick then task.spawn(onClick) end
    end)
end

-- ============ 以下为原脚本逻辑（保持不变，仅把开关迁至新 UI） ============
-- 标记变量（由 UI 控制）
local autofarm = false
local autoCollectingCubes = false
local autoClaimRewards = false
local farmMoving = false
local showMap = false
local autoeat = false
local autoUpgradeSize = false
local autoUpgradeSpd = false
local autoUpgradeMulti = false
local autoUpgradeEat = false
local keepUnanchor = false
local boundProtect = false

-- 原工具函数/逻辑
local function getRoot()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end

local function randomTp(character)
    local pos = workspace.Map.Bedrock.Position + Vector3.new(
        math.random(-workspace.Map.Bedrock.Size.X / 2, workspace.Map.Bedrock.Size.X / 2), 0,
        math.random(-workspace.Map.Bedrock.Size.X / 2, workspace.Map.Bedrock.Size.X / 2)
    )
    character:MoveTo(pos)
    character:PivotTo(CFrame.new(character:GetPivot().Position, workspace.Map.Bedrock.Position))
end

local function changeMap()
    local args = { { MapTime = -1, Paused = true } }
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

local function sizeGrowth(level)      return math.floor(((level + 0.5) ^ 2 - 0.25) / 2 * 100) end
local function speedGrowth(level)     return math.floor(level * 2 + 10) end
local function multiplierGrowth(level) return math.floor(level) end
local function eatSpeedGrowth(level)  return math.floor((1 + (level - 1) * 0.2) * 10) / 10 end
local function sizePrice(level)       return math.floor(level ^ 3 / 2) * 20 end
local function speedPrice(level)      return math.floor((level * 3) ^ 3 / 200) * 1000 end
local function multiplierPrice(level) return math.floor((level * 10) ^ 3 / 200) * 1000 end
local function eatSpeedPrice(level)   return math.floor((level * 10) ^ 3 / 200) * 2000 end

local function teleportPos()
    LocalPlayer.Character:PivotTo(CFrame.new(0, LocalPlayer.Character.Humanoid.HipHeight * 2, -100) * CFrame.Angles(0, math.rad(-90), 0))
end

-- ============ 将原“UI库里的开关”迁移为新悬浮窗控件 ============
-- 自动刷
local function toggle_autofarm(enabled)
    autofarm = enabled
    if not enabled then return end
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
        -- bedrock.Transparency = 1
        bedrock.BrickColor = BrickColor.Black()
        bedrock.Parent = workspace

        local map, chunks = workspace:FindFirstChild("Map"), workspace:FindFirstChild("Chunks")
        if map and chunks then
            map.Parent, chunks.Parent = nil, nil
        end

        local numChunks = 0

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

            autoConn = game["Run Service"].Heartbeat:Connect(function(dt)
                if not autofarm then
                    if autoConn then autoConn:Disconnect() end
                    return
                end

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

                text.Text = ""
                    .. "\n运行时间: " .. string.format("%ih%im%is", hours, minutes % 60, seconds % 60)
                    .. "\n实际时间: " .. string.format("%im%is", eatMinutes % 60, eatSeconds % 60)
                    .. "\n大约时间: " .. string.format("%im%is", sellMinutes % 60, sellSeconds % 60)
                    .. "\n每天: " .. dayEarn
                    .. "\n块数: " .. numChunks

                hum:ChangeState(Enum.HumanoidStateType.Physics)
                grab:FireServer()
                root.Anchored = false
                eat:FireServer()
                sendTrack:FireServer()

                if chunk.Value then
                    if timer > 0 then
                        numChunks += 1
                    end
                    timer = 0
                    grabTimer += dt
                else
                    timer += dt
                    grabTimer = 0
                end

                if timer > 60 then
                    hum.Health = 0
                    timer = 0
                    numChunks = 0
                end

                if grabTimer > 15 then
                    size.Value = LocalPlayer.Upgrades.MaxSize.Value
                end

                if (size.Value >= LocalPlayer.Upgrades.MaxSize.Value) or timer > 8 then
                    if timer < 8 then
                        sell:FireServer()
                        if not sellDebounce then
                            changeMap()
                        end
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

                    if z > bound then
                        changeMap()
                        numChunks = 0
                    end

                    root.CFrame = startPos * offset
                else
                    root.CFrame = CFrame.new(0, y, 0)
                end
            end)

            hum.Died:Connect(function()
                if autoConn then autoConn:Disconnect() end
                changeMap()
            end)

            char:WaitForChild("LocalChunkManager").Enabled = false
            char:WaitForChild("Animate").Enabled = false
        end

        if LocalPlayer.Character then
            task.spawn(onCharAdd, LocalPlayer.Character)
        else
            task.spawn(onCharAdd, LocalPlayer.CharacterAdded:Wait())
        end
        local charAddConn = LocalPlayer.CharacterAdded:Connect(onCharAdd)
        while autofarm do
            local dt = task.wait()
            if workspace:FindFirstChild("Loading") then
                workspace.Loading:Destroy()
            end
            local map, chunks = workspace:FindFirstChild("Map"), workspace:FindFirstChild("Chunks")
            if map and chunks then
                if showMap then
                    map.Parent, chunks.Parent = workspace, workspace
                else
                    map.Parent, chunks.Parent = nil, nil
                end
            end
        end
        charAddConn:Disconnect()
        if map and chunks then
            map.Parent, chunks.Parent = workspace, workspace
        end
        if hum then hum:ChangeState(Enum.HumanoidStateType.GettingUp) end
        bedrock:Destroy()
        if LocalPlayer.Character then
            LocalPlayer.Character.LocalChunkManager.Enabled = true
            LocalPlayer.Character.Animate.Enabled = true
        end
        text:Destroy()
    end)()
end

-- 自动收
local function toggle_autoCollectingCubes(enabled)
    autoCollectingCubes = enabled
    if not enabled then return end
    coroutine.wrap(function()
        local saved = LocalPlayer.PlayerScripts:FindFirstChild("CubeVis")
        if saved then saved.Enabled = false end
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
        if saved then saved.Enabled = true end
    end)()
end

-- 自动领
local function toggle_autoClaimRewards(enabled)
    autoClaimRewards = enabled
    if not enabled then return end
    coroutine.wrap(function()
        while autoClaimRewards do
            task.wait(1)
            for _, reward in LocalPlayer.TimedRewards:GetChildren() do
                if reward.Value > 0 then
                    Events.RewardEvent:FireServer(reward)
                end
            end
            Events.SpinEvent:FireServer()
        end
    end)()
end

-- 移动模式
local function toggle_farmMoving(enabled)
    farmMoving = enabled
end

-- 显示地图
local function toggle_showMap(enabled)
    showMap = enabled
end

-- 自动吃
local function toggle_autoeat(enabled)
    autoeat = enabled
    if not enabled then return end
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
end

-- 升级相关
local function toggle_autoUpgradeSize(enabled)
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
end
local function toggle_autoUpgradeSpd(enabled)
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
end
local function toggle_autoUpgradeMulti(enabled)
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
end
local function toggle_autoUpgradeEat(enabled)
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
end

-- 人物
local function toggle_keepUnanchor(enabled)
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
end

local function toggle_boundProtect(enabled)
    boundProtect = enabled
    if not enabled then return end
    coroutine.wrap(function()
        while boundProtect do
            task.wait()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local root = LocalPlayer.Character.HumanoidRootPart
                local pos = root.Position
                local mapSize = workspace.Map.Bedrock.Size * Vector3.new(1, 0, 1)
                -- 保持与原逻辑一致（不改动具体实现）
                local clampedPos = vector.clamp(pos * Vector3.new(1, 0, 1), -mapSize / 2, mapSize / 2)
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(clampedPos.X, pos.Y, clampedPos.Z) * root.CFrame.Rotation
            end
        end
    end)()
end

-- 其它
local function viewPlayerData()
    local localization = {
        MaxSize = "体积",
        Speed = "移速",
        Multiplier = "乘数",
        EatSpeed = "吃速",
    }
    local growthFunctions = {
        MaxSize = sizeGrowth,
        Speed = speedGrowth,
        Multiplier = multiplierGrowth,
        EatSpeed = eatSpeedGrowth,
    }
    local priceFunctions = {
        MaxSize = sizePrice,
        Speed = speedPrice,
        Multiplier = multiplierPrice,
        EatSpeed = eatSpeedPrice,
    }
    for _, player in Players:GetPlayers() do
        print()
        for _, upg in player.Upgrades:GetChildren() do
            local contentText = player.Name .. "："
            local cost = 0
            for l = 2, upg.Value do
                cost += priceFunctions[upg.Name](l)
            end
            contentText = contentText .. " " .. string.format("%s： %d级； %d值； %d花费；",
                localization[upg.Name], upg.Value, growthFunctions[upg.Name](upg.Value), cost)
            print(contentText)
        end
    end
    game.StarterGui:SetCore("DevConsoleVisible", true)
end

local function toggle_portrait(enabled)
    LocalPlayer.PlayerGui.ScreenOrientation = enabled and Enum.ScreenOrientation.Portrait or Enum.ScreenOrientation.LandscapeRight
end

-- ============ 将控件挂到新悬浮窗 Content ============
-- 自动
addSection("自动")
createToggle("自动刷", false, toggle_autofarm)
createToggle("自动收", false, toggle_autoCollectingCubes)
createToggle("自动领", false, toggle_autoClaimRewards)
createToggle("移动模式", false, toggle_farmMoving)
createToggle("显示地图", false, toggle_showMap)
createToggle("自动吃", false, toggle_autoeat)

-- 升级
addSection("升级")
createToggle("大小", false, toggle_autoUpgradeSize)
createToggle("移速", false, toggle_autoUpgradeSpd)
createToggle("乘数", false, toggle_autoUpgradeMulti)
createToggle("吃速", false, toggle_autoUpgradeEat)

-- 人物
addSection("人物")
createToggle("取消锚固", false, toggle_keepUnanchor)
createToggle("边界保护", false, toggle_boundProtect)

-- 其它
addSection("其它")
createButton("查看玩家数据", viewPlayerData)
createToggle("竖屏", false, toggle_portrait)

-- 完成
print("[悬浮窗] 已加载：可拖拽 + 最小化 + RightShift 切换。所有功能开关已迁移到悬浮窗 UI。")
