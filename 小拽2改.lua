local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

if CoreGui:FindFirstChild("MobileFloatingWindow") then
	CoreGui.MobileFloatingWindow:Destroy()
end

local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "MobileFloatingWindow"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- 主窗口
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0, 60, 0, 60)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
frame.Name = "MainWindow"
frame.Parent = gui

-- 标题栏
local dragArea = Instance.new("TextButton")
dragArea.Size = UDim2.new(1, 0, 0, 30)
dragArea.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
dragArea.Text = "吃吃世界工具"
dragArea.TextColor3 = Color3.new(1, 1, 1)
dragArea.Font = Enum.Font.SourceSansBold
dragArea.TextSize = 18
dragArea.AutoButtonColor = false
dragArea.Parent = frame

-- 内容区
local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, 0, 1, -30)
contentArea.Position = UDim2.new(0, 0, 0, 30)
contentArea.BackgroundTransparency = 1
contentArea.Parent = frame

-- 示例按钮
local fakeButton = Instance.new("TextButton", contentArea)
fakeButton.Size = UDim2.new(0, 200, 0, 40)
fakeButton.Position = UDim2.new(0.5, -100, 0, 20)
fakeButton.Text = "自动吃（示例）"
fakeButton.Font = Enum.Font.SourceSans
fakeButton.TextSize = 18
fakeButton.BackgroundColor3 = Color3.fromRGB(60, 100, 180)
fakeButton.TextColor3 = Color3.new(1, 1, 1)

-- 缩放按钮
local resizeBtn = Instance.new("ImageButton")
resizeBtn.Size = UDim2.new(0, 24, 0, 24)
resizeBtn.Position = UDim2.new(1, -12, 1, -12)
resizeBtn.AnchorPoint = Vector2.new(1, 1)
resizeBtn.BackgroundTransparency = 1
resizeBtn.Image = "rbxassetid://3926305904"
resizeBtn.ImageRectOffset = Vector2.new(84, 284)
resizeBtn.ImageRectSize = Vector2.new(36, 36)
resizeBtn.Parent = frame

-- 最小化按钮
local miniBtn = Instance.new("TextButton")
miniBtn.Size = UDim2.new(0, 30, 0, 30)
miniBtn.Position = UDim2.new(1, -30, 0, 0)
miniBtn.Text = "-"
miniBtn.TextColor3 = Color3.new(1, 1, 1)
miniBtn.BackgroundTransparency = 1
miniBtn.Font = Enum.Font.SourceSansBold
miniBtn.TextSize = 18
miniBtn.Parent = dragArea

-- 🌈 最小化时显示的圆形按钮
local miniCircle = Instance.new("TextButton")
miniCircle.Size = UDim2.new(0, 60, 0, 60)
miniCircle.Position = UDim2.new(0, 100, 0, 100)
miniCircle.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
miniCircle.Text = "+"
miniCircle.TextSize = 32
miniCircle.TextColor3 = Color3.new(1,1,1)
miniCircle.BorderSizePixel = 3
miniCircle.Visible = false
miniCircle.Parent = gui

-- 圆角
local corner = Instance.new("UICorner", miniCircle)
corner.CornerRadius = UDim.new(1, 0)

-- 彩虹边框动画
local hue = 0
RunService.RenderStepped:Connect(function()
	if miniCircle.Visible then
		hue = (hue + 1) % 360
		miniCircle.BorderColor3 = Color3.fromHSV(hue / 360, 1, 1)
	end
end)

-- 拖动窗口
local dragging = false
local dragStart, startPos

dragArea.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
	end
end)

dragArea.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

UserInputService.TouchMoved:Connect(function(input)
	if dragging then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
end)

-- 拖动 miniCircle（圆形按钮）
local draggingMini = false
local miniStart, miniPos

miniCircle.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch then
		draggingMini = true
		miniStart = input.Position
		miniPos = miniCircle.Position
	end
end)

miniCircle.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch then
		draggingMini = false
	end
end)

UserInputService.TouchMoved:Connect(function(input)
	if draggingMini then
		local delta = input.Position - miniStart
		miniCircle.Position = UDim2.new(
			miniPos.X.Scale, miniPos.X.Offset + delta.X,
			miniPos.Y.Scale, miniPos.Y.Offset + delta.Y
		)
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
	if input.UserInputType == Enum.UserInputType.Touch then
		resizing = false
	end
end)

UserInputService.TouchMoved:Connect(function(input)
	if resizing then
		local delta = input.Position - resizeStartPos
		local newWidth = math.max(200, resizeStartSize.X.Offset + delta.X)
		local newHeight = math.max(100, resizeStartSize.Y.Offset + delta.Y)
		frame.Size = UDim2.new(0, newWidth, 0, newHeight)
	end
end)

-- 最小化行为：隐藏窗口，显示圆形按钮
local originalSize = frame.Size
local originalPos = frame.Position

miniBtn.Activated:Connect(function()
	originalSize = frame.Size
	originalPos = frame.Position
	frame.Visible = false
	miniCircle.Visible = true
end)

-- 恢复窗口
miniCircle.Activated:Connect(function()
	frame.Visible = true
	frame.Size = originalSize
	frame.Position = originalPos
	miniCircle.Visible = false
end)
