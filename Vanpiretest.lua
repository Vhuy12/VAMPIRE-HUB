local AirflowLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/4lpaca-pin/Airflow/refs/heads/main/src/source.luau"))()
if not AirflowLib then return end

local Window = AirflowLib:Init({
	Name = "Vampire test version",
	Keybind = "LeftControl",
})

getgenv().vampire = getgenv().vampire or {}
local vampire = getgenv().vampire
vampire.AutoParry = false
vampire.AutoSpam = false
vampire.ParryAccuracy = 70
vampire.ParryThreshold = 1.5

local DiscordTab = Window:DrawTab({
	Name = "Our Discord",
	Icon = "message-square"
})

local DiscordSection = DiscordTab:AddSection({
	Name = "Support",
	Position = "left"
})

DiscordSection:AddButton({
	Name = "Click here to Copy Discord Link",
	FullWidth = true,
	Callback = function()
		setclipboard("https://discord.gg/MghwMJHX")
		AirflowLib:Notify({
			Title = "Discord",
			Content = "Link Copied!",
			Duration = 5
		})
	end
})

local Tab = Window:DrawTab({
	Name = "Main",
	Icon = "swords"
})

local Left = Tab:AddSection({
	Name = "Auto Parry",
	Position = "left"
})

local Right = Tab:AddSection({
	Name = "Auto Spam",
	Position = "right"
})

Left:AddToggle({
	Name = "Auto Parry",
	Default = vampire.AutoParry,
	Callback = function(v)
		vampire.AutoParry = v
	end,
})

Left:AddSlider({
	Name = "Parry Accuracy",
	Min = 1,
	Max = 100,
	Decimals = 0,
	Default = vampire.ParryAccuracy,
	Callback = function(v)
		vampire.ParryAccuracy = v
	end,
})

Right:AddToggle({
	Name = "Auto Spam Parry",
	Default = vampire.AutoSpam,
	Callback = function(v)
		vampire.AutoSpam = v
	end,
})

Right:AddSlider({
	Name = "Parry Threshold",
	Min = 1,
	Max = 3,
	Decimals = 1,
	Default = vampire.ParryThreshold,
	Callback = function(v)
		vampire.ParryThreshold = v
	end,
})

--// CORE LOGIC (ĐÃ FIX)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer
local Balls = workspace:WaitForChild("Balls")

local ShouldPlayerJump = ReplicatedStorage.Remotes:WaitForChild("ShouldPlayerJump")
local MainRemote = ReplicatedStorage.Remotes:WaitForChild("MainRemote")
local GetOpponentPosition = ReplicatedStorage.Remotes:WaitForChild("GetOpponentPosition")

-- Thay bằng giá trị thực nếu bạn có
local HashOne = "RbdCUz"
local HashTwo = "o9Wiyc"
local HashThree = "5ebU4s"
local ParryKey = "F"

local Parries = 0
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local function GetBall()
	for _, ball in ipairs(Balls:GetChildren()) do
		if ball:GetAttribute("realBall") then
			return ball
		end
	end
	return nil
end

local function Parry()
	if isMobile then
		local hotbar = Player:FindFirstChild("PlayerGui") and Player.PlayerGui:FindFirstChild("Hotbar")
		if hotbar and hotbar:FindFirstChild("Block") then
			hotbar.Block:Activate()
		end
	else
		ShouldPlayerJump:FireServer(HashOne, ParryKey)
		MainRemote:FireServer(HashTwo, ParryKey)
		GetOpponentPosition:FireServer(HashThree, ParryKey)
	end
end

local function GetParryAccuracy(speed)
	local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 10
	local cappedSpeedDiff = math.clamp(speed - 9.5, 0, 650)
	local base = 2.4 + cappedSpeedDiff * 0.002
	local multiplier = 0.7 + (vampire.ParryAccuracy - 1) * (0.35 / 99)
	local divisor = base * multiplier
	return ping + math.max(speed / divisor, 9.5)
end

RunService.Heartbeat:Connect(function()
	if not vampire.AutoParry then return end

	local ball = GetBall()
	if not ball then return end

	local zoomies = ball:FindFirstChild("zoomies")
	if not zoomies then return end

	local velocity = zoomies.VectorVelocity
	local speed = velocity.Magnitude
	local distance = (Player.Character.PrimaryPart.Position - ball.Position).Magnitude
	local accuracy = GetParryAccuracy(speed)

	if ball:GetAttribute("target") == tostring(Player) and distance <= accuracy then
		if Parries <= vampire.ParryThreshold then
			Parry()
			Parries += 1
			task.delay(0.5, function()
				if Parries > 0 then Parries -= 1 end
			end)
		end
	end
end)

RunService.Heartbeat:Connect(function()
	if not vampire.AutoSpam then return end

	local ball = GetBall()
	if not ball then return end

	local zoomies = ball:FindFirstChild("zoomies")
	if not zoomies then return end

	local velocity = zoomies.VectorVelocity
	local speed = velocity.Magnitude
	local distance = (Player.Character.PrimaryPart.Position - ball.Position).Magnitude
	local accuracy = GetParryAccuracy(speed)

	if ball:GetAttribute("target") == tostring(Player) and distance <= accuracy then
		if Parries > vampire.ParryThreshold then
			Parry()
		end
	end
end)

Balls.ChildRemoved:Connect(function()
	Parries = 0
end)