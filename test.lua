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
gui.Name = "  kid v1.1"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

pcall(function()
    gui.Parent = gethui and gethui() or (syn and syn.protect_gui and syn.protect_gui(gui)) or game:GetService("CoreGui")
end)

-- Main window frame
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 400, 0, 250)
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
title.Text = "  kid v1.0"
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
close.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
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
minimize.BackgroundColor3 = Color3.fromRGB(80, 80, 200)
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

-- Left panel for menu (30% width)
local leftPanel = Instance.new("Frame")
leftPanel.Size = UDim2.new(0.3, 0, 1, -30)
leftPanel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
leftPanel.BorderSizePixel = 0
leftPanel.Position = UDim2.new(0, 0, 0, 30)  -- <-- add this line to move down by 30 px
leftPanel.Size = UDim2.new(0.3, 0, 1, -30)    -- <-- reduce height by 30 px
leftPanel.Parent = main


local leftCorner = Instance.new("UICorner", leftPanel)
leftCorner.CornerRadius = UDim.new(0, 8)

-- Right panel for content (70% width)
local rightPanel = Instance.new("Frame")
rightPanel.Size = UDim2.new(0.7, 0, 1, -30)  -- reduce height by 30 px
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

-- Button click events to update right panel content
menu1.MouseButton1Click:Connect(function()
    rightContent.Text = "Options for Menu 1:\n- Option A\n- Option B\n- Option C"
end)

menu2.MouseButton1Click:Connect(function()
    rightContent.Text = "Options for Menu 2:\n- Setting 1\n- Setting 2\n- Setting 3"
end)

--menu3.MouseButton1Click:Connect(function()
--    rightContent.Text = "Options for Menu 3:\n- Feature X\n- Feature Y\n- Feature Z"
--end)
menu3.MouseButton1Click:Connect(function()
    -- Clear existing content
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

    -- Helper function to create label
    local function createLabel(text)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -20, 0, 25)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        lbl.Font = Enum.Font.GothamSemibold
        lbl.TextSize = 10
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.LayoutOrder = 1
        return lbl
    end

    -- Helper function to create dropdown (simple simulated)
    local function createDropdown()
        local dropdown = Instance.new("TextButton")
        dropdown.Size = UDim2.new(1, -20, 0, 30)
        dropdown.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
        dropdown.Font = Enum.Font.Gotham
        dropdown.TextSize = 10
        dropdown.Text = "Select an option ▼"
        dropdown.LayoutOrder = 2
        dropdown.AutoButtonColor = true

        -- You can add real dropdown logic here later
        dropdown.MouseButton1Click:Connect(function()
            print("Dropdown clicked!")
        end)

        return dropdown
    end

    -- Helper function to create TextBox
    local function createTextBox()
        local tb = Instance.new("TextBox")
        tb.Size = UDim2.new(1, -20, 0, 30)
        tb.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        tb.TextColor3 = Color3.fromRGB(255, 255, 255)
        tb.Font = Enum.Font.Gotham
        tb.TextSize = 14
        tb.ClearTextOnFocus = false
        tb.PlaceholderText = "Enter text here"
        tb.LayoutOrder = 4
        return tb
    end

    -- Helper function to create button
    local function createButton(text, layoutOrder)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.48, 0, 0, 15)
        btn.BackgroundColor3 = Color3.fromRGB(70, 70, 200)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamSemibold
        btn.TextSize = 10
        btn.Text = text
        btn.LayoutOrder = layoutOrder
        return btn
    end

    -- Row 1: Label + Dropdown
    local row1 = Instance.new("Frame")
    row1.Size = UDim2.new(1, 0, 0, 60)
    row1.BackgroundTransparency = 1
    row1.LayoutOrder = 1
    row1.Parent = rightPanel

    local row1Label = createLabel("Choose option:")
    row1Label.Position = UDim2.new(0, 0, 0, 0)
    row1Label.Parent = row1

    local row1Dropdown = createDropdown()
    row1Dropdown.Position = UDim2.new(0, 0, 0, 30)
    row1Dropdown.Parent = row1

    -- Row 2: Label + TextBox
    local row2 = Instance.new("Frame")
    row2.Size = UDim2.new(1, 0, 0, 60)
    row2.BackgroundTransparency = 1
    row2.LayoutOrder = 2
    row2.Parent = rightPanel

    local row2Label = createLabel("Enter text:")
    row2Label.Position = UDim2.new(0, 0, 0, 0)
    row2Label.Parent = row2

    local row2TextBox = createTextBox()
    row2TextBox.Position = UDim2.new(0, 0, 0, 30)
    row2TextBox.Parent = row2

    -- Row 3: Two buttons side by side
    local row3 = Instance.new("Frame")
    row3.Size = UDim2.new(1, 0, 0, 40)
    row3.BackgroundTransparency = 1
    row3.LayoutOrder = 3
    row3.Parent = rightPanel

    --local btnReLogin = createButton("Re-login", 1)
    --btnReLogin.Position = UDim2.new(0, 0, 0, 0)
    --btnReLogin.Parent = row3
    -- Add this where you create buttons inside Menu 3, for example inside your layout setup:

    local TeleportService = game:GetService("TeleportService")
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    
    local btnReLogin = createButton("Re-login", 1)
    btnReLogin.Position = UDim2.new(0, 0, 0, 0)
    btnReLogin.Parent = row3    
    btnReLogin.MouseButton1Click:Connect(function()
        TeleportService:Teleport(game.PlaceId, player)
    end)
        
    local btnClearList = createButton("Clear list", 2)
    btnClearList.Position = UDim2.new(0.52, 0, 0, 0)  -- small gap between buttons
    btnClearList.Parent = row3

    -- Example button events
    btnReLogin.MouseButton1Click:Connect(function()
        print("Re-login clicked")
    end)
    btnClearList.MouseButton1Click:Connect(function()
        print("Clear list clicked")
    end)
end)


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
