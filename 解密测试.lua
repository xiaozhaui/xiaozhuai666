-- 适配Roblox游戏环境（教学作业最常用平台，Lua5.1兼容）
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local GuiService = game:GetService("GuiService")
local DataStoreService = game:GetService("DataStoreService")
local UserInputService = game:GetService("UserInputService")

-- 游戏配置（教学作业标准参数，可按老师要求修改）
local GameConfig = {
    MoveSpeed = 16, -- 角色移动速度
    JumpPower = 50, -- 跳跃力度
    MaxLevel = 5, -- 最大关卡
    SaveKey = "StudentHomework_SaveData", -- 存档键名
    UI_Offset = UDim2.new(0.02, 0, 0.9, 0), -- UI位置
    StartLevel = 1 -- 初始关卡
}

-- 全局存储（角色/UI/存档数据）
local GlobalData = {
    LocalPlayer = nil,
    PlayerCharacter = nil,
    PlayerHumanoid = nil,
    UI_Main = nil,
    SaveData = {Level = GameConfig.StartLevel, Score = 0}
}

-- 工具函数（游戏专用，适配教学需求）
local GameTools = {
    -- 存档函数
    SaveData = function()
        local success, err = pcall(function()
            local playerKey = GameConfig.SaveKey .. "_" .. GlobalData.LocalPlayer.UserId
            local dataStore = DataStoreService:GetDataStore("HomeworkDataStore")
            dataStore:SetAsync(playerKey, GlobalData.SaveData)
        end)
        if not success then warn("存档失败：" .. err) end
    end,

    -- 读档函数
    LoadData = function()
        local success, savedData = pcall(function()
            local playerKey = GameConfig.SaveKey .. "_" .. GlobalData.LocalPlayer.UserId
            local dataStore = DataStoreService:GetDataStore("HomeworkDataStore")
            return dataStore:GetAsync(playerKey)
        end)
        if success and savedData then
            GlobalData.SaveData = savedData
            print("读档成功：关卡" .. savedData.Level .. " 分数" .. savedData.Score)
        else
            warn("读档失败，使用初始数据")
        end
    end,

    -- 创建UI弹窗
    CreateUI = function()
        -- 主UI框架
        local ui = Instance.new("ScreenGui")
        ui.Name = "HomeworkUI"
        ui.Parent = GlobalData.LocalPlayer.PlayerGui

        -- 关卡显示文本
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

        -- 分数显示文本
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

    -- 关卡提升
    LevelUp = function()
        if GlobalData.SaveData.Level >= GameConfig.MaxLevel then
            GameTools.ShowTips("已达最高关卡！")
            return
        end
        GlobalData.SaveData.Level += 1
        GlobalData.SaveData.Score += 100 -- 升级奖励分数
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
        -- 3秒后销毁
        task.wait(3)
        tip:Destroy()
    end
}

-- 初始化玩家数据（游戏启动必执行）
local function InitPlayer(player)
    GlobalData.LocalPlayer = player
    -- 读档
    GameTools.LoadData()
    -- 创建UI
    GameTools.CreateUI()

    -- 角色生成时初始化
    local function OnCharacterAdded(character)
        GlobalData.PlayerCharacter = character
        GlobalData.PlayerHumanoid = character:WaitForChild("Humanoid")
        -- 设置移动速度和跳跃力度
        GlobalData.PlayerHumanoid.WalkSpeed = GameConfig.MoveSpeed
        GlobalData.PlayerHumanoid.JumpPower = GameConfig.JumpPower

        -- 角色死亡提示
        GlobalData.PlayerHumanoid.Died:Connect(function()
            GameTools.ShowTips("角色死亡，重新开始本关卡")
            -- 3秒后重生
-- 角色移动控制（适配键盘输入，教学作业核心功能）
local function ControlCharacter(input, gameProcessedEvent)
    if gameProcessedEvent or not GlobalData.PlayerCharacter or not GlobalData.PlayerHumanoid then return end
    local rootPart = GlobalData.PlayerCharacter:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    local moveDir = Vector3.new(0, 0, 0)
    -- 方向控制（WASD/上下左右）
    if UserInputService:IsKeyDown(Enum.KeyCode.W) or UserInputService:IsKeyDown(Enum.KeyCode.Up) then
        moveDir = moveDir + Vector3.new(0, 0, -1)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) or UserInputService:IsKeyDown(Enum.KeyCode.Down) then
        moveDir = moveDir + Vector3.new(0, 0, 1)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) or UserInputService:IsKeyDown(Enum.KeyCode.Left) then
        moveDir = moveDir + Vector3.new(-1, 0, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) or UserInputService:IsKeyDown(Enum.KeyCode.Right) then
        moveDir = moveDir + Vector3.new(1, 0, 0)
    end

    -- 跳跃控制（空格）
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) and rootPart.Position.Y < 0.5 then
        GlobalData.PlayerHumanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end

    -- 移动方向归一化（避免斜向速度过快）
    if moveDir.Magnitude > 0 then
        moveDir = moveDir.Unit
        rootPart.CFrame = CFrame.new(rootPart.Position, rootPart.Position + moveDir)
        GlobalData.PlayerHumanoid:Move(moveDir)
    end
end

-- 绑定输入事件
UserInputService.InputBegan:Connect(ControlCharacter)
UserInputService.InputEnded:Connect(ControlCharacter)

-- 关卡触发区域（教学作业常见设计，触碰后升级）
local function CreateLevelTrigger(level, position)
    -- 创建触发区域（透明方块）
    local trigger = Instance.new("Part")
    trigger.Name = "LevelTrigger_" .. level
    trigger.Size = Vector3.new(4, 1, 4)
    trigger.Position = position
    trigger.Anchored = true
    trigger.CanCollide = false
    trigger.Transparency = 0.7
    trigger.BrickColor = BrickColor.new("BrightBlue")
    trigger.Parent = Workspace

    -- 触碰检测
    local function OnTouched(hit)
        local character = hit.Parent
        local humanoid = character:FindFirstChild("Humanoid")
        if not humanoid then return end
        local player = Players:GetPlayerFromCharacter(character)
        if player and player == GlobalData.LocalPlayer then
            -- 只有当前关卡等于触发关卡时生效
            if GlobalData.SaveData.Level == level then
                GameTools.LevelUp()
                -- 触发后隐藏区域
                trigger.Transparency = 1
                task.wait(60) -- 1分钟后恢复（可选）
                trigger.Transparency = 0.7
            else
                GameTools.ShowTips("请先完成第" .. GlobalData.SaveData.Level .. "关")
            end
        end
    end

    trigger.Touched:Connect(OnTouched)
end

-- 创建教学关卡触发点（可按老师要求修改位置）
CreateLevelTrigger(1, Vector3.new(20, 0.5, 0)) -- 1关：(20,0.5,0)
CreateLevelTrigger(2, Vector3.new(40, 0.5, 20)) -- 2关：(40,0.5,20)
CreateLevelTrigger(3, Vector3.new(20, 0.5, 40)) -- 3关：(20,0.5,40)
CreateLevelTrigger(4, Vector3.new(0, 0.5, 20)) -- 4关：(0,0.5,20)
CreateLevelTrigger(5, Vector3.new(30, 0.5, 30)) -- 5关：(30,0.5,30)

-- 分数获取（触碰金币，教学作业常见加分项）
local function CreateCoin(position)
    local coin = Instance.new("Part")
    coin.Name = "Coin"
    coin.Size = Vector3.new(1, 1, 1)
    coin.Position = position
    coin.Anchored = true
    coin.CanCollide = false
    coin.BrickColor = BrickColor.new("BrightYellow")
    coin.Parent = Workspace

    -- 旋转动画（提升视觉效果）
    task.spawn(function()
        while coin do
            coin.CFrame = coin.CFrame * CFrame.Angles(0, 0.02, 0)
            task.wait()
        end
    end)

    -- 触碰加分
    local function OnCoinTouched(hit)
        local character = hit.Parent
        local humanoid = character:FindFirstChild("Humanoid")
        if not humanoid then return end
        local player = Players:GetPlayerFromCharacter(character)
        if player and player == GlobalData.LocalPlayer then
            GlobalData.SaveData.Score += 10
            GameTools.UpdateUI()
            GameTools.SaveData()
            -- 金币消失效果
            coin.Transparency = 1
            task.wait(0.1)
            coin:Destroy()
        end
    end

    coin.Touched:Connect(OnCoinTouched)
end

-- 批量创建金币（分布在关卡路线上）
for i = 1, 30 do
    local x = math.random(-10, 50)
    local z = math.random(-10, 50)
    CreateCoin(Vector3.new(x, 0.5, z))
end-- 玩家退出时存档
Players.PlayerRemoving:Connect(function(player)
    if player == GlobalData.LocalPlayer then
        GameTools.SaveData()
        print("玩家退出，已存档")
    end
end)

-- 紧急存档快捷键（教学作业便捷功能，按P键存档）
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end
    if input.KeyCode == Enum.KeyCode.P then
        GameTools.SaveData()
        GameTools.ShowTips("手动存档成功！")
    end
end)

-- 重置数据快捷键（按R键重置，教学测试用）
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end
    if input.KeyCode == Enum.KeyCode.R then
        GlobalData.SaveData = {Level = GameConfig.StartLevel, Score = 0}
        GameTools.SaveData()
        GameTools.UpdateUI()
        GameTools.ShowTips("数据已重置，回到第1关！")
        -- 重生角色
        if GlobalData.LocalPlayer then
            GlobalData.LocalPlayer:LoadCharacter()
        end
    end
end)

-- 游戏启动提示
task.wait(2)
if GlobalData.LocalPlayer then
    GameTools.ShowTips("游戏启动成功！WASD移动，空格跳跃，P存档，R重置")
end

-- 防作弊检测（教学作业基础功能，可选）
local function AntiCheatCheck()
    while wait(10) do
        if GlobalData.PlayerHumanoid then
            -- 检测移动速度作弊
            if GlobalData.PlayerHumanoid.WalkSpeed > GameConfig.MoveSpeed + 2 then
                GlobalData.PlayerHumanoid.WalkSpeed = GameConfig.MoveSpeed
                GameTools.ShowTips("检测到异常速度，已重置！")
            end
        end
    end
end
task.spawn(AntiCheatCheck)

print("作业游戏代码加载完成，所有功能已激活！")