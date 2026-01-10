-- Roblox 教学作业 - 反混淆还原代码（ServerScriptService下运行）
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local DataStoreService = game:GetService("DataStoreService")
local SaveDataStore = DataStoreService:GetDataStore("RobloxHomeworkSave")

-- 游戏配置（还原混淆的常量）
local GameConfig = {
    MoveSpeed = 16,          -- 角色移动速度
    JumpPower = 50,          -- 角色跳跃力度
    StartLevel = 1,          -- 初始关卡
    MaxLevel = 5,            -- 最高关卡
    CoinScore = 10,          -- 金币加分
    LevelUpScore = 100,      -- 升级奖励分数
    UI_Offset = UDim2.new(0.02, 0, 0.02, 0) -- UI偏移
}

-- 全局数据（还原混淆的全局变量）
local GlobalData = {
    LocalPlayer = nil,
    PlayerCharacter = nil,
    PlayerHumanoid = nil,
    UI_Main = nil,
    SaveData = {
        Level = GameConfig.StartLevel,
        Score = 0
    }
}

-- 工具函数库（还原混淆的工具函数）
local GameTools = {
    -- 加载存档
    LoadData = function()
        local success, data = pcall(function()
            return SaveDataStore:GetAsync("Player_" .. GlobalData.LocalPlayer.UserId)
        end)
        if success and data then
            GlobalData.SaveData = data
        end
    end,

    -- 保存存档
    SaveData = function()
        pcall(function()
            SaveDataStore:SetAsync("Player_" .. GlobalData.LocalPlayer.UserId, GlobalData.SaveData)
        end)
    end,

    -- 创建UI（关卡+分数显示）
    CreateUI = function()
        local ui = Instance.new("ScreenGui")
        ui.Name = "GameUI"
        ui.Parent = GlobalData.LocalPlayer.PlayerGui

        -- 关卡显示
        local levelText = Instance.new("TextLabel")
        levelText.Name = "LevelText"
        levelText.Size = UDim2.new(0.2, 0, 0.05, 0)
        levelText.Position = GameConfig.UI_Offset
        levelText.Font = Enum.Font.SourceSansBold
        levelText.TextSize = 24
        levelText.Text = "当前关卡：" .. GlobalData.SaveData.Level
        levelText.TextColor3 = Color3.new(1, 1, 1)
        levelText.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
        levelText.BackgroundTransparency = 0.3
        levelText.Parent = ui

        -- 分数显示
        local scoreText = Instance.new("TextLabel")
        scoreText.Name = "ScoreText"
        scoreText.Size = UDim2.new(0.2, 0, 0.05, 0)
        scoreText.Position = GameConfig.UI_Offset + UDim2.new(0, 0, -0.06, 0)
        scoreText.Font = Enum.Font.SourceSansBold
        scoreText.TextSize = 24
        scoreText.Text = "当前分数：" .. GlobalData.SaveData.Score
        scoreText.TextColor3 = Color3.new(1, 1, 0)
        scoreText.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
        scoreText.BackgroundTransparency = 0.3
        scoreText.Parent = ui

        GlobalData.UI_Main = ui
        return ui
    end,

    -- 更新UI数据
    UpdateUI = function()
        if not GlobalData.UI_Main then return end
        GlobalData.UI_Main.LevelText.Text = "当前关卡：" .. GlobalData.SaveData.Level
        GlobalData.UI_Main.ScoreText.Text = "当前分数：" .. GlobalData.SaveData.Score
    end,

    -- 关卡升级
    LevelUp = function()
        if GlobalData.SaveData.Level >= GameConfig.MaxLevel then
            GameTools.ShowTips("已达最高关卡！")
            return
        end
        GlobalData.SaveData.Level += 1
        GlobalData.SaveData.Score += GameConfig.LevelUpScore
        GameTools.UpdateUI()
        GameTools.SaveData()
        GameTools.ShowTips("升级成功！当前关卡：" .. GlobalData.SaveData.Level)
    end,

    -- 显示提示弹窗
    ShowTips = function(content)
        local tip = Instance.new("TextLabel")
        tip.Name = "TipLabel"
        tip.Size = UDim2.new(0.3, 0, 0.08, 0)
        tip.Position = UDim2.new(0.35, 0, 0.1, 0)
        tip.Font = Enum.Font.SourceSansBold
        tip.TextSize = 28
        tip.Text = content
        tip.TextColor3 = Color3.new(1, 1, 1)
        tip.BackgroundColor3 = Color3.new(0.1, 0.3, 0.5)
        tip.BackgroundTransparency = 0.2
        tip.Parent = GlobalData.LocalPlayer.PlayerGui
        task.wait(3)
        tip:Destroy()
    end
}

-- 初始化玩家数据（游戏启动执行）
local function InitPlayer(player)
    GlobalData.LocalPlayer = player
    GameTools.LoadData()
    GameTools.CreateUI()

    -- 角色生成初始化
    local function OnCharacterAdded(character)
        GlobalData.PlayerCharacter = character
        GlobalData.PlayerHumanoid = character:WaitForChild("Humanoid")
        GlobalData.PlayerHumanoid.WalkSpeed = GameConfig.MoveSpeed
        GlobalData.PlayerHumanoid.JumpPower = GameConfig.JumpPower

        -- 角色死亡处理
        GlobalData.PlayerHumanoid.Died:Connect(function()
            GameTools.ShowTips("角色死亡，重新开始本关卡")
            task.wait(3)
            player:LoadCharacter()
        end)
    end

    if player.Character then
        OnCharacterAdded(player.Character)
    end
    player.CharacterAdded:Connect(OnCharacterAdded)
end

-- 角色移动控制（WASD+空格跳跃）
local function ControlCharacter(input, gameProcessedEvent)
    if gameProcessedEvent or not GlobalData.PlayerCharacter or not GlobalData.PlayerHumanoid then return end
    local rootPart = GlobalData.PlayerCharacter:FindFirstChild("HumanoidRootPart")
    if not