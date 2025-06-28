--!strict repeat task.wait() until game:IsLoaded()

-- Load Fluent UI (giữ nguyên link của bạn)
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

-- ========== CORE LOGIC (Mobile-Optimized, chỉ dùng Highlight, không Drawing) ==========
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

_G.AutoParry = false
_G.AutoSpam = false
_G.ManualSpam = false
_G.AutoCurve = false
_G.ESP = false
_G.Fly = false
_G.AntiVoid = false
_G.SkinChanger = false

-- AutoParry
local autoParryConn
function enableAutoParry()
    if autoParryConn then return end
    autoParryConn = RunService.Heartbeat:Connect(function()
        -- AutoParry logic ở đây
    end)
end
function disableAutoParry()
    if autoParryConn then autoParryConn:Disconnect() autoParryConn = nil end
end

-- AutoSpam
local autoSpamConn
function enableAutoSpam()
    if autoSpamConn then return end
    autoSpamConn = RunService.Heartbeat:Connect(function()
        -- AutoSpam logic
    end)
end
function disableAutoSpam()
    if autoSpamConn then autoSpamConn:Disconnect() autoSpamConn = nil end
end

-- ManualSpam
local manualSpamConn
function enableManualSpam()
    if manualSpamConn then return end
    manualSpamConn = RunService.Heartbeat:Connect(function()
        -- ManualSpam logic
    end)
end
function disableManualSpam()
    if manualSpamConn then manualSpamConn:Disconnect() manualSpamConn = nil end
end

-- AutoCurve
local autoCurveConn
function enableAutoCurve()
    if autoCurveConn then return end
    autoCurveConn = RunService.Heartbeat:Connect(function()
        -- AutoCurve logic
    end)
end
function disableAutoCurve()
    if autoCurveConn then autoCurveConn:Disconnect() autoCurveConn = nil end
end

-- ESP (Highlight)
local highlightTable = {}
function enableESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local highlight = Instance.new("Highlight")
            highlight.Name = "VAMPIRE_HUB_ESP"
            highlight.FillColor = Color3.fromRGB(255,0,0)
            highlight.OutlineColor = Color3.fromRGB(255,255,255)
            highlight.Parent = player.Character
            highlight.Adornee = player.Character
            highlightTable[player] = highlight
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

-- AntiVoid
local antiVoidConn
function enableAntiVoid()
    if antiVoidConn then return end
    antiVoidConn = RunService.Heartbeat:Connect(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if LocalPlayer.Character.HumanoidRootPart.Position.Y < -10 then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0,50,0)
            end
        end
    end)
end
function disableAntiVoid()
    if antiVoidConn then antiVoidConn:Disconnect() antiVoidConn = nil end
end

-- SkinChanger (ví dụ: đổi màu nhân vật)
function enableSkinChanger()
    if LocalPlayer.Character then
        for _,v in ipairs(LocalPlayer.Character:GetChildren()) do
            if v:IsA("BasePart") then
                v.Color = Color3.fromRGB(0,255,255)
            end
        end
    end
end
function disableSkinChanger()
    if LocalPlayer.Character then
        for _,v in ipairs(LocalPlayer.Character:GetChildren()) do
            if v:IsA("BasePart") then
                v.Color = Color3.fromRGB(255,255,255)
            end
        end
    end
end

-- ========== GẮN LOGIC VÀO GUI GỐC CỦA BẠN ==========

Tabs.Balant:AddToggle("AutoParry", { Title = "Auto Parry", Default = false, Callback = function(v)
    _G.AutoParry = v
    if v then enableAutoParry() else disableAutoParry() end
end })

Tabs.Balant:AddToggle("AutoSpam", { Title = "Auto Spam", Default = false, Callback = function(v)
    _G.AutoSpam = v
    if v then enableAutoSpam() else disableAutoSpam() end
end })

Tabs.Balant:AddToggle("ManualSpam", { Title = "Manual Spam", Default = false, Callback = function(v)
    _G.ManualSpam = v
    if v then enableManualSpam() else disableManualSpam() end
    -- Giữ nguyên phần giao diện ManualSpam nếu bạn muốn (code cũ ở đây)
end })

Tabs.Balant:AddToggle("AutoCurve", { Title = "Auto Curve", Default = false, Callback = function(v)
    _G.AutoCurve = v
    if v then enableAutoCurve() else disableAutoCurve() end
end })

-- Nếu bạn muốn giữ dropdown chọn hướng AutoCurve
Tabs.Balant:AddDropdown("CurveDirection", { 
    Title = "Curve Direction", 
    Values = {"Left", "Right", "Straight", "Up", "Backward", "Random"}, 
    Multi = false, 
    Default = 1, 
    Callback = function(v) 
        _G.CurveDirection = v
    end 
})

Tabs.Special:AddInput("SkinChanger", { Title = "Skin Changer", Default = "", Placeholder = "Enter skin name", Numeric = false, Callback = function(text)
    _G.SkinChanger = text
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

-- Nếu bạn có thêm toggle nào ở GUI gốc Evil.lua, cứ thêm logic enable/disable như hướng dẫn trên.

-- ===== END SCRIPT =====