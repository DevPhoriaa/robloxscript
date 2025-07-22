-- Modern Fly GUI V4 with improved UI/UX
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local main = Instance.new("ScreenGui")
local mainFrame = Instance.new("Frame")
local titleBar = Instance.new("Frame")
local titleLabel = Instance.new("TextLabel")
local closeButton = Instance.new("TextButton")
local minimizeButton = Instance.new("TextButton")
local contentFrame = Instance.new("Frame")
local flyButton = Instance.new("TextButton")
local speedFrame = Instance.new("Frame")
local speedLabel = Instance.new("TextLabel")
local speedValue = Instance.new("TextLabel")
local speedDown = Instance.new("TextButton")
local speedUp = Instance.new("TextButton")
local statusFrame = Instance.new("Frame")
local statusLabel = Instance.new("TextLabel")

-- Variables
local speeds = 1
local isFlying = false
local isMinimized = false
local isVisible = true
local speaker = Players.LocalPlayer

-- Create rounded corners
local function createCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

-- Create shadow effect
local function createShadow(parent)
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 6, 1, 6)
    shadow.Position = UDim2.new(0, -3, 0, -3)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.8
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Parent = parent.Parent
    createCorner(shadow, 10)
    return shadow
end

-- Setup main GUI
main.Name = "ModernFlyGUI"
main.Parent = speaker:WaitForChild("PlayerGui")
main.ResetOnSpawn = false
main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame
mainFrame.Name = "MainFrame"
mainFrame.Parent = main
mainFrame.Size = UDim2.new(0, 280, 0, 140)
mainFrame.Position = UDim2.new(0.5, -140, 0.3, -70)
mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
createCorner(mainFrame, 12)
createShadow(mainFrame)

-- Make draggable
local dragging = false
local dragStart = nil
local startPos = nil

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Title Bar
titleBar.Name = "TitleBar"
titleBar.Parent = mainFrame
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
titleBar.BorderSizePixel = 0
local titleCorner = createCorner(titleBar, 12)

-- Title Label
titleLabel.Name = "TitleLabel"
titleLabel.Parent = titleBar
titleLabel.Size = UDim2.new(1, -70, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "✈ Fly GUI V4"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold

-- Close Button
closeButton.Name = "CloseButton"
closeButton.Parent = titleBar
closeButton.Size = UDim2.new(0, 30, 0, 25)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
closeButton.BorderSizePixel = 0
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
createCorner(closeButton, 6)

-- Minimize Button
minimizeButton.Name = "MinimizeButton"
minimizeButton.Parent = titleBar
minimizeButton.Size = UDim2.new(0, 30, 0, 25)
minimizeButton.Position = UDim2.new(1, -70, 0, 5)
minimizeButton.BackgroundColor3 = Color3.fromRGB(100, 100, 120)
minimizeButton.BorderSizePixel = 0
minimizeButton.Text = "−"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.TextScaled = true
minimizeButton.Font = Enum.Font.GothamBold
createCorner(minimizeButton, 6)

-- Content Frame
contentFrame.Name = "ContentFrame"
contentFrame.Parent = mainFrame
contentFrame.Size = UDim2.new(1, -20, 1, -45)
contentFrame.Position = UDim2.new(0, 10, 0, 40)
contentFrame.BackgroundTransparency = 1

-- Fly Button
flyButton.Name = "FlyButton"
flyButton.Parent = contentFrame
flyButton.Size = UDim2.new(0, 120, 0, 35)
flyButton.Position = UDim2.new(0, 10, 0, 10)
flyButton.BackgroundColor3 = Color3.fromRGB(80, 200, 120)
flyButton.BorderSizePixel = 0
flyButton.Text = "START FLY"
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.TextScaled = true
flyButton.Font = Enum.Font.GothamBold
createCorner(flyButton, 8)

-- Speed Frame
speedFrame.Name = "SpeedFrame"
speedFrame.Parent = contentFrame
speedFrame.Size = UDim2.new(0, 120, 0, 35)
speedFrame.Position = UDim2.new(1, -130, 0, 10)
speedFrame.BackgroundColor3 = Color3.fromRGB(70, 70, 85)
speedFrame.BorderSizePixel = 0
createCorner(speedFrame, 8)

-- Speed Label
speedLabel.Name = "SpeedLabel"
speedLabel.Parent = speedFrame
speedLabel.Size = UDim2.new(0, 50, 1, 0)
speedLabel.Position = UDim2.new(0, 5, 0, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed:"
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.Gotham

-- Speed Value
speedValue.Name = "SpeedValue"
speedValue.Parent = speedFrame
speedValue.Size = UDim2.new(0, 30, 1, 0)
speedValue.Position = UDim2.new(0, 55, 0, 0)
speedValue.BackgroundTransparency = 1
speedValue.Text = tostring(speeds)
speedValue.TextColor3 = Color3.fromRGB(100, 255, 200)
speedValue.TextScaled = true
speedValue.Font = Enum.Font.GothamBold

-- Speed Down Button
speedDown.Name = "SpeedDown"
speedDown.Parent = speedFrame
speedDown.Size = UDim2.new(0, 15, 0, 25)
speedDown.Position = UDim2.new(1, -35, 0, 5)
speedDown.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
speedDown.BorderSizePixel = 0
speedDown.Text = "−"
speedDown.TextColor3 = Color3.fromRGB(255, 255, 255)
speedDown.TextScaled = true
speedDown.Font = Enum.Font.GothamBold
createCorner(speedDown, 4)

-- Speed Up Button
speedUp.Name = "SpeedUp"
speedUp.Parent = speedFrame
speedUp.Size = UDim2.new(0, 15, 0, 25)
speedUp.Position = UDim2.new(1, -15, 0, 5)
speedUp.BackgroundColor3 = Color3.fromRGB(80, 200, 120)
speedUp.BorderSizePixel = 0
speedUp.Text = "+"
speedUp.TextColor3 = Color3.fromRGB(255, 255, 255)
speedUp.TextScaled = true
speedUp.Font = Enum.Font.GothamBold
createCorner(speedUp, 4)

-- Status Frame
statusFrame.Name = "StatusFrame"
statusFrame.Parent = contentFrame
statusFrame.Size = UDim2.new(1, -20, 0, 30)
statusFrame.Position = UDim2.new(0, 10, 1, -35)
statusFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
statusFrame.BorderSizePixel = 0
createCorner(statusFrame, 6)

-- Status Label
statusLabel.Name = "StatusLabel"
statusLabel.Parent = statusFrame
statusLabel.Size = UDim2.new(1, -10, 1, 0)
statusLabel.Position = UDim2.new(0, 5, 0, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Ready"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham

-- Animation functions
local function tweenButton(button, scale)
    local tween = TweenService:Create(button, TweenInfo.new(0.1), {Size = button.Size * scale})
    tween:Play()
    tween.Completed:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {Size = button.Size / scale}):Play()
    end)
end

local function updateStatus(text, color)
    statusLabel.Text = "Status: " .. text
    statusLabel.TextColor3 = color or Color3.fromRGB(200, 200, 200)
end

-- Flying functionality
local function toggleFly()
    isFlying = not isFlying
    
    if isFlying then
        flyButton.Text = "STOP FLY"
        flyButton.BackgroundColor3 = Color3.fromRGB(220, 80, 80)
        updateStatus("Flying", Color3.fromRGB(100, 255, 100))
        
        -- Enable flying
        local character = speaker.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                for _, state in pairs(Enum.HumanoidStateType:GetEnumItems()) do
                    humanoid:SetStateEnabled(state, false)
                end
                humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
            end
            
            -- Create flying mechanics
            for i = 1, speeds do
                spawn(function()
                    local heartbeat = RunService.Heartbeat
                    local tpwalking = true
                    
                    while tpwalking and isFlying and character and character.Parent do
                        heartbeat:Wait()
                        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                        local humanoid = character:FindFirstChildOfClass("Humanoid")
                        
                        if humanoidRootPart and humanoid and humanoid.MoveDirection.Magnitude > 0 then
                            character:TranslateBy(humanoid.MoveDirection)
                        end
                    end
                end)
            end
        end
    else
        flyButton.Text = "START FLY"
        flyButton.BackgroundColor3 = Color3.fromRGB(80, 200, 120)
        updateStatus("Stopped", Color3.fromRGB(255, 100, 100))
        
        -- Disable flying
        local character = speaker.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                for _, state in pairs(Enum.HumanoidStateType:GetEnumItems()) do
                    humanoid:SetStateEnabled(state, true)
                end
                humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
            end
        end
    end
end

-- Button connections
flyButton.MouseButton1Click:Connect(function()
    tweenButton(flyButton, 0.95)
    toggleFly()
end)

speedUp.MouseButton1Click:Connect(function()
    tweenButton(speedUp, 0.9)
    speeds = math.min(speeds + 1, 10)
    speedValue.Text = tostring(speeds)
    updateStatus("Speed: " .. speeds, Color3.fromRGB(100, 200, 255))
end)

speedDown.MouseButton1Click:Connect(function()
    tweenButton(speedDown, 0.9)
    if speeds > 1 then
        speeds = speeds - 1
        speedValue.Text = tostring(speeds)
        updateStatus("Speed: " .. speeds, Color3.fromRGB(100, 200, 255))
    end
end)

closeButton.MouseButton1Click:Connect(function()
    tweenButton(closeButton, 0.9)
    main:Destroy()
end)

minimizeButton.MouseButton1Click:Connect(function()
    tweenButton(minimizeButton, 0.9)
    isMinimized = not isMinimized
    
    local targetSize = isMinimized and UDim2.new(0, 280, 0, 35) or UDim2.new(0, 280, 0, 140)
    local tween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = targetSize})
    tween:Play()
    
    minimizeButton.Text = isMinimized and "□" or "−"
end)

-- Toggle GUI visibility with G key
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.G then
        isVisible = not isVisible
        
        local targetTransparency = isVisible and 0 or 1
        local tween = TweenService:Create(mainFrame, TweenInfo.new(0.2), {BackgroundTransparency = targetTransparency})
        tween:Play()
        
        -- Toggle all child elements
        for _, child in pairs(mainFrame:GetDescendants()) do
            if child:IsA("GuiObject") then
                if child:IsA("TextLabel") or child:IsA("TextButton") then
                    TweenService:Create(child, TweenInfo.new(0.2), {TextTransparency = targetTransparency}):Play()
                end
                if child.Name ~= "Shadow" then
                    TweenService:Create(child, TweenInfo.new(0.2), {BackgroundTransparency = child.BackgroundTransparency + (targetTransparency - child.BackgroundTransparency)}):Play()
                end
            end
        end
    end
end)

-- Character respawn handling
speaker.CharacterAdded:Connect(function(character)
    wait(0.7)
    if isFlying then
        toggleFly() -- Reset flying state
        toggleFly() -- Re-enable if was flying
    end
end)

-- Welcome notification
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Modern Fly GUI V4";
    Text = "Press 'G' to toggle visibility • Drag to move";
    Duration = 5;
})
