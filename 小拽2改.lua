-- 吃吃世界正式版：手机注入器兼容，保留功能名称
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Events = ReplicatedStorage:WaitForChild("Events")

local UILib = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wizard"))()
local win = UILib:NewWindow("吃吃世界")

-- 自动功能区域
local auto = win:NewSection("自动")

auto:CreateToggle("自动吃", function(v)
    autoeat = v
    coroutine.wrap(function()
        while autoeat do
            task.wait()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Events") then
                local events = LocalPlayer.Character.Events
                if events:FindFirstChild("Grab") then events.Grab:FireServer() end
                if events:FindFirstChild("Eat") then events.Eat:FireServer() end
            end
        end
    end)()
end)

auto:CreateToggle("自动刷", function(v)
    autofarm = v
    print("已启用自动刷，请接入完整版逻辑")
end)

auto:CreateToggle("自动收", function(v)
    autoCollect = v
    coroutine.wrap(function()
        while autoCollect do
            task.wait()
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                for _, v in pairs(workspace:GetChildren()) do
                    if v.Name == "Cube" and v:FindFirstChild("Owner") and (v.Owner.Value == LocalPlayer.Name or v.Owner.Value == "") then
                        v.CFrame = root.CFrame
                    end
                end
            end
        end
    end)()
end)

auto:CreateToggle("自动领", function(v)
    autoClaim = v
    coroutine.wrap(function()
        while autoClaim do
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

auto:CreateToggle("移动模式", function(v)
    farmMoving = v
end)

auto:CreateToggle("显示地图", function(v)
    showMap = v
end)

-- 升级功能区域
local upgrades = win:NewSection("升级")

upgrades:CreateToggle("大小", function(v)
    coroutine.wrap(function()
        while v do
            task.wait(1)
            Events.PurchaseEvent:FireServer("MaxSize")
        end
    end)()
end)

upgrades:CreateToggle("移速", function(v)
    coroutine.wrap(function()
        while v do
            task.wait(1)
            Events.PurchaseEvent:FireServer("Speed")
        end
    end)()
end)

upgrades:CreateToggle("乘数", function(v)
    coroutine.wrap(function()
        while v do
            task.wait(1)
            Events.PurchaseEvent:FireServer("Multiplier")
        end
    end)()
end)

upgrades:CreateToggle("吃速", function(v)
    coroutine.wrap(function()
        while v do
            task.wait(1)
            Events.PurchaseEvent:FireServer("EatSpeed")
        end
    end)()
end)

-- 人物功能区域
local figure = win:NewSection("人物")

figure:CreateToggle("取消锚固", function(v)
    coroutine.wrap(function()
        while v do
            task.wait()
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                root.Anchored = false
            end
        end
    end)()
end)

figure:CreateToggle("边界保护", function(v)
    coroutine.wrap(function()
        while v do
            task.wait()
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root and workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Bedrock") then
                local size = workspace.Map.Bedrock.Size * Vector3.new(1, 0, 1)
                local pos = root.Position
                local clamped = Vector3.new(
                    math.clamp(pos.X, -size.X/2, size.X/2),
                    pos.Y,
                    math.clamp(pos.Z, -size.Z/2, size.Z/2)
                )
                root.CFrame = CFrame.new(clamped)
            end
        end
    end)()
end)

-- 其它功能区域
local others = win:NewSection("其它")

others:CreateButton("查看玩家数据", function()
    print("查看玩家数据：")
    for _, player in pairs(Players:GetPlayers()) do
        for _, upg in pairs(player:WaitForChild("Upgrades"):GetChildren()) do
            print(player.Name, upg.Name, upg.Value)
        end
    end
end)

others:CreateToggle("竖屏", function(v)
    LocalPlayer.PlayerGui.ScreenOrientation = v and Enum.ScreenOrientation.Portrait or Enum.ScreenOrientation.LandscapeRight
end)
