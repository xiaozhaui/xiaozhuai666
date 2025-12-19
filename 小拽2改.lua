-- Load UILib (ensure the script is using the UILib for GUI creation)
local UILib = getgenv().UILibCache or loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wizard"))
getgenv().UILibCache = UILib

-- Create UI window
local UI = UILib()
local window = UI:NewWindow("小拽吃吃世界二改", Color3.fromRGB(0, 0, 0), Enum.OutlineVisibility.Visible, Enum.UIElementSize(300, 80))

-- Create Name Section (Ellipse shaped)
local nameSection = window:NewSection("小拽吃吃世界二改", {Shape = Enum.UIShape.Ellipse, Size = UDim2.new(0, 300, 0, 40)})
nameSection.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

-- Create Round Collapse Button
local collapseButton = nameSection:CreateButton("-", function()
    if window:IsOpen() then
        window:Collapse()  -- Close the UI when clicked
    else
        window:Expand()   -- Expand the UI when clicked
    end
end)

-- Add Sections for functional blocks
local main = window:NewSection("自动")
local upgrades = window:NewSection("升级")
local figure = window:NewSection("人物")
local others = window:NewSection("其它")

-- Toggle for automatic farming
main:CreateToggle("自动刷", function(enabled)
    autofarm = enabled
    
    -- Add logic to handle autofarm actions here
    coroutine.wrap(function()
        -- Your autofarm logic here...
    end)()
end)

-- Toggle for automatic upgrades (size)
upgrades:CreateToggle("大小", function(enabled)
    autoUpgradeSize = enabled
    
    -- Add logic to handle auto upgrade for size here
    coroutine.wrap(function()
        -- Your size upgrade logic here...
    end)()
end)

-- Toggle for automatic upgrades (speed)
upgrades:CreateToggle("移速", function(enabled)
    autoUpgradeSpd = enabled
    
    -- Add logic to handle auto upgrade for speed here
    coroutine.wrap(function()
        -- Your speed upgrade logic here...
    end)()
end)

-- Toggle for automatic upgrades (multiplier)
upgrades:CreateToggle("乘数", function(enabled)
    autoUpgradeMulti = enabled
    
    -- Add logic to handle auto upgrade for multiplier here
    coroutine.wrap(function()
        -- Your multiplier upgrade logic here...
    end)()
end)

-- Toggle for automatic upgrades (eat speed)
upgrades:CreateToggle("吃速", function(enabled)
    autoUpgradeEat = enabled
    
    -- Add logic to handle auto upgrade for eat speed here
    coroutine.wrap(function()
        -- Your eat speed upgrade logic here...
    end)()
end)

-- Toggle for figure settings (unanchoring)
figure:CreateToggle("取消锚固", function(enabled)
    keepUnanchor = enabled
    
    -- Add logic to unanchor character here
    coroutine.wrap(function()
        -- Your unanchor logic here...
    end)()
end)

-- Toggle for boundary protection
figure:CreateToggle("边界保护", function(enabled)
    boundProtect = enabled
    
    -- Add logic for boundary protection here
    coroutine.wrap(function()
        -- Your boundary protection logic here...
    end)()
end)

-- Button for viewing player data
others:CreateButton("查看玩家数据", function()
    -- Fetch and display player data
    local localization = {
        MaxSize = "体积",
        Speed = "移速",
        Multiplier = "乘数",
        EatSpeed = "吃速",
    }
    local growthFunctions = {
        MaxSize = sizeGrowth,
        Speed = speedGrowth,
        Multiplier = multiplierGrowth,
        EatSpeed = eatSpeedGrowth,
    }
    local priceFunctions = {
        MaxSize = sizePrice,
        Speed = speedPrice,
        Multiplier = multiplierPrice,
        EatSpeed = eatSpeedPrice,
    }
    for _, player in Players:GetPlayers() do
        -- Your logic to display player data here...
    end
    
    game.StarterGui:SetCore("DevConsoleVisible", true)
end)

-- Collapse or Expand the window based on button state
local function toggleWindow()
    if window:IsOpen() then
        window:Collapse()
    else
        window:Expand()
    end
end
