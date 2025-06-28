print("Hi Skiddiddy")

local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Stats = game:GetService("Stats")

local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)
if not success then
    warn("Failed to load Rayfield: " .. tostring(Rayfield))
    return
end

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local BallsFolder = Workspace:WaitForChild("Balls", 9e9)
local Remotes = ReplicatedStorage:WaitForChild("Remotes", 9e9)
local AbilityButtonPress = Remotes:WaitForChild("AbilityButtonPress")
local ParryButtonPress = Remotes:WaitForChild("ParryButtonPress")

-- Konfigurasi
getgenv().Vico = {
    AutoParry = true,
    PingBased = true,
    PingBasedOffset = 0.05,
    BallSpeedCheck = true,
    ParryRangeMultiplier = 2,
}

local UseRage = false
local SliderValue = 2

local Window = Rayfield:CreateWindow({
    Name = "Open Source AutoParry BEST",
    LoadingTitle = "VicoX",
    LoadingSubtitle = "By Rudert",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "BladeBallerlol",
        FileName = "VicoConfig"
    }
})

local AutoParryTab = Window:CreateTab("|Parry|")
local MainTab = Window:CreateTab("|Home|", 13014546637)
local AutoOpenTab = Window:CreateTab("|XD|", 13014546637)


local success, bypass = pcall(function()
    loadstring(game:GetObjects("rbxassetid://15900013841")[1].Source)()
end)
if not success then
    warn("Failed to load anticheat bypass: " .. tostring(bypass))
end

local function initialize(dataFolder_name)
    local Vico_Data = Instance.new("Folder", game:GetService("CoreGui"))
    Vico_Data.Name = dataFolder_name
end

local function onCharacterAdded(newCharacter)
    Character = newCharacter
end

LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

local function VerifyBall(Ball)
    return typeof(Ball) == "Instance" and Ball:IsA("BasePart") and Ball:IsDescendantOf(BallsFolder) and Ball:GetAttribute("realBall") == true
end

local function IsTheTarget()
    return Character and Character:FindFirstChild("Highlight")
end

local function FindBall()
    for _, v in pairs(BallsFolder:GetChildren()) do
        if v:GetAttribute("realBall") == true then
            return v
        end
    end
    return nil
end

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
    
local function isStationary()
    local humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    return humanoid and humanoid.WalkSpeed == 0
end

local function Parry()
    pcall(function()
        local abilities = Character and Character:FindFirstChild("Abilities")
        if abilities and abilities:FindFirstChild("Raging Deflection") and abilities["Raging Deflection"].Enabled and UseRage then
            AbilityButtonPress:Fire()
            task.wait(0)
            if not isStationary() then
                sendParryClick()
            end
        else
            ParryButtonPress:Fire()
            sendParryClick()
        end
    end)
end

local function startAutoParry()
    RunService.PreRender:Connect(function()
        if not Vico.AutoParry or not Character or not Character.PrimaryPart then
            return
        end

        local Ball = FindBall()
        if not Ball or not Ball.Position then
            return
        end

        local BallPosition = Ball.Position
        local BallVelocity = Ball.AssemblyLinearVelocity.Magnitude
        local Distance = (BallPosition - Character.PrimaryPart.Position).Magnitude
        local ping = Vico.PingBased and getPing() or 0
        local ping_threshold = math.clamp(ping / 10, 10, 20)
        local parryRange = (ping_threshold + Vico.PingBasedOffset) + (BallVelocity / math.pi) * Vico.ParryRangeMultiplier

        if Vico.BallSpeedCheck and BallVelocity < 5 then
            return
        end

        if Distance <= parryRange and IsTheTarget() then
            Parry()
        end
    end)
end

local function equipAbility(abilityName)
    pcall(function()
        ReplicatedStorage.Remotes.Store.RequestEquipAbility:InvokeServer(abilityName)
        ReplicatedStorage.Remotes.Store.GetOwnedAbilities:InvokeServer()
    end)
end

local function sendNotif(title, text)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 3,
            Icon = "rbxassetid://14763355020"
        })
    end)
end

local function getExplosion()
    local success, explosion = pcall(function()
        local _, result = ReplicatedStorage.Remotes.Store.RequestOpenExplosionBox:InvokeServer()
        return result
    end)
    return success and explosion or "Error"
end

local function getSword()
    local success, sword = pcall(function()
        local _, result = ReplicatedStorage.Remotes.Store.RequestOpenSwordBox:InvokeServer()
        return result
    end)
    return success and sword or "Error"
end

AutoParryTab:CreateToggle({
    Name = "|â€¢Auto Parryâ€¢|",
    CurrentValue = false,
    Flag = "AutoParryFlag",
    Callback = function(Value)
        Vico.AutoParry = Value
        if Value then
            startAutoParry()
        end
    end
})

AutoParryTab:CreateToggle({
    Name = "|â€¢Auto Rage Parry (MUST EQUIP RAGING DEFLECT)â€¢|",
    CurrentValue = false,
    Flag = "AutoRagingDeflectFlag",
    Callback = function(Value)
        UseRage = Value
    end
})

AutoParryTab:CreateSlider({
    Name = "Parry Range Multiplier",
    Range = {0.5, 3},
    Increment = 0.1,
    Suffix = "x",
    CurrentValue = 2,
    Flag = "ParryRangeMultiplierSlider",
    Callback = function(Value)
        Vico.ParryRangeMultiplier = Value
    end
})

AutoParryTab:CreateToggle({
    Name = "|â€¢Anti AFKâ€¢|",
    CurrentValue = false,
    Flag = "AntiAfk",
    Callback = function(Value)
        if Value then
            LocalPlayer.Idled:Connect(function()
                local vu = game:GetService("VirtualUser")
                pcall(function()
                    vu:Button2Down(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
                    task.wait(0.5)
                    vu:Button2Up(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
                end)
            end)
        end
    end
})

MainTab:CreateButton({
    Name = "Dash",
    Callback = function()
        equipAbility("Dash")
    end
})

MainTab:CreateButton({
    Name = "Forcefield",
    Callback = function()
        equipAbility("Forcefield")
    end
})

MainTab:CreateButton({
    Name = "Invisibility",
    Callback = function()
        equipAbility("Invisibility")
    end
})

MainTab:CreateButton({
    Name = "Platform",
    Callback = function()
        equipAbility("Platform")
    end
})

MainTab:CreateButton({
    Name = "Raging Deflection",
    Callback = function()
        equipAbility("Raging Deflection")
    end
})

MainTab:CreateButton({
    Name = "Shadow Step",
    Callback = function()
        equipAbility("Shadow Step")
    end
})

MainTab:CreateButton({
    Name = "Super Jump",
    Callback = function()
        equipAbility("Super Jump")
    end
})

MainTab:CreateButton({
    Name = "Telekinesis",
    Callback = function()
        equipAbility("Telekinesis")
    end
})

MainTab:CreateButton({
    Name = "Thunder Dash",
    Callback = function()
        equipAbility("Thunder Dash")
    end
})

MainTab:CreateButton({
    Name = "Rapture",
    Callback = function()
        equipAbility("Rapture")
    end
})

initialize("vico_temp")
if Vico.AutoParry then
    startAutoParry()
end