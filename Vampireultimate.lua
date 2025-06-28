local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

local ConfigFolder = "VampireConfig"
local ConfigFile = "VampireSettings.json"
local HttpService = game:GetService("HttpService")
local SavePath = ConfigFolder .. "/" .. ConfigFile

if not isfolder(ConfigFolder) then makefolder(ConfigFolder) end
if not isfile(SavePath) then writefile(SavePath, HttpService:JSONEncode({})) end

local defaultSettings = {
    AutoParry = false,
    SpamParry = false,
    TriggerBot = false,
    Fly = false,
    Spinbot = false,
    Strafe = false,
    SlashDetect = false,
    InfinityDetect = false,
    PhantomDetect = false,
    AntiStun = false,
    AutoAbility = false,
    CurveDetect = false,
    Aimbot = false,
    ESP = false,
    BallESP = false,
    HighlightPlayers = false,
    ShowPingFPS = false,
    ReflectAI = false,
    PanicParry = false,
    AutoQ = false,
    SmartCooldown = false,
    GUI = true,
    MobileButtons = false,
    AntiBan = true,
    Key = Enum.KeyCode.F,
    FOV = 100,
    CustomFOV = false,
    FakeHeadless = false,
    FakeKorblox = false
}

local loadedSettings = {}
pcall(function()
    loadedSettings = HttpService:JSONDecode(readfile(SavePath))
end)

for k, v in pairs(defaultSettings) do
    if loadedSettings[k] == nil then
        loadedSettings[k] = v
    end
end

getgenv().Vampire = loadedSettings

spawn(function()
    while task.wait(2) do
        pcall(function()
            writefile(SavePath, HttpService:JSONEncode(getgenv().Vampire))
        end)
    end
end)

if getgenv().Vampire.GUI then
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Vhuy12/VAMPIRE-HUB/refs/heads/main/Evil.lua"))()
    end)
end

if getgenv().Vampire.AntiBan then
    local old
    old = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        if getnamecallmethod() == "FireServer" then
            local name = tostring(self)
            if name:find("Parry") or name:find("Remote") then
                return nil
            end
        end
        return old(self, ...)
    end))
end

RunService.Heartbeat:Connect(function()
    local ball = Workspace:FindFirstChild("Balls") and Workspace.Balls:FindFirstChildWhichIsA("BasePart")
    if not ball then return end
    if getgenv().Vampire.AutoParry and Player:DistanceFromCharacter(ball.Position) < 40 then
        task.spawn(function()
            VirtualInputManager:SendKeyEvent(true, getgenv().Vampire.Key, false, game)
            VirtualInputManager:SendKeyEvent(false, getgenv().Vampire.Key, false, game)
        end)
    end
    if getgenv().Vampire.SpamParry and ball.AssemblyLinearVelocity.Magnitude > 90 then
        task.spawn(function()
            VirtualInputManager:SendKeyEvent(true, getgenv().Vampire.Key, false, game)
            VirtualInputManager:SendKeyEvent(false, getgenv().Vampire.Key, false, game)
        end)
    end
end)

UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and getgenv().Vampire.TriggerBot then
        local target = Workspace.Alive:FindFirstChildWhichIsA("Model")
        if target and Player:DistanceFromCharacter(target:GetPivot().Position) < 20 then
            VirtualInputManager:SendKeyEvent(true, getgenv().Vampire.Key, false, game)
            VirtualInputManager:SendKeyEvent(false, getgenv().Vampire.Key, false, game)
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if getgenv().Vampire.Aimbot and Camera then
        local nearest, closest = nil, math.huge
        for _, b in ipairs(Workspace.Balls:GetChildren()) do
            if b:IsA("BasePart") then
                local dist = (Camera.CFrame.Position - b.Position).Magnitude
                if dist < closest then
                    closest = dist
                    nearest = b
                end
            end
        end
        if nearest then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, nearest.Position)
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if getgenv().Vampire.ESP then
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.Name:lower():find("ball") and not v:FindFirstChild("SelectionBox") then
                local box = Instance.new("SelectionBox")
                box.Adornee = v
                box.Color3 = Color3.fromRGB(0, 255, 0)
                box.LineThickness = 0.05
                box.Parent = v
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if getgenv().Vampire.Fly and Character:FindFirstChild("HumanoidRootPart") then
        Character.HumanoidRootPart.Velocity = Vector3.new(0, 50, 0)
    end
end)

RunService.RenderStepped:Connect(function()
    if getgenv().Vampire.Spinbot then
        Character.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(15), 0)
    end
end)

local toggle = true
RunService.RenderStepped:Connect(function()
    if getgenv().Vampire.Strafe then
        local offset = toggle and Vector3.new(1, 0, 0) or Vector3.new(-1, 0, 0)
        Character.HumanoidRootPart.CFrame *= CFrame.new(offset / 5)
        toggle = not toggle
    end
end)

RunService.RenderStepped:Connect(function()
    if getgenv().Vampire.CustomFOV then
        Camera.FieldOfView = getgenv().Vampire.FOV
    end
end)

if getgenv().Vampire.FakeHeadless and Character:FindFirstChild("Head") then
    Character.Head.Transparency = 1
end

if getgenv().Vampire.FakeKorblox and Character:FindFirstChild("RightLowerLeg") then
    Character.RightLowerLeg.Size = Vector3.new(0.1, 0.1, 0.1)
    Character.RightLowerLeg.Transparency = 1
end

if getgenv().Vampire.MobileButtons then
    local gui = Instance.new("ScreenGui")
    gui.Name = "VampireSpamGUI"
    gui.ResetOnSpawn = false
    gui.Parent = Player:WaitForChild("PlayerGui")

    local spamButton = Instance.new("TextButton")
    spamButton.Size = UDim2.new(0, 130, 0, 50)
    spamButton.Position = UDim2.new(1, -140, 1, -70)
    spamButton.AnchorPoint = Vector2.new(1, 1)
    spamButton.Text = "MANUAL SPAM"
    spamButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    spamButton.TextColor3 = Color3.new(1, 1, 1)
    spamButton.Font = Enum.Font.GothamBold
    spamButton.TextSize = 16
    spamButton.AutoButtonColor = true
    spamButton.Parent = gui

    local function manualSpam()
        task.spawn(function()
            for i = 1, 20 do
                VirtualInputManager:SendKeyEvent(true, getgenv().Vampire.Key, false, game)
                VirtualInputManager:SendKeyEvent(false, getgenv().Vampire.Key, false, game)
                task.wait(0.025)
            end
        end)
    end

    spamButton.MouseButton1Click:Connect(manualSpam)
end