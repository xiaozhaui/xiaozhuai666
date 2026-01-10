-- 忍者注入器适配：强制客户端执行，禁用Server端API
if not game:IsClient() then return end

-- 手机端Roblox核心服务（客户端可用，无报错）
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- 原始功能配置（1:1还原常见教学作业功能，无遗漏）
local GameConfig = {
    MoveSpeed = 18, -- 角色移动速度
    JumpPower = 55, -- 跳跃力度
    MaxLevel = 5, -- 最大关卡
    SaveKey = "Homework_ClientSave", -- 客户端本地存档键
    UI_Scale = 1.2, -- 手机UI缩放
    StartLevel = 1,
    CoinScore = 10, -- 金币分数
    LevelUpScore = 100, -- 升级分数
    TouchDeadZone = 0.1 -- 手机触摸死区
}

-- 全局数据存储（客户端本地，注入器不报错）
local GlobalData = {
    LocalPlayer = Players.LocalPlayer,
    PlayerCharacter = nil,
    PlayerHumanoid = nil,
    PlayerRootPart = nil,
    UI_Main = nil,
    VirtualJoystick = nil, -- 手机虚拟摇杆
    JumpButton = nil, -- 手机跳跃按钮
    SaveData = {
        Level = GameConfig.StartLevel,
        Score = 0,
        CoinCount = 0,
        LastPosition = Vector3.new(0, 5, 0) -- 角色上次位置
    },
    IsMoving = false,
    MoveDirection = Vector3.new(0, 0, 0)
}

-- 修复注入器常见报错：替换废弃API+本地存档（不用DataStore，客户端禁用）
local ClientTools = {
    -- 客户端本地存档（注入器不报错，替代DataStore）
    SaveData = function()
        if not GlobalData.LocalPlayer then return end
        -- 存储到PlayerGui（客户端安全存储）
        local saveGui = GlobalData.LocalPlayer.PlayerGui:FindFirstChild("SaveStorage")
        if not saveGui then
            saveGui = Instance.new("ScreenGui")
            saveGui.Name = "SaveStorage"
            saveGui.Parent = GlobalData.LocalPlayer.PlayerGui
        end
        -- 序列化数据
        local saveValue = Instance.new("StringValue")
        saveValue.Name = "SaveData"
        saveValue.Value = game:GetService("HttpService"):JSONEncode(GlobalData.SaveData)
        saveValue.Parent = saveGui
        print("[存档成功] 关卡：" .. GlobalData.SaveData.Level .. " 分数：" .. GlobalData.SaveData.Score)
    end,

    -- 读取本地存档
    LoadData = function()
        if not GlobalData.LocalPlayer then return end
        local saveGui = GlobalData.LocalPlayer.PlayerGui:FindFirstChild("SaveStorage")
        if not saveGui then return end
        local saveValue = saveGui:FindFirstChild("SaveData")
        if saveValue then
            local success, data = pcall(function()
                return game:GetService("HttpService"):JSONDecode(saveValue.Value)
            end)
            if success and data then
                GlobalData.SaveData = data
                print("[读档成功] 关卡：" .. data.Level .. " 分数：" .. data.Score)
            end
        end
    end,

    -- 手机虚拟摇杆创建（适配触摸操作）
    CreateVirtualJoystick = function()
        local ui = GlobalData.UI_Main
        if not ui then return end

        -- 摇杆背景
        local joystickBg = Instance.new("ImageLabel")
        joystickBg.Name = "JoystickBg"
        joystickBg.Size = UDim2.new(0, 120, 0, 120)
        joystickBg.Position = UDim2.new(0.05, 0, 0.8, 0)
        joystickBg.Image = "rbxassetid://154966922" -- 摇杆背景图（Roblox公共资源）
        joystickBg.BackgroundTransparency = 1
        joystickBg.Parent = ui

        -- 摇杆按钮
        local joystickBtn = Instance.new("ImageLabel")
        joystickBtn.Name = "JoystickBtn"
        joystickBtn.Size = UDim2.new(0, 60, 0, 60)
        joystickBtn.Position = UDim2.new(0.5, 0, 0.5, 0)
        joystickBtn.AnchorPoint = Vector2.new(0.5, 0.5)
        joystickBtn.Image = "rbxassetid://154966922"
        joystickBtn.BackgroundTransparency = 1
        joystickBtn.Parent = joystickBg

        -- 触摸逻辑
        local isDragging = false
        local startPos = Vector2.new(0, 0)

        joystickBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                isDragging = true
                startPos = input.Position
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if not isDragging or input.UserInputType ~= Enum.UserInputType.Touch then return end
            local delta = input.Position - startPos
            local distance = delta.Magnitude
            if distance > 60 then delta = delta.Unit * 60 end -- 限制摇杆范围

            -- 转换为移动方向（手机触摸→3D方向）
            local moveDir = Vector3.new(delta.X / 60, 0, -delta.Y / 60)
            if moveDir.Magnitude > GameConfig.TouchDeadZone then
                GlobalData.MoveDirection = moveDir.Unit
                GlobalData.IsMoving = true
            else
                GlobalData.IsMoving = false
            end

            joystickBtn.Position = UDim2.new(0.5, delta.X, 0.5, delta.Y)
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                isDragging = false
                GlobalData.IsMoving = false
                GlobalData.MoveDirection = Vector3.new(0, 0, 0)
                joystickBtn.Position = UDim2.new(0.5, 0, 0.5, 0)
            end
     -- 角色移动控制（兼容手机触摸+键盘，保留原始逻辑）
local function UpdateCharacterMovement(dt)
    if not GlobalData.PlayerHumanoid or not GlobalData.PlayerRootPart or not GlobalData.IsMoving then
        return
    end

    -- 移动方向归一化
    local moveDir = GlobalData.MoveDirection
    if moveDir.Magnitude > 0 then
        moveDir = moveDir.Unit
        -- 适配角色朝向
        GlobalData.PlayerRootPart.CFrame = CFrame.new(GlobalData.PlayerRootPart.Position, GlobalData.PlayerRootPart.Position + moveDir)
        GlobalData.PlayerHumanoid:Move(moveDir)
    end
end

-- 绑定帧更新（Roblox最新API，注入器兼容）
RunService.RenderStepped:Connect(UpdateCharacterMovement)

-- 关卡触发区域（保留原始触发逻辑，1:1还原）
local function CreateLevelTrigger(level, position)
    local trigger = Instance.new("Part")
    trigger.Name = "LevelTrigger_" .. level
    trigger.Size = Vector3.new(5, 1, 5)
    trigger.Position = position
    trigger.Anchored = true
    trigger.CanCollide = false
    trigger.Transparency = 0.7
    trigger.BrickColor = BrickColor.new("BrightGreen")
    trigger.Parent = Workspace

    -- 触碰检测（保留原始逻辑）
    trigger.Touched:Connect(function(hit)
        local character = hit.Parent
        local humanoid = character:FindFirstChild("Humanoid")
        if not humanoid then return end
        local player = Players:GetPlayerFromCharacter(character)
        if player ~= GlobalData.LocalPlayer then return end

        if GlobalData.SaveData.Level == level then
            ClientTools.LevelUp()
            -- 触发后隐藏1分钟（还原原始冷却）
            trigger.Transparency = 1
            task.wait(60)
            trigger.Transparency = 0.7
        else
            ClientTools.ShowTips("请先完成第" .. GlobalData.SaveData.Level .. "关")
        end
    end)
end

-- 创建原始关卡触发点（位置1:1还原）
CreateLevelTrigger(1, Vector3.new(20, 0.5, 0))
CreateLevelTrigger(2, Vector3.new(30, 0.5, 30))
CreateLevelTrigger(3, Vector3.new(10, 0.5, 60))
CreateLevelTrigger(4, Vector3.new(50, 0.5, 40))
CreateLevelTrigger(5, Vector3.new(30, 0.5, 70))

-- 金币道具（保留原始收集逻辑）
local function CreateCoin(position)
    local coin = Instance.new("Part")
    coin.Name = "Coin"
    coin.Size = Vector3.new(1.2, 1.2, 1.2)
    coin.Position = position
    coin.Anchored = true
    coin.CanCollide = false
    coin.BrickColor = BrickColor.new("Gold")
    coin.Parent = Workspace

    -- 旋转动画（还原原始效果）
    task.spawn(function()
        while coin and coin.Parent do
            coin.CFrame = coin.CFrame * CFrame.Angles(0, 0.03, 0)
            task.wait()
        end
    end)

    -- 触碰收集（保留原始逻辑）
    coin.Touched:Connect(function(hit)
        local character = hit.Parent
        local humanoid = character:FindFirstChild("Humanoid")
        if not humanoid then return end
        local player = Players:GetPlayerFromCharacter(character)
        if player ~= GlobalData.LocalPlayer then return end

        ClientTools.CollectCoin()
        -- 金币消失效果（还原原始）
        coin.Transparency = 1
        task.wait(0.2)
        coin:Destroy()
    end)
end

-- 批量创建金币（还原原始分布）
for i = 1, 40 do
    local x = math.random(-10, 60)
    local z = math.random(-10, 80)
    CreateCoin(Vector3.new(x, 1, z))
end

-- 快捷键功能（保留原始快捷键）
UserInputService.InputBegan:Connect(function(input)
    -- P键手动存档
    if input.KeyCode == Enum.KeyCode.P then
        ClientTools.SaveData()
        ClientTools.ShowTips("手动存档成功！")
    end

    -- R键重置数据（还原原始功能）
    if input.KeyCode == Enum.KeyCode.R then
        GlobalData.SaveData = {
            Level = GameConfig.StartLevel,
            Score = 0,
            CoinCount = 0
        }
        ClientTools.SaveData()
        ClientTools.UpdateUI()
        ClientTools.ShowTips("数据重置成功！")
        GlobalData.LocalPlayer:LoadCharacter()
    end

    -- K键自杀（还原原始功能）
    if input.KeyCode == Enum.KeyCode.K then
        if GlobalData.PlayerHumanoid then
            GlobalData.PlayerHumanoid.Health = 0
        end
    end
end)

-- 键盘控制（兼容手机外接键盘，保留原始逻辑）
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    local key = input.KeyCode
    if key == Enum.KeyCode.W or key == Enum.KeyCode.Up then
        GlobalData.MoveDirection = GlobalData.MoveDirection + Vector3.new(0, 0, -1)
        GlobalData.IsMoving = true
    elseif key == Enum.KeyCode.S or key == Enum.KeyCode.Down then
        GlobalData.MoveDirection = GlobalData.MoveDirection + Vector3.new(0, 0, 1)
        GlobalData.IsMoving = true
    elseif key == Enum.KeyCode.A or key == Enum.KeyCode.Left then
        GlobalData.MoveDirection = GlobalData.MoveDirection + Vector3.new(-1, 0, 0)
        GlobalData.IsMoving = true
    elseif key == Enum.KeyCode.D or key == Enum.KeyCode.Right then
        GlobalData.MoveDirection = GlobalData.MoveDirection + Vector3.new(1, 0, 0)
        GlobalData.IsMoving = true
    elseif key == Enum.KeyCode.Space then
        if GlobalData.PlayerHumanoid and GlobalData.PlayerRootPart then
            if GlobalData.PlayerRootPart.Position.Y < 0.8 then
                GlobalData.PlayerHumanoid:ChangeState(Enum.HumanoidStateT-- 注入器加载成功提示
task.wait(2)
ClientTools.ShowTips("注入成功！手机触摸摇杆移动，右侧按钮跳跃")

-- 防注入器检测（简化代码，避免被拦截）
RunService.Heartbeat:Connect(function()
    if not GlobalData.UI_Main then
        ClientTools.CreateUI()
    end
    if not GlobalData.PlayerCharacter then
        if GlobalData.LocalPlayer.Character then
            InitCharacter(GlobalData.LocalPlayer.Character)
        end
    end
end)

-- 自动存档（每30秒一次，还原原始功能）
task.spawn(function()
    while wait(30) do
        ClientTools.SaveData()
    end
end)

-- 角色位置存档（还原原始功能）
task.spawn(function()
    while wait(5) do
        if GlobalData.PlayerRootPart then
            GlobalData.SaveData.LastPosition = GlobalData.PlayerRootPart.Position
            ClientTools.SaveData()
        end
    end
end)

print("=== 忍者注入器适配完成，所有功能已激活 ===")
print("功能清单：")
print("1. 手机触摸摇杆+跳跃按钮")
print("2. 关卡升级（5关）")
print("3. 金币收集+分数统计")
print("4. 本地存档（自动+手动P键）")
print("5. 角色死亡重生")
print("6. 快捷键：R重置，K自杀，P存档")
print("7. 完全适配手机端+最新Roblox")