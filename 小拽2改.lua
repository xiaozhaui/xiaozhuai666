-- FloatingWin.client.lua  （整段可用）
-- 悬浮窗：拖拽 / 最小化 / RightShift 显隐 / 置顶显示 / 滚动裁剪 / 点名字可切换
-- 内置“默认行为”保证有可见效果；如存在 ReplicatedStorage.GameActions 模块，则优先调用你自己的实现。

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

-- 先清掉旧的
local old = PlayerGui:FindFirstChild("FloatingWin")
if old then old:Destroy() end

-- 顶层 ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "FloatingWin"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 9999
gui.Parent = PlayerGui

-- 尝试加载你自己的动作模块（可选）
local ActionsModule = nil
do
    local ok, res = pcall(function()
        local mod = ReplicatedStorage:FindFirstChild("GameActions")
        if mod and mod:IsA("ModuleScript") then
            return require(mod)
        end
    end)
    if ok then ActionsModule = res end
end

-- 简单通知
local function toast(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {Title = title or "提示", Text = text or "", Duration = 2})
    end)
    print("[FloatingWin]", title or "提示", text or "")
end

-- 主窗体
local win = Instance.new("Frame")
win.Name = "Window"
win.Size = UDim2.fromOffset(360, 260)
win.Position = UDim2.fromOffset(120, 120)
win.BackgroundColor3 = Color3.fromRGB(24, 26, 32)
win.BackgroundTransparency = 0.05
win.BorderSizePixel = 0
win.ClipsDescendants = true
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
content.ClipsDescendants = true
content.ScrollingEnabled = true
content.Active = true
content.ZIndex = 120
content.Parent = win

-- 内层容器
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
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then updateDrag(input) end
    end)
end

-- 关闭 / 最小化 / 快捷键
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

-- ===== 默认行为（看得见的反馈），以及对 GameActions 的自动适配 =====
local running = {}   -- 保存每个开关的运行状态与线程

-- 标题栏颜色反馈
local function setTitleActive(active)
    title.TextColor3 = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
    titleBar.BackgroundTransparency = active and 0.6 or 0.8
end

-- 为每个功能准备一个“适配调用”
local function call(name, ...)
    -- 优先调用你自己的实现
    if ActionsModule and type(ActionsModule[name]) == "function" then
        local ok, err = pcall(ActionsModule[name], ...)
        if not ok then warn("[GameActions."..name.."] error:", err) end
        return
    end
    -- 否则给一个默认可见效果（不越权，不依赖服务端）
    local args = {...}
    local on = args[1]
    if on ~= nil then
        toast(name, on and "已开启" or "已关闭")
    else
        toast(name, "已触发")
    end
end

-- 可复用的小部件
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

local function createToggle(key, labelText, defaultOn)
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

    local rowHit = Instance.new("TextButton")
    rowHit.BackgroundTransparency = 1
    rowHit.AutoButtonColor = false
    rowHit.Size = UDim2.fromScale(1, 1)
    rowHit.Text = ""
    rowHit.ZIndex = 122
    rowHit.Parent = row

    local state = defaultOn and true or false
    local function render()
        if state then btn.Text = "开"; btn.BackgroundColor3 = Color3.fromRGB(40, 120, 255)
        else btn.Text = "关"; btn.BackgroundColor3 = Color3.fromRGB(120, 120, 120) end
    end
    local function toggle()
        state = not state; render()

        -- 停掉旧线程
        if running[key] and running[key].stop then running[key].stop() end
        -- 可见反馈（标题栏闪烁表示有开关打开）
        local anyOn = false
        for _, v in pairs(running) do if v.on then anyOn = true break end end
        setTitleActive(anyOn or state)

        -- 调用你的实现或默认行为
        call(key, state)

        -- 我们给一些“默认长任务”的示例（不做越权操作，只做客户端可见效果）
        if state then
            local alive = true
            running[key] = {on = true, stop = function() alive = false; running[key].on = false end}
            task.spawn(function()
                -- 不同 key 给不同的可见动画/提示，保证“有反应”
                while alive do
                    task.wait(0.5)
                    -- 轻微动画：改变窗体透明度/标题色，表示正在“运行”
                    titleBar.BackgroundTransparency = 0.6 + 0.2*math.abs(math.sin(tick()*2))
                end
                titleBar.BackgroundTransparency = 0.8
            end)
        else
            running[key] = {on = false, stop = function() end}
        end
    end
    render()
    btn.MouseButton1Click:Connect(toggle)
    labBtn.MouseButton1Click:Connect(toggle)
    rowHit.MouseButton1Click:Connect(toggle)
end

local function createButton(key, labelText)
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
        call(key) -- 无布尔参数，表示一次性动作
        -- 给个可见动效
        toast(labelText, "已执行")
    end
    btn.MouseButton1Click:Connect(fire)
    labBtn.MouseButton1Click:Connect(fire)
end

-- ===== UI 内容 =====
local function addAuto()
    addSection("自动")
    createToggle("AutoFarm",    "自动刷",   false)
    createToggle("AutoCollect", "自动收",   false)
    createToggle("AutoClaim",   "自动领",   false)
    createToggle("MoveMode",    "移动模式", false)
    createToggle("ShowMap",     "显示地图", false)
    createToggle("AutoEat",     "自动吃",   false)
end

local function addUpgrade()
    addSection("升级")
    createToggle("UpgSize",  "大小",   false)
    createToggle("UpgSpeed", "移速",   false)
    createToggle("UpgMulti", "乘数",   false)
    createToggle("UpgEat",   "吃速",   false)
end

local function addCharacter()
    addSection("人物")
    createToggle("KeepUnanchor","取消锚固", false)
    createToggle("BoundProtect","边界保护", false)
end

local function addMisc()
    addSection("其它")
    createButton("ViewPlayerData","查看玩家数据")
end

addAuto(); addUpgrade(); addCharacter(); addMisc()

toast("悬浮窗", "已加载，可拖拽/最小化/RightShift切换")
print("[FloatingWin] Ready. 若放置了 ReplicatedStorage.GameActions 模块，将优先调用你的实现。")
