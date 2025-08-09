repeat task.wait() until game:IsLoaded() and game:GetService("Players") and game:GetService("Players").LocalPlayer and game:GetService("Players").LocalPlayer.Character

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
-- ====== File system and download setup ======
if not isfolder("GagHub") then
    makefolder("GagHub")
end
if not isfolder("GagHub/Assets") then
    makefolder("GagHub/Assets")
end
local imageUrl = "https://raw.githubusercontent.com/klvnco/gag-scr/main/klvn-slvr.png"
local imagePath = "GagHub/Assets/klvn-slvr.png"

if not isfile(imagePath) then
    local req = (syn and syn.request or http and http.request or request)({
        Url = imageUrl,
        Method = "GET"
    })
    if req and req.StatusCode == 200 then
        writefile(imagePath, req.Body)
        print("✅ Image downloaded:", imagePath)
    else
        warn("❌ Failed to download image")
    end
end

-- ====== Create GUI ======
local gui = Instance.new("ScreenGui")
gui.Name = "kid"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

pcall(function()
    gui.Parent = gethui and gethui() or (syn and syn.protect_gui and syn.protect_gui(gui)) or game:GetService("CoreGui")
end)

-- Main window frame
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 300, 0, 300)
main.Position = UDim2.new(0.5, -150, 0.5, -80)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.BorderSizePixel = 0
main.Parent = gui

local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 8)

-- Title bar
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.Text = "kid"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamSemibold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

local titleCorner = Instance.new("UICorner", title)
titleCorner.CornerRadius = UDim.new(0, 8)

-- Close button
local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 20, 0, 20)
close.Position = UDim2.new(1, -28, 0, 3)
close.Text = "x"
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

-- Minimize button
local minimize = Instance.new("TextButton")
minimize.Size = UDim2.new(0, 20, 0, 20)
minimize.Position = UDim2.new(1, -56, 0, 3)
minimize.Text = "-"
minimize.BackgroundColor3 = Color3.fromRGB(80, 80, 200)
minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 16
minimize.Parent = title

local minimizeCorner = Instance.new("UICorner", minimize)
minimizeCorner.CornerRadius = UDim.new(0, 4)

-- Content label
local content = Instance.new("TextLabel")
content.Size = UDim2.new(1, -20, 1, -50)
content.Position = UDim2.new(0, 10, 0, 40)
content.BackgroundTransparency = 1
content.Text = "Hello, World!"
content.TextColor3 = Color3.fromRGB(255, 255, 255)
content.TextScaled = true
content.Font = Enum.Font.Gotham
content.Parent = main

-- Restore icon (starts hidden)
local restoreIcon = Instance.new("ImageButton")
restoreIcon.Size = UDim2.new(0, 40, 0, 40)
restoreIcon.Position = UDim2.new(0, 10, 1, -50)
restoreIcon.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
restoreIcon.Image = getcustomasset(imagePath)
restoreIcon.Visible = false
restoreIcon.Parent = gui

local restoreCorner = Instance.new("UICorner", restoreIcon)
restoreCorner.CornerRadius = UDim.new(1, 0)

-- Dragging variables for main window
local dragging, dragStart, startPos

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
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                  startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Dragging variables for restore icon
local draggingIcon, iconDragStart, iconStartPos

restoreIcon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingIcon = true
        iconDragStart = input.Position
        iconStartPos = restoreIcon.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                draggingIcon = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if draggingIcon and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - iconDragStart
        restoreIcon.Position = UDim2.new(iconStartPos.X.Scale, iconStartPos.X.Offset + delta.X,
                                         iconStartPos.Y.Scale, iconStartPos.Y.Offset + delta.Y)
    end
end)

-- Minimize button functionality
minimize.MouseButton1Click:Connect(function()
    main.Visible = false
    restoreIcon.Visible = true
end)

-- Restore icon functionality
restoreIcon.MouseButton1Click:Connect(function()
    main.Visible = true
    restoreIcon.Visible = false
end)
