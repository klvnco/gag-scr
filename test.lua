
-- Draggable Hello World GUI with Close Button (Delta Executor Safe)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- Create main GUI
local gui = Instance.new("ScreenGui")
gui.Name = "HelloWorldOverlay"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global

-- Parent to CoreGui / gethui (executor-safe)
pcall(function()
	gui.Parent = gethui and gethui() or (syn and syn.protect_gui and syn.protect_gui(gui)) or game:GetService("CoreGui")
end)

-- Window frame
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 300, 0, 160)
main.Position = UDim2.new(0.5, -150, 0.5, -80)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.BorderSizePixel = 0
main.Parent = gui

-- Round corners
local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 8)

-- Title bar (drag area)
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.Text = " Hello Window"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamSemibold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

local titleCorner = Instance.new("UICorner", title)
titleCorner.CornerRadius = UDim.new(0, 8)

-- Close button
local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 24, 0, 24)
close.Position = UDim2.new(1, -28, 0, 3)
close.Text = "✕"
close.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
close.TextColor3 = Color3.fromRGB(255, 255, 255)
close.Font = Enum.Font.GothamBold
close.TextSize = 16
close.Parent = title

local closeCorner = Instance.new("UICorner", close)
closeCorner.CornerRadius = UDim.new(0, 4)

close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

-- Content (Hello World)
local content = Instance.new("TextLabel")
content.Size = UDim2.new(1, -20, 1, -50)
content.Position = UDim2.new(0, 10, 0, 40)
content.BackgroundTransparency = 1
content.Text = "Hello, World!"
content.TextColor3 = Color3.fromRGB(255, 255, 255)
content.TextScaled = true
content.Font = Enum.Font.Gotham
content.Parent = main

-- Make window draggable (custom method)
local dragging, dragInput, dragStart, startPos

title.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = main.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)
