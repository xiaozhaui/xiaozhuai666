-- 创建主屏幕 GUI
local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

-- 创建浮动窗口（黑色背景，椭圆形）
local floatingWindow = Instance.new("Frame")
floatingWindow.Size = UDim2.new(0, 300, 0, 50)
floatingWindow.Position = UDim2.new(0.5, -150, 0.2, 0) -- 居中，略微下方
floatingWindow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
floatingWindow.AnchorPoint = Vector2.new(0.5, 0.5)
floatingWindow.Parent = screenGui

-- 创建名字标签（居中显示在浮动窗口内）
local nameLabel = Instance.new("TextLabel")
nameLabel.Text = "小拽吃吃世界二改"
nameLabel.Size = UDim2.new(1, 0, 1, 0)
nameLabel.BackgroundTransparency = 1
nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
nameLabel.TextSize = 20
nameLabel.TextAlign = Enum.TextAlign.Center
nameLabel.Parent = floatingWindow

-- 创建折叠/展开按钮（带减号的圆形按钮）
local collapseButton = Instance.new("TextButton")
collapseButton.Size = UDim2.new(0, 30, 0, 30)
collapseButton.Position = UDim2.new(1, -35, 0.5, -15)  -- 定位在名字的右侧
collapseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
collapseButton.Text = "-"
collapseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
collapseButton.TextSize = 20
collapseButton.TextAlign = Enum.TextAlign.Center
collapseButton.Parent = floatingWindow

-- 创建展开的内容区域
local expandSection = Instance.new("Frame")
expandSection.Size = UDim2.new(0, 300, 0, 0)
expandSection.Position = UDim2.new(0.5, -150, 0.4, 0)
expandSection.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
expandSection.Visible = false
expandSection.Parent = screenGui

-- 创建展开区域中的按钮（用于各项功能）
local autoFarmButton = Instance.new("TextButton")
autoFarmButton.Size = UDim2.new(1, 0, 0, 40)
autoFarmButton.Position = UDim2.new(0, 0, 0, 0)
autoFarmButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
autoFarmButton.Text = "自动刷"
autoFarmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
autoFarmButton.TextSize = 18
autoFarmButton.Parent = expandSection

local autoCollectButton = Instance.new("TextButton")
autoCollectButton.Size = UDim2.new(1, 0, 0, 40)
autoCollectButton.Position = UDim2.new(0, 0, 0, 40)
autoCollectButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
autoCollectButton.Text = "自动收集"
autoCollectButton.TextColor3 = Color3.fromRGB(255, 255, 255)
autoCollectButton.TextSize = 18
autoCollectButton.Parent = expandSection

local autoUpgradeButton = Instance.new("TextButton")
autoUpgradeButton.Size = UDim2.new(1, 0, 0, 40)
autoUpgradeButton.Position = UDim2.new(0, 0, 0, 80)
autoUpgradeButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
autoUpgradeButton.Text = "自动升级"
autoUpgradeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
autoUpgradeButton.TextSize = 18
autoUpgradeButton.Parent = expandSection

local keepUnanchorButton = Instance.new("TextButton")
keepUnanchorButton.Size = UDim2.new(1, 0, 0, 40)
keepUnanchorButton.Position = UDim2.new(0, 0, 0, 120)
keepUnanchorButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
keepUnanchorButton.Text = "取消锚固"
keepUnanchorButton.TextColor3 = Color3.fromRGB(255, 255, 255)
keepUnanchorButton.TextSize = 18
keepUnanchorButton.Parent = expandSection

local boundProtectButton = Instance.new("TextButton")
boundProtectButton.Size = UDim2.new(1, 0, 0, 40)
boundProtectButton.Position = UDim2.new(0, 0, 0, 160)
boundProtectButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
boundProtectButton.Text = "边界保护"
boundProtectButton.TextColor3 = Color3.fromRGB(255, 255, 255)
boundProtectButton.TextSize = 18
boundProtectButton.Parent = expandSection

-- 添加折叠/展开按钮功能
local isExpanded = false
collapseButton.MouseButton1Click:Connect(function()
    isExpanded = not isExpanded
    if isExpanded then
        expandSection.Visible = true
        -- 展开区域动画（逐渐增加高度）
        for i = 0, 100, 10 do
            wait(0.05)
            expandSection.Size = UDim2.new(0, 300, 0, i)
        end
    else
        -- 折叠区域动画（逐渐减少高度）
        for i = 100, 0, -10 do
            wait(0.05)
            expandSection.Size = UDim2.new(0, 300, 0, i)
        end
        expandSection.Visible = false
    end
end)

-- 自动刷功能
autoFarmButton.MouseButton1Click:Connect(function()
    -- 启用自动刷逻辑（您之前提供的代码中有相应功能）
    print("自动刷功能已开启")
    -- 可以在此调用您脚本中的具体自动刷逻辑
end)

-- 自动收集功能
autoCollectButton.MouseButton1Click:Connect(function()
    -- 启用自动收集逻辑（您之前提供的代码中有相应功能）
    print("自动收集功能已开启")
    -- 可以在此调用您脚本中的具体收集逻辑
end)

-- 自动升级功能
autoUpgradeButton.MouseButton1Click:Connect(function()
    -- 启用自动升级逻辑（您之前提供的代码中有相应功能）
    print("自动升级功能已开启")
    -- 可以在此调用您脚本中的具体自动升级逻辑
end)

-- 取消锚固功能
keepUnanchorButton.MouseButton1Click:Connect(function()
    -- 启用取消锚固逻辑（您之前提供的代码中有相应功能）
    print("取消锚固已开启")
    -- 可以在此调用您脚本中的具体取消锚定逻辑
end)

-- 边界保护功能
boundProtectButton.MouseButton1Click:Connect(function()
    -- 启用边界保护逻辑（您之前提供的代码中有相应功能）
    print("边界保护已开启")
    -- 可以在此调用您脚本中的具体边界保护逻辑
end)

-- 其他功能（比如查看玩家数据等）可以按需求添加
