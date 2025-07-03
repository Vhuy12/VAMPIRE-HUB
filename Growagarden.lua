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

local g = game:GetService("Players")
local J = game:GetService("ReplicatedStorage")
local o = game:GetService("UserInputService")
local L = game:GetService("RunService")
local m = g.LocalPlayer
local N = m.PlayerGui
local b = J:WaitForChild("GameEvents")
local n = b:WaitForChild("BuySeedStock")
local u = b:WaitForChild("Plant_RE")
local d = {
    auto_buy_seeds = true;
    use_distance_check = true;
    collection_distance = 17,
    collect_nearest_fruit = true,
    debug_mode = false
}
local U = nil
local F = "Carrot"
local R = false
local t = false
local function G()
    for w, v in ipairs(workspace.Farm:GetChildren()) do
        local E = v:FindFirstChild("Important")
        if E then
            local w = E:FindFirstChild("Data") and E.Data:FindFirstChild("Owner")
            if w and w.Value == m.Name then
                return v
            end
        end
    end
    return nil
end
local function j(w)
    if (N.Seed_Shop.Frame.ScrollingFrame)[w].Main_Frame.Cost_Text.TextColor3 ~= Color3.fromRGB(255, 0, 0) then
        if _G.table_settings.debug_mode then
            print("Attempting to buy seed:", w)
        end
        n:FireServer(w)
    end
end
local function S(w)
    local v = m.Character
    if not v then
        return false
    end
    local E = v:FindFirstChildOfClass("Humanoid")
    if not E then
        return false
    end
    for g, J in ipairs(m.Backpack:GetChildren()) do
        if J:GetAttribute("ITEM_TYPE") == "Seed" and J:GetAttribute("Seed") == w then
            E:EquipTool(J)
            task.wait()
            local g = v:FindFirstChildOfClass("Tool")
            if g and (g:GetAttribute("ITEM_TYPE") == "Seed" and g:GetAttribute("Seed") == w) then
                return g
            end
        end
    end
    local g = v:FindFirstChildOfClass("Tool")
    if g and (g:GetAttribute("ITEM_TYPE") == "Seed" and g:GetAttribute("Seed") == w) then
        return g
    end
    return false
end
local function V()
    while t do
        local w = false
        repeat
            if not t then
                return
            end
            local v = m.Character
            local E = v and v:FindFirstChild("HumanoidRootPart")
            local g = G()
            if not (E and (g and (g.Important and g.Important.Plants_Physical))) then
                if d.debug_mode then
                    print("Player, farm, or plants not found, skipping auto_collect iteration.")
                end
                task.wait(.5)
                w = true
                break
            end
            local J = g.Important.Plants_Physical
            if d.collect_nearest_fruit then
                local w = nil
                local v = math.huge
                for g, J in ipairs(J:GetChildren()) do
                    if not t then
                        return
                    end
                    for g, J in ipairs(J:GetDescendants()) do
                        if not t then
                            return
                        end
                        if J:IsA("ProximityPrompt") and (J.Enabled and J.Parent) then
                            local g = (E.Position - J.Parent.Position).Magnitude
                            local o = false
                            if d.use_distance_check then
                                if g <= d.collection_distance then
                                    o = true
                                end
                            else
                                o = true
                            end
                            if o and g < v then
                                v = g
                                w = J
                            end
                        end
                    end
                end
                if w then
                    if d.debug_mode then
                        print("Nearest fruit prompt:", w.Parent and w.Parent.Name or "Unknown", "at distance", v)
                    end
                    fireproximityprompt(w)
                    task.wait(.05)
                end
            else
                for w, v in ipairs(J:GetChildren()) do
                    if not t then
                        return
                    end
                    for w, v in ipairs(v:GetDescendants()) do
                        if not t then
                            return
                        end
                        if v:IsA("ProximityPrompt") and (v.Enabled and v.Parent) then
                            local w = false
                            if d.use_distance_check then
                                local g = (E.Position - v.Parent.Position).Magnitude
                                if g <= d.collection_distance then
                                    w = true
                                    if d.debug_mode then
                                        print("Collecting (distance):", v.Parent.Name, "at", g)
                                    end
                                end
                            else
                                w = true
                                if d.debug_mode then
                                    print("Collecting (no distance check):", v.Parent.Name)
                                end
                            end
                            if w then
                                fireproximityprompt(v)
                                task.wait(.05)
                            end
                        end
                    end
                end
            end
            task.wait()
            w = true
        until true
        if not w then
            break
        end
    end
end
local function C(w)
    while R do
        if not R then
            return
        end
        local v = S(w)
        if not v and d.auto_buy_seeds then
            j(w)
            task.wait(.1)
            v = S(w)
        end
        if v and U then
            local E = v:GetAttribute("Quantity")
            if E and E > 0 then
                if d.debug_mode then
                    print("Planting", w, "at", U, "Quantity:", E)
                end
                local v = {
                    U,
                    w
                }
                u:FireServer(unpack(v))
                task.wait(.1)
            else
                if d.debug_mode then
                    print("No quantity for seed or seed ran out:", w)
                end
            end
        else
            if d.debug_mode then
                print("Could not equip seed or plant_position is nil. Seed:", w, "Pos:", U)
            end
            task.wait(1)
        end
        task.wait(.2)
    end
end
local y = G()
if y and (y.Important and y.Important.Plant_Locations) then
    local w = y.Important.Plant_Locations:FindFirstChildOfClass("Part")
    if w then
        U = w.Position
    else
        U = Vector3.new(0, 0, 0)
        warn("Default plant location part not found in farm.")
    end
else
    U = Vector3.new(0, 0, 0)
    warn("Player farm or plant locations not found on script start.")
end
local O = E:Tab({
    Title = "Main";
    Icon = "rbxassetid://124620632231839";
    Locked = false
})
local Y = E:Tab({
    Title = "Settings";
    Icon = "rbxassetid://96957318452720";
    Locked = false
})
E:SelectTab(1)
local l = O:Button({
    Title = "Set Plant Position";
    Desc = "Set the position to plant seeds (defaults to center of your farm)";
    Locked = false;
    Callback = function()
        local w = m.Character
        local E = w and w:FindFirstChild("HumanoidRootPart")
        if E then
            U = E.Position;
            (v.new("info", "Position Set", "Planting position set to: " .. tostring(math.round(U.X) .. (", " .. (math.round(U.Y) .. (", " .. math.round(U.Z))))))):deleteTimeout(1)
        else
            (v.new("error", "Error", "Player character not found.")):deleteTimeout(1)
        end
    end
})
local c = O:Dropdown({
    Title = "Seed Selection";
    Values = {
        "Carrot",
        "Strawberry";
        "Blueberry";
        "Orange Tulip",
        "Tomato",
        "Corn",
        "Watermelon";
        "Daffodil";
        "Pumpkin",
        "Apple",
        "Bamboo",
        "Coconut";
        "Cactus",
        "Dragon Fruit";
        "Mango";
        "Grape",
        "Mushroom",
        "Pepper",
        "Cacao";
        "Beanstalk"
    };
    Value = "Carrot",
    Multi = false,
    AllowNone = true;
    Callback = function(w)
        F = w
    end
})
local Z = O:Toggle({
    Title = "Auto Plant";
    Desc = "Automatically plants selected seeds at the set position",
    Default = R,
    Callback = function(w)
        R = w
        if w then
            task.spawn(C, F)
        end
    end
})
local p = O:Toggle({
    Title = "Auto Collect";
    Desc = "Automatically collects fruits from plants";
    Default = t,
    Callback = function(w)
        t = w
        if w then
            task.spawn(V)
        end
    end
})
local k = Y:Toggle({
    Title = "Auto Buy Seeds",
    Desc = "Automatically buy seeds when they run out",
    Default = d.auto_buy_seeds;
    Callback = function(w)
        d.auto_buy_seeds = w
    end
})
k:Set(true)
local a = Y:Toggle({
    Title = "Use Distance Check";
    Desc = "Enable to only collect fruits within a certain distance (-fps)";
    Default = d.use_distance_check,
    Callback = function(w)
        d.use_distance_check = w
    end
})
local P = Y:Toggle({
    Title = "Collect Nearest Fruit",
    Desc = "Collect only the nearest fruit if distance check is enabled",
    Default = d.use_distance_check,
    Callback = function(w)
        d.collect_nearest_fruit = w
    end
})
P:Set(true)
local B = Y:Slider({
    Title = "Collection Distance";
    Desc = "Distance to collect fruits (if distance check is enabled)";
    Step = .5,
    Value = {
        Min = 1;
        Max = 30,
        Default = d.collection_distance
    };
    Callback = function(w)
        d.collection_distance = w
    end
})
local X = Y:Toggle({
    Title = "Debug Mode",
    Desc = "Enable debug mode for console logs (console output)",
    Icon = "bug",
    Default = d.debug_mode;
    Callback = function(w)
        d.debug_mode = w
    end
});
(v.new("success", "idkwhatisthis script loaded successfully!", "Version ballsack | Enjoy sexing!")):deleteTimeout(5)