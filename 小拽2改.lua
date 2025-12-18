-- Roblox Lua GUI script with elliptical rainbow header and dropdown content
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "RainbowFloatingUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
gui.Parent = player:WaitForChild("PlayerGui")

-- Main pill button: "小拽吃吃世界"
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

-- Minimize button
local minimize = Instance.new("TextButton")
minimize.Name = "MinimizeButton"
minimize.Text = "-"
minimize.TextColor3 = Color3.new(1, 1, 1)
minimize.TextSize = 22
minimize.Font = Enum.Font.SourceSansBold
minimize.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
minimize.Size = UDim2.new(0, 40, 0, 40)
minimize.Position = UDim2.new(0, pill.Position.X.Offset + pill.Size.X.Offset + 8, 0, 100)
minimize.BorderSizePixel = 3
minimize.Parent = gui

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(1, 0)
minCorner.Parent = minimize

-- Rainbow border logic
local hue = 0
RunService.RenderStepped:Connect(function()
    hue = (hue + 1) % 360
    local color = Color3.fromHSV(hue / 360, 1, 1)
    pill.BorderColor3 = color
    minimize.BorderColor3 = color
    for _, child in ipairs(gui:GetChildren()) do
        if child:IsA("TextButton") and child.Name:match("Button%d") then
            child.BorderColor3 = color
        end
    end
end)

-- Dropdown container
local dropdown = Instance.new("Frame")
dropdown.Name = "DropdownContent"
dropdown.Size = UDim2.new(0, 160, 0, 0)
dropdown.Position = UDim2.new(0, 50, 0, 140)
dropdown.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
dropdown.ClipsDescendants = true
dropdown.Visible = false
dropdown.Parent = gui

-- UIListLayout for stacking buttons
local list = Instance.new("UIListLayout")
list.FillDirection = Enum.FillDirection.Vertical
list.SortOrder = Enum.SortOrder.LayoutOrder
list.Padding = UDim.new(0, 4)
list.Parent = dropdown

-- Function buttons with rainbow borders
local function createButton(name, order)
    local btn = Instance.new("TextButton")
    btn.Name = "Button" .. order
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 16
    btn.Font = Enum.Font.SourceSans
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    btn.Size = UDim2.new(1, -8, 0, 36)
    btn.BorderSizePixel = 3
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.2, 0)
    corner.Parent = btn
    btn.Parent = dropdown
end

createButton("自动吃", 1)
createButton("自动刷怪", 2)
createButton("自动升级", 3)

-- Toggle logic
local expanded = false
pill.MouseButton1Click:Connect(function()
    expanded = not expanded
    dropdown.Visible = true
    local goalSize = expanded and UDim2.new(0, 160, 0, 120) or UDim2.new(0, 160, 0, 0)
    dropdown:TweenSize(goalSize, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
end)

-- Minimize logic
minimize.MouseButton1Click:Connect(function()
    gui.Enabled = false
end)
