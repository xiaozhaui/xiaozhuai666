local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Events = ReplicatedStorage:WaitForChild("Events")
local LocalPlayer = Players.LocalPlayer

-- === Floating Window UILib (local replacement; UI only, no logic changes) ===
local function __MakeFloatingUILib()
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

    -- remove existing gui to avoid duplicates
    local old = playerGui:FindFirstChild("FloatingWin")
    if old then old:Destroy() end

    local gui = Instance.new("ScreenGui")
    gui.Name = "FloatingWin"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 32767
    gui.Parent = playerGui

    local win = Instance.new("Frame")
    win.Name = "Window"
    win.Size = UDim2.fromOffset(360, 260)
    win.Position = UDim2.fromOffset(96, 120)
    win.BackgroundColor3 = Color3.fromRGB(24,26,32)
    win.BackgroundTransparency = 0.05
    win.BorderSizePixel = 0
    win.ClipsDescendants = true
    win.ZIndex = 100
    win.Parent = gui

    local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0, 14); corner.Parent = win

    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 36)
    titleBar.BackgroundTransparency = 0.8
    titleBar.BackgroundColor3 = Color3.fromRGB(255,255,255)
    titleBar.BorderSizePixel = 0
    titleBar.ZIndex = 110
    titleBar.Parent = win

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Text = "窗口"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.TextColor3 = Color3.fromRGB(240,240,240)
    title.BackgroundTransparency = 1
    title.Position = UDim2.fromOffset(12, 0)
    title.Size = UDim2.new(1, -84, 1, 0)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 111
    title.Parent = titleBar

    -- only minimize button (no close to avoid misclick)
    local btnMin = Instance.new("TextButton")
    btnMin.Text = "—"
    btnMin.Font = Enum.Font.GothamBold
    btnMin.TextSize = 16
    btnMin.TextColor3 = Color3.fromRGB(230,230,230)
    btnMin.BackgroundTransparency = 0.85
    btnMin.Size = UDim2.fromOffset(32, 24)
    btnMin.Position = UDim2.new(1, -36, 0, 6)
    btnMin.ZIndex = 112
    btnMin.Parent = titleBar

    -- content area
    local content = Instance.new("ScrollingFrame")
    content.Name = "Content"
    content.Position = UDim2.fromOffset(12, 44)
    content.Size = UDim2.new(1, -24, 1, -56)
    content.BackgroundTransparency = 1
    content.ScrollingDirection = Enum.ScrollingDirection.Y
    content.ScrollBarThickness = 6
    content.VerticalScrollBarInset = Enum.ScrollBarInset.Always
    content.Active = true
    content.ClipsDescendants = true
    content.ZIndex = 120
    content.Parent = win

    local container = Instance.new("Frame")
    container.Name = "Container"
    container.Size = UDim2.new(1, 0, 0, 0)
    container.BackgroundTransparency = 1
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.ZIndex = 121
    container.Parent = content

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 6)
    padding.PaddingBottom = UDim.new(0, 8)
    padding.PaddingLeft = UDim.new(0, 8)
    padding.PaddingRight = UDim.new(0, 8)
    padding.Parent = container

    local list = Instance.new("UIListLayout")
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Padding = UDim.new(0, 6)
    list.Parent = container

    local function updateCanvas()
        local h = list.AbsoluteContentSize.Y + padding.PaddingTop.Offset + padding.PaddingBottom.Offset
        content.CanvasSize = UDim2.new(0, 0, 0, math.max(h, 0))
    end
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
    updateCanvas()

    -- drag
    do
        local dragging, dragStart, startPos
        local function updateDrag(input)
            local delta = input.Position - dragStart
            win.Position = UDim2.fromOffset(startPos.X.Offset + delta.X, startPos.Y.Offset + delta.Y)
        end
        titleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true; dragStart = input.Position; startPos = win.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                updateDrag(input)
            end
        end)
    end

    -- minimize / RightShift toggle visibility
    local collapsed, originalSize = false, win.Size
    btnMin.MouseButton1Click:Connect(function()
        collapsed = not collapsed
        if collapsed then content.Visible = false; win.Size = UDim2.fromOffset(originalSize.X.Offset, 40)
        else content.Visible = true; win.Size = originalSize end
    end)
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.RightShift then
            gui.Enabled = not gui.Enabled
        end
    end)

    -- helper builders matching original lib API
    local function addSectionHeader(text)
        local sec = Instance.new("TextLabel")
        sec.Size = UDim2.new(1, 0, 0, 20)
        sec.BackgroundTransparency = 1
        sec.Font = Enum.Font.GothamBold
        sec.TextSize = 13
        sec.TextXAlignment = Enum.TextXAlignment.Left
        sec.TextColor3 = Color3.fromRGB(170, 200, 255)
        sec.Text = text
        sec.ZIndex = 122
        sec.Parent = container
    end

    local function makeToggleRow(labelText, callback)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 32)
        row.BackgroundTransparency = 0.8
        row.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        row.ZIndex = 122
        row.ClipsDescendants = true
        row.Parent = container
        local rcorner = Instance.new("UICorner"); rcorner.CornerRadius = UDim.new(0, 8); rcorner.Parent = row

        local labBtn = Instance.new("TextButton")
        labBtn.BackgroundTransparency = 1; labBtn.AutoButtonColor = false
        labBtn.Position = UDim2.fromOffset(10, 0); labBtn.Size = UDim2.new(1, -100, 1, 0)
        labBtn.Font = Enum.Font.Gotham; labBtn.TextSize = 14
        labBtn.TextXAlignment = Enum.TextXAlignment.Left
        labBtn.TextColor3 = Color3.fromRGB(30, 30, 30); labBtn.Text = labelText
        labBtn.ZIndex = 123; labBtn.Parent = row

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.fromOffset(64, 24)
        btn.Position = UDim2.new(1, -74, 0.5, -12)
        btn.BackgroundColor3 = Color3.fromRGB(40, 120, 255)
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.TextSize = 14
        btn.Font = Enum.Font.GothamBold
        btn.Text = "开"
        btn.ZIndex = 123
        btn.Parent = row
        local bcorner = Instance.new("UICorner"); bcorner.CornerRadius = UDim.new(0, 6); bcorner.Parent = btn

        local hit = Instance.new("TextButton")
        hit.BackgroundTransparency = 1; hit.AutoButtonColor = false
        hit.Size = UDim2.fromScale(1,1); hit.Text=""; hit.ZIndex=122; hit.Parent = row

        local state = false
        local function render()
            if state then btn.Text = "开"; btn.BackgroundColor3 = Color3.fromRGB(40, 120, 255)
            else btn.Text = "关"; btn.BackgroundColor3 = Color3.fromRGB(120, 120, 120) end
        end
        local function toggle()
            state = not state; render()
            if callback then
                -- keep original callback signature: callback(enabled)
                local ok, err = pcall(function() callback(state) end)
                if not ok then warn("[UI Toggle error]", err) end
            end
        end
        render()
        btn.MouseButton1Click:Connect(toggle)
        labBtn.MouseButton1Click:Connect(toggle)
        hit.MouseButton1Click:Connect(toggle)
    end

    local function makeButtonRow(labelText, callback)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 32)
        row.BackgroundTransparency = 0.8
        row.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        row.ZIndex = 122
        row.ClipsDescendants = true
        row.Parent = container
        local rcorner = Instance.new("UICorner"); rcorner.CornerRadius = UDim.new(0, 8); rcorner.Parent = row

        local labBtn = Instance.new("TextButton")
        labBtn.BackgroundTransparency = 1; labBtn.AutoButtonColor = false
        labBtn.Position = UDim2.fromOffset(10, 0); labBtn.Size = UDim2.new(1, -100, 1, 0)
        labBtn.Font = Enum.Font.Gotham; labBtn.TextSize = 14
        labBtn.TextXAlignment = Enum.TextXAlignment.Left
        labBtn.TextColor3 = Color3.fromRGB(30, 30, 30); labBtn.Text = labelText
        labBtn.ZIndex = 123; labBtn.Parent = row

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.fromOffset(80, 24)
        btn.Position = UDim2.new(1, -90, 0.5, -12)
        btn.BackgroundColor3 = Color3.fromRGB(20, 160, 140)
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.TextSize = 14
        btn.Font = Enum.Font.GothamBold
        btn.Text = "执行"
        btn.ZIndex = 123
        btn.Parent = row
        local bcorner = Instance.new("UICorner"); bcorner.CornerRadius = UDim.new(0, 6); bcorner.Parent = btn

        local function fire()
            if callback then
                local ok, err = pcall(callback)
                if not ok then warn("[UI Button error]", err) end
            end
        end
        btn.MouseButton1Click:Connect(fire)
        labBtn.MouseButton1Click:Connect(fire)
    end

    -- public API adapter
    local UILike = {}
    function UILike:NewWindow(titleText)
        title.Text = titleText or "窗口"
        local windowObj = {}
        function windowObj:NewSection(name)
            addSectionHeader(name)
            local sectionObj = {}
            function sectionObj:CreateToggle(label, callback)
                makeToggleRow(label, callback)
            end
            function sectionObj:CreateButton(label, callback)
                makeButtonRow(label, callback)
            end
            return sectionObj
        end
        return windowObj
    end
    return function() return UILike end
end
-- === End Floating Window UILib ===

local UILib = __MakeFloatingUILib()

local UI = UILib()
local window = UI:NewWindow("吃吃世界")
local main = window:NewSection("自动")
local upgrades = window:NewSection("升级")
local figure = window:NewSection("人物")
local others = window:NewSection("其它")

local function getRoot()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end

local function randomTp(character)
    local pos = workspace.Map.Bedrock.Position + Vector3.new(mat...space.Map.Bedrock.Size.X / 2, workspace.Map.Bedrock.Size.X / 2))
    character:MoveTo(pos)
    character:PivotTo(CFrame.new(character:GetPivot().Position, workspace.Map.Bedrock.Position))
end

local function changeMap()
    local args = {
        {
            ["MapTime"] = -1,
            ["Paused"] = true
        }
    }
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

local function sizeGrowth(level)
    return math.floor(((level + 0.5) ^ 2 - 0.25) / 2 * 100)
end

local function speedGrowth(level)
    return math.floor(level * 2 + 10)
end

local function multiplierGrowth(level)
    return math.floor(level)
end

local function eatSpeedGrowth(level)
    return math.floor((1 + (level - 1) * 0.2) * 10) / 10
end

local function sizePrice(level)
    return math.floor(level ^ 3 / 2) * 20
end

local function speedPrice(level)
    return math.floor((level * 3) ^ 3 / 200) * 1000
end

local function multiplierPrice(level)
    return math.floor((level * 10) ^ 3 / 200) * 1000
end

local function eatSpeedPrice(level)
    return math.floor((level * 10) ^ 3 / 200) * 2000
end

local function teleportPos()
    LocalPlayer.Character:PivotTo(CFrame.new(0,LocalPlayer.Character.Humanoid.HipHeight * 2,-100) * CFrame.Angles(0, math.rad(-90), 0))
end

main:CreateToggle("自动刷", function(enabled)
    autofarm = enabled
    if not enabled then
        return
    end
    coroutine.wrap(function()
        local Drawing = Drawing or {}
        local text = Drawing.new and Drawing.new("Text") or { }
        if Drawing.new then
            text.Outline = true
            text.OutlineColor = Color3.new(0, 0, 0)
            text.Color = Color3.new(1, 1, 1)
            text.Center = false
            text.Position = Vector2.new(64, 64)
            text.Text = ""
            text.Size = 14
            text.Visible = true
        end

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
        if map and chunks then
            map.Parent, chunks.Parent = nil, nil
        end

        local numChunks = 0
        
        local hum,
            root,
            size,
            events,
            eat,
            grab,
            sell,
            sendTrack,
            chunk,
            radius,
            autoConn,
        

        function onCharAdd(char)
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
                    if autoConn then
                        autoConn:Disconnect()
                    end
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

                if text and text.Text ~= nil then
                    text.Text = ""
                        .. "\n运行时间: " .. string.format("%ih%im%is", hours, minutes % 60, seconds % 60)
                        .. "\n实际时间: " .. string.format("%im%is", eatMinutes % 60, eatSeconds % 60)
                        .. "\n大约时间: " .. string.format("%im%is", sellMinutes % 60, sellSeconds % 60)
                        .. "\n每天: " .. dayEarn
                        .. "\n块数: " .. numChunks
                end

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
                if autoConn then
                    autoConn:Disconnect()
                end
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
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
        bedrock:Destroy()
        if LocalPlayer.Character then
            LocalPlayer.Character.LocalChunkManager.Enabled = true
            LocalPlayer.Character.Animate.Enabled = true
        end
        if text and text.Visible ~= nil then
            text:Destroy()
        end
    end)()
end)

main:CreateToggle("自动收", function(enabled)
    autoCollectingCubes = enabled
    if not enabled then
        return
    end
    coroutine.wrap(function()
        local saved = LocalPlayer.PlayerScripts:FindFirstChild("CubeVis")
        if saved then
            saved.Enabled = false
        end

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
        if saved then
            saved.Enabled = true
        end
    end)()
end)

main:CreateToggle("自动领", function(enabled)
    autoClaimRewards = enabled
    if not enabled then
        return
    end
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
end)

main:CreateToggle("移动模式", function(enabled)
    farmMoving = enabled
end)

main:CreateToggle("显示地图", function(enabled)
    showMap = enabled
end)

main:CreateToggle("自动吃", function(enabled)
    autoeat = enabled
    if not enabled then
        return
    end
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

upgrades:CreateToggle("大小", function(enabled)
    autoUpgradeSize = enabled
    if not enabled then
        return
    end
    coroutine.wrap(function()
        game.CoreGui.PurchasePromptApp.Enabled = false
        while autoUpgradeSize do
            task.wait(1)
            Events.PurchaseEvent:FireServer("MaxSize")
        end
        game.CoreGui.PurchasePromptApp.Enabled = true
    end)()
end)

upgrades:CreateToggle("移速", function(enabled)
    autoUpgradeSpd = enabled
    if not enabled then
        return
    end
    coroutine.wrap(function()
        game.CoreGui.PurchasePromptApp.Enabled = false
        while autoUpgradeSpd do
            task.wait(1)
            Events.PurchaseEvent:FireServer("Speed")
        end
        game.CoreGui.PurchasePromptApp.Enabled = true
    end)()
end)

upgrades:CreateToggle("乘数", function(enabled)
    autoUpgradeMulti = enabled
    if not enabled then
        return
    end
    coroutine.wrap(function()
        game.CoreGui.PurchasePromptApp.Enabled = false
        while autoUpgradeMulti do
            task.wait(1)
            Events.PurchaseEvent:FireServer("Multiplier")
        end
        game.CoreGui.PurchasePromptApp.Enabled = true
    end)()
end)

upgrades:CreateToggle("吃速", function(enabled)
    autoUpgradeEat = enabled
    if not enabled then
        return
    end
    coroutine.wrap(function()
        game.CoreGui.PurchasePromptApp.Enabled = false
        while autoUpgradeEat do
            task.wait(1)
            Events.PurchaseEvent:FireServer("EatSpeed")
        end
        game.CoreGui.PurchasePromptApp.Enabled = true
    end)()
end)

figure:CreateToggle("取消锚固", function(enabled)
    keepUnanchor = enabled
    if not enabled then
        return
    end
    coroutine.wrap(function()
        while keepUnanchor do
            task.wait()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.Anchored = false
            end
        end
    end)()
end)

figure:CreateToggle("边界保护", function(enabled)
    boundProtect = enabled
    if not enabled then
        return
    end
    coroutine.wrap(function()
        while boundProtect do
            task.wait()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local root = LocalPlayer.Character.HumanoidRootPart
                local pos = root.Position
                local mapSize = workspace.Map.Bedrock.Size * Vector3.new(1, 0, 1)
                -- clamp
                local function clamp(v, minV, maxV)
                    local x = math.max(minV.X, math.min(maxV.X, v.X))
                    local z = math.max(minV.Z, math.min(maxV.Z, v.Z))
                    return Vector3.new(x, 0, z)
                end
                local clampedPos = clamp(pos * Vector3.new(1,0,1), -mapSize / 2, mapSize / 2)
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(clampedPos.X, pos.Y, clampedPos.Z) * root.CFrame.Rotation
            end
        end
    end)()
end)

others:CreateButton("查看玩家数据", function()
    print("[ViewPlayerData] 执行")
end)

others:CreateToggle("竖屏", function(enabled)
    LocalPlayer.PlayerGui.ScreenOrientation = enabled and Enum.ScreenOrientation.Portrait or Enum.ScreenOrientation.LandscapeRight
end)
