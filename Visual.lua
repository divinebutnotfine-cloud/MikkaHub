-- LEAK BY PRINCE THE OWNER GIVE IT TO ME

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
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
        infoLabel.Text = "Mikka Hub | Ping: " .. ping .. "ms | FPS: " .. fps
    end)
end

local function setupUI()
    local sg = lp.PlayerGui:FindFirstChild("MikkaHub")
    if not sg then
        sg = Instance.new("ScreenGui")
        sg.Name = "MikkaHub"
        sg.ResetOnSpawn = false
        sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        sg.DisplayOrder = 999
        sg.Parent = lp.PlayerGui
    end

    if not progressBarBg then
        -- Main Container (very top, high priority)
        local container = Instance.new("Frame")
        container.Name = "MainContainer"
        container.Size = UDim2.new(0, 300, 0, 85)
        container.Position = UDim2.new(0.5, -150, 0, 2)
        container.BackgroundColor3 = Color3.fromRGB(25, 15, 20)
        container.BackgroundTransparency = 0.2
        container.BorderSizePixel = 0
        container.ZIndex = 100
        container.Parent = sg

        local containerCorner = Instance.new("UICorner", container)
        containerCorner.CornerRadius = UDim.new(0, 12)

        local containerStroke = Instance.new("UIStroke", container)
        containerStroke.Color = Color3.fromRGB(255, 105, 180)
        containerStroke.Thickness = 1.5
        containerStroke.Transparency = 0.3

        -- Banner
        bannerFrame = Instance.new("Frame")
        bannerFrame.Name = "Banner"
        bannerFrame.Size = UDim2.new(1, -12, 0, 34)
        bannerFrame.Position = UDim2.new(0, 6, 0, 6)
        bannerFrame.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
        bannerFrame.BackgroundTransparency = 0.1
        bannerFrame.BorderSizePixel = 0
        bannerFrame.ZIndex = 101
        bannerFrame.Parent = container

        local bannerCorner = Instance.new("UICorner", bannerFrame)
        bannerCorner.CornerRadius = UDim.new(0, 10)

        -- Logo Image
        -- INSTRUCTIONS: Upload your image to Roblox as a Decal, then paste the Asset ID below.
        -- Example: logo.Image = "rbxassetid://123456789"
        local logo = Instance.new("ImageLabel")
        logo.Name = "Logo"
        logo.Size = UDim2.new(0, 28, 0, 28)
        logo.Position = UDim2.new(0, 6, 0.5, -14)
        logo.BackgroundTransparency = 1
        logo.Image = "" -- LEAVE EMPTY UNTIL YOU ADD YOUR ROBLOX ASSET ID
        logo.ZIndex = 102
        logo.Parent = bannerFrame

        -- Placeholder text so you see where the logo goes before uploading
        local logoPlaceholder = Instance.new("TextLabel")
        logoPlaceholder.Name = "Placeholder"
        logoPlaceholder.Size = UDim2.new(1, 0, 1, 0)
        logoPlaceholder.BackgroundTransparency = 1
        logoPlaceholder.Font = Enum.Font.GothamBold
        logoPlaceholder.TextSize = 10
        logoPlaceholder.TextColor3 = Color3.fromRGB(255, 255, 255)
        logoPlaceholder.Text = "?"
        logoPlaceholder.ZIndex = 103
        logoPlaceholder.Parent = logo

        local logoCorner = Instance.new("UICorner", logo)
        logoCorner.CornerRadius = UDim.new(1, 0)

        local logoStroke = Instance.new("UIStroke", logo)
        logoStroke.Color = Color3.fromRGB(255, 255, 255)
        logoStroke.Thickness = 1.5
        logoStroke.Transparency = 0.5

        -- Info Label
        infoLabel = Instance.new("TextLabel")
        infoLabel.Name = "Info"
        infoLabel.Size = UDim2.new(1, -42, 1, 0)
        infoLabel.Position = UDim2.new(0, 38, 0, 0)
        infoLabel.BackgroundTransparency = 1
        infoLabel.Font = Enum.Font.GothamBold
        infoLabel.TextSize = 13
        infoLabel.TextColor3 = Color3.fromRGB(255, 240, 245)
        infoLabel.Text = "Mikka Hub | Ping: 0ms | FPS: 0"
        infoLabel.TextXAlignment = Enum.TextXAlignment.Left
        infoLabel.ZIndex = 102
        infoLabel.Parent = bannerFrame

        -- Progress Bar Background
        progressBarBg = Instance.new("Frame")
        progressBarBg.Name = "ProgressBg"
        progressBarBg.Size = UDim2.new(1, -12, 0, 16)
        progressBarBg.Position = UDim2.new(0, 6, 0, 46)
        progressBarBg.BackgroundColor3 = Color3.fromRGB(20, 10, 15)
        progressBarBg.BackgroundTransparency = 0.3
        progressBarBg.BorderSizePixel = 0
        progressBarBg.Visible = true
        progressBarBg.ZIndex = 100
        progressBarBg.Parent = container

        local bgCorner = Instance.new("UICorner", progressBarBg)
        bgCorner.CornerRadius = UDim.new(0, 8)

        local bgStroke = Instance.new("UIStroke", progressBarBg)
        bgStroke.Color = Color3.fromRGB(255, 182, 193)
        bgStroke.Thickness = 1
        bgStroke.Transparency = 0.5

        -- Progress Fill
        progressFill = Instance.new("Frame")
        progressFill.Name = "Fill"
        progressFill.Size = UDim2.new(0, 0, 1, -4)
        progressFill.Position = UDim2.new(0, 2, 0, 2)
        progressFill.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
        progressFill.BorderSizePixel = 0
        progressFill.ZIndex = 101
        progressFill.Parent = progressBarBg

        local fillCorner = Instance.new("UICorner", progressFill)
        fillCorner.CornerRadius = UDim.new(0, 6)

        -- Percent Label
        percentLabel = Instance.new("TextLabel")
        percentLabel.Name = "Percent"
        percentLabel.Size = UDim2.new(1, 0, 1, 0)
        percentLabel.BackgroundTransparency = 1
        percentLabel.Font = Enum.Font.GothamBold
        percentLabel.TextSize = 11
        percentLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        percentLabel.Text = "0%"
        percentLabel.ZIndex = 102
        percentLabel.Parent = progressBarBg

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
