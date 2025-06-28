repeat task.wait() until game:IsLoaded()

-- == BLADE BALL CORE GHÉP CHUẨN UI EVIL.LUA (VAMPIRE HUB) ==
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local ParryRemote = nil
for _,v in pairs(ReplicatedStorage:GetDescendants()) do
    if v:IsA("RemoteEvent") and v.Name:lower():find("parry") then
        ParryRemote = v break
    end
end

local function getBall()
    for _,ball in pairs(workspace:GetChildren()) do
        if ball.Name:lower():find("ball") and ball:IsA("BasePart") then
            return ball
        end
    end
    return nil
end

local autoParryConn = nil
function EnableAutoParry()
    if autoParryConn or not ParryRemote then return end
    autoParryConn = RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        local ball = getBall()
        if not char or not ball or not char:FindFirstChild("HumanoidRootPart") then return end
        local dist = (char.HumanoidRootPart.Position - ball.Position).Magnitude
        local ballVel = ball.Velocity.Magnitude
        if dist < 17 and ballVel > 10 then
            ParryRemote:FireServer()
            task.wait(0.18)
        end
    end)
end
function DisableAutoParry()
    if autoParryConn then autoParryConn:Disconnect() autoParryConn = nil end
end

local autoSpamConn = nil
function EnableAutoSpam()
    if autoSpamConn or not ParryRemote then return end
    autoSpamConn = RunService.Heartbeat:Connect(function()
        ParryRemote:FireServer()
        task.wait(0.12)
    end)
end
function DisableAutoSpam()
    if autoSpamConn then autoSpamConn:Disconnect() autoSpamConn = nil end
end

local manualSpamConn = nil
local manualSpamButton = nil
function EnableManualSpam()
    if manualSpamConn or not ParryRemote then return end
    -- PC: Q
    manualSpamConn = UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode.Q then
            ParryRemote:FireServer()
        end
    end)
    -- MOBILE: tạo nút vật lý
    if manualSpamButton == nil then
        manualSpamButton = Instance.new("ScreenGui")
        manualSpamButton.Name = "ManualSpamButtonGui"
        manualSpamButton.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 120, 0, 50)
        btn.Position = UDim2.new(1, -140, 1, -70)
        btn.AnchorPoint = Vector2.new(0, 0)
        btn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
        btn.Text = "Spam Parry"
        btn.TextScaled = true
        btn.Font = Enum.Font.GothamBold
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.Parent = manualSpamButton
        btn.MouseButton1Click:Connect(function()
            ParryRemote:FireServer()
        end)
    end
end
function DisableManualSpam()
    if manualSpamConn then manualSpamConn:Disconnect() manualSpamConn = nil end
    if manualSpamButton then
        manualSpamButton:Destroy()
        manualSpamButton = nil
    end
end

local highlightTable, espConn = {}, nil
function EnableESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if not player.Character:FindFirstChild("BB_ESP") then
                local highlight = Instance.new("Highlight")
                highlight.Name = "BB_ESP"
                highlight.FillColor = Color3.fromRGB(255,0,0)
                highlight.OutlineColor = Color3.fromRGB(255,255,255)
                highlight.Parent = player.Character
                highlight.Adornee = player.Character
                highlightTable[player] = highlight
            end
        end
    end
    espConn = Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(char)
            local highlight = Instance.new("Highlight")
            highlight.Name = "BB_ESP"
            highlight.FillColor = Color3.fromRGB(255,0,0)
            highlight.OutlineColor = Color3.fromRGB(255,255,255)
            highlight.Parent = char
            highlight.Adornee = char
            highlightTable[player] = highlight
        end)
    end)
end
function DisableESP()
    for player, highlight in pairs(highlightTable) do
        if highlight and highlight.Parent then
            highlight:Destroy()
        end
    end
    highlightTable = {}
    if espConn then espConn:Disconnect() espConn = nil end
end

-- == TẠO UI/Tab Blade Ball (GHÉP SẴN CHUẨN EVIL.LUA) ==
-- Nếu bạn đã có dòng tạo Window, giữ nguyên. Nếu không, thêm đoạn sau:
-- local Library = ... (phần tạo Library và Window theo Evil.lua gốc của bạn)

local BladeBallTab = Window:MakeTab({
    Name = "Blade Ball",
    Icon = "",
    PremiumOnly = false
})

BladeBallTab:AddToggle({
    Name = "Auto Parry",
    Default = false,
    Callback = function(state)
        if state then EnableAutoParry() else DisableAutoParry() end
    end
})

BladeBallTab:AddToggle({
    Name = "Auto Spam",
    Default = false,
    Callback = function(state)
        if state then EnableAutoSpam() else DisableAutoSpam() end
    end
})

BladeBallTab:AddToggle({
    Name = "Manual Spam (PC: Q, Mobile: Nút)",
    Default = false,
    Callback = function(state)
        if state then EnableManualSpam() else DisableManualSpam() end
    end
})

BladeBallTab:AddToggle({
    Name = "ESP",
    Default = false,
    Callback = function(state)
        if state then EnableESP() else DisableESP() end
    end
})