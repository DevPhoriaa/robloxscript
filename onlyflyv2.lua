-- Optimized Fly Script with Clean UI
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer

-- Variables
local isFlying = false
local flySpeed = 16
local bodyVelocity = nil
local bodyAngularVelocity = nil
local connection = nil
local gui = nil
local isGuiVisible = true

-- Movement controls
local movement = {
    w = false, s = false,
    a = false, d = false,
    space = false, shift = false
}

-- Create GUI
local function createGUI()
    -- Main ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FlyGUI"
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Parent = screenGui
    mainFrame.Size = UDim2.new(0, 220, 0, 80)
    mainFrame.Position = UDim2.new(0, 50, 0, 50)
    mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    
    -- Add corner rounding
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame
    
    -- Add stroke
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(70, 70, 70)
    stroke.Thickness = 1
    stroke.Parent = mainFrame
    
    -- Title Label
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Parent = mainFrame
    titleLabel.Size = UDim2.new(1, -60, 0, 25)
    titleLabel.Position = UDim2.new(0, 10, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "Fly Script | DevPhoria"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    
    -- Close Button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Parent = mainFrame
    closeButton.Size = UDim2.new(0, 25, 0, 25)
    closeButton.Position = UDim2.new(1, -30, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    closeButton.BorderSizePixel = 0
    closeButton.Text = "×"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.GothamBold
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 4)
    closeCorner.Parent = closeButton
    
    -- Fly Toggle Button
    local flyButton = Instance.new("TextButton")
    flyButton.Name = "FlyButton"
    flyButton.Parent = mainFrame
    flyButton.Size = UDim2.new(0, 80, 0, 25)
    flyButton.Position = UDim2.new(0, 10, 0, 35)
    flyButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    flyButton.BorderSizePixel = 0
    flyButton.Text = "START FLY"
    flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    flyButton.TextScaled = true
    flyButton.Font = Enum.Font.Gotham
    
    local flyCorner = Instance.new("UICorner")
    flyCorner.CornerRadius = UDim.new(0, 4)
    flyCorner.Parent = flyButton
    
    -- Speed Label
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Name = "SpeedLabel"
    speedLabel.Parent = mainFrame
    speedLabel.Size = UDim2.new(0, 50, 0, 25)
    speedLabel.Position = UDim2.new(0, 95, 0, 35)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "Speed: " .. flySpeed
    speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedLabel.TextScaled = true
    speedLabel.Font = Enum.Font.Gotham
    
    -- Speed Up Button
    local speedUpButton = Instance.new("TextButton")
    speedUpButton.Name = "SpeedUpButton"
    speedUpButton.Parent = mainFrame
    speedUpButton.Size = UDim2.new(0, 25, 0, 25)
    speedUpButton.Position = UDim2.new(0, 150, 0, 35)
    speedUpButton.BackgroundColor3 = Color3.fromRGB(70, 70, 200)
    speedUpButton.BorderSizePixel = 0
    speedUpButton.Text = "+"
    speedUpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedUpButton.TextScaled = true
    speedUpButton.Font = Enum.Font.GothamBold
    
    local speedUpCorner = Instance.new("UICorner")
    speedUpCorner.CornerRadius = UDim.new(0, 4)
    speedUpCorner.Parent = speedUpButton
    
    -- Speed Down Button
    local speedDownButton = Instance.new("TextButton")
    speedDownButton.Name = "SpeedDownButton"
    speedDownButton.Parent = mainFrame
    speedDownButton.Size = UDim2.new(0, 25, 0, 25)
    speedDownButton.Position = UDim2.new(0, 180, 0, 35)
    speedDownButton.BackgroundColor3 = Color3.fromRGB(200, 70, 70)
    speedDownButton.BorderSizePixel = 0
    speedDownButton.Text = "-"
    speedDownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedDownButton.TextScaled = true
    speedDownButton.Font = Enum.Font.GothamBold
    
    local speedDownCorner = Instance.new("UICorner")
    speedDownCorner.CornerRadius = UDim.new(0, 4)
    speedDownCorner.Parent = speedDownButton
    
    -- Instructions Label
    local instructionsLabel = Instance.new("TextLabel")
    instructionsLabel.Name = "InstructionsLabel"
    instructionsLabel.Parent = mainFrame
    instructionsLabel.Size = UDim2.new(1, -20, 0, 15)
    instructionsLabel.Position = UDim2.new(0, 10, 0, 62)
    instructionsLabel.BackgroundTransparency = 1
    instructionsLabel.Text = "WASD + Space/Shift to fly | G to toggle GUI"
    instructionsLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    instructionsLabel.TextSize = 10
    instructionsLabel.Font = Enum.Font.Gotham
    
    return screenGui, mainFrame, flyButton, speedLabel, speedUpButton, speedDownButton, closeButton
end

-- Fly Functions
local function startFlying()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    local character = LocalPlayer.Character
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character.HumanoidRootPart
    
    -- Create BodyVelocity
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = rootPart
    
    -- Create BodyAngularVelocity for rotation
    bodyAngularVelocity = Instance.new("BodyAngularVelocity")
    bodyAngularVelocity.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyAngularVelocity.AngularVelocity = Vector3.new(0, 0, 0)
    bodyAngularVelocity.Parent = rootPart
    
    -- Disable some humanoid states
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, false)
    humanoid:ChangeState(Enum.HumanoidStateType.Physics)
    
    isFlying = true
    
    -- Main fly loop
    connection = RunService.Heartbeat:Connect(function()
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or not bodyVelocity then
            return
        end
        
        local camera = workspace.CurrentCamera
        local rootPart = LocalPlayer.Character.HumanoidRootPart
        
        local velocity = Vector3.new(0, 0, 0)
        
        -- Calculate movement direction
        if movement.w then
            velocity = velocity + camera.CoordinateFrame.LookVector
        end
        if movement.s then
            velocity = velocity - camera.CoordinateFrame.LookVector
        end
        if movement.a then
            velocity = velocity - camera.CoordinateFrame.RightVector
        end
        if movement.d then
            velocity = velocity + camera.CoordinateFrame.RightVector
        end
        if movement.space then
            velocity = velocity + Vector3.new(0, 1, 0)
        end
        if movement.shift then
            velocity = velocity - Vector3.new(0, 1, 0)
        end
        
        -- Apply velocity
        bodyVelocity.Velocity = velocity.Unit * flySpeed
        
        -- Handle zero velocity
        if velocity.Magnitude == 0 then
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    end)
end

local function stopFlying()
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
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, true)
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
    end
    
    isFlying = false
    
    -- Reset movement
    for key, _ in pairs(movement) do
        movement[key] = false
    end
end

-- Create GUI and get references
local screenGui, mainFrame, flyButton, speedLabel, speedUpButton, speedDownButton, closeButton = createGUI()
gui = screenGui

-- GUI Event Handlers
flyButton.MouseButton1Click:Connect(function()
    if isFlying then
        stopFlying()
        flyButton.Text = "START FLY"
        flyButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    else
        startFlying()
        flyButton.Text = "STOP FLY"
        flyButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end
end)

speedUpButton.MouseButton1Click:Connect(function()
    flySpeed = math.min(flySpeed + 4, 100)
    speedLabel.Text = "Speed: " .. flySpeed
end)

speedDownButton.MouseButton1Click:Connect(function()
    flySpeed = math.max(flySpeed - 4, 4)
    speedLabel.Text = "Speed: " .. flySpeed
end)

closeButton.MouseButton1Click:Connect(function()
    stopFlying()
    gui:Destroy()
end)

-- Input Handling
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    local key = input.KeyCode
    
    -- Toggle GUI with G key
    if key == Enum.KeyCode.G then
        isGuiVisible = not isGuiVisible
        mainFrame.Visible = isGuiVisible
        return
    end
    
    -- Movement keys (only when flying)
    if isFlying then
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
        end
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
    end
end)

-- Character respawn handler
LocalPlayer.CharacterAdded:Connect(function()
    wait(1)
    if isFlying then
        stopFlying()
        flyButton.Text = "START FLY"
        flyButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    end
end)

-- Notification
StarterGui:SetCore("SendNotification", {
    Title = "Fly Script Loaded | DevPhoria";
    Text = "Press G to toggle GUI | Clean & Optimized";
    Duration = 5;
})

print("Optimized Fly Script Loaded - Press G to toggle GUI")
