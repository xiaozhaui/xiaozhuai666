local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage:WaitForChild("Events")
local LocalPlayer = Players.LocalPlayer

-- 替换为更美观的Sirus UI库（核心样式改造点）
local UILib = getgenv().SirusLibCache or loadstring(game:HttpGet("https://raw.githubusercontent.com/SirusCodes/Sirus-UI-Library/main/source"))()
getgenv().SirusLibCache = UILib

-- 定制悬浮窗主样式（渐变背景+圆角+阴影）
local window = UILib:CreateWindow({
    Name = "吃吃世界",
    Title = "吃吃世界辅助",
    Theme = UILib.Themes.Gradient({ -- 渐变主题（蓝紫渐变）
        Primary = Color3.fromRGB(103, 58, 183),
        Secondary = Color3.fromRGB(63, 81, 181),
        Accent = Color3.fromRGB(255, 235, 59),
    }),
    Size = UDim2.new(0, 420, 0, 550), -- 悬浮窗尺寸
    Position = UDim2.new(0.5, -210, 0.5, -275), -- 居中显示
    Resizable = true, -- 允许拖动缩放
    ShowCustomization = true -- 开放样式自定义面板
})

-- 保留原功能分区（仅改UI创建语法，逻辑不变）
local main = window:AddPage("自动功能", "rbxassetid://12873528730") -- 加图标更美观
local upgrades = window:AddPage("属性升级", "rbxassetid://12873530609")
local figure = window:AddPage("人物控制", "rbxassetid://12873532214")
local others = window:AddPage("其他工具", "rbxassetid://12873533578")

-- 工具函数（原功能，完全保留）
local function getRoot()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end
local function randomTp(character)
    local pos = workspace.Map.Bedrock.Position + Vector3.new(math.random(-workspace.Map.Bedrock.Size.X / 2, workspace.Map.Bedrock.Size.X / 2), 0, math.random(-workspace.Map.Bedrock.Size.X / 2, workspace.Map.Bedrock.Size.X / 2))
    character:MoveTo(pos)
    character:PivotTo(CFrame.new(character:GetPivot().Position, workspace.Map.Bedrock.Position))
end
local function changeMap()
    local args = {{MapTime = -1, Paused = true}}
    Events.SetServerSettings:FireServer(unpack(args))
end
local function checkLoaded()
    return (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character:FindFirstChild("Size") and LocalPlayer.Character:FindFirstChild("Events") and LocalPlayer.Character.Events:FindFirstChild("Grab") and LocalPlayer.Character.Events:FindFirstChild("Eat") and LocalPlayer.Character.Events:FindFirstChild("Sell") and LocalPlayer.Character:FindFirstChild("CurrentChunk")) ~= nil
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

-- 核心功能（原逻辑完全保留，仅改UI控件创建语法）
-- 自动刷功能
main:AddToggle({
    Name = "自动刷资源",
    Default = false,
    Callback = function(enabled)
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
            bedrock.BrickColor = BrickColor.Black()
            bedrock.Parent = workspace
            local map, chunks = workspace:FindFirstChild("Map"), workspace:FindFirstChild("Chunks")
            if map and chunks then
                map.Parent, chunks.Parent = nil, nil
            end
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
                sell = events:WaitForCh