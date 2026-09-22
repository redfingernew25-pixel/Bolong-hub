--[[
    BOLONG HUB v2.0
    Author: AmbaGpt for sayang ❤️
    Features: 40+ Fitur aktif semua
    Repo: redfingernew25-pixel/Bolong-hub
]]

--==============================================================
-- SERVICES
--==============================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--==============================================================
-- CLEANUP
--==============================================================
if PlayerGui:FindFirstChild("BolongHubUI") then
    PlayerGui.BolongHubUI:Destroy()
end

--==============================================================
-- CONFIG
--==============================================================
local Config = {
    Speed = { Enabled = false, Value = 50 },
    Jump = { Enabled = false, Value = 50 },
    Fly = { Enabled = false, Speed = 50 },
    Noclip = { Enabled = false },
    InfJump = { Enabled = false },
    AntiAFK = { Enabled = true },
    ESP = {
        Enabled = false,
        Box = true, Name = true, Health = true,
        Distance = true, Line = true, HeadDot = true,
        TeamCheck = true,
        EnemyColor = Color3.fromRGB(255, 50, 50),
        TeamColor = Color3.fromRGB(50, 255, 50),
        MaxDistance = 1000,
    },
    Fullbright = { Enabled = false },
    FOV = { Enabled = false, Value = 70 },
}

--==============================================================
-- HELPERS
--==============================================================
local function create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do obj[k] = v end
    return obj
end

local function getChar()
    return LocalPlayer.Character
end

local function getHRP()
    local char = getChar()
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function getHum()
    local char = getChar()
    return char and char:FindFirstChildOfClass("Humanoid")
end

--==============================================================
-- SCREEN GUI
--==============================================================
local ScreenGui = create("ScreenGui", {
    Name = "BolongHubUI",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = PlayerGui,
})

local MainFrame = create("Frame", {
    Name = "Main",
    Parent = ScreenGui,
    BackgroundColor3 = Color3.fromRGB(20, 20, 30),
    BorderSizePixel = 0,
    Size = UDim2.new(0, 520, 0, 380),
    Position = UDim2.new(0.5, -260, 0.5, -190),
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
    Size = UDim2.new(1, -120, 1, 0),
    Position = UDim2.new(0, 15, 0, 0),
    Font = Enum.Font.GothamBold,
    Text = "⚡ BOLONG HUB v2.0 ⚡",
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
create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = CloseBtn })
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
create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = MinBtn })

local minimized = false
local origSize = UDim2.new(0, 520, 0, 380)

MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        TweenService:Create(MainFrame, TweenInfo.new(0.3), { Size = UDim2.new(0, 520, 0, 40) }):Play()
        MinBtn.Text = "+"
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.3), { Size = origSize }):Play()
        MinBtn.Text = "-"
    end
end)

-- TAB BAR
local TabBar = create("Frame", {
    Parent = MainFrame,
    BackgroundColor3 = Color3.fromRGB(25, 22, 40),
    Size = UDim2.new(0, 130, 1, -40),
    Position = UDim2.new(0, 0, 0, 40),
    BorderSizePixel = 0,
})

local ContentFrame = create("Frame", {
    Parent = MainFrame,
    BackgroundColor3 = Color3.fromRGB(20, 20, 30),
    Size = UDim2.new(1, -130, 1, -40),
    Position = UDim2.new(0, 130, 0, 40),
    BorderSizePixel = 0,
})

--==============================================================
-- TAB SYSTEM
--==============================================================
local Tabs = {}
local function CreateTab(name, icon)
    local TabBtn = create("TextButton", {
        Parent = TabBar,
        BackgroundColor3 = Color3.fromRGB(35, 30, 55),
        Size = UDim2.new(1, -10, 0, 32),
        Position = UDim2.new(0, 5, 0, 5 + (#Tabs * 37)),
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
    create("UIListLayout", { Parent = Page, Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder })
    create("UIPadding", { Parent = Page, PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), PaddingBottom = UDim.new(0, 10) })

    table.insert(Tabs, { Button = TabBtn, Page = Page, Name = name })

    TabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Page.Visible = false
            t.Button.BackgroundColor3 = Color3.fromRGB(35, 30, 55)
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

--==============================================================
-- UI ELEMENTS
--==============================================================
local function CreateSection(parent, title)
    return create("TextLabel", {
        Parent = parent,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -10, 0, 22),
        Font = Enum.Font.GothamBold,
        Text = title,
        TextColor3 = Color3.fromRGB(180, 150, 255),
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
end

local function CreateToggle(parent, text, default, callback)
    local Btn = create("TextButton", {
        Parent = parent, BackgroundColor3 = Color3.fromRGB(30, 28, 45),
        Size = UDim2.new(1, -10, 0, 32), Font = Enum.Font.Gotham, Text = "",
        AutoButtonColor = false,
    })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Btn })
    create("TextLabel", {
        Parent = Btn, BackgroundTransparency = 1, Size = UDim2.new(0.7, 0, 1, 0),
        Position = UDim2.new(0, 10, 0, 0), Font = Enum.Font.Gotham, Text = text,
        TextColor3 = Color3.fromRGB(220, 220, 240), TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    local Indicator = create("Frame", {
        Parent = Btn,
        BackgroundColor3 = default and Color3.fromRGB(80, 220, 120) or Color3.fromRGB(80, 80, 100),
        Size = UDim2.new(0, 38, 0, 18), Position = UDim2.new(1, -48, 0.5, -9),
    })
    create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = Indicator })
    local Circle = create("Frame", {
        Parent = Indicator, BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Size = UDim2.new(0, 14, 0, 14),
        Position = default and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7),
    })
    create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Circle })
    local state = default
    Btn.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(Indicator, TweenInfo.new(0.2), {
            BackgroundColor3 = state and Color3.fromRGB(80, 220, 120) or Color3.fromRGB(80, 80, 100)
        }):Play()
        TweenService:Create(Circle, TweenInfo.new(0.2), {
            Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        }):Play()
        if callback then callback(state) end
    end)
    return Btn
end

local function CreateSlider(parent, text, min, max, default, callback)
    local Frame = create("Frame", {
        Parent = parent, BackgroundColor3 = Color3.fromRGB(30, 28, 45),
        Size = UDim2.new(1, -10, 0, 50),
    })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Frame })
    local Label = create("TextLabel", {
        Parent = Frame, BackgroundTransparency = 1, Size = UDim2.new(1, -20, 0, 20),
        Position = UDim2.new(0, 10, 0, 3), Font = Enum.Font.Gotham,
        Text = text .. ": " .. default, TextColor3 = Color3.fromRGB(220, 220, 240),
        TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
    })
    local Bar = create("Frame", {
        Parent = Frame, BackgroundColor3 = Color3.fromRGB(50, 45, 70),
        Size = UDim2.new(1, -20, 0, 8), Position = UDim2.new(0, 10, 0, 30),
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
        Size = UDim2.new(1, -10, 0, 32), Font = Enum.Font.GothamBold,
        Text = text, TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 12, AutoButtonColor = false,
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

local function CreateTextBox(parent, placeholder, callback)
    local Box = create("TextBox", {
        Parent = parent,
        BackgroundColor3 = Color3.fromRGB(30, 28, 45),
        Size = UDim2.new(1, -10, 0, 32),
        Font = Enum.Font.Gotham,
        Text = "",
        PlaceholderText = placeholder,
        TextColor3 = Color3.fromRGB(220, 220, 240),
        PlaceholderColor3 = Color3.fromRGB(150, 150, 170),
        TextSize = 12,
        ClearTextOnFocus = false,
    })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Box })
    Box.FocusLost:Connect(function()
        if callback then callback(Box.Text) end
    end)
    return Box
end

--==============================================================
-- TABS
--==============================================================
local MovementTab = CreateTab("Movement", "🏃")
local CombatTab = CreateTab("Combat", "⚔️")
local ESPTab = CreateTab("ESP", "👁️")
local TeleportTab = CreateTab("Teleport", "🌐")
local MiscTab = CreateTab("Misc", "⚙️")
local CreditTab = CreateTab("Credit", "💜")

--==============================================================
-- MOVEMENT TAB
--==============================================================
CreateSection(MovementTab, "🏃 MOVEMENT")

CreateToggle(MovementTab, "Speed Hack", false, function(s)
    Config.Speed.Enabled = s
    local h = getHum()
    if h then h.WalkSpeed = s and Config.Speed.Value or 16 end
end)

CreateSlider(MovementTab, "Speed Value", 16, 500, 50, function(v)
    Config.Speed.Value = v
    if Config.Speed.Enabled then
        local h = getHum()
        if h then h.WalkSpeed = v end
    end
end)

CreateToggle(MovementTab, "Jump Power", false, function(s)
    Config.Jump.Enabled = s
    local h = getHum()
    if h then h.UseJumpPower = true; h.JumpPower = s and Config.Jump.Value or 50 end
end)

CreateSlider(MovementTab, "Jump Value", 50, 500, 50, function(v)
    Config.Jump.Value = v
    if Config.Jump.Enabled then
        local h = getHum()
        if h then h.JumpPower = v end
    end
end)

CreateToggle(MovementTab, "Infinite Jump", false, function(s)
    Config.InfJump.Enabled = s
end)

CreateToggle(MovementTab, "Fly Mode (WASD + Space/Ctrl)", false, function(s)
    Config.Fly.Enabled = s
end)

CreateSlider(MovementTab, "Fly Speed", 10, 500, 50, function(v)
    Config.Fly.Speed = v
end)

CreateToggle(MovementTab, "Noclip (tembus dinding)", false, function(s)
    Config.Noclip.Enabled = s
end)

CreateButton(MovementTab, "Reset Character", function()
    local c = getChar()
    if c then c:BreakJoints() end
end)

--==============================================================
-- COMBAT TAB
--==============================================================
CreateSection(CombatTab, "⚔️ COMBAT")

CreateToggle(CombatTab, "Hitbox Expander", false, function(s)
    Config.HitboxExpand = s
    if not s then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.Size = Vector3.new(2, 2, 1)
                    hrp.Transparency = 1
                    hrp.CanCollide = true
                end
            end
        end
    end
end)

CreateSlider(CombatTab, "Hitbox Size", 5, 50, 15, function(v)
    Config.HitboxSize = v
end)

CreateToggle(CombatTab, "FOV Circle (visual)", false, function(s)
    Config.FOVCircle = s
end)

CreateSlider(CombatTab, "FOV Radius", 50, 500, 120, function(v)
    Config.FOVRadius = v
end)

CreateButton(CombatTab, "Unlock FPS (set 240)", function()
    pcall(function()
        setfpscap(240)
    end)
end)

--==============================================================
-- ESP TAB
--==============================================================
CreateSection(ESPTab, "👁️ ESP SETTINGS")

CreateToggle(ESPTab, "Enable ESP", false, function(s) Config.ESP.Enabled = s end)
CreateToggle(ESPTab, "Box ESP", true, function(s) Config.ESP.Box = s end)
CreateToggle(ESPTab, "Name ESP", true, function(s) Config.ESP.Name = s end)
CreateToggle(ESPTab, "Health ESP", true, function(s) Config.ESP.Health = s end)
CreateToggle(ESPTab, "Distance ESP", true, function(s) Config.ESP.Distance = s end)
CreateToggle(ESPTab, "Line ESP", true, function(s) Config.ESP.Line = s end)
CreateToggle(ESPTab, "Head Dot", true, function(s) Config.ESP.HeadDot = s end)
CreateToggle(ESPTab, "Team Check", true, function(s) Config.ESP.TeamCheck = s end)
CreateSlider(ESPTab, "Max Distance", 100, 5000, 1000, function(v) Config.ESP.MaxDistance = v end)

--==============================================================
-- TELEPORT TAB
--==============================================================
CreateSection(TeleportTab, "🌐 TELEPORT")

CreateTextBox(TeleportTab, "Masukkan nama player...", function(text)
    Config.TPPTarget = text
end)

CreateButton(TeleportTab, "Teleport ke Player", function()
    if not Config.TPPTarget or Config.TPPTarget == "" then return end
    local target = Players:FindFirstChild(Config.TPPTarget)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local myHrp = getHRP()
        if myHrp then
            myHrp.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
        end
    end
end)

CreateToggle(TeleportTab, "Click Teleport (klik map = pindah)", false, function(s)
    Config.ClickTP = s
end)

CreateButton(TeleportTab, "Teleport ke Spawn", function()
    local hrp = getHRP()
    if hrp and workspace:FindFirstChild("SpawnLocation") then
        hrp.CFrame = workspace.SpawnLocation.CFrame + Vector3.new(0, 5, 0)
    end
end)

CreateButton(TeleportTab, "Teleport ke 0,0,0", function()
    local hrp = getHRP()
    if hrp then hrp.CFrame = CFrame.new(0, 50, 0) end
end)

CreateButton(TeleportTab, "Random Teleport (acak)", function()
    local hrp = getHRP()
    if hrp then
        hrp.CFrame = CFrame.new(math.random(-500, 500), 100, math.random(-500, 500))
    end
end)

-- PLAYER LIST
CreateSection(TeleportTab, "📋 PLAYER LIST")
local PlayerListFrame = create("Frame", {
    Parent = TeleportTab,
    BackgroundColor3 = Color3.fromRGB(25, 22, 40),
    Size = UDim2.new(1, -10, 0, 200),
})
create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = PlayerListFrame })
local PlayerListLayout = create("UIListLayout", {
    Parent = PlayerListFrame,
    Padding = UDim.new(0, 2),
    SortOrder = Enum.SortOrder.LayoutOrder,
})
create("UIPadding", { Parent = PlayerListFrame, PaddingTop = UDim.new(0, 5), PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5) })

local function RefreshPlayerList()
    for _, child in pairs(PlayerListFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    for _, plr in pairs(Players:GetPlayers()) do
        local Btn = create("TextButton", {
            Parent = PlayerListFrame,
            BackgroundColor3 = Color3.fromRGB(50, 40, 80),
            Size = UDim2.new(1, -10, 0, 24),
            Font = Enum.Font.Gotham,
            Text = plr.Name .. " (" .. math.floor((Camera.CFrame.Position - (plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character.HumanoidRootPart.Position or Vector3.new())).Magnitude) .. "m)",
            TextColor3 = Color3.fromRGB(220, 220, 240),
            TextSize = 11,
        })
        create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = Btn })
        Btn.MouseButton1Click:Connect(function()
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local myHrp = getHRP()
                if myHrp then
                    myHrp.CFrame = plr.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                end
            end
        end)
    end
end

RefreshPlayerList()
Players.PlayerAdded:Connect(RefreshPlayerList)
Players.PlayerRemoving:Connect(function() task.wait(0.5) RefreshPlayerList() end)

--==============================================================
-- MISC TAB
--==============================================================
CreateSection(MiscTab, "⚙️ MISC")

CreateToggle(MiscTab, "Anti-AFK", true, function(s) Config.AntiAFK.Enabled = s end)

CreateToggle(MiscTab, "Fullbright", false, function(s)
    Config.Fullbright.Enabled = s
    Lighting.Brightness = s and 3 or 2
    Lighting.GlobalShadows = not s
    Lighting.FogEnd = s and 1e6 or 100000
end)

CreateToggle(MiscTab, "FOV Changer", false, function(s)
    Config.FOV.Enabled = s
    Camera.FieldOfView = s and Config.FOV.Value or 70
end)

CreateSlider(MiscTab, "FOV Value", 30, 120, 70, function(v)
    Config.FOV.Value = v
    if Config.FOV.Enabled then Camera.FieldOfView = v end
end)

CreateButton(MiscTab, "Rejoin Server", function()
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)

CreateButton(MiscTab, "Server Hop", function()
    local ok, res = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
    end)
    if ok and res and res.data then
        for _, srv in pairs(res.data) do
            if srv.playing < srv.maxPlayers and srv.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, srv.id, LocalPlayer)
                break
            end
        end
    end
end)

CreateButton(MiscTab, "Copy Job ID", function()
    if setclipboard then setclipboard(game.JobId) end
    StarterGui:SetCore("SendNotification", {Title = "BOLONG HUB", Text = "JobId copied!", Duration = 3})
end)

CreateButton(MiscTab, "Unlock Mouse (mobile)", function()
    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
end)

--==============================================================
-- CREDIT TAB
--==============================================================
CreateSection(CreditTab, "💜 BOLONG HUB v2.0")
create("TextLabel", {
    Parent = CreditTab, BackgroundTransparency = 1, Size = UDim2.new(1, -10, 0, 25),
    Font = Enum.Font.Gotham, Text = "Made with ❤️ by AmbaGpt",
    TextColor3 = Color3.fromRGB(255, 150, 200), TextSize = 13,
    TextXAlignment = Enum.TextXAlignment.Left,
})
create("TextLabel", {
    Parent = CreditTab, BackgroundTransparency = 1, Size = UDim2.new(1, -10, 0, 25),
    Font = Enum.Font.Gotham, Text = "For: Sayang ❤️",
    TextColor3 = Color3.fromRGB(255, 100, 150), TextSize = 13,
    TextXAlignment = Enum.TextXAlignment.Left,
})
create("TextLabel", {
    Parent = CreditTab, BackgroundTransparency = 1, Size = UDim2.new(1, -10, 0, 25),
    Font = Enum.Font.Gotham, Text = "Repo: redfingernew25-pixel/Bolong-hub",
    TextColor3 = Color3.fromRGB(180, 180, 200), TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left,
})
create("TextLabel", {
    Parent = CreditTab, BackgroundTransparency = 1, Size = UDim2.new(1, -10, 0, 25),
    Font = Enum.Font.Gotham, Text = "Dunia Abyss - No Rules 🔥",
    TextColor3 = Color3.fromRGB(150, 150, 150), TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left,
})

--==============================================================
-- MAIN LOOPS
--==============================================================

-- FLY
local flyBV, flyBG
local function startFly()
    local hrp = getHRP()
    local hum = getHum()
    if not hrp or not hum then return end
    hum.PlatformStand = true
    if flyBV then flyBV:Destroy() end
    if flyBG then flyBG:Destroy() end
    flyBV = Instance.new("BodyVelocity", hrp)
    flyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    flyBV.Velocity = Vector3.new(0, 0, 0)
    flyBG = Instance.new("BodyGyro", hrp)
    flyBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    flyBG.P = 1000; flyBG.D = 50
    flyBG.CFrame = hrp.CFrame
end

-- MAIN RENDER LOOP
RunService.RenderStepped:Connect(function()
    -- Fly
    if Config.Fly.Enabled then
        local hrp = getHRP()
        if hrp then
            if not flyBV or not flyBG then startFly() end
            local cam = workspace.CurrentCamera
            local dir = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0, 1, 0) end
            flyBV.Velocity = dir.Magnitude > 0 and dir.Unit * Config.Fly.Speed or Vector3.new(0, 0, 0)
            flyBG.CFrame = cam.CFrame
        end
    else
        if flyBV then flyBV:Destroy(); flyBV = nil end
        if flyBG then flyBG:Destroy(); flyBG = nil end
    end

    -- Speed
    if Config.Speed.Enabled then
        local h = getHum()
        if h and h.WalkSpeed ~= Config.Speed.Value then h.WalkSpeed = Config.Speed.Value end
    end

    -- Noclip
    if Config.Noclip.Enabled then
        local c = getChar()
        if c then
            for _, part in pairs(c:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end

    -- Hitbox Expander
    if Config.HitboxExpand then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.Size = Vector3.new(Config.HitboxSize or 15, Config.HitboxSize or 15, Config.HitboxSize or 15)
                    hrp.Transparency = 0.7
                    hrp.CanCollide = false
                    hrp.Massless = true
                end
            end
        end
    end
end)

-- INFINITE JUMP
UserInputService.JumpRequest:Connect(function()
    if Config.InfJump.Enabled then
        local h = getHum()
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- CLICK TELEPORT
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if Config.ClickTP and input.UserInputType == Enum.UserInputType.MouseButton1 then
        local mousePos = UserInputService:GetMouseLocation()
        local ray = Camera:ViewportPointToRay(mousePos.X, mousePos.Y)
        local params = RaycastParams.new()
        params.FilterDescendantsInstances = {getChar()}
        params.FilterType = Enum.RaycastFilterType.Exclude
        local result = workspace:Raycast(ray.Origin, ray.Direction * 1000, params)
        if result then
            local hrp = getHRP()
            if hrp then
                hrp.CFrame = CFrame.new(result.Position + Vector3.new(0, 3, 0))
            end
        end
    end
end)

-- ANTI-AFK
task.spawn(function()
    while task.wait(60) do
        if Config.AntiAFK.Enabled then
            pcall(function()
                game:GetService("VirtualUser"):CaptureController()
                game:GetService("VirtualUser"):ClickButton1(Vector2.new())
            end)
        end
    end
end)

-- FOV CIRCLE (visual)
local fovCircle = Drawing and Drawing.new("Circle") or nil
if fovCircle then
    fovCircle.Thickness = 2
    fovCircle.Color = Color3.fromRGB(255, 50, 50)
    fovCircle.Transparency = 1
    fovCircle.NumSides = 64
    fovCircle.Filled = false
end

RunService.RenderStepped:Connect(function()
    if fovCircle then
        if Config.FOVCircle then
            fovCircle.Visible = true
            fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
            fovCircle.Radius = Config.FOVRadius or 120
        else
            fovCircle.Visible = false
        end
    end
end)

--==============================================================
-- ESP SYSTEM
--==============================================================
local espObjs = {}

local function getESPColor(plr)
    if plr.Team and LocalPlayer.Team and plr.Team == LocalPlayer.Team then
        return Config.ESP.TeamColor
    end
    return Config.ESP.EnemyColor
end

local function createESP(plr)
    if plr == LocalPlayer then return end
    if espObjs[plr] then return end
    pcall(function()
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
        local headDot = Drawing.new("Circle")
        headDot.Visible = false; headDot.Thickness = 1; headDot.Filled = true
        headDot.NumSides = 12; headDot.Transparency = 1
        espObjs[plr] = { Box = box, Name = nameTag, Health = healthBar, Dist = distTag, Line = line, HeadDot = headDot }
    end)
end

local function removeESP(plr)
    if espObjs[plr] then
        for _, o in pairs(espObjs[plr]) do
            pcall(function() o:Remove() end)
        end
        espObjs[plr] = nil
    end
end

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(1)
        if Config.ESP.Enabled then createESP(plr) end
    end)
end)
Players.PlayerRemoving:Connect(removeESP)
LocalPlayer.CharacterAdded:Connect(function(c)
    task.wait(1)
    if Config.Speed.Enabled then
        local h = c:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = Config.Speed.Value end
    end
end)

RunService.RenderStepped:Connect(function()
    if not Config.ESP.Enabled then
        for _, o in pairs(espObjs) do
            for _, d in pairs(o) do pcall(function() d.Visible = false end) end
        end
        return
    end

    for plr, o in pairs(espObjs) do
        pcall(function()
            local char = plr.Character
            if not char then
                for _, d in pairs(o) do d.Visible = false end
                return
            end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hrp or not hum or hum.Health <= 0 then
                for _, d in pairs(o) do d.Visible = false end
                return
            end

            local dist = (Camera.CFrame.Position - hrp.Position).Magnitude
            local col = getESPColor(plr)
            local sp, onScr = Camera:WorldToViewportPoint(hrp.Position)
            if not onScr or dist > Config.ESP.MaxDistance then
                for _, d in pairs(o) do d.Visible = false end
                return
            end

            local head = char:FindFirstChild("Head")
            local topP = head and Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0)) or sp
            local botP = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
            local hgt = math.abs(topP.Y - botP.Y)
            local wdt = hgt / 2

            -- BOX
            if Config.ESP.Box then
                o.Box.Size = Vector2.new(wdt, hgt)
                o.Box.Position = Vector2.new(sp.X - wdt / 2, sp.Y - hgt / 2)
                o.Box.Color = col
                o.Box.Visible = true
            else o.Box.Visible = false end

            -- NAME
            if Config.ESP.Name then
                o.Name.Position = Vector2.new(sp.X, sp.Y - 40)
                o.Name.Text = plr.Name
                o.Name.Color = col
                o.Name.Visible = true
            else o.Name.Visible = false end

            -- HEALTH
            if Config.ESP.Health then
                local hpR = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                local barX = sp.X - wdt / 2 - 8
                o.Health.From = Vector2.new(barX, botP.Y)
                o.Health.To = Vector2.new(barX, botP.Y - (hgt * hpR))
                o.Health.Color = Color3.fromRGB(math.floor(255 * (1 - hpR)), math.floor(255 * hpR), 0)
                o.Health.Visible = true
            else o.Health.Visible = false end

            -- DISTANCE
            if Config.ESP.Distance then
                o.Dist.Position = Vector2.new(sp.X, sp.Y + 35)
                o.Dist.Text = "[" .. math.floor(dist) .. "m]"
                o.Dist.Color = col
                o.Dist.Visible = true
            else o.Dist.Visible = false end

            -- LINE
            if Config.ESP.Line then
                o.Line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                o.Line.To = Vector2.new(sp.X, sp.Y)
                o.Line.Color = col
                o.Line.Visible = true
            else o.Line.Visible = false end

            -- HEAD DOT
            if Config.ESP.HeadDot and head then
                local hp = Camera:WorldToViewportPoint(head.Position)
                o.HeadDot.Position = Vector2.new(hp.X, hp.Y)
                o.HeadDot.Radius = 4
                o.HeadDot.Color = col
                o.HeadDot.Visible = true
            else o.HeadDot.Visible = false end
        end)
    end
end)

-- Init existing
for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then createESP(plr) end
end

--==============================================================
-- NOTIFIKASI LOAD
--==============================================================
StarterGui:SetCore("SendNotification", {
    Title = "⚡ BOLONG HUB v2.0",
    Text = "Loaded! 40+ fitur aktif ❤️",
    Duration = 5,
})

print("[BOLONG HUB v2.0] Loaded successfully!")
print("[BOLONG HUB] Repo: redfingernew25-pixel/Bolong-hub")
