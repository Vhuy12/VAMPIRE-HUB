function loadMainScript()
    loadstring(game:HttpGet("https://pandadevelopment.net/virtual/file/9b2141f7f19f5004"))()
end

local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "GetKeyUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

local container = Instance.new("Frame", gui)
container.Size = UDim2.new(0, 320, 0, 180)
container.Position = UDim2.new(0.5, 0, 0.5, 0)
container.AnchorPoint = Vector2.new(0.5, 0.5)
container.BackgroundTransparency = 1

local frame = Instance.new("Frame", container)
frame.Size = UDim2.new(0, 0, 0, 0)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(22, 18, 34)
frame.BackgroundTransparency = 1
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

local gradient = Instance.new("UIGradient", frame)
gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 130, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 130, 255))
}
gradient.Rotation = 90

local title = Instance.new("TextLabel", frame)
title.Text = "Vampire get key"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(235, 235, 255)
title.BackgroundTransparency = 1
title.TextTransparency = 1
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 8)

local textbox = Instance.new("TextBox", frame)
textbox.Size = UDim2.new(0.8, 0, 0, 30)
textbox.Position = UDim2.new(0.1, 0, 0.35, 0)
textbox.PlaceholderText = "Enter your key..."
textbox.Text = ""
textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
textbox.BackgroundColor3 = Color3.fromRGB(50, 40, 80)
textbox.Font = Enum.Font.Gotham
textbox.TextSize = 13
textbox.TextTransparency = 1
textbox.BackgroundTransparency = 1
Instance.new("UICorner", textbox).CornerRadius = UDim.new(0, 6)

local buttonRow = Instance.new("Frame", frame)
buttonRow.Size = UDim2.new(0.8, 0, 0, 30)
buttonRow.Position = UDim2.new(0.1, 0, 0.65, 0)
buttonRow.BackgroundTransparency = 1

local getKeyMain = Instance.new("TextButton", buttonRow)
getKeyMain.Size = UDim2.new(0.48, 0, 1, 0)
getKeyMain.Position = UDim2.new(0, 0, 0, 0)
getKeyMain.Text = "Get Key"
getKeyMain.TextColor3 = Color3.fromRGB(255, 255, 255)
getKeyMain.BackgroundColor3 = Color3.fromRGB(100, 80, 255)
getKeyMain.Font = Enum.Font.GothamBold
getKeyMain.TextSize = 13
getKeyMain.TextTransparency = 1
getKeyMain.BackgroundTransparency = 1
Instance.new("UICorner", getKeyMain).CornerRadius = UDim.new(0, 6)

local submit = Instance.new("TextButton", buttonRow)
submit.Size = UDim2.new(0.48, 0, 1, 0)
submit.Position = UDim2.new(0.52, 0, 0, 0)
submit.Text = "Submit"
submit.TextColor3 = Color3.fromRGB(255, 255, 255)
submit.BackgroundColor3 = Color3.fromRGB(120, 100, 255)
submit.Font = Enum.Font.GothamBold
submit.TextSize = 13
submit.TextTransparency = 1
submit.BackgroundTransparency = 1
Instance.new("UICorner", submit).CornerRadius = UDim.new(0, 6)

local function hover(btn, color1, color2)
	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundColor3 = color2 }):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundColor3 = color1 }):Play()
	end)
end

hover(submit, Color3.fromRGB(120, 100, 255), Color3.fromRGB(140, 120, 255))
hover(getKeyMain, Color3.fromRGB(100, 80, 255), Color3.fromRGB(130, 110, 255))

getKeyMain.MouseButton1Click:Connect(function()
	setclipboard("https://discord.gg/ppSY9wgf")
end)

local validKey = "VampireOnTop"
submit.MouseButton1Click:Connect(function()
	if textbox.Text == validKey then
		for _, child in pairs(frame:GetDescendants()) do
			if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
				TweenService:Create(child, TweenInfo.new(0.3), {
					TextTransparency = 1,
					BackgroundTransparency = 1
				}):Play()
			end
		end
		TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			Size = UDim2.new(0, 0, 0, 0),
			Position = UDim2.new(0.5, 0, 0.55, 0),
			BackgroundTransparency = 1
		}):Play()

		local notify = Instance.new("TextLabel", gui)
		notify.Size = UDim2.new(0, 200, 0, 40)
		notify.Position = UDim2.new(0.5, 0, 0.5, 0)
		notify.AnchorPoint = Vector2.new(0.5, 0.5)
		notify.BackgroundColor3 = Color3.fromRGB(40, 200, 120)
		notify.Text = "✅ Execute Script"
		notify.TextColor3 = Color3.new(1, 1, 1)
		notify.Font = Enum.Font.GothamBold
		notify.TextSize = 16
		notify.BackgroundTransparency = 0
		Instance.new("UICorner", notify).CornerRadius = UDim.new(0, 8)

		task.delay(2, function()
			TweenService:Create(notify, TweenInfo.new(0.5), {
				TextTransparency = 1,
				BackgroundTransparency = 1
			}):Play()
			wait(0.5)
			notify:Destroy()
		end)

		wait(0.4)
		gui:Destroy()
		loadMainScript()
	else
		textbox.Text = ""
		textbox.PlaceholderText = "❌ Invalid key. Try again."
	end
end)

TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
	Size = UDim2.new(1, 0, 1, 0),
	BackgroundTransparency = 0.2
}):Play()

for _, child in pairs(frame:GetDescendants()) do
	if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
		TweenService:Create(child, TweenInfo.new(0.4), {
			TextTransparency = 0,
			BackgroundTransparency = 0
		}):Play()
	end
end