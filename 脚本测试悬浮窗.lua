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
gui.DisplayOrder = 100 -- 确保窗口在最上层，不被遮挡

-- 主窗口
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0, 60, 0, 60)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
frame.Name = "MainWindow"
frame.Parent = gui
frame.ClipsDescendants = true -- 防止内容溢出

-- 标题栏（调整层级，确保最小化按钮可点击）
local dragArea = Instance.new("TextButton")
dragArea.Size = UDim2.new(1, 0, 0, 30)
dragArea.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
dragArea.Text = "吃吃世界工具"
dragArea.TextColor3 = Color3.new(1, 1, 1)
dragArea.Font = Enum.Font.SourceSansBold
dragArea.TextSize = 18
dragArea.AutoButtonColor = true -- 增加点击反馈
dragArea.Parent = frame

-- 最小化按钮（优化尺寸+点击区域+反馈）
local miniBtn = Instance.new("TextButton")
miniBtn.Size = UDim2.new(0, 40, 0, 30) -- 扩大点击区域（宽40→原30）
miniBtn.Position = UDim2.new(1, -40, 0, 0) -- 对应调整位置
miniBtn.Text = "-"
miniBtn.TextColor3 = Color3.new(1, 1, 1)
miniBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70) -- 增加背景，明确点击区域
miniBtn.BorderSizePixel = 1
miniBtn.BorderColor3 = Color3.fromRGB(200, 200, 200)
miniBtn.Font = Enum.Font.SourceSansBold
miniBtn.TextSize = 22 -- 放大文字，更易识别
miniBtn.AutoButtonColor = true -- 点击时变色反馈
miniBtn.Parent = dragArea

-- 内容区（保持不变）
local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, 0, 1, -30)
contentArea.Position = UDim2.new(0, 0, 0, 30)
contentArea.BackgroundTransparency = 1
contentArea.Parent = frame

local fakeButton = Instance.new("TextButton", contentArea)
fakeButton.Size = UDim2.new(0, 200, 0, 40)
fakeButton.Position = UDim2.new(0.5, -100, 0, 20)
fakeButton.Text = "自动吃（示例）"
fakeButton.Font = Enum.Font.SourceSans
fakeButton.TextSize = 18
fakeButton.BackgroundColor3 = Color3.fromRGB(60, 100, 180)
fakeButton.TextColor3 = Color3.new(1, 1, 1)
fakeButton.AutoButtonColor = true

-- 缩放按钮（扩大尺寸+优化图片显示）
local resizeBtn = Instance.new("ImageButton")
resizeBtn.Size = UDim2.new(0, 36, 0, 36) -- 放大按钮（原24x24→36x36）
resizeBtn.Position = UDim2.new(1, -18, 1, -18) -- 对应调整锚点位置
resizeBtn.AnchorPoint = Vector2.new(1, 1)
resizeBtn.BackgroundTransparency = 0.3
resizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- 增加半透明背景，易找到
resizeBtn.Image = "rbxassetid://3926305904"
resizeBtn.ImageRectOffset = Vector2.new(84, 284)
resizeBtn.ImageRectSize = Vector2.new(36, 36)
resizeBtn.ImageColor3 = Color3.new(1, 1, 1) -- 图片变白，更显眼
resizeBtn.Parent = frame

-- 最小化圆形按钮（保持不变，优化显示）
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
miniCircle.AutoButtonColor = true -- 点击反馈

local corner = Instance.new("UICorner", miniCircle)
corner.CornerRadius = UDim.new(1, 0)

-- 彩虹边框动画（保持不变）
local hue = 0
RunService.RenderStepped:Connect(function()
	if miniCircle.Visible then
		hue = (hue + 1) % 360
		miniCircle.BorderColor3 = Color3.fromHSV(hue / 360, 1, 1)
	end
end)

-- 拖动窗口（保持不变）
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

-- 拖动圆形按钮（保持不变）
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

-- 缩放逻辑（优化灵敏度+扩大缩放范围）
local resizing = false
local resizeStartPos, resizeStartSize
resizeBtn.InputBegan:Connect(function(input)
	if input.UserInputType 