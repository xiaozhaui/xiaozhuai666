-- 载入 Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

-- 创建窗口
local Window = Rayfield:CreateWindow({
   Name = "吃吃世界",
   LoadingTitle = "吃吃世界 脚本加载中",
   LoadingSubtitle = "by 你自己",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "吃吃世界配置"
   },
   Discord = {
      Enabled = false
   },
   KeySystem = false
})

-- 设置界面样式和互动元素
local main = Window:CreateTab("自动", 4483362458)
local upgrades = Window:CreateTab("升级", 4483362458)
local figure = Window:CreateTab("人物", 4483362458)
local others = Window:CreateTab("其它", 4483362458)

-- 自定义拉伸和缩放
local resizeable = true
local windowSize = Vector2.new(400, 300)  -- 默认窗口大小
local windowPos = Vector2.new(100, 100)   -- 默认位置

local bg = Drawing.new("Square")
bg.Size = windowSize
bg.Position = windowPos
bg.Color = Color3.fromRGB(30, 30, 30)
bg.Thickness = 1
bg.Transparency = 0.4
bg.Filled = true

local rainbowBorder = Drawing.new("Square")
rainbowBorder.Size = windowSize + Vector2.new(10, 10)  -- 边框稍微大一点
rainbowBorder.Position = windowPos - Vector2.new(5, 5)
rainbowBorder.Color = Color3.fromRGB(255, 0, 0)
rainbowBorder.Thickness = 3
rainbowBorder.Transparency = 0.5
rainbowBorder.Filled = false

-- 创建动态彩虹流动效果
local function createRainbowEffect()
    local rainbowEffect = {}
    local colors = {Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 165, 0), Color3.fromRGB(255, 255, 0), Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 0, 255), Color3.fromRGB(75, 0, 130), Color3.fromRGB(148, 0, 211)}

    local step = 1
    for i = 1, 6 do
        rainbowEffect[i] = Drawing.new("Line")
        rainbowEffect[i].From = windowPos + Vector2.new(i * 60, 0)
        rainbowEffect[i].To = windowPos + Vector2.new(i * 60 + 100, 0)
        rainbowEffect[i].Thickness = 5
        rainbowEffect[i].Transparency = 0
        rainbowEffect[i].Color = colors[step]
        rainbowEffect[i].Visible = true

        step = step + 1
        if step > #colors then
            step = 1
        end
    end

    return rainbowEffect
end

local function updateRainbowEffect(rainbowEffect)
    local step = 1
    for i = 1, #rainbowEffect do
        rainbowEffect[i].Color = rainbowEffect[(i + 1) % #rainbowEffect + 1].Color
    end
end

local rainbowEffect = createRainbowEffect()

-- 每次点击按钮都会显示彩虹流动效果
main:CreateButton({
   Name = "自动刷",
   Callback = function()
      rainbowEffect = createRainbowEffect()  -- 触发按钮时，更新彩虹流动
   end,
})

-- 你可以根据需要继续添加其他功能按钮
main:CreateButton({
   Name = "自动吃",
   Callback = function()
      rainbowEffect = createRainbowEffect()  -- 触发按钮时，更新彩虹流动
   end,
})

-- 监听并更新
game:GetService("RunService").Heartbeat:Connect(function()
    -- 每帧更新彩虹流动效果
    updateRainbowEffect(rainbowEffect)

    -- 这里添加窗口尺寸调整、移动事件（如果需要）

end)