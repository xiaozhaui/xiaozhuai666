-- 吃吃世界：手机注入器适配版，使用 Wizard UI，保留原始功能名称
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Events = ReplicatedStorage:WaitForChild("Events")

local UILib = getgenv().UILibCache or loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wizard"))()
getgenv().UILibCache = UILib

local win = UILib:NewWindow("吃吃世界")

-- 自动区
local auto = win:NewSection("自动")

auto:CreateToggle("自动吃", function(enabled)
    autoeat = enabled
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

auto:CreateToggle("自动刷", function(enabled)
    autofarm = enabled
    print("自动刷逻辑已启用（请接入完整版脚本）")
end)

auto:CreateToggle("自动收", function(enabled)
    autoCollect = enabled
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

auto:CreateToggle("自动领", function(enabled)
    autoClaim = enabled
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

auto:CreateToggle("移动模式", function(enabled)
    farmMoving = enabled
end)

auto:CreateToggle("显示地图", function(enabled)
    showMap = enabled
end)

-- 升级区
local upgrades = win:NewSection("升级")

upgrades:CreateToggle("大小", function(enabled)
    if enabled then
        coroutine.wrap(function()
            while enabled do
                task.wait(1)
                Events.PurchaseEvent:FireServer("MaxSize")
            end
        end)()
    end
end)

upgrades:CreateToggle("移速", function(enabled)
    if enabled then
        coroutine.wrap(function()
            while enabled do
                task.wait(1)
                Events.PurchaseEvent:FireServer("Speed")
            end
        end)()
    end
end)

upgrades:CreateToggle("乘数", function(enabled)
    if enabled then
        coroutine.wrap(function()
            while enabled do
                task.wait(1)
                Events.PurchaseEvent:FireServer("Multiplier")
            end
        end)()
    end
end)

upgrades:CreateToggle("吃速", function(enabled)
    if enabled then
        coroutine.wrap(function()
            while enabled do
                task.wait(1)
                Events.PurchaseEvent:FireServer("EatSpeed")
            end
        end)()
    end
end)

-- 人物区
local figure = win:NewSection("人物")

figure:CreateToggle("取消锚固", function(enabled)
    coroutine.wrap(function()
        while enabled do
            task.wait()
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                root.Anchored = false
            end
        end
    end)()
end)

figure:CreateToggle("边界保护", function(enabled)
    coroutine.wrap(function()
        while enabled do
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

-- 其它区
local others = win:NewSection("其它")

others:CreateButton("查看玩家数据", function()
    print("查看玩家数据：")
    for _, player in pairs(Players:GetPlayers()) do
        for _, upg in pairs(player:WaitForChild("Upgrades"):GetChildren()) do
            print(player.Name, upg.Name, upg.Value)
        end
    end
end)

others:CreateToggle("竖屏", function(enabled)
    LocalPlayer.PlayerGui.ScreenOrientation = enabled and Enum.ScreenOrientation.Portrait or Enum.ScreenOrientation.LandscapeRight
end)
