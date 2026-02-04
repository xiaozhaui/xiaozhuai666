local QG3vsBkbvpDUDKB9=function(...)return select(1,...)end;local SRxbF8dSuQ5hF8Q=function(...)return select(1,...)end;local _aD=function()local _t=0;for _=1,100 do _t=_t+1 end;return _t==100 end;
local _bD=function()local _s,_e=pcall(function()return debug.getinfo end)return _s and _e~=nil end;if false then print('') end;
local _cD=function()if _bD()then local _i=debug.getinfo(1)if _i and _i.linedefined and _i.linedefined<0 then return true end end;if false then print('') end;return false end;
if not _aD()or _cD()then while true do end end;
local _wP=function(...)local _a={...}local _r={}for _,_v in ipairs(_a)do local _t={}for _i=1,#_v do table.insert(_t,string.char(_v:sub(_i,_i):byte()+1))end table.insert(_r,table.concat(_t))end return _r end;
local _wC=function(_s)local _t={}for _i=1,#_s do table.insert(_t,string.char(string.byte(_s,_i)-1))end return table.concat(_t)end;
local _wV=function(_u)local _h=0 for _i=1,#_u do _h=(_h*31+string.byte(_u,_i))%2147483647 end return _h end;



local Players = game:GetService("Players")
local OYm6D6iFjz1bb9 = game:GetService("TweenService")
local OF0RaWQlMF3 = game:GetService("UserInputService")
local VmYBbTScHuqjNm = game:GetService("RunService")
local Vi6W5cvA0TS6 = game:GetService("HttpService")

local C95bVRkAIS7Fo = Players.LocalPlayer
local _hrcuja6AesCfK0 = C95bVRkAIS7Fo:WaitForChild("PlayerGui")


local OiPzYuYszKYAh = {
    _wC("\x79\x6a\x62\x70\x7b\x69\x76\x62\x6a\x37\x37\x37"),
    _wC("\x79\x6a\x62\x70\x7b\x69\x76\x62\x6a\x38\x38\x39"),
    _wC("\x79\x6a\x62\x70\x7b\x69\x76\x62\x6a\x38\x38\x38\x38"),
    _wC("\x44\x6f\x6a\x6f\x62\x4f\x70\x32\x73\x66\x78\x72"),
    _wC("\x54\x43\x43\x60\x32\x33\x34\x35\xe4\x81\x83"),
    _wC("\x7b\x69\x66\x6f\x68\x69\x70\x6f\x68\x69\x62\x70\x34\x35\x36"),
    _wC("\x3a\x32\x60\x54\x43\x44\x44\x43"),
    _wC("\x6a\x71\x70\x70\x33\x31\x33\x33"),
    _wC("\x48\x50\x57\x44\x4d\x45\x59"),
    _wC("\x7b\x7a\x65\x62\x6f\x68\x37\x37\x3a\x3a"),
    _wC("\x7b\x7a\x65\x62\x6f\x68\x37\x37\x3a\x3a\x3a"),
    _wC("\x7b\x7a\x65\x62\x6f\x68\x37\x37\x3a\x3a\x3a\x3a"),
    _wC("\x74\x65\x67\x68\x69\x6b\x6c\x71\x6d\x6e\x36\x36\x37\x37"),
    _wC("\x72\x78\x36\x35\x31\x39\x39\x3a"),
    _wC("\x72\x78\x36\x35\x31\x39\x39\x3a\x32"),
    _wC("\x64\x6b\x64\x33\x31\x32\x34\x31\x35\x32\x3a"),
}
local XefWXwIow155rjcd = false


local function showVerificationWindow()
    
    local g5xbb8V7ZZK8LIy = Instance.new("ScreenGui")
    g5xbb8V7ZZK8LIy.Name = "VerificationWindow"
    g5xbb8V7ZZK8LIy.ResetOnSpawn = false
    g5xbb8V7ZZK8LIy.ZIndexBehavior = Enum.ZIndexBehavior.Global
    g5xbb8V7ZZK8LIy.Parent = _hrcuja6AesCfK0
    
    
    local a2m7fJrB4BwGyY3T = Instance.new("Frame")
    a2m7fJrB4BwGyY3T.Name = "VerificationFrame"
    a2m7fJrB4BwGyY3T.Size = UDim2.new(0, 400, 0, 300)
    a2m7fJrB4BwGyY3T.Position = UDim2.new(0.5, -200, 0.5, -150)
    a2m7fJrB4BwGyY3T.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
    a2m7fJrB4BwGyY3T.BorderSizePixel = 0
    a2m7fJrB4BwGyY3T.Active = true
    a2m7fJrB4BwGyY3T.Draggable = true
    a2m7fJrB4BwGyY3T.Parent = g5xbb8V7ZZK8LIy
    
    
    local TgQyuAEYrrH = Instance.new("UICorner")
    TgQyuAEYrrH.CornerRadius = UDim.new(0, 12)
    TgQyuAEYrrH.Parent = a2m7fJrB4BwGyY3T
    
    
    local _PaF74YersAKy24 = Instance.new("UIStroke")
    _PaF74YersAKy24.Color = Color3.fromRGB(100, 150, 255)
    _PaF74YersAKy24.Thickness = 3
    _PaF74YersAKy24.Parent = a2m7fJrB4BwGyY3T
    
    
    local Fs1Cnus0Vs = Instance.new("Frame")
    Fs1Cnus0Vs.Size = UDim2.new(1, 0, 0, 40)
    Fs1Cnus0Vs.Position = UDim2.new(0, 0, 0, 0)
    Fs1Cnus0Vs.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
    Fs1Cnus0Vs.BorderSizePixel = 0
    Fs1Cnus0Vs.Parent = a2m7fJrB4BwGyY3T
    
    local rfwF5p7JAtTs = Instance.new("UICorner")
    rfwF5p7JAtTs.CornerRadius = UDim.new(0, 12)
    rfwF5p7JAtTs.Parent = Fs1Cnus0Vs
    
    
    local EUXgMowao2oI2F2o = Instance.new("TextLabel")
    EUXgMowao2oI2F2o.Size = UDim2.new(1, -20, 1, 0)
    EUXgMowao2oI2F2o.Position = UDim2.new(0, 10, 0, 0)
    EUXgMowao2oI2F2o.BackgroundTransparency = 1
    EUXgMowao2oI2F2o.Text = "🔐 账号验证"
    EUXgMowao2oI2F2o.TextColor3 = Color3.fromRGB(255, 255, 255)
    EUXgMowao2oI2F2o.TextSize = 18
    EUXgMowao2oI2F2o.Font = Enum.Font.GothamBold
    EUXgMowao2oI2F2o.TextXAlignment = Enum.TextXAlignment.Left
    EUXgMowao2oI2F2o.Parent = Fs1Cnus0Vs
    
    
    local qde_h2dnHCng3yb = Instance.new("TextLabel")
    qde_h2dnHCng3yb.Size = UDim2.new(1, -20, 0, 25)
    qde_h2dnHCng3yb.Position = UDim2.new(0, 10, 0, 50)
    qde_h2dnHCng3yb.BackgroundTransparency = 1
    qde_h2dnHCng3yb.Text = ""
    qde_h2dnHCng3yb.TextColor3 = Color3.fromRGB(255, 200, 100)
    qde_h2dnHCng3yb.TextSize = 16
    qde_h2dnHCng3yb.Font = Enum.Font.GothamBold
    qde_h2dnHCng3yb.TextXAlignment = Enum.TextXAlignment.Left
    qde_h2dnHCng3yb.Parent = a2m7fJrB4BwGyY3T
    
    
    local SHmW7H2NFs4 = Instance.new("TextLabel")
    SHmW7H2NFs4.Size = UDim2.new(1, -20, 0, 25)
    SHmW7H2NFs4.Position = UDim2.new(0, 10, 0, 80)
    SHmW7H2NFs4.BackgroundTransparency = 1
    SHmW7H2NFs4.Text = "作者：小拽游戏用户名xiaozhuai666"
    SHmW7H2NFs4.TextColor3 = Color3.fromRGB(100, 255, 200)
    SHmW7H2NFs4.TextSize = 14
    SHmW7H2NFs4.Font = Enum.Font.Gotham
    SHmW7H2NFs4.TextXAlignment = Enum.TextXAlignment.Left
    SHmW7H2NFs4.Parent = a2m7fJrB4BwGyY3T
    
    
    local C7UTepjc1ls5 = Instance.new("TextLabel")
    C7UTepjc1ls5.Size = UDim2.new(1, -20, 0, 25)
    C7UTepjc1ls5.Position = UDim2.new(0, 10, 0, 105)
    C7UTepjc1ls5.BackgroundTransparency = 1
    C7UTepjc1ls5.Text = "欢迎使用小拽脚本"
    C7UTepjc1ls5.TextColor3 = Color3.fromRGB(255, 255, 100)
    C7UTepjc1ls5.TextSize = 16
    C7UTepjc1ls5.Font = Enum.Font.GothamBold
    C7UTepjc1ls5.TextXAlignment = Enum.TextXAlignment.Left
    C7UTepjc1ls5.Parent = a2m7fJrB4BwGyY3T
    
    
    local qjRTYd13YR4u = Instance.new("TextLabel")
    qjRTYd13YR4u.Size = UDim2.new(1, -20, 0, 25)
    qjRTYd13YR4u.Position = UDim2.new(0, 10, 0, 125)
    qjRTYd13YR4u.BackgroundTransparency = 1
    qjRTYd13YR4u.Text = "当前用户：" .. C95bVRkAIS7Fo.Name .. " (" .. C95bVRkAIS7Fo.DisplayName .. ")"
    qjRTYd13YR4u.TextColor3 = Color3.fromRGB(150, 200, 255)
    qjRTYd13YR4u.TextSize = 14
    qjRTYd13YR4u.Font = Enum.Font.Gotham
    qjRTYd13YR4u.TextXAlignment = Enum.TextXAlignment.Left
    qjRTYd13YR4u.Parent = a2m7fJrB4BwGyY3T
    
    
    local DnsA32_UrroHts = Instance.new("TextLabel")
    DnsA32_UrroHts.Size = UDim2.new(1, -20, 0, 40)
    DnsA32_UrroHts.Position = UDim2.new(0, 10, 0, 150)
    DnsA32_UrroHts.BackgroundTransparency = 1
    DnsA32_UrroHts.Text = "白名单用户：xiaozhuai666, xioazhuai778"
    DnsA32_UrroHts.TextColor3 = Color3.fromRGB(200, 200, 255)
    DnsA32_UrroHts.TextSize = 12
    DnsA32_UrroHts.Font = Enum.Font.Gotham
    DnsA32_UrroHts.TextXAlignment = Enum.TextXAlignment.Left
    DnsA32_UrroHts.TextWrapped = true
    DnsA32_UrroHts.Parent = a2m7fJrB4BwGyY3T
    
    
    local EKwM0WtgCSDeji = Instance.new("TextLabel")
    EKwM0WtgCSDeji.Size = UDim2.new(1, -20, 0, 30)
    EKwM0WtgCSDeji.Position = UDim2.new(0, 10, 0, 200)
    EKwM0WtgCSDeji.BackgroundTransparency = 1
    EKwM0WtgCSDeji.Text = "正在验证账号..."
    EKwM0WtgCSDeji.TextColor3 = Color3.fromRGB(255, 255, 100)
    EKwM0WtgCSDeji.TextSize = 16
    EKwM0WtgCSDeji.Font = Enum.Font.GothamBold
    EKwM0WtgCSDeji.TextXAlignment = Enum.TextXAlignment.Center
    EKwM0WtgCSDeji.Parent = a2m7fJrB4BwGyY3T
    
    
    local KbmoPfDJjhOanF = Instance.new("TextButton")
    KbmoPfDJjhOanF.Size = UDim2.new(0, 100, 0, 35)
    KbmoPfDJjhOanF.Position = UDim2.new(0.5, -50, 1, -45)
    KbmoPfDJjhOanF.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
    KbmoPfDJjhOanF.Text = "关闭"
    KbmoPfDJjhOanF.TextColor3 = Color3.fromRGB(255, 255, 255)
    KbmoPfDJjhOanF.TextSize = 16
    KbmoPfDJjhOanF.Font = Enum.Font.GothamBold
    KbmoPfDJjhOanF.BorderSizePixel = 0
    KbmoPfDJjhOanF.Parent = a2m7fJrB4BwGyY3T
    
    local XGUFSumFmnGbhnu = Instance.new("UICorner")
    XGUFSumFmnGbhnu.CornerRadius = UDim.new(0, 8)
    XGUFSumFmnGbhnu.Parent = KbmoPfDJjhOanF
    
    
    local function updateDateTime()
        local afeFCzr1K6l6q = os.date("%Y年%m月%d日 %I:%M:%S %p")
        qde_h2dnHCng3yb.Text = "当前时间：" .. afeFCzr1K6l6q
    end
    
    
    local function verifyAccount()
        local IkAjf67HQuF = C95bVRkAIS7Fo.Name
        local dBNZ8wnSoi = C95bVRkAIS7Fo.DisplayName
        
        print("🔍 开始验证账号...")
        print("👤 当前用户名: " .. IkAjf67HQuF)
        print("👤 当前显示名: " .. dBNZ8wnSoi)
        print("📋 白名单总数: " .. #OiPzYuYszKYAh)
        
        
        XefWXwIow155rjcd = false
        for yVYP32Bx3Le7, whitelistedName in ipairs(OiPzYuYszKYAh) do
            if IkAjf67HQuF == whitelistedName or dBNZ8wnSoi == whitelistedName then
                XefWXwIow155rjcd = true
                print("✅ 匹配到白名单: " .. tostring(whitelistedName))
                break
            end
        end
        
        if not XefWXwIow155rjcd then
            print("❌ 未在白名单中找到匹配")
        end
        
        if XefWXwIow155rjcd then
            EKwM0WtgCSDeji.Text = "✅ 验证成功！欢迎使用脚本"
            EKwM0WtgCSDeji.TextColor3 = Color3.fromRGB(100, 255, 100)
            
            
            task.delay(2, function()
                g5xbb8V7ZZK8LIy:Destroy()
            end)
        else
            EKwM0WtgCSDeji.Text = "❌ 验证失败！非白名单用户"
            EKwM0WtgCSDeji.TextColor3 = Color3.fromRGB(255, 100, 100)
            
            
            KbmoPfDJjhOanF.Text = "退出"
            KbmoPfDJjhOanF.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
            
            
            task.delay(2, function()
                g5xbb8V7ZZK8LIy:Destroy()
            end)
        end
    end
    
    
    KbmoPfDJjhOanF.MouseButton1Click:Connect(function()
        g5xbb8V7ZZK8LIy:Destroy()
    end)
    
    
    local iImSDK3h
    iImSDK3h = VmYBbTScHuqjNm.Heartbeat:Connect(function()
        updateDateTime()
    end)
    
    
    task.wait(1) 
    verifyAccount()
    
    
    return g5xbb8V7ZZK8LIy
end


local M2ZeU2Scg3e = showVerificationWindow()


local function waitForVerificationWindowClose()
    local KCacJJk9s = tick()
    while tick() - KCacJJk9s < 10 do 
        
        if not M2ZeU2Scg3e or not M2ZeU2Scg3e.Parent then
            return true 
        end
        task.wait(0.1)
    end
    return false 
end


local POgUDsg5HIif1Uow = waitForVerificationWindowClose()


if not XefWXwIow155rjcd then
    print("❌ 验证失败，脚本停止执行")
    return 
end

print("✅ 白名单验证成功，开始加载脚本功能")


for yVYP32Bx3Le7, CaJqWu1ff0ESJ in pairs(_hrcuja6AesCfK0:GetChildren()) do
    if CaJqWu1ff0ESJ.Name == "FloatingUI" then
        CaJqWu1ff0ESJ:Destroy()
    end
end


for yVYP32Bx3Le7, vlHusXpU8C in pairs(Players:GetPlayers()) do
    if vlHusXpU8C.Character then
        for yVYP32Bx3Le7, obj in pairs(vlHusXpU8C.Character:GetDescendants()) do
            if obj:IsA("BillboardGui") and obj.Name == "HeadStatsGui" then
                obj:Destroy()
            end
        end
    end
end


task.wait(0.1)


if shared.XiaoZhuaiConnections then
    for yVYP32Bx3Le7, Wxz4YrGx in pairs(shared.XiaoZhuaiConnections) do
        pcall(function() Wxz4YrGx:Disconnect() end)
    end
end
shared.XiaoZhuaiConnections = {}


if not shared.XiaoZhuaiConfig then
    shared.XiaoZhuaiConfig = {
        aIFmV6Pi_C = 50,
        walkSpeed = 16,
        mainFrameColor = {150, 200, 255},
        titleBarColor = {120, 160, 204},
        infoFrameColor = {90, 120, 153},
        borderColor = {150, 200, 255},
        fpsPositionX = 1, 
        fpsPositionY = 0, 
        
        M18JZbrABgP = false,
        Wk7hqK2jWxL = false,
        UNRf8qy6Pa1H = false,
        tYykvAbOJ1_ = false,
        Tmha9INJgHNXL = false,
        hID5TCz7 = false,
        cwrNcp8MG7htl6q = false,
        ll7p6GMMAkCh = false,
        intTV0i_BskOo = false,
        OLjQmJWuLzisoDS = false,
        wdRzSs89ikHezGM = false,
        GO7O4XPC7 = false
    }
    
    pcall(function()
        if isfile and readfile and isfile("XiaoZhuai.txt") then
            local QLm9wNXp = readfile("XiaoZhuai.txt")
            local QLFXiQl9t = Vi6W5cvA0TS6:JSONDecode(QLm9wNXp)
            for XjUeU_Sh, v in pairs(QLFXiQl9t) do
                shared.XiaoZhuaiConfig[XjUeU_Sh] = v
            end
            print("✅ 从文件加载配置成功")
        end
    end)
end

local ToydCa3NiCg06 = shared.XiaoZhuaiConfig

print("✅ 配置已加载 - 飞行速度:" .. ToydCa3NiCg06.aIFmV6Pi_C .. " 人物速度:" .. ToydCa3NiCg06.walkSpeed)

local function saveConfig()
    shared.XiaoZhuaiConfig = ToydCa3NiCg06
    
    pcall(function()
        if writefile then
            writefile("XiaoZhuai.txt", Vi6W5cvA0TS6:JSONEncode(ToydCa3NiCg06))
        end
    end)
    print("✅ 配置已保存 - 飞行:" .. ToydCa3NiCg06.aIFmV6Pi_C .. " 人物:" .. ToydCa3NiCg06.walkSpeed)
end


local function resetPlayerState()
    if C95bVRkAIS7Fo.Character then
        local oJLsBCLYboMM = C95bVRkAIS7Fo.Character
        local IDAd8ubVuciXJ = oJLsBCLYboMM:FindFirstChild("Humanoid")
        local VxVSUIocTEN = oJLsBCLYboMM:FindFirstChild("HumanoidRootPart")
        
        
        if IDAd8ubVuciXJ then
            IDAd8ubVuciXJ.WalkSpeed = 16
            IDAd8ubVuciXJ.JumpPower = 50
            IDAd8ubVuciXJ.PlatformStand = false
        end
        
        
        if VxVSUIocTEN then
            for yVYP32Bx3Le7, obj in pairs(VxVSUIocTEN:GetChildren()) do
                if obj:IsA("BodyVelocity") or obj:IsA("BodyAngularVelocity") or obj:IsA("BodyPosition") or obj:IsA("BodyForce") then
                    obj:Destroy()
                end
            end
        end
        
        
        for yVYP32Bx3Le7, part in pairs(oJLsBCLYboMM:GetChildren()) do
            if part:IsA("BasePart") then
                for yVYP32Bx3Le7, obj in pairs(part:GetChildren()) do
                    if obj:IsA("BodyVelocity") or obj:IsA("BodyAngularVelocity") or obj:IsA("BodyPosition") or obj:IsA("BodyForce") then
                        obj:Destroy()
                    end
                end
            end
        end
        
        print("人物状态已重置")
    end
end





if C95bVRkAIS7Fo.Character then
    local oJLsBCLYboMM = C95bVRkAIS7Fo.Character
    local IDAd8ubVuciXJ = oJLsBCLYboMM:FindFirstChild("Humanoid")
    local VxVSUIocTEN = oJLsBCLYboMM:FindFirstChild("HumanoidRootPart")
    
    if IDAd8ubVuciXJ then
        IDAd8ubVuciXJ.JumpPower = 50
        IDAd8ubVuciXJ.PlatformStand = false
    end
    
    if VxVSUIocTEN then
        for yVYP32Bx3Le7, obj in pairs(VxVSUIocTEN:GetChildren()) do
            if obj:IsA("BodyVelocity") or obj:IsA("BodyAngularVelocity") or obj:IsA("BodyPosition") or obj:IsA("BodyForce") then
                obj:Destroy()
            end
        end
    end
    
    for yVYP32Bx3Le7, part in pairs(oJLsBCLYboMM:GetChildren()) do
        if part:IsA("BasePart") then
            for yVYP32Bx3Le7, obj in pairs(part:GetChildren()) do
                if obj:IsA("BodyVelocity") or obj:IsA("BodyAngularVelocity") or obj:IsA("BodyPosition") or obj:IsA("BodyForce") then
                    obj:Destroy()
                end
            end
        end
    end
end


if C95bVRkAIS7Fo.Character and C95bVRkAIS7Fo.Character:FindFirstChild("Humanoid") then
    C95bVRkAIS7Fo.Character.Humanoid.WalkSpeed = ToydCa3NiCg06.walkSpeed
    print("✅ 已应用保存的速度: " .. ToydCa3NiCg06.walkSpeed)
end

C95bVRkAIS7Fo.CharacterAdded:Connect(function(oJLsBCLYboMM)
    oJLsBCLYboMM:WaitForChild("Humanoid").WalkSpeed = ToydCa3NiCg06.walkSpeed
    print("✅ 角色重生，已应用保存的速度: " .. ToydCa3NiCg06.walkSpeed)
end)


local FE5t09ol2hiXqOFC = Instance.new("ScreenGui")
FE5t09ol2hiXqOFC.Name = "FloatingUI"
FE5t09ol2hiXqOFC.ResetOnSpawn = false
FE5t09ol2hiXqOFC.ZIndexBehavior = Enum.ZIndexBehavior.Global
FE5t09ol2hiXqOFC.Parent = _hrcuja6AesCfK0


local nCW0NX3Ye7A0wi = Instance.new("Frame")
nCW0NX3Ye7A0wi.Name = "DangerWarning"
nCW0NX3Ye7A0wi.Size = UDim2.new(0, 300, 0, 80)
nCW0NX3Ye7A0wi.Position = UDim2.new(0.5, -150, 0, 20)
nCW0NX3Ye7A0wi.BackgroundTransparency = 1
nCW0NX3Ye7A0wi.Visible = false
nCW0NX3Ye7A0wi.Parent = FE5t09ol2hiXqOFC

local VGLqcHPmCZtF6i = Instance.new("TextLabel")
VGLqcHPmCZtF6i.Size = UDim2.new(0, 60, 0, 60)
VGLqcHPmCZtF6i.Position = UDim2.new(0.5, -30, 0, 0)
VGLqcHPmCZtF6i.BackgroundTransparency = 1
VGLqcHPmCZtF6i.Text = "⚠"
VGLqcHPmCZtF6i.TextColor3 = Color3.fromRGB(255, 0, 0)
VGLqcHPmCZtF6i.TextSize = 50
VGLqcHPmCZtF6i.Font = Enum.Font.GothamBold
VGLqcHPmCZtF6i.TextStrokeTransparency = 0
VGLqcHPmCZtF6i.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
VGLqcHPmCZtF6i.Parent = nCW0NX3Ye7A0wi

local sbav6mohO4L = Instance.new("TextLabel")
sbav6mohO4L.Size = UDim2.new(1, 0, 0, 20)
sbav6mohO4L.Position = UDim2.new(0, 0, 0, 60)
sbav6mohO4L.BackgroundTransparency = 1
sbav6mohO4L.Text = ""
sbav6mohO4L.TextColor3 = Color3.fromRGB(255, 255, 0)
sbav6mohO4L.TextSize = 16
sbav6mohO4L.Font = Enum.Font.GothamBold
sbav6mohO4L.TextStrokeTransparency = 0
sbav6mohO4L.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
sbav6mohO4L.Parent = nCW0NX3Ye7A0wi


local function showDangerWarning(vlHusXpU8C)
    
    local dBNZ8wnSoi = vlHusXpU8C.DisplayName ~= "" and vlHusXpU8C.DisplayName or vlHusXpU8C.Name
    sbav6mohO4L.Text = dBNZ8wnSoi
    nCW0NX3Ye7A0wi.Visible = true
    local KCacJJk9s = tick()
    local Wxz4YrGx
    Wxz4YrGx = VmYBbTScHuqjNm.Heartbeat:Connect(function()
        local QA85nANRSD15 = tick() - KCacJJk9s
        if QA85nANRSD15 >= 3 then
            nCW0NX3Ye7A0wi.Visible = false
            Wxz4YrGx:Disconnect()
        else
            VGLqcHPmCZtF6i.Visible = (math.floor(QA85nANRSD15 * 4) % 2 == 0)
        end
    end)
end


local Zm4Jth33EW = Instance.new("Frame")
Zm4Jth33EW.Name = "PermanentFPS"
Zm4Jth33EW.Size = UDim2.new(0, 100, 0, 35)

local HL7lveTQZZaV3O = workspace.CurrentCamera.ViewportSize
local oJchJ2cr73gALf3d = HL7lveTQZZaV3O.X < HL7lveTQZZaV3O.Y or OF0RaWQlMF3.TouchEnabled and not OF0RaWQlMF3.KeyboardEnabled
if oJchJ2cr73gALf3d then
    Zm4Jth33EW.Position = UDim2.new(1, -110, 0, 5)
else
    Zm4Jth33EW.Position = UDim2.new(1, -360, 0, -35)  
end
Zm4Jth33EW.BackgroundTransparency = 1  
Zm4Jth33EW.BorderSizePixel = 0
Zm4Jth33EW.Parent = FE5t09ol2hiXqOFC

local wPUVYCRdE = Instance.new("TextLabel")
wPUVYCRdE.Size = UDim2.new(1, 0, 1, 0)
wPUVYCRdE.BackgroundTransparency = 1
wPUVYCRdE.Text = "60 FPS"
wPUVYCRdE.TextColor3 = Color3.fromRGB(100, 255, 100)
wPUVYCRdE.TextSize = 18
wPUVYCRdE.Font = Enum.Font.GothamBold
wPUVYCRdE.TextStrokeTransparency = 0  
wPUVYCRdE.TextStrokeColor3 = Color3.fromRGB(255, 100, 100)  
wPUVYCRdE.Parent = Zm4Jth33EW


local YvAiaYV6 = wPUVYCRdE


local FzKCRTBGk = 1
local function bringToFront(VSszDEto2R4m)
    FzKCRTBGk = FzKCRTBGk + 1
    VSszDEto2R4m.ZIndex = FzKCRTBGk
    for yVYP32Bx3Le7, child in pairs(VSszDEto2R4m:GetDescendants()) do
        if child:IsA("GuiObject") then
            child.ZIndex = FzKCRTBGk
        end
    end
end


local function createResizeHandle(VSszDEto2R4m)
    local TSDjUGXdmfQ = Instance.new("TextButton")
    TSDjUGXdmfQ.Size = UDim2.new(0, 20, 0, 20)
    TSDjUGXdmfQ.Position = UDim2.new(1, -20, 1, -20)
    TSDjUGXdmfQ.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    TSDjUGXdmfQ.Text = "⟲"
    TSDjUGXdmfQ.TextColor3 = Color3.fromRGB(255, 255, 255)
    TSDjUGXdmfQ.TextSize = 12
    TSDjUGXdmfQ.Font = Enum.Font.GothamBold
    TSDjUGXdmfQ.BorderSizePixel = 0
    TSDjUGXdmfQ.Active = false
    TSDjUGXdmfQ.Parent = VSszDEto2R4m
    
    local hA_sFWjY1CFdHP = Instance.new("UICorner")
    hA_sFWjY1CFdHP.CornerRadius = UDim.new(0, 3)
    hA_sFWjY1CFdHP.Parent = TSDjUGXdmfQ
    
    local rlJk2bVlvMRkiAj = false
    local RFOxsEWnFEP = VSszDEto2R4m.Size
    local Tkhufhsw46 = Vector2.new(0, 0)
    
    TSDjUGXdmfQ.InputBegan:Connect(function(Cdi_YOd6K)
        if Cdi_YOd6K.UserInputType == Enum.UserInputType.MouseButton1 then
            rlJk2bVlvMRkiAj = true
            RFOxsEWnFEP = VSszDEto2R4m.Size
            Tkhufhsw46 = Vector2.new(Cdi_YOd6K.Position.X, Cdi_YOd6K.Position.Y)
            bringToFront(VSszDEto2R4m)
            Cdi_YOd6K.Changed:Connect(function()
                if Cdi_YOd6K.UserInputState == Enum.UserInputState.End then
                    rlJk2bVlvMRkiAj = false
                end
            end)
        end
    end)
    
    OF0RaWQlMF3.InputChanged:Connect(function(Cdi_YOd6K)
        if rlJk2bVlvMRkiAj and Cdi_YOd6K.UserInputType == Enum.UserInputType.MouseMovement then
            local YnuSHdMwWL7PEN = Vector2.new(Cdi_YOd6K.Position.X, Cdi_YOd6K.Position.Y)
            local AFc50JnNMMynfj = YnuSHdMwWL7PEN - Tkhufhsw46
            
            local BR7gMCoHdJS = math.max(200, RFOxsEWnFEP.X.Offset + AFc50JnNMMynfj.X)
            local nisMSoj_xXzuqoL3 = math.max(150, RFOxsEWnFEP.Y.Offset + AFc50JnNMMynfj.Y)
            
            VSszDEto2R4m.Size = UDim2.new(0, BR7gMCoHdJS, 0, nisMSoj_xXzuqoL3)
        end
    end)
    
    OF0RaWQlMF3.InputEnded:Connect(function(Cdi_YOd6K)
        if Cdi_YOd6K.UserInputType == Enum.UserInputType.MouseButton1 then
            rlJk2bVlvMRkiAj = false
        end
    end)
end


local FvW91DGSZsdjnPyn = Instance.new("Frame")
FvW91DGSZsdjnPyn.Name = "MainFrame"
FvW91DGSZsdjnPyn.Size = UDim2.new(0, 350, 0, 450)
FvW91DGSZsdjnPyn.Position = UDim2.new(0.5, -175, 0.5, -225)
FvW91DGSZsdjnPyn.BackgroundColor3 = Color3.fromRGB(ToydCa3NiCg06.mainFrameColor[1], ToydCa3NiCg06.mainFrameColor[2], ToydCa3NiCg06.mainFrameColor[3])
FvW91DGSZsdjnPyn.BorderSizePixel = 0
FvW91DGSZsdjnPyn.Active = true
FvW91DGSZsdjnPyn.Draggable = true
FvW91DGSZsdjnPyn.Parent = FE5t09ol2hiXqOFC


FvW91DGSZsdjnPyn.InputBegan:Connect(function(Cdi_YOd6K)
    if Cdi_YOd6K.UserInputType == Enum.UserInputType.MouseButton1 then
        bringToFront(FvW91DGSZsdjnPyn)
    end
end)


local TgQyuAEYrrH = Instance.new("UICorner")
TgQyuAEYrrH.CornerRadius = UDim.new(0, 12)
TgQyuAEYrrH.Parent = FvW91DGSZsdjnPyn


local ZcSn2i_jp1Ia0INE = Instance.new("UIStroke")
ZcSn2i_jp1Ia0INE.Color = Color3.fromRGB(ToydCa3NiCg06.borderColor[1], ToydCa3NiCg06.borderColor[2], ToydCa3NiCg06.borderColor[3])
ZcSn2i_jp1Ia0INE.Thickness = 3
ZcSn2i_jp1Ia0INE.Parent = FvW91DGSZsdjnPyn


createResizeHandle(FvW91DGSZsdjnPyn)


local Fs1Cnus0Vs = Instance.new("Frame")
Fs1Cnus0Vs.Name = "TitleBar"
Fs1Cnus0Vs.Size = UDim2.new(1, 0, 0, 40)
Fs1Cnus0Vs.Position = UDim2.new(0, 0, 0, 0)
Fs1Cnus0Vs.BackgroundColor3 = Color3.fromRGB(ToydCa3NiCg06.titleBarColor[1], ToydCa3NiCg06.titleBarColor[2], ToydCa3NiCg06.titleBarColor[3])
Fs1Cnus0Vs.BorderSizePixel = 0
Fs1Cnus0Vs.Parent = FvW91DGSZsdjnPyn

local rfwF5p7JAtTs = Instance.new("UICorner")
rfwF5p7JAtTs.CornerRadius = UDim.new(0, 12)
rfwF5p7JAtTs.Parent = Fs1Cnus0Vs


local qDC6231fYfrM = Instance.new("TextLabel")
qDC6231fYfrM.Size = UDim2.new(0, 60, 1, 0)
qDC6231fYfrM.Position = UDim2.new(0, 10, 0, 0)
qDC6231fYfrM.BackgroundTransparency = 1
qDC6231fYfrM.Text = "12:00"
qDC6231fYfrM.TextColor3 = Color3.fromRGB(255, 200, 100)
qDC6231fYfrM.TextSize = 12
qDC6231fYfrM.Font = Enum.Font.GothamBold
qDC6231fYfrM.Visible = false
qDC6231fYfrM.Parent = Fs1Cnus0Vs


local EUXgMowao2oI2F2o = Instance.new("TextLabel")
EUXgMowao2oI2F2o.Name = "TitleLabel"
EUXgMowao2oI2F2o.Size = UDim2.new(1, -80, 1, 0)
EUXgMowao2oI2F2o.Position = UDim2.new(0, 10, 0, 0)
EUXgMowao2oI2F2o.BackgroundTransparency = 1
EUXgMowao2oI2F2o.Text = "小拽脚本"
EUXgMowao2oI2F2o.TextColor3 = Color3.fromRGB(255, 255, 255)
EUXgMowao2oI2F2o.TextScaled = true
EUXgMowao2oI2F2o.Font = Enum.Font.GothamBold
EUXgMowao2oI2F2o.TextXAlignment = Enum.TextXAlignment.Left
EUXgMowao2oI2F2o.Parent = Fs1Cnus0Vs


local gQpu0_FHRRu = Instance.new("TextLabel")
gQpu0_FHRRu.Size = UDim2.new(0, 60, 1, 0)
gQpu0_FHRRu.Position = UDim2.new(1, -130, 0, 0)
gQpu0_FHRRu.BackgroundTransparency = 1
gQpu0_FHRRu.Text = "60 FPS"
gQpu0_FHRRu.TextColor3 = Color3.fromRGB(100, 255, 100)
gQpu0_FHRRu.TextSize = 12
gQpu0_FHRRu.Font = Enum.Font.GothamBold
gQpu0_FHRRu.Visible = false
gQpu0_FHRRu.Parent = Fs1Cnus0Vs


local SAfx_qyqt9C0 = Instance.new("TextButton")
SAfx_qyqt9C0.Name = "MinimizeButton"
SAfx_qyqt9C0.Size = UDim2.new(0, 30, 0, 30)
SAfx_qyqt9C0.Position = UDim2.new(1, -70, 0, 5)
SAfx_qyqt9C0.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SAfx_qyqt9C0.Text = "—"
SAfx_qyqt9C0.TextColor3 = Color3.fromRGB(255, 255, 255)
SAfx_qyqt9C0.TextScaled = true
SAfx_qyqt9C0.Font = Enum.Font.GothamBold
SAfx_qyqt9C0.BorderSizePixel = 0
SAfx_qyqt9C0.Parent = Fs1Cnus0Vs

local MvEeEdiN = Instance.new("UICorner")
MvEeEdiN.CornerRadius = UDim.new(0.5, 0)
MvEeEdiN.Parent = SAfx_qyqt9C0


local KbmoPfDJjhOanF = Instance.new("TextButton")
KbmoPfDJjhOanF.Name = "CloseButton"
KbmoPfDJjhOanF.Size = UDim2.new(0, 30, 0, 30)
KbmoPfDJjhOanF.Position = UDim2.new(1, -35, 0, 5)
KbmoPfDJjhOanF.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
KbmoPfDJjhOanF.Text = "✕"
KbmoPfDJjhOanF.TextColor3 = Color3.fromRGB(255, 255, 255)
KbmoPfDJjhOanF.TextScaled = true
KbmoPfDJjhOanF.Font = Enum.Font.GothamBold
KbmoPfDJjhOanF.BorderSizePixel = 0
KbmoPfDJjhOanF.Parent = Fs1Cnus0Vs

local XGUFSumFmnGbhnu = Instance.new("UICorner")
XGUFSumFmnGbhnu.CornerRadius = UDim.new(0, 6)
XGUFSumFmnGbhnu.Parent = KbmoPfDJjhOanF


local PTkdnw2JeVQW = Instance.new("Frame")
PTkdnw2JeVQW.Name = "ContentFrame"
PTkdnw2JeVQW.Size = UDim2.new(1, -20, 1, -60)
PTkdnw2JeVQW.Position = UDim2.new(0, 10, 0, 50)
PTkdnw2JeVQW.BackgroundTransparency = 1
PTkdnw2JeVQW.Parent = FvW91DGSZsdjnPyn


local GPtTxPX1 = Instance.new("Frame")
GPtTxPX1.Name = "InfoFrame"
GPtTxPX1.Size = UDim2.new(1, 0, 0, 150)
GPtTxPX1.Position = UDim2.new(0, 0, 0, 0)
GPtTxPX1.BackgroundColor3 = Color3.fromRGB(ToydCa3NiCg06.infoFrameColor[1], ToydCa3NiCg06.infoFrameColor[2], ToydCa3NiCg06.infoFrameColor[3])
GPtTxPX1.BorderSizePixel = 0
GPtTxPX1.Parent = PTkdnw2JeVQW

local QaIlwpMCRpuH = Instance.new("UICorner")
QaIlwpMCRpuH.CornerRadius = UDim.new(0, 8)
QaIlwpMCRpuH.Parent = GPtTxPX1


local NLE_EZ9p3jElH_3 = Instance.new("TextLabel")
NLE_EZ9p3jElH_3.Name = "InfoTitle"
NLE_EZ9p3jElH_3.Size = UDim2.new(1, -20, 0, 25)
NLE_EZ9p3jElH_3.Position = UDim2.new(0, 10, 0, 5)
NLE_EZ9p3jElH_3.BackgroundTransparency = 1
NLE_EZ9p3jElH_3.Text = "📊 游戏信息"
NLE_EZ9p3jElH_3.TextColor3 = Color3.fromRGB(255, 255, 255)
NLE_EZ9p3jElH_3.TextScaled = true
NLE_EZ9p3jElH_3.Font = Enum.Font.GothamBold
NLE_EZ9p3jElH_3.Parent = GPtTxPX1


local mrlf4XzCBCY1jh = Instance.new("TextLabel")
mrlf4XzCBCY1jh.Name = "PlayerInfo"
mrlf4XzCBCY1jh.Size = UDim2.new(1, -20, 0, 25)
mrlf4XzCBCY1jh.Position = UDim2.new(0, 10, 0, 30)
mrlf4XzCBCY1jh.BackgroundTransparency = 1
mrlf4XzCBCY1jh.Text = "玩家: " .. C95bVRkAIS7Fo.Name
mrlf4XzCBCY1jh.TextColor3 = Color3.fromRGB(200, 200, 200)
mrlf4XzCBCY1jh.TextScaled = true
mrlf4XzCBCY1jh.Font = Enum.Font.Gotham
mrlf4XzCBCY1jh.TextXAlignment = Enum.TextXAlignment.Left
mrlf4XzCBCY1jh.Parent = GPtTxPX1


local Z5WvKwrYWHI = Instance.new("TextLabel")
Z5WvKwrYWHI.Name = "FPSLabel"
Z5WvKwrYWHI.Size = UDim2.new(1, -20, 0, 25)
Z5WvKwrYWHI.Position = UDim2.new(0, 10, 0, 55)
Z5WvKwrYWHI.BackgroundTransparency = 1
Z5WvKwrYWHI.Text = "帧率: 60 FPS"
Z5WvKwrYWHI.TextColor3 = Color3.fromRGB(100, 255, 100)
Z5WvKwrYWHI.TextScaled = true
Z5WvKwrYWHI.Font = Enum.Font.Gotham
Z5WvKwrYWHI.TextXAlignment = Enum.TextXAlignment.Left
Z5WvKwrYWHI.Parent = GPtTxPX1


local nKdg6Mrwe8knYrzH = Instance.new("TextLabel")
nKdg6Mrwe8knYrzH.Size = UDim2.new(1, -20, 0, 25)
nKdg6Mrwe8knYrzH.Position = UDim2.new(0, 10, 0, 80)
nKdg6Mrwe8knYrzH.BackgroundTransparency = 1
nKdg6Mrwe8knYrzH.Text = "速度: 16"
nKdg6Mrwe8knYrzH.TextColor3 = Color3.fromRGB(255, 200, 100)
nKdg6Mrwe8knYrzH.TextScaled = true
nKdg6Mrwe8knYrzH.Font = Enum.Font.Gotham
nKdg6Mrwe8knYrzH.TextXAlignment = Enum.TextXAlignment.Left
nKdg6Mrwe8knYrzH.Parent = GPtTxPX1


local kS1r1Bov = Instance.new("TextLabel")
kS1r1Bov.Size = UDim2.new(1, -20, 0, 25)
kS1r1Bov.Position = UDim2.new(0, 10, 0, 105)
kS1r1Bov.BackgroundTransparency = 1
kS1r1Bov.Text = "时间: 12:00:00"
kS1r1Bov.TextColor3 = Color3.fromRGB(255, 255, 100)
kS1r1Bov.TextScaled = true
kS1r1Bov.Font = Enum.Font.Gotham
kS1r1Bov.TextXAlignment = Enum.TextXAlignment.Left
kS1r1Bov.Parent = GPtTxPX1


local BcyVfvc7eI6HfM5Y = Instance.new("Frame")
BcyVfvc7eI6HfM5Y.Name = "ButtonFrame"
BcyVfvc7eI6HfM5Y.Size = UDim2.new(1, 0, 0, 120)
BcyVfvc7eI6HfM5Y.Position = UDim2.new(0, 0, 0, 160)
BcyVfvc7eI6HfM5Y.BackgroundTransparency = 1
BcyVfvc7eI6HfM5Y.Parent = PTkdnw2JeVQW


local FkVEWKVP = false
local S14m31hLm = nil
local xXsXKxzswNH4 = nil
local aIFmV6Pi_C = ToydCa3NiCg06.aIFmV6Pi_C or 50


local function toggleFly()
    FkVEWKVP = not FkVEWKVP
    
    if FkVEWKVP then
        if C95bVRkAIS7Fo.Character and C95bVRkAIS7Fo.Character:FindFirstChild("HumanoidRootPart") then
            local VxVSUIocTEN = C95bVRkAIS7Fo.Character.HumanoidRootPart
            
            S14m31hLm = Instance.new("BodyVelocity")
            S14m31hLm.MaxForce = Vector3.new(4000, 4000, 4000)
            S14m31hLm.Velocity = Vector3.new(0, 0, 0)
            S14m31hLm.Parent = VxVSUIocTEN
            
            xXsXKxzswNH4 = Instance.new("BodyAngularVelocity")
            xXsXKxzswNH4.MaxTorque = Vector3.new(0, math.huge, 0)
            xXsXKxzswNH4.AngularVelocity = Vector3.new(0, 0, 0)
            xXsXKxzswNH4.Parent = VxVSUIocTEN
            
            print("飞行模式已开启")
        end
    else
        if S14m31hLm then 
            S14m31hLm:Destroy() 
            S14m31hLm = nil
        end
        if xXsXKxzswNH4 then
            xXsXKxzswNH4:Destroy()
            xXsXKxzswNH4 = nil
        end
        print("飞行模式已关闭")
    end
end


local iuVR1pDOuOZXQOVj = Instance.new("Frame")
iuVR1pDOuOZXQOVj.Size = UDim2.new(0, 200, 0, 230)
iuVR1pDOuOZXQOVj.Position = UDim2.new(0, 10, 0.5, -115)
iuVR1pDOuOZXQOVj.BackgroundTransparency = 1
iuVR1pDOuOZXQOVj.Visible = false
iuVR1pDOuOZXQOVj.Active = true
iuVR1pDOuOZXQOVj.Draggable = true
iuVR1pDOuOZXQOVj.Parent = FE5t09ol2hiXqOFC


iuVR1pDOuOZXQOVj.InputBegan:Connect(function(Cdi_YOd6K)
    if Cdi_YOd6K.UserInputType == Enum.UserInputType.MouseButton1 then
        bringToFront(iuVR1pDOuOZXQOVj)
    end
end)


local GEZ3Qc17B = Instance.new("TextLabel")
GEZ3Qc17B.Size = UDim2.new(1, 0, 0, 20)
GEZ3Qc17B.Position = UDim2.new(0, 0, 0, 0)
GEZ3Qc17B.BackgroundTransparency = 1
GEZ3Qc17B.Text = "飞行速度: " .. aIFmV6Pi_C
GEZ3Qc17B.TextColor3 = Color3.fromRGB(255, 255, 255)
GEZ3Qc17B.TextSize = 12
GEZ3Qc17B.Font = Enum.Font.Gotham
GEZ3Qc17B.Parent = iuVR1pDOuOZXQOVj


local ft42MN_REtguh4 = Instance.new("TextBox")
ft42MN_REtguh4.Size = UDim2.new(0, 80, 0, 25)
ft42MN_REtguh4.Position = UDim2.new(0, 10, 0, 20)
ft42MN_REtguh4.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
ft42MN_REtguh4.Text = tostring(aIFmV6Pi_C)
ft42MN_REtguh4.TextColor3 = Color3.fromRGB(255, 255, 255)
ft42MN_REtguh4.TextSize = 12
ft42MN_REtguh4.Font = Enum.Font.Gotham
ft42MN_REtguh4.BorderSizePixel = 0
ft42MN_REtguh4.Parent = iuVR1pDOuOZXQOVj
local fjqASAJouUjky = Instance.new("UICorner")
fjqASAJouUjky.CornerRadius = UDim.new(0, 4)
fjqASAJouUjky.Parent = ft42MN_REtguh4

local LKuB6gZ2Nh = Instance.new("TextButton")
LKuB6gZ2Nh.Size = UDim2.new(0, 60, 0, 25)
LKuB6gZ2Nh.Position = UDim2.new(0, 100, 0, 20)
LKuB6gZ2Nh.BackgroundColor3 = Color3.fromRGB(40, 167, 69)
LKuB6gZ2Nh.Text = "设置"
LKuB6gZ2Nh.TextColor3 = Color3.fromRGB(255, 255, 255)
LKuB6gZ2Nh.TextSize = 12
LKuB6gZ2Nh.Font = Enum.Font.GothamBold
LKuB6gZ2Nh.BorderSizePixel = 0
LKuB6gZ2Nh.Parent = iuVR1pDOuOZXQOVj
local JN2COoTKUrIuwxz = Instance.new("UICorner")
JN2COoTKUrIuwxz.CornerRadius = UDim.new(0, 4)
JN2COoTKUrIuwxz.Parent = LKuB6gZ2Nh

LKuB6gZ2Nh.MouseButton1Click:Connect(function()
    local EuI6Zjvk106TdsJ = tonumber(ft42MN_REtguh4.Text)
    if EuI6Zjvk106TdsJ and EuI6Zjvk106TdsJ > 0 then
        aIFmV6Pi_C = EuI6Zjvk106TdsJ
        GEZ3Qc17B.Text = "飞行速度: " .. aIFmV6Pi_C
        ToydCa3NiCg06.aIFmV6Pi_C = aIFmV6Pi_C
        saveConfig()
        print("✅ 飞行速度已设置为: " .. aIFmV6Pi_C)
    else
        ft42MN_REtguh4.Text = tostring(aIFmV6Pi_C)
    end
end)


local BMfvIQb1MLiXPS = Instance.new("TextButton")
BMfvIQb1MLiXPS.Size = UDim2.new(0, 120, 0, 35)
BMfvIQb1MLiXPS.Position = UDim2.new(0, 40, 0, 50)
BMfvIQb1MLiXPS.BackgroundColor3 = Color3.fromRGB(255, 193, 7)
BMfvIQb1MLiXPS.Text = "开启飞天"
BMfvIQb1MLiXPS.TextColor3 = Color3.fromRGB(0, 0, 0)
BMfvIQb1MLiXPS.TextSize = 14
BMfvIQb1MLiXPS.Font = Enum.Font.GothamBold
BMfvIQb1MLiXPS.BorderSizePixel = 0
BMfvIQb1MLiXPS.Parent = iuVR1pDOuOZXQOVj

local BQ0m_nUZ5muyBt6U = Instance.new("UICorner")
BQ0m_nUZ5muyBt6U.CornerRadius = UDim.new(0, 8)
BQ0m_nUZ5muyBt6U.Parent = BMfvIQb1MLiXPS


local pXDh7Y8y = Instance.new("TextButton")
pXDh7Y8y.Size = UDim2.new(0, 80, 0, 40)
pXDh7Y8y.Position = UDim2.new(0, 0, 0, 95)
pXDh7Y8y.BackgroundColor3 = Color3.fromRGB(0, 123, 255)
pXDh7Y8y.Text = "上升\n(空格)"
pXDh7Y8y.TextColor3 = Color3.fromRGB(255, 255, 255)
pXDh7Y8y.TextSize = 12
pXDh7Y8y.Font = Enum.Font.GothamBold
pXDh7Y8y.BorderSizePixel = 0
pXDh7Y8y.Parent = iuVR1pDOuOZXQOVj

local B919E2OubWm = Instance.new("UICorner")
B919E2OubWm.CornerRadius = UDim.new(0, 8)
B919E2OubWm.Parent = pXDh7Y8y

local _Pt5ceVz3 = Instance.new("TextButton")
_Pt5ceVz3.Size = UDim2.new(0, 80, 0, 40)
_Pt5ceVz3.Position = UDim2.new(0, 0, 0, 145)
_Pt5ceVz3.BackgroundColor3 = Color3.fromRGB(0, 123, 255)
_Pt5ceVz3.Text = "下降\n(C键)"
_Pt5ceVz3.TextColor3 = Color3.fromRGB(255, 255, 255)
_Pt5ceVz3.TextSize = 12
_Pt5ceVz3.Font = Enum.Font.GothamBold
_Pt5ceVz3.BorderSizePixel = 0
_Pt5ceVz3.Parent = iuVR1pDOuOZXQOVj

local KPcOZwC7L50pf8 = Instance.new("UICorner")
KPcOZwC7L50pf8.CornerRadius = UDim.new(0, 8)
KPcOZwC7L50pf8.Parent = _Pt5ceVz3


local Z7xZyugJrbTg1 = Instance.new("TextButton")
Z7xZyugJrbTg1.Size = UDim2.new(0, 80, 0, 40)
Z7xZyugJrbTg1.Position = UDim2.new(0, 100, 0, 95)
Z7xZyugJrbTg1.BackgroundColor3 = Color3.fromRGB(40, 167, 69)
Z7xZyugJrbTg1.Text = "前进\n(W键)"
Z7xZyugJrbTg1.TextColor3 = Color3.fromRGB(255, 255, 255)
Z7xZyugJrbTg1.TextSize = 12
Z7xZyugJrbTg1.Font = Enum.Font.GothamBold
Z7xZyugJrbTg1.BorderSizePixel = 0
Z7xZyugJrbTg1.Parent = iuVR1pDOuOZXQOVj

local LefiYXuPGEA = Instance.new("UICorner")
LefiYXuPGEA.CornerRadius = UDim.new(0, 8)
LefiYXuPGEA.Parent = Z7xZyugJrbTg1

local JQkZr9MB = Instance.new("TextButton")
JQkZr9MB.Size = UDim2.new(0, 80, 0, 40)
JQkZr9MB.Position = UDim2.new(0, 100, 0, 145)
JQkZr9MB.BackgroundColor3 = Color3.fromRGB(40, 167, 69)
JQkZr9MB.Text = "后退\n(S键)"
JQkZr9MB.TextColor3 = Color3.fromRGB(255, 255, 255)
JQkZr9MB.TextSize = 12
JQkZr9MB.Font = Enum.Font.GothamBold
JQkZr9MB.BorderSizePixel = 0
JQkZr9MB.Parent = iuVR1pDOuOZXQOVj

local sBIzooUBdbxk1JbO = Instance.new("UICorner")
sBIzooUBdbxk1JbO.CornerRadius = UDim.new(0, 8)
sBIzooUBdbxk1JbO.Parent = JQkZr9MB


local ZsNHUpo8GYjskl = false
local PrQkd0oks_of = false
local KgjClwghwA = false
local ODTXAf99O = false


BMfvIQb1MLiXPS.MouseButton1Click:Connect(function()
    toggleFly()
    if FkVEWKVP then
        BMfvIQb1MLiXPS.Text = "关闭飞天"
        BMfvIQb1MLiXPS.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
        BMfvIQb1MLiXPS.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        BMfvIQb1MLiXPS.Text = "开启飞天"
        BMfvIQb1MLiXPS.BackgroundColor3 = Color3.fromRGB(255, 193, 7)
        BMfvIQb1MLiXPS.TextColor3 = Color3.fromRGB(0, 0, 0)
    end
end)


pXDh7Y8y.MouseButton1Down:Connect(function()
    ZsNHUpo8GYjskl = true
end)
pXDh7Y8y.MouseButton1Up:Connect(function()
    ZsNHUpo8GYjskl = false
end)


_Pt5ceVz3.MouseButton1Down:Connect(function()
    PrQkd0oks_of = true
end)
_Pt5ceVz3.MouseButton1Up:Connect(function()
    PrQkd0oks_of = false
end)


Z7xZyugJrbTg1.MouseButton1Down:Connect(function()
    KgjClwghwA = true
end)
Z7xZyugJrbTg1.MouseButton1Up:Connect(function()
    KgjClwghwA = false
end)


JQkZr9MB.MouseButton1Down:Connect(function()
    ODTXAf99O = true
end)
JQkZr9MB.MouseButton1Up:Connect(function()
    ODTXAf99O = false
end)


local function flyControl()
    if not FkVEWKVP or not S14m31hLm then return end
    
    local oJLsBCLYboMM = C95bVRkAIS7Fo.Character
    if not oJLsBCLYboMM then return end
    
    local VxVSUIocTEN = oJLsBCLYboMM:FindFirstChild("HumanoidRootPart")
    if not VxVSUIocTEN then return end
    
    local MdWgB1Z8IEifaz = workspace.CurrentCamera
    local DIvUqOzQQRKiDwt = Vector3.new(0, 0, 0)
    
    
    if ZsNHUpo8GYjskl then
        DIvUqOzQQRKiDwt = DIvUqOzQQRKiDwt + Vector3.new(0, 1, 0)
    end
    if PrQkd0oks_of then
        DIvUqOzQQRKiDwt = DIvUqOzQQRKiDwt - Vector3.new(0, 1, 0)
    end
    if KgjClwghwA then
        DIvUqOzQQRKiDwt = DIvUqOzQQRKiDwt + MdWgB1Z8IEifaz.CFrame.LookVector
    end
    if ODTXAf99O then
        DIvUqOzQQRKiDwt = DIvUqOzQQRKiDwt - MdWgB1Z8IEifaz.CFrame.LookVector
    end
    
    
    if OF0RaWQlMF3:IsKeyDown(Enum.KeyCode.Space) then
        DIvUqOzQQRKiDwt = DIvUqOzQQRKiDwt + Vector3.new(0, 1, 0)
    end
    if OF0RaWQlMF3:IsKeyDown(Enum.KeyCode.C) then
        DIvUqOzQQRKiDwt = DIvUqOzQQRKiDwt - Vector3.new(0, 1, 0)
    end
    if OF0RaWQlMF3:IsKeyDown(Enum.KeyCode.W) then
        DIvUqOzQQRKiDwt = DIvUqOzQQRKiDwt + MdWgB1Z8IEifaz.CFrame.LookVector
    end
    if OF0RaWQlMF3:IsKeyDown(Enum.KeyCode.S) then
        DIvUqOzQQRKiDwt = DIvUqOzQQRKiDwt - MdWgB1Z8IEifaz.CFrame.LookVector
    end
    if OF0RaWQlMF3:IsKeyDown(Enum.KeyCode.A) then
        DIvUqOzQQRKiDwt = DIvUqOzQQRKiDwt - MdWgB1Z8IEifaz.CFrame.RightVector
    end
    if OF0RaWQlMF3:IsKeyDown(Enum.KeyCode.D) then
        DIvUqOzQQRKiDwt = DIvUqOzQQRKiDwt + MdWgB1Z8IEifaz.CFrame.RightVector
    end
    
    S14m31hLm.Velocity = DIvUqOzQQRKiDwt * aIFmV6Pi_C
end


VmYBbTScHuqjNm.Heartbeat:Connect(flyControl)


local avbnxhjq9Frpy3J = Instance.new("Frame")
avbnxhjq9Frpy3J.Size = UDim2.new(0, 400, 0, 500)
avbnxhjq9Frpy3J.Position = UDim2.new(0, 370, 0, 20)
avbnxhjq9Frpy3J.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
avbnxhjq9Frpy3J.BorderSizePixel = 0
avbnxhjq9Frpy3J.Visible = false
avbnxhjq9Frpy3J.Active = true
avbnxhjq9Frpy3J.Draggable = true
avbnxhjq9Frpy3J.Parent = FE5t09ol2hiXqOFC


avbnxhjq9Frpy3J.InputBegan:Connect(function(Cdi_YOd6K)
    if Cdi_YOd6K.UserInputType == Enum.UserInputType.MouseButton1 then
        bringToFront(avbnxhjq9Frpy3J)
    end
end)

local CYvb8xga = Instance.new("UICorner")
CYvb8xga.CornerRadius = UDim.new(0, 10)
CYvb8xga.Parent = avbnxhjq9Frpy3J

local KFS5i7jpm7oB = Instance.new("UIStroke")
KFS5i7jpm7oB.Color = Color3.fromRGB(ToydCa3NiCg06.borderColor[1], ToydCa3NiCg06.borderColor[2], ToydCa3NiCg06.borderColor[3]) 
KFS5i7jpm7oB.Thickness = 2
KFS5i7jpm7oB.Parent = avbnxhjq9Frpy3J


createResizeHandle(avbnxhjq9Frpy3J)

local GkafedrVv7DJu = Instance.new("TextLabel")
GkafedrVv7DJu.Size = UDim2.new(1, -25, 0, 30)
GkafedrVv7DJu.Position = UDim2.new(0, 5, 0, 5)
GkafedrVv7DJu.BackgroundTransparency = 1
GkafedrVv7DJu.Text = "⚡ 移动速度设置"
GkafedrVv7DJu.TextColor3 = Color3.fromRGB(255, 255, 255)
GkafedrVv7DJu.TextSize = 14
GkafedrVv7DJu.Font = Enum.Font.GothamBold
GkafedrVv7DJu.Parent = avbnxhjq9Frpy3J

local A1pA1xX1M = Instance.new("TextButton")
A1pA1xX1M.Size = UDim2.new(0, 20, 0, 20)
A1pA1xX1M.Position = UDim2.new(1, -25, 0, 5)
A1pA1xX1M.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
A1pA1xX1M.Text = "×"
A1pA1xX1M.TextColor3 = Color3.fromRGB(255, 255, 255)
A1pA1xX1M.TextSize = 12
A1pA1xX1M.BorderSizePixel = 0
A1pA1xX1M.Parent = avbnxhjq9Frpy3J

local DKKNMSIW = Instance.new("UICorner")
DKKNMSIW.CornerRadius = UDim.new(0, 3)
DKKNMSIW.Parent = A1pA1xX1M


local a5sjSOeb8 = Instance.new("Frame")
a5sjSOeb8.Size = UDim2.new(1, -20, 0, 80)
a5sjSOeb8.Position = UDim2.new(0, 10, 0, 40)
a5sjSOeb8.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
a5sjSOeb8.BorderSizePixel = 0
a5sjSOeb8.Parent = avbnxhjq9Frpy3J

local Oa7YhyoA4tLyT9s = Instance.new("UICorner")
Oa7YhyoA4tLyT9s.CornerRadius = UDim.new(0, 8)
Oa7YhyoA4tLyT9s.Parent = a5sjSOeb8

local WlJ5Dw2HbeQi = Instance.new("TextLabel")
WlJ5Dw2HbeQi.Size = UDim2.new(1, 0, 0, 25)
WlJ5Dw2HbeQi.Position = UDim2.new(0, 0, 0, 5)
WlJ5Dw2HbeQi.BackgroundTransparency = 1
WlJ5Dw2HbeQi.Text = "自定义移速"
WlJ5Dw2HbeQi.TextColor3 = Color3.fromRGB(255, 255, 255)
WlJ5Dw2HbeQi.TextSize = 14
WlJ5Dw2HbeQi.Font = Enum.Font.GothamBold
WlJ5Dw2HbeQi.Parent = a5sjSOeb8

local GvbuM4eW03 = Instance.new("TextBox")
GvbuM4eW03.Size = UDim2.new(0, 200, 0, 30)
GvbuM4eW03.Position = UDim2.new(0, 10, 0, 30)
GvbuM4eW03.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
GvbuM4eW03.Text = "输入速度值"
GvbuM4eW03.TextColor3 = Color3.fromRGB(255, 255, 255)
GvbuM4eW03.TextSize = 12
GvbuM4eW03.Font = Enum.Font.Gotham
GvbuM4eW03.BorderSizePixel = 0
GvbuM4eW03.Parent = a5sjSOeb8

local NChSDJ4Y1By = Instance.new("UICorner")
NChSDJ4Y1By.CornerRadius = UDim.new(0, 5)
NChSDJ4Y1By.Parent = GvbuM4eW03

local WBqtqqyQqt = Instance.new("TextButton")
WBqtqqyQqt.Size = UDim2.new(0, 80, 0, 30)
WBqtqqyQqt.Position = UDim2.new(0, 220, 0, 30)
WBqtqqyQqt.BackgroundColor3 = Color3.fromRGB(40, 167, 69)
WBqtqqyQqt.Text = "设置"
WBqtqqyQqt.TextColor3 = Color3.fromRGB(255, 255, 255)
WBqtqqyQqt.TextSize = 12
WBqtqqyQqt.Font = Enum.Font.GothamBold
WBqtqqyQqt.BorderSizePixel = 0
WBqtqqyQqt.Parent = a5sjSOeb8

local F_1OUNml_4 = Instance.new("UICorner")
F_1OUNml_4.CornerRadius = UDim.new(0, 5)
F_1OUNml_4.Parent = WBqtqqyQqt

WBqtqqyQqt.MouseButton1Click:Connect(function()
    local PjJwic7nbkv = tonumber(GvbuM4eW03.Text)
    if PjJwic7nbkv and PjJwic7nbkv > 0 then
        if C95bVRkAIS7Fo.Character and C95bVRkAIS7Fo.Character:FindFirstChild("Humanoid") then
            C95bVRkAIS7Fo.Character.Humanoid.WalkSpeed = PjJwic7nbkv
            ToydCa3NiCg06.walkSpeed = PjJwic7nbkv
            saveConfig()
            print("自定义移动速度已设置为: " .. PjJwic7nbkv)
        end
    else
        print("请输入有效的数字")
    end
end)


local IEqQNvSKXeiEol0 = Instance.new("ScrollingFrame")
IEqQNvSKXeiEol0.Size = UDim2.new(1, -20, 1, -130)
IEqQNvSKXeiEol0.Position = UDim2.new(0, 10, 0, 130)
IEqQNvSKXeiEol0.BackgroundTransparency = 1
IEqQNvSKXeiEol0.ScrollBarThickness = 8
IEqQNvSKXeiEol0.CanvasSize = UDim2.new(0, 0, 0, 460)
IEqQNvSKXeiEol0.Parent = avbnxhjq9Frpy3J


local aFYlPl3h42RlWEOH = {100, 200, 300, 400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 2000, 3000, 4000}

for HDDjCvBKNS, WmAFsKMfE in ipairs(aFYlPl3h42RlWEOH) do
    local ePhJte4UeIgF = Instance.new("TextButton")
    ePhJte4UeIgF.Size = UDim2.new(0, 180, 0, 35)
    ePhJte4UeIgF.Position = UDim2.new(0, 10 + ((HDDjCvBKNS-1) % 2) * 190, 0, 10 + math.floor((HDDjCvBKNS-1) / 2) * 45)
    ePhJte4UeIgF.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
    ePhJte4UeIgF.Text = "速度: " .. WmAFsKMfE
    ePhJte4UeIgF.TextColor3 = Color3.fromRGB(255, 255, 255)
    ePhJte4UeIgF.TextSize = 12
    ePhJte4UeIgF.Font = Enum.Font.Gotham
    ePhJte4UeIgF.BorderSizePixel = 0
    ePhJte4UeIgF.Parent = IEqQNvSKXeiEol0
    
    local noDi48AmsDeoU = Instance.new("UICorner")
    noDi48AmsDeoU.CornerRadius = UDim.new(0, 5)
    noDi48AmsDeoU.Parent = ePhJte4UeIgF
    
    ePhJte4UeIgF.MouseButton1Click:Connect(function()
        if C95bVRkAIS7Fo.Character and C95bVRkAIS7Fo.Character:FindFirstChild("Humanoid") then
            C95bVRkAIS7Fo.Character.Humanoid.WalkSpeed = WmAFsKMfE
            ToydCa3NiCg06.walkSpeed = WmAFsKMfE
            saveConfig()
            print("移动速度已设置为: " .. WmAFsKMfE)
        end
    end)
end


local ENA0mC8hhVoWDLK = Instance.new("Frame")
ENA0mC8hhVoWDLK.Size = UDim2.new(0, 320, 0, 300)
ENA0mC8hhVoWDLK.Position = UDim2.new(0, 370, 0, 20)
ENA0mC8hhVoWDLK.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
ENA0mC8hhVoWDLK.BorderSizePixel = 0
ENA0mC8hhVoWDLK.Visible = false
ENA0mC8hhVoWDLK.Active = true
ENA0mC8hhVoWDLK.Draggable = true
ENA0mC8hhVoWDLK.Parent = FE5t09ol2hiXqOFC


ENA0mC8hhVoWDLK.InputBegan:Connect(function(Cdi_YOd6K)
    if Cdi_YOd6K.UserInputType == Enum.UserInputType.MouseButton1 then
        bringToFront(ENA0mC8hhVoWDLK)
    end
end)

local B5fvVQMOB = Instance.new("UICorner")
B5fvVQMOB.CornerRadius = UDim.new(0, 10)
B5fvVQMOB.Parent = ENA0mC8hhVoWDLK

local T2qu0FtBGwiNg = Instance.new("UIStroke")
T2qu0FtBGwiNg.Color = Color3.fromRGB(ToydCa3NiCg06.borderColor[1], ToydCa3NiCg06.borderColor[2], ToydCa3NiCg06.borderColor[3]) 
T2qu0FtBGwiNg.Thickness = 2
T2qu0FtBGwiNg.Parent = ENA0mC8hhVoWDLK


createResizeHandle(ENA0mC8hhVoWDLK)

local kMS1BChqym = Instance.new("TextLabel")
kMS1BChqym.Size = UDim2.new(1, -25, 0, 30)
kMS1BChqym.Position = UDim2.new(0, 5, 0, 5)
kMS1BChqym.BackgroundTransparency = 1
kMS1BChqym.Text = "🎨 自定义悬浮窗颜色"
kMS1BChqym.TextColor3 = Color3.fromRGB(255, 255, 255)
kMS1BChqym.TextSize = 14
kMS1BChqym.Font = Enum.Font.GothamBold
kMS1BChqym.Parent = ENA0mC8hhVoWDLK

local e1cNV1eIDi1qJ = Instance.new("TextButton")
e1cNV1eIDi1qJ.Size = UDim2.new(0, 20, 0, 20)
e1cNV1eIDi1qJ.Position = UDim2.new(1, -25, 0, 5)
e1cNV1eIDi1qJ.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
e1cNV1eIDi1qJ.Text = "×"
e1cNV1eIDi1qJ.TextColor3 = Color3.fromRGB(255, 255, 255)
e1cNV1eIDi1qJ.TextSize = 12
e1cNV1eIDi1qJ.BorderSizePixel = 0
e1cNV1eIDi1qJ.Parent = ENA0mC8hhVoWDLK

local x2wZFNLRJp = Instance.new("UICorner")
x2wZFNLRJp.CornerRadius = UDim.new(0, 3)
x2wZFNLRJp.Parent = e1cNV1eIDi1qJ


local b_bZ9jPs = Instance.new("ScrollingFrame")
b_bZ9jPs.Size = UDim2.new(1, -10, 1, -40)
b_bZ9jPs.Position = UDim2.new(0, 5, 0, 35)
b_bZ9jPs.BackgroundTransparency = 1
b_bZ9jPs.BorderSizePixel = 0
b_bZ9jPs.ScrollBarThickness = 6
b_bZ9jPs.CanvasSize = UDim2.new(0, 0, 0, 0)  
b_bZ9jPs.Parent = ENA0mC8hhVoWDLK

local wDFFmzvsTr6 = Instance.new("UICorner")
wDFFmzvsTr6.CornerRadius = UDim.new(0, 5)
wDFFmzvsTr6.Parent = b_bZ9jPs

local uGl9bZyYcfRU = Instance.new("UIGridLayout")
uGl9bZyYcfRU.CellSize = UDim2.new(0, 95, 0, 35)
uGl9bZyYcfRU.CellPadding = UDim2.new(0, 5, 0, 5)
uGl9bZyYcfRU.SortOrder = Enum.SortOrder.LayoutOrder
uGl9bZyYcfRU.Parent = b_bZ9jPs

local Jb1uwhidd29WLjLt = Instance.new("UIPadding")
Jb1uwhidd29WLjLt.PaddingLeft = UDim.new(0, 5)
Jb1uwhidd29WLjLt.PaddingTop = UDim.new(0, 5)
Jb1uwhidd29WLjLt.Parent = b_bZ9jPs


local TxnYok1fwGm = {
    
    {Color3.fromRGB(100, 200, 255), "天空蓝"},
    {Color3.fromRGB(255, 100, 100), "樱花红"},
    {Color3.fromRGB(100, 255, 100), "翡翠绿"},
    {Color3.fromRGB(255, 200, 100), "夕阳橙"},
    {Color3.fromRGB(200, 100, 255), "薰衣紫"},
    {Color3.fromRGB(255, 255, 100), "柠檬黄"},
    {Color3.fromRGB(255, 150, 200), "粉玫瑰"},
    {Color3.fromRGB(150, 255, 200), "薄荷绿"},
    {Color3.fromRGB(200, 255, 150), "青草绿"},
    {Color3.fromRGB(255, 200, 150), "蜜桃橙"},
    {Color3.fromRGB(150, 200, 255), "海洋蓝"},
    {Color3.fromRGB(255, 150, 255), "梦幻紫"},
    
    
    {Color3.fromRGB(255, 255, 255), "纯白色"},
    {Color3.fromRGB(0, 0, 0), "纯黑色"},
    {Color3.fromRGB(128, 128, 128), "灰色"},
    {Color3.fromRGB(192, 192, 192), "银色"},
    {Color3.fromRGB(128, 0, 0), "深红"},
    {Color3.fromRGB(128, 128, 0), "橄榄绿"},
    {Color3.fromRGB(0, 128, 0), "森林绿"},
    {Color3.fromRGB(128, 0, 128), "紫色"},
    {Color3.fromRGB(0, 128, 128), "青色"},
    {Color3.fromRGB(0, 0, 128), "海军蓝"},
    {Color3.fromRGB(255, 165, 0), "橙色"},
    {Color3.fromRGB(255, 192, 203), "粉色"},
    {Color3.fromRGB(139, 69, 19), "棕色"},
    {Color3.fromRGB(240, 230, 140), "卡其色"},
    {Color3.fromRGB(173, 216, 230), "浅蓝"},
    {Color3.fromRGB(144, 238, 144), "浅绿"},
    {Color3.fromRGB(221, 160, 221), "梅红色"},
    {Color3.fromRGB(255, 218, 185), "桃色"},
    {Color3.fromRGB(255, 105, 180), "热粉色"},
    {Color3.fromRGB(30, 144, 255), "道奇蓝"},
    {Color3.fromRGB(0, 255, 255), "青色"},
    {Color3.fromRGB(50, 205, 50), "石灰绿"},
    {Color3.fromRGB(255, 20, 147), "深粉色"},
    {Color3.fromRGB(0, 191, 255), "深天蓝"},
    {Color3.fromRGB(218, 112, 214), "紫罗兰"},
    {Color3.fromRGB(255, 105, 180), "浅粉色"},
    {Color3.fromRGB(255, 182, 193), "浅粉红"},
    {Color3.fromRGB(175, 238, 238), "浅青色"},
    {Color3.fromRGB(152, 251, 152), "浅绿色"},
    {Color3.fromRGB(176, 196, 222), "浅钢蓝"},
    {Color3.fromRGB(230, 230, 250), "薰衣草"},
    {Color3.fromRGB(255, 228, 225), "薄雾玫瑰"},
    {Color3.fromRGB(250, 250, 210), "象牙白"},
    {Color3.fromRGB(253, 245, 230), "亚麻色"},
    {Color3.fromRGB(245, 255, 250), "蜜瓜色"},
    {Color3.fromRGB(240, 255, 240), "蜜瓜白"},
    {Color3.fromRGB(248, 248, 255), "幽灵白"},
    {Color3.fromRGB(245, 245, 245), "烟白色"},
    {Color3.fromRGB(220, 220, 220), "亮灰色"},
    {Color3.fromRGB(105, 105, 105), "暗灰色"},
    {Color3.fromRGB(47, 79, 79), "暗海绿"},
    {Color3.fromRGB(119, 136, 153), "暗灰蓝"},
    {Color3.fromRGB(112, 128, 144), "石板灰"},
    {Color3.fromRGB(25, 25, 112), "中海蓝"},
    {Color3.fromRGB(0, 0, 139), "深蓝色"},
    {Color3.fromRGB(138, 43, 226), "蓝紫色"},
    {Color3.fromRGB(75, 0, 130), "深紫色"},
    {Color3.fromRGB(123, 104, 238), "中紫色"},
    {Color3.fromRGB(147, 112, 219), "中紫罗兰色"},
    {Color3.fromRGB(186, 85, 211), "紫罗兰色"},
    {Color3.fromRGB(238, 130, 238), "紫水晶色"},
    {Color3.fromRGB(216, 191, 216), "苍白紫罗兰色"},
    {Color3.fromRGB(255, 0, 255), "洋红色"},
    {Color3.fromRGB(255, 20, 147), "深粉色"},
    {Color3.fromRGB(255, 105, 180), "热粉色"},
    {Color3.fromRGB(199, 21, 133), "深粉色"},
    {Color3.fromRGB(219, 112, 147), "苍白紫红色"},
    {Color3.fromRGB(255, 182, 193), "浅粉红"},
    {Color3.fromRGB(255, 192, 203), "粉色"},
    {Color3.fromRGB(255, 160, 122), "浅珊瑚色"},
    {Color3.fromRGB(240, 128, 128), "淡珊瑚色"},
    {Color3.fromRGB(233, 150, 122), "浅鲑鱼色"},
    {Color3.fromRGB(250, 128, 114), "鲑鱼色"},
    {Color3.fromRGB(255, 99, 71), "番茄色"},
    {Color3.fromRGB(255, 69, 0), "橙红色"},
    {Color3.fromRGB(255, 140, 0), "深橙色"},
    {Color3.fromRGB(255, 165, 0), "橙色"},
    {Color3.fromRGB(255, 215, 0), "金色"},
    {Color3.fromRGB(238, 232, 170), "淡金色"},
    {Color3.fromRGB(189, 183, 107), "深卡其色"},
    {Color3.fromRGB(240, 230, 140), "卡其色"},
    {Color3.fromRGB(230, 230, 0), "橄榄色"},
    {Color3.fromRGB(184, 134, 11), "暗金黄色"},
    {Color3.fromRGB(255, 255, 0), "黄色"},
    {Color3.fromRGB(154, 205, 50), "黄绿色"},
    {Color3.fromRGB(85, 107, 47), "橄榄土褐色"},
    {Color3.fromRGB(107, 142, 35), "橄榄军服绿"},
    {Color3.fromRGB(128, 128, 0), "橄榄色"},
    {Color3.fromRGB(124, 252, 0), "草绿色"},
    {Color3.fromRGB(0, 255, 0), "纯绿色"},
    {Color3.fromRGB(34, 139, 34), "森林绿"},
    {Color3.fromRGB(0, 250, 154), "春绿色"},
    {Color3.fromRGB(0, 255, 127), "春天绿"},
    {Color3.fromRGB(143, 188, 143), "暗海绿"},
    {Color3.fromRGB(46, 139, 87), "海绿色"},
    {Color3.fromRGB(60, 179, 113), "中海绿"},
    {Color3.fromRGB(32, 178, 170), "浅海绿"},
    {Color3.fromRGB(0, 128, 128), "青色"},
    {Color3.fromRGB(0, 206, 209), "深青色"},
    {Color3.fromRGB(72, 209, 204), "中青色"},
    {Color3.fromRGB(64, 224, 208), "碧绿色"},
    {Color3.fromRGB(0, 139, 139), "深青色"},
    {Color3.fromRGB(0, 0, 255), "纯蓝色"},
    {Color3.fromRGB(30, 144, 255), "道奇蓝"},
    {Color3.fromRGB(135, 206, 250), "浅天蓝"},
    {Color3.fromRGB(135, 206, 235), "天空蓝"},
    {Color3.fromRGB(70, 130, 180), "钢蓝色"},
    {Color3.fromRGB(176, 196, 222), "浅钢蓝"},
    {Color3.fromRGB(100, 149, 237), "玉米花蓝"},
    {Color3.fromRGB(25, 25, 112), "中海蓝"},
    {Color3.fromRGB(0, 0, 139), "深蓝色"},
    {Color3.fromRGB(0, 0, 128), "海军蓝"},
    {Color3.fromRGB(240, 248, 255), "爱丽丝蓝"},
    {Color3.fromRGB(230, 240, 250), "钢青色"},
    {Color3.fromRGB(255, 240, 245), "雪花色"},
    {Color3.fromRGB(248, 248, 255), "幽灵白"},
    {Color3.fromRGB(245, 245, 245), "烟白色"},
    {Color3.fromRGB(255, 250, 250), "雪白色"}
}

for HDDjCvBKNS, colorData in ipairs(TxnYok1fwGm) do
    local wibia0Px_EgoJP = Instance.new("TextButton")
    wibia0Px_EgoJP.BackgroundColor3 = colorData[1]
    wibia0Px_EgoJP.Text = colorData[2]
    wibia0Px_EgoJP.TextColor3 = Color3.fromRGB(255, 255, 255)
    wibia0Px_EgoJP.TextSize = 10
    wibia0Px_EgoJP.Font = Enum.Font.Gotham
    wibia0Px_EgoJP.BorderSizePixel = 0
    wibia0Px_EgoJP.LayoutOrder = HDDjCvBKNS  
    wibia0Px_EgoJP.Parent = b_bZ9jPs
    
    local Kdz5E3xj0U = Instance.new("UICorner")
    Kdz5E3xj0U.CornerRadius = UDim.new(0, 5)
    Kdz5E3xj0U.Parent = wibia0Px_EgoJP
    
    wibia0Px_EgoJP.MouseButton1Click:Connect(function()
        
        FvW91DGSZsdjnPyn.BackgroundColor3 = colorData[1]
        Fs1Cnus0Vs.BackgroundColor3 = Color3.new(colorData[1].R * 0.8, colorData[1].G * 0.8, colorData[1].B * 0.8)
        GPtTxPX1.BackgroundColor3 = Color3.new(colorData[1].R * 0.6, colorData[1].G * 0.6, colorData[1].B * 0.6)
        ZcSn2i_jp1Ia0INE.Color = colorData[1]
        
        
        if avbnxhjq9Frpy3J then
            
            avbnxhjq9Frpy3J.BackgroundColor3 = colorData[1]
            
            local KFS5i7jpm7oB = avbnxhjq9Frpy3J:FindFirstChild("UIStroke")
            if KFS5i7jpm7oB then
                KFS5i7jpm7oB.Color = colorData[1]
            end
        end
        
        if ENA0mC8hhVoWDLK then
            
            ENA0mC8hhVoWDLK.BackgroundColor3 = colorData[1]
            
            local T2qu0FtBGwiNg = ENA0mC8hhVoWDLK:FindFirstChild("UIStroke")
            if T2qu0FtBGwiNg then
                T2qu0FtBGwiNg.Color = colorData[1]
            end
        end
        
        
        local LCCUgskUD0OS = FE5t09ol2hiXqOFC:FindFirstChild("NameWindow")
        if LCCUgskUD0OS then
            
            LCCUgskUD0OS.BackgroundColor3 = colorData[1]
            
            local n5BB0pj5Rp2 = LCCUgskUD0OS:FindFirstChild("UIStroke")
            if n5BB0pj5Rp2 then
                n5BB0pj5Rp2.Color = colorData[1] 
            end
        end
        
        
        local RcnZXNa4Ej = FE5t09ol2hiXqOFC:FindFirstChild("WhitelistWindow")
        if RcnZXNa4Ej then
            
            RcnZXNa4Ej.BackgroundColor3 = colorData[1]
            
            local t0kjFG5k_i18OEI = RcnZXNa4Ej:FindFirstChild("UIStroke")
            if t0kjFG5k_i18OEI then
                t0kjFG5k_i18OEI.Color = colorData[1]
            end
        end
        
        
        local ga5FrgWP9N = FE5t09ol2hiXqOFC:FindFirstChild("FPSPositionWindow")
        if ga5FrgWP9N then
            
            ga5FrgWP9N.BackgroundColor3 = colorData[1]
            
            local FKYNPRInwih = ga5FrgWP9N:FindFirstChild("UIStroke")
            if FKYNPRInwih then
                FKYNPRInwih.Color = colorData[1]
            end
        end
        
        
        ToydCa3NiCg06.mainFrameColor = {math.floor(colorData[1].R * 255), math.floor(colorData[1].G * 255), math.floor(colorData[1].B * 255)}
        ToydCa3NiCg06.titleBarColor = {math.floor(colorData[1].R * 0.8 * 255), math.floor(colorData[1].G * 0.8 * 255), math.floor(colorData[1].B * 0.8 * 255)}
        ToydCa3NiCg06.infoFrameColor = {math.floor(colorData[1].R * 0.6 * 255), math.floor(colorData[1].G * 0.6 * 255), math.floor(colorData[1].B * 0.6 * 255)}
        ToydCa3NiCg06.borderColor = {math.floor(colorData[1].R * 255), math.floor(colorData[1].G * 255), math.floor(colorData[1].B * 255)}
        saveConfig()
        print("颜色已更改为: " .. colorData[2])
    end)
end


b_bZ9jPs.AutomaticCanvasSize = Enum.AutomaticSize.Y


local function createSmallButton(hQJrMvzjUeYyWPoB, gEc3ayzruz0bMjz_, ebl9VfmRMe4a, F3_kt9RdiBO4, IfHZWvCUGtj_)
    local T_Mwu1qOX2WQBB = Instance.new("TextButton")
    T_Mwu1qOX2WQBB.Size = UDim2.new(0, 155, 0, 35)
    T_Mwu1qOX2WQBB.Position = F3_kt9RdiBO4
    T_Mwu1qOX2WQBB.BackgroundColor3 = gEc3ayzruz0bMjz_
    T_Mwu1qOX2WQBB.Text = ebl9VfmRMe4a .. " " .. hQJrMvzjUeYyWPoB
    T_Mwu1qOX2WQBB.TextColor3 = Color3.fromRGB(255, 255, 255)
    T_Mwu1qOX2WQBB.TextSize = 12
    T_Mwu1qOX2WQBB.Font = Enum.Font.Gotham
    T_Mwu1qOX2WQBB.BorderSizePixel = 0
    T_Mwu1qOX2WQBB.Parent = BcyVfvc7eI6HfM5Y
    
    local bZnOqKIKlOxF = Instance.new("UICorner")
    bZnOqKIKlOxF.CornerRadius = UDim.new(0, 8)
    bZnOqKIKlOxF.Parent = T_Mwu1qOX2WQBB
    
    T_Mwu1qOX2WQBB.MouseEnter:Connect(function()
        local j3CeltosC = OYm6D6iFjz1bb9:Create(T_Mwu1qOX2WQBB, TweenInfo.new(0.2), {BackgroundColor3 = Color3.new(gEc3ayzruz0bMjz_.R + 0.1, gEc3ayzruz0bMjz_.G + 0.1, gEc3ayzruz0bMjz_.B + 0.1)})
        j3CeltosC:Play()
    end)
    
    T_Mwu1qOX2WQBB.MouseLeave:Connect(function()
        local j3CeltosC = OYm6D6iFjz1bb9:Create(T_Mwu1qOX2WQBB, TweenInfo.new(0.2), {BackgroundColor3 = gEc3ayzruz0bMjz_})
        j3CeltosC:Play()
    end)
    
    if IfHZWvCUGtj_ then
        T_Mwu1qOX2WQBB.MouseButton1Click:Connect(IfHZWvCUGtj_)
    end
    
    return T_Mwu1qOX2WQBB
end


createSmallButton("飞行模式", Color3.fromRGB(0, 123, 255), "✈️", UDim2.new(0, 5, 0, 5), function()
    iuVR1pDOuOZXQOVj.Visible = not iuVR1pDOuOZXQOVj.Visible
end)

createSmallButton("移速设置", Color3.fromRGB(220, 53, 69), "⚡", UDim2.new(0, 170, 0, 5), function()
    avbnxhjq9Frpy3J.Visible = not avbnxhjq9Frpy3J.Visible
    ENA0mC8hhVoWDLK.Visible = false
end)

createSmallButton("自定义颜色", Color3.fromRGB(138, 43, 226), "🎨", UDim2.new(0, 5, 0, 50), function()
    ENA0mC8hhVoWDLK.Visible = not ENA0mC8hhVoWDLK.Visible
    avbnxhjq9Frpy3J.Visible = false
end)

local GRyrp96hhOWrPJ = ToydCa3NiCg06.GRyrp96hhOWrPJ or false
local ZXKrahArrrK = {}
local INQc8AkW = {}

local function sizeGrowth(Aouymw6WYcenKca4) return math.floor(((Aouymw6WYcenKca4 + 0.5) ^ 2 - 0.25) / 2 * 100) end
local function eatSpeedGrowth(Aouymw6WYcenKca4) return math.floor((1 + (Aouymw6WYcenKca4 - 1) * 0.2) * 10) / 10 end

local MTL13F5zr1 = {}


local function checkDangerousPlayersOnJoin(vlHusXpU8C)
    if vlHusXpU8C ~= C95bVRkAIS7Fo and not MTL13F5zr1[vlHusXpU8C.UserId] and vlHusXpU8C:FindFirstChild("Upgrades") then
        local Si8cUUW4UyPdo = vlHusXpU8C.Upgrades:FindFirstChild("MaxSize")
        if Si8cUUW4UyPdo then
            local gucQG3rZxSxM = sizeGrowth(Si8cUUW4UyPdo.Value)
            if gucQG3rZxSxM >= 10000000 then
                MTL13F5zr1[vlHusXpU8C.UserId] = true
                showDangerWarning(vlHusXpU8C)
            end
        end
    end
end

Players.PlayerRemoving:Connect(function(qqqWs29OpDz)
    MTL13F5zr1[qqqWs29OpDz.UserId] = nil
end)

Players.PlayerAdded:Connect(function(ebUyBEjFKB)
    task.wait(1)
    checkDangerousPlayersOnJoin(ebUyBEjFKB)
    ebUyBEjFKB.CharacterAdded:Connect(function(hF5Lj0BwH9b)
        task.wait(1)
        checkDangerousPlayersOnJoin(ebUyBEjFKB)
    end)
end)


for yVYP32Bx3Le7, existingPlayer in pairs(Players:GetPlayers()) do
    checkDangerousPlayersOnJoin(existingPlayer)
    existingPlayer.CharacterAdded:Connect(function(hF5Lj0BwH9b)
        task.wait(1)
        checkDangerousPlayersOnJoin(existingPlayer)
    end)
end

local function updateHeadStats()
    for yVYP32Bx3Le7, p in pairs(Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("Head") then
            local kGFlmRZ0HnNxfKr = p.Character.Head:FindFirstChild("HeadStatsGui")
            if kGFlmRZ0HnNxfKr then
                local WQtBd4T3PH = kGFlmRZ0HnNxfKr:FindFirstChildOfClass("TextLabel")
                if WQtBd4T3PH then
                    WQtBd4T3PH.TextColor3 = ToydCa3NiCg06.headTextColor and Color3.fromRGB(ToydCa3NiCg06.headTextColor[1], ToydCa3NiCg06.headTextColor[2], ToydCa3NiCg06.headTextColor[3]) or Color3.fromRGB(255, 255, 255)
                    WQtBd4T3PH.TextSize = ToydCa3NiCg06.headTextSize or 12
                end
            end
        end
    end
end

local function createHeadStatsForPlayer(vlHusXpU8C)
    if vlHusXpU8C == C95bVRkAIS7Fo then return end
    if not vlHusXpU8C.Character or not vlHusXpU8C.Character:FindFirstChild("Head") then return end
    if ZXKrahArrrK[vlHusXpU8C.UserId] then ZXKrahArrrK[vlHusXpU8C.UserId]:Destroy() end
    if INQc8AkW[vlHusXpU8C.UserId] then INQc8AkW[vlHusXpU8C.UserId]:Disconnect() end
    local CaJqWu1ff0ESJ = Instance.new("BillboardGui")
    CaJqWu1ff0ESJ.Name = "HeadStatsGui"
    CaJqWu1ff0ESJ.Adornee = vlHusXpU8C.Character.Head

    CaJqWu1ff0ESJ.Size = UDim2.new(0, 150, 0, 120)
    CaJqWu1ff0ESJ.StudsOffset = Vector3.new(0, 2.5, 0)
    CaJqWu1ff0ESJ.AlwaysOnTop = true
    CaJqWu1ff0ESJ.Parent = vlHusXpU8C.Character.Head
    local WQtBd4T3PH = Instance.new("TextLabel")
    WQtBd4T3PH.Size = UDim2.new(1, 0, 1, 0)
    WQtBd4T3PH.BackgroundTransparency = 1
    WQtBd4T3PH.TextColor3 = ToydCa3NiCg06.headTextColor and Color3.fromRGB(ToydCa3NiCg06.headTextColor[1], ToydCa3NiCg06.headTextColor[2], ToydCa3NiCg06.headTextColor[3]) or Color3.fromRGB(255, 255, 255)
    WQtBd4T3PH.TextSize = ToydCa3NiCg06.headTextSize or 12
    WQtBd4T3PH.Font = Enum.Font.GothamBold
    WQtBd4T3PH.RichText = true
    WQtBd4T3PH.TextStrokeTransparency = 0
    WQtBd4T3PH.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    WQtBd4T3PH.TextYAlignment = Enum.TextYAlignment.Top
    WQtBd4T3PH.Parent = CaJqWu1ff0ESJ
    ZXKrahArrrK[vlHusXpU8C.UserId] = CaJqWu1ff0ESJ
    
    
    local Lv2V1b5x3q3 = {
        "#FF0000", 
        "#FF7F00", 
        "#FFFF00", 
        "#00FF00", 
        "#00FFFF", 
        "#0000FF", 
        "#8B00FF"  
    }
    local cYQ3vnjw7VH = 1
    local QS2gtd3p = 0
    
    local Wxz4YrGx = VmYBbTScHuqjNm.Heartbeat:Connect(function(BoSqebZL0g_7St)
        if not GRyrp96hhOWrPJ or not vlHusXpU8C.Character or not CaJqWu1ff0ESJ.Parent then
            if ZXKrahArrrK[vlHusXpU8C.UserId] then ZXKrahArrrK[vlHusXpU8C.UserId]:Destroy() ZXKrahArrrK[vlHusXpU8C.UserId] = nil end
            if INQc8AkW[vlHusXpU8C.UserId] then INQc8AkW[vlHusXpU8C.UserId]:Disconnect() INQc8AkW[vlHusXpU8C.UserId] = nil end
            return
        end
        
        
        QS2gtd3p = QS2gtd3p + BoSqebZL0g_7St
        if QS2gtd3p >= 0.2 then
            cYQ3vnjw7VH = cYQ3vnjw7VH + 1
            if cYQ3vnjw7VH > #Lv2V1b5x3q3 then
                cYQ3vnjw7VH = 1
            end
            QS2gtd3p = 0
        end
        
        local IDAd8ubVuciXJ = vlHusXpU8C.Character:FindFirstChild("Humanoid")
        if IDAd8ubVuciXJ and vlHusXpU8C:FindFirstChild("Upgrades") then
            local Si8cUUW4UyPdo = vlHusXpU8C.Upgrades:FindFirstChild("MaxSize")
            local nkJ1cMEaqT = vlHusXpU8C.Upgrades:FindFirstChild("Multiplier")
            local aUZbM1udFAk4Irr = vlHusXpU8C.Upgrades:FindFirstChild("EatSpeed")
            local WmAFsKMfE = IDAd8ubVuciXJ.WalkSpeed
            local PiWZ87fES4CAO9M = Si8cUUW4UyPdo and Si8cUUW4UyPdo.Value or 0
            local PRLV2EtvOmC0UznE = sizeGrowth(PiWZ87fES4CAO9M)
            local x4fPE1_lsN1stxhH = nkJ1cMEaqT and nkJ1cMEaqT.Value or 0
            local bfrF2lf62zLY = aUZbM1udFAk4Irr and aUZbM1udFAk4Irr.Value or 0
            local omQyIzuL2 = eatSpeedGrowth(bfrF2lf62zLY)
            local uNVJLNkV = PRLV2EtvOmC0UznE >= 10000000 and "#FF0000" or (PRLV2EtvOmC0UznE >= 100000 and "#FFFF00" or "#00FF00")
            local J4TtwbyQvisw = Lv2V1b5x3q3[cYQ3vnjw7VH]
            
            WQtBd4T3PH.Text = string.format("<font color='%s'>%s</font>\n速度: %d\n乘数: %dx\n最大体积: <font color='%s'>%d</font>\n吃速: %.1f", J4TtwbyQvisw, vlHusXpU8C.DisplayName, math.floor(WmAFsKMfE), x4fPE1_lsN1stxhH, uNVJLNkV, PRLV2EtvOmC0UznE, omQyIzuL2)
        end
    end)
    INQc8AkW[vlHusXpU8C.UserId] = Wxz4YrGx
end

local function createAllPlayersStats()
    for yVYP32Bx3Le7, vlHusXpU8C in pairs(Players:GetPlayers()) do
        if vlHusXpU8C.Character then createHeadStatsForPlayer(vlHusXpU8C) end
    end
end

local function removeAllPlayersStats()
    for qVO7oPFPUmZehQAj, CaJqWu1ff0ESJ in pairs(ZXKrahArrrK) do CaJqWu1ff0ESJ:Destroy() ZXKrahArrrK[qVO7oPFPUmZehQAj] = nil end
    for qVO7oPFPUmZehQAj, Wxz4YrGx in pairs(INQc8AkW) do Wxz4YrGx:Disconnect() INQc8AkW[qVO7oPFPUmZehQAj] = nil end
end

function toggleHeadStats(yVKutnCmMC4)
    GRyrp96hhOWrPJ = yVKutnCmMC4
    ToydCa3NiCg06.GRyrp96hhOWrPJ = yVKutnCmMC4
    saveConfig()
    if yVKutnCmMC4 then createAllPlayersStats() else removeAllPlayersStats() end
end

if GRyrp96hhOWrPJ then
    createAllPlayersStats()
end

Players.PlayerAdded:Connect(function(ebUyBEjFKB)
    ebUyBEjFKB.CharacterAdded:Connect(function()
        task.wait(0.5)
        if GRyrp96hhOWrPJ then createHeadStatsForPlayer(ebUyBEjFKB) end
    end)
end)

for yVYP32Bx3Le7, existingPlayer in pairs(Players:GetPlayers()) do
    existingPlayer.CharacterAdded:Connect(function()
        task.wait(0.5)
        if GRyrp96hhOWrPJ then createHeadStatsForPlayer(existingPlayer) end
    end)
end


createSmallButton("自定义名称", Color3.fromRGB(255, 165, 0), "📝", UDim2.new(0, 170, 0, 50), function()
    if not FE5t09ol2hiXqOFC:FindFirstChild("NameWindow") then
        local LCCUgskUD0OS = Instance.new("Frame")
        LCCUgskUD0OS.Name = "NameWindow"
        
        LCCUgskUD0OS.Size = UDim2.new(0, 320, 0, 440)
        LCCUgskUD0OS.Position = UDim2.new(0, 370, 0, 20)
        LCCUgskUD0OS.BackgroundColor3 = FvW91DGSZsdjnPyn.BackgroundColor3 
        LCCUgskUD0OS.BorderSizePixel = 0
        LCCUgskUD0OS.Visible = true
        LCCUgskUD0OS.Active = true
        LCCUgskUD0OS.Draggable = true
        LCCUgskUD0OS.Parent = FE5t09ol2hiXqOFC
        LCCUgskUD0OS.InputBegan:Connect(function(Cdi_YOd6K)
            if Cdi_YOd6K.UserInputType == Enum.UserInputType.MouseButton1 then bringToFront(LCCUgskUD0OS) end
        end)
        local fX81fECwa2 = Instance.new("UICorner")
        fX81fECwa2.CornerRadius = UDim.new(0, 10)
        fX81fECwa2.Parent = LCCUgskUD0OS
        local n5BB0pj5Rp2 = Instance.new("UIStroke")
        n5BB0pj5Rp2.Color = ZcSn2i_jp1Ia0INE.Color 
        n5BB0pj5Rp2.Thickness = 2
        n5BB0pj5Rp2.Parent = LCCUgskUD0OS
        createResizeHandle(LCCUgskUD0OS)
        local OmKWfe5yhkwJ = Instance.new("TextLabel")
        OmKWfe5yhkwJ.Size = UDim2.new(1, -25, 0, 30)
        OmKWfe5yhkwJ.Position = UDim2.new(0, 5, 0, 5)
        OmKWfe5yhkwJ.BackgroundTransparency = 1
        OmKWfe5yhkwJ.Text = "📝 自定义名称"
        OmKWfe5yhkwJ.TextColor3 = Color3.fromRGB(255, 255, 255)
        OmKWfe5yhkwJ.TextSize = 14
        OmKWfe5yhkwJ.Font = Enum.Font.GothamBold
        OmKWfe5yhkwJ.Parent = LCCUgskUD0OS
        local AZemIbPBeK = Instance.new("TextButton")
        AZemIbPBeK.Size = UDim2.new(0, 20, 0, 20)
        AZemIbPBeK.Position = UDim2.new(1, -25, 0, 5)
        AZemIbPBeK.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
        AZemIbPBeK.Text = "×"
        AZemIbPBeK.TextColor3 = Color3.fromRGB(255, 255, 255)
        AZemIbPBeK.TextSize = 12
        AZemIbPBeK.BorderSizePixel = 0
        AZemIbPBeK.Parent = LCCUgskUD0OS
        local RaZ6bN4dtRh4I = Instance.new("UICorner")
        RaZ6bN4dtRh4I.CornerRadius = UDim.new(0, 3)
        RaZ6bN4dtRh4I.Parent = AZemIbPBeK
        AZemIbPBeK.MouseButton1Click:Connect(function() LCCUgskUD0OS:Destroy() end)
        
        local C5VDS5zSU9b7rX = Instance.new("TextLabel")
        C5VDS5zSU9b7rX.Size = UDim2.new(1, -20, 0, 25)
        C5VDS5zSU9b7rX.Position = UDim2.new(0, 10, 0, 45)
        C5VDS5zSU9b7rX.BackgroundTransparency = 1
        C5VDS5zSU9b7rX.Text = "文字大小: " .. (ToydCa3NiCg06.headTextSize or 12)
        C5VDS5zSU9b7rX.TextColor3 = Color3.fromRGB(255, 255, 255)
        C5VDS5zSU9b7rX.TextSize = 14
        C5VDS5zSU9b7rX.Font = Enum.Font.GothamBold
        C5VDS5zSU9b7rX.TextXAlignment = Enum.TextXAlignment.Left
        C5VDS5zSU9b7rX.Parent = LCCUgskUD0OS
        
        local uIh94Os0LmwdJfx = Instance.new("Frame")
        uIh94Os0LmwdJfx.Size = UDim2.new(1, -20, 0, 30)
        uIh94Os0LmwdJfx.Position = UDim2.new(0, 10, 0, 75)
        uIh94Os0LmwdJfx.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
        uIh94Os0LmwdJfx.BorderSizePixel = 0
        uIh94Os0LmwdJfx.Parent = LCCUgskUD0OS
        local bTqRBtXo = Instance.new("UICorner")
        bTqRBtXo.CornerRadius = UDim.new(0, 5)
        bTqRBtXo.Parent = uIh94Os0LmwdJfx
        
        for HDDjCvBKNS, size in ipairs({8, 10, 12, 14, 16, 18}) do
            local MgjeTO4tU5DsAwt = Instance.new("TextButton")
            MgjeTO4tU5DsAwt.Size = UDim2.new(0, 45, 0, 25)
            MgjeTO4tU5DsAwt.Position = UDim2.new(0, 5 + (HDDjCvBKNS-1) * 48, 0, 2.5)
            MgjeTO4tU5DsAwt.BackgroundColor3 = size == (ToydCa3NiCg06.headTextSize or 12) and Color3.fromRGB(40, 167, 69) or Color3.fromRGB(60, 60, 80)
            MgjeTO4tU5DsAwt.Text = tostring(size)
            MgjeTO4tU5DsAwt.TextColor3 = Color3.fromRGB(255, 255, 255)
            MgjeTO4tU5DsAwt.TextSize = 12
            MgjeTO4tU5DsAwt.Font = Enum.Font.Gotham
            MgjeTO4tU5DsAwt.BorderSizePixel = 0
            MgjeTO4tU5DsAwt.Parent = uIh94Os0LmwdJfx
            local ioZEaTNn = Instance.new("UICorner")
            ioZEaTNn.CornerRadius = UDim.new(0, 4)
            ioZEaTNn.Parent = MgjeTO4tU5DsAwt
            MgjeTO4tU5DsAwt.MouseButton1Click:Connect(function()
                ToydCa3NiCg06.headTextSize = size
                saveConfig()
                updateHeadStats()
                C5VDS5zSU9b7rX.Text = "文字大小: " .. size
                for yVYP32Bx3Le7, btn in pairs(uIh94Os0LmwdJfx:GetChildren()) do
                    if btn:IsA("TextButton") then btn.BackgroundColor3 = Color3.fromRGB(60, 60, 80) end
                end
                MgjeTO4tU5DsAwt.BackgroundColor3 = Color3.fromRGB(40, 167, 69)
            end)
        end
        
        local nUU5hMuIYBupUvi = Instance.new("Frame")
        nUU5hMuIYBupUvi.Size = UDim2.new(1, -20, 0, 40)
        nUU5hMuIYBupUvi.Position = UDim2.new(0, 10, 0, 115)
        nUU5hMuIYBupUvi.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        nUU5hMuIYBupUvi.BorderSizePixel = 0
        nUU5hMuIYBupUvi.Parent = LCCUgskUD0OS
        local h5f1TSvJDfgE = Instance.new("UICorner")
        h5f1TSvJDfgE.CornerRadius = UDim.new(0, 6)
        h5f1TSvJDfgE.Parent = nUU5hMuIYBupUvi
        local GLjmy22pZ75jDF = Instance.new("TextLabel")
        GLjmy22pZ75jDF.Size = UDim2.new(1, -55, 1, 0)
        GLjmy22pZ75jDF.Position = UDim2.new(0, 10, 0, 0)
        GLjmy22pZ75jDF.BackgroundTransparency = 1
        GLjmy22pZ75jDF.Text = "头顶显示"
        GLjmy22pZ75jDF.TextColor3 = Color3.new(1, 1, 1)
        GLjmy22pZ75jDF.TextSize = 14
        GLjmy22pZ75jDF.Font = Enum.Font.Gotham
        GLjmy22pZ75jDF.TextXAlignment = Enum.TextXAlignment.Left
        GLjmy22pZ75jDF.Parent = nUU5hMuIYBupUvi
        local XsMZMdGQLD = Instance.new("TextButton")
        XsMZMdGQLD.Size = UDim2.new(0, 45, 0, 25)
        XsMZMdGQLD.Position = UDim2.new(1, -50, 0.5, -12.5)
        XsMZMdGQLD.BackgroundColor3 = GRyrp96hhOWrPJ and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
        XsMZMdGQLD.BorderSizePixel = 0
        XsMZMdGQLD.Text = ""
        XsMZMdGQLD.Parent = nUU5hMuIYBupUvi
        local o0ZMEZwsq = Instance.new("UICorner")
        o0ZMEZwsq.CornerRadius = UDim.new(1, 0)
        o0ZMEZwsq.Parent = XsMZMdGQLD
        local R1hXBfScVS = Instance.new("Frame")
        R1hXBfScVS.Size = UDim2.new(0, 19, 0, 19)
        R1hXBfScVS.Position = GRyrp96hhOWrPJ and UDim2.new(1, -22, 0.5, -9.5) or UDim2.new(0, 3, 0.5, -9.5)
        R1hXBfScVS.BackgroundColor3 = Color3.new(1, 1, 1)
        R1hXBfScVS.BorderSizePixel = 0
        R1hXBfScVS.Parent = XsMZMdGQLD
        local nVmYWOZm9PLv = Instance.new("UICorner")
        nVmYWOZm9PLv.CornerRadius = UDim.new(1, 0)
        nVmYWOZm9PLv.Parent = R1hXBfScVS
        XsMZMdGQLD.MouseButton1Click:Connect(function()
            GRyrp96hhOWrPJ = not GRyrp96hhOWrPJ
            if GRyrp96hhOWrPJ then
                XsMZMdGQLD.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
                R1hXBfScVS.Position = UDim2.new(1, -22, 0.5, -9.5)
            else
                XsMZMdGQLD.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                R1hXBfScVS.Position = UDim2.new(0, 3, 0.5, -9.5)
            end
            toggleHeadStats(GRyrp96hhOWrPJ)
        end)
        
        local xpzHCAMmir4zI = Instance.new("TextLabel")
        xpzHCAMmir4zI.Size = UDim2.new(1, -20, 0, 25)
        xpzHCAMmir4zI.Position = UDim2.new(0, 10, 0, 165)
        xpzHCAMmir4zI.BackgroundTransparency = 1
        xpzHCAMmir4zI.Text = "文字颜色"
        xpzHCAMmir4zI.TextColor3 = Color3.fromRGB(255, 255, 255)
        xpzHCAMmir4zI.TextSize = 14
        xpzHCAMmir4zI.Font = Enum.Font.GothamBold
        xpzHCAMmir4zI.TextXAlignment = Enum.TextXAlignment.Left
        xpzHCAMmir4zI.Parent = LCCUgskUD0OS
        
        
        local b_bZ9jPs = Instance.new("ScrollingFrame")
        b_bZ9jPs.Size = UDim2.new(1, -20, 0, 200)
        b_bZ9jPs.Position = UDim2.new(0, 10, 0, 195)
        b_bZ9jPs.BackgroundTransparency = 1
        b_bZ9jPs.BorderSizePixel = 0
        b_bZ9jPs.ScrollBarThickness = 6
        b_bZ9jPs.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
        b_bZ9jPs.CanvasSize = UDim2.new(0, 0, 0, 0)
        b_bZ9jPs.Parent = LCCUgskUD0OS
        
        local RRS3OEjWFAKXpx5P = Instance.new("Frame")
        RRS3OEjWFAKXpx5P.Size = UDim2.new(1, -10, 0, 0)
        RRS3OEjWFAKXpx5P.Position = UDim2.new(0, 0, 0, 0)
        RRS3OEjWFAKXpx5P.BackgroundTransparency = 1
        RRS3OEjWFAKXpx5P.Parent = b_bZ9jPs
        
        
        local wrVbz43wY = {
            
            {255,255,255,"白色"}, {0,0,0,"黑色"}, {128,128,128,"灰色"},
            
            {255,0,0,"纯红"}, {255,100,100,"浅红"}, {220,20,60,"猩红"},
            {178,34,34,"耐火砖"}, {139,0,0,"深红"}, {255,99,71,"番茄"},
            {255,69,0,"橙红"}, {205,92,92,"印度红"}, {240,128,128,"浅珊瑚"},
            {255,160,122,"鲑鱼"}, {233,150,122,"深鲑鱼"}, {250,128,114,"珊瑚"},
            
            {255,165,0,"橙色"}, {255,140,0,"深橙"}, {255,127,80,"珊瑚橙"},
            {255,215,0,"金色"}, {218,165,32,"金菊"}, {238,232,170,"灰金"},
            {240,230,140,"卡其"}, {189,183,107,"深卡其"},
            
            {255,255,0,"纯黄"}, {255,255,100,"浅黄"}, {255,215,0,"金黄"},
            {255,223,0,"柠檬黄"}, {255,250,205,"柠檬绸"}, {250,250,210,"浅金"},
            {255,239,213,"木瓜"}, {255,228,181,"麦色"}, {255,222,173,"鹿皮"},
            
            {0,255,0,"纯绿"}, {100,255,100,"浅绿"}, {50,205,50,"酸橙"},
            {0,128,0,"深绿"}, {0,100,0,"暗绿"}, {34,139,34,"森林绿"},
            {85,107,47,"暗橄榄"}, {107,142,35,"橄榄"}, {154,205,50,"黄绿"},
            {173,255,47,"绿黄"}, {127,255,0,"查特酒"}, {0,255,127,"春绿"},
            {60,179,113,"中海绿"}, {32,178,170,"浅海绿"}, {46,139,87,"海绿"},
            {128,128,0,"橄榄色"}, {144,238,144,"浅绿"}, {152,251,152,"淡绿"},
            
            {0,255,255,"青色"}, {0,206,209,"深青"}, {64,224,208,"绿松石"},
            {72,209,204,"中绿松石"}, {175,238,238,"浅青"}, {127,255,212,"碧蓝"},
            
            {0,0,255,"纯蓝"}, {100,150,255,"浅蓝"}, {30,144,255,"道奇蓝"},
            {0,0,139,"深蓝"}, {0,0,128,"藏青"}, {25,25,112,"午夜蓝"},
            {65,105,225,"皇家蓝"}, {70,130,180,"钢蓝"}, {100,149,237,"矢车菊"},
            {135,206,250,"浅天蓝"}, {135,206,235,"天蓝"}, {0,191,255,"深天蓝"},
            {30,144,255,"闪蓝"}, {123,104,238,"中紫"}, {106,90,205,"板岩蓝"},
            
            {128,0,128,"紫色"}, {255,0,255,"洋红"}, {255,150,255,"浅紫"},
            {128,0,128,"深紫"}, {139,0,139,"深洋红"}, {153,50,204,"深紫罗兰"},
            {148,0,211,"紫罗兰"}, {138,43,226,"蓝紫"}, {147,112,219,"中紫"},
            {216,191,216,"蓟色"}, {221,160,221,"梅色"}, {238,130,238,"紫罗兰"},
            {218,112,214,"兰花"}, {199,21,133,"中紫红"}, {255,20,147,"深粉"},
            
            {255,105,180,"热粉"}, {255,20,147,"深粉"}, {255,192,203,"粉红"},
            {255,182,193,"浅粉"}, {255,240,245,"薰衣草"}, {219,112,147,"紫粉"},
            
            {139,69,19,"马鞍棕"}, {160,82,45,"赭色"}, {210,105,30,"巧克力"},
            {205,133,63,"秘鲁"}, {244,164,96,"沙棕"}, {222,184,135,"鹿皮"},
            {210,180,140,"棕褐"}, {188,143,143,"玫瑰棕"}, {255,228,196,"杏仁"},
            {255,235,205,"漂白"}, {245,245,220,"米色"}, {255,250,240,"花白"},
            
            {112,128,144,"灰板岩"}, {119,136,153,"浅灰板岩"}, {176,196,222,"浅钢蓝"},
            {230,230,250,"薰衣草"}, {255,250,250,"雪色"}, {240,255,255,"天蓝"},
            {245,255,250,"薄荷"}, {255,255,240,"象牙"}, {105,105,105,"暗灰"}
        }
        
        local b5CSxABKwVo2 = 40
        local ECvO1BtDq = 100
        local otKvlLIh = 3
        local vcOJiil2PZC = math.ceil(#wrVbz43wY / otKvlLIh)
        
        
        RRS3OEjWFAKXpx5P.Size = UDim2.new(1, -10, 0, vcOJiil2PZC * b5CSxABKwVo2)
        b_bZ9jPs.CanvasSize = UDim2.new(0, 0, 0, vcOJiil2PZC * b5CSxABKwVo2)
        
        for HDDjCvBKNS, c in ipairs(wrVbz43wY) do
            local wibia0Px_EgoJP = Instance.new("TextButton")
            wibia0Px_EgoJP.Size = UDim2.new(0, 95, 0, 35)
            wibia0Px_EgoJP.Position = UDim2.new(0, ((HDDjCvBKNS-1) % otKvlLIh) * ECvO1BtDq, 0, math.floor((HDDjCvBKNS-1) / otKvlLIh) * b5CSxABKwVo2)
            wibia0Px_EgoJP.BackgroundColor3 = Color3.fromRGB(c[1], c[2], c[3])
            wibia0Px_EgoJP.Text = c[4]
            
            local Od6GBEliQ = (c[1] * 299 + c[2] * 587 + c[3] * 114) / 1000
            wibia0Px_EgoJP.TextColor3 = Od6GBEliQ < 128 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
            wibia0Px_EgoJP.TextSize = 11
            wibia0Px_EgoJP.Font = Enum.Font.Gotham
            wibia0Px_EgoJP.BorderSizePixel = 0
            wibia0Px_EgoJP.Parent = RRS3OEjWFAKXpx5P
            local Kdz5E3xj0U = Instance.new("UICorner")
            Kdz5E3xj0U.CornerRadius = UDim.new(0, 5)
            Kdz5E3xj0U.Parent = wibia0Px_EgoJP
            wibia0Px_EgoJP.MouseButton1Click:Connect(function()
                ToydCa3NiCg06.headTextColor = {c[1], c[2], c[3]}
                saveConfig()
                updateHeadStats()
            end)
        end
        
        Players.PlayerRemoving:Connect(function(qqqWs29OpDz)
            if ZXKrahArrrK[qqqWs29OpDz.UserId] then ZXKrahArrrK[qqqWs29OpDz.UserId]:Destroy() ZXKrahArrrK[qqqWs29OpDz.UserId] = nil end
            if INQc8AkW[qqqWs29OpDz.UserId] then INQc8AkW[qqqWs29OpDz.UserId]:Disconnect() INQc8AkW[qqqWs29OpDz.UserId] = nil end
        end)
    else
        local DBruMfKBK2cLf = FE5t09ol2hiXqOFC:FindFirstChild("NameWindow")
        DBruMfKBK2cLf.Visible = not DBruMfKBK2cLf.Visible
    end
end)


local OdpNjEdKcqmFYrh = false
local nMWEbNKO = 0
local WiEp__vLv5b = tick()


local aK66IjP3z3lV1o = {
    Color3.fromRGB(255, 100, 100),
    Color3.fromRGB(255, 200, 100),
    Color3.fromRGB(255, 255, 100),
    Color3.fromRGB(100, 255, 100),
    Color3.fromRGB(100, 200, 255),
    Color3.fromRGB(200, 100, 255),
}

local cYQ3vnjw7VH = 1
local lLdzVgQUoC = 0


SAfx_qyqt9C0.MouseButton1Click:Connect(function()
    OdpNjEdKcqmFYrh = not OdpNjEdKcqmFYrh
    local G8xON3POxyy4oGp = OdpNjEdKcqmFYrh and UDim2.new(0, 150, 0, 40) or UDim2.new(0, 350, 0, 450)
    local j3CeltosC = OYm6D6iFjz1bb9:Create(FvW91DGSZsdjnPyn, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = G8xON3POxyy4oGp})
    j3CeltosC:Play()
    
    PTkdnw2JeVQW.Visible = not OdpNjEdKcqmFYrh
    SAfx_qyqt9C0.Text = OdpNjEdKcqmFYrh and "+" or "—"
end)


KbmoPfDJjhOanF.MouseButton1Click:Connect(function()
    if FkVEWKVP then 
        toggleFly()
        iuVR1pDOuOZXQOVj.Visible = false
    end
    
    resetPlayerState()
    local j3CeltosC = OYm6D6iFjz1bb9:Create(FvW91DGSZsdjnPyn, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    })
    j3CeltosC:Play()
    
    j3CeltosC.Completed:Connect(function()
        FE5t09ol2hiXqOFC:Destroy()
    end)
end)

A1pA1xX1M.MouseButton1Click:Connect(function()
    avbnxhjq9Frpy3J.Visible = false
end)

e1cNV1eIDi1qJ.MouseButton1Click:Connect(function()
    ENA0mC8hhVoWDLK.Visible = false
end)


VmYBbTScHuqjNm.Heartbeat:Connect(function(BoSqebZL0g_7St)
    nMWEbNKO = nMWEbNKO + 1
    local afeFCzr1K6l6q = tick()
    
    
    if afeFCzr1K6l6q - WiEp__vLv5b >= 1 then
        local p9nohfryUGlyXV = math.floor(nMWEbNKO / (afeFCzr1K6l6q - WiEp__vLv5b))
        Z5WvKwrYWHI.Text = "帧率: " .. p9nohfryUGlyXV .. " FPS"
        gQpu0_FHRRu.Text = p9nohfryUGlyXV .. " FPS"
        wPUVYCRdE.Text = p9nohfryUGlyXV .. " FPS"  
        
        if p9nohfryUGlyXV >= 50 then
            wPUVYCRdE.TextColor3 = Color3.fromRGB(100, 255, 100)
        elseif p9nohfryUGlyXV >= 30 then
            wPUVYCRdE.TextColor3 = Color3.fromRGB(255, 255, 100)
        else
            wPUVYCRdE.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
        nMWEbNKO = 0
        WiEp__vLv5b = afeFCzr1K6l6q
    end
    
    
    if C95bVRkAIS7Fo.Character and C95bVRkAIS7Fo.Character:FindFirstChild("Humanoid") then
        local WmAFsKMfE = C95bVRkAIS7Fo.Character.Humanoid.WalkSpeed
        nKdg6Mrwe8knYrzH.Text = "速度: " .. math.floor(WmAFsKMfE)
    end
    
    
    local HgR8dBfMqYcaLGF2 = os.date("*t")
    local eGtXxsI2kPt885ZU = string.format("%02d:%02d:%02d", HgR8dBfMqYcaLGF2.hour, HgR8dBfMqYcaLGF2.min, HgR8dBfMqYcaLGF2.sec)
    kS1r1Bov.Text = "时间: " .. eGtXxsI2kPt885ZU
    
    
    local aAuN9XY5P = string.format("%02d:%02d", HgR8dBfMqYcaLGF2.hour, HgR8dBfMqYcaLGF2.min)
    qDC6231fYfrM.Text = aAuN9XY5P
    
    
    lLdzVgQUoC = lLdzVgQUoC + BoSqebZL0g_7St * 2
    
    if lLdzVgQUoC >= 1 then
        cYQ3vnjw7VH = cYQ3vnjw7VH + 1
        if cYQ3vnjw7VH > #aK66IjP3z3lV1o then
            cYQ3vnjw7VH = 1
        end
        lLdzVgQUoC = 0
    end
    
    local cmKqPjxWy5s3Q6f = aK66IjP3z3lV1o[cYQ3vnjw7VH]
    local KKgSUWny40 = cYQ3vnjw7VH + 1
    if KKgSUWny40 > #aK66IjP3z3lV1o then
        KKgSUWny40 = 1
    end
    local NeiEmhnE5ZV = aK66IjP3z3lV1o[KKgSUWny40]
    
    local ASJFVAxSjuQd = cmKqPjxWy5s3Q6f.R + (NeiEmhnE5ZV.R - cmKqPjxWy5s3Q6f.R) * lLdzVgQUoC
    local ZbLvwJOzqpS41 = cmKqPjxWy5s3Q6f.G + (NeiEmhnE5ZV.G - cmKqPjxWy5s3Q6f.G) * lLdzVgQUoC
    local iUVMuYgn1 = cmKqPjxWy5s3Q6f.B + (NeiEmhnE5ZV.B - cmKqPjxWy5s3Q6f.B) * lLdzVgQUoC
    
    ZcSn2i_jp1Ia0INE.Color = Color3.new(ASJFVAxSjuQd, ZbLvwJOzqpS41, iUVMuYgn1)
    
    wPUVYCRdE.TextStrokeColor3 = Color3.new(ASJFVAxSjuQd, ZbLvwJOzqpS41, iUVMuYgn1)
end)


FvW91DGSZsdjnPyn.Size = UDim2.new(0, 0, 0, 0)
FvW91DGSZsdjnPyn.Position = UDim2.new(0.5, 0, 0.5, 0)

local l4oDQEonW5d6 = OYm6D6iFjz1bb9:Create(FvW91DGSZsdjnPyn, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
    Size = UDim2.new(0, 350, 0, 450),
    Position = UDim2.new(0.5, -175, 0.5, -225)
})
l4oDQEonW5d6:Play()

print("🎮 小拽脚本已加载完成! - 人物状态已重置")



local aRkvK5NYG = game:GetService("ReplicatedStorage")
local nnEOVfrIcz = aRkvK5NYG:WaitForChild("Events")
local LocalPlayer = Players.LocalPlayer

local M18JZbrABgP = ToydCa3NiCg06.M18JZbrABgP or false
local Wk7hqK2jWxL = ToydCa3NiCg06.Wk7hqK2jWxL or false
local UNRf8qy6Pa1H = ToydCa3NiCg06.UNRf8qy6Pa1H or false
local tYykvAbOJ1_ = ToydCa3NiCg06.tYykvAbOJ1_ or false
local Tmha9INJgHNXL = ToydCa3NiCg06.Tmha9INJgHNXL or false
local hID5TCz7 = ToydCa3NiCg06.hID5TCz7 or false
local cwrNcp8MG7htl6q = ToydCa3NiCg06.cwrNcp8MG7htl6q or false
local ll7p6GMMAkCh = ToydCa3NiCg06.ll7p6GMMAkCh or false
local intTV0i_BskOo = ToydCa3NiCg06.intTV0i_BskOo or false
local OLjQmJWuLzisoDS = ToydCa3NiCg06.OLjQmJWuLzisoDS or false
local wdRzSs89ikHezGM = ToydCa3NiCg06.wdRzSs89ikHezGM ~= nil and ToydCa3NiCg06.wdRzSs89ikHezGM or false
local GO7O4XPC7 = ToydCa3NiCg06.GO7O4XPC7 ~= nil and ToydCa3NiCg06.GO7O4XPC7 or false

local function getRoot()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end

local function checkLoaded()
    return (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character:FindFirstChild("Size") and LocalPlayer.Character:FindFirstChild("Events") and LocalPlayer.Character.nnEOVfrIcz:FindFirstChild("Grab") and LocalPlayer.Character.nnEOVfrIcz:FindFirstChild("Eat") and LocalPlayer.Character.nnEOVfrIcz:FindFirstChild("Sell") and LocalPlayer.Character:FindFirstChild("CurrentChunk")) ~= nil
end

local function changeMap()
    local nMpdKKCrPOaF7 = {{MapTime = -1, Paused = true}}
    nnEOVfrIcz.SetServerSettings:FireServer(unpack(nMpdKKCrPOaF7))
end

local function sizeGrowth(Aouymw6WYcenKca4) return math.floor(((Aouymw6WYcenKca4 + 0.5) ^ 2 - 0.25) / 2 * 100) end
local function speedGrowth(Aouymw6WYcenKca4) return math.floor(Aouymw6WYcenKca4 * 2 + 10) end
local function multiplierGrowth(Aouymw6WYcenKca4) return math.floor(Aouymw6WYcenKca4) end
local function eatSpeedGrowth(Aouymw6WYcenKca4) return math.floor((1 + (Aouymw6WYcenKca4 - 1) * 0.2) * 10) / 10 end
local function sizePrice(Aouymw6WYcenKca4) return math.floor(Aouymw6WYcenKca4 ^ 3 / 2) * 20 end
local function speedPrice(Aouymw6WYcenKca4) return math.floor((Aouymw6WYcenKca4 * 3) ^ 3 / 200) * 1000 end
local function multiplierPrice(Aouymw6WYcenKca4) return math.floor((Aouymw6WYcenKca4 * 10) ^ 3 / 200) * 1000 end
local function eatSpeedPrice(Aouymw6WYcenKca4) return math.floor((Aouymw6WYcenKca4 * 10) ^ 3 / 200) * 2000 end

local function createEatWorldWindow(bh9XV32jiIZ, uY8Rec6T, Vrv2V9uQLZ2yW)
    local iyu3LTQNXzvK_wut = Instance.new("Frame")
    iyu3LTQNXzvK_wut.Name = bh9XV32jiIZ .. "Window"
    iyu3LTQNXzvK_wut.Size = UDim2.new(0, uY8Rec6T, 0, Vrv2V9uQLZ2yW)
    iyu3LTQNXzvK_wut.Position = UDim2.new(0.5, -uY8Rec6T/2, 0.5, -Vrv2V9uQLZ2yW/2)
    iyu3LTQNXzvK_wut.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    iyu3LTQNXzvK_wut.BorderSizePixel = 0
    iyu3LTQNXzvK_wut.Visible = false
    iyu3LTQNXzvK_wut.Active = true
    iyu3LTQNXzvK_wut.Draggable = true
    iyu3LTQNXzvK_wut.Parent = FE5t09ol2hiXqOFC
    iyu3LTQNXzvK_wut.InputBegan:Connect(function(Cdi_YOd6K)
        if Cdi_YOd6K.UserInputType == Enum.UserInputType.MouseButton1 then bringToFront(iyu3LTQNXzvK_wut) end
    end)
    local TgQyuAEYrrH = Instance.new("UICorner")
    TgQyuAEYrrH.CornerRadius = UDim.new(0, 10)
    TgQyuAEYrrH.Parent = iyu3LTQNXzvK_wut
    local _PaF74YersAKy24 = Instance.new("UIStroke")
    _PaF74YersAKy24.Color = Color3.fromRGB(100, 150, 255)
    _PaF74YersAKy24.Thickness = 2
    _PaF74YersAKy24.Parent = iyu3LTQNXzvK_wut
    createResizeHandle(iyu3LTQNXzvK_wut)
    local Fs1Cnus0Vs = Instance.new("Frame")
    Fs1Cnus0Vs.Size = UDim2.new(1, 0, 0, 35)
    Fs1Cnus0Vs.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    Fs1Cnus0Vs.BorderSizePixel = 0
    Fs1Cnus0Vs.Parent = iyu3LTQNXzvK_wut
    local rfwF5p7JAtTs = Instance.new("UICorner")
    rfwF5p7JAtTs.CornerRadius = UDim.new(0, 10)
    rfwF5p7JAtTs.Parent = Fs1Cnus0Vs
    local EUXgMowao2oI2F2o = Instance.new("TextLabel")
    EUXgMowao2oI2F2o.Size = UDim2.new(1, -40, 1, 0)
    EUXgMowao2oI2F2o.Position = UDim2.new(0, 10, 0, 0)
    EUXgMowao2oI2F2o.BackgroundTransparency = 1
    EUXgMowao2oI2F2o.Text = bh9XV32jiIZ
    EUXgMowao2oI2F2o.TextColor3 = Color3.new(1, 1, 1)
    EUXgMowao2oI2F2o.TextSize = 16
    EUXgMowao2oI2F2o.Font = Enum.Font.GothamBold
    EUXgMowao2oI2F2o.TextXAlignment = Enum.TextXAlignment.Left
    EUXgMowao2oI2F2o.Parent = Fs1Cnus0Vs
    local KbmoPfDJjhOanF = Instance.new("TextButton")
    KbmoPfDJjhOanF.Size = UDim2.new(0, 30, 0, 30)
    KbmoPfDJjhOanF.Position = UDim2.new(1, -32, 0, 2.5)
    KbmoPfDJjhOanF.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
    KbmoPfDJjhOanF.BorderSizePixel = 0
    KbmoPfDJjhOanF.Text = "×"
    KbmoPfDJjhOanF.TextColor3 = Color3.new(1, 1, 1)
    KbmoPfDJjhOanF.TextSize = 18
    KbmoPfDJjhOanF.Font = Enum.Font.GothamBold
    KbmoPfDJjhOanF.Parent = Fs1Cnus0Vs
    local kaqXRro7BpH = Instance.new("UICorner")
    kaqXRro7BpH.CornerRadius = UDim.new(0, 6)
    kaqXRro7BpH.Parent = KbmoPfDJjhOanF
    KbmoPfDJjhOanF.MouseButton1Click:Connect(function() iyu3LTQNXzvK_wut.Visible = false end)
    local YH1SQuQw1 = Instance.new("ScrollingFrame")
    YH1SQuQw1.Name = "Content"
    YH1SQuQw1.Size = UDim2.new(1, -20, 1, -50)
    YH1SQuQw1.Position = UDim2.new(0, 10, 0, 40)
    YH1SQuQw1.BackgroundTransparency = 1
    YH1SQuQw1.BorderSizePixel = 0
    YH1SQuQw1.ScrollBarThickness = 6
    YH1SQuQw1.CanvasSize = UDim2.new(0, 0, 0, 0)
    YH1SQuQw1.Parent = iyu3LTQNXzvK_wut
    local NMtteKGcqUJHJq = Instance.new("UIListLayout")
    NMtteKGcqUJHJq.Padding = UDim.new(0, 8)
    NMtteKGcqUJHJq.SortOrder = Enum.SortOrder.LayoutOrder
    NMtteKGcqUJHJq.Parent = YH1SQuQw1
    NMtteKGcqUJHJq:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        YH1SQuQw1.CanvasSize = UDim2.new(0, 0, 0, NMtteKGcqUJHJq.AbsoluteContentSize.Y + 10)
    end)
    return iyu3LTQNXzvK_wut, YH1SQuQw1
end

local function createEatToggle(w3pAtqdZFYbmq, hQJrMvzjUeYyWPoB, IfHZWvCUGtj_)
    local VSszDEto2R4m = Instance.new("Frame")
    VSszDEto2R4m.Size = UDim2.new(1, 0, 0, 40)
    VSszDEto2R4m.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    VSszDEto2R4m.BorderSizePixel = 0
    VSszDEto2R4m.Parent = w3pAtqdZFYbmq
    local TgQyuAEYrrH = Instance.new("UICorner")
    TgQyuAEYrrH.CornerRadius = UDim.new(0, 6)
    TgQyuAEYrrH.Parent = VSszDEto2R4m
    local YjNH4uabhF4PTV = Instance.new("TextLabel")
    YjNH4uabhF4PTV.Size = UDim2.new(1, -55, 1, 0)
    YjNH4uabhF4PTV.Position = UDim2.new(0, 10, 0, 0)
    YjNH4uabhF4PTV.BackgroundTransparency = 1
    YjNH4uabhF4PTV.Text = hQJrMvzjUeYyWPoB
    YjNH4uabhF4PTV.TextColor3 = Color3.new(1, 1, 1)
    YjNH4uabhF4PTV.TextSize = 14
    YjNH4uabhF4PTV.Font = Enum.Font.Gotham
    YjNH4uabhF4PTV.TextXAlignment = Enum.TextXAlignment.Left
    YjNH4uabhF4PTV.Parent = VSszDEto2R4m
    local XsMZMdGQLD = Instance.new("TextButton")
    XsMZMdGQLD.Size = UDim2.new(0, 45, 0, 25)
    XsMZMdGQLD.Position = UDim2.new(1, -50, 0.5, -12.5)
    XsMZMdGQLD.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    XsMZMdGQLD.BorderSizePixel = 0
    XsMZMdGQLD.Text = ""
    XsMZMdGQLD.Parent = VSszDEto2R4m
    local h5f1TSvJDfgE = Instance.new("UICorner")
    h5f1TSvJDfgE.CornerRadius = UDim.new(1, 0)
    h5f1TSvJDfgE.Parent = XsMZMdGQLD
    local R1hXBfScVS = Instance.new("Frame")
    R1hXBfScVS.Size = UDim2.new(0, 19, 0, 19)
    R1hXBfScVS.Position = UDim2.new(0, 3, 0.5, -9.5)
    R1hXBfScVS.BackgroundColor3 = Color3.new(1, 1, 1)
    R1hXBfScVS.BorderSizePixel = 0
    R1hXBfScVS.Parent = XsMZMdGQLD
    local nVmYWOZm9PLv = Instance.new("UICorner")
    nVmYWOZm9PLv.CornerRadius = UDim.new(1, 0)
    nVmYWOZm9PLv.Parent = R1hXBfScVS
    local yVKutnCmMC4 = false
    XsMZMdGQLD.MouseButton1Click:Connect(function()
        yVKutnCmMC4 = not yVKutnCmMC4
        if yVKutnCmMC4 then
            XsMZMdGQLD.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            R1hXBfScVS.Position = UDim2.new(1, -22, 0.5, -9.5)
        else
            XsMZMdGQLD.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            R1hXBfScVS.Position = UDim2.new(0, 3, 0.5, -9.5)
        end
        IfHZWvCUGtj_(yVKutnCmMC4)
    end)
    return VSszDEto2R4m
end

local function createEatButton(w3pAtqdZFYbmq, hQJrMvzjUeYyWPoB, IfHZWvCUGtj_)
    local T_Mwu1qOX2WQBB = Instance.new("TextButton")
    T_Mwu1qOX2WQBB.Size = UDim2.new(1, 0, 0, 40)
    T_Mwu1qOX2WQBB.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    T_Mwu1qOX2WQBB.BorderSizePixel = 0
    T_Mwu1qOX2WQBB.Text = hQJrMvzjUeYyWPoB
    T_Mwu1qOX2WQBB.TextColor3 = Color3.new(1, 1, 1)
    T_Mwu1qOX2WQBB.TextSize = 14
    T_Mwu1qOX2WQBB.Font = Enum.Font.Gotham
    T_Mwu1qOX2WQBB.Parent = w3pAtqdZFYbmq
    local TgQyuAEYrrH = Instance.new("UICorner")
    TgQyuAEYrrH.CornerRadius = UDim.new(0, 6)
    TgQyuAEYrrH.Parent = T_Mwu1qOX2WQBB
    T_Mwu1qOX2WQBB.MouseButton1Click:Connect(IfHZWvCUGtj_)
    T_Mwu1qOX2WQBB.MouseEnter:Connect(function() T_Mwu1qOX2WQBB.BackgroundColor3 = Color3.fromRGB(80, 80, 100) end)
    T_Mwu1qOX2WQBB.MouseLeave:Connect(function() T_Mwu1qOX2WQBB.BackgroundColor3 = Color3.fromRGB(60, 60, 80) end)
    return T_Mwu1qOX2WQBB
end

local RtDt4OeO5B, autoContent = createEatWorldWindow("自动", 300, 400)

createEatToggle(autoContent, "自动刷", function(yVKutnCmMC4)
    M18JZbrABgP = yVKutnCmMC4
    ToydCa3NiCg06.M18JZbrABgP = yVKutnCmMC4
    saveConfig()
    coroutine.wrap(function()
    	local hQJrMvzjUeYyWPoB = Drawing.new("Text")
    	hQJrMvzjUeYyWPoB.Outline = true
    	hQJrMvzjUeYyWPoB.OutlineColor = Color3.new(0, 0, 0)
    	hQJrMvzjUeYyWPoB.Color = Color3.new(1, 1, 1)
    	hQJrMvzjUeYyWPoB.Center = false
    	hQJrMvzjUeYyWPoB.Position = Vector2.new(64, 64)
    	hQJrMvzjUeYyWPoB.Text = ""
    	hQJrMvzjUeYyWPoB.Size = 14
    	hQJrMvzjUeYyWPoB.Visible = true
    	local KCacJJk9s = tick()
    	local gLll2Pb16BW1r = 0
    	local aObtLXLnpRP = tick()
        local wCbiIg6WPA = 0
        local tYZPFNiC3AX3 = 0
        local ZgbJsb1pp = false
        local e3ZvEb9I7 = 0
        local g7eITxhx1 = Instance.new("Part")
        g7eITxhx1.Anchored = true
        g7eITxhx1.Size = Vector3.new(2048, 10, 2048)
        g7eITxhx1.Position = Vector3.new(0, -5, 0)
        g7eITxhx1.BrickColor = BrickColor.Black()
        g7eITxhx1.Parent = workspace
        local koWKkcpQ, chunks = workspace:FindFirstChild("Map"), workspace:FindFirstChild("Chunks")
        if koWKkcpQ and chunks then koWKkcpQ.Parent, chunks.Parent = nil, nil end
        local k5G16dMGLQniRD = 0
        local XJBpdnJzD4, a77IXoE2El0PZ, size, events, eat, grab, sell, sendTrack, chunk, radius, autoConn, sizeConn
        local function onCharAdd(hF5Lj0BwH9b)
            k5G16dMGLQniRD = 0
            XJBpdnJzD4 = hF5Lj0BwH9b:WaitForChild("Humanoid")
            a77IXoE2El0PZ = hF5Lj0BwH9b:WaitForChild("HumanoidRootPart")
            size = hF5Lj0BwH9b:WaitForChild("Size")
            events = hF5Lj0BwH9b:WaitForChild("Events")
            eat = events:WaitForChild("Eat")
            grab = events:WaitForChild("Grab")
            sell = events:WaitForChild("Sell")
            chunk = hF5Lj0BwH9b:WaitForChild("CurrentChunk")
            sendTrack = hF5Lj0BwH9b:WaitForChild("SendTrack")
            radius = hF5Lj0BwH9b:WaitForChild("Radius")
            autoConn = game["Run Service"].Heartbeat:Connect(function(Uhqo6uLVd)
                if not M18JZbrABgP then autoConn:Disconnect() return end
                local MTsx6LLcArOrG = tick() - KCacJJk9s
                local vBjhSfd1rIO = math.floor(MTsx6LLcArOrG / 60 / 60)
                local jvQyUCznp = math.floor(MTsx6LLcArOrG / 60)
                local arLhbGu9N = math.floor(MTsx6LLcArOrG)
                local EQMlzvdTK7pAml8w = math.floor(gLll2Pb16BW1r / 60)
                local QfQUVKc6zjJFi86R = math.floor(gLll2Pb16BW1r)
                local MqYsfcEnHzTUn88 = g7eITxhx1.Position.Y + g7eITxhx1.Size.Y / 2 + XJBpdnJzD4.HipHeight + a77IXoE2El0PZ.Size.Y / 2
                local yyXtIavVG8uzZDM = LocalPlayer.Upgrades.Multiplier.Value / 100
                local MY5_vQqigiolO6 = LocalPlayer.Upgrades.MaxSize.Value / yyXtIavVG8uzZDM
                local KdGgfbLMS_1 = MY5_vQqigiolO6 / 2
                local JN9tea683AtWR0Tj = math.floor(KdGgfbLMS_1 / 60)
                local LJPGXl8a = math.floor(KdGgfbLMS_1)
                local KiTd6gkoYt21b = math.floor(sizeGrowth(LocalPlayer.Upgrades.MaxSize.Value) / KdGgfbLMS_1)
                local YFs4ChW2 = KiTd6gkoYt21b * 60
                local ckErlhcauQl = YFs4ChW2 * 60
                local jl0LwEYcukxPqs = ckErlhcauQl * 24
                hQJrMvzjUeYyWPoB.Text = "\n运行时间: " .. string.format("%ih%im%is", vBjhSfd1rIO, jvQyUCznp % 60, arLhbGu9N % 60) .. "\n实际时间: " .. string.format("%im%is", EQMlzvdTK7pAml8w % 60, QfQUVKc6zjJFi86R % 60) .. "\n大约时间: " .. string.format("%im%is", JN9tea683AtWR0Tj % 60, LJPGXl8a % 60) .. "\n每天: " .. jl0LwEYcukxPqs .. "\n块数: " .. k5G16dMGLQniRD
                XJBpdnJzD4:ChangeState(Enum.HumanoidStateType.Physics)
                grab:FireServer()
                a77IXoE2El0PZ.Anchored = false
                eat:FireServer()
                sendTrack:FireServer()
                if chunk.Value then
                    if wCbiIg6WPA > 0 then k5G16dMGLQniRD += 1 end
                    wCbiIg6WPA = 0
                    tYZPFNiC3AX3 += Uhqo6uLVd
                else
                    wCbiIg6WPA += Uhqo6uLVd
                    tYZPFNiC3AX3 = 0
                end
                if wCbiIg6WPA > 60 then XJBpdnJzD4.Health = 0 wCbiIg6WPA = 0 k5G16dMGLQniRD = 0 end
                if tYZPFNiC3AX3 > 15 then size.Value = LocalPlayer.Upgrades.MaxSize.Value end
                if (size.Value >= LocalPlayer.Upgrades.MaxSize.Value) or wCbiIg6WPA > 8 then
                    if wCbiIg6WPA < 8 then
                        sell:FireServer()
                        if not ZgbJsb1pp then changeMap() end
                        ZgbJsb1pp = true
                    else
                        changeMap()
                    end
                    k5G16dMGLQniRD = 0
                elseif size.Value == 0 then
                    if ZgbJsb1pp then
                        local Qvs_xI1WT = tick()
                        gLll2Pb16BW1r = Qvs_xI1WT - aObtLXLnpRP
                        aObtLXLnpRP = Qvs_xI1WT
                        e3ZvEb9I7 += 1
                    end
                    ZgbJsb1pp = false
                end
                if tYykvAbOJ1_ then
                    local SabdVeUclx = 300
                    local Tkhufhsw46 = CFrame.new(-SabdVeUclx/2, MqYsfcEnHzTUn88, -SabdVeUclx/2)
                    local ASJFVAxSjuQd = radius.Value * 1.1
                    local PXvrCfY7TZgG = (ASJFVAxSjuQd * k5G16dMGLQniRD)
                    local V1LqOHD6p5K0 = PXvrCfY7TZgG % SabdVeUclx
                    local fE4e1_rPn6jMcTDl = math.floor(PXvrCfY7TZgG / SabdVeUclx) * ASJFVAxSjuQd
                    local nbdXH5s2F = CFrame.new(V1LqOHD6p5K0, 0, fE4e1_rPn6jMcTDl + ASJFVAxSjuQd * 2)
                    if fE4e1_rPn6jMcTDl > SabdVeUclx then changeMap() k5G16dMGLQniRD = 0 end
                    a77IXoE2El0PZ.CFrame = Tkhufhsw46 * nbdXH5s2F
                else
                    a77IXoE2El0PZ.CFrame = CFrame.new(0, MqYsfcEnHzTUn88, 0)
                end
            end)
            XJBpdnJzD4.Died:Connect(function() autoConn:Disconnect() changeMap() end)
            hF5Lj0BwH9b:WaitForChild("LocalChunkManager").Enabled = false
            hF5Lj0BwH9b:WaitForChild("Animate").Enabled = false
        end
        if LocalPlayer.Character then task.spawn(onCharAdd, LocalPlayer.Character) else task.spawn(onCharAdd, LocalPlayer.CharacterAdded:Wait()) end
        local w4OGXx5Burey = LocalPlayer.CharacterAdded:Connect(onCharAdd)
        while M18JZbrABgP do
            local Uhqo6uLVd = task.wait()
            if workspace:FindFirstChild("Loading") then workspace.Loading:Destroy() end
            if koWKkcpQ and chunks then
                if Tmha9INJgHNXL then koWKkcpQ.Parent, chunks.Parent = workspace, workspace else koWKkcpQ.Parent, chunks.Parent = nil, nil end
            end
        end
        w4OGXx5Burey:Disconnect()
        if autoConn then autoConn:Disconnect() end
        if koWKkcpQ and chunks then koWKkcpQ.Parent, chunks.Parent = workspace, workspace end
        XJBpdnJzD4:ChangeState(Enum.HumanoidStateType.GettingUp)
        g7eITxhx1:Destroy()
        LocalPlayer.Character.LocalChunkManager.Enabled = true
        LocalPlayer.Character.Animate.Enabled = true
        hQJrMvzjUeYyWPoB:Destroy()
    end)()
end)

createEatToggle(autoContent, "自动收", function(yVKutnCmMC4)
    Wk7hqK2jWxL = yVKutnCmMC4
    ToydCa3NiCg06.Wk7hqK2jWxL = yVKutnCmMC4
    saveConfig()
    coroutine.wrap(function()
        LocalPlayer.PlayerScripts.CubeVis.Enabled = false
        while Wk7hqK2jWxL do
            task.wait()
            local a77IXoE2El0PZ = getRoot()
            if a77IXoE2El0PZ then
                for yVYP32Bx3Le7, v in workspace:GetChildren() do
                    if v.Name == "Cube" and v:FindFirstChild("Owner") and (v.Owner.Value == LocalPlayer.Name or v.Owner.Value == "") then
                        v.CFrame = a77IXoE2El0PZ.CFrame
                    end
                end
            end
        end
        LocalPlayer.PlayerScripts.CubeVis.Enabled = true
    end)()
end)

createEatToggle(autoContent, "自动领", function(yVKutnCmMC4)
    UNRf8qy6Pa1H = yVKutnCmMC4
    ToydCa3NiCg06.UNRf8qy6Pa1H = yVKutnCmMC4
    saveConfig()
    coroutine.wrap(function()
        while UNRf8qy6Pa1H do
            task.wait(1)
            for yVYP32Bx3Le7, reward in LocalPlayer.TimedRewards:GetChildren() do
                if reward.Value > 0 then nnEOVfrIcz.RewardEvent:FireServer(reward) end
            end
            nnEOVfrIcz.SpinEvent:FireServer()
        end
    end)()
end)

createEatToggle(autoContent, "移动模式", function(yVKutnCmMC4) tYykvAbOJ1_ = yVKutnCmMC4 ToydCa3NiCg06.tYykvAbOJ1_ = yVKutnCmMC4 saveConfig() end)
createEatToggle(autoContent, "显示地图", function(yVKutnCmMC4) Tmha9INJgHNXL = yVKutnCmMC4 ToydCa3NiCg06.Tmha9INJgHNXL = yVKutnCmMC4 saveConfig() end)

createEatToggle(autoContent, "自动吃", function(yVKutnCmMC4)
    hID5TCz7 = yVKutnCmMC4
    ToydCa3NiCg06.hID5TCz7 = yVKutnCmMC4
    saveConfig()
    coroutine.wrap(function()
        while hID5TCz7 do
            local Uhqo6uLVd = task.wait()
            if checkLoaded() then
                LocalPlayer.Character.HumanoidRootPart.Anchored = false
                LocalPlayer.Character.nnEOVfrIcz.Grab:FireServer()
                LocalPlayer.Character.nnEOVfrIcz.Eat:FireServer()
            end
        end
    end)()
end)

local pHOzlO0j, upgradeContent = createEatWorldWindow("升级", 300, 300)

createEatToggle(upgradeContent, "大小", function(yVKutnCmMC4)
    cwrNcp8MG7htl6q = yVKutnCmMC4
    ToydCa3NiCg06.cwrNcp8MG7htl6q = yVKutnCmMC4
    saveConfig()
    coroutine.wrap(function()
        game.CoreGui.PurchasePromptApp.Enabled = false
        while cwrNcp8MG7htl6q do task.wait(1) nnEOVfrIcz.PurchaseEvent:FireServer("MaxSize") end
        game.CoreGui.PurchasePromptApp.Enabled = true
    end)()
end)

createEatToggle(upgradeContent, "移速", function(yVKutnCmMC4)
    ll7p6GMMAkCh = yVKutnCmMC4
    ToydCa3NiCg06.ll7p6GMMAkCh = yVKutnCmMC4
    saveConfig()
    coroutine.wrap(function()
        game.CoreGui.PurchasePromptApp.Enabled = false
        while ll7p6GMMAkCh do task.wait(1) nnEOVfrIcz.PurchaseEvent:FireServer("Speed") end
        game.CoreGui.PurchasePromptApp.Enabled = true
    end)()
end)

createEatToggle(upgradeContent, "乘数", function(yVKutnCmMC4)
    intTV0i_BskOo = yVKutnCmMC4
    ToydCa3NiCg06.intTV0i_BskOo = yVKutnCmMC4
    saveConfig()
    coroutine.wrap(function()
        game.CoreGui.PurchasePromptApp.Enabled = false
        while intTV0i_BskOo do task.wait(1) nnEOVfrIcz.PurchaseEvent:FireServer("Multiplier") end
        game.CoreGui.PurchasePromptApp.Enabled = true
    end)()
end)

createEatToggle(upgradeContent, "吃速", function(yVKutnCmMC4)
    OLjQmJWuLzisoDS = yVKutnCmMC4
    ToydCa3NiCg06.OLjQmJWuLzisoDS = yVKutnCmMC4
    saveConfig()
    coroutine.wrap(function()
        game.CoreGui.PurchasePromptApp.Enabled = false
        while OLjQmJWuLzisoDS do task.wait(1) nnEOVfrIcz.PurchaseEvent:FireServer("EatSpeed") end
        game.CoreGui.PurchasePromptApp.Enabled = true
    end)()
end)

local IJ6tcDbmjlO86Tu, figureContent = createEatWorldWindow("人物", 300, 250)

createEatToggle(figureContent, "取消锚固", function(yVKutnCmMC4)
    wdRzSs89ikHezGM = yVKutnCmMC4
    ToydCa3NiCg06.wdRzSs89ikHezGM = yVKutnCmMC4
    saveConfig()
    coroutine.wrap(function()
        while wdRzSs89ikHezGM do
            task.wait()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.Anchored = false
            end
        end
    end)()
end)

createEatToggle(figureContent, "边界保护", function(yVKutnCmMC4)
    GO7O4XPC7 = yVKutnCmMC4
    ToydCa3NiCg06.GO7O4XPC7 = yVKutnCmMC4
    saveConfig()
    coroutine.wrap(function()
        while GO7O4XPC7 do
            task.wait()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local a77IXoE2El0PZ = LocalPlayer.Character.HumanoidRootPart
                local dRyFAONyPUc2e = a77IXoE2El0PZ.Position
                local bVvyc7Iqz = workspace.Map.Bedrock.Size * Vector3.new(1, 0, 1)
                local tI2xMQnJlGj = Vector3.new(math.clamp(dRyFAONyPUc2e.X, -bVvyc7Iqz.X / 2, bVvyc7Iqz.X / 2), dRyFAONyPUc2e.Y, math.clamp(dRyFAONyPUc2e.Z, -bVvyc7Iqz.Z / 2, bVvyc7Iqz.Z / 2))
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(tI2xMQnJlGj) * a77IXoE2El0PZ.CFrame.Rotation
            end
        end
    end)()
end)

local E0ljoOb8HAatd, otherContent = createEatWorldWindow("其它", 300, 250)

createEatButton(otherContent, "查看玩家数据", function()
    local fmlOi4SmAjKS = {MaxSize = "体积", Speed = "移速", Multiplier = "乘数", EatSpeed = "吃速"}
    local uMApN0ek = {MaxSize = sizeGrowth, Speed = speedGrowth, Multiplier = multiplierGrowth, EatSpeed = eatSpeedGrowth}
    local RTpdpoWyo0Uzye = {MaxSize = sizePrice, Speed = speedPrice, Multiplier = multiplierPrice, EatSpeed = eatSpeedPrice}
    for yVYP32Bx3Le7, C95bVRkAIS7Fo in Players:GetPlayers() do
        print()
        for yVYP32Bx3Le7, upg in C95bVRkAIS7Fo.Upgrades:GetChildren() do
            local YH1SQuQw1 = C95bVRkAIS7Fo.Name .. "："
            local _oHELpDddv0k5 = 0
            for jkMr3BAs9EafQU6 = 2, upg.Value do _oHELpDddv0k5 += RTpdpoWyo0Uzye[upg.Name](jkMr3BAs9EafQU6) end
            YH1SQuQw1 = YH1SQuQw1 .. " " .. fmlOi4SmAjKS[upg.Name] .. "：" .. upg.Value .. "级；" .. uMApN0ek[upg.Name](upg.Value) .. "值；" .. _oHELpDddv0k5 .. "花费；"
            print(YH1SQuQw1)
        end
    end
    game.StarterGui:SetCore("DevConsoleVisible", true)
end)

createEatToggle(otherContent, "竖屏", function(yVKutnCmMC4)
    LocalPlayer.PlayerGui.ScreenOrientation = yVKutnCmMC4 and Enum.ScreenOrientation.Portrait or Enum.ScreenOrientation.LandscapeRight
end)

BcyVfvc7eI6HfM5Y.Size = UDim2.new(1, 0, 0, 210)

local Ryvf1nL8 = 95
createSmallButton("自动", Color3.fromRGB(255, 165, 0), "🤖", UDim2.new(0, 5, 0, Ryvf1nL8), function()
    RtDt4OeO5B.Visible = not RtDt4OeO5B.Visible
    avbnxhjq9Frpy3J.Visible = false
    ENA0mC8hhVoWDLK.Visible = false
    pHOzlO0j.Visible = false
    IJ6tcDbmjlO86Tu.Visible = false
    E0ljoOb8HAatd.Visible = false
end)

createSmallButton("升级", Color3.fromRGB(34, 139, 34), "⬆️", UDim2.new(0, 170, 0, Ryvf1nL8), function()
    pHOzlO0j.Visible = not pHOzlO0j.Visible
    avbnxhjq9Frpy3J.Visible = false
    ENA0mC8hhVoWDLK.Visible = false
    RtDt4OeO5B.Visible = false
    IJ6tcDbmjlO86Tu.Visible = false
    E0ljoOb8HAatd.Visible = false
end)

createSmallButton("人物", Color3.fromRGB(138, 43, 226), "👤", UDim2.new(0, 5, 0, Ryvf1nL8 + 45), function()
    IJ6tcDbmjlO86Tu.Visible = not IJ6tcDbmjlO86Tu.Visible
    avbnxhjq9Frpy3J.Visible = false
    ENA0mC8hhVoWDLK.Visible = false
    RtDt4OeO5B.Visible = false
    pHOzlO0j.Visible = false
    E0ljoOb8HAatd.Visible = false
end)

createSmallButton("其它", Color3.fromRGB(70, 130, 180), "📋", UDim2.new(0, 170, 0, Ryvf1nL8 + 45), function()
    E0ljoOb8HAatd.Visible = not E0ljoOb8HAatd.Visible
    avbnxhjq9Frpy3J.Visible = false
    ENA0mC8hhVoWDLK.Visible = false
    RtDt4OeO5B.Visible = false
    pHOzlO0j.Visible = false
    IJ6tcDbmjlO86Tu.Visible = false
end)

print("🎮 小拽脚本 + 吃吃世界功能已加载完成!")



local function resetAllFeatures()
    if FkVEWKVP then
        FkVEWKVP = false
        if S14m31hLm then S14m31hLm:Destroy() S14m31hLm = nil end
        if xXsXKxzswNH4 then xXsXKxzswNH4:Destroy() xXsXKxzswNH4 = nil end
        BMfvIQb1MLiXPS.Text = "开启飞天"
        BMfvIQb1MLiXPS.BackgroundColor3 = Color3.fromRGB(255, 193, 7)
        BMfvIQb1MLiXPS.TextColor3 = Color3.fromRGB(0, 0, 0)
        iuVR1pDOuOZXQOVj.Visible = false
    end
    M18JZbrABgP = false
    Wk7hqK2jWxL = false
    UNRf8qy6Pa1H = false
    tYykvAbOJ1_ = false
    Tmha9INJgHNXL = false
    hID5TCz7 = false
    cwrNcp8MG7htl6q = false
    ll7p6GMMAkCh = false
    intTV0i_BskOo = false
    OLjQmJWuLzisoDS = false
    wdRzSs89ikHezGM = false
    GO7O4XPC7 = false
    resetPlayerState()
    local koWKkcpQ, chunks = workspace:FindFirstChild("Map"), workspace:FindFirstChild("Chunks")
    if koWKkcpQ and chunks and (koWKkcpQ.Parent == nil or chunks.Parent == nil) then
        koWKkcpQ.Parent, chunks.Parent = workspace, workspace
    end
    if C95bVRkAIS7Fo.Character then
        local oVjBrBWJva_ = C95bVRkAIS7Fo.Character:FindFirstChild("LocalChunkManager")
        local dg0MCizjJZp = C95bVRkAIS7Fo.Character:FindFirstChild("Animate")
        if oVjBrBWJva_ then oVjBrBWJva_.Enabled = true end
        if dg0MCizjJZp then dg0MCizjJZp.Enabled = true end
    end
    print("✅ 所有功能已重置")
end

BcyVfvc7eI6HfM5Y.Size = UDim2.new(1, 0, 0, 255)


local jEI0cSelsz2MG = {}


local function createCountdownUI()
    local FE5t09ol2hiXqOFC = Instance.new("ScreenGui")
    FE5t09ol2hiXqOFC.Name = "ServerSearchUI"
    FE5t09ol2hiXqOFC.ResetOnSpawn = false
    FE5t09ol2hiXqOFC.ZIndexBehavior = Enum.ZIndexBehavior.Global
    FE5t09ol2hiXqOFC.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    
    
    local nJonyUIR2u9jRW = Instance.new("Frame")
    nJonyUIR2u9jRW.Name = "Background"
    nJonyUIR2u9jRW.Size = UDim2.new(1, 0, 1, 0)
    nJonyUIR2u9jRW.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    nJonyUIR2u9jRW.BackgroundTransparency = 0.5
    nJonyUIR2u9jRW.BorderSizePixel = 0
    nJonyUIR2u9jRW.Parent = FE5t09ol2hiXqOFC
    
    
    local FvW91DGSZsdjnPyn = Instance.new("Frame")
    FvW91DGSZsdjnPyn.Name = "MainFrame"
    FvW91DGSZsdjnPyn.Size = UDim2.new(0, 400, 0, 200)
    FvW91DGSZsdjnPyn.Position = UDim2.new(0.5, -200, 0.5, -100)
    FvW91DGSZsdjnPyn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    FvW91DGSZsdjnPyn.BorderSizePixel = 0
    FvW91DGSZsdjnPyn.Parent = FE5t09ol2hiXqOFC
    
    local TgQyuAEYrrH = Instance.new("UICorner")
    TgQyuAEYrrH.CornerRadius = UDim.new(0, 15)
    TgQyuAEYrrH.Parent = FvW91DGSZsdjnPyn
    
    local BU9d3o_8ATQ1 = Instance.new("UIStroke")
    BU9d3o_8ATQ1.Color = Color3.fromRGB(100, 200, 100)
    BU9d3o_8ATQ1.Thickness = 3
    BU9d3o_8ATQ1.Parent = FvW91DGSZsdjnPyn
    
    
    local EUXgMowao2oI2F2o = Instance.new("TextLabel")
    EUXgMowao2oI2F2o.Name = "Title"
    EUXgMowao2oI2F2o.Size = UDim2.new(1, 0, 0, 50)
    EUXgMowao2oI2F2o.Position = UDim2.new(0, 0, 0, 10)
    EUXgMowao2oI2F2o.BackgroundTransparency = 1
    EUXgMowao2oI2F2o.Text = "🔍 搜索服务器中..."
    EUXgMowao2oI2F2o.TextColor3 = Color3.fromRGB(255, 255, 255)
    EUXgMowao2oI2F2o.TextSize = 24
    EUXgMowao2oI2F2o.Font = Enum.Font.GothamBold
    EUXgMowao2oI2F2o.Parent = FvW91DGSZsdjnPyn
    
    
    local Thjge21EL6Rn8kd2 = Instance.new("TextLabel")
    Thjge21EL6Rn8kd2.Name = "Countdown"
    Thjge21EL6Rn8kd2.Size = UDim2.new(1, 0, 0, 80)
    Thjge21EL6Rn8kd2.Position = UDim2.new(0, 0, 0, 70)
    Thjge21EL6Rn8kd2.BackgroundTransparency = 1
    Thjge21EL6Rn8kd2.Text = "5"
    Thjge21EL6Rn8kd2.TextColor3 = Color3.fromRGB(100, 255, 100)
    Thjge21EL6Rn8kd2.TextSize = 60
    Thjge21EL6Rn8kd2.Font = Enum.Font.GothamBold
    Thjge21EL6Rn8kd2.Parent = FvW91DGSZsdjnPyn
    
    
    local EKwM0WtgCSDeji = Instance.new("TextLabel")
    EKwM0WtgCSDeji.Name = "Status"
    EKwM0WtgCSDeji.Size = UDim2.new(1, 0, 0, 30)
    EKwM0WtgCSDeji.Position = UDim2.new(0, 0, 0, 150)
    EKwM0WtgCSDeji.BackgroundTransparency = 1
    EKwM0WtgCSDeji.Text = "正在获取服务器列表..."
    EKwM0WtgCSDeji.TextColor3 = Color3.fromRGB(200, 200, 200)
    EKwM0WtgCSDeji.TextSize = 14
    EKwM0WtgCSDeji.Font = Enum.Font.Gotham
    EKwM0WtgCSDeji.Parent = FvW91DGSZsdjnPyn
    
    return {
        FE5t09ol2hiXqOFC = FE5t09ol2hiXqOFC,
        Thjge21EL6Rn8kd2 = Thjge21EL6Rn8kd2,
        EKwM0WtgCSDeji = EKwM0WtgCSDeji,
        EUXgMowao2oI2F2o = EUXgMowao2oI2F2o
    }
end


createSmallButton("随机服务器", Color3.fromRGB(100, 200, 100), "🎲", UDim2.new(0, 5, 0, Ryvf1nL8 + 90), function()
    local rCbtR873T23 = game:GetService("TeleportService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Vi6W5cvA0TS6 = game:GetService("HttpService")
    local VmYBbTScHuqjNm = game:GetService("RunService")
    
    
    local P7cjq77us = game.PlaceId
    local WIWViM4SPEyiY = game.JobId
    
    
    jEI0cSelsz2MG[WIWViM4SPEyiY] = true
    
    print("🎲 开始随机服务器跳转...")
    print("📍 当前服务器ID: " .. tostring(WIWViM4SPEyiY))
    
    
    local LzdBDoBw = createCountdownUI()
    local P9YGvSoAetUH = 5
    local fRb8Y5rGK_HJ = false
    local iPqbhHiv0i_WrM = nil
    
    
    task.spawn(function()
        while P9YGvSoAetUH > 0 and not fRb8Y5rGK_HJ do
            LzdBDoBw.Thjge21EL6Rn8kd2.Text = tostring(P9YGvSoAetUH)
            task.wait(1)
            P9YGvSoAetUH = P9YGvSoAetUH - 1
        end
        
        if not fRb8Y5rGK_HJ then
            LzdBDoBw.Thjge21EL6Rn8kd2.Text = "..."
            LzdBDoBw.EKwM0WtgCSDeji.Text = "仍在搜索中，请稍候..."
        end
    end)
    
    
    task.spawn(function()
        
        local t03MMhzTPY = 0
        for yVYP32Bx3Le7 in pairs(jEI0cSelsz2MG) do t03MMhzTPY = t03MMhzTPY + 1 end
        print("📋 已访问服务器数量: " .. t03MMhzTPY)
        
        
        local Lvabr_SMlQzp = {}
        local G9kGBHjKtmn = {}
        local bC3yP5w8Aur = false
        
        
        local zYkEp_TUcQnN = nil
        if typeof(request) == "function" then
            zYkEp_TUcQnN = request
        elseif typeof(syn) == "table" and typeof(syn.request) == "function" then
            zYkEp_TUcQnN = syn.request
        elseif typeof(http) == "table" and typeof(http.request) == "function" then
            zYkEp_TUcQnN = http.request
        elseif typeof(fluxus) == "table" and typeof(fluxus.request) == "function" then
            zYkEp_TUcQnN = fluxus.request
        elseif typeof(getgenv) == "function" and typeof(getgenv().request) == "function" then
            zYkEp_TUcQnN = getgenv().request
        end
        
        
        LzdBDoBw.EKwM0WtgCSDeji.Text = "正在连接服务器..."
        print("🌐 正在获取服务器列表...")
        
        
        local ZWQ8Nhbw2em = 5
        local _KyTYgKHl = 0
        local XePiHMaA4l6 = false
        
        while _KyTYgKHl < ZWQ8Nhbw2em and #Lvabr_SMlQzp == 0 do
            _KyTYgKHl = _KyTYgKHl + 1
            
            local S9BJXofe6wqx, result = pcall(function()
                local ftBKYGzS0 = "https://games.roblox.com/v1/games/" .. P7cjq77us .. "/servers/Public?sortOrder=Asc&limit=100"
                local k7BI9pRo9AkQ = game:HttpGet(ftBKYGzS0, true)
                if k7BI9pRo9AkQ then
                    
                    if string.find(k7BI9pRo9AkQ, "Too Many Requests") or string.find(k7BI9pRo9AkQ, "Rate Limit") then
                        XePiHMaA4l6 = true
                        return
                    end
                    
                    local QLm9wNXp = Vi6W5cvA0TS6:JSONDecode(k7BI9pRo9AkQ)
                    if QLm9wNXp and QLm9wNXp.data then
                        for yVYP32Bx3Le7, server in ipairs(QLm9wNXp.data) do
                            if server.playing < server.maxPlayers then
                                table.insert(Lvabr_SMlQzp, server.id)
                                if not jEI0cSelsz2MG[server.id] then
                                    table.insert(G9kGBHjKtmn, server.id)
                                end
                            end
                        end
                    end
                end
            end)
            
            if #Lvabr_SMlQzp > 0 then
                bC3yP5w8Aur = true
                print("✅ 第 " .. _KyTYgKHl .. " 次尝试成功，获取到 " .. #Lvabr_SMlQzp .. " 个服务器")
                break
            elseif XePiHMaA4l6 then
                LzdBDoBw.EKwM0WtgCSDeji.Text = "请求过于频繁，等待中..."
                print("⚠️ 检测到速率限制，等待3秒...")
                task.wait(3)
                XePiHMaA4l6 = false
            else
                LzdBDoBw.EKwM0WtgCSDeji.Text = "尝试 " .. _KyTYgKHl .. "/" .. ZWQ8Nhbw2em .. "..."
                task.wait(0.1)
            end
        end
        
        
        if not bC3yP5w8Aur and zYkEp_TUcQnN then
            print("🔄 尝试使用 request...")
            
            local S9BJXofe6wqx = pcall(function()
                local k7BI9pRo9AkQ = zYkEp_TUcQnN({
                    Url = "https://games.roblox.com/v1/games/" .. P7cjq77us .. "/servers/Public?sortOrder=Asc&limit=100",
                    Method = "GET"
                })
                
                if k7BI9pRo9AkQ and k7BI9pRo9AkQ.Body then
                    local QLm9wNXp = Vi6W5cvA0TS6:JSONDecode(k7BI9pRo9AkQ.Body)
                    if QLm9wNXp and QLm9wNXp.data then
                        for yVYP32Bx3Le7, server in ipairs(QLm9wNXp.data) do
                            if server.playing < server.maxPlayers then
                                table.insert(Lvabr_SMlQzp, server.id)
                                if not jEI0cSelsz2MG[server.id] then
                                    table.insert(G9kGBHjKtmn, server.id)
                                end
                            end
                        end
                    end
                end
            end)
            
            bC3yP5w8Aur = #Lvabr_SMlQzp > 0
        end
        
        LzdBDoBw.EKwM0WtgCSDeji.Text = "已找到 " .. #Lvabr_SMlQzp .. " 个服务器..."
        
        if not bC3yP5w8Aur then
            print("⚠️ 无法获取服务器列表（已尝试 " .. ZWQ8Nhbw2em .. " 次）")
            LzdBDoBw.EKwM0WtgCSDeji.Text = "无法获取服务器列表，请稍后再试"
            task.wait(1)
        end
        
        
        if bC3yP5w8Aur then
            
            if #G9kGBHjKtmn > 0 then
                math.randomseed(tick())
                local r7ExEgNaTKiDu2LT = math.random(1, #G9kGBHjKtmn)
                iPqbhHiv0i_WrM = G9kGBHjKtmn[r7ExEgNaTKiDu2LT]
                print("🎯 选中未访问过的服务器")
            elseif #Lvabr_SMlQzp > 0 then
                
                print("⚠️ 所有获取到的服务器都已访问过，随机选择...")
                math.randomseed(tick())
                local r7ExEgNaTKiDu2LT = math.random(1, #Lvabr_SMlQzp)
                iPqbhHiv0i_WrM = Lvabr_SMlQzp[r7ExEgNaTKiDu2LT]
            end
        end
        
        fRb8Y5rGK_HJ = true
        
        
        if iPqbhHiv0i_WrM then
            jEI0cSelsz2MG[iPqbhHiv0i_WrM] = true
            LzdBDoBw.EUXgMowao2oI2F2o.Text = "✅ 找到服务器！"
            LzdBDoBw.EUXgMowao2oI2F2o.TextColor3 = Color3.fromRGB(100, 255, 100)
            LzdBDoBw.Thjge21EL6Rn8kd2.Text = "🚀"
            LzdBDoBw.EKwM0WtgCSDeji.Text = "正在传送..."
            LzdBDoBw.EKwM0WtgCSDeji.TextColor3 = Color3.fromRGB(100, 255, 100)
            
            print("🎯 目标服务器ID: " .. tostring(iPqbhHiv0i_WrM))
            print("🚀 正在传送...")
            
            task.wait(0.5)
            LzdBDoBw.FE5t09ol2hiXqOFC:Destroy()
            
            local S9BJXofe6wqx, err = pcall(function()
                rCbtR873T23:TeleportToPlaceInstance(P7cjq77us, iPqbhHiv0i_WrM, LocalPlayer)
            end)
            
            if not S9BJXofe6wqx then
                print("❌ 传送失败: " .. tostring(err))
            end
        else
            LzdBDoBw.EUXgMowao2oI2F2o.Text = "❌ 未找到服务器"
            LzdBDoBw.EUXgMowao2oI2F2o.TextColor3 = Color3.fromRGB(255, 100, 100)
            LzdBDoBw.Thjge21EL6Rn8kd2.Text = "✕"
            LzdBDoBw.EKwM0WtgCSDeji.Text = "请稍后重试"
            LzdBDoBw.EKwM0WtgCSDeji.TextColor3 = Color3.fromRGB(255, 100, 100)
            
            print("❌ 没有可用的目标服务器")
            
            task.wait(2)
            LzdBDoBw.FE5t09ol2hiXqOFC:Destroy()
        end
    end)
end)


createSmallButton("白名单", Color3.fromRGB(100, 150, 255), "👥", UDim2.new(0, 170, 0, Ryvf1nL8 + 90), function()
    
    local JG2HKJP4O9Ss9zR = Instance.new("ScreenGui")
    JG2HKJP4O9Ss9zR.Name = "WhitelistManager"
    JG2HKJP4O9Ss9zR.ResetOnSpawn = false
    JG2HKJP4O9Ss9zR.ZIndexBehavior = Enum.ZIndexBehavior.Global
    JG2HKJP4O9Ss9zR.Parent = _hrcuja6AesCfK0
    
    
    local RcnZXNa4Ej = Instance.new("Frame")
    RcnZXNa4Ej.Name = "WhitelistFrame"
    RcnZXNa4Ej.Size = UDim2.new(0, 450, 0, 400)
    RcnZXNa4Ej.Position = UDim2.new(0.5, -225, 0.5, -200)
    RcnZXNa4Ej.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
    RcnZXNa4Ej.BorderSizePixel = 0
    RcnZXNa4Ej.Active = true
    RcnZXNa4Ej.Draggable = true
    RcnZXNa4Ej.Parent = JG2HKJP4O9Ss9zR
    
    
    local TgQyuAEYrrH = Instance.new("UICorner")
    TgQyuAEYrrH.CornerRadius = UDim.new(0, 12)
    TgQyuAEYrrH.Parent = RcnZXNa4Ej
    
    
    local _PaF74YersAKy24 = Instance.new("UIStroke")
    _PaF74YersAKy24.Color = Color3.fromRGB(100, 150, 255)
    _PaF74YersAKy24.Thickness = 3
    _PaF74YersAKy24.Parent = RcnZXNa4Ej
    
    
    local Fs1Cnus0Vs = Instance.new("Frame")
    Fs1Cnus0Vs.Size = UDim2.new(1, 0, 0, 40)
    Fs1Cnus0Vs.Position = UDim2.new(0, 0, 0, 0)
    Fs1Cnus0Vs.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
    Fs1Cnus0Vs.BorderSizePixel = 0
    Fs1Cnus0Vs.Parent = RcnZXNa4Ej
    
    local rfwF5p7JAtTs = Instance.new("UICorner")
    rfwF5p7JAtTs.CornerRadius = UDim.new(0, 12)
    rfwF5p7JAtTs.Parent = Fs1Cnus0Vs
    
    
    local EUXgMowao2oI2F2o = Instance.new("TextLabel")
    EUXgMowao2oI2F2o.Size = UDim2.new(1, -20, 1, 0)
    EUXgMowao2oI2F2o.Position = UDim2.new(0, 10, 0, 0)
    EUXgMowao2oI2F2o.BackgroundTransparency = 1
    EUXgMowao2oI2F2o.Text = "👥 白名单管理"
    EUXgMowao2oI2F2o.TextColor3 = Color3.fromRGB(255, 255, 255)
    EUXgMowao2oI2F2o.TextSize = 18
    EUXgMowao2oI2F2o.Font = Enum.Font.GothamBold
    EUXgMowao2oI2F2o.TextXAlignment = Enum.TextXAlignment.Left
    EUXgMowao2oI2F2o.Parent = Fs1Cnus0Vs
    
    
    local KbmoPfDJjhOanF = Instance.new("TextButton")
    KbmoPfDJjhOanF.Size = UDim2.new(0, 30, 0, 30)
    KbmoPfDJjhOanF.Position = UDim2.new(1, -35, 0, 5)
    KbmoPfDJjhOanF.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
    KbmoPfDJjhOanF.Text = "✕"
    KbmoPfDJjhOanF.TextColor3 = Color3.fromRGB(255, 255, 255)
    KbmoPfDJjhOanF.TextScaled = true
    KbmoPfDJjhOanF.Font = Enum.Font.GothamBold
    KbmoPfDJjhOanF.BorderSizePixel = 0
    KbmoPfDJjhOanF.Parent = Fs1Cnus0Vs
    
    local XGUFSumFmnGbhnu = Instance.new("UICorner")
    XGUFSumFmnGbhnu.CornerRadius = UDim.new(0, 6)
    XGUFSumFmnGbhnu.Parent = KbmoPfDJjhOanF
    
    
    local PTkdnw2JeVQW = Instance.new("Frame")
    PTkdnw2JeVQW.Size = UDim2.new(1, -20, 1, -60)
    PTkdnw2JeVQW.Position = UDim2.new(0, 10, 0, 50)
    PTkdnw2JeVQW.BackgroundTransparency = 1
    PTkdnw2JeVQW.Parent = RcnZXNa4Ej
    
    
    local vfwc4ci9glx = Instance.new("TextLabel")
    vfwc4ci9glx.Size = UDim2.new(1, 0, 0, 25)
    vfwc4ci9glx.Position = UDim2.new(0, 0, 0, 10)
    vfwc4ci9glx.BackgroundTransparency = 1
    vfwc4ci9glx.Text = "当前白名单用户："
    vfwc4ci9glx.TextColor3 = Color3.fromRGB(255, 255, 255)
    vfwc4ci9glx.TextSize = 16
    vfwc4ci9glx.Font = Enum.Font.GothamBold
    vfwc4ci9glx.TextXAlignment = Enum.TextXAlignment.Left
    vfwc4ci9glx.Parent = PTkdnw2JeVQW
    
    
    local o1A7i7lZ = Instance.new("TextLabel")
    o1A7i7lZ.Size = UDim2.new(1, 0, 0, 80)
    o1A7i7lZ.Position = UDim2.new(0, 0, 0, 35)
    o1A7i7lZ.BackgroundTransparency = 1
    o1A7i7lZ.Text = table.concat(OiPzYuYszKYAh, ", ")
    o1A7i7lZ.TextColor3 = Color3.fromRGB(200, 255, 200)
    o1A7i7lZ.TextSize = 14
    o1A7i7lZ.Font = Enum.Font.Gotham
    o1A7i7lZ.TextXAlignment = Enum.TextXAlignment.Left
    o1A7i7lZ.TextWrapped = true
    o1A7i7lZ.Parent = PTkdnw2JeVQW
    
    
    local y2sOBf4RXiSq = Instance.new("TextLabel")
    y2sOBf4RXiSq.Size = UDim2.new(1, 0, 0, 25)
    y2sOBf4RXiSq.Position = UDim2.new(0, 0, 0, 125)
    y2sOBf4RXiSq.BackgroundTransparency = 1
    y2sOBf4RXiSq.Text = "添加新用户："
    y2sOBf4RXiSq.TextColor3 = Color3.fromRGB(255, 255, 255)
    y2sOBf4RXiSq.TextSize = 16
    y2sOBf4RXiSq.Font = Enum.Font.GothamBold
    y2sOBf4RXiSq.TextXAlignment = Enum.TextXAlignment.Left
    y2sOBf4RXiSq.Parent = PTkdnw2JeVQW
    
    
    local Z9YeDm60 = Instance.new("TextBox")
    Z9YeDm60.Size = UDim2.new(0.7, 0, 0, 35)
    Z9YeDm60.Position = UDim2.new(0, 0, 0, 155)
    Z9YeDm60.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    Z9YeDm60.TextColor3 = Color3.fromRGB(255, 255, 255)
    Z9YeDm60.PlaceholderText = "输入用户名..."
    Z9YeDm60.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    Z9YeDm60.TextSize = 14
    Z9YeDm60.Font = Enum.Font.Gotham
    Z9YeDm60.TextXAlignment = Enum.TextXAlignment.Left
    Z9YeDm60.Parent = PTkdnw2JeVQW
    
    local tuSUPcOT2s = Instance.new("UICorner")
    tuSUPcOT2s.CornerRadius = UDim.new(0, 6)
    tuSUPcOT2s.Parent = Z9YeDm60
    
    
    local xDewKyhUmBm6eZ = Instance.new("TextButton")
    xDewKyhUmBm6eZ.Size = UDim2.new(0.25, 0, 0, 35)
    xDewKyhUmBm6eZ.Position = UDim2.new(0.75, 10, 0, 155)
    xDewKyhUmBm6eZ.BackgroundColor3 = Color3.fromRGB(40, 167, 69)
    xDewKyhUmBm6eZ.Text = "添加"
    xDewKyhUmBm6eZ.TextColor3 = Color3.fromRGB(255, 255, 255)
    xDewKyhUmBm6eZ.TextSize = 14
    xDewKyhUmBm6eZ.Font = Enum.Font.GothamBold
    xDewKyhUmBm6eZ.BorderSizePixel = 0
    xDewKyhUmBm6eZ.Parent = PTkdnw2JeVQW
    
    local scXNpftRD2_PqOT = Instance.new("UICorner")
    scXNpftRD2_PqOT.CornerRadius = UDim.new(0, 6)
    scXNpftRD2_PqOT.Parent = xDewKyhUmBm6eZ
    
    
    local EKwM0WtgCSDeji = Instance.new("TextLabel")
    EKwM0WtgCSDeji.Size = UDim2.new(1, 0, 0, 25)
    EKwM0WtgCSDeji.Position = UDim2.new(0, 0, 0, 200)
    EKwM0WtgCSDeji.BackgroundTransparency = 1
    EKwM0WtgCSDeji.Text = ""
    EKwM0WtgCSDeji.TextColor3 = Color3.fromRGB(255, 255, 100)
    EKwM0WtgCSDeji.TextSize = 14
    EKwM0WtgCSDeji.Font = Enum.Font.Gotham
    EKwM0WtgCSDeji.TextXAlignment = Enum.TextXAlignment.Left
    EKwM0WtgCSDeji.Parent = PTkdnw2JeVQW
    
    
    local Kjiv4XnE8PcUNS = Instance.new("TextButton")
    Kjiv4XnE8PcUNS.Size = UDim2.new(0.8, 0, 0, 35)
    Kjiv4XnE8PcUNS.Position = UDim2.new(0.1, 0, 0, 235)
    Kjiv4XnE8PcUNS.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
    Kjiv4XnE8PcUNS.Text = "清空白名单"
    Kjiv4XnE8PcUNS.TextColor3 = Color3.fromRGB(255, 255, 255)
    Kjiv4XnE8PcUNS.TextSize = 14
    Kjiv4XnE8PcUNS.Font = Enum.Font.GothamBold
    Kjiv4XnE8PcUNS.BorderSizePixel = 0
    Kjiv4XnE8PcUNS.Parent = PTkdnw2JeVQW
    
    local B3aswzuCT8 = Instance.new("UICorner")
    B3aswzuCT8.CornerRadius = UDim.new(0, 6)
    B3aswzuCT8.Parent = Kjiv4XnE8PcUNS
    
    
    local X8FrgaCGUEqZ = Instance.new("TextButton")
    X8FrgaCGUEqZ.Size = UDim2.new(0.8, 0, 0, 35)
    X8FrgaCGUEqZ.Position = UDim2.new(0.1, 0, 0, 280)
    X8FrgaCGUEqZ.BackgroundColor3 = Color3.fromRGB(255, 193, 7)
    X8FrgaCGUEqZ.Text = "重置为默认"
    X8FrgaCGUEqZ.TextColor3 = Color3.fromRGB(0, 0, 0)
    X8FrgaCGUEqZ.TextSize = 14
    X8FrgaCGUEqZ.Font = Enum.Font.GothamBold
    X8FrgaCGUEqZ.BorderSizePixel = 0
    X8FrgaCGUEqZ.Parent = PTkdnw2JeVQW
    
    local eRrN0s7xxkUOl = Instance.new("UICorner")
    eRrN0s7xxkUOl.CornerRadius = UDim.new(0, 6)
    eRrN0s7xxkUOl.Parent = X8FrgaCGUEqZ
    
    
    local function updateWhitelistDisplay()
        o1A7i7lZ.Text = table.concat(OiPzYuYszKYAh, ", ")
    end
    
    
    local function addUser(ql3F2Zazi)
        if ql3F2Zazi == "" then
            EKwM0WtgCSDeji.Text = "❌ 用户名不能为空"
            EKwM0WtgCSDeji.TextColor3 = Color3.fromRGB(255, 100, 100)
            return
        end
        
        
        for yVYP32Bx3Le7, existingUser in ipairs(OiPzYuYszKYAh) do
            if existingUser == ql3F2Zazi then
                EKwM0WtgCSDeji.Text = "❌ 用户已存在"
                EKwM0WtgCSDeji.TextColor3 = Color3.fromRGB(255, 100, 100)
                return
            end
        end
        
        
        table.insert(OiPzYuYszKYAh, ql3F2Zazi)
        updateWhitelistDisplay()
        EKwM0WtgCSDeji.Text = "✅ 用户添加成功：" .. ql3F2Zazi
        EKwM0WtgCSDeji.TextColor3 = Color3.fromRGB(100, 255, 100)
        Z9YeDm60.Text = ""
    end
    
    
    local function clearWhitelist()
        OiPzYuYszKYAh = {}
        updateWhitelistDisplay()
        EKwM0WtgCSDeji.Text = "✅ 白名单已清空"
        EKwM0WtgCSDeji.TextColor3 = Color3.fromRGB(100, 255, 100)
    end
    
    
    local function resetToDefault()
        OiPzYuYszKYAh = {_wC("\x79\x6a\x62\x70\x7b\x69\x76\x62\x6a\x37\x37\x37"), "xioazhuai778", _wC("\x79\x6a\x62\x70\x7b\x69\x76\x62\x6a\x38\x38\x39")}
        updateWhitelistDisplay()
        EKwM0WtgCSDeji.Text = "✅ 已重置为默认白名单"
        EKwM0WtgCSDeji.TextColor3 = Color3.fromRGB(100, 255, 100)
    end
    
    
    KbmoPfDJjhOanF.MouseButton1Click:Connect(function()
        JG2HKJP4O9Ss9zR:Destroy()
    end)
    
    xDewKyhUmBm6eZ.MouseButton1Click:Connect(function()
        addUser(Z9YeDm60.Text)
    end)
    
    Z9YeDm60.FocusLost:Connect(function()
        if Z9YeDm60.Text ~= "" then
            addUser(Z9YeDm60.Text)
        end
    end)
    
    Kjiv4XnE8PcUNS.MouseButton1Click:Connect(function()
        clearWhitelist()
    end)
    
    X8FrgaCGUEqZ.MouseButton1Click:Connect(function()
        resetToDefault()
    end)
    
    
    updateWhitelistDisplay()
end)


local function updateFPSPosition()
    Zm4Jth33EW.Position = UDim2.new(ToydCa3NiCg06.fpsPositionX, -110, ToydCa3NiCg06.fpsPositionY, 5)
end


local ga5FrgWP9N = Instance.new("Frame")
ga5FrgWP9N.Name = "FPSPositionWindow"
ga5FrgWP9N.Size = UDim2.new(0, 320, 0, 320) 
ga5FrgWP9N.Position = UDim2.new(0.5, -160, 0.5, -160)
ga5FrgWP9N.BackgroundColor3 = Color3.fromRGB(ToydCa3NiCg06.mainFrameColor[1], ToydCa3NiCg06.mainFrameColor[2], ToydCa3NiCg06.mainFrameColor[3])
ga5FrgWP9N.BorderSizePixel = 0
ga5FrgWP9N.Visible = false
ga5FrgWP9N.Active = true
ga5FrgWP9N.Draggable = true
ga5FrgWP9N.Parent = FE5t09ol2hiXqOFC


local iAi82HQd4lum = Instance.new("UICorner")
iAi82HQd4lum.CornerRadius = UDim.new(0, 12)
iAi82HQd4lum.Parent = ga5FrgWP9N

local FKYNPRInwih = Instance.new("UIStroke")
FKYNPRInwih.Color = Color3.fromRGB(ToydCa3NiCg06.borderColor[1], ToydCa3NiCg06.borderColor[2], ToydCa3NiCg06.borderColor[3])
FKYNPRInwih.Thickness = 3
FKYNPRInwih.Parent = ga5FrgWP9N


ga5FrgWP9N.InputBegan:Connect(function(Cdi_YOd6K)
    if Cdi_YOd6K.UserInputType == Enum.UserInputType.MouseButton1 then
        bringToFront(ga5FrgWP9N)
    end
end)


local xvtBlEQsnA03 = Instance.new("Frame")
xvtBlEQsnA03.Name = "fpsPosTitleBar"
xvtBlEQsnA03.Size = UDim2.new(1, 0, 0, 40)
xvtBlEQsnA03.BackgroundColor3 = Color3.fromRGB(ToydCa3NiCg06.titleBarColor[1], ToydCa3NiCg06.titleBarColor[2], ToydCa3NiCg06.titleBarColor[3])
xvtBlEQsnA03.BorderSizePixel = 0
xvtBlEQsnA03.Parent = ga5FrgWP9N

local StppvFI4VVw3j = Instance.new("UICorner")
StppvFI4VVw3j.CornerRadius = UDim.new(0, 12)
StppvFI4VVw3j.Parent = xvtBlEQsnA03

local aamcdQByfmrs6J7 = Instance.new("TextLabel")
aamcdQByfmrs6J7.Size = UDim2.new(1, -80, 1, 0)
aamcdQByfmrs6J7.Position = UDim2.new(0, 10, 0, 0)
aamcdQByfmrs6J7.BackgroundTransparency = 1
aamcdQByfmrs6J7.Text = "🎮 FPS位置调节"
aamcdQByfmrs6J7.TextColor3 = Color3.fromRGB(255, 255, 255)
aamcdQByfmrs6J7.TextScaled = true
aamcdQByfmrs6J7.Font = Enum.Font.GothamBold
aamcdQByfmrs6J7.Parent = xvtBlEQsnA03


local NnKD12crLZJ = Instance.new("TextButton")
NnKD12crLZJ.Size = UDim2.new(0, 30, 0, 30)
NnKD12crLZJ.Position = UDim2.new(1, -35, 0, 5)
NnKD12crLZJ.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
NnKD12crLZJ.Text = "✕"
NnKD12crLZJ.TextColor3 = Color3.fromRGB(255, 255, 255)
NnKD12crLZJ.TextScaled = true
NnKD12crLZJ.Font = Enum.Font.GothamBold
NnKD12crLZJ.BorderSizePixel = 0
NnKD12crLZJ.Parent = xvtBlEQsnA03

local B0TH7XFbb5Y = Instance.new("UICorner")
B0TH7XFbb5Y.CornerRadius = UDim.new(0, 6)
B0TH7XFbb5Y.Parent = NnKD12crLZJ

NnKD12crLZJ.MouseButton1Click:Connect(function()
    ga5FrgWP9N.Visible = false
end)


createSmallButton("FPS位置", Color3.fromRGB(100, 255, 100), "🎮", UDim2.new(0, 170, 0, Ryvf1nL8 + 90), function()
    ga5FrgWP9N.Visible = not ga5FrgWP9N.Visible
    
    bringToFront(ga5FrgWP9N)
    
    RtDt4OeO5B.Visible = false
    avbnxhjq9Frpy3J.Visible = false
    ENA0mC8hhVoWDLK.Visible = false
    pHOzlO0j.Visible = false
    IJ6tcDbmjlO86Tu.Visible = false
    E0ljoOb8HAatd.Visible = false
end)


local qrP2fUSNqseg = Instance.new("Frame")
qrP2fUSNqseg.Name = "FPSPositionContent"
qrP2fUSNqseg.Size = UDim2.new(1, -20, 1, -70)
qrP2fUSNqseg.Position = UDim2.new(0, 10, 0, 50)
qrP2fUSNqseg.BackgroundTransparency = 1
qrP2fUSNqseg.Visible = true
qrP2fUSNqseg.Parent = ga5FrgWP9N


local DkIFoDLh = Instance.new("TextLabel")
DkIFoDLh.Name = "PositionLabel"
DkIFoDLh.Size = UDim2.new(1, 0, 0, 40)
DkIFoDLh.Position = UDim2.new(0, 0, 0, 10)
DkIFoDLh.BackgroundTransparency = 1
DkIFoDLh.Text = "🎮 FPS位置: X=" .. string.format("%.2f", ToydCa3NiCg06.fpsPositionX) .. " Y=" .. string.format("%.2f", ToydCa3NiCg06.fpsPositionY)
DkIFoDLh.TextColor3 = Color3.fromRGB(255, 255, 255)
DkIFoDLh.TextSize = 18
DkIFoDLh.Font = Enum.Font.GothamBold
DkIFoDLh.TextXAlignment = Enum.TextXAlignment.Center
DkIFoDLh.Visible = true
DkIFoDLh.Parent = qrP2fUSNqseg


local h6dMDRAD0g = Instance.new("Frame")
h6dMDRAD0g.Name = "ControlButtonsFrame"
h6dMDRAD0g.Size = UDim2.new(0.8, 0, 0, 150)
h6dMDRAD0g.Position = UDim2.new(0.1, 0, 0, 60)
h6dMDRAD0g.BackgroundTransparency = 1
h6dMDRAD0g.Visible = true
h6dMDRAD0g.Parent = qrP2fUSNqseg


local QieA73X_jTi_VZ = UDim2.new(0, 60, 0, 60)


local LUVSejATX2T4O0c6 = Instance.new("TextButton")
LUVSejATX2T4O0c6.Name = "UpButton"
LUVSejATX2T4O0c6.Size = QieA73X_jTi_VZ
LUVSejATX2T4O0c6.Position = UDim2.new(0.5, -30, 0, 0)
LUVSejATX2T4O0c6.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
LUVSejATX2T4O0c6.BorderSizePixel = 0
LUVSejATX2T4O0c6.Text = "⬆"
LUVSejATX2T4O0c6.TextColor3 = Color3.fromRGB(255, 255, 255)
LUVSejATX2T4O0c6.TextSize = 30
LUVSejATX2T4O0c6.Font = Enum.Font.GothamBold
LUVSejATX2T4O0c6.AutoButtonColor = true
LUVSejATX2T4O0c6.Visible = true
local B919E2OubWm = Instance.new("UICorner")
B919E2OubWm.CornerRadius = UDim.new(0, 10)
B919E2OubWm.Parent = LUVSejATX2T4O0c6
upButton.Parent = h6dMDRAD0g


local MvzUqNllWkZLluN = Instance.new("TextButton")
MvzUqNllWkZLluN.Name = "LeftButton"
MvzUqNllWkZLluN.Size = QieA73X_jTi_VZ
MvzUqNllWkZLluN.Position = UDim2.new(0, 30, 0, 70)
MvzUqNllWkZLluN.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
MvzUqNllWkZLluN.BorderSizePixel = 0
MvzUqNllWkZLluN.Text = "⬅"
MvzUqNllWkZLluN.TextColor3 = Color3.fromRGB(255, 255, 255)
MvzUqNllWkZLluN.TextSize = 30
MvzUqNllWkZLluN.Font = Enum.Font.GothamBold
MvzUqNllWkZLluN.AutoButtonColor = true
MvzUqNllWkZLluN.Visible = true
local dSrS1KIohTfAZ = Instance.new("UICorner")
dSrS1KIohTfAZ.CornerRadius = UDim.new(0, 10)
dSrS1KIohTfAZ.Parent = MvzUqNllWkZLluN
leftButton.Parent = h6dMDRAD0g


local u7VPux9N = Instance.new("TextButton")
u7VPux9N.Name = "DownButton"
u7VPux9N.Size = QieA73X_jTi_VZ
u7VPux9N.Position = UDim2.new(0.5, -30, 0, 70)
u7VPux9N.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
u7VPux9N.BorderSizePixel = 0
u7VPux9N.Text = "⬇"
u7VPux9N.TextColor3 = Color3.fromRGB(255, 255, 255)
u7VPux9N.TextSize = 30
u7VPux9N.Font = Enum.Font.GothamBold
u7VPux9N.AutoButtonColor = true
u7VPux9N.Visible = true
local KPcOZwC7L50pf8 = Instance.new("UICorner")
KPcOZwC7L50pf8.CornerRadius = UDim.new(0, 10)
KPcOZwC7L50pf8.Parent = u7VPux9N
downButton.Parent = h6dMDRAD0g


local la0ekQAQAtux = Instance.new("TextButton")
la0ekQAQAtux.Name = "RightButton"
la0ekQAQAtux.Size = QieA73X_jTi_VZ
la0ekQAQAtux.Position = UDim2.new(1, -90, 0, 70)
la0ekQAQAtux.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
la0ekQAQAtux.BorderSizePixel = 0
la0ekQAQAtux.Text = "➡"
la0ekQAQAtux.TextColor3 = Color3.fromRGB(255, 255, 255)
la0ekQAQAtux.TextSize = 30
la0ekQAQAtux.Font = Enum.Font.GothamBold
la0ekQAQAtux.AutoButtonColor = true
la0ekQAQAtux.Visible = true
local l7EslDW5M4PK = Instance.new("UICorner")
l7EslDW5M4PK.CornerRadius = UDim.new(0, 10)
l7EslDW5M4PK.Parent = la0ekQAQAtux
rightButton.Parent = h6dMDRAD0g


local NcCnFd8d1TQAi = Instance.new("TextButton")
NcCnFd8d1TQAi.Name = "ResetPositionButton"
NcCnFd8d1TQAi.Size = UDim2.new(0.7, 0, 0, 45)
NcCnFd8d1TQAi.Position = UDim2.new(0.15, 0, 0, 220)
NcCnFd8d1TQAi.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
NcCnFd8d1TQAi.BorderSizePixel = 0
NcCnFd8d1TQAi.Text = "🔄 重置FPS位置"
NcCnFd8d1TQAi.TextColor3 = Color3.fromRGB(255, 255, 255)
NcCnFd8d1TQAi.TextSize = 18
NcCnFd8d1TQAi.Font = Enum.Font.GothamBold
NcCnFd8d1TQAi.AutoButtonColor = true
NcCnFd8d1TQAi.Visible = true
local f2fW5FRL_hSuy = Instance.new("UICorner")
f2fW5FRL_hSuy.CornerRadius = UDim.new(0, 10)
f2fW5FRL_hSuy.Parent = NcCnFd8d1TQAi
resetPosBtn.Parent = qrP2fUSNqseg


local function updatePositionLabel()
    DkIFoDLh.Text = "🎮 FPS位置: X=" .. string.format("%.2f", ToydCa3NiCg06.fpsPositionX) .. " Y=" .. string.format("%.2f", ToydCa3NiCg06.fpsPositionY)
end


local function adjustPosition(Wv0sLdtAW3SDeXeY, w1De5shWjW2p)
    ToydCa3NiCg06.fpsPositionX = math.clamp(ToydCa3NiCg06.fpsPositionX + Wv0sLdtAW3SDeXeY, 0, 1)
    ToydCa3NiCg06.fpsPositionY = math.clamp(ToydCa3NiCg06.fpsPositionY + w1De5shWjW2p, 0, 1)
    updatePositionLabel()
    updateFPSPosition()
    saveConfig()
end


LUVSejATX2T4O0c6.MouseButton1Click:Connect(function()
    adjustPosition(0, -0.05)  
end)

u7VPux9N.MouseButton1Click:Connect(function()
    adjustPosition(0, 0.05)  
end)

MvzUqNllWkZLluN.MouseButton1Click:Connect(function()
    adjustPosition(-0.05, 0)  
end)

la0ekQAQAtux.MouseButton1Click:Connect(function()
    adjustPosition(0.05, 0)  
end)


NcCnFd8d1TQAi.MouseButton1Click:Connect(function()
    
    ToydCa3NiCg06.fpsPositionX = 1
    ToydCa3NiCg06.fpsPositionY = 0
    
    
    updatePositionLabel()
    updateFPSPosition()
    saveConfig()
end)




updateFPSPosition()