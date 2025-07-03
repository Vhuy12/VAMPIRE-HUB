local AirflowLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/4lpaca-pin/Airflow/refs/heads/main/src/source.luau"))()
if not AirflowLib then return end

local Window = AirflowLib:Init({
        Name = "Vampire test version",
        Keybind = "LeftControl",
        Logo = "http://www.roblox.com/asset/?id=97624744584100",                                                
})

local Credits = Window:DrawTab({
        Name = "Credits",
        Icon = "home"
})

local world = Window:DrawTab({
        Name = "World",
        Icon = "globe"
})

local misc = Window:DrawTab({
        Name = "Misc",
        Icon = "layers"
})

local section = Credits:AddSection({
        Name = "Vampire Hub",
        Position = "mid"
})

section:AddParagraph({
        Title = "Created by Kurayami",
        Content = "Script developed by Kurayami and Discord: Vampire Hub"
})

section:AddButton({
        Name = "Copy Discord Link",
        Callback = function()
                setclipboard("https://discord.gg/xqbpKmSs")
                notify("Credits", "Discord link copied!")
        end
})

section:AddParagraph({
        Title = "About Vampire hub",
        Content = "Vampire hub is a script Blade ball powerful"
})