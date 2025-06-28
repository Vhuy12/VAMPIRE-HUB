-- VampireUltimate_CoreLogic.lua -- Đã tối ưu cho Delta X/mobile
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Stats = game:GetService("Stats")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local BallsFolder = Workspace:WaitForChild("Balls")
local ParryRemote = ReplicatedStorage.Remotes:WaitForChild("ParryButtonPress")
local AbilityRemote = ReplicatedStorage.Remotes:WaitForChild("AbilityButtonPress")
local CurveRemote = ReplicatedStorage.Remotes:FindFirstChild("CurveDirection")

-- Toggle mặc định
_G.AutoParry = _G.AutoParry or false
_G.PingBased = true
_G.PingBasedOffset = 0.05
_G.BallSpeedCheck = true
_G.ParryRangeMultiplier = 2
_G.UseRage = false
_G.ManualSpam = false
_G.AutoSpam = false
_G.AutoCurve = false
_G.Triggerbot = false
_G.ESP = false
_G.Fly = false
_G.InfinityDetection = true
_G.PhantomDetection = true
_G.SlashOfFuryDetection = true
_G.FOV = 25
_G.ESP_Color = Color3.fromRGB(255, 0, 0)
_G.FOVVisual = false
_G.Visualize = false
_G.SkinChanger = false
_G.AntiVoid = false

LocalPlayer.CharacterAdded:Connect(function(char) Character = char end)

local function getPing()
    local success, ping = pcall(function()
        return Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 1000
    end)
    return success and math.max(0.05, math.min(0.5, ping)) or 0.1
end

local function sendParryClick()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
end

local function Parry()
    local abilities = Character and Character:FindFirstChild("Abilities")
    if _G.UseRage and abilities and abilities:FindFirstChild("Raging Deflection") and abilities["Raging Deflection"].Enabled then
        AbilityRemote:Fire()
        task.wait(0)
    end
    ParryRemote:Fire()
    sendParryClick()
end

local function VerifyBall(ball)
    return ball and ball:IsA("BasePart") and ball:IsDescendantOf(BallsFolder) and ball:GetAttribute("realBall") == true
end

local function FindBall()
    for _, v in ipairs(BallsFolder:GetChildren()) do
        if VerifyBall(v) then return v end
    end
end

local function IsTheTarget()
    return Character and Character:FindFirstChild("Highlight")
end

-- AutoParry + Detection
RunService.PreRender:Connect(function()
    if not _G.AutoParry or not Character or not Character.PrimaryPart then return end
    local ball = FindBall()
    if not ball then return end
    local velocity = ball.AssemblyLinearVelocity.Magnitude
    if _G.BallSpeedCheck and velocity < 5 then return end
    local ping = _G.PingBased and getPing() or 0
    local distance = (ball.Position - Character.PrimaryPart.Position).Magnitude
    local range = ((_G.PingBasedOffset or 0.05) + (velocity / math.pi)) * (_G.ParryRangeMultiplier or 2)
    local name = tostring(ball)
    if _G.InfinityDetection and name:lower():find("infinity") then return Parry() end
    if _G.SlashOfFuryDetection and name:lower():find("slash") then return Parry() end
    if _G.PhantomDetection and ball:FindFirstChild("Tail") then return Parry() end
    if distance <= range and IsTheTarget() then Parry() end
end)

-- AutoSpam
spawn(function()
    while true do
        if _G.AutoSpam then
            ParryRemote:Fire()
            sendParryClick()
        end
        task.wait(0.035)
    end
end)

-- ManualSpam
UserInputService.InputBegan:Connect(function(input)
    if _G.ManualSpam and input.KeyCode == Enum.KeyCode.E then
        for _ = 1, 8 do
            ParryRemote:Fire()
            sendParryClick()
            task.wait(0.05)
        end
    end
end)

-- AutoCurve
spawn(function()
    while true do
        if _G.AutoCurve and CurveRemote then
            local dir = math.random(1,2)==1 and "Left" or "Right"
            CurveRemote:FireServer(dir)
        end
        task.wait(0.75)
    end
end)

-- Triggerbot
spawn(function()
    while true do
        if _G.Triggerbot then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (plr.Character.HumanoidRootPart.Position - Character.PrimaryPart.Position).Magnitude
                    if dist < 15 then Parry() end
                end
            end
        end
        task.wait(0.25)
    end
end)

-- ESP sử dụng Highlight (hỗ trợ mobile, Delta X)
spawn(function()
    while true do
        if _G.ESP then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and not plr.Character:FindFirstChild("ESP_High") then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "ESP_High"
                    highlight.Adornee = plr.Character
                    highlight.FillColor = _G.ESP_Color
                    highlight.OutlineColor = Color3.new(1,1,1)
                    highlight.Parent = plr.Character
                end
            end
        end
        task.wait(1)
    end
end)

-- Đã bỏ Drawing API (FOV Circle) và SelectionSphere (Visualize Ball) để tránh lỗi executor mobile

-- SkinChanger (nếu bị lỗi MeshId thì bỏ đoạn này)
spawn(function()
    while true do
        if _G.SkinChanger and Character then
            local head = Character:FindFirstChild("Head")
            local leftLeg = Character:FindFirstChild("LeftLowerLeg")
            local rightLeg = Character:FindFirstChild("RightLowerLeg")
            if head then
                head.Transparency = 1
            end
            -- Nếu lỗi MeshId thì comment 2 dòng dưới
            if leftLeg then
                pcall(function()
                    leftLeg.MeshId = "902942093"
                end)
            end
            if rightLeg then
                pcall(function()
                    rightLeg.MeshId = "902942093"
                end)
            end
        end
        task.wait(1)
    end
end)

-- Fly
local flyToggle = false
UserInputService.InputBegan:Connect(function(input, gpe)
    if input.KeyCode == Enum.KeyCode.F and _G.Fly then
        flyToggle = not flyToggle
    end
end)
RunService.RenderStepped:Connect(function()
    if flyToggle and Character and Character:FindFirstChild("HumanoidRootPart") then
        Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(0, 50, 0)
    end
end)

-- AntiVoid
RunService.Stepped:Connect(function()
    if _G.AntiVoid and Character and Character:FindFirstChild("HumanoidRootPart") then
        if Character.HumanoidRootPart.Position.Y < -10 then
            Character:SetPrimaryPartCFrame(CFrame.new(0, 50, 0))
        end
    end
end)