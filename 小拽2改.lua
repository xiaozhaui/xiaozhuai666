-- FloatingWin.client.lua  （整段替换）
-- 悬浮窗：拖拽 / 最小化 / RightShift 显隐 / 置顶显示 / 严格裁剪 / 可滚动内容
-- 行为改进：点击“功能名”也能切换（整行可点）

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

-- 防重复
local old = playerGui:FindFirstChild("FloatingWin")
if old then old:Destroy() end

-- 顶层 ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "FloatingWin"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 9999            -- ★ 始终在最上层
gui.Parent = playerGui

-- 主窗体
local win = Instance.new("Frame")
win.Name = "Window"
win.Size = UDim2.fromOffset(360, 260)
win.Position = UDim2.fromOffset(120, 120)
win.BackgroundColor3 = Color3.fromRGB(24, 26, 32)
win.BackgroundTransparency = 0.05
win.BorderSizePixel = 0
win.ClipsDescendants = true        -- ★ 裁剪一切子元素
win.ZIndex = 100
win.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = win

-- 阴影（可选）
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.Position = UDim2.fromScale(0.5, 0.5)
shadow.Size = UDim2.new(1, 60, 1, 60)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://5028857084"
shadow.ImageTransparency = 0.35
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(24, 24, 276, 276)
shadow.ZIndex = 99
shadow.Parent = win

-- 标题栏
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 36)
titleBar.BackgroundTransparency = 0.8
titleBar.BackgroundColor3 = Color3.fromRGB(255,255,255)
titleBar.BorderSizePixel = 0
titleBar.ZIndex = 110
titleBar.Parent = win

local title = Instance.new("TextLabel")
title.Text = "吃吃世界 — 悬浮窗"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextColor3 = Color3.fromRGB(240, 240, 240)
title.BackgroundTransparency = 1
title.Position = UDim2.fromOffset(12, 0)
title.Size = UDim2.new(1, -120, 1, 0)
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 111
title.Parent = titleBar

local btnClose = Instance.new("TextButton")
btnClose.Text = "×"
btnClose.Font = Enum.Font.GothamBold
btnClose.TextSize = 16
btnClose.TextColor3 = Color3.fromRGB(230,230,230)
btnClose.BackgroundTransparency = 0.85
btnClose.Size = UDim2.fromOffset(32, 24)
btnClose.Position = UDim2.new(1, -36, 0, 6)
btnClose.ZIndex = 112
btnClose.Parent = titleBar

local btnMin = Instance.new("TextButton")
btnMin.Text = "—"
btnMin.Font = Enum.Font.GothamBold
btnMin.TextSize = 16
btnMin.TextColor3 = Color3.fromRGB(230,230,230)
btnMin.BackgroundTransparency = 0.85
btnMin.Size = UDim2.fromOffset(32, 24)
btnMin.Position = UDim2.new(1, -72, 0, 6)
btnMin.ZIndex = 112
btnMin.Parent = titleBar

-- 内容滚动区
local content = Instance.new("ScrollingFrame")
content.Name = "Content"
content.Position = UDim2.fromOffset(12, 44)
content.Size = UDim2.new(1, -24, 1, -56)
content.BackgroundTransparency = 1
content.ScrollingDirection = Enum.ScrollingDirection.Y
content.ScrollBarThickness = 6
content.VerticalScrollBarInset = Enum.ScrollBarInset.Always
content.ClipsDescendants = true        -- ★ 滚动框也裁剪
content.ScrollingEnabled = true
content.Active = true
content.ZIndex = 120
content.Parent = win

-- 内层容器（真正放行的地方）
local container = Instance.new("Frame")
container.Name = "Container"
container.Size = UDim2.new(1, 0, 0, 0)
container.BackgroundTransparency = 1
container.AutomaticSize = Enum.AutomaticSize.Y
container.ZIndex = 121
container.Parent = content

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 4)
padding.PaddingBottom = UDim.new(0, 8)
padding.PaddingLeft = UDim.new(0, 8)
padding.PaddingRight = UDim.new(0, 8)
padding.Parent = container

local list = Instance.new("UIListLayout")
list.SortOrder = Enum.SortOrder.LayoutOrder
list.Padding = UDim.new(0, 6)
list.Parent = container

-- 统一根据内容高度更新 CanvasSize（不依赖 AutomaticCanvasSize）
local function updateCanvas()
    local h = list.AbsoluteContentSize.Y + padding.PaddingTop.Offset + padding.PaddingBottom.Offset
    content.CanvasSize = UDim2.new(0, 0, 0, math.max(h, 0))
end
list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
updateCanvas()

-- 拖拽
do
    local dragging, dragStart, startPos
    local function updateDrag(input)
        local delta = input.Position - dragStart
        win.Position = UDim2.fromOffset(startPos.X.Offset + delta.X, startPos.Y.Offset + delta.Y)
    end
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = win.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            updateDrag(input)
        end
    end)
end

-- 关闭 / 最小化 / 快捷键
btnClose.MouseButton1Click:Connect(function()
    gui.Enabled = false
end)

local collapsed = false
local originalSize = win.Size
btnMin.MouseButton1Click:Connect(function()
    collapsed = not collapsed
    if collapsed then
        content.Visible = false
        win.Size = UDim2.fromOffset(originalSize.X.Offset, 40)
    else
        content.Visible = true
        win.Size = originalSize
    end
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        gui.Enabled = not gui.Enabled
    end
end)

-- ===== 可复用的小部件 =====
local function addSection(titleText)
    local sec = Instance.new("TextLabel")
    sec.Size = UDim2.new(1, 0, 0, 20)
    sec.BackgroundTransparency = 1
    sec.Font = Enum.Font.GothamBold
    sec.TextSize = 13
    sec.TextXAlignment = Enum.TextXAlignment.Left
    sec.TextColor3 = Color3.fromRGB(170, 200, 255)
    sec.Text = titleText
    sec.LayoutOrder = 0
    sec.ZIndex = 122
    sec.Parent = container
end

-- 点击“名字”即可切换；整行也能点
local function createToggle(labelText, defaultOn, onChanged)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 32)
    row.BackgroundTransparency = 0.8
    row.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    row.LayoutOrder = 1
    row.ZIndex = 122
    row.ClipsDescendants = true
    row.Parent = container

    local rcorner = Instance.new("UICorner"); rcorner.CornerRadius = UDim.new(0, 8); rcorner.Parent = row

    -- 名字按钮（可点）
    local labBtn = Instance.new("TextButton")
    labBtn.BackgroundTransparency = 1
    labBtn.AutoButtonColor = false
    labBtn.Position = UDim2.fromOffset(10, 0)
    labBtn.Size = UDim2.new(1, -100, 1, 0)
    labBtn.Font = Enum.Font.Gotham
    labBtn.TextSize = 14
    labBtn.TextXAlignment = Enum.TextXAlignment.Left
    labBtn.TextColor3 = Color3.fromRGB(30, 30, 30)
    labBtn.Text = labelText
    labBtn.ZIndex = 123
    labBtn.Parent = row

    -- 右侧按钮
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromOffset(64, 24)
    btn.Position = UDim2.new(1, -74, 0.5, -12)
    btn.BackgroundColor3 = Color3.fromRGB(40, 120, 255)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.Text = "开"
    btn.ZIndex = 123
    btn.Parent = row

    local bcorner = Instance.new("UICorner"); bcorner.CornerRadius = UDim.new(0, 6); bcorner.Parent = btn

    -- 整行透明触发层（容错：点行背景也能切换）
    local rowHit = Instance.new("TextButton")
    rowHit.BackgroundTransparency = 1
    rowHit.AutoButtonColor = false
    rowHit.Size = UDim2.fromScale(1, 1)
    rowHit.Text = ""
    rowHit.ZIndex = 122
    rowHit.Parent = row

    local state = defaultOn and true or false
    local function render()
        if state then
            btn.Text = "开"
            btn.BackgroundColor3 = Color3.fromRGB(40, 120, 255)
        else
            btn.Text = "关"
            btn.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
        end
    end
    local function toggle()
        state = not state
        render()
        if onChanged then task.spawn(onChanged, state) end
    end
    render()

    btn.MouseButton1Click:Connect(toggle)
    labBtn.MouseButton1Click:Connect(toggle)   -- ★ 点名字即可切换
    rowHit.MouseButton1Click:Connect(toggle)   -- ★ 点整行也可切换
end

local function createButton(labelText, onClick)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 32)
    row.BackgroundTransparency = 0.8
    row.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    row.LayoutOrder = 1
    row.ZIndex = 122
    row.ClipsDescendants = true
    row.Parent = container

    local rcorner = Instance.new("UICorner"); rcorner.CornerRadius = UDim.new(0, 8); rcorner.Parent = row

    local labBtn = Instance.new("TextButton")
    labBtn.BackgroundTransparency = 1
    labBtn.AutoButtonColor = false
    labBtn.Position = UDim2.fromOffset(10, 0)
    labBtn.Size = UDim2.new(1, -100, 1, 0)
    labBtn.Font = Enum.Font.Gotham
    labBtn.TextSize = 14
    labBtn.TextXAlignment = Enum.TextXAlignment.Left
    labBtn.TextColor3 = Color3.fromRGB(30, 30, 30)
    labBtn.Text = labelText
    labBtn.ZIndex = 123
    labBtn.Parent = row

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromOffset(80, 24)
    btn.Position = UDim2.new(1, -90, 0.5, -12)
    btn.BackgroundColor3 = Color3.fromRGB(20, 160, 140)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.Text = "执行"
    btn.ZIndex = 123
    btn.Parent = row

    local bcorner = Instance.new("UICorner"); bcorner.CornerRadius = UDim.new(0, 6); bcorner.Parent = btn

    local function fire()
        if onClick then task.spawn(onClick) end
    end
    btn.MouseButton1Click:Connect(fire)
    labBtn.MouseButton1Click:Connect(fire)     -- 点名字也执行
end

-- ====== 示例内容（把回调换成你的逻辑即可）======
addSection("自动")
createToggle("自动刷", false, function(on) print("自动刷:", on) end)
createToggle("自动收", false, function(on) print("自动收:", on) end)
createToggle("自动领", false, function(on) print("自动领:", on) end)
createToggle("移动模式", false, function(on) print("移动模式:", on) end)
createToggle("显示地图", false, function(on) print("显示地图:", on) end)
createToggle("自动吃", false, function(on) print("自动吃:", on) end)

addSection("升级")
createToggle("大小", false, function(on) print("升级-大小:", on) end)
createToggle("移速", false, function(on) print("升级-移速:", on) end)
createToggle("乘数", false, function(on) print("升级-乘数:", on) end)
createToggle("吃速", false, function(on) print("升级-吃速:", on) end)

addSection("人物")
createToggle("取消锚固", false, function(on) print("人物-取消锚固:", on) end)
createToggle("边界保护", false, function(on) print("人物-边界保护:", on) end)

addSection("其它")
createButton("查看玩家数据", function() print("查看玩家数据：执行") end)

print("[悬浮窗] Loaded (Top-most, Clip, Scroll). 点击名字=切换 / 整行可点。")
