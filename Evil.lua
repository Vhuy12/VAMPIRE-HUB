--!strict repeat task.wait() until game:IsLoaded()

local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/CodeE4X-dev/Library/refs/heads/main/FluentRemake.lua"))()

local Window = Fluent:CreateWindow({ Title = "Vampire test version", SubTitle = "by Kurayami", TabWidth = 160, Size = UDim2.fromOffset(530, 310), Acrylic = false, Theme = "Aqua", MinimizeKey = Enum.KeyCode.LeftControl })

local Tabs = { Discord = Window:AddTab({ Title = "Our Discord", Icon = "heart" }), Balant = Window:AddTab({ Title = "Balant", Icon = "swords" }), Special = Window:AddTab({ Title = "Special", Icon = "wand" }), Visual = Window:AddTab({ Title = "Visual", Icon = "eye" }) }

Window:SelectTab(1)

Tabs.Discord:AddParagraph({ Title = "Discord", Content = "https://discord.gg/xqbpKmSs" })

Tabs.Discord:AddButton({ Title = "Copy Invite Link", Description = "Copy Discord invite to clipboard", Callback = function() setclipboard("https://discord.gg/xqbpKmSs") end })

Tabs.Balant:AddToggle("AutoParry", { Title = "Auto Parry", Default = false, Callback = function(v) getgenv().Vampire = getgenv().Vampire or {} getgenv().Vampire.AutoParry = v end })

Tabs.Balant:AddToggle("AutoSpam", { Title = "Auto Spam", Default = false, Callback = function(v) getgenv().Vampire = getgenv().Vampire or {} getgenv().Vampire.AutoSpam = v end })

Tabs.Balant:AddToggle("ManualSpam", { Title = "Manual Spam", Default = false, Callback = function(v) getgenv().Vampire = getgenv().Vampire or {} getgenv().Vampire.ManualSpam = v

if not v then
        if getgenv().ManualSpamGui then
            getgenv().ManualSpamGui:Destroy()
            getgenv().ManualSpamGui = nil
        end
        return
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "ManualSpamGui"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = game:GetService("CoreGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 140, 0, 80)
    frame.Position = UDim2.new(0.4, 0, 0.4, 0)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.Active = true
    frame.Draggable = true
    frame.Parent = gui
    Instance.new("UICorner").Parent = frame

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.6, 0, 0.4, 0)
    button.Position = UDim2.new(0.2, 0, 0.2, 0)
    button.Text = "Spam"
    button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    button.TextColor3 = Color3.new(1,1,1)
    button.TextScaled = true
    button.Parent = frame
    Instance.new("UICorner").Parent = button

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0.3, 0)
    label.Position = UDim2.new(0, 0, 0.65, 0)
    label.Text = "PC: E to Spam"
    label.TextColor3 = Color3.fromRGB(180,180,180)
    label.TextScaled = true
    label.BackgroundTransparency = 1
    label.Parent = frame

    local rs = game:GetService("RunService")
    local uis = game:GetService("UserInputService")
    local spamming = false
    local spamConnection, keyConnection

    local function toggleSpam()
        spamming = not spamming
        button.BackgroundColor3 = spamming and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)

        if spamConnection then
            spamConnection:Disconnect()
            spamConnection = nil
        end

        if spamming then
            spamConnection = rs.RenderStepped:Connect(function()
                pcall(function()
                    if d and d.Parry then d.Parry() end
                end)
            end)
        end
    end

    button.MouseButton1Click:Connect(toggleSpam)

    keyConnection = uis.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.E then
            toggleSpam()
        end
    end)

    gui.Destroying:Connect(function()
        if keyConnection then keyConnection:Disconnect() end
        if spamConnection then spamConnection:Disconnect() end
    end)

    getgenv().ManualSpamGui = gui
end

})

Tabs.Balant:AddToggle("AutoCurve", { Title = "Auto Curve", Default = false, Callback = function(v) getgenv().Vampire = getgenv().Vampire or {} getgenv().Vampire.AutoCurve = v end })

Tabs.Balant:AddDropdown("CurveDirection", { Title = "Curve Direction", Values = {"Left", "Right", "Straight", "Up", "Backward", "Random"}, Multi = false, Default = 1, Callback = function(v) getgenv().Vampire = getgenv().Vampire or {} getgenv().Vampire.CurveDirection = v end })

Tabs.Special:AddInput("SkinChanger", { Title = "Skin Changer", Default = "", Placeholder = "Enter skin name", Numeric = false, Callback = function(text) getgenv().Vampire = getgenv().Vampire or {} getgenv().Vampire.SkinName = text end })

Tabs.Visual:AddToggle("ESP", { Title = "ESP", Default = false, Callback = function(enabled) getgenv().Vampire = getgenv().Vampire or {} getgenv().Vampire.ESP = enabled

if getgenv().ESPConnection then
        getgenv().ESPConnection:Disconnect()
        getgenv().ESPConnection = nil
    end

    for _, adorn in pairs(workspace:GetDescendants()) do
        if adorn:IsA("BillboardGui") and adorn.Name == "VampireESP" then
            adorn:Destroy()
        end
    end

    if enabled then
        getgenv().ESPConnection = game:GetService("RunService").RenderStepped:Connect(function()
            for _, player in ipairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                    if not player.Character:FindFirstChild("VampireESP") then
                        local tag = Instance.new("BillboardGui")
                        tag.Name = "VampireESP"
                        tag.Adornee = player.Character.Head
                        tag.Size = UDim2.new(0, 100, 0, 40)
                        tag.AlwaysOnTop = true
                        tag.StudsOffset = Vector3.new(0, 2, 0)
                        tag.Parent = player.Character

                        local nameLabel = Instance.new("TextLabel", tag)
                        nameLabel.Size = UDim2.new(1, 0, 1, 0)
                        nameLabel.Text = player.Name
                        nameLabel.BackgroundTransparency = 1
                        nameLabel.TextColor3 = Color3.new(1, 1, 1)
                        nameLabel.TextStrokeTransparency = 0
                        nameLabel.TextScaled = true
                        nameLabel.Font = Enum.Font.SourceSansBold
                    end
                end
            end
        end)
    end
end

})

