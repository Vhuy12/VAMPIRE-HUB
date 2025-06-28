repeat task.wait() until game:IsLoaded()

local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/CodeE4X-dev/Library/refs/heads/main/FluentRemake.lua"))()
getgenv().Vampire = getgenv().Vampire or {}

local Window = Fluent:CreateWindow({
    Title = "Vampire test version",
    SubTitle = "by Kurayami",
    TabWidth = 160,
    Size = UDim2.fromOffset(530, 310),
    Acrylic = false,
    Theme = "Aqua",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Tabs
local Tabs = {
    Discord  = Window:AddTab({ Title = "Our Discord", Icon = "heart" }),
    Balant   = Window:AddTab({ Title = "Balant", Icon = "swords" }),
    Special  = Window:AddTab({ Title = "Special", Icon = "sparkles" }),
    Visual   = Window:AddTab({ Title = "Visual", Icon = "eye" }),
}

Window:SelectTab(1)

-- Discord Tab
Tabs.Discord:AddParagraph({
    Title = "Discord",
    Content = "Join Discord: https://discord.gg/xqbpKmSs"
})

-- Balant Tab
Tabs.Balant:AddToggle("AutoParry", {
    Title = "Auto Parry",
    Default = getgenv().Vampire.AutoParry or false,
    Callback = function(v) getgenv().Vampire.AutoParry = v end
})
Tabs.Balant:AddToggle("AutoSpam", {
    Title = "Auto Spam",
    Default = getgenv().Vampire.AutoSpam or false,
    Callback = function(v) getgenv().Vampire.AutoSpam = v end
})
Tabs.Balant:AddToggle("ManualSpam", {
    Title = "Manual Spam",
    Default = getgenv().Vampire.ManualSpam or false,
    Callback = function(v) getgenv().Vampire.ManualSpam = v end
})
Tabs.Balant:AddToggle("AutoCurve", {
    Title = "Auto Curve",
    Default = getgenv().Vampire.AutoCurve or false,
    Callback = function(v) getgenv().Vampire.AutoCurve = v end
})
Tabs.Balant:AddDropdown("CurveDirection", {
    Title = "Curve Direction",
    Values = {"Left", "Right", "Straight", "Up", "Backward", "Random"},
    Default = getgenv().Vampire.CurveDirection or "Left",
    Multi = false,
    Callback = function(v)
        getgenv().Vampire.CurveDirection = v
    end
})

-- Special Tab
Tabs.Special:AddInput("SkinChanger", {
    Title = "Skin Changer",
    Default = getgenv().Vampire.SkinName or "",
    Placeholder = "Enter skin name",
    Numeric = false,
    Callback = function(v)
        getgenv().Vampire.SkinName = v
    end
})

-- Visual Tab
Tabs.Visual:AddToggle("ESP", {
    Title = "ESP",
    Default = getgenv().Vampire.ESP or false,
    Callback = function(v) getgenv().Vampire.ESP = v end
})
Tabs.Visual:AddToggle("Visualize", {
    Title = "Visualize",
    Default = getgenv().Vampire.Visualize or false,
    Callback = function(v) getgenv().Vampire.Visualize = v end
})
Tabs.Visual:AddSlider("FOV", {
    Title = "FOV Circle",
    Description = "Adjust your FOV",
    Min = 30,
    Max = 120,
    Default = getgenv().Vampire.FOV or 60,
    Callback = function(v)
        getgenv().Vampire.FOV = v
    end
})