-- Perfect Optimized Fly Script with Premium UI | DevPhoria
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

local LocalPlayer = Players.LocalPlayer

-- Enhanced Variables
local isFlying = false
local flySpeed = 16
local maxSpeed = 200
local minSpeed = 4
local speedIncrement = 8
local acceleration = 0.85 -- Smooth acceleration
local deceleration = 0.92 -- Smooth deceleration
local bodyVelocity = nil
local bodyAngularVelocity = nil
local connection = nil
local gui = nil
local isGuiVisible = true
local currentVelocity = Vector3.new(0, 0, 0)
local targetVelocity = Vector3.new(0, 0, 0)
local isMoving = false
local lastMoveTime = 0

-- Advanced Movement Controls
local movement = {
    w = false, s = false,
    a = false, d = false,
    space = false, shift = false,
    -- New controls
    q = false, e = false -- Roll left/right
}

-- UI Animation Info
local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

-- Create Enhanced GUI with Modern Design
local function createPremiumGUI()
    -- Main ScreenGui with blur effect
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "PerfectFlyGUI"
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.DisplayOrder = 999
    
    -- Main Frame with gradient background
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Parent = screenGui
    mainFrame.Size = UDim2.new(0, 280, 0, 160)
    mainFrame.Position = UDim2.new(0, 50, 0, 50)
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.ClipsDescendants = true
    
    -- Gradient Background
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 35)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 25))
    }
    gradient.Rotation = 45
    gradient.Parent = mainFrame
    
    -- Modern Corner Rounding
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    -- Enhanced Glow Effect
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(100, 100, 255)
    stroke.Thickness = 2
    stroke.Transparency = 0.3
    stroke.Parent = mainFrame
    
    -- Animated Glow Effect
    local glowTween = TweenService:Create(stroke, 
        TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Transparency = 0.7}
    )
    glowTween:Play()
    
    -- Title with Icon
    local titleFrame = Instance.new("Frame")
    titleFrame.Name = "TitleFrame"
    titleFrame.Parent = mainFrame
    titleFrame.Size = UDim2.new(1, -70, 0, 30)
    titleFrame.Position = UDim2.new(0, 10, 0, 5)
    titleFrame.BackgroundTransparency = 1
    
    local titleIcon = Instance.new("TextLabel")
    titleIcon.Name = "TitleIcon"
    titleIcon.Parent = titleFrame
    titleIcon.Size = UDim2.new(0, 25, 0, 25)
    titleIcon.Position = UDim2.new(0, 0, 0, 2)
    titleIcon.BackgroundTransparency = 1
    titleIcon.Text = "✈"
    titleIcon.TextColor3 = Color3.fromRGB(100, 200, 255)
    titleIcon.TextScaled = true
    titleIcon.Font = Enum.Font.GothamBold
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Parent = titleFrame
    titleLabel.Size = UDim2.new(1, -30, 0, 25)
    titleLabel.Position = UDim2.new(0, 30, 0, 2)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "Perfect Fly | DevPhoria"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    
    -- Status Indicator
    local statusIndicator = Instance.new("Frame")
    statusIndicator.Name = "StatusIndicator"
    statusIndicator.Parent = mainFrame
    statusIndicator.Size = UDim2.new(0, 8, 0, 8)
    statusIndicator.Position = UDim2.new(1, -45, 0, 12)
    statusIndicator.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    statusIndicator.BorderSizePixel = 0
    
    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(1, 0)
    statusCorner.Parent = statusIndicator
    
    -- Minimize Button
    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Name = "MinimizeButton"
    minimizeButton.Parent = mainFrame
    minimizeButton.Size = UDim2.new(0, 25, 0, 25)
    minimizeButton.Position = UDim2.new(1, -60, 0, 5)
    minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
    minimizeButton.BorderSizePixel = 0
    minimizeButton.Text = "–"
    minimizeButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    minimizeButton.TextScaled = true
    minimizeButton.Font = Enum.Font.GothamBold
    
    local minimizeCorner = Instance.new("UICorner")
    minimizeCorner.CornerRadius = UDim.new(0, 6)
    minimizeCorner.Parent = minimizeButton
    
    -- Close Button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Parent = mainFrame
    closeButton.Size = UDim2.new(0, 25, 0, 25)
    closeButton.Position = UDim2.new(1, -30, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    closeButton.BorderSizePixel = 0
    closeButton.Text = "×"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.GothamBold
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeButton
    
    -- Main Controls Container
    local controlsFrame = Instance.new("Frame")
    controlsFrame.Name = "ControlsFrame"
    controlsFrame.Parent = mainFrame
    controlsFrame.Size = UDim2.new(1, -20, 1, -45)
    controlsFrame.Position = UDim2.new(0, 10, 0, 35)
    controlsFrame.BackgroundTransparency = 1
    
    -- Fly Toggle Button (Enhanced)
    local flyButton = Instance.new("TextButton")
    flyButton.Name = "FlyButton"
    flyButton.Parent = controlsFrame
    flyButton.Size = UDim2.new(0, 100, 0, 35)
    flyButton.Position = UDim2.new(0, 0, 0, 0)
    flyButton.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
    flyButton.BorderSizePixel = 0
    flyButton.Text = "🚀 START FLY"
    flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    flyButton.TextScaled = true
    flyButton.Font = Enum.Font.GothamBold
    
    local flyCorner = Instance.new("UICorner")
    flyCorner.CornerRadius = UDim.new(0, 8)
    flyCorner.Parent = flyButton
    
    -- Button Glow Effect
    local flyGlow = Instance.new("UIStroke")
    flyGlow.Color = Color3.fromRGB(50, 200, 100)
    flyGlow.Thickness = 0
    flyGlow.Transparency = 1
    flyGlow.Parent = flyButton
    
    -- Speed Container
    local speedContainer = Instance.new("Frame")
    speedContainer.Name = "SpeedContainer"
    speedContainer.Parent = controlsFrame
    speedContainer.Size = UDim2.new(1, -110, 0, 35)
    speedContainer.Position = UDim2.new(0, 105, 0, 0)
    speedContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    speedContainer.BorderSizePixel = 0
    
    local speedCorner = Instance.new("UICorner")
    speedCorner.CornerRadius = UDim.new(0, 8)
    speedCorner.Parent = speedContainer
    
    -- Speed Label
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Name = "SpeedLabel"
    speedLabel.Parent = speedContainer
    speedLabel.Size = UDim2.new(1, -60, 1, 0)
    speedLabel.Position = UDim2.new(0, 30, 0, 0)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "⚡ " .. flySpeed
    speedLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
    speedLabel.TextScaled = true
    speedLabel.Font = Enum.Font.GothamBold
    
    -- Speed Down Button
    local speedDownButton = Instance.new("TextButton")
    speedDownButton.Name = "SpeedDownButton"
    speedDownButton.Parent = speedContainer
    speedDownButton.Size = UDim2.new(0, 25, 0, 25)
    speedDownButton.Position = UDim2.new(0, 5, 0, 5)
    speedDownButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    speedDownButton.BorderSizePixel = 0
    speedDownButton.Text = "–"
    speedDownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedDownButton.TextScaled = true
    speedDownButton.Font = Enum.Font.GothamBold
    
    local speedDownCorner = Instance.new("UICorner")
    speedDownCorner.CornerRadius = UDim.new(0, 4)
    speedDownCorner.Parent = speedDownButton
    
    -- Speed Up Button
    local speedUpButton = Instance.new("TextButton")
    speedUpButton.Name = "SpeedUpButton"
    speedUpButton.Parent = speedContainer
    speedUpButton.Size = UDim2.new(0, 25, 0, 25)
    speedUpButton.Position = UDim2.new(1, -30, 0, 5)
    speedUpButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
    speedUpButton.BorderSizePixel = 0
    speedUpButton.Text = "+"
    speedUpButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    speedUpButton.TextScaled = true
    speedUpButton.Font = Enum.Font.GothamBold
    
    local speedUpCorner = Instance.new("UICorner")
    speedUpCorner.CornerRadius = UDim.new(0, 4)
    speedUpCorner.Parent = speedUpButton
    
    -- Info Panel
    local infoPanel = Instance.new("Frame")
    infoPanel.Name = "InfoPanel"
    infoPanel.Parent = controlsFrame
    infoPanel.Size = UDim2.new(1, 0, 0, 35)
    infoPanel.Position = UDim2.new(0, 0, 0, 40)
    infoPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    infoPanel.BorderSizePixel = 0
    
    local infoPanelCorner = Instance.new("UICorner")
    infoPanelCorner.CornerRadius = UDim.new(0, 8)
    infoPanelCorner.Parent = infoPanel
    
    -- Velocity Display
    local velocityLabel = Instance.new("TextLabel")
    velocityLabel.Name = "VelocityLabel"
    velocityLabel.Parent = infoPanel
    velocityLabel.Size = UDim2.new(0.5, -5, 1, 0)
    velocityLabel.Position = UDim2.new(0, 5, 0, 0)
    velocityLabel.BackgroundTransparency = 1
    velocityLabel.Text = "📊 Velocity: 0.0"
    velocityLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
    velocityLabel.TextScaled = true
    velocityLabel.Font = Enum.Font.Gotham
    
    -- Altitude Display
    local altitudeLabel = Instance.new("TextLabel")
    altitudeLabel.Name = "AltitudeLabel"
    altitudeLabel.Parent = infoPanel
    altitudeLabel.Size = UDim2.new(0.5, -5, 1, 0)
    altitudeLabel.Position = UDim2.new(0.5, 0, 0, 0)
    altitudeLabel.BackgroundTransparency = 1
    altitudeLabel.Text = "🏔 Alt: 0"
    altitudeLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    altitudeLabel.TextScaled = true
    altitudeLabel.Font = Enum.Font.Gotham
    
    -- Instructions with better formatting
    local instructionsLabel = Instance.new("TextLabel")
    instructionsLabel.Name = "InstructionsLabel"
    instructionsLabel.Parent = controlsFrame
    instructionsLabel.Size = UDim2.new(1, 0, 0, 40)
    instructionsLabel.Position = UDim2.new(0, 0, 0, 80)
    instructionsLabel.BackgroundTransparency = 1
    instructionsLabel.Text = "🎮 WASD + Space/Shift + Q/E (Roll)\n⌨️ G: Toggle GUI | F: Boost Mode"
    instructionsLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
    instructionsLabel.TextSize = 11
    instructionsLabel.Font = Enum.Font.Gotham
    
    return screenGui, mainFrame, flyButton, speedLabel, speedUpButton, speedDownButton, 
           closeButton, minimizeButton, statusIndicator, velocityLabel, altitudeLabel, flyGlow
end

-- Enhanced Flying Physics
local function startPerfectFlying()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return false
    end
    
    local character = LocalPlayer.Character
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character.HumanoidRootPart
    
    -- Enhanced BodyVelocity with better physics
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = rootPart
    
    -- Enhanced BodyAngularVelocity for smooth rotation
    bodyAngularVelocity = Instance.new("BodyAngularVelocity")
    bodyAngularVelocity.MaxTorque = Vector3.new(4000, 4000, 4000)
    bodyAngularVelocity.AngularVelocity = Vector3.new(0, 0, 0)
    bodyAngularVelocity.Parent = rootPart
    
    -- Optimize humanoid states
    humanoid.PlatformStand = true
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    
    isFlying = true
    currentVelocity = Vector3.new(0, 0, 0)
    
    -- Perfect flying physics loop
    connection = RunService.Heartbeat:Connect(function(deltaTime)
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or not bodyVelocity then
            return
        end
        
        local camera = workspace.CurrentCamera
        local rootPart = LocalPlayer.Character.HumanoidRootPart
        local currentTime = tick()
        
        targetVelocity = Vector3.new(0, 0, 0)
        local isCurrentlyMoving = false
        
        -- Calculate movement direction with smooth controls
        if movement.w then
            targetVelocity = targetVelocity + camera.CoordinateFrame.LookVector
            isCurrentlyMoving = true
        end
        if movement.s then
            targetVelocity = targetVelocity - camera.CoordinateFrame.LookVector
            isCurrentlyMoving = true
        end
        if movement.a then
            targetVelocity = targetVelocity - camera.CoordinateFrame.RightVector
            isCurrentlyMoving = true
        end
        if movement.d then
            targetVelocity = targetVelocity + camera.CoordinateFrame.RightVector
            isCurrentlyMoving = true
        end
        if movement.space then
            targetVelocity = targetVelocity + Vector3.new(0, 1, 0)
            isCurrentlyMoving = true
        end
        if movement.shift then
            targetVelocity = targetVelocity - Vector3.new(0, 1, 0)
            isCurrentlyMoving = true
        end
        
        -- Roll controls
        local rollVelocity = Vector3.new(0, 0, 0)
        if movement.q then
            rollVelocity = rollVelocity + Vector3.new(0, 0, -2)
        end
        if movement.e then
            rollVelocity = rollVelocity + Vector3.new(0, 0, 2)
        end
        
        bodyAngularVelocity.AngularVelocity = rollVelocity
        
        -- Normalize and apply speed
        if targetVelocity.Magnitude > 0 then
            targetVelocity = targetVelocity.Unit * flySpeed
            lastMoveTime = currentTime
        end
        
        -- Smooth acceleration/deceleration
        if isCurrentlyMoving then
            currentVelocity = currentVelocity:lerp(targetVelocity, acceleration * deltaTime * 60)
        else
            currentVelocity = currentVelocity:lerp(Vector3.new(0, 0, 0), deceleration * deltaTime * 60)
        end
        
        -- Apply final velocity
        bodyVelocity.Velocity = currentVelocity
        
        -- Update UI displays
        if velocityLabel then
            local speed = math.floor(currentVelocity.Magnitude * 10) / 10
            velocityLabel.Text = "📊 Velocity: " .. speed
        end
        
        if altitudeLabel then
            local altitude = math.floor(rootPart.Position.Y)
            altitudeLabel.Text = "🏔 Alt: " .. altitude
        end
    end)
    
    return true
end

local function stopPerfectFlying()
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
    
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
        end
    end
    
    isFlying = false
    currentVelocity = Vector3.new(0, 0, 0)
    
    -- Reset all movement
    for key, _ in pairs(movement) do
        movement[key] = false
    end
end

-- Create Premium GUI
local screenGui, mainFrame, flyButton, speedLabel, speedUpButton, speedDownButton, 
      closeButton, minimizeButton, statusIndicator, velocityLabel, altitudeLabel, flyGlow = createPremiumGUI()
gui = screenGui

-- Enhanced Button Effects
local function createButtonEffect(button, originalColor, hoverColor)
    button.MouseEnter:Connect(function()
        local hoverTween = TweenService:Create(button, tweenInfo, {BackgroundColor3 = hoverColor})
        hoverTween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local leaveTween = TweenService:Create(button, tweenInfo, {BackgroundColor3 = originalColor})
        leaveTween:Play()
    end)
end

-- Apply button effects
createButtonEffect(flyButton, Color3.fromRGB(50, 200, 100), Color3.fromRGB(70, 220, 120))
createButtonEffect(speedUpButton, Color3.fromRGB(100, 255, 100), Color3.fromRGB(120, 255, 120))
createButtonEffect(speedDownButton, Color3.fromRGB(255, 100, 100), Color3.fromRGB(255, 120, 120))
createButtonEffect(closeButton, Color3.fromRGB(255, 60, 60), Color3.fromRGB(255, 80, 80))
createButtonEffect(minimizeButton, Color3.fromRGB(255, 200, 50), Color3.fromRGB(255, 220, 70))

-- Enhanced GUI Event Handlers
flyButton.MouseButton1Click:Connect(function()
    if isFlying then
        stopPerfectFlying()
        flyButton.Text = "🚀 START FLY"
        flyButton.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
        statusIndicator.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        
        -- Remove glow effect
        local glowTween = TweenService:Create(flyGlow, tweenInfo, {Thickness = 0, Transparency = 1})
        glowTween:Play()
    else
        if startPerfectFlying() then
            flyButton.Text = "🛑 STOP FLY"
            flyButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
            statusIndicator.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
            
            -- Add glow effect
            local glowTween = TweenService:Create(flyGlow, tweenInfo, {Thickness = 3, Transparency = 0.5})
            glowTween:Play()
        end
    end
end)

speedUpButton.MouseButton1Click:Connect(function()
    flySpeed = math.min(flySpeed + speedIncrement, maxSpeed)
    speedLabel.Text = "⚡ " .. flySpeed
    
    -- Speed boost effect
    local speedBoost = TweenService:Create(speedLabel, TweenInfo.new(0.1, Enum.EasingStyle.Back), 
        {TextColor3 = Color3.fromRGB(255, 255, 100)})
    speedBoost:Play()
    speedBoost.Completed:Connect(function()
        local resetColor = TweenService:Create(speedLabel, tweenInfo, {TextColor3 = Color3.fromRGB(100, 200, 255)})
        resetColor:Play()
    end)
end)

speedDownButton.MouseButton1Click:Connect(function()
    flySpeed = math.max(flySpeed - speedIncrement, minSpeed)
    speedLabel.Text = "⚡ " .. flySpeed
    
    -- Speed reduction effect
    local speedReduce = TweenService:Create(speedLabel, TweenInfo.new(0.1, Enum.EasingStyle.Back), 
        {TextColor3 = Color3.fromRGB(255, 100, 100)})
    speedReduce:Play()
    speedReduce.Completed:Connect(function()
        local resetColor = TweenService:Create(speedLabel, tweenInfo, {TextColor3 = Color3.fromRGB(100, 200, 255)})
        resetColor:Play()
    end)
end)

-- Minimize/Maximize functionality
local isMinimized = false
minimizeButton.MouseButton1Click:Connect(function()
    if isMinimized then
        -- Expand
        local expandTween = TweenService:Create(mainFrame, tweenInfo, {Size = UDim2.new(0, 280, 0, 160)})
        expandTween:Play()
        minimizeButton.Text = "–"
        isMinimized = false
    else
        -- Minimize
        local minimizeTween = TweenService:Create(mainFrame, tweenInfo, {Size = UDim2.new(0, 280, 0, 35)})
        minimizeTween:Play()
        minimizeButton.Text = "+"
        isMinimized = true
    end
end)

closeButton.MouseButton1Click:Connect(function()
    -- Smooth close animation
    local closeTween = TweenService:Create(mainFrame, tweenInfo, {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0, 165, 0, 130)
    })
    closeTween:Play()
    closeTween.Completed:Connect(function()
        stopPerfectFlying()
        gui:Destroy()
    end)
end)

-- Enhanced Input Handling
local boostMode = false

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    local key = input.KeyCode
    
    -- Toggle GUI with G key
    if key == Enum.KeyCode.G then
        isGuiVisible = not isGuiVisible
        if isGuiVisible then
            local showTween = TweenService:Create(mainFrame, tweenInfo, {
                Position = UDim2.new(0, 50, 0, 50),
                Size = isMinimized and UDim2.new(0, 280, 0, 35) or UDim2.new(0, 280, 0, 160)
            })
            showTween:Play()
        else
            local hideTween = TweenService:Create(mainFrame, tweenInfo, {
                Position = UDim2.new(0, -300, 0, 50),
                Size = isMinimized and UDim2.new(0, 280, 0, 35) or UDim2.new(0, 280, 0, 160)
            })
            hideTween:Play()
        end
        return
    end
    
    -- Boost mode toggle with F key
    if key == Enum.KeyCode.F and isFlying then
        boostMode = not boostMode
        if boostMode then
            flySpeed = math.min(flySpeed * 2, maxSpeed)
            speedLabel.Text = "⚡ " .. flySpeed .. " 🔥"
        else
            flySpeed = math.max(flySpeed / 2, minSpeed)
            speedLabel.Text = "⚡ " .. flySpeed
        end
        return
    end
    
    -- Movement keys
    if key == Enum.KeyCode.W then
        movement.w = true
    elseif key == Enum.KeyCode.S then
        movement.s = true
    elseif key == Enum.KeyCode.A then
        movement.a = true
    elseif key == Enum.KeyCode.D then
        movement.d = true
    elseif key == Enum.KeyCode.Space then
        movement.space = true
    elseif key == Enum.KeyCode.LeftShift then
        movement.shift = true
    elseif key == Enum.KeyCode.Q then
        movement.q = true
    elseif key == Enum.KeyCode.E then
        movement.e = true
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    local key = input.KeyCode
    
    if key == Enum.KeyCode.W then
        movement.w = false
    elseif key == Enum.KeyCode.S then
        movement.s = false
    elseif key == Enum.KeyCode.A then
        movement.a = false
    elseif key == Enum.KeyCode.D then
        movement.d = false
    elseif key == Enum.KeyCode.Space then
        movement.space = false
    elseif key == Enum.KeyCode.LeftShift then
        movement.shift = false
    elseif key == Enum.KeyCode.Q then
        movement.q = false
    elseif key == Enum.KeyCode.E then
        movement.e = false
    end
end)

-- Auto-stop flying on character respawn
LocalPlayer.CharacterAdded:Connect(function()
    wait(1)
    if isFlying then
        stopPerfectFlying()
        flyButton.Text = "🚀 START FLY"
        flyButton.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
        statusIndicator.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        
        -- Reset glow effect
        local glowTween = TweenService:Create(flyGlow, tweenInfo, {Thickness = 0, Transparency = 1})
        glowTween:Play()
    end
end)

-- Smooth GUI entrance animation
local function playEntranceAnimation()
    mainFrame.Position = UDim2.new(0, -300, 0, 50)
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    
    local entranceTween = TweenService:Create(mainFrame, 
        TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {
            Position = UDim2.new(0, 50, 0, 50),
            Size = UDim2.new(0, 280, 0, 160)
        }
    )
    entranceTween:Play()
end

-- Performance optimization for mobile devices
local function optimizePerformance()
    if UserInputService.TouchEnabled then
        -- Reduce update frequency on mobile
        acceleration = 0.7
        deceleration = 0.85
        speedIncrement = 4
    end
end

-- Initialize optimizations
optimizePerformance()

-- Advanced keybind system
local keybinds = {
    toggleGui = Enum.KeyCode.G,
    boostMode = Enum.KeyCode.F,
    quickStop = Enum.KeyCode.X,
    resetPosition = Enum.KeyCode.R
}

-- Quick stop functionality
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or not isFlying then return end
    
    if input.KeyCode == keybinds.quickStop then
        currentVelocity = Vector3.new(0, 0, 0)
        if bodyVelocity then
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    elseif input.KeyCode == keybinds.resetPosition then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
        end
    end
end)

-- Enhanced notification system
local function showNotification(title, text, duration, color)
    StarterGui:SetCore("SendNotification", {
        Title = title;
        Text = text;
        Duration = duration or 5;
        Button1 = "OK";
    })
end

-- Play entrance animation
playEntranceAnimation()

-- Welcome notification with enhanced styling
showNotification(
    "✈️ Perfect Fly Script Loaded | DevPhoria",
    "🎮 G: Toggle GUI | F: Boost Mode | X: Quick Stop\n🚀 Enhanced physics & premium UI loaded!",
    8
)

-- Performance monitoring
local lastFPS = 0
local fpsConnection = RunService.Heartbeat:Connect(function()
    lastFPS = math.floor(1 / RunService.Heartbeat:Wait())
    
    -- Auto-optimize if low FPS detected
    if lastFPS < 30 and isFlying then
        acceleration = math.max(acceleration - 0.01, 0.5)
        deceleration = math.max(deceleration - 0.01, 0.7)
    end
end)

-- Auto-save settings (using game variables since no localStorage)
local savedSettings = {
    flySpeed = flySpeed,
    lastPosition = mainFrame.Position
}

-- Cleanup function
local function cleanup()
    if connection then connection:Disconnect() end
    if fpsConnection then fpsConnection:Disconnect() end
    stopPerfectFlying()
end

-- Auto-cleanup on script reload
game.Players.PlayerRemoving:Connect(cleanup)

print("🚀 Perfect Fly Script v2.0 Loaded Successfully!")
print("📋 Commands: G (GUI), F (Boost), X (Stop), R (Reset)")
print("⚡ Enhanced Physics & Premium UI Active!")
print("🎯 DevPhoria - Perfect Flight Experience!")
