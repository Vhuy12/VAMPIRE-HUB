local Airflow = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/4lpaca-pin/Airflow/refs/heads/main/src/source.luau"))()

local Window = Airflow:Init({
    Name = "Vampire hub",
    Keybind = "LeftControl",
})

local Tab_Discord = Window:DrawTab({
    Name = "Our Discord",
    Icon = "message-square"
})

local DiscordSection = Tab_Discord:AddSection({
    Name = "Join Our Discord Sever to have new update",
    Position = "left"
})

DiscordSection:AddButton({
    Name = "Copy Discord Link",
    Callback = function()
        setclipboard("https://discord.gg/MghwMJHX") 
        Airflow:Notify({
            Title = "Discord",
            Content = "Link Copied",
            Duration = 5
        })
    end
})

local module = Blatant:AddSection({
    Name = "Auto Parry",
    Position = "left",
})

module:AddToggle({
    Name = "Auto Parry",
    Callback = function(value)
        if value then
            Connections_Manager['Auto Parry'] = RunService.PreSimulation:Connect(function()
                local Balls = Auto_Parry.Get_Balls()
                for _, Ball in pairs(Balls) do
                    if not Ball then return end
                    local Zoomies = Ball:FindFirstChild('zoomies')
                    if not Zoomies then return end

                    Ball:GetAttributeChangedSignal('target'):Once(function()
                        Parried = false
                    end)

                    if Parried then return end

                    local effectiveMultiplier = 0.7 + (math.random(1, 100) - 1) * (0.35 / 99)
                    local speed_divisor_base = 20
                    local Speed = Zoomies.Velocity.Magnitude
                    local speed_divisor = speed_divisor_base * effectiveMultiplier
                    local Ping_Threshold = 0.1
                    local Parry_Accuracy = Ping_Threshold + math.max(Speed / speed_divisor, 9.5)

                    local Curved = Auto_Parry.Is_Curved()
                    if Phantom and Player.Character:FindFirstChild('ParryHighlight') and getgenv().PhantomV2Detection then
                        ContextActionService:BindAction('BlockPlayerMovement', BlockMovement, false, Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D, Enum.UserInputType.Touch)
                        Player.Character.Humanoid.WalkSpeed = 36
                        Player.Character.Humanoid:MoveTo(Ball.Position)
                        task.spawn(function()
                            repeat
                                if Player.Character.Humanoid.WalkSpeed ~= 36 then
                                    Player.Character.Humanoid.WalkSpeed = 36
                                end
                                task.wait()
                            until not Phantom
                        end)
                        Ball:GetAttributeChangedSignal('target'):Once(function()
                            Parry_Time()
                            Parried = true
                        end)
                        local Last_Parrys = tick()
                        repeat
                            RunService.PreSimulation:Wait()
                        until (tick() - Last_Parrys) >= 1 or not Parried
                        Parried = false
                    end
                end
            end)
        else
            if Connections_Manager['Auto Parry'] then
                Connections_Manager['Auto Parry']:Disconnect()
                Connections_Manager['Auto Parry'] = nil
            end
        end
    end
})

module:AddSlider({
    Name = "Parry Accuracy",
    Min = 1,
    Max = 100,
    Default = 100,
    Callback = function(value)
        -- callback logic (if needed)
    end
})

module:AddToggle({
    Name = "Keypress",
    Callback = function(value)
        getgenv().AutoParryKeypress = value
    end
})

local SpamParry = Blatant:AddSection({
    Name = "Auto Spam Parry",
    Position = "right",
})

SpamParry:AddToggle({
    Name = "Auto Spam Parry",
    Callback = function(value)
        if value then
            Connections_Manager["Auto Spam"] = RunService.PreSimulation:Connect(function()
                local Ball = Auto_Parry.Get_Ball()
                if not Ball then return end

                local Zoomies = Ball:FindFirstChild("zoomies")
                if not Zoomies then return end

                Auto_Parry.Closest_Player()

                local Ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
                local Ping_Threshold = math.clamp(Ping / 10, 1, 16)

                local Ball_Target = Ball:GetAttribute("target")
                local Ball_Properties = Auto_Parry:Get_Ball_Properties()
                local Entity_Properties = Auto_Parry:Get_Entity_Properties()

                local Spam_Accuracy = Auto_Parry.Spam_Service({
                    Ball_Properties = Ball_Properties,
                    Entity_Properties = Entity_Properties,
                    Ping = Ping_Threshold,
                })

                local Target_Position = Closest_Entity.PrimaryPart.Position
                local Target_Distance = Player:DistanceFromCharacter(Target_Position)
                local Direction = (Player.Character.PrimaryPart.Position - Ball.Position).Unit
                local Ball_Direction = Zoomies.VectorVelocity.Unit
                local Dot = Direction:Dot(Ball_Direction)
                local Distance = Player:DistanceFromCharacter(Ball.Position)

                if not Ball_Target then return end
                if Target_Distance > Spam_Accuracy or Distance > Spam_Accuracy then return end

                local Pulsed = Player.Character:GetAttribute("Pulsed")
                if Pulsed then return end

                if Ball_Target == tostring(Player) and Target_Distance > 30 and Distance > 30 then
                    return
                end

                local threshold = ParryThreshold
                if Distance <= Spam_Accuracy and Parries > threshold then
                    if getgenv().SpamParryKeypress then
                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
                    else
                        Auto_Parry.Parry(Selected_Parry_Type)
                    end
                end
            end)
        else
            if Connections_Manager["Auto Spam"] then
                Connections_Manager["Auto Spam"]:Disconnect()
                Connections_Manager["Auto Spam"] = nil
            end
        end
    end
})

SpamParry:AddDropdown({
    Name = "Parry Type",
    Values = { "Legit", "Blatant" },
    Multi = false,
    Default = "Legit",
    Callback = function(value)

    end
})

SpamParry:AddSlider({
    Name = "Parry Threshold",
    Min = 1,
    Max = 3,
    Default = 2.5,
    Callback = function(value)
        ParryThreshold = value
    end
})

SpamParry:AddToggle({
    Name = "Keypress",
    Callback = function(value)
        getgenv().SpamParryKeypress = value
    end
})

local ManualSpam = Blatant:AddSection({
	Name = "Manual Spam",
	Position = "left",
});

ManualSpam:AddToggle({
	Name = "Manual Spam Parry",
	Callback = function(value)
        if value then
            Connections_Manager['Manual Spam'] = RunService.PreSimulation:Connect(function()
                if getgenv().spamui then
                    return
                end

                if getgenv().ManualSpamKeypress then
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
                else
                    Auto_Parry.Parry(Selected_Parry_Type)
                end
            end)
        else
            if Connections_Manager['Manual Spam'] then
                Connections_Manager['Manual Spam']:Disconnect()
                Connections_Manager['Manual Spam'] = nil
            end
        end
    end
})

if isMobile then
    ManualSpam:AddToggle({
        Name = "UI",
        Callback = function(value)
            getgenv().spamui = value

            if value then
                local gui = Instance.new("ScreenGui")
                gui.Name = "ManualSpamUI"
                gui.ResetOnSpawn = false
                gui.IgnoreGuiInset = true
                gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                gui.Parent = game:GetService("CoreGui")

                local frame = Instance.new("Frame")
                frame.Name = "MainFrame"
                frame.Position = UDim2.new(0, 20, 0, 20)
                frame.Size = UDim2.new(0, 200, 0, 100)
                frame.BackgroundColor3 = Color3.fromRGB(10, 10, 50)
                frame.BackgroundTransparency = 0.3
                frame.BorderSizePixel = 0
                frame.Active = true
                frame.Draggable = true
                frame.Parent = gui

                local uiCorner = Instance.new("UICorner")
                uiCorner.CornerRadius = UDim.new(0, 12)
                uiCorner.Parent = frame

                local spamButton = Instance.new("TextButton")
                spamButton.Size = UDim2.new(1, 0, 1, 0)
                spamButton.BackgroundTransparency = 1
                spamButton.Text = "SPAM"
                spamButton.Font = Enum.Font.GothamBold
                spamButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                spamButton.TextScaled = true
                spamButton.Parent = frame

                spamButton.MouseButton1Click:Connect(function()
                    if getgenv().ManualSpamKeypress then
                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
                    else
                        Auto_Parry.Parry(Selected_Parry_Type)
                    end
                end)
            else
                local gui = game:GetService("CoreGui"):FindFirstChild("ManualSpamUI")
                if gui then
                    gui:Destroy()
                end
            end
        end
    })
end
local HitSounds = Tab_Visual:AddSection({
    Name = "Hit Sounds",
    Position = "right",
})

HitSounds:AddToggle({
    Name = "Hit Sounds",
    Callback = function(value)
        hit_Sound_Enabled = value
    end
})

local Folder = Instance.new("Folder")
Folder.Name = "Useful Utility"
Folder.Parent = workspace

local hit_Sound = Instance.new("Sound")
hit_Sound.Name = "ParryHitSound"
hit_Sound.Volume = 6
hit_Sound.Parent = Folder

local hitSoundOptions = {
    "Medal",
    "Fatality",
    "Skeet",
    "Switches",
    "Rust Headshot",
    "Neverlose Sound",
    "Bubble",
    "Laser",
    "Steve",
    "Call of Duty",
    "Bat",
    "TF2 Critical",
    "Saber",
    "Bameware"
}

local hitSoundIds = {
    Medal = "rbxassetid://6607336718",
    Fatality = "rbxassetid://6607113255",
    Skeet = "rbxassetid://6607204501",
    Switches = "rbxassetid://6607173363",
    ["Rust Headshot"] = "rbxassetid://138750331387064",
    ["Neverlose Sound"] = "rbxassetid://110168723447153",
    Bubble = "rbxassetid://6534947588",
    Laser = "rbxassetid://7837461331",
    Steve = "rbxassetid://4965083997",
    ["Call of Duty"] = "rbxassetid://5952120301",
    Bat = "rbxassetid://3333907347",
    ["TF2 Critical"] = "rbxassetid://296102734",
    Saber = "rbxassetid://8415678813",
    Bameware = "rbxassetid://3124331820"
}

HitSounds:AddSlider({
    Name = "Hit Sound Volume",
    Min = 0,
    Max = 10,
    Default = 6,
    Callback = function(value)
        hit_Sound.Volume = value
    end
})

HitSounds:AddDropdown({
    Name = "Hit Sound",
    Options = hitSoundOptions,
    Callback = function(selectedOption)
        if hitSoundIds[selectedOption] then
            hit_Sound.SoundId = hitSoundIds[selectedOption]
        end
    end
})

ReplicatedStorage.Remotes.ParrySuccess.OnClientEvent:Connect(function()
ReplicatedStorage.Remotes.ParrySuccessAll.OnClientEvent:Connect(function(_, root)
	if root.Parent and root.Parent ~= Player.Character then
		if root.Parent.Parent ~= workspace.Alive then
			return
		end
	end

	Auto_Parry.Closest_Player()

	local Ball = Auto_Parry.Get_Ball()
	if not Ball then
		return
	end

	local Target_Distance = (Player.Character.PrimaryPart.Position - Closest_Entity.PrimaryPart.Position).Magnitude
	local Distance = (Player.Character.PrimaryPart.Position - Ball.Position).Magnitude
	local Direction = (Player.Character.PrimaryPart.Position - Ball.Position).Unit
	local Dot = Direction:Dot(Ball.AssemblyLinearVelocity.Unit)

	local Curve_Detected = Auto_Parry.Is_Curved()

	if Target_Distance < 15 and Distance < 15 and Dot > -0.25 then
		if Curve_Detected then
			Auto_Parry.Parry(Selected_Parry_Type)
		end
	end

	if not Grab_Parry then
		return
	end

	Grab_Parry:Stop()
end)

    Auto_Parry.Closest_Player()

    local Ball = Auto_Parry.Get_Ball()

    if not Ball then
        return
    end

    local Target_Distance = (Player.Character.PrimaryPart.Position - Closest_Entity.PrimaryPart.Position).Magnitude
    local Distance = (Player.Character.PrimaryPart.Position - Ball.Position).Magnitude
    local Direction = (Player.Character.PrimaryPart.Position - Ball.Position).Unit
    local Dot = Direction:Dot(Ball.AssemblyLinearVelocity.Unit)

    local Curve_Detected = Auto_Parry.Is_Curved()

    if Target_Distance < 15 and Distance < 15 and Dot > -0.25 then -- wtf ?? maybe the big issue
        if Curve_Detected then
            Auto_Parry.Parry(Selected_Parry_Type)
        end
    end

    if not Grab_Parry then
        return
    end

    Grab_Parry:Stop()
end)

ReplicatedStorage.Remotes.ParrySuccess.OnClientEvent:Connect(function()
    if Player.Character.Parent ~= workspace.Alive then
        return
    end

    ReplicatedStorage.Remotes.ParrySuccess.OnClientEvent:Connect(function()
    if Player.Character.Parent ~= workspace.Alive then
        return
    end

    if not Grab_Parry then
        return
    end

    Grab_Parry:Stop()
end)

workspace.Balls.ChildAdded:Connect(function()
    Parried = false
end)

workspace.Balls.ChildRemoved:Connect(function()
    Parries = 0
    Parried = false

    if Connections_Manager['Target Change'] then
        Connections_Manager['Target Change']:Disconnect()
        Connections_Manager['Target Change'] = nil
    end
end)

ReplicatedStorage.Remotes.ParrySuccessAll.OnClientEvent:Connect(function(_, b)
    local Primary_Part = Player.Character and Player.Character.PrimaryPart
    local Ball = Auto_Parry.Get_Ball()

    if not Ball or not Primary_Part then
        return
    end

    local Zoomies = Ball:FindFirstChild("zoomies")
    if not Zoomies then
        return
    end

    local Speed = Zoomies.VectorVelocity.Magnitude
    local Distance = (Primary_Part.Position - Ball.Position).Magnitude
    local Velocity = Zoomies.VectorVelocity
    local Ball_Direction = Velocity.Unit

    local Direction = (Primary_Part.Position - Ball.Position).Unit
    local Dot = Direction:Dot(Ball_Direction)

    local Pings = Network.ServerStatsItem["Data Ping"]:GetValue()

    local Speed_Threshold = math.min(Speed / 100, 40)
    local Reach_Time = Distance / Speed - (Pings / 1000)

    local Enough_Speed = Speed > 100
    local Ball_Distance_Threshold = 15 - math.min(Distance / 1000, 15) + Speed_Threshold

    if Enough_Speed and Reach_Time > (Pings / 10) then
        Ball_Distance_Threshold = math.max(Ball_Distance_Threshold - 15, 15)
    end

    if b ~= Primary_Part and Distance > Ball_Distance_Threshold then
        Curving = tick()
    end
end)

ReplicatedStorage.Remotes.Phantom.OnClientEvent:Connect(function(_, b)
    if b and b.Name == tostring(Player) then
        Phantom = true
    else
        Phantom = false
    end
end)

local Balls = workspace:WaitForChild("Balls")

Balls.ChildRemoved:Connect(function()
    Phantom = false
end)
                  


                
