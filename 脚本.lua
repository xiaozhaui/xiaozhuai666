local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Events = ReplicatedStorage:WaitForChild("Events")
local LocalPlayer = Players.LocalPlayer

local UILib = getgenv().UILibCache or loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wizard"))
getgenv().UILibCache = UILib

local UI = UILib()
local window = UI:NewWindow("吃吃世界")
local main = window:NewSection("自动")
local upgrades = window:NewSection("升级")
local figure = window:NewSection("人物")
local glowSection = window:NewSection("发光效果") -- 新增发光效果区域
local others = window:NewSection("其它")

local function getRoot()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end

local function randomTp(character)
    local pos = workspace.Map.Bedrock.Position + Vector3.new(math.random(-workspace.Map.Bedrock.Size.X / 2, workspace.Map.Bedrock.Size.X / 2), 0, math.random(-workspace.Map.Bedrock.Size.X / 2, workspace.Map.Bedrock.Size.X / 2))
    character:MoveTo(pos)
    character:PivotTo(CFrame.new(character:GetPivot().Position, workspace.Map.Bedrock.Position))
end

local function changeMap()
    local args = {
    	{
    		MapTime = -1,
    		Paused = true
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
    LocalPlayer.Character:PivotTo(CFrame.new(0, LocalPlayer.Character.Humanoid.HipHeight * 2, -100) * CFrame.Angles(0, math.rad(-90), 0))
end

-- 添加发光效果开关
glowSection:CreateToggle("全身发光", function(enabled)
    if enabled then
        -- 开启发光效果
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        wait(1) -- 等待角色完全加载
        
        -- 存储原始属性的表
        local originalProperties = {}
        
        -- 处理身体部件
        local function processParts(obj)
            if obj:IsA("BasePart") then
                if obj.Parent and obj.Parent:IsA("Tool") then return end -- 跳过工具中的部件
                
                -- 保存原始属性
                originalProperties[obj] = {
                    Material = obj.Material,
                    Color = obj.Color,
                    Reflectance = obj.Reflectance
                }
                
                -- 设置发光材质
                obj.Material = Enum.Material.Neon
                obj.Reflectance = 0.4
            end
        end
        
        -- 处理配件（头发、帽子等）
        local function processAccessories(obj)
            if obj:IsA("Accessory") then
                local handle = obj:FindFirstChild("Handle")
                if handle then
                    originalProperties[handle] = {
                        Material = handle.Material,
                        Color = handle.Color,
                        Reflectance = handle.Reflectance
                    }
                    
                    handle.Material = Enum.Material.Neon
                    handle.Reflectance = 0.4
                end
            end
        end
        
        -- 递归处理所有对象
        local function processAll(obj)
            processParts(obj)
            processAccessories(obj)
            
            for _, child in pairs(obj:GetChildren()) do
                processAll(child)
            end
        end
        
        -- 处理现有对象
        processAll(character)
        
        -- 监听新添加的对象
        local childAddedConnection = character.ChildAdded:Connect(function(child)
            processAll(child)
        end)
        
        -- 颜色动画
        local time = 0
        local colorAnimConnection = RunService.Heartbeat:Connect(function(dt)
            time = time + dt * 2
            
            local r = 0.5 + 0.5 * math.sin(time)
            local g = 0.5 + 0.5 * math.sin(time + 2.1)
            local b = 0.5 + 0.5 * math.sin(time + 4.2)
            
            local color = Color3.new(r, g, b)
            
            -- 应用颜色到所有已处理的部件
            for part, _ in pairs(originalProperties) do
                if part and part.Parent then
                    part.Color = color
                end
            end
        end)
        
        -- 保存连接以便关闭时清理
        character.GlowConnections = {
            childAddedConnection = childAddedConnection,
            colorAnimConnection = colorAnimConnection
        }
        character.OriginalProperties = originalProperties
    else
        -- 关闭发光效果
        local character = LocalPlayer.Character
        if character and character.OriginalProperties then
            -- 恢复原始属性
            for part, original in pairs(character.OriginalProperties) do
                if part and part.Parent then
                    part.Material = original.Material
                    part.Color = original.Color
                    part.Reflectance = original.Reflectance
                end
            end
            
            -- 断开连接
            if character.GlowConnections then
                if character.GlowConnections.childAddedConnection then
                    character.GlowConnections.childAddedConnection:Disconnect()
                end
                if character.GlowConnections.colorAnimConnection then
                    character.GlowConnections.colorAnimConnection:Disconnect()
                end
            end
            
            -- 清除保存的数据
            character.GlowConnections = nil
            character.OriginalProperties = nil
        end
    end
end)

-- 添加固定颜色发光选项
glowSection:CreateDropdown("发光颜色", {"红色", "绿色", "蓝色", "黄色", "紫色", "青色", "白色"}, function(selectedColor)
    -- 这里可以添加固定颜色发光的逻辑
    -- 为了简洁，这里只是占位符
end)

-- 添加发光强度选项
glowSection:CreateSlider("发光强度", 0, 1, 0.5, function(value)
    -- 这里可以添加调整发光强度的逻辑
    -- 为了简洁，这里只是占位符
end)

main:CreateToggle("自动刷", function(enabled)
    autofarm = enabled
    
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
            sizeConn
        
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
                    autoConn:Disconnect()
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
                
                if (size.Value >= LocalPlayer.Upgrades.MaxSize.Value)
                    or timer > 8
                then
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
                    -- root.CFrame = CFrame.new(x, y, z) * CFrame.Angles(0, math.atan2(x, z) + math.pi, 0)
                else
                    root.CFrame = CFrame.new(0, y, 0)
                end
            end)
            
            hum.Died:Connect(function()
                autoConn:Disconnect()
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
            if map and chunks then
                if showMap then
                    map.Parent, chunks.Parent = workspace, workspace
                else
                    map.Parent, chunks.Parent = nil, nil
                end
            end
        end
        charAddConn:Disconnect()
        if autoConn then
            autoConn:Disconnect()
        end
        if map and chunks then
            map.Parent, chunks.Parent = workspace, workspace
        end
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        bedrock:Destroy()
        LocalPlayer.Character.LocalChunkManager.Enabled = true
        LocalPlayer.Character.Animate.Enabled = true
        text:Destroy()
    end)()
end)

main:CreateToggle("自动收", function(enabled)
    autoCollectingCubes = enabled
    
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

main:CreateToggle("自动领", function(enabled)
    autoClaimRewards = enabled
    
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
    
    coroutine.wrap(function()
        while boundProtect do
            task.wait()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local root = LocalPlayer.Character.HumanoidRootPart
                local pos = root.Position
                local mapSize = workspace.Map.Bedrock.Size * Vector3.new(1, 0, 1)
                local clampedPos = vector.clamp(pos * Vector3.new(1, 0, 1), -mapSize / 2, mapSize / 2)
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(clampedPos.X, pos.Y, clampedPos.Z) * root.CFrame.Rotation
            end
        end
    end)()
end)

others:CreateButton("查看玩家数据", function()
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
            local content = player.Name .. "："
            
            local cost = 0
            for l = 2, upg.Value do
                cost += priceFunctions[upg.Name](l)
            end
            
            content = content .. " " .. `{localization[upg.Name]}：`
            content = content .. " " .. `{upg.Value}级；`
            content = content .. " " .. `{growthFunctions[upg.Name](upg.Value)}值；`
            content = content .. " " .. `{cost}花费；`
            
            print(content)
        end
    end
    
    game.StarterGui:SetCore("DevConsoleVisible", true)
end)

-- 添加一个清除所有效果的按钮
others:CreateButton("清除所有效果", function()
    -- 清除发光效果
    local character = LocalPlayer.Character
    if character and character.OriginalProperties then
        for part, original in pairs(character.OriginalProperties) do
            if part and part.Parent then
                part.Material = original.Material
                part.Color = original.Color
                part.Reflectance = original.Reflectance
            end
        end
        
        if character.GlowConnections then
            if character.GlowConnections.childAddedConnection then
                character.GlowConnections.childAddedConnection:Disconnect()
            end
            if character.GlowConnections.colorAnimConnection then
                character.GlowConnections.colorAnimConnection:Disconnect()
            end
        end
        
        character.GlowConnections = nil
        character.OriginalProperties = nil
    end
    
    -- 清除其他可能的效果
    if LocalPlayer.Character then
        LocalPlayer.Character.HumanoidRootPart.Anchored = false
    end
end)

others:CreateToggle("竖屏", function(enabled)
    LocalPlayer.PlayerGui.ScreenOrientation = enabled and Enum.ScreenOrientation.Portrait or Enum.ScreenOrientation.LandscapeRight
end)