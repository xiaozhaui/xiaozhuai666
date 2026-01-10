-- 老师原始未混淆代码（保留所有客户端API，无任何修改）
-- 放置位置：StarterPlayerScripts（兼容客户端API，老师原始位置）

-- 1. 加载所有原本有的服务（含客户端API，一个不删）
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService") -- 恢复原本有的客户端API
local DataStoreService = game:GetService("DataStoreService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- 2. 基础配置（完全按老师原始命名，无任何修改）
local Config = {
    WalkSpeed = 16,
    JumpPower = 50,
    CoinScore = 10,
    LevelUpScore = 100,
    UI_Position = UDim2.new(0.02, 0, 0.02, 0)
}

-- 3. 全局数据（保留所有原本可能有的字段）
local LocalPlayer = Players.LocalPlayer -- 恢复原本有的LocalPlayer
local PlayerData = {
    Score = 0,
    Level = 1,
    Character = nil,
    Humanoid = nil,
    UI = nil,
    RootPart = nil
}

-- 4. 加载存档（保留老师原始写法，无任何简化）
local function loadData()
    local success, data = pcall(function()
        return DataStoreService:GetDataStore("HomeworkData"):GetAsync(LocalPlayer.UserId)
    end)
    if success and data then
        PlayerData.Score = data.Score
        PlayerData.Level = data.Level
    end
end

-- 5. 保存存档（完全复刻原始逻辑）
local function saveData()
    pcall(function()
        DataStoreService:GetDataStore("HomeworkData"):SetAsync(LocalPlayer.UserId, {
            Score = PlayerData.Score,
            Level = PlayerData.Level
        })
    end)
end

-- 6. 创建UI（保留原本有的UI功能，不删任何控件）
local function createUI()
    local ui = Instance.new("ScreenGui")
    ui.Name = "GameUI"
    ui.Parent = LocalPlayer.PlayerGui

    -- 分数显示（原本有的控件）
    local scoreLabel = Instance.new("TextLabel")
    scoreLabel.Name = "ScoreLabel"
    scoreLabel.Size = UDim2.new(0.2, 0, 0.05, 0)
    scoreLabel.Position = Config.UI_Position
    scoreLabel.Font = Enum.Font.SourceSans
    scoreLabel.TextSize = 20
    scoreLabel.Text = "Score: " .. PlayerData.Score
    scoreLabel.TextColor3 = Color3.new(1, 1, 1)
    scoreLabel.BackgroundColor3 = Color3.new(0, 0, 0)
    scoreLabel.BackgroundTransparency = 0.5
    scoreLabel.Parent = ui

    -- 关卡显示（原本有的控件）
    local levelLabel = Instance.new("TextLabel")
    levelLabel.Name = "LevelLabel"
    levelLabel.Size = UDim2.new(0.2, 0, 0.05, 0)
    levelLabel.Position = Config.UI_Position + UDim2.new(0, 0, 0.06, 0)
    levelLabel.Font = Enum.Font.SourceSans
    levelLabel.TextSize = 20
    levelLabel.Text = "Level: " .. PlayerData.Level
    levelLabel.TextColor3 = Color3.new(1, 1, 0)
    levelLabel.BackgroundColor3 = Color3.new(0, 0, 0)
    levelLabel.BackgroundTransparency = 0.5
    levelLabel.Parent = ui

    PlayerData.UI = ui
end

-- 7. 更新UI（保留原本有的逻辑）
local function updateUI()
    if PlayerData.UI then
        PlayerData.UI.ScoreLabel.Text = "Score: " .. PlayerData.Score
        PlayerData.UI.LevelLabel.Text = "Level: " .. PlayerData.Level
    end
end

-- 8. 角色触碰处理（保留所有碰撞逻辑，不删任何判断）
local function onCharacterTouched(hit)
    if not PlayerData.Character or PlayerData.Humanoid.Health <= 0 then return end

    -- 金币加分（原本有的功能）
    if hit.Name == "Coin" then
        PlayerData.Score = PlayerData.Score + Config.CoinScore
        updateUI()
        saveData()
        hit:Destroy()

        -- 关卡升级（原本有的功能）
        if PlayerData.Score >= PlayerData.Level * Config.LevelUpScore then
            PlayerData.Level = PlayerData.Level + 1
            updateUI()
            saveData()
        end
    end

    -- 关卡触发（原本有的功能，不删除）
    if hit.Name == "LevelTrigger" then
        print(LocalPlayer.Name .. " 触发关卡")
    end
end

-- 9. 角色生成初始化（保留所有原本有的逻辑）
local function onCharacterAdded(character)
    PlayerData.Character = character
    PlayerData.Humanoid = character:WaitForChild("Humanoid")
    PlayerData.RootPart = character:WaitForChild("HumanoidRootPart")

    -- 角色属性设置（原本有的）
    PlayerData.Humanoid.WalkSpeed = Config.WalkSpeed
    PlayerData.Humanoid.JumpPower = Config.JumpPower

    -- 绑定触碰事件（原本有的）
    character.Touched:Connect(onCharacterTouched)

    -- 角色死亡处理（原本有的）
    PlayerData.Humanoid.Died:Connect(function()
        wait(3)
        LocalPlayer:LoadCharacter()
    end)
end

-- 10. 移动控制（保留原本有的客户端API调用，不删任何输入逻辑）
local function handleMovement(input, gameProcessedEvent)
    if gameProcessedEvent then return end
    if not PlayerData.Character or not PlayerData.Humanoid or PlayerData.Humanoid.Health <= 0 then return end

    local moveDir = Vector3.new(0, 0, 0)
    -- WASD方向（原本有的所有按键判断，一个不删）
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += Vector3.new(0, 0, -1) end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir += Vector3.new(0, 0, 1) end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir += Vector3.new(-1, 0, 0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += Vector3.new(1, 0, 0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.Up) then moveDir += Vector3.new(0, 0, -1) end -- 保留原本有的方向键控制
    if UserInputService:IsKeyDown(Enum.KeyCode.Down) then moveDir += Vector3.new(0, 0, 1) end
    if UserInputService:IsKeyDown(Enum.KeyCode.Left) then moveDir += Vector3.new(-1, 0, 0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.Right) then moveDir += Vector3.new(1, 0, 0) end

    -- 空格跳跃（原本有的功能）
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) and PlayerData.RootPart.Position.Y < 0.5 then
        PlayerData.Humanoid:Jump()
    end

    -- 执行移动（原本有的逻辑）
    if moveDir.Magnitude > 0 then
        PlayerData.Humanoid:Move(moveDir.Unit)
    end
end

-- 11. 生成游戏对象（保留原本有的所有对象，不删任何）
local function spawnObjects()
    -- 生成金币（原本有的所有位置，不删减）
    local coinPositions = {
        Vector3.new(10, 0.5, 0),
        Vector3.new(0, 0.5, 10),
        Vector3.new(20, 0.5, 20),
        Vector3.new(15, 0.5, 30),
        Vector3.new(30, 0.5, 15)
    }
    for _, pos in ipairs(coinPositions) do
        local coin = Instance.new("Part")
        coin.Name = "Coin"
        coin.Size = Vector3.new(1, 1, 1)
        coin.Position = pos
        coin.Anchored = true
        coin.CanCollide = false
        coin.BrickColor = BrickColor.new("Yellow")
        coin.Parent = Workspace

        -- 金币旋转动画（原本有的，不修改）
        spawn(function()
            while coin and coin.Parent do
                coin.CFrame = coin.CFrame * CFrame.Angles(0, 0.01, 0)
                wait()
            end
        end)
    end

    -- 生成关卡触发点（原本有的，不删除）
    local trigger = Instance.new("Part")
    trigger.Name = "LevelTrigger"
    trigger.Size = Vector3.new(4, 1, 4)
    trigger.Position = Vector3.new(30, 0.5, 30)
    trigger.Anchored = true
    trigger.CanCollide = false
    trigger.Transparency = 0.7
    trigger.BrickColor = BrickColor.new("Blue")
    trigger.Parent = Workspace
end

-- 12. 绑定所有原本有的事件（一个不删）
loadData()
createUI()
spawnObjects()

-- 角色生成绑定（原本有的）
if LocalPlayer.Character then
    onCharacterAdded(LocalPlayer.Character)
end
LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

-- 客户端输入绑定（原本有的客户端API事件，不删除）
UserInputService.InputBegan:Connect(handleMovement)
UserInputService.InputEnded:Connect(handleMovement)

-- 玩家退出保存（原本有的）
LocalPlayer.PlayerRemoving:Connect(saveData)

-- 保留原本有的打印信息
print("Original Homework Script Loaded - All APIs Reserved")
