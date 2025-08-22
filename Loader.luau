-- Custom Game Loader with Game ID Detection
-- No full-screen background, just a small popup

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Game configurations
local gameConfigs = {
    [15420499516] = {
        name = "Slaime",
        script = "https://raw.githubusercontent.com/Numass/SLaime/refs/heads/main/Slaime.lua"
    },
    [537413528] = {
        name = "Build A Boat For Treasure",
        script = "https://raw.githubusercontent.com/example/babft.lua"
    },
    [606849621] = {
        name = "Jailbreak",
        script = "https://raw.githubusercontent.com/example/jailbreak.lua"
    },
    [920587237] = {
        name = "Adopt Me",
        script = "https://raw.githubusercontent.com/example/adoptme.lua"
    }
    -- Add more games as needed
}

-- Create small popup loader
local function createLoader()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CustomLoader"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = playerGui
    
    -- Main container (small popup)
    local container = Instance.new("Frame")
    container.Name = "Container"
    container.Size = UDim2.new(0, 250, 0, 120)
    container.Position = UDim2.new(0.5, -125, 0.5, -60)
    container.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
    container.BorderSizePixel = 0
    container.Parent = screenGui
    
    -- Container styling
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 15)
    containerCorner.Parent = container
    
    local containerStroke = Instance.new("UIStroke")
    containerStroke.Color = Color3.fromRGB(100, 150, 255)
    containerStroke.Thickness = 2
    containerStroke.Transparency = 0.3
    containerStroke.Parent = container
    
    -- Drop shadow effect
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.Position = UDim2.new(0, -5, 0, -5)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.7
    shadow.ZIndex = container.ZIndex - 1
    shadow.Parent = screenGui
    
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(0, 15)
    shadowCorner.Parent = shadow
    
    -- Main text
    local mainText = Instance.new("TextLabel")
    mainText.Name = "MainText"
    mainText.Size = UDim2.new(1, -20, 0, 40)
    mainText.Position = UDim2.new(0, 10, 0, 20)
    mainText.BackgroundTransparency = 1
    mainText.Text = "Checking game..."
    mainText.TextColor3 = Color3.fromRGB(255, 255, 255)
    mainText.TextScaled = true
    mainText.Font = Enum.Font.GothamBold
    mainText.Parent = container
    
    -- Status text
    local statusText = Instance.new("TextLabel")
    statusText.Name = "StatusText"
    statusText.Size = UDim2.new(1, -20, 0, 25)
    statusText.Position = UDim2.new(0, 10, 0, 65)
    statusText.BackgroundTransparency = 1
    statusText.Text = ""
    statusText.TextColor3 = Color3.fromRGB(150, 150, 150)
    statusText.TextScaled = true
    statusText.Font = Enum.Font.Gotham
    statusText.Parent = container
    
    -- Progress bar (initially hidden)
    local progressBg = Instance.new("Frame")
    progressBg.Name = "ProgressBackground"
    progressBg.Size = UDim2.new(0.8, 0, 0, 6)
    progressBg.Position = UDim2.new(0.1, 0, 0, 95)
    progressBg.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    progressBg.BorderSizePixel = 0
    progressBg.Visible = false
    progressBg.Parent = container
    
    local progressBgCorner = Instance.new("UICorner")
    progressBgCorner.CornerRadius = UDim.new(0, 3)
    progressBgCorner.Parent = progressBg
    
    local progressFill = Instance.new("Frame")
    progressFill.Name = "ProgressFill"
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.Position = UDim2.new(0, 0, 0, 0)
    progressFill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    progressFill.BorderSizePixel = 0
    progressFill.Parent = progressBg
    
    local progressFillCorner = Instance.new("UICorner")
    progressFillCorner.CornerRadius = UDim.new(0, 3)
    progressFillCorner.Parent = progressFill
    
    return screenGui, container, shadow, mainText, statusText, progressBg, progressFill
end

-- Animate progress
local function animateProgress(progressFill, progress)
    local tween = TweenService:Create(progressFill, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(progress, 0, 1, 0)
    })
    tween:Play()
    return tween
end

-- Animate container size
local function animateContainerSize(container, shadow, newSize)
    local containerTween = TweenService:Create(container, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = newSize,
        Position = UDim2.new(0.5, -newSize.X.Offset/2, 0.5, -newSize.Y.Offset/2)
    })
    
    local shadowTween = TweenService:Create(shadow, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(1, newSize.X.Offset + 10, 1, newSize.Y.Offset + 10),
        Position = UDim2.new(0.5, -(newSize.X.Offset + 10)/2, 0.5, -(newSize.Y.Offset + 10)/2)
    })
    
    containerTween:Play()
    shadowTween:Play()
    return containerTween
end

-- Main loader function
local function runLoader()
    local screenGui, container, shadow, mainText, statusText, progressBg, progressFill = createLoader()
    
    -- Initial entrance animation
    container.Position = UDim2.new(0.5, -125, 1.5, 0)
    shadow.Position = UDim2.new(0.5, -130, 1.5, 0)
    
    local entranceTween = TweenService:Create(container, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -125, 0.5, -60)
    })
    
    local shadowEntranceTween = TweenService:Create(shadow, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -130, 0.5, -65)
    })
    
    entranceTween:Play()
    shadowEntranceTween:Play()
    entranceTween.Completed:Wait()
    
    wait(0.5)
    
    -- Check game ID
    local gameId = game.PlaceId
    local gameConfig = gameConfigs[gameId]
    
    if not gameConfig then
        mainText.Text = "❌ Not Compatible"
        mainText.TextColor3 = Color3.fromRGB(255, 100, 100)
        statusText.Text = "Game ID: " .. tostring(gameId)
        
        wait(2)
        
        -- Exit animation
        local exitTween = TweenService:Create(container, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, -125, -1.5, 0)
        })
        exitTween:Play()
        exitTween.Completed:Connect(function()
            screenGui:Destroy()
        end)
        return
    end
    
    -- Game is compatible, greet user
    mainText.Text = "Hi " .. player.DisplayName .. "!"
    mainText.TextColor3 = Color3.fromRGB(100, 255, 100)
    statusText.Text = "Game: " .. gameConfig.name
    
    wait(1.5)
    
    -- Grow the window and start loading
    local growTween = animateContainerSize(container, shadow, UDim2.new(0, 300, 0, 150))
    growTween.Completed:Wait()
    
    -- Show progress bar and start loading animation
    progressBg.Visible = true
    mainText.Text = "Loading " .. gameConfig.name
    statusText.Text = "Please wait..."
    
    -- Loading stages
    local stages = {
        {0.2, "Connecting..."},
        {0.4, "Downloading..."},
        {0.6, "Preparing..."},
        {0.8, "Initializing..."},
        {1.0, "Almost ready..."}
    }
    
    for _, stage in ipairs(stages) do
        statusText.Text = stage[2]
        local tween = animateProgress(progressFill, stage[1])
        tween.Completed:Wait()
        wait(0.4)
    end
    
    -- Move up and show "Have fun" message
    local moveUpTween = TweenService:Create(container, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -150, 0.3, -75)
    })
    moveUpTween:Play()
    moveUpTween.Completed:Wait()
    
    mainText.Text = "Have fun!"
    mainText.TextColor3 = Color3.fromRGB(100, 255, 100)
    statusText.Text = "Starting script..."
    progressBg.Visible = false
    
    wait(1)
    
    -- Load the actual script
    local success, result = pcall(function()
        loadstring(game:HttpGet(gameConfig.script))()
    end)
    
    if success then
        statusText.Text = "✅ Loaded successfully!"
        statusText.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        statusText.Text = "❌ Failed to load"
        statusText.TextColor3 = Color3.fromRGB(255, 100, 100)
        warn("Script loading failed:", result)
    end
    
    wait(1.5)
    
    -- Slow fade out
    local fadeOutTween = TweenService:Create(container, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 1
    })
    
    local shadowFadeOutTween = TweenService:Create(shadow, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 1
    })
    
    local textFadeOutTween = TweenService:Create(mainText, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 1
    })
    
    local statusFadeOutTween = TweenService:Create(statusText, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 1
    })
    
    local strokeFadeOutTween = TweenService:Create(container:FindFirstChild("UIStroke"), TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Transparency = 1
    })
    
    fadeOutTween:Play()
    shadowFadeOutTween:Play()
    textFadeOutTween:Play()
    statusFadeOutTween:Play()
    strokeFadeOutTween:Play()
    
    fadeOutTween.Completed:Connect(function()
        screenGui:Destroy()
    end)
end

-- Execute the loader
runLoader()
