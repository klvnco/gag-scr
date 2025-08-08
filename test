-- Simple Hello World UI for Delta Executor

-- Make sure the LocalPlayer exists
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()

-- Create GUI container
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HelloWorldGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

-- Attach to CoreGui for exploit-based GUI (safer from detection)
pcall(function()
    ScreenGui.Parent = gethui and gethui() or (syn and syn.protect_gui and syn.protect_gui(ScreenGui)) or game:GetService("CoreGui")
end)

-- Create background frame
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 150)
Frame.Position = UDim2.new(0.5, -150, 0.5, -75)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

-- Create text label
local Label = Instance.new("TextLabel")
Label.Size = UDim2.new(1, 0, 1, 0)
Label.BackgroundTransparency = 1
Label.Text = "Hello, World!"
Label.TextColor3 = Color3.fromRGB(255, 255, 255)
Label.TextScaled = true
Label.Font = Enum.Font.GothamBold
Label.Parent = Frame
