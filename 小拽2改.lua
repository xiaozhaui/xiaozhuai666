-- Roblox Lua GUI 脚本：完整功能整合 + 中文名称 + 分组下拉菜单
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Events = ReplicatedStorage:WaitForChild("Events")

local gui = Instance.new("ScreenGui")
gui.Name = "RainbowFloatingUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local pill = Instance.new("TextButton")
pill.Name = "ToggleButton"
pill.Text = "小拽吃吃世界"
pill.TextColor3 = Color3.new(1, 1, 1)
pill.TextSize = 18
pill.Font = Enum.Font.SourceSansBold
pill.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
pill.AutoButtonColor = false
pill.BorderSizePixel = 3
pill.Size = UDim2.new(0, 160, 0, 40)
pill.Position = UDim2.new(0, 50, 0, 100)
pill.Parent = gui

local pillCorner = Instance.new("UICorner")
pillCorner.CornerRadius = UDim.new(1, 0)
pillCorner.Parent = pill

local minimize = Instance.new("TextButton")
minimize.Name = "MinimizeButton"
minimize.Text = "-"
minimize.TextColor3 = Color3.new(1, 1, 1)
minimize.TextSize = 22
minimize.Font = Enum.Font.SourceSansBold
minimize.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
minimize.Size = UDim2.new(0, 40, 0, 40)
minimize.Position = UDim2.new(0, 218, 0, 100)
minimize.BorderSizePixel = 3
minimize.Parent = gui

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(1, 0)
minCorner.Parent = minimize

-- 彩虹边框
local hue = 0
RunService.RenderStepped:Connect(function()
    hue = (hue + 1) % 360
    local color = Color3.fromHSV(hue / 360, 1, 1)
    pill.BorderColor3 = color
    minimize.BorderColor3 = color
end)

-- 创建下拉菜单容器
local function createDropdown(name, yPos)
    local frame = Instance.new("Frame")
    frame.Name = name
    frame.Size = UDim2.new(0, 160, 0, 0)
    frame.Position = UDim2.new(0, 50, 0, yPos)
    frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    frame.ClipsDescendants = true
    frame.Visible = false
    frame.Parent = gui

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 4)
    layout.Parent = frame

    return frame
end

-- 分类下拉菜单
local dropdowns = {
    自动 = createDropdown("自动", 140),
    升级 = createDropdown("升级", 270),
    人物 = createDropdown("人物", 400),
    其它 = createDropdown("其它", 530),
}

-- 占位功能（演示用）
local function placeholder(name)
    return function()
        print("功能 [" .. name .. "] 已触发（请接入真实逻辑）")
    end
end

-- 功能映射（按钮名 → 功能函数）
local featureMap = {
    ["自动吃"] = placeholder("自动吃"),
    ["自动刷"] = placeholder("自动刷"),
    ["自动收"] = placeholder("自动收"),
    ["自动领"] = placeholder("自动领"),
    ["移动模式"] = placeholder("移动模式"),
    ["显示地图"] = placeholder("显示地图"),
    ["大小"] = placeholder("升级体积"),
    ["移速"] = placeholder("升级速度"),
    ["乘数"] = placeholder("升级乘数"),
    ["吃速"] = placeholder("升级吃速"),
    ["取消锚固"] = placeholder("取消锚固"),
    ["边界保护"] = placeholder("边界保护"),
    ["查看玩家数据"] = placeholder("查看玩家数据"),
    ["竖屏"] = placeholder("竖屏切换"),
}

-- 分类映射（按钮名 → 对应下拉区域）
local sectionMap = {
    ["自动吃"] = "自动", ["自动刷"] = "自动", ["自动收"] = "自动", ["自动领"] = "自动",
    ["移动模式"] = "自动", ["显示地图"] = "自动",
    ["大小"] = "升级", ["移速"] = "升级", ["乘数"] = "升级", ["吃速"] = "升级",
    ["取消锚固"] = "人物", ["边界保护"] = "人物",
    ["查看玩家数据"] = "其它", ["竖屏"] = "其它",
}

-- 添加按钮到界面
local index = 0
for name, func in pairs(featureMap) do
    index += 1
    local btn = Instance.new("TextButton")
    btn.Name = "Button" .. index
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 16
    btn.Font = Enum.Font.SourceSans
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    btn.Size = UDim2.new(1, -8, 0, 36)
    btn.BorderSizePixel = 3
    btn.Parent = dropdowns[sectionMap[name]]

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.2, 0)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(func)
end

-- 展开 / 收起菜单逻辑
local expanded = false
pill.MouseButton1Click:Connect(function()
    expanded = not expanded
    for _, frame in pairs(dropdowns) do
        frame.Visible = true
        local count = #frame:GetChildren() - 1 -- 减去 UIListLayout
        local sizeY = expanded and (count * 36 + (count - 1) * 4) or 0
        frame:TweenSize(UDim2.new(0, 160, 0, sizeY), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
    end
end)

minimize.MouseButton1Click:Connect(function()
    gui.Enabled = false
end)
