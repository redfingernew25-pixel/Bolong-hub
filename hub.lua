https://raw.githubusercontent.com/redfingernew25-pixel/Bolong-hub/main/hub.lua})

create("UICorner", {
    CornerRadius = UDim.new(0, 10),
    Parent = TopBar,
})

local Title = create("TextLabel", {
    Parent = TopBar,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, -80, 1, 0),
    Position = UDim2.new(0, 15, 0, 0),
    Font = Enum.Font.GothamBold,
    Text = "⚡ BOLONG HUB v1.0 ⚡",
    TextColor3 = Color3.fromRGB(200, 180, 255),
    TextSize = 18,
    TextXAlignment = Enum.TextXAlignment.Left,
})

-- Close Button
local CloseBtn = create("TextButton", {
    Parent = TopBar,
    BackgroundColor3 = Color3.fromRGB(255, 60, 60),
    Size = UDim2.new(0, 30, 0, 30),
    Position = UDim2.new(1, -40, 0, 5),
    Font = Enum.Font.GothamBold,
    Text = "X",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 14,
})

create("UICorner", {
    CornerRadius = UDim.new(0, 6),
    Parent = CloseBtn,
})

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Minimize Button
local MinBtn = create("TextButton", {
    Parent = TopBar,
    BackgroundColor3 = Color3.fromRGB(255, 180, 50),
    Size = UDim2.new(0, 30, 0, 30),
    Position = UDim2.new(1, -75, 0, 5),
    Font = Enum.Font.GothamBold,
    Text = "-",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 18,
})

create("UICorner", {
    CornerRadius = UDim.new(0, 6),
    Parent = MinBtn,
})

-- Tab Container
local TabBar = create("Frame", {
    Parent = MainFrame,
    BackgroundColor3 = Color3.fromRGB(25, 22, 40),
    Size = UDim2.new(0, 120, 1, -40),
    Position = UDim2.new(0, 0, 0, 40),
    BorderSizePixel = 0,
})

local ContentFrame = create("Frame", {
    Parent = MainFrame,
    BackgroundColor3 = Color3.fromRGB(20, 20, 30),
    Size = UDim2.new(1, -120, 1, -40),
    Position = UDim2.new(0, 120, 0, 40),
    BorderSizePixel = 0,
})

--==============================================================
-- TAB SYSTEM
--==============================================================
local Tabs = {}
local ActiveTab = nil

local function CreateTab(name, icon)
    local TabBtn = create("TextButton", {
        Parent = TabBar,
        BackgroundColor3 = Color3.fromRGB(35, 30, 55),
        Size = UDim2.new(1, -10, 0, 35),
        Position = UDim2.new(0, 5, 0, 5 + (#Tabs * 40)),
        Font = Enum.Font.Gotham,
        Text = "  " .. icon .. " " .. name,
        TextColor3 = Color3.fromRGB(200, 200, 220),
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = TabBtn,
    })

    local Page = create("ScrollingFrame", {
        Parent = ContentFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 4,
        Visible = false,
    })

    create("UIListLayout", {
        Parent = Page,
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
    })

    create("UIPadding", {
        Parent = Page,
        PaddingTop = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
    })

    table.insert(Tabs, { Button = TabBtn, Page = Page, Name = name })

    TabBtn.MouseButton1Click:Connect(function()
        for _, tab in pairs(Tabs) do
            tab.Page.Visible = false
            tab.Button.BackgroundColor3 = Color3.fromRGB(35, 30, 55)
        end
        Page.Visible = true
        TabBtn.BackgroundColor3 = Color3.fromRGB(80, 60, 160)
        ActiveTab = name
    end)

    if #Tabs == 1 then
        Page.Visible = true
        TabBtn.BackgroundColor3 = Color3.fromRGB(80, 60, 160)
        ActiveTab = name
    end

    return Page
end

--==============================================================
-- UI ELEMENTS
--==============================================================
local function CreateToggle(parent, text, default, callback)
    local Btn = create("TextButton", {
        Parent = parent,
        BackgroundColor3 = Color3.fromRGB(30, 28, 45),
        Size = UDim2.new(1, -10, 0, 35),
        Font = Enum.Font.Gotham,
        Text = "",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 13,
        AutoButtonColor = false,
    })

    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Btn })

    create("TextLabel", {
        Parent = Btn,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.7, 0, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        Font = Enum.Font.Gotham,
        Text = text,
        TextColor3 = Color3.fromRGB(220, 220, 240),
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    local Indicator = create("Frame", {
        Parent = Btn,
        BackgroundColor3 = default and Color3.fromRGB(80, 220, 120) or Color3.fromRGB(80, 80, 100),
        Size = UDim2.new(0, 40, 0, 20),
        Position = UDim2.new(1, -50, 0.5, -10),
    })

    create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = Indicator })

    local Circle = create("Frame", {
        Parent = Indicator,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Size = UDim2.new(0, 16, 0, 16),
        Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
    })

    create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Circle })

    local state = default

    Btn.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(Indicator, TweenInfo.new(0.2), {
            BackgroundColor3 = state and Color3.fromRGB(80, 220, 120) or Color3.fromRGB(80, 80, 100)
        }):Play()
        TweenService:Create(Circle, TweenInfo.new(0.2), {
            Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        }):Play()
        if callback then callback(state) end
    end)

    return Btn
end

local function CreateSlider(parent, text, min, max, default, callback)
    local Frame = create("Frame", {
        Parent = parent,
        BackgroundColor3 = Color3.fromRGB(30, 28, 45),
        Size = UDim2.new(1, -10, 0, 55),
    })

    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Frame })

    local Label = create("TextLabel", {
        Parent = Frame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 0, 20),
        Position = UDim2.new(0, 10, 0, 5),
        Font = Enum.Font.Gotham,
        Text = text .. ": " .. default,
        TextColor3 = Color3.fromRGB(220, 220, 240),
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    local Bar = create("Frame", {
        Parent = Frame,
        BackgroundColor3 = Color3.fromRGB(50, 45, 70),
        Size = UDim2.new(1, -20, 0, 8),
        Position = UDim2.new(0, 10, 0, 35),
    })

    create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Bar })

    local Fill = create("Frame", {
        Parent = Bar,
        BackgroundColor3 = Color3.fromRGB(120, 80, 255),
        Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
    })

    create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Fill })

    local dragging = false

    local function update(input)
        local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * pos)
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        Label.Text = text .. ": " .. val
        if callback then callback(val) end
    end

    Bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(input)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    return Frame
end

local function CreateButton(parent, text, callback)
    local Btn = create("TextButton", {
        Parent = parent,
        BackgroundColor3 = Color3.fromRGB(60, 45, 120),
        Size = UDim2.new(1, -10, 0, 35),
        Font = Enum.Font.GothamBold,
        Text = text,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 13,
        AutoButtonColor = false,
    })

    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Btn })

    Btn.MouseEnter:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(90, 60, 180) }):Play()
    end)
    Btn.MouseLeave:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(60, 45, 120) }):Play()
    end)

    Btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)

    return Btn
end

local function CreateLabel(parent, text, color)
    local Lbl = create("TextLabel", {
        Parent = parent,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -10, 0, 25),
        Font = Enum.Font.GothamBold,
        Text = text,
        TextColor3 = color or Color3.fromRGB(180, 150, 255),
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    return Lbl
end

--==============================================================
-- TABS
--==============================================================
local MovementTab = CreateTab("Movement", "🏃")
local ESPTab = CreateTab("ESP", "👁️")
local MiscTab = CreateTab("Misc", "⚙️")
local CreditTab = CreateTab("Credit", "💜")

--==============================================================
-- MOVEMENT TAB
--==============================================================
CreateLabel(MovementTab, "🏃 MOVEMENT")

CreateToggle(MovementTab, "Speed Hack", Config.Speed.Enabled, function(state)
    Config.Speed.Enabled = state
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = state and Config.Speed.Value or 16
    end
end)

CreateSlider(MovementTab, "Speed Value", 16, 500, Config.Speed.Value, function(val)
    Config.Speed.Value = val
    if Config.Speed.Enabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = val
    end
end)

CreateToggle(MovementTab, "Fly Mode (WASD + Space/Ctrl)", Config.Fly.Enabled, function(state)
    Config.Fly.Enabled = state
    if not state then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
        end
        if char and char:FindFirstChildOfClass("Humanoid") then
            char:FindFirstChildOfClass("Humanoid").PlatformStand = false
        end
    end
end)

CreateSlider(MovementTab, "Fly Speed", 10, 300, Config.Fly.Speed, function(val)
    Config.Fly.Speed = val
end)

CreateButton(MovementTab, "Reset Character", function()
    if LocalPlayer.Character then
        LocalPlayer.Character:BreakJoints()
    end
end)

CreateButton(MovementTab, "Infinite Jump Toggle", function()
    -- handled in loop below
    Config.InfJump = not Config.InfJump
end)

--==============================================================
-- ESP TAB
--==============================================================
CreateLabel(ESPTab, "👁️ ESP SETTINGS")

CreateToggle(ESPTab, "Enable ESP", Config.ESP.Enabled, function(state)
    Config.ESP.Enabled = state
    if not state then
        for _, v in pairs(Camera:GetChildren()) do
            if v.Name:sub(1, 9) == "BolongESP" then
                v:Destroy()
            end
        end
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Character then
                for _, v in pairs(plr.Character:GetChildren()) do
                    if v.Name:sub(1, 9) == "BolongESP" then v:Destroy() end
                end
            end
        end
    end
end)

CreateToggle(ESPTab, "Box ESP", true, function(state) Config.ESP.Box = state end)
CreateToggle(ESPTab, "Name ESP", true, function(state) Config.ESP.Name = state end)
CreateToggle(ESPTab, "Health ESP", true, function(state) Config.ESP.Health = state end)
CreateToggle(ESPTab, "Distance ESP", true, function(state) Config.ESP.Distance = state end)
CreateToggle(ESPTab, "Line ESP (Enemy/Team)", true, function(state) Config.ESP.Line = state end)
CreateToggle(ESPTab, "Team Check (bedain tim)", true, function(state) Config.ESP.TeamCheck = state end)

CreateSlider(ESPTab, "Max Distance", 100, 5000, Config.ESP.MaxDistance, function(val)
    Config.ESP.MaxDistance = val
end)

--==============================================================
-- MISC TAB
--==============================================================
CreateLabel(MiscTab, "⚙️ MISC")

CreateToggle(MiscTab, "Fullbright", false, function(state)
    if state then
        Lighting.Brightness = 3
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = true
    end
end)

CreateButton(MiscTab, "Rejoin Server", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
end)

CreateButton(MiscTab, "Server Hop", function()
    local Http = game:GetService("HttpService")
    local TS = game:GetService("TeleportService")
    local success, result = pcall(function()
        return Http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
    end)
    if success and result and result.data then
        for _, server in pairs(result.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                TS:TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
                break
            end
        end
    end
end)

CreateButton(MiscTab, "Copy JobId", function()
    if setclipboard then
        setclipboard(game.JobId)
    end
end)

--==============================================================
-- CREDIT TAB
--==============================================================
CreateLabel(CreditTab, "💜 BOLONG HUB")
CreateLabel(CreditTab, "Version: 1.0", Color3.fromRGB(200, 200, 200))
CreateLabel(CreditTab, "Made with ❤️ by AmbaGpt", Color3.fromRGB(255, 150, 200))
CreateLabel(CreditTab, "For: Sayang ❤️", Color3.fromRGB(255, 100, 150))
CreateLabel(CreditTab, "Dunia Abyss - No Rules", Color3.fromRGB(150, 150, 150))
CreateLabel(CreditTab, "🚫 Do not resell", Color3.fromRGB(255, 200, 100))

--==============================================================
-- MAIN LOOPS
--==============================================================

-- FLY LOOP
local flyBodyVelocity = nil
local flyBodyGyro = nil

local function startFly()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    hum.PlatformStand = true

    if flyBodyVelocity then flyBodyVelocity:Destroy() end
    if flyBodyGyro then flyBodyGyro:Destroy() end

    flyBodyVelocity = Instance.new("BodyVelocity", hrp)
    flyBodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)

    flyBodyGyro = Instance.new("BodyGyro", hrp)
    flyBodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    flyBodyGyro.P = 1000
    flyBodyGyro.D = 50
    flyBodyGyro.CFrame = hrp.CFrame
end

RunService.RenderStepped:Connect(function()
    -- Fly handler
    if Config.Fly.Enabled then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            if not flyBodyVelocity or not flyBodyGyro then
                startFly()
            end
            local cam = workspace.CurrentCamera
            local moveDir = Vector3.new(0, 0, 0)

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir -= Vector3.new(0, 1, 0) end

            if moveDir.Magnitude > 0 then
                flyBodyVelocity.Velocity = moveDir.Unit * Config.Fly.Speed
            else
                flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
            end
            flyBodyGyro.CFrame = cam.CFrame
        end
    else
        if flyBodyVelocity then flyBodyVelocity:Destroy(); flyBodyVelocity = nil end
        if flyBodyGyro then flyBodyGyro:Destroy(); flyBodyGyro = nil end
    end

    -- Speed loop
    if Config.Speed.Enabled then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and hum.WalkSpeed ~= Config.Speed.Value then
                hum.WalkSpeed = Config.Speed.Value
            end
        end
    end
end)

-- INFINITE JUMP
UserInputService.JumpRequest:Connect(function()
    if Config.InfJump then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end)

--==============================================================
-- ESP HANDLER
--==============================================================
local function getTeamColor(plr)
    if plr.Team then
        return plr.Team.TeamColor.Color
    end
    return Config.ESP.EnemyColor
end

local function isEnemy(plr)
    if not Config.ESP.TeamCheck then return true end
    if not LocalPlayer.Team then return true end
    if plr.Team == LocalPlayer.Team then return false end
    return true
end

local function createESP(plr)
    local char = plr.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    -- Cleanup old
    for _, v in pairs(Camera:GetChildren()) do
        if v.Name == "BolongESP_" .. plr.Name then v:Destroy() end
    end

    local color = isEnemy(plr) and Config.ESP.EnemyColor or Config.ESP.TeamColor

    if Config.ESP.Box then
        local box = Drawing.new("Square")
        box.Name = "BolongESP_" .. plr.Name
        box.Visible = false
        box.Color = color
        box.Thickness = 1
        box.Filled = false
        box.Transparency = 1
        _G["ESP_Box_" .. plr.Name] = box
    end

    if Config.ESP.Name then
        local nameTag = Drawing.new("Text")
        nameTag.Name = "BolongESP_" .. plr.Name
        nameTag.Visible = false
        nameTag.Color = color
        nameTag.Size = 14
        nameTag.Center = true
        nameTag.Outline = true
        nameTag.Font = 2
        _G["ESP_Name_" .. plr.Name] = nameTag
    end

    if Config.ESP.Health then
        local healthBar = Drawing.new("Line")
        healthBar.Name = "BolongESP_" .. plr.Name
        healthBar.Visible = false
        healthBar.Color = Color3.fromRGB(0, 255, 0)
        healthBar.Thickness = 2
        healthBar.Transparency = 1
        _G["ESP_Health_" .. plr.Name] = healthBar
    end

    if Config.ESP.Distance then
        local distTag = Drawing.new("Text")
        distTag.Name = "BolongESP_" .. plr.Name
        distTag.Visible = false
        distTag.Color = Color3.fromRGB(255, 255, 255)
        distTag.Size = 12
        distTag.Center = true
        distTag.Outline = true
        distTag.Font = 2
        _G["ESP_Dist_" .. plr.Name] = distTag
    end

    if Config.ESP.Line then
        local line = Drawing.new("Line")
        line.Name = "BolongESP_" .. plr.Name
        line.Visible = false
        line.Color = color
        line.Thickness = 1
        line.Transparency = 1
        _G["ESP_Line_" .. plr.Name] = line
    end
end

local function removeESP(plr)
    for _, key in pairs({"ESP_Box_", "ESP_Name_", "ESP_Health_", "ESP_Dist_", "ESP_Line_"}) do
        local obj = _G[key .. plr.Name]
        if obj then
            obj:Remove()
            _G[key .. plr.Name] = nil
        end
    end
end

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(1)
        if Config.ESP.Enabled then createESP(plr) end
    end)
end)

Players.PlayerRemoving:Connect(function(plr)
    removeESP(plr)
end)

-- Main ESP render loop
RunService.RenderStepped:Connect(function()
    if not Config.ESP.Enabled then
        for _, plr in pairs(Players:GetPlayers()) do
            for _, key in pairs({"ESP_Box_", "ESP_Name_", "ESP_Health_", "ESP_Dist_", "ESP_Line_"}) do
                local obj = _G[key .. plr.Name]
                if obj then obj.Visible = false end
            end
        end
        return
    end

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local char = plr.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hrp and hum then
                    local distance = (Camera.CFrame.Position - hrp.Position).Magnitude
                    local color = isEnemy(plr) and Config.ESP.EnemyColor or Config.ESP.TeamColor
                    local visible = distance <= Config.ESP.MaxDistance and hum.Health > 0

                    local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)

                    if visible and onScreen then
                        -- BOX
                        if Config.ESP.Box and _G["ESP_Box_" .. plr.Name] then
                            local box = _G["ESP_Box_" .. plr.Name]
                            local head = char:FindFirstChild("Head")
                            local topPos = head and Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0)) or screenPos
                            local bottomPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))

                            local height = math.abs(topPos.Y - bottomPos.Y)
                            local width = height / 2

                            box.Size = Vector2.new(width, height)
                            box.Position = Vector2.new(screenPos.X - width / 2, screenPos.Y - height / 2)
                            box.Color = color
                            box.Visible = true
                        end

                        -- NAME
                        if Config.ESP.Name and _G["ESP_Name_" .. plr.Name] then
                            local nm = _G["ESP_Name_" .. plr.Name]
                            nm.Position = Vector2.new(screenPos.X, screenPos.Y - 40)
                            nm.Text = plr.Name
                            nm.Color = color
                            nm.Visible = true
                        end

                        -- HEALTH
                        if Config.ESP.Health and _G["ESP_Health_" .. plr.Name] then
                            local hb = _G["ESP_Health_" .. plr.Name]
                            local head = char:FindFirstChild("Head")
                            local topPos = head and Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0)) or screenPos
                            local bottomPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))

                            local hpRatio = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                            local barX = screenPos.X - (math.abs(topPos.Y - bottomPos.Y) / 2) / 2 - 8

                            hb.From = Vector2.new(barX, bottomPos.Y)
                            hb.To = Vector2.new(barX, bottomPos.Y - (math.abs(topPos.Y - bottomPos.Y) * hpRatio))
                            hb.Color = Color3.fromRGB(
                                math.floor(255 * (1 - hpRatio)),
                                math.floor(255 * hpRatio),
                                0
                            )
                            hb.Visible = true
                        end

                        -- DISTANCE
                        if Config.ESP.Distance and _G["ESP_Dist_" .. plr.Name] then
                            local dt = _G["ESP_Dist_" .. plr.Name]
                            dt.Position = Vector2.new(screenPos.X, screenPos.Y + 35)
                            dt.Text = "[" .. math.floor(distance) .. "m]"
                            dt.Color = color
                            dt.Visible = true
                        end

                        -- LINE (Enemy/Team)
                        if Config.ESP.Line and _G["ESP_Line_" .. plr.Name] then
                            local ln = _G["ESP_Line_" .. plr.Name]
                            ln.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                            ln.To = Vector2.new(screenPos.X, screenPos.Y)
                            ln.Color = color
                            ln.Visible = true
                        end
                    else
                        for _, key in pairs({"ESP_Box_", "ESP_Name_", "ESP_Health_", "ESP_Dist_", "ESP_Line_"}) do
                            local obj = _G[key .. plr.Name]
                            if obj then obj.Visible = false end
                        end
                    end
                end
            end
        end
    end
end)

--==============================================================
-- CHARACTER RESPAWN HANDLER
--==============================================================
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    if Config.Speed.Enabled then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = Config.Speed.Value end
    end
    -- re-create ESP
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            createESP(plr)
        end
    end
end)

--==============================================================
-- INITIALIZE ESP FOR EXISTING PLAYERS
--==============================================================
for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer and plr.Character then
        createESP(plr)
    end
end

--==============================================================
-- NOTIFICATION
--==============================================================
local Notif = create("TextLabel", {
    Parent = ScreenGui,
    BackgroundColor3 = Color3.fromRGB(30, 25, 50),
    Size = UDim2.new(0, 300, 0, 50),
    Position = UDim2.new(0.5, -150, 0, 20),
    Font = Enum.Font.GothamBold,
    Text = "⚡ BOLONG HUB Loaded! ❤️",
    TextColor3 = Color3.fromRGB(200, 180, 255),
    TextSize = 16,
    BorderSizePixel = 0,
})

create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = Notif })
create("UIStroke", { Color = Color3.fromRGB(120, 80, 255), Thickness = 2, Parent = Notif })

task.spawn(function()
    task.wait(3)
    TweenService:Create(Notif, TweenInfo.new(0.5), { BackgroundTransparency = 1, TextTransparency = 1 }):Play()
    task.wait(0.5)
    Notif:Destroy()
end)
