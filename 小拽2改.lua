-- 仅保留2个必需服务（无多余）
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 5)

-- 清理旧UI（容错）
pcall(function() PlayerGui:FindFirstChild("TestWindow"):Destroy() end)

-- 主GUI（极简配置）
local gui = Instance.new("ScreenGui")
gui.Name = "TestWindow"
gui.DisplayOrder = 999999
gui.IgnoreGuiInset = true
gui.Parent = PlayerGui

-- 测试按钮（大尺寸，确保可见）
local testBtn = Instance.new("TextButton")
testBtn.Size = UDim2.new(0, 200, 0, 50)
testBtn.Position = UDim2.new(0.5, -100, 0.5, -25) -- 屏幕正中央
testBtn.BackgroundColor3 = Color3.new(1, 0, 0) -- 红色醒目
testBtn.Text = "点击测试"
testBtn.TextColor3 = Color3.new(1, 1, 1)
testBtn.TextSize = 20
testBtn.ZIndex = 10
testBtn.Parent = gui
Instance.new("UICorner", testBtn).CornerRadius = UDim.new(0.2, 0)

-- 点击事件（仅打印，无复杂逻辑）
local clickCount = 0
testBtn.MouseButton1Click:Connect(function()
    clickCount += 1
    testBtn.Text = "已点击 "..clickCount.." 次"
    testBtn.BackgroundColor3 = Color3.new(0, 1, 0) -- 变绿色
    task.wait(0.2)
    testBtn.BackgroundColor3 = Color3.new(1, 0, 0) -- 恢复红色
    print("按钮被点击，计数：", clickCount)
end)

-- 拖动功能（极简）
local isDragging = false
local startPos = Vector2.new(0, 0)

testBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        startPos = input.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - startPos
        testBtn.Position = UDim2.new(0, testBtn.Position.X.Offset + delta.X, 0, testBtn.Position.Y.Offset + delta.Y)
        startPos = input.Position
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        isDragging = false
    end
end)

-- 强制显示
gui.Enabled = true
testBtn.Visible = true

print("=== 测试脚本加载完成 ===")
print("如果看到红色按钮，说明注入成功")
print("点击按钮会变绿色并计数")
