-- BOLONG HUB v1.1 - FIXED FOR MOBILE EXECUTOR
-- Parent: PlayerGui (biar ga ke-block CoreGui)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Hapus UI lama
if PlayerGui:FindFirstChild("BolongHubUI") then
    PlayerGui.BolongHubUI:Destroy()
end

-- CONFIG
local Config = {
    Speed = { Enabled = false, Value = 50 },
    Fly = { Enabled = false, Speed = 50 },
    ESP = {
        Enabled = false,
        Box = true, Name = true, Health = true,
        Distance = true, Line = true, TeamCheck = true,
        EnemyColor = Color3.fromRGB(255, 50, 50),
        TeamColor = Color3.fromRGB(50, 255, 50),
        MaxDistance = 1000,
    },
    InfJump = false,
}

-- HELPER
local function create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do obj[k] = v end
    return obj
end

-- SCREEN GUI (pake PlayerGui)
local ScreenGui = create("ScreenGui", {
    Name = "BolongHubUI",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = PlayerGui,
})

-- MAIN FRAME
local MainFrame = create("Frame", {
    Name = "Main",
    Parent = ScreenGui,
    BackgroundColor3 = Color3.fromRGB(20, 20, 30),
    BorderSizePixel = 0,
    Size = UDim2.new(0, 500, 0, 350),
    Position = UDim2.new(0.5, -250, 0.5, -175),
    Active = true,
    Draggable = true,
})

create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = MainFrame })
create("UIStroke", { Color = Color3.fromRGB(120, 80, 255), Thickness = 2, Parent = MainFrame })

-- TOP BAR
local TopBar = create("Frame", {
    Parent = MainFrame,
    BackgroundColor3 = Color3.fromRGB(30, 25, 50),
    Size = UDim2.new(1, 0, 0, 40),
    BorderSizePixel = 0,
})
create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = TopBar })

create("TextLabel", {
    Parent = TopBar,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, -80, 1, 0),
    Position = UDim2.new(0, 15, 0, 0),
    Font = Enum.Font.GothamBold,
    Text = "⚡ BOLONG HUB v1.1 ⚡",
    TextColor3 = Color3.fromRGB(200, 180, 255),
    TextSize = 18,
    TextXAlignment = Enum.TextXAlignment.Left,
})

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
create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = CloseBtn })
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

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
create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = MinBtn })

-- TAB CONTAINER
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

-- TAB SYSTEM
local Tabs = {}
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
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = TabBtn })

    local Page = create("ScrollingFrame", {
        Parent = ContentFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 4,
        Visible = false,
    })
    create("UIListLayout", { Parent = Page, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder })
    create("UIPadding", { Parent = Page, PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10) })

    table.insert(Tabs, { Button = TabBtn, Page = Page, Name = name })
    TabBtn.MouseButton1Click:Connect(function()
        for _, tab in pairs(Tabs) do
            tab.Page.Visible = false
            tab.Button.BackgroundColor3 = Color3.fromRGB(35, 30, 55)
        end
        Page.Visible = true
        TabBtn.BackgroundColor3 = Color3.fromRGB(80, 60, 160)
    end)

    if #Tabs == 1 then
        Page.Visible = true
        TabBtn.BackgroundColor3 = Color3.fromRGB(80, 60, 160)
    end
    return Page
end

-- UI ELEMENTS
local function CreateToggle(parent, text, default, callback)
    local Btn = create("TextButton", {
        Parent = parent, BackgroundColor3 = Color3.fromRGB(30, 28, 45),
        Size = UDim2.new(1, -10, 0, 35), Font = Enum.Font.Gotham, Text = "",
        AutoButtonColor = false,
    })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Btn })
    create("TextLabel", {
        Parent = Btn, BackgroundTransparency = 1, Size = UDim2.new(0.7, 0, 1, 0),
        Position = UDim2.new(0, 10, 0, 0), Font = Enum.Font.Gotham, Text = text,
        TextColor3 = Color3.fromRGB(220, 220, 240), TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    local Indicator = create("Frame", {
        Parent = Btn, BackgroundColor3 = default and Color3.fromRGB(80, 220, 120) or Color3.fromRGB(80, 80, 100),
        Size = UDim2.new(0, 40, 0, 20), Position = UDim2.new(1, -50, 0.5, -10),
    })
    create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = Indicator })
    local Circle = create("Frame", {
        Parent = Indicator, BackgroundColor3 = Color3.fromRGB(255, 255, 255),
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
        Parent = parent, BackgroundColor3 = Color3.fromRGB(30, 28, 45),
        Size = UDim2.new(1, -10, 0, 55),
    })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Frame })
    local Label = create("TextLabel", {
        Parent = Frame, BackgroundTransparency = 1, Size = UDim2.new(1, -20, 0, 20),
        Position = UDim2.new(0, 10, 0, 5), Font = Enum.Font.Gotham,
        Text = text .. ": " .. default, TextColor3 = Color3.fromRGB(220, 220, 240),
        TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left,
    })
    local Bar = create("Frame", {
        Parent = Frame, BackgroundColor3 = Color3.fromRGB(50, 45, 70),
        Size = UDim2.new(1, -20, 0, 8), Position = UDim2.new(0, 10, 0, 35),
    })
    create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Bar })
    local Fill = create("Frame", {
        Parent = Bar, BackgroundColor3 = Color3.fromRGB(120, 80, 255),
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
            dragging = true; update(input)
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
        Parent = parent, BackgroundColor3 = Color3.fromRGB(60, 45, 120),
        Size = UDim2.new(1, -10, 0, 35), Font = Enum.Font.GothamBold,
        Text = text, TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 13, AutoButtonColor = false,
    })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Btn })
    Btn.MouseButton1Click:Connect(function() if callback then callback() end end)
    return Btn
end

local function CreateLabel(parent, text, color)
    return create("TextLabel", {
        Parent = parent, BackgroundTransparency = 1, Size = UDim2.new(1, -10, 0, 25),
        Font = Enum.Font.GothamBold, Text = text,
        TextColor3 = color or Color3.fromRGB(180, 150, 255),
        TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left,
    })
end

-- TABS
local MovementTab = CreateTab("Movement", "🏃")
local ESPTab = CreateTab("ESP", "👁️")
local MiscTab = CreateTab("Misc", "⚙️")
local CreditTab = CreateTab("Credit", "💜")

-- MOVEMENT TAB
CreateLabel(MovementTab, "🏃 MOVEMENT")
CreateToggle(MovementTab, "Speed Hack", false, function(state)
    Config.Speed.Enabled = state
    if LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = state and Config.Speed.Value or 16 end
    end
end)
CreateSlider(MovementTab, "Speed Value", 16, 500, 50, function(val) Config.Speed.Value = val end)
CreateToggle(MovementTab, "Fly Mode (WASD + Space/Ctrl)", false, function(state) Config.Fly.Enabled = state end)
CreateSlider(MovementTab, "Fly Speed", 10, 300, 50, function(val) Config.Fly.Speed = val end)
CreateToggle(MovementTab, "Infinite Jump", false, function(state) Config.InfJump = state end)
CreateButton(MovementTab, "Reset Character", function()
    if LocalPlayer.Character then LocalPlayer.Character:BreakJoints() end
end)

-- ESP TAB
CreateLabel(ESPTab, "👁️ ESP SETTINGS")
CreateToggle(ESPTab, "Enable ESP", false, function(state) Config.ESP.Enabled = state end)
CreateToggle(ESPTab, "Box ESP", true, function(state) Config.ESP.Box = state end)
CreateToggle(ESPTab, "Name ESP", true, function(state) Config.ESP.Name = state end)
CreateToggle(ESPTab, "Health ESP", true, function(state) Config.ESP.Health = state end)
CreateToggle(ESPTab, "Distance ESP", true, function(state) Config.ESP.Distance = state end)
CreateToggle(ESPTab, "Line ESP (Enemy/Team)", true, function(state) Config.ESP.Line = state end)
CreateToggle(ESPTab, "Team Check", true, function(state) Config.ESP.TeamCheck = state end)
CreateSlider(ESPTab, "Max Distance", 100, 5000, 1000, function(val) Config.ESP.MaxDistance = val end)

-- MISC TAB
CreateLabel(MiscTab, "⚙️ MISC")
CreateToggle(MiscTab, "Fullbright", false, function(state)
    Lighting.Brightness = state and 3 or 2
    Lighting.GlobalShadows = not state
end)
CreateButton(MiscTab, "Rejoin Server", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
end)

-- CREDIT TAB
CreateLabel(CreditTab, "💜 BOLONG HUB")
CreateLabel(CreditTab, "Version: 1.1 (Mobile Fix)", Color3.fromRGB(200, 200, 200))
CreateLabel(CreditTab, "Made with ❤️ by AmbaGpt", Color3.fromRGB(255, 150, 200))
CreateLabel(CreditTab, "For: Sayang ❤️", Color3.fromRGB(255, 100, 150))

-- LOOPS
local flyBodyVelocity, flyBodyGyro

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
    -- Fly
    if Config.Fly.Enabled then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            if not flyBodyVelocity or not flyBodyGyro then startFly() end
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

    -- Speed
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

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if Config.InfJump then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end
end)

-- ESP (pakai pcall biar ga crash kalau Drawing ga support)
local espObjects = {}

local function getESPColor(plr)
    if plr.Team and LocalPlayer.Team and plr.Team == LocalPlayer.Team then
        return Config.ESP.TeamColor
    end
    return Config.ESP.EnemyColor
end

local function createESP(plr)
    if plr == LocalPlayer then return end
    local ok = pcall(function()
        local box = Drawing.new("Square")
        box.Visible = false; box.Thickness = 1; box.Filled = false; box.Transparency = 1

        local nameTag = Drawing.new("Text")
        nameTag.Visible = false; nameTag.Size = 14; nameTag.Center = true
        nameTag.Outline = true; nameTag.Font = 2

        local healthBar = Drawing.new("Line")
        healthBar.Visible = false; healthBar.Thickness = 2; healthBar.Transparency = 1

        local distTag = Drawing.new("Text")
        distTag.Visible = false; distTag.Size = 12; distTag.Center = true
        distTag.Outline = true; distTag.Font = 2

        local line = Drawing.new("Line")
        line.Visible = false; line.Thickness = 1; line.Transparency = 1

        espObjects[plr] = { Box = box, Name = nameTag, Health = healthBar, Dist = distTag, Line = line }
    end)
    if not ok then
        warn("[BOLONG HUB] Drawing API tidak support di executor ini")
    end
end

local function removeESP(plr)
    if espObjects[plr] then
        for _, obj in pairs(espObjects[plr]) do
            pcall(function() obj:Remove() end)
        end
        espObjects[plr] = nil
    end
end

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(1)
        if Config.ESP.Enabled then createESP(plr) end
    end)
end)
Players.PlayerRemoving:Connect(removeESP)

RunService.RenderStepped:Connect(function()
    if not Config.ESP.Enabled then
        for _, obj in pairs(espObjects) do
            for _, d in pairs(obj) do
                pcall(function() d.Visible = false end)
            end
        end
        return
    end

    for plr, obj in pairs(espObjects) do
        pcall(function()
            local char = plr.Character
            if not char then
                for _, d in pairs(obj) do d.Visible = false end
                return
            end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hrp or not hum or hum.Health <= 0 then
                for _, d in pairs(obj) do d.Visible = false end
                return
            end

            local distance = (Camera.CFrame.Position - hrp.Position).Magnitude
            local color = getESPColor(plr)
            local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            local visible = distance <= Config.ESP.MaxDistance and onScreen

            if not visible then
                for _, d in pairs(obj) do d.Visible = false end
                return
            end

            -- Box
            if Config.ESP.Box then
                local head = char:FindFirstChild("Head")
                local topPos = head and Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0)) or screenPos
                local bottomPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                local height = math.abs(topPos.Y - bottomPos.Y)
                local width = height / 2
                obj.Box.Size = Vector2.new(width, height)
                obj.Box.Position = Vector2.new(screenPos.X - width / 2, screenPos.Y - height / 2)
                obj.Box.Color = color
                obj.Box.Visible = true
            else
                obj.Box.Visible = false
            end

            -- Name
            if Config.ESP.Name then
                obj.Name.Position = Vector2.new(screenPos.X, screenPos.Y - 40)
                obj.Name.Text = plr.Name
                obj.Name.Color = color
                obj.Name.Visible = true
            else
                obj.Name.Visible = false
            end

            -- Health
            if Config.ESP.Health then
                local head = char:FindFirstChild("Head")
                local topPos = head and Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0)) or screenPos
                local bottomPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                local hpRatio = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                local barX = screenPos.X - (math.abs(topPos.Y - bottomPos.Y) / 2) / 2 - 8
                obj.Health.From = Vector2.new(barX, bottomPos.Y)
                obj.Health.To = Vector2.new(barX, bottomPos.Y - (math.abs(topPos.Y - bottomPos.Y) * hpRatio))
                obj.Health.Color = Color3.fromRGB(math.floor(255 * (1 - hpRatio)), math.floor(255 * hpRatio), 0)
                obj.Health.Visible = true
            else
                obj.Health.Visible = false
            end

            -- Distance
            if Config.ESP.Distance then
                obj.Dist.Position = Vector2.new(screenPos.X, screenPos.Y + 35)
                obj.Dist.Text = "[" .. math.floor(distance) .. "m]"
                obj.Dist.Color = color
                obj.Dist.Visible = true
            else
                obj.Dist.Visible = false
            end

            -- Line
            if Config.ESP.Line then
                obj.Line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                obj.Line.To = Vector2.new(screenPos.X, screenPos.Y)
                obj.Line.Color = color
                obj.Line.Visible = true
            else
                obj.Line.Visible = false
            end
        end)
    end
end)

-- Init ESP existing
for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then createESP(plr) end
end

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    if Config.Speed.Enabled then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = Config.Speed.Value end
    end
end)

-- NOTIF CHAT (biar lu tau script jalan)
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "BOLONG HUB",
    Text = "Script loaded! ❤️",
    Duration = 5,
})

print("[BOLONG HUB] Loaded successfully!")
