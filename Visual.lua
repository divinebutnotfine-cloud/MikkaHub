-- LEAK BY PRINCE THE OWNER GIVE IT TO ME

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local TweenService = game:GetService("TweenService")
local lp = Players.LocalPlayer

local STEAL_RADIUS = 60
local STEAL_DURATION = 1.4
local isStealing = false
local StealData = {}
local progressBarBg = nil
local progressFill = nil
local percentLabel = nil
local bannerFrame = nil
local infoLabel = nil

-- Mikka Hub Theme Colors
local THEME = {
    Primary = Color3.fromRGB(255, 105, 180),      -- Hot Pink
    Secondary = Color3.fromRGB(255, 182, 193),    -- Light Pink
    Accent = Color3.fromRGB(255, 20, 147),          -- Deep Pink
    Dark = Color3.fromRGB(30, 10, 20),              -- Dark Pink-Black
    Glass = Color3.fromRGB(20, 5, 15),              -- Glass bg
    Text = Color3.fromRGB(255, 240, 245),           -- Lavender Blush
    Glow = Color3.fromRGB(255, 105, 180),           -- Glow color
}

local function updateTopBar()
    if not infoLabel then return end
    local fps = 60
    local ping = 0
    local framesCount = 0
    local last = tick()
    RunService.RenderStepped:Connect(function()
        framesCount = framesCount + 1
        if tick() - last >= 1 then
            fps = framesCount
            framesCount = 0
            last = tick()
        end
        local network = Stats:FindFirstChild("Network")
        if network and network:FindFirstChild("ServerStatsItem") then
            local dataPing = network.ServerStatsItem:FindFirstChild("Data Ping")
            if dataPing then ping = math.floor(dataPing:GetValue()) end
        end
        infoLabel.Text = "  Mikka Hub  |  Ping: " .. ping .. "ms  |  FPS: " .. fps
    end)
end

local function setupUI()
    local sg = lp.PlayerGui:FindFirstChild("MikkaHub")
    if not sg then
        sg = Instance.new("ScreenGui")
        sg.Name = "MikkaHub"
        sg.ResetOnSpawn = false
        sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        sg.Parent = lp.PlayerGui
    end

    if not progressBarBg then
        -- Main Container with Glassmorphism
        local container = Instance.new("Frame")
        container.Size = UDim2.new(0, 320, 0, 90)
        container.Position = UDim2.new(0.5, -160, 0, 25)
        container.BackgroundColor3 = THEME.Glass
        container.BackgroundTransparency = 0.35
        container.BorderSizePixel = 0
        container.Parent = sg
        
        local containerCorner = Instance.new("UICorner", container)
        containerCorner.CornerRadius = UDim.new(0, 16)
        
        -- Outer Glow / Shadow
        local glow = Instance.new("ImageLabel")
        glow.Name = "Glow"
        glow.Size = UDim2.new(1, 40, 1, 40)
        glow.Position = UDim2.new(0, -20, 0, -20)
        glow.BackgroundTransparency = 1
        glow.Image = "rbxassetid://4996891976"
        glow.ImageColor3 = THEME.Glow
        glow.ImageTransparency = 0.85
        glow.ZIndex = 0
        glow.Parent = container
        
        -- Stroke for glass effect
        local stroke = Instance.new("UIStroke", container)
        stroke.Color = THEME.Primary
        stroke.Thickness = 1.2
        stroke.Transparency = 0.5
        
        -- Banner / Header
        bannerFrame = Instance.new("Frame")
        bannerFrame.Name = "Banner"
        bannerFrame.Size = UDim2.new(1, -16, 0, 36)
        bannerFrame.Position = UDim2.new(0, 8, 0, 8)
        bannerFrame.BackgroundColor3 = THEME.Primary
        bannerFrame.BackgroundTransparency = 0.15
        bannerFrame.BorderSizePixel = 0
        bannerFrame.Parent = container
        
        local bannerCorner = Instance.new("UICorner", bannerFrame)
        bannerCorner.CornerRadius = UDim.new(0, 12)
        
        -- Gradient for banner
        local gradient = Instance.new("UIGradient", bannerFrame)
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, THEME.Primary),
            ColorSequenceKeypoint.new(0.5, THEME.Secondary),
            ColorSequenceKeypoint.new(1, THEME.Accent)
        })
        gradient.Rotation = 45
        
        -- Banner Glow
        local bannerGlow = Instance.new("ImageLabel")
        bannerGlow.Name = "BannerGlow"
        bannerGlow.Size = UDim2.new(1, 20, 1, 20)
        bannerGlow.Position = UDim2.new(0, -10, 0, -10)
        bannerGlow.BackgroundTransparency = 1
        bannerGlow.Image = "rbxassetid://4996891976"
        bannerGlow.ImageColor3 = THEME.Accent
        bannerGlow.ImageTransparency = 0.7
        bannerGlow.ZIndex = bannerFrame.ZIndex - 1
        bannerGlow.Parent = bannerFrame
        
        -- Cute Icon (Heart)
        local icon = Instance.new("ImageLabel")
        icon.Name = "Icon"
        icon.Size = UDim2.new(0, 20, 0, 20)
        icon.Position = UDim2.new(0, 10, 0.5, -10)
        icon.BackgroundTransparency = 1
        icon.Image = "rbxassetid://6022668898"
        icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
        icon.Parent = bannerFrame
        
        -- Info Label
        infoLabel = Instance.new("TextLabel")
        infoLabel.Name = "Info"
        infoLabel.Size = UDim2.new(1, -36, 1, 0)
        infoLabel.Position = UDim2.new(0, 32, 0, 0)
        infoLabel.BackgroundTransparency = 1
        infoLabel.Font = Enum.Font.GothamBold
        infoLabel.TextSize = 13
        infoLabel.TextColor3 = THEME.Text
        infoLabel.Text = "  Mikka Hub  |  Ping: 0ms  |  FPS: 0"
        infoLabel.TextXAlignment = Enum.TextXAlignment.Left
        infoLabel.Parent = bannerFrame
        
        -- Subtle shadow for text
        local textShadow = Instance.new("UIStroke", infoLabel)
        textShadow.Color = THEME.Accent
        textShadow.Thickness = 0.6
        textShadow.Transparency = 0.6
        
        -- Progress Bar Background
        progressBarBg = Instance.new("Frame")
        progressBarBg.Name = "ProgressBg"
        progressBarBg.Size = UDim2.new(1, -16, 0, 18)
        progressBarBg.Position = UDim2.new(0, 8, 0, 52)
        progressBarBg.BackgroundColor3 = THEME.Dark
        progressBarBg.BackgroundTransparency = 0.4
        progressBarBg.BorderSizePixel = 0
        progressBarBg.Visible = true
        progressBarBg.Parent = container
        
        local bgCorner = Instance.new("UICorner", progressBarBg)
        bgCorner.CornerRadius = UDim.new(0, 9)
        
        local bgStroke = Instance.new("UIStroke", progressBarBg)
        bgStroke.Color = THEME.Secondary
        bgStroke.Thickness = 1
        bgStroke.Transparency = 0.6
        
        -- Progress Fill
        progressFill = Instance.new("Frame")
        progressFill.Name = "Fill"
        progressFill.Size = UDim2.new(0, 0, 1, -4)
        progressFill.Position = UDim2.new(0, 2, 0, 2)
        progressFill.BackgroundColor3 = THEME.Primary
        progressFill.BorderSizePixel = 0
        progressFill.Parent = progressBarBg
        
        local fillCorner = Instance.new("UICorner", progressFill)
        fillCorner.CornerRadius = UDim.new(0, 7)
        
        -- Fill Gradient
        local fillGradient = Instance.new("UIGradient", progressFill)
        fillGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, THEME.Secondary),
            ColorSequenceKeypoint.new(1, THEME.Accent)
        })
        fillGradient.Rotation = 90
        
        -- Fill Glow
        local fillGlow = Instance.new("ImageLabel")
        fillGlow.Name = "FillGlow"
        fillGlow.Size = UDim2.new(1, 10, 1, 10)
        fillGlow.Position = UDim2.new(0, -5, 0, -5)
        fillGlow.BackgroundTransparency = 1
        fillGlow.Image = "rbxassetid://4996891976"
        fillGlow.ImageColor3 = THEME.Accent
        fillGlow.ImageTransparency = 0.75
        fillGlow.ZIndex = progressFill.ZIndex - 1
        fillGlow.Parent = progressFill
        
        -- Percent Label
        percentLabel = Instance.new("TextLabel")
        percentLabel.Name = "Percent"
        percentLabel.Size = UDim2.new(1, 0, 1, 0)
        percentLabel.BackgroundTransparency = 1
        percentLabel.Font = Enum.Font.GothamBlack
        percentLabel.TextSize = 12
        percentLabel.TextColor3 = THEME.Text
        percentLabel.Text = "0%"
        percentLabel.Parent = progressBarBg
        
        -- Intro Animation
        container.Size = UDim2.new(0, 0, 0, 90)
        container.Position = UDim2.new(0.5, 0, 0, 25)
        
        TweenService:Create(container, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 320, 0, 90),
            Position = UDim2.new(0.5, -160, 0, 25)
        }):Play()
        
        -- Idle floating animation
        task.spawn(function()
            while container and container.Parent do
                local tween = TweenService:Create(container, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                    Position = UDim2.new(0.5, -160, 0, 22)
                })
                tween:Play()
                tween.Completed:Wait()
                
                if not container or not container.Parent then break end
                
                local tween2 = TweenService:Create(container, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                    Position = UDim2.new(0.5, -160, 0, 28)
                })
                tween2:Play()
                tween2.Completed:Wait()
            end
        end)
        
        updateTopBar()
    end
end

local function getHRP()
    local c = lp.Character
    if c then return c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Torso") or c:FindFirstChild("UpperTorso") end
    return nil
end

local function isMyPlotByName(pn)
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return false end
    local plot = plots:FindFirstChild(pn)
    if not plot then return false end
    local sign = plot:FindFirstChild("PlotSign")
    if sign then
        local yb = sign:FindFirstChild("YourBase")
        if yb and yb:IsA("BillboardGui") then return yb.Enabled == true end
    end
    return false
end

local function findNearestPrompt()
    local hrp = getHRP()
    if not hrp then return nil end
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    local nearest, dist = nil, math.huge
    for _, plot in ipairs(plots:GetChildren()) do
        if isMyPlotByName(plot.Name) then continue end
        local pods = plot:FindFirstChild("AnimalPodiums")
        if not pods then continue end
        for _, pod in ipairs(pods:GetChildren()) do
            local base = pod:FindFirstChild("Base")
            if not base then continue end
            local spawn = base:FindFirstChild("Spawn")
            if not spawn then continue end
            local d = (spawn.Position - hrp.Position).Magnitude
            if d <= STEAL_RADIUS and d < dist then
                local att = spawn:FindFirstChild("PromptAttachment")
                if att then
                    for _, p in ipairs(att:GetChildren()) do
                        if p:IsA("ProximityPrompt") and p.ActionText and p.ActionText:find("Steal") then
                            nearest, dist = p, d
                        end
                    end
                end
            end
        end
    end
    return nearest
end

local function updateProgressBar(p)
    if progressFill then
        progressFill.Size = UDim2.new(p, 0, 1, -4)
    end
    if percentLabel then
        percentLabel.Text = math.floor(p * 100) .. "%"
    end
end

local function executeSteal(prompt)
    if isStealing then return end
    if not StealData[prompt] then
        StealData[prompt] = {hold = {}, trigger = {}, ready = true}
        if getconnections then
            for _, c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
                if c.Function then table.insert(StealData[prompt].hold, c.Function) end
            end
            for _, c in ipairs(getconnections(prompt.Triggered)) do
                if c.Function then table.insert(StealData[prompt].trigger, c.Function) end
            end
        end
    end
    local data = StealData[prompt]
    if not data.ready then return end
    data.ready = false
    isStealing = true
    local startTime = tick()
    task.spawn(function()
        for _, f in ipairs(data.hold) do pcall(f) end
        while tick() - startTime < STEAL_DURATION do
            local elapsed = tick() - startTime
            local p = math.clamp(elapsed / STEAL_DURATION, 0, 1)
            updateProgressBar(p)
            task.wait()
        end
        updateProgressBar(1)
        for _, f in ipairs(data.trigger) do pcall(f) end
        task.wait(0.05)
        updateProgressBar(0)
        data.ready = true
        isStealing = false
    end)
end

local heartbeatConn
local function startAutoSteal()
    setupUI()
    if heartbeatConn then return end
    heartbeatConn = RunService.Heartbeat:Connect(function()
        if isStealing then return end
        local success, prompt = pcall(findNearestPrompt)
        if success and prompt then pcall(executeSteal, prompt) end
    end)
end

local function stopAutoSteal()
    if heartbeatConn then heartbeatConn:Disconnect() heartbeatConn = nil end
    isStealing = false
    updateProgressBar(0)
end

startAutoSteal()
