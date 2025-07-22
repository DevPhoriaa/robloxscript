-- Fly GUI V4 - Improved UI/UX
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables
local flying = false
local speed = 1
local bodyVelocity = nil
local bodyGyro = nil
local connections = {}

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyGUI_V4"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
mainFrame.BorderSizePixel = 0
mainFrame.Position = UDim2.new(0.1, 0, 0.3, 0)
mainFrame.Size = UDim2.new(0, 250, 0, 120)
mainFrame.Active = true
mainFrame.Draggable = true

-- Add corner radius
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

-- Add subtle shadow effect
local shadow = Instance.new("Frame")
shadow.Name = "Shadow"
shadow.Parent = mainFrame
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.8
shadow.BorderSizePixel = 0
shadow.Position = UDim2.new(0, 3, 0, 3)
shadow.Size = UDim2.new(1, 0, 1, 0)
shadow.ZIndex = mainFrame.ZIndex - 1

local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 10)
shadowCorner.Parent = shadow

-- Title Label
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Parent = mainFrame
titleLabel.BackgroundTransparency = 1
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "Fly GUI V4"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 16
titleLabel.TextStrokeTransparency = 0.5

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Parent = mainFrame
closeButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
closeButton.BorderSizePixel = 0
closeButton.Position = UDim2.new(1, -25, 0, 5)
closeButton.Size = UDim2.new(0, 20, 0, 20)
closeButton.Font = Enum.Font.GothamBold
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 14

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 10)
closeCorner.Parent = closeButton

-- Fly Toggle Button
local flyButton = Instance.new("TextButton")
flyButton.Name = "FlyButton"
flyButton.Parent = mainFrame
flyButton.BackgroundColor3 = Color3.fromRGB(70, 255, 70)
flyButton.BorderSizePixel = 0
flyButton.Position = UDim2.new(0.05, 0, 0.35, 0)
flyButton.Size = UDim2.new(0.4, 0, 0.25, 0)
flyButton.Font = Enum.Font.GothamSemibold
flyButton.Text = "FLY"
flyButton.TextColor3 = Color3.fromRGB(0, 0, 0)
flyButton.TextSize = 14

local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0, 6)
flyCorner.Parent = flyButton

-- Speed Control Frame
local speedFrame = Instance.new("Frame")
speedFrame.Name = "SpeedFrame"
speedFrame.Parent = mainFrame
speedFrame.BackgroundTransparency = 1
speedFrame.Position = UDim2.new(0.5, 0, 0.35, 0)
speedFrame.Size = UDim2.new(0.45, 0, 0.25, 0)

-- Speed Decrease Button
local speedDownButton = Instance.new("TextButton")
speedDownButton.Name = "SpeedDown"
speedDownButton.Parent = speedFrame
speedDownButton.BackgroundColor3 = Color3.fromRGB(255, 150, 150)
speedDownButton.BorderSizePixel = 0
speedDownButton.Position = UDim2.new(0, 0, 0, 0)
speedDownButton.Size = UDim2.new(0.25, 0, 1, 0)
speedDownButton.Font = Enum.Font.GothamBold
speedDownButton.Text = "-"
speedDownButton.TextColor3 = Color3.fromRGB(0, 0, 0)
speedDownButton.TextSize = 16

local speedDownCorner = Instance.new("UICorner")
speedDownCorner.CornerRadius = UDim.new(0, 4)
speedDownCorner.Parent = speedDownButton

-- Speed Display
local speedLabel = Instance.new("TextLabel")
speedLabel.Name = "SpeedLabel"
speedLabel.Parent = speedFrame
speedLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
speedLabel.BorderSizePixel = 0
speedLabel.Position = UDim2.new(0.3, 0, 0, 0)
speedLabel.Size = UDim2.new(0.4, 0, 1, 0)
speedLabel.Font = Enum.Font.GothamSemibold
speedLabel.Text = tostring(speed)
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextSize = 14

local speedLabelCorner = Instance.new("UICorner")
speedLabelCorner.CornerRadius = UDim.new(0, 4)
speedLabelCorner.Parent = speedLabel

-- Speed Increase Button
local speedUpButton = Instance.new("TextButton")
speedUpButton.Name = "SpeedUp"
speedUpButton.Parent = speedFrame
speedUpButton.BackgroundColor3 = Color3.fromRGB(150, 255, 150)
speedUpButton.BorderSizePixel = 0
speedUpButton.Position = UDim2.new(0.75, 0, 0, 0)
speedUpButton.Size = UDim2.new(0.25, 0, 1, 0)
speedUpButton.Font = Enum.Font.GothamBold
speedUpButton.Text = "+"
speedUpButton.TextColor3 = Color3.fromRGB(0, 0, 0)
speedUpButton.TextSize = 16

local speedUpCorner = Instance.new("UICorner")
speedUpCorner.CornerRadius = UDim.new(0, 4)
speedUpCorner.Parent = speedUpButton

-- Up/Down Control Frame
local controlFrame = Instance.new("Frame")
controlFrame.Name = "ControlFrame"
controlFrame.Parent = mainFrame
controlFrame.BackgroundTransparency = 1
controlFrame.Position = UDim2.new(0.05, 0, 0.65, 0)
controlFrame.Size = UDim2.new(0.9, 0, 0.25, 0)

-- Up Button
local upButton = Instance.new("TextButton")
upButton.Name = "UpButton"
upButton.Parent = controlFrame
upButton.BackgroundColor3 = Color3.fromRGB(150, 150, 255)
upButton.BorderSizePixel = 0
upButton.Position = UDim2.new(0, 0, 0, 0)
upButton.Size = UDim2.new(0.48, 0, 1, 0)
upButton.Font = Enum.Font.GothamSemibold
upButton.Text = "UP"
upButton.TextColor3 = Color3.fromRGB(0, 0, 0)
upButton.TextSize = 12

local upCorner = Instance.new("UICorner")
upCorner.CornerRadius = UDim.new(0, 4)
upCorner.Parent = upButton

-- Down Button
local downButton = Instance.new("TextButton")
downButton.Name = "DownButton"
downButton.Parent = controlFrame
downButton.BackgroundColor3 = Color3.fromRGB(255, 200, 150)
downButton.BorderSizePixel = 0
downButton.Position = UDim2.new(0.52, 0, 0, 0)
downButton.Size = UDim2.new(0.48, 0, 1, 0)
downButton.Font = Enum.Font.GothamSemibold
downButton.Text = "DOWN"
downButton.TextColor3 = Color3.fromRGB(0, 0, 0)
downButton.TextSize = 12

local downCorner = Instance.new("UICorner")
downCorner.CornerRadius = UDim.new(0, 4)
downCorner.Parent = downButton

-- Functions
local function createTween(object, properties, duration)
    local tweenInfo = TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    return TweenService:Create(object, tweenInfo, properties)
end

local function updateSpeedDisplay()
    speedLabel.Text = tostring(speed)
end

local function cleanupFly()
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    if bodyGyro then
        bodyGyro:Destroy()
        bodyGyro = nil
    end
    
    for _, connection in pairs(connections) do
        if connection then
            connection:Disconnect()
        end
    end
    connections = {}
    
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
            -- Re-enable all humanoid states
            for _, state in pairs(Enum.HumanoidStateType:GetEnumItems()) do
                if state ~= Enum.HumanoidStateType.None then
                    humanoid:SetStateEnabled(state, true)
                end
            end
        end
        
        local animate = character:FindFirstChild("Animate")
        if animate then
            animate.Disabled = false
        end
    end
end

local function startFly()
    local character = player.Character
    if not character then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    if not rootPart or not humanoid then return end
    
    -- Disable animations and humanoid states
    local animate = character:FindFirstChild("Animate")
    if animate then
        animate.Disabled = true
    end
    
    for _, state in pairs(Enum.HumanoidStateType:GetEnumItems()) do
        if state ~= Enum.HumanoidStateType.None then
            humanoid:SetStateEnabled(state, false)
        end
    end
    
    humanoid.PlatformStand = true
    humanoid:ChangeState(Enum.HumanoidStateType.Physics)
    
    -- Create body movers
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = rootPart
    
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(4000, 4000, 4000)
    bodyGyro.P = 3000
    bodyGyro.D = 500
    bodyGyro.CFrame = rootPart.CFrame
    bodyGyro.Parent = rootPart
    
    -- Movement loop
    connections[#connections + 1] = RunService.Heartbeat:Connect(function()
        if not flying or not bodyVelocity or not bodyGyro then return end
        
        local camera = workspace.CurrentCamera
        local moveVector = humanoid.MoveDirection
        
        if moveVector.Magnitude > 0 then
            local cameraDirection = camera.CFrame.LookVector
            local cameraRight = camera.CFrame.RightVector
            
            local moveDirection = (cameraDirection * moveVector.Z + cameraRight * moveVector.X).Unit
            bodyVelocity.Velocity = moveDirection * (speed * 16)
            bodyGyro.CFrame = CFrame.lookAt(rootPart.Position, rootPart.Position + moveDirection)
        else
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    end)
end

local function toggleFly()
    flying = not flying
    
    if flying then
        flyButton.Text = "STOP"
        flyButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
        startFly()
    else
        flyButton.Text = "FLY"
        flyButton.BackgroundColor3 = Color3.fromRGB(70, 255, 70)
        cleanupFly()
    end
    
    -- Animate button
    local tween = createTween(flyButton, {Size = UDim2.new(0.45, 0, 0.25, 0)}, 0.1)
    tween:Play()
    tween.Completed:Wait()
    local tween2 = createTween(flyButton, {Size = UDim2.new(0.4, 0, 0.25, 0)}, 0.1)
    tween2:Play()
end

local function moveUp()
    local character = player.Character
    if not character or not flying then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
    if rootPart and bodyVelocity then
        bodyVelocity.Velocity = bodyVelocity.Velocity + Vector3.new(0, speed * 16, 0)
    end
end

local function moveDown()
    local character = player.Character
    if not character or not flying then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
    if rootPart and bodyVelocity then
        bodyVelocity.Velocity = bodyVelocity.Velocity - Vector3.new(0, speed * 16, 0)
    end
end

-- Button Connections
flyButton.MouseButton1Click:Connect(toggleFly)

speedUpButton.MouseButton1Click:Connect(function()
    if speed < 10 then
        speed = speed + 1
        updateSpeedDisplay()
        
        -- Animate button
        local tween = createTween(speedUpButton, {BackgroundColor3 = Color3.fromRGB(100, 255, 100)}, 0.1)
        tween:Play()
        tween.Completed:Wait()
        createTween(speedUpButton, {BackgroundColor3 = Color3.fromRGB(150, 255, 150)}, 0.1):Play()
    end
end)

speedDownButton.MouseButton1Click:Connect(function()
    if speed > 1 then
        speed = speed - 1
        updateSpeedDisplay()
        
        -- Animate button
        local tween = createTween(speedDownButton, {BackgroundColor3 = Color3.fromRGB(255, 100, 100)}, 0.1)
        tween:Play()
        tween.Completed:Wait()
        createTween(speedDownButton, {BackgroundColor3 = Color3.fromRGB(255, 150, 150)}, 0.1):Play()
    end
end)

-- Up/Down button connections with hold functionality
local upConnection, downConnection

upButton.MouseButton1Down:Connect(function()
    upConnection = RunService.Heartbeat:Connect(moveUp)
end)

upButton.MouseButton1Up:Connect(function()
    if upConnection then
        upConnection:Disconnect()
        upConnection = nil
    end
end)

downButton.MouseButton1Down:Connect(function()
    downConnection = RunService.Heartbeat:Connect(moveDown)
end)

downButton.MouseButton1Up:Connect(function()
    if downConnection then
        downConnection:Disconnect()
        downConnection = nil
    end
end)

closeButton.MouseButton1Click:Connect(function()
    cleanupFly()
    screenGui:Destroy()
end)

-- Toggle GUI with G key
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.G then
        mainFrame.Visible = not mainFrame.Visible
        
        if mainFrame.Visible then
            -- Animate in
            mainFrame.Size = UDim2.new(0, 0, 0, 0)
            mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
            createTween(mainFrame, {
                Size = UDim2.new(0, 250, 0, 120),
                Position = UDim2.new(0.1, 0, 0.3, 0)
            }, 0.3):Play()
        end
    end
end)

-- Character respawn handling
player.CharacterAdded:Connect(function()
    wait(1)
    if flying then
        flying = false
        flyButton.Text = "FLY"
        flyButton.BackgroundColor3 = Color3.fromRGB(70, 255, 70)
    end
    cleanupFly()
end)

-- Notification
StarterGui:SetCore("SendNotification", {
    Title = "Fly GUI V4";
    Text = "Press 'G' to toggle GUI. Improved UI/UX!";
    Duration = 5;
})

print("Fly GUI V4 loaded successfully! Press 'G' to toggle GUI.")
