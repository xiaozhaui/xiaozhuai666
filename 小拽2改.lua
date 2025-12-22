-- StarterGui/FloatingWin_DEBUG.client.lua  （整段可用）
-- 用途：在自己的体验里验证 UI 是否加载成功；内置自检与醒目横幅
-- 功能：悬浮窗（拖拽/最小化/RightShift 显隐/置顶/滚动不溢出），以及逐步日志
-- 说明：仅限Studio/自家体验。不要用于注入/绕过（我不能协助注入相关）

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

-- ==== 0) 环境自检 ====
local function log(...) print("[FloatingWin_DEBUG]", ...) end
local function toast(t, m, d)
    pcall(function()
        StarterGui:SetCore("SendNotification", {Title = t or "提示", Text = m or "", Duration = d or 3})
    end)
    log(t or "提示", m or "")
end

-- 必须是客户端 LocalScript
if not RunService:IsClient() then
    warn("[FloatingWin_DEBUG] 这是服务端环境，LocalScript 才能创建玩家本地 UI。请将脚本放到 StarterGui 下（LocalScript）。")
    return
end

-- LocalPlayer / PlayerGui
local LP = Players.LocalPlayer
if not LP then
    warn("[FloatingWin_DEBUG] 没有 LocalPlayer。请确认脚本为 LocalScript 且位于 StarterGui/StarterPlayerScripts。")
    return
end

local PlayerGui = LP:WaitForChild("PlayerGui", 5)
if not PlayerGui then
    warn("[FloatingWin_DEBUG] 5 秒内未找到 PlayerGui。请确认放在 StarterGui 下且为 LocalScript。")
    return
end

-- ==== 1) 清理旧 GUI + 顶部“UI READY”横幅 ====
local old = PlayerGui:FindFirstChild("FloatingWin")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "FloatingWin"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 32767  -- 顶层
gui.Parent = PlayerGui

do
    local banner = Instance.new("TextLabel")
    banner.Name = "ReadyBanner"
    banner.Size = UDim2.new(1, 0, 0, 28)
    banner.Position = UDim2.fromOffset(0, 0)
    banner.BackgroundColor3 = Color3.fromRGB(0, 170, 85)
    banner.BackgroundTransparency = 0
    banner.Text = "✅ UI READY - 按 RightShift 显隐悬浮窗"
    banner.TextColor3 = Color3.new(1,1,1)
    banner.TextSize = 16
    banner.Font = Enum.Font.GothamBold
    banner.ZIndex = 1000
    banner.Parent = gui
    task.delay(2.5, function() if banner then banner:Destroy() end end)
end

toast("步骤1/4", "创建 ScreenGui 成功", 2)

-- ==== 2) 悬浮窗骨架 ====
local win = Instance.new("Frame")
win.Name = "Window"
win.Size = UDim2.fromOffset(360, 260)
win.Position = UDim2.fromOffset(80, 100)
win.BackgroundColor3 = Color3.fromRGB(24, 26, 32)
win.BackgroundTransparency = 0.05
win.BorderSizePixel = 0
win.ClipsDescendants = true
win.ZIndex = 100
win.Parent = gui

Instance.new("UICorner", win).CornerRadius = UDim.new(0, 14)

local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 36)
titleBar.BackgroundTransparency = 0.8
titleBar.BackgroundColor3 = Color3.fromRGB(255,255,255)
titleBar.BorderSizePixel = 0
titleBar.ZIndex = 110
titleBar.Parent = win

local title = Instance.new("TextLabel")
title.Text = "吃吃世界 — 悬浮窗（调试版）"
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

toast("步骤2/4", "窗口与标题栏创建成功", 2)

-- ==== 3) 滚动内容区 + 内层容器 ====
local content = Instance.new("ScrollingFrame")
content.Name = "Content"
content.Position = UDim2.fromOffset(12, 44)
content.Size = UDim2.new(1, -24, 1, -56)
content.BackgroundTransparency = 1
content.ScrollingDirection = Enum.ScrollingDirection.Y
content.ScrollBarThickness = 6
content.VerticalScrollBarInset = Enum.ScrollBarInset.Always
content.Active = true
content.ClipsDescendants = true
content.ZIndex = 120
content.Parent = win

local container = Instance.new("Frame")
container.Name = "Container"
container.Size = UDim2.new(1, 0, 0, 0)
container.BackgroundTransparency = 1
container.AutomaticSize = Enum.AutomaticSize.Y
container.ZIndex = 121
container.Parent = content

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 6)
padding.PaddingBottom = UDim.new(0, 8)
padding.PaddingLeft = UDim.new(0, 8)
padding.PaddingRight = UDim.new(0, 8)
padding.Parent = container

local list = Instance.new("UIListLayout")
list.SortOrder = Enum.SortOrder.LayoutOrder
list.Padding = UDim.new(0, 6)
list.Parent = container

local function updateCanvas()
    local h = list.AbsoluteContentSize.Y + padding.PaddingTop.Offset + padding.PaddingBottom.Offset
    content.CanvasSize = UDim2.new(0, 0, 0, math.max(h, 0))
end
list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
updateCanvas()

toast("步骤3/4", "滚动容器就绪", 2)

-- ==== 4) 拖拽 / 最小化 / RightShift ====
do
    local dragging, dragStart, startPos
    local function updateDrag(input)
        local delta = input.Position - dragStart
        win.Position = UDim2.fromOffset(startPos.X.Offset + delta.X, startPos.Y.Offset + delta.Y)
    end
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = win.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then updateDrag(input) end
    end)
end

btnClose.MouseButton1Click:Connect(function() gui.Enabled = false end)

local collapsed = false
local originalSize = win.Size
btnMin.MouseButton1Click:Connect(function()
    collapsed = not collapsed
    if collapsed then content.Visible = false; win.Size = UDim2.fromOffset(originalSize.X.Offset, 40)
    else content.Visible = true; win.Size = originalSize end
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then gui.Enabled = not gui.Enabled end
end)

toast("步骤4/4", "交互绑定成功（可拖拽/最小化/RightShift）", 3)

-- ==== UI 小部件（点击“名字”也能切换）====
local function addSection(titleText)
    local sec = Instance.new("TextLabel")
    sec.Size = UDim2.new(1, 0, 0, 20)
    sec.BackgroundTransparency = 1
    sec.Font = Enum.Font.GothamBold
    sec.TextSize = 13
    sec.TextXAlignment = Enum.TextXAlignment.Left
    sec.TextColor3 = Color3.fromRGB(170, 200, 255)
    sec.Text = titleText
    sec.ZIndex = 122
    sec.Parent = container
end

local function createToggle(labelText, defaultOn, onChanged)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 32)
    row.BackgroundTransparency = 0.8
    row.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    row.ZIndex = 122
    row.ClipsDescendants = true
    row.Parent = container
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

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
    btn.Size = UDim2.fromOffset(64, 24)
    btn.Position = UDim2.new(1, -74, 0.5, -12)
    btn.BackgroundColor3 = Color3.fromRGB(40, 120, 255)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.Text = "开"
    btn.ZIndex = 123
    btn.Parent = row
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local rowHit = Instance.new("TextButton")
    rowHit.BackgroundTransparency = 1
    rowHit.AutoButtonColor = false
    rowHit.Size = UDim2.fromScale(1, 1)
    rowHit.Text = ""
    rowHit.ZIndex = 122
    rowHit.Parent = row

    local state = defaultOn and true or false
    local function render()
        if state then btn.Text = "开"; btn.BackgroundColor3 = Color3.fromRGB(40,120,255)
        else btn.Text = "关"; btn.BackgroundColor3 = Color3.fromRGB(120,120,120) end
    end
    local function toggle()
        state = not state; render()
        if onChanged then task.spawn(onChanged, state) end
        toast(labelText, state and "开启" or "关闭", 1.2)
    end
    render()
    btn.MouseButton1Click:Connect(toggle)
    labBtn.MouseButton1Click:Connect(toggle)
    rowHit.MouseButton1Click:Connect(toggle)
end

local function createButton(labelText, onClick)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 32)
    row.BackgroundTransparency = 0.8
    row.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    row.ZIndex = 122
    row.ClipsDescendants = true
    row.Parent = container
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

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
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local function fire() if onClick then task.spawn(onClick) end; toast(labelText, "执行", 1.0) end
    btn.MouseButton1Click:Connect(fire)
    labBtn.MouseButton1Click:Connect(fire)
end

-- ==== 示例项（仅为可见反馈；把 print 换成你的逻辑即可）====
local function addAuto()
    addSection("自动")
    createToggle("自动刷", false, function(on) log("自动刷 =>", on) end)
    createToggle("自动收", false, function(on) log("自动收 =>", on) end)
    createToggle("自动领", false, function(on) log("自动领 =>", on) end)
    createToggle("移动模式", false, function(on) log("移动模式 =>", on) end)
    createToggle("显示地图", false, function(on) log("显示地图 =>", on) end)
    createToggle("自动吃", false, function(on) log("自动吃 =>", on) end)
end
local function addUpgrade()
    addSection("升级")
    createToggle("大小", false, function(on) log("升级-大小 =>", on) end)
    createToggle("移速", false, function(on) log("升级-移速 =>", on) end)
    createToggle("乘数", false, function(on) log("升级-乘数 =>", on) end)
    createToggle("吃速", false, function(on) log("升级-吃速 =>", on) end)
end
local function addFigure()
    addSection("人物")
    createToggle("取消锚固", false, function(on) log("取消锚固 =>", on) end)
    createToggle("边界保护", false, function(on) log("边界保护 =>", on) end)
end
local function addMisc()
    addSection("其它")
    createButton("查看玩家数据", function() log("查看玩家数据：执行") end)
end
addAuto(); addUpgrade(); addFigure(); addMisc()

-- ==== 完成提示 ====
toast("悬浮窗", "加载完成（见上方横幅 & 窗口）", 3)
log("如果仍看不到：按 F9 打开控制台，查看是否输出了“步骤1/4 ~ 4/4”。")
log("必须是 LocalScript 且放在 StarterGui 下。注入/执行器问题不在本脚本支持范围。")
