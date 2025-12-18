local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- 清理旧窗口
if CoreGui:FindFirstChild("MobileFloatingWindow") then CoreGui.MobileFloatingWindow:Destroy() end

-- 主GUI
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "MobileFloatingWindow"
gui.ResetOnSpawn = false
gui.DisplayOrder = 100

-- 主窗口
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0, 60, 0, 60)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
frame.ClipsDescendants = true

-- 标题栏+拖动
local dragArea = Instance.new("TextButton", frame)
dragArea.Size = UDim2.new(1, 0, 0, 30)
dragArea.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
dragArea.Text = "吃吃世界工具"
dragArea.TextColor3 = Color3.new(1,1,1)
dragArea.Font = Enum.Font.SourceSansBold
dragArea.TextSize = 18

-- 最小化按钮
local miniBtn = Instance.new("TextButton", dragArea)
miniBtn.Size = UDim2.new(0, 40, 0, 30)
miniBtn.Position = UDim2.new(1, -40, 0, 0)
miniBtn.Text = "-"
miniBtn.TextColor3 = Color3.new(1,1,1)
miniBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)

-- 内容区+示例按钮
local contentArea = Instance.new("Frame", frame)
contentArea.Size = UDim2.new(1, 0, 1, -30)
contentArea.Position = UDim2.new(0, 0, 0, 30)
contentArea.BackgroundTransparency = 1

local fakeButton = Instance.new("TextButton", contentArea)
fakeButton.Size = UDim2.new(0, 200, 0, 40)
fakeButton.Position = UDim2.new(0.5, -100, 0, 20)
fakeButton.Text = "自动吃（示例）"
fakeButton.BackgroundColor3 = Color3.fromRGB(60, 100, 180)
fakeButton.TextColor3 = Color3.new(1,1,1)

-- 缩放按钮
local resizeBtn = Instance.new("ImageButton", frame)
resizeBtn.Size = UDim2.new(0, 36, 0, 36)
resizeBtn.Position = UDim2.new(1, -18, 1, -18)
resizeBtn.AnchorPoint = Vector2.new(1,1)
resizeBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
resizeBtn.Image = "rbxassetid://3926305904"
resizeBtn.ImageRectOffset = Vector2.new(84, 284)
resizeBtn.ImageRectSize = Vector2.new(36, 36)

-- 最小化圆形按钮
local miniCircle = Instance.new("TextButton", gui)
miniCircle.Size = UDim2.new(0, 60, 0, 60)
miniCircle.Position = UDim2.new(0, 100, 0, 100)
miniCircle.BackgroundColor3 = Color3.fromRGB(25,25,25)
miniCircle.Text = "+"
miniCircle.TextColor3 = Color3.new(1,1,1)
miniCircle.BorderSizePixel = 3
miniCircle.Visible = false
Instance.new("UICorner", miniCircle).CornerRadius = UDim.new(1,0)

-- 🌈 彩虹边框动画
local hue = 0
RunService.RenderStepped:Connect(function()
	if miniCircle.Visible then
		hue = (hue + 1.5) % 360
		miniCircle.BorderColor3 = Color3.fromHSV(hue / 360, 1, 1)
	end
end)

-- 拖动逻辑（保持流畅）
local dragging, draggingMini = false, false
local dragStart, startPos, miniStart, miniPos

dragArea.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
	end
end)

dragArea.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

miniCircle.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch then
		draggingMini = true
		miniStart = input.Position
		miniPos = miniCircle.Position
	end
end)

miniCircle.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch then draggingMini = false end
end)

UserInputService.TouchMoved:Connect(function(input)
	if dragging then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
	elseif draggingMini then
		local delta = input.Position - miniStart
		miniCircle.Position = UDim2.new(0, miniPos.X.Offset + delta.X, 0, miniPos.Y.Offset + delta.Y)
	end
end)

-- 缩放逻辑优化（跟手性提升核心）
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
	if input.UserInputType == Enum.UserInputType.Touch then resizing = false end
end)

UserInputService.TouchMoved:Connect(function(input)
	if resizing then
		local delta = input.Position - resizeStartPos
		-- 优化1：取消灵敏度倍数（delta×1→原1.5），完全跟手
		-- 优化2：进一步缩小最小尺寸限制，缩放更自由
		local newW = math.max(120, resizeStartSize.X.Offset + delta.X)
		local newH = math.max(60, resizeStartSize.Y.Offset + delta.Y)
		frame.Size = UDim2.new(0, newW, 0, newH)
	end
end)

-- 最小化/恢复逻辑（修改为双击打开）
miniBtn.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch then
		frame.Visible = false
		miniCircle.Visible = true
	end
end)

-- 双击逻辑核心：300ms内两次点击触发
local lastClickTime = 0
local doubleClickDelay = 300 -- 双击间隔（可调整）
miniCircle.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch then
		local currentTime = tick()
		-- 判断两次点击间隔是否小于300ms
		if currentTime - lastClickTime < doubleClickDelay then
			miniCircle.Visible = false
			frame.Visible = true
		end
		lastClickTime = currentTime -- 更新上次点击时间
	end
end)
