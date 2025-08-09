repeat task.wait() until game:IsLoaded() and game:GetService("Players") and game:GetService("Players").LocalPlayer and game:GetService("Players").LocalPlayer.Character

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local version = "kid v1.1"


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
gui.Name = "  " .. version
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

pcall(function()
    gui.Parent = gethui and gethui() or (syn and syn.protect_gui and syn.protect_gui(gui)) or game:GetService("CoreGui")
end)

-- Main window frame
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 400, 0, 300)
main.Position = UDim2.new(0.5, -150, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.BorderSizePixel = 0
main.Parent = gui

local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 8)

-- Title bar
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.Text = "  " .. version
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamSemibold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

local titleCorner = Instance.new("UICorner", title)
titleCorner.CornerRadius = UDim.new(0, 8)

-- Close button
local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 20, 0, 20)
close.Position = UDim2.new(1, -28, 0, 5)
close.Text = "x"
--close.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
close.TextColor3 = Color3.fromRGB(255, 255, 255)
close.Font = Enum.Font.GothamBold
close.TextSize = 14
close.Parent = title

local closeCorner = Instance.new("UICorner", close)
closeCorner.CornerRadius = UDim.new(0, 4)

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Minimize button
local minimize = Instance.new("TextButton")
minimize.Size = UDim2.new(0, 20, 0, 20)
minimize.Position = UDim2.new(1, -56, 0, 5)
minimize.Text = "-"
--minimize.BackgroundColor3 = Color3.fromRGB(80, 80, 200)
minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 14
minimize.Parent = title

local minimizeCorner = Instance.new("UICorner", minimize)
minimizeCorner.CornerRadius = UDim.new(0, 10)

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

-- Add a subtle separator line
local separator = Instance.new("Frame")
separator.Size = UDim2.new(1, 0, 0, 1)
separator.Position = UDim2.new(0, 0, 0, 40)
separator.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
separator.BorderSizePixel = 0
separator.Parent = main

-- Left panel for menu (30% width)
local leftPanel = Instance.new("Frame")
leftPanel.Position = UDim2.new(0, 0, 0, 35)  -- <-- add this line to move down by 30 px
leftPanel.Size = UDim2.new(0.30, 0, 1, -35)
leftPanel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
leftPanel.BorderSizePixel = 0

leftPanel.Parent = main


local leftCorner = Instance.new("UICorner", leftPanel)
leftCorner.CornerRadius = UDim.new(0, 8)

-- Right panel for content (70% width)
local rightPanel = Instance.new("Frame")
rightPanel.Size = UDim2.new(0.70, 0, 1, -30)  -- reduce height by 30 px
rightPanel.Position = UDim2.new(0.3, 0, 0, 30) -- move down by 30 px
rightPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
rightPanel.BorderSizePixel = 0
rightPanel.Parent = main


local rightCorner = Instance.new("UICorner", rightPanel)
rightCorner.CornerRadius = UDim.new(0, 8)

-- Content label inside right panel
local rightContent = Instance.new("TextLabel")
rightContent.Size = UDim2.new(1, -20, 1, -20)
rightContent.Position = UDim2.new(0, 10, 0, 10)
rightContent.BackgroundTransparency = 1
rightContent.TextColor3 = Color3.fromRGB(255, 255, 255)
rightContent.TextWrapped = true
rightContent.Font = Enum.Font.Gotham
rightContent.TextSize = 14
rightContent.Text = "Select a menu from the left"
rightContent.Parent = rightPanel

-- Function to create menu buttons inside leftPanel
local function createMenuButton(text, posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 20)
    btn.Position = UDim2.new(0, 5, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 12
    btn.Text = text
    btn.Parent = leftPanel

    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 6)

    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    end)

    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end)

    return btn
end

-- Create 3 menu buttons
local menu1 = createMenuButton("Menu 1", 10)
local menu2 = createMenuButton("Menu 2", 40)
local menu3 = createMenuButton("Menu 3", 70)

local function clearRightPanel()
    for _, child in pairs(rightPanel:GetChildren()) do
        if not child:IsA("UIListLayout") then
            child:Destroy()
        end
    end
end

local function showMenu1()
    clearRightPanel()
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -20, 1, -20)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "Options for Menu 1:\n- Option A\n- Option B\n- Option C"
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.Font = Enum.Font.Gotham
    textLabel.TextSize = 14
    textLabel.TextWrapped = true
    textLabel.Parent = rightPanel
end

local function showMenu2()
    clearRightPanel()
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -20, 1, -20)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "Options for Menu 2:\n- Setting 1\n- Setting 2\n- Setting 3"
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.Font = Enum.Font.Gotham
    textLabel.TextSize = 14
    textLabel.TextWrapped = true
    textLabel.Parent = rightPanel
end

local function showMenu3()
    clearRightPanel()
    for _, child in pairs(rightPanel:GetChildren()) do
        if not child:IsA("UIListLayout") then
            child:Destroy()
        end
    end

    -- Add a UIListLayout to arrange rows vertically
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 10)  -- spacing between rows
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = rightPanel

    -- Helper function to create label (modified for inline)
    local function createLabel(text, widthPercent)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(widthPercent or 0.2, -5, 0, 30)  -- Default to 30% width with 5px margin
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        lbl.Font = Enum.Font.GothamSemibold
        lbl.TextSize = 10
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        return lbl
    end

    -- Helper function to create dropdown (modified for inline)
    local function createDropdown(widthPercent)
        local dropdown = Instance.new("TextButton")
        dropdown.Size = UDim2.new(widthPercent or 0.7, -5, 0, 30)  -- Default to 70% width with 5px margin
        dropdown.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
        dropdown.Font = Enum.Font.Gotham
        dropdown.TextSize = 10
        dropdown.Text = "Select an option ▼"
        dropdown.AutoButtonColor = true

        dropdown.MouseButton1Click:Connect(function()
            print("Dropdown clicked!")
        end)

        return dropdown
    end

    -- Helper function to create row container
    local function createRow(height)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -10, 0, height or 40)  -- 10px side padding
        row.BackgroundTransparency = 1
        return row
    end

    -- Row 1: Label + Dropdown in same row
    local row1 = createRow(40)
    row1.LayoutOrder = 1
    row1.Parent = rightPanel

    -- Add horizontal layout for this row
    local row1Layout = Instance.new("UIListLayout")
    row1Layout.FillDirection = Enum.FillDirection.Horizontal
    row1Layout.Padding = UDim.new(0, 10)  -- Space between label and dropdown
    row1Layout.Parent = row1

    local row1Label = createLabel("Choose option:", 0.2)
    row1Label.Parent = row1

    local row1Dropdown = createDropdown(0.7)
    row1Dropdown.Parent = row1

    -- Row 2: Label + TextBox in same row
    local row2 = createRow(40)
    row2.LayoutOrder = 2
    row2.Parent = rightPanel

    local row2Layout = Instance.new("UIListLayout")
    row2Layout.FillDirection = Enum.FillDirection.Horizontal
    row2Layout.Padding = UDim.new(0, 10)
    row2Layout.Parent = row2

    local row2Label = createLabel("Enter text:", 0.2)
    row2Label.Parent = row2

    local row2TextBox = Instance.new("TextBox")
    row2TextBox.Size = UDim2.new(0.7, -5, 0, 30)
    row2TextBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    row2TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    row2TextBox.Font = Enum.Font.Gotham
    row2TextBox.TextSize = 14
    row2TextBox.ClearTextOnFocus = false
    row2TextBox.PlaceholderText = "Enter text here"
    row2TextBox.Parent = row2

    -- Row 3: Buttons (unchanged)
    local row3 = createRow(40)
    row3.LayoutOrder = 3
    row3.Parent = rightPanel

    local btnReLogin = Instance.new("TextButton")
    btnReLogin.Size = UDim2.new(0.48, 0, 0, 30)
    btnReLogin.BackgroundColor3 = Color3.fromRGB(70, 70, 200)
    btnReLogin.TextColor3 = Color3.fromRGB(255, 255, 255)
    btnReLogin.Font = Enum.Font.GothamSemibold
    btnReLogin.TextSize = 12
    btnReLogin.Text = "Re-login"
    btnReLogin.Position = UDim2.new(0, 0, 0, 0)
    btnReLogin.Parent = row3

    local btnClearList = Instance.new("TextButton")
    btnClearList.Size = UDim2.new(0.48, 0, 0, 30)
    btnClearList.BackgroundColor3 = Color3.fromRGB(70, 70, 200)
    btnClearList.TextColor3 = Color3.fromRGB(255, 255, 255)
    btnClearList.Font = Enum.Font.GothamSemibold
    btnClearList.TextSize = 12
    btnClearList.Text = "Clear list"
    btnClearList.Position = UDim2.new(0.52, 0, 0, 0)
    btnClearList.Parent = row3

    -- Button functionality
    btnReLogin.MouseButton1Click:Connect(function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
    end)
    btnClearList.MouseButton1Click:Connect(function()
        print("Clear list clicked")
    end)
end

menu1.MouseButton1Click:Connect(showMenu1)
menu2.MouseButton1Click:Connect(showMenu2)
menu3.MouseButton1Click:Connect(showMenu3)




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
