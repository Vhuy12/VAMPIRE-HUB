
repeat wait() until game:IsLoaded()
local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/CodeE4X-dev/Library/refs/heads/main/FluentRemake.lua"))()

local Window = Fluent:CreateWindow({ 
    Title = "Vampire test version", 
    SubTitle = "by Kurayami", 
    TabWidth = 160, 
    Size = UDim2.fromOffset(530, 310), 
    Acrylic = false, 
    Theme = "Aqua", 
    MinimizeKey = Enum.KeyCode.RightControl 
})

local Tabs = { 
    Discord = Window:AddTab({ Title = "Our Discord", Icon = "heart" }), 
    Balant = Window:AddTab({ Title = "Balant", Icon = "swords" }), 
    Special = Window:AddTab({ Title = "Special", Icon = "star" }), 
    Visual = Window:AddTab({ Title = "Visual", Icon = "eye" }) 
}
Window:SelectTab(1)
Tabs.Discord:AddParagraph({ Title = "Discord", Content = "https://discord.gg/xqbpKmSs" })
Tabs.Discord:AddButton({ Title = "Copy Invite Link", Description = "Copy Discord invite to clipboard", Callback = function() setclipboard("https://discord.gg/xqbpKmSs") end })

-- ================== CORE LOGIC ==================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

_G.AutoParry = false
_G.AutoSpam = false
_G.ManualSpam = false
_G.AutoCurve = false
_G.ESP = false
_G.Fly = false
_G.AntiVoid = false
_G.SkinChanger = false
_G.CurveDirection = "Left"

-------------------------
-- Auto Parry
local autoParryConn
function enableAutoParry()
    if autoParryConn then return end
    autoParryConn = RunService.Heartbeat:Connect(function()
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.Name == "Bullet" and v:FindFirstChild("creator") then
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    if (v.Position - char.HumanoidRootPart.Position).Magnitude < 15 then
                        -- Giả lập ấn phím F (parry)
                        keypress(0x46)
                        task.wait(0.03)
                        keyrelease(0x46)
                    end
                end
            end
        end
    end)
end
function disableAutoParry()
    if autoParryConn then autoParryConn:Disconnect() autoParryConn = nil end
end

-------------------------
-- Auto Spam
local autoSpamConn
function enableAutoSpam()
    if autoSpamConn then return end
    autoSpamConn = RunService.Heartbeat:Connect(function()
        mouse1press()
        task.wait(0.03)
        mouse1release()
    end)
end
function disableAutoSpam()
    if autoSpamConn then autoSpamConn:Disconnect() autoSpamConn = nil end
end

-------------------------
-- Manual Spam (ấn Q để spam chuột)
local manualSpamConn
function enableManualSpam()
    if manualSpamConn then return end
    manualSpamConn = UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.Q then
            mouse1press()
            task.wait(0.03)
            mouse1release()
        end
    end)
end
function disableManualSpam()
    if manualSpamConn then manualSpamConn:Disconnect() manualSpamConn = nil end
end

-------------------------
-- Auto Curve (chỉ ví dụ: giữ phím A hoặc D, có thể mở rộng)
local autoCurveConn
function enableAutoCurve()
    if autoCurveConn then return end
    autoCurveConn = RunService.Heartbeat:Connect(function()
        if _G.CurveDirection == "Left" then
            keypress(0x41) -- A
            task.wait(0.05)
            keyrelease(0x41)
        elseif _G.CurveDirection == "Right" then
            keypress(0x44) -- D
            task.wait(0.05)
            keyrelease(0x44)
        end
    end)
end
function disableAutoCurve()
    if autoCurveConn then autoCurveConn:Disconnect() autoCurveConn = nil end
end

-------------------------
-- ESP (Highlight)
local highlightTable = {}
function enableESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if not player.Character:FindFirstChild("VAMPIRE_HUB_ESP") then
                local highlight = Instance.new("Highlight")
                highlight.Name = "VAMPIRE_HUB_ESP"
                highlight.FillColor = Color3.fromRGB(255,0,0)
                highlight.OutlineColor = Color3.fromRGB(255,255,255)
                highlight.Parent = player.Character
                highlight.Adornee = player.Character
                highlightTable[player] = highlight
            end
        end
    end
    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(char)
            if _G.ESP then
                local highlight = Instance.new("Highlight")
                highlight.Name = "VAMPIRE_HUB_ESP"
                highlight.FillColor = Color3.fromRGB(255,0,0)
                highlight.OutlineColor = Color3.fromRGB(255,255,255)
                highlight.Parent = char
                highlight.Adornee = char
                highlightTable[player] = highlight
            end
        end)
    end)
end
function disableESP()
    for player, highlight in pairs(highlightTable) do
        if highlight and highlight.Parent then
            highlight:Destroy()
        end
    end
    highlightTable = {}
end

-------------------------
-- Fly
local flyConn
function enableFly()
    if flyConn then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    local bp = Instance.new("BodyPosition")
    bp.MaxForce = Vector3.new(1e5,1e5,1e5)
    bp.P = 1e4
    bp.Position = hrp.Position
    bp.Parent = hrp
    flyConn = RunService.Heartbeat:Connect(function()
        if _G.Fly then
            bp.Position = hrp.Position + Vector3.new(0,2,0)
        end
    end)
end
function disableFly()
    if flyConn then flyConn:Disconnect() flyConn = nil end
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        for _,obj in ipairs(char.HumanoidRootPart:GetChildren()) do
            if obj:IsA("BodyPosition") then obj:Destroy() end
        end
    end
end

-------------------------
-- Anti Void
local antiVoidConn
function enableAntiVoid()
    if antiVoidConn then return end
    antiVoidConn = RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            if char.HumanoidRootPart.Position.Y < -10 then
                char.HumanoidRootPart.CFrame = CFrame.new(0,50,0)
            end
        end
    end)
end
function disableAntiVoid()
    if antiVoidConn then antiVoidConn:Disconnect() antiVoidConn = nil end
end

-------------------------
-- Skin Changer (đổi màu nhân vật)
function enableSkinChanger()
    local char = LocalPlayer.Character
    if char then
        for _,v in ipairs(char:GetChildren()) do
            if v:IsA("BasePart") then
                v.Color = Color3.fromRGB(0,255,255)
            end
        end
    end
end
function disableSkinChanger()
    local char = LocalPlayer.Character
    if char then
        for _,v in ipairs(char:GetChildren()) do
            if v:IsA("BasePart") then
                v.Color = Color3.fromRGB(255,255,255)
            end
        end
    end
end

-- ================== KẾT NỐI VỚI GIAO DIỆN UI ==================
Tabs.Balant:AddToggle("AutoParry", { Title = "Auto Parry", Default = false, Callback = function(v)
    _G.AutoParry = v
    if v then enableAutoParry() else disableAutoParry() end
end })

Tabs.Balant:AddToggle("AutoSpam", { Title = "Auto Spam", Default = false, Callback = function(v)
    _G.AutoSpam = v
    if v then enableAutoSpam() else disableAutoSpam() end
end })

Tabs.Balant:AddToggle("ManualSpam", { Title = "Manual Spam (Q)", Default = false, Callback = function(v)
    _G.ManualSpam = v
    if v then enableManualSpam() else disableManualSpam() end
end })

Tabs.Balant:AddToggle("AutoCurve", { Title = "Auto Curve", Default = false, Callback = function(v)
    _G.AutoCurve = v
    if v then enableAutoCurve() else disableAutoCurve() end
end })

Tabs.Balant:AddDropdown("CurveDirection", { 
    Title = "Curve Direction", 
    Values = {"Left", "Right"}, 
    Multi = false, 
    Default = 1, 
    Callback = function(v) 
        _G.CurveDirection = v
    end 
})

Tabs.Special:AddButton({ Title = "Change Skin", Description = "Đổi skin nhân vật (chỉ đổi màu)", Callback = function()
    enableSkinChanger()
end })

Tabs.Visual:AddToggle("ESP", { Title = "ESP", Default = false, Callback = function(enabled)
    _G.ESP = enabled
    if enabled then enableESP() else disableESP() end
end })

Tabs.Visual:AddToggle("Fly", { Title = "Fly", Default = false, Callback = function(enabled)
    _G.Fly = enabled
    if enabled then enableFly() else disableFly() end
end })

Tabs.Visual:AddToggle("AntiVoid", { Title = "AntiVoid", Default = false, Callback = function(enabled)
    _G.AntiVoid = enabled
    if enabled then enableAntiVoid() else disableAntiVoid() end
end })

-- ================== KẾT THÚC ==================