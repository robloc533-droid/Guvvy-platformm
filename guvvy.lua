-- This file is protected
-- Guvvy Platform
-- made by dc: luni010_
-- discord.gg/pjuj99ure5

--// SEMI-VISIBLE GUVVY PLATFORM

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local speed = 0.05
local maxY = 5
local platformSize = Vector3.new(1000, 2, 1000)
local platform
local enabled = false

-- GUI
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GuvvyGUI"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 80)
frame.Position = UDim2.new(0.5, -100, 0.7, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = screenGui

-- TOP CREDIT TEXT
local credit = Instance.new("TextLabel")
credit.Size = UDim2.new(1, -10, 0, 14)
credit.Position = UDim2.new(0, 5, 0, 2)
credit.BackgroundTransparency = 1
credit.Text = "made by dc: luni010_"
credit.TextColor3 = Color3.fromRGB(180, 180, 180)
credit.Font = Enum.Font.SourceSans
credit.TextSize = 12
credit.TextXAlignment = Enum.TextXAlignment.Center
credit.Parent = frame

-- MAIN BUTTON
local button = Instance.new("TextButton")
button.Size = UDim2.new(1, -10, 0, 36)
button.Position = UDim2.new(0, 5, 0, 18)
button.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
button.TextColor3 = Color3.new(1,1,1)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 18
button.Text = "PLATFORM OFF"
button.Parent = frame

-- BOTTOM DISCORD TEXT
local discord = Instance.new("TextLabel")
discord.Size = UDim2.new(1, -10, 0, 14)
discord.Position = UDim2.new(0, 5, 0, 58)
discord.BackgroundTransparency = 1
discord.Text = "discord.gg/pjuj99ure5"
discord.TextColor3 = Color3.fromRGB(150, 150, 150)
discord.Font = Enum.Font.SourceSans
discord.TextSize = 12
discord.TextXAlignment = Enum.TextXAlignment.Center
discord.Parent = frame

--// PROPER DRAG SYSTEM
local dragging = false
local dragStart
local startPos

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

frame.InputChanged:Connect(function(input)
	if dragging and (
		input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch
	) then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

-- Function to create semi-visible platform
local function createPlatform(hrp)
	if platform then platform:Destroy() end

	platform = Instance.new("Part")
	platform.Name = "GuvvyPlatform"
	platform.Size = platformSize
	platform.Anchored = true
	platform.CanCollide = true
	platform.Transparency = 0.5
	platform.Material = Enum.Material.SmoothPlastic
	platform.Color = Color3.fromRGB(40,40,40)
	platform.Position = Vector3.new(hrp.Position.X, hrp.Position.Y - 8, hrp.Position.Z)
	platform.Parent = workspace

	local currentY = platform.Position.Y

	local conn
	conn = RunService.Heartbeat:Connect(function()
		if not hrp.Parent or not platform or not enabled then
			conn:Disconnect()
			return
		end

		if currentY < maxY then
			currentY = math.min(currentY + speed, maxY)
		end

		platform.CFrame = CFrame.new(hrp.Position.X, currentY, hrp.Position.Z)
	end)
end

-- Button toggle ON/OFF
button.MouseButton1Click:Connect(function()
	enabled = not enabled

	if enabled then
		button.Text = "PLATFORM ON"
		button.BackgroundColor3 = Color3.fromRGB(50,200,50)

		local char = player.Character
		if char then
			local hrp = char:WaitForChild("HumanoidRootPart")
			createPlatform(hrp)
		end
	else
		button.Text = "PLATFORM OFF"
		button.BackgroundColor3 = Color3.fromRGB(200,50,50)

		if platform then
			platform.CanCollide = false
			task.delay(0.1, function()
				if platform then
					platform:Destroy()
					platform = nil
				end
			end)
		end
	end
end)
