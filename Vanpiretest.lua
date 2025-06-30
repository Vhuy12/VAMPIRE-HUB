
local AirflowURL = "https://raw.githubusercontent.com/4lpaca-pin/Airflow/refs/heads/main/src/source.luau"
local AirflowLib = loadstring(game:HttpGet(AirflowURL, true))()
if not AirflowLib then return end

local Window = AirflowLib:Init({
	Name = "Vampire test version",
	Keybind = "LeftControl",
	Logo = "http://www.roblox.com/asset/?id=94220348785476",
})

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local StarterPack = game:GetService("StarterPack")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Camera = Workspace.CurrentCamera

getgenv().vampire = getgenv().vampire or {}
local vampire = getgenv().vampire
vampire.Enabled = true
vampire.AutoParry = true
vampire.Triggerbot = false
vampire.Spinbot = false
vampire.Fly = false
vampire.MobileMode = false

-- Hàm tiện ích
local function getPing()
	local stats = LocalPlayer:FindFirstChild("NetworkStats")
	if stats then
		local pingValue = stats:FindFirstChild("Data Ping")
		if pingValue then
			local ping = tonumber(pingValue:GetValue():match("%d+"))
			return ping or 0
		end
	end
	return 0
end

local function getClosestBall()
	local closest, distance = nil, math.huge
	for _, ball in pairs(Workspace:GetChildren()) do
		if ball:IsA("BasePart") and ball.Name == "Ball" then
			local mag = (ball.Position - HumanoidRootPart.Position).Magnitude
			if mag < distance then
				distance = mag
				closest = ball
			end
		end
	end
	return closest
end

local function isBallComing(ball)
	if not ball or not ball:IsA("BasePart") then return false end
	local velocity = ball.Velocity
	local direction = (HumanoidRootPart.Position - ball.Position).Unit
	return velocity:Dot(direction) > 0.5
end

local function canParry()
	local hotbar = LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Hotbar")
	if not hotbar then return true end
	local cooldown = hotbar:FindFirstChild("Cooldown")
	return cooldown and cooldown.Size.X.Scale <= 0
end

local function parry()
	local args = {
		[1] = "Parry"
	}
	ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("ParryButtonPress"):FireServer(unpack(args))
end

RunService.Heartbeat:Connect(function()
	if not vampire.Enabled or not vampire.AutoParry then return end

	local ball = getClosestBall()
	if ball and isBallComing(ball) and canParry() then
		local distance = (ball.Position - HumanoidRootPart.Position).Magnitude
		local ping = getPing()
		local delay = (distance / ball.Velocity.Magnitude) - (ping / 1000)

		task.delay(delay, function()
			if vampire.AutoParry and isBallComing(ball) and canParry() then
				parry()
			end
		end)
	end
end)

RunService.RenderStepped:Connect(function()
	if not vampire.Enabled or not vampire.Triggerbot then return end

	local target = Mouse.Target
	if target and target:IsA("BasePart") and target.Name == "Ball" then
		if isBallComing(target) and canParry() then
			parry()
		end
	end
end)

local spamConnection
local function startSpamParry()
	if spamConnection then return end
	spamConnection = RunService.Heartbeat:Connect(function()
		if vampire.Enabled and vampire.SpamParry and canParry() then
			parry()
		end
	end)
end

local function stopSpamParry()
	if spamConnection then
		spamConnection:Disconnect()
		spamConnection = nil
	end
end

local MainTab = Window:CreateTab("Vampire")

MainTab:CreateToggle({
	Name = "Auto Parry",
	Default = vampire.AutoParry,
	Callback = function(state)
		vampire.AutoParry = state
	end
})

MainTab:CreateToggle({
	Name = "Triggerbot",
	Default = vampire.Triggerbot,
	Callback = function(state)
		vampire.Triggerbot = state
	end
})

MainTab:CreateToggle({
	Name = "Spam Parry",
	Default = vampire.SpamParry or false,
	Callback = function(state)
		vampire.SpamParry = state
		if state then
			startSpamParry()
		else
			stopSpamParry()
		end
	end
})

local flyConnection
local function startFly()
	if flyConnection then return end
	flyConnection = RunService.RenderStepped:Connect(function()
		if vampire.Enabled and vampire.Fly and HumanoidRootPart then
			HumanoidRootPart.Velocity = Vector3.new(0, 50, 0)
		end
	end)
end

local function stopFly()
	if flyConnection then
		flyConnection:Disconnect()
		flyConnection = nil
	end
end

-- Spinbot
local spinConnection
local function startSpinbot()
	if spinConnection then return end
	spinConnection = RunService.RenderStepped:Connect(function()
		if vampire.Enabled and vampire.Spinbot and HumanoidRootPart then
			HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(15), 0)
		end
	end)
end

local function stopSpinbot()
	if spinConnection then
		spinConnection:Disconnect()
		spinConnection = nil
	end
end

-- UI: Fly & Spinbot
MainTab:CreateToggle({
	Name = "Fly",
	Default = vampire.Fly,
	Callback = function(state)
		vampire.Fly = state
		if state then
			startFly()
		else
			stopFly()
		end
	end
})

MainTab:CreateToggle({
	Name = "Spinbot",
	Default = vampire.Spinbot,
	Callback = function(state)
		vampire.Spinbot = state
		if state then
			startSpinbot()
		else
			stopSpinbot()
		end
	end
})

local mobileButton
local function createMobileButton()
	if mobileButton then return end

	mobileButton = Instance.new("TextButton")
	mobileButton.Size = UDim2.new(0, 100, 0, 40)
	mobileButton.Position = UDim2.new(0.5, -50, 1, -60)
	mobileButton.AnchorPoint = Vector2.new(0.5, 1)
	mobileButton.Text = "Parry"
	mobileButton.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
	mobileButton.TextColor3 = Color3.new(1, 1, 1)
	mobileButton.Font = Enum.Font.GothamBold
	mobileButton.TextSize = 18
	mobileButton.Parent = CoreGui

	mobileButton.MouseButton1Click:Connect(function()
		if vampire.Enabled and vampire.MobileMode and canParry() then
			parry()
		end
	end)
end

local function removeMobileButton()
	if mobileButton then
		mobileButton:Destroy()
		mobileButton = nil
	end
end

MainTab:CreateToggle({
	Name = "Mobile Mode",
	Default = vampire.MobileMode,
	Callback = function(state)
		vampire.MobileMode = state
		if state then
			createMobileButton()
		else
			removeMobileButton()
		end
	end
})

local function applyHeadless()
	local head = Character:FindFirstChild("Head")
	if head then
		head.Transparency = 1
		local face = head:FindFirstChildOfClass("Decal")
		if face then
			face.Transparency = 1
		end
	end
end

local function removeHeadless()
	local head = Character:FindFirstChild("Head")
	if head then
		head.Transparency = 0
		local face = head:FindFirstChildOfClass("Decal")
		if face then
			face.Transparency = 0
		end
	end
end

local function applyKorblox()
	local leg = Character:FindFirstChild("RightLowerLeg") or Character:FindFirstChild("RightLeg")
	if leg then
		leg.Transparency = 1
	end
end

local function removeKorblox()
	local leg = Character:FindFirstChild("RightLowerLeg") or Character:FindFirstChild("RightLeg")
	if leg then
		leg.Transparency = 0
	end
end

MainTab:CreateToggle({
	Name = "Headless",
	Default = vampire.Headless or false,
	Callback = function(state)
		vampire.Headless = state
		if state then
			applyHeadless()
		else
			removeHeadless()
		end
	end
})

MainTab:CreateToggle({
	Name = "Korblox",
	Default = vampire.Korblox or false,
	Callback = function(state)
		vampire.Korblox = state
		if state then
			applyKorblox()
		else
			removeKorblox()
		end
	end
})

local MainTab = Window:CreateTab("Main")

MainTab:CreateToggle({
	Name = "Test Toggle",
	Default = false,
	Callback = function(state)
		print("Toggle state:", state)
	end
})