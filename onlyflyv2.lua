-- Modern Fly GUI V4
-- Created by: DevPhoria
-- Enhanced version with modern design and cross-platform support

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Check if GUI already exists
if playerGui:FindFirstChild("ModernFlyGUI") then
    playerGui.ModernFlyGUI:Destroy()
end

-- Variables
local flyEnabled = false
local flySpeed = 50
local connection = nil
local bodyVelocity = nil
local bodyAngularVelocity = nil

-- Create main GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ModernFlyGUI"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main container with modern design
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainContainer"
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Position = UDim2.new(0.02, 0, 0.4, 0)
mainFrame.Size = UDim2.new(0, 280, 0, 160)
mainFrame.Active = true
mainFrame.Draggable = true

-- Add corner rounding
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Add subtle gradient
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 35))
}
gradient.Rotation = 45
gradient.Parent = mainFrame

-- Header
local header = Instance.new("Frame")
header.Name = "Header"
header.Parent = mainFrame
header.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
header.BorderSizePixel = 0
header.Size = UDim2.new(1, 0, 0, 40)

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

-- Fix corner on bottom
local headerBottom = Instance.new("Frame")
headerBottom.Parent = header
headerBottom.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
headerBottom.BorderSizePixel = 0
headerBottom.Position = UDim2.new(0, 0, 0.5, 0)
headerBottom.Size = UDim2.new(1, 0, 0.5, 0)

-- Title
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Parent = header
titleLabel.BackgroundTransparency = 1
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.Size = UDim2.new(0, 180, 1, 0)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "Modern Fly GUI V4"
titleLabel.TextColor3 = Color3.fromRGB(120, 180, 255)
titleLabel.TextSize = 16
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Minimize button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Name = "MinimizeButton"
minimizeBtn.Parent = header
minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Position = UDim2.new(1, -70, 0.5, -10)
minimizeBtn.Size = UDim2.new(0, 20, 0, 20)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.Text = "−"
minimizeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
minimizeBtn.TextSize = 14

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 10)
minimizeCorner.Parent = minimizeBtn

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseButton"
closeBtn.Parent = header
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.BorderSizePixel = 0
closeBtn.Position = UDim2.new(1, -40, 0.5, -10)
closeBtn.Size = UDim2.new(0, 20, 0, 20)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 12

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 10)
closeCorner.Parent = closeBtn

-- Content area
local contentFrame = Instance.new("Frame")
contentFrame.Name = "Content"
contentFrame.Parent = mainFrame
contentFrame.BackgroundTransparency = 1
contentFrame.Position = UDim2.new(0, 0, 0, 40)
contentFrame.Size = UDim2.new(1, 0, 1, -40)

-- Fly toggle button
local flyToggle = Instance.new("TextButton")
flyToggle.Name = "FlyToggle"
flyToggle.Parent = contentFrame
flyToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
flyToggle.BorderSizePixel = 0
flyToggle.Position = UDim2.new(0, 20, 0, 20)
flyToggle.Size = UDim2.new(0, 120, 0, 35)
flyToggle.Font = Enum.Font.GothamSemibold
flyToggle.Text = "Enable Fly"
flyToggle.TextColor3 = Color3.fromRGB(200, 200, 200)
flyToggle.TextSize = 14

local flyToggleCorner = Instance.new("UICorner")
flyToggleCorner.CornerRadius = UDim.new(0, 8)
flyToggleCorner.Parent = flyToggle

-- Speed controls container
local speedContainer = Instance.new("Frame")
speedContainer.Name = "SpeedContainer"
speedContainer.Parent = contentFrame
speedContainer.BackgroundTransparency = 1
speedContainer.Position = UDim2.new(0, 20, 0, 70)
speedContainer.Size = UDim2.new(1, -40, 0, 35)

-- Speed label
local speedLabel = Instance.new("TextLabel")
speedLabel.Name = "SpeedLabel"
speedLabel.Parent = speedContainer
speedLabel.BackgroundTransparency = 1
speedLabel.Size = UDim2.new(0, 60, 1, 0)
speedLabel.Font = Enum.Font.Gotham
speedLabel.Text = "Speed:"
speedLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
speedLabel.TextSize = 12
speedLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Speed decrease button
local speedDown = Instance.new("TextButton")
speedDown.Name = "SpeedDown"
speedDown.Parent = speedContainer
speedDown.BackgroundColor3 = Color3.fromRGB(70, 50, 50)
speedDown.BorderSizePixel = 0
speedDown.Position = UDim2.new(0, 70, 0, 0)
speedDown.Size = UDim2.new(0, 30, 1, 0)
speedDown.Font = Enum.Font.GothamBold
speedDown.Text = "−"
speedDown.TextColor3 = Color3.fromRGB(255, 150, 150)
speedDown.TextSize = 16

local speedDownCorner = Instance.new("UICorner")
speedDownCorner.CornerRadius = UDim.new(0, 6)
speedDownCorner.Parent = speedDown

-- Speed display
local speedDisplay = Instance.new("TextLabel")
speedDisplay.Name = "SpeedDisplay"
speedDisplay.Parent = speedContainer
speedDisplay.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
speedDisplay.BorderSizePixel = 0
speedDisplay.Position = UDim2.new(0, 110, 0, 0)
speedDisplay.Size = UDim2.new(0, 50, 1, 0)
speedDisplay.Font = Enum.Font.GothamSemibold
speedDisplay.Text = tostring(flySpeed)
speedDisplay.TextColor3 = Color3.fromRGB(120, 180, 255)
speedDisplay.TextSize = 14

local speedDisplayCorner = Instance.new("UICorner")
speedDisplayCorner.CornerRadius = UDim.new(0, 6)
speedDisplayCorner.Parent = speedDisplay

-- Speed increase button
local speedUp = Instance.new("TextButton")
speedUp.Name = "SpeedUp"
speedUp.Parent = speedContainer
speedUp.BackgroundColor3 = Color3.fromRGB(50, 70, 50)
speedUp.BorderSizePixel = 0
speedUp.Position = UDim2.new(0, 170, 0, 0)
speedUp.Size = UDim2.new(0, 30, 1, 0)
speedUp.Font = Enum.Font.GothamBold
speedUp.Text = "+"
speedUp.TextColor3 = Color3.fromRGB(150, 255, 150)
speedUp.TextSize = 16

local speedUpCorner = Instance.new("UICorner")
speedUpCorner.CornerRadius = UDim.new(0, 6)
speedUpCorner.Parent = speedUp

-- Creator credit
local creditLabel = Instance.new("TextLabel")
creditLabel.Name = "Credit"
creditLabel.Parent = mainFrame
creditLabel.BackgroundTransparency = 1
creditLabel.Position = UDim2.new(0, 0, 1, -20)
creditLabel.Size = UDim2.new(1, 0, 0, 20)
creditLabel.Font = Enum.Font.Gotham
creditLabel.Text = "Created by DevPhoria"
creditLabel.TextColor3 = Color3.fromRGB(100, 100, 120)
creditLabel.TextSize = 10
creditLabel.TextXAlignment = Enum.TextXAlignment.Center

-- Minimized state frame
local minimizedFrame = Instance.new("Frame")
minimizedFrame.Name = "MinimizedFrame"
minimizedFrame.Parent = screenGui
minimizedFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
minimizedFrame.BorderSizePixel = 0
minimizedFrame.Position = UDim2.new(0.02, 0, 0.4, 0)
minimizedFrame.Size = UDim2.new(0, 180, 0, 40)
minimizedFrame.Visible = false
minimizedFrame.Active = true
minimizedFrame.Draggable = true

local minimizedCorner = Instance.new("UICorner")
minimizedCorner.CornerRadius = UDim.new(0, 8)
minimizedCorner.Parent = minimizedFrame

local minimizedTitle = Instance.new("TextLabel")
minimizedTitle.Parent = minimizedFrame
minimizedTitle.BackgroundTransparency = 1
minimizedTitle.Position = UDim2.new(0, 10, 0, 0)
minimizedTitle.Size = UDim2.new(0, 120, 1, 0)
minimizedTitle.Font = Enum.Font.GothamBold
minimizedTitle.Text = "Fly GUI - DevPhoria"
minimizedTitle.TextColor3 = Color3.fromRGB(120, 180, 255)
minimizedTitle.TextSize = 12
minimizedTitle.TextXAlignment = Enum.TextXAlignment.Left

local restoreBtn = Instance.new("TextButton")
restoreBtn.Parent = minimizedFrame
restoreBtn.BackgroundColor3 = Color3.fromRGB(100, 180, 100)
restoreBtn.BorderSizePixel = 0
restoreBtn.Position = UDim2.new(1, -35, 0.5, -10)
restoreBtn.Size = UDim2.new(0, 20, 0, 20)
restoreBtn.Font = Enum.Font.GothamBold
restoreBtn.Text = "+"
restoreBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
restoreBtn.TextSize = 14

local restoreCorner = Instance.new("UICorner")
restoreCorner.CornerRadius = UDim.new(0, 10)
restoreCorner.Parent = restoreBtn

-- Utility functions
local function createTween(object, properties, duration)
    local tweenInfo = TweenInfo.new(duration or 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    return TweenService:Create(object, tweenInfo, properties)
end

local function updateSpeedDisplay()
    speedDisplay.Text = tostring(flySpeed)
end

-- Fly functionality
local function enableFly()
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return end
    
    -- Create BodyVelocity for movement
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = rootPart
    
    -- Create BodyAngularVelocity for rotation
    bodyAngularVelocity = Instance.new("BodyAngularVelocity")
    bodyAngularVelocity.MaxTorque = Vector3.new(0, math.huge, 0)
    bodyAngularVelocity.AngularVelocity = Vector3.new(0, 0, 0)
    bodyAngularVelocity.Parent = rootPart
    
    -- Movement connection
    connection = RunService.Heartbeat:Connect(function()
        if not character or not character.Parent then
            disableFly()
            return
        end
        
        local camera = workspace.CurrentCamera
        local moveVector = humanoid.MoveDirection
        local lookVector = camera.CFrame.LookVector
        local rightVector = camera.CFrame.RightVector
        
        local velocity = Vector3.new(0, 0, 0)
        
        if moveVector.Magnitude > 0 then
            velocity = (lookVector * moveVector.Z + rightVector * moveVector.X) * flySpeed
        end
        
        -- Handle up/down movement
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            velocity = velocity + Vector3.new(0, flySpeed, 0)
        elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            velocity = velocity + Vector3.new(0, -flySpeed, 0)
        end
        
        bodyVelocity.Velocity = velocity
    end)
    
    flyEnabled = true
    flyToggle.Text = "Disable Fly"
    createTween(flyToggle, {BackgroundColor3 = Color3.fromRGB(70, 100, 70)}):Play()
end

local function disableFly()
    if connection then
        connection:Disconnect()
        connection = nil
    end
    
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    
    if bodyAngularVelocity then
        bodyAngularVelocity:Destroy()
        bodyAngularVelocity = nil
    end
    
    flyEnabled = false
    flyToggle.Text = "Enable Fly"
    createTween(flyToggle, {BackgroundColor3 = Color3.fromRGB(50, 50, 70)}):Play()
end

-- Button connections
flyToggle.MouseButton1Click:Connect(function()
    if flyEnabled then
        disableFly()
    else
        enableFly()
    end
    
    -- Button animation
    createTween(flyToggle, {Size = UDim2.new(0, 115, 0, 32)}):Play()
    wait(0.1)
    createTween(flyToggle, {Size = UDim2.new(0, 120, 0, 35)}):Play()
end)

speedUp.MouseButton1Click:Connect(function()
    if flySpeed < 200 then
        flySpeed = flySpeed + 10
        updateSpeedDisplay()
        
        -- Button animation
        createTween(speedUp, {BackgroundColor3 = Color3.fromRGB(80, 120, 80)}):Play()
        wait(0.1)
        createTween(speedUp, {BackgroundColor3 = Color3.fromRGB(50, 70, 50)}):Play()
    end
end)

speedDown.MouseButton1Click:Connect(function()
    if flySpeed > 10 then
        flySpeed = flySpeed - 10
        updateSpeedDisplay()
        
        -- Button animation
        createTween(speedDown, {BackgroundColor3 = Color3.fromRGB(100, 70, 70)}):Play()
        wait(0.1)
        createTween(speedDown, {BackgroundColor3 = Color3.fromRGB(70, 50, 50)}):Play()
    end
end)

minimizeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    minimizedFrame.Visible = true
end)

restoreBtn.MouseButton1Click:Connect(function()
    minimizedFrame.Visible = false
    mainFrame.Visible = true
end)

closeBtn.MouseButton1Click:Connect(function()
    disableFly()
    screenGui:Destroy()
end)

-- Auto-disable fly when character respawns
player.CharacterAdded:Connect(function()
    wait(1)
    if flyEnabled then
        disableFly()
    end
end)

-- Welcome notification
StarterGui:SetCore("SendNotification", {
    Title = "Modern Fly GUI V4";
    Text = "Created by DevPhoria - Press SPACE/SHIFT for up/down movement";
    Duration = 5;
})

-- Mobile support - touch controls
if UserInputService.TouchEnabled then
    -- Adjust GUI size for mobile
    mainFrame.Size = UDim2.new(0, 300, 0, 180)
    
    -- Create touch controls for up/down movement
    local mobileControls = Instance.new("Frame")
    mobileControls.Name = "MobileControls"
    mobileControls.Parent = screenGui
    mobileControls.BackgroundTransparency = 1
    mobileControls.Position = UDim2.new(1, -120, 0.5, -50)
    mobileControls.Size = UDim2.new(0, 100, 0, 100)
    
    local upBtn = Instance.new("TextButton")
    upBtn.Parent = mobileControls
    upBtn.BackgroundColor3 = Color3.fromRGB(100, 180, 100)
    upBtn.BorderSizePixel = 0
    upBtn.Size = UDim2.new(1, 0, 0, 45)
    upBtn.Font = Enum.Font.GothamBold
    upBtn.Text = "UP"
    upBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    upBtn.TextSize = 16
    
    local upCorner = Instance.new("UICorner")
    upCorner.CornerRadius = UDim.new(0, 8)
    upCorner.Parent = upBtn
    
    local downBtn = Instance.new("TextButton")
    downBtn.Parent = mobileControls
    downBtn.BackgroundColor3 = Color3.fromRGB(180, 100, 100)
    downBtn.BorderSizePixel = 0
    downBtn.Position = UDim2.new(0, 0, 0, 55)
    downBtn.Size = UDim2.new(1, 0, 0, 45)
    downBtn.Font = Enum.Font.GothamBold
    downBtn.Text = "DOWN"
    downBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    downBtn.TextSize = 16
    
    local downCorner = Instance.new("UICorner")
    downCorner.CornerRadius = UDim.new(0, 8)
    downCorner.Parent = downBtn
    
    -- Mobile up/down functionality
    local mobileUpPressed = false
    local mobileDownPressed = false
    
    upBtn.MouseButton1Down:Connect(function()
        mobileUpPressed = true
    end)
    
    upBtn.MouseButton1Up:Connect(function()
        mobileUpPressed = false
    end)
    
    downBtn.MouseButton1Down:Connect(function()
        mobileDownPressed = true
    end)
    
    downBtn.MouseButton1Up:Connect(function()
        mobileDownPressed = false
    end)
    
    -- Update fly function for mobile
    if connection then connection:Disconnect() end
    connection = RunService.Heartbeat:Connect(function()
        if not flyEnabled then return end
        
        local character = player.Character
        if not character or not character.Parent then
            disableFly()
            return
        end
        
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local camera = workspace.CurrentCamera
        
        if not humanoid or not bodyVelocity then return end
        
        local moveVector = humanoid.MoveDirection
        local lookVector = camera.CFrame.LookVector
        local rightVector = camera.CFrame.RightVector
        
        local velocity = Vector3.new(0, 0, 0)
        
        if moveVector.Magnitude > 0 then
            velocity = (lookVector * moveVector.Z + rightVector * moveVector.X) * flySpeed
        end
        
        -- Handle up/down movement (keyboard or mobile)
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) or mobileUpPressed then
            velocity = velocity + Vector3.new(0, flySpeed, 0)
        elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or mobileDownPressed then
            velocity = velocity + Vector3.new(0, -flySpeed, 0)
        end
        
        bodyVelocity.Velocity = velocity
    end)
    
    -- Show mobile controls only when flying
    mobileControls.Visible = false
    flyToggle.MouseButton1Click:Connect(function()
        wait(0.1)
        mobileControls.Visible = flyEnabled
    end)
end
