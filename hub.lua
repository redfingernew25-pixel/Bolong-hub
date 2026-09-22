--[[
    BOLONG HUB v2.1 - SURVIVAL EDITION
    Author: AmbaGpt for sayang ❤️
    Features: 60+ Fitur aktif semua
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
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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
    AutoDodge = { Enabled = false, Radius = 30 },
    SpeedBurst = { Enabled = false, Duration = 1, Cooldown = 5 },
    Invisible = { Enabled = false, Transparency = 0.9 },
    BunnyHop = { Enabled = false },
    AutoHeal = { Enabled = false, Threshold = 30 },
    ESP = {
        Enabled = false,
        Box = true, Name = true, Health = true,
        Distance = true, Line = true, HeadDot = true,
        KillerTracker = true, ItemESP = true,
        TeamCheck = true,
        EnemyColor = Color3.fromRGB(255, 50, 50),
        TeamColor = Color3.fromRGB(50, 255, 50),
        KillerColor = Color3.fromRGB(255, 0, 0),
        ItemColor = Color3.fromRGB(255, 220, 0),
        MaxDistance = 1000,
    },
    Fullbright = { Enabled = false },
    FOV = { Enabled = false, Value = 70 },
    MapReveal = { Enabled = false },
    KillerAlert = { Enabled = false, Radius = 50 },
    HitboxExpand = false, HitboxSize = 15,
    FOVCircle = false, FOVRadius = 120,
    ClickTP = false,
    TPPTarget = "",
    AntiGrab = { Enabled = false },
}

--==============================================================
-- HELPERS
--==============================================================
local function create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do obj[k] = v end
    return obj
end

local function getChar() return LocalPlayer.Character end
local function getHRP()
    local c = getChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end
local function getHum()
    local c = getChar()
    return c and c:FindFirstChildOfClass("Humanoid")
end

-- Deteksi killer (heuristik umum game survival)
local function isKiller(plr)
    if plr == LocalPlayer then return false end
    -- Cek by name/tag
    local char = plr.Character
    if not char then return false end
    -- Cek Humanoid displayName
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum and (string.lower(hum.DisplayName):find("killer") or string.lower(hum.DisplayName):find("monster") or string.lower(hum.DisplayName):find("hunter")) then
        return true
    end
    -- Cek Team
    if plr.Team and (string.lower(plr.Team.Name):find("killer") or string.lower(plr.Team.Name):find("monster") or string.lower(plr.Team.Name):find("hunter")) then
        return true
    end
    -- Cek nama
    if string.lower(plr.Name):find("killer") then return true end
    -- Cek apakah punya tool khusus killer
    for _, item in pairs(char:GetChildren()) do
        if item:IsA("Tool") or item:IsA("Accessory") then
            if string.lower(item.Name):find("knife") or string.lower(item.Name):find("weapon") or string.lower(item.Name):find("kill") then
                return true
            end
        end
    end
    return false
end

-- Deteksi item di map
local function isItem(obj)
    if not obj:IsA("BasePart") and not obj:IsA("Model") then return false end
    local n = string.lower(obj.Name)
    return n:find("key") or n:find("medkit") or n:find("item") or n:find("pickup") or n:find("coin") or n:find("gem") or n:find("crystal") or n:find("generator") or n:find("fuse") or n:find("battery")
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
    Size = UDim2.new(0, 540, 0, 400),
    Position = UDim2.new(0.5, -270, 0.5, -200),
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
    Text = "⚡ BOLONG HUB v2.1 ⚡",
    TextColor3 = Color3.fromRGB(200, 180, 255),
    TextSize = 18,
    TextXAlignment = Enum.TextXAlignment.Left,
})

-- CLOSE BUTTON
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

-- TAB BAR & CONTENT FRAME (HARUS DI ATAS MIN BTN)
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

-- MINIMIZE BUTTON (FIXED!)
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
local origSize = UDim2.new(0, 540, 0, 400)

MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        TabBar.Visible = false
        ContentFrame.Visible = false
        TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 540, 0, 40)
        }):Play()
        MinBtn.Text = "+"
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
            Size = origSize
        }):Play()
        task.wait(0.25)
        TabBar.Visible = true
        ContentFrame.Visible = true
        MinBtn.Text = "-"
    end
end)

--==============================================================
-- TAB SYSTEM
--==============================================================
local Tabs = {}
local function CreateTab(name, icon)
    local TabBtn = create("TextButton", {
        Parent = TabBar,
        BackgroundColor3 = Color3.fromRGB(35, 30, 55),
        Size = UDim2.new(1, -10, 0, 30),
        Position = UDim2.new(0, 5, 0, 5 + (#Tabs * 35)),
        Font = Enum.Font.Gotham,
        Text = "  " .. icon .. " " .. name,
        TextColor3 = Color3.fromRGB(200, 200, 220),
        TextSize = 12,
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
        Parent = parent, BackgroundTransparency = 1, Size = UDim2.new(1, -10, 0, 22),
        Font = Enum.Font.GothamBold, Text = title,
        TextColor3 = Color3.fromRGB(180, 150, 255), TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
end

local function CreateToggle(parent, text, default, callback)
    local Btn = create("TextButton", {
        Parent = parent, BackgroundColor3 = Color3.fromRGB(30, 28, 45),
        Size = UDim2.new(1, -10, 0, 30), Font = Enum.Font.Gotham, Text = "",
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
        Size = UDim2.new(1, -10, 0, 48),
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
        Size = UDim2.new(1, -20, 0, 8), Position = UDim2.new(0, 10, 0, 28),
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
        Size = UDim2.new(1, -10, 0, 30), Font = Enum.Font.GothamBold,
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
        Parent = parent, BackgroundColor3 = Color3.fromRGB(30, 28, 45),
        Size = UDim2.new(1, -10, 0, 30), Font = Enum.Font.Gotham,
        Text = "", PlaceholderText = placeholder,
        TextColor3 = Color3.fromRGB(220, 220, 240),
        PlaceholderColor3 = Color3.fromRGB(150, 150, 170),
        TextSize = 12, ClearTextOnFocus = false,
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
local SurvivalTab = CreateTab("Survival", "🏃")
local CombatTab = CreateTab("Combat", "⚔️")
local ESPTab = CreateTab("ESP", "👁️")
local TeleportTab = CreateTab("Teleport", "🌐")
local MiscTab = CreateTab("Misc", "⚙️")
local CreditTab = CreateTab("Credit", "💜")

--==============================================================
-- SURVIVAL TAB (Movement + Survival)
--==============================================================
CreateSection(SurvivalTab, "🏃 MOVEMENT")

CreateToggle(SurvivalTab, "Speed Hack", false, function(s)
    Config.Speed.Enabled = s
    local h = getHum()
    if h then h.WalkSpeed = s and Config.Speed.Value or 16 end
end)
CreateSlider(SurvivalTab, "Speed Value", 16, 500, 50, function(v)
    Config.Speed.Value = v
    if Config.Speed.Enabled then
        local h = getHum(); if h then h.WalkSpeed = v end
    end
end)

CreateToggle(SurvivalTab, "Jump Power", false, function(s)
    Config.Jump.Enabled = s
    local h = getHum()
    if h then h.UseJumpPower = true; h.JumpPower = s and Config.Jump.Value or 50 end
end)
CreateSlider(SurvivalTab, "Jump Value", 50, 500, 50, function(v) Config.Jump.Value = v end)

CreateToggle(SurvivalTab, "Infinite Jump", false, function(s) Config.InfJump.Enabled = s end)
CreateToggle(SurvivalTab, "Bunny Hop (auto-jump)", false, function(s) Config.BunnyHop.Enabled = s end)
CreateToggle(SurvivalTab, "Fly Mode", false, function(s) Config.Fly.Enabled = s end)
CreateSlider(SurvivalTab, "Fly Speed", 10, 500, 50, function(v) Config.Fly.Speed = v end)
CreateToggle(SurvivalTab, "Noclip", false, function(s) Config.Noclip.Enabled = s end)

CreateSection(SurvivalTab, "🛡️ SURVIVAL")

CreateToggle(SurvivalTab, "Speed Burst (Dash)", false, function(s)
    Config.SpeedBurst.Enabled = s
end)
CreateButton(SurvivalTab, "💨 DASH NOW (klik)", function()
    local h = getHum()
    if h then
        h.WalkSpeed = 150
        task.wait(Config.SpeedBurst.Duration or 1)
        h.WalkSpeed = Config.Speed.Enabled and Config.Speed.Value or 16
    end
end)
CreateSlider(SurvivalTab, "Burst Duration (s)", 1, 5, 1, function(v) Config.SpeedBurst.Duration = v end)

CreateToggle(SurvivalTab, "Auto Dodge (kabur dari killer)", false, function(s)
    Config.AutoDodge.Enabled = s
end)
CreateSlider(SurvivalTab, "Dodge Radius (stud)", 10, 100, 30, function(v) Config.AutoDodge.Radius = v end)

CreateToggle(SurvivalTab, "Invisible", false, function(s)
    Config.Invisible.Enabled = s
    local c = getChar()
    if c then
        for _, p in pairs(c:GetDescendants()) do
            if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
                p.Transparency = s and Config.Invisible.Transparency or 0
            elseif p:IsA("Decal") then
                p.Transparency = s and Config.Invisible.Transparency or 0
            end
        end
    end
end)
CreateSlider(SurvivalTab, "Invisibility Level", 0.5, 1, 0.9, function(v) Config.Invisible.Transparency = v end)

CreateToggle(SurvivalTab, "Auto Heal (HP < threshold)", false, function(s) Config.AutoHeal.Enabled = s end)
CreateSlider(SurvivalTab, "Heal Threshold", 10, 90, 30, function(v) Config.AutoHeal.Threshold = v end)

CreateButton(SurvivalTab, "Reset Character", function()
    local c = getChar(); if c then c:BreakJoints() end
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
CreateSlider(CombatTab, "Hitbox Size", 5, 50, 15, function(v) Config.HitboxSize = v end)

CreateToggle(CombatTab, "FOV Circle", false, function(s) Config.FOVCircle = s end)
CreateSlider(CombatTab, "FOV Radius", 50, 500, 120, function(v) Config.FOVRadius = v end)

CreateButton(CombatTab, "Unlock FPS (240)", function()
    pcall(function() setfpscap(240) end)
end)

CreateToggle(CombatTab, "Anti-Grab / Anti-Tangkap", false, function(s)
    Config.AntiGrab.Enabled = s
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
CreateToggle(ESPTab, "🎯 Killer Tracker (highlight killer)", true, function(s) Config.ESP.KillerTracker = s end)
CreateToggle(ESPTab, "📦 Item ESP (kunci, medkit, dll)", true, function(s) Config.ESP.ItemESP = s end)
CreateSlider(ESPTab, "Max Distance", 100, 5000, 1000, function(v) Config.ESP.MaxDistance = v end)

CreateSection(ESPTab, "🚨 ALERT")
CreateToggle(ESPTab, "Killer Alert (notif kalau killer deket)", false, function(s) Config.KillerAlert.Enabled = s end)
CreateSlider(ESPTab, "Alert Radius", 20, 200, 50, function(v) Config.KillerAlert.Radius = v end)

--==============================================================
-- TELEPORT TAB
--==============================================================
CreateSection(TeleportTab, "🌐 TELEPORT")

CreateTextBox(TeleportTab, "Masukkan nama player...", function(text) Config.TPPTarget = text end)
CreateButton(TeleportTab, "Teleport ke Player", function()
    if Config.TPPTarget == "" then return end
    local target = Players:FindFirstChild(Config.TPPTarget)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local myHrp = getHRP()
        if myHrp then myHrp.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0) end
    end
end)

CreateToggle(TeleportTab, "Click Teleport (klik map)", false, function(s) Config.ClickTP = s end)
CreateButton(TeleportTab, "TP ke Spawn", function()
    local hrp = getHRP()
    if hrp and workspace:FindFirstChild("SpawnLocation") then
        hrp.CFrame = workspace.SpawnLocation.CFrame + Vector3.new(0, 5, 0)
    end
end)
CreateButton(TeleportTab, "TP ke 0,0,0", function()
    local hrp = getHRP(); if hrp then hrp.CFrame = CFrame.new(0, 50, 0) end
end)
CreateButton(TeleportTab, "Random Teleport", function()
    local hrp = getHRP()
    if hrp then hrp.CFrame = CFrame.new(math.random(-500, 500), 100, math.random(-500, 500)) end
end)

CreateSection(TeleportTab, "📋 PLAYER LIST (tap untuk TP)")
local PlayerListFrame = create("Frame", {
    Parent = TeleportTab,
    BackgroundColor3 = Color3.fromRGB(25, 22, 40),
    Size = UDim2.new(1, -10, 0, 200),
})
create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = PlayerListFrame })
create("UIListLayout", { Parent = PlayerListFrame, Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder })
create("UIPadding", { Parent = PlayerListFrame, PaddingTop = UDim.new(0, 5), PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5) })

local function RefreshPlayerList()
    for _, child in pairs(PlayerListFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    for _, plr in pairs(Players:GetPlayers()) do
        local dist = 0
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            dist = math.floor((Camera.CFrame.Position - plr.Character.HumanoidRootPart.Position).Magnitude)
        end
        local tag = isKiller(plr) and "☠️ " or ""
        local Btn = create("TextButton", {
            Parent = PlayerListFrame, BackgroundColor3 = Color3.fromRGB(50, 40, 80),
            Size = UDim2.new(1, -10, 0, 24), Font = Enum.Font.Gotham,
            Text = tag .. plr.Name .. " (" .. dist .. "m)",
            TextColor3 = isKiller(plr) and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(220, 220, 240),
            TextSize = 11,
        })
        create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = Btn })
        Btn.MouseButton1Click:Connect(function()
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local myHrp = getHRP()
                if myHrp then myHrp.CFrame = plr.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0) end
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

CreateToggle(MiscTab, "Map Reveal (hilangkan fog)", false, function(s)
    Config.MapReveal.Enabled = s
    if s then
        Lighting.FogEnd = 1e6
        Lighting.FogStart = 1e6
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Atmosphere") then obj.Density = 0 end
        end
    end
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
CreateSection(CreditTab, "💜 BOLONG HUB v2.1")
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
    Font = Enum.Font.Gotham, Text = "Survival Edition - 60+ Fitur",
    TextColor3 = Color3.fromRGB(150, 150, 150), TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left,
})

--==============================================================
-- MAIN LOOPS
--==============================================================
local flyBV, flyBG
local function startFly()
    local hrp, hum = getHRP(), getHum()
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
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end

    -- Hitbox
    if Config.HitboxExpand then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.Size = Vector3.new(Config.HitboxSize, Config.HitboxSize, Config.HitboxSize)
                    hrp.Transparency = 0.7
                    hrp.CanCollide = false
                end
            end
        end
    end
end)

-- INFINITE JUMP + BUNNY HOP
UserInputService.JumpRequest:Connect(function()
    if Config.InfJump.Enabled then
        local h = getHum(); if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        if Config.BunnyHop.Enabled then
            local h = getHum()
            if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end
end)

-- AUTO DODGE
task.spawn(function()
    while task.wait(0.2) do
        if Config.AutoDodge.Enabled then
            local myHrp = getHRP()
            if myHrp then
                for _, plr in pairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and isKiller(plr) and plr.Character then
                        local kHrp = plr.Character:FindFirstChild("HumanoidRootPart")
                        if kHrp then
                            local dist = (myHrp.Position - kHrp.Position).Magnitude
                            if dist < Config.AutoDodge.Radius then
                                -- Kabur ke arah berlawanan
                                local dir = (myHrp.Position - kHrp.Position).Unit
                                local target = myHrp.Position + dir * 50
                                myHrp.CFrame = CFrame.new(target)
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- AUTO HEAL
task.spawn(function()
    while task.wait(1) do
        if Config.AutoHeal.Enabled then
            local h = getHum()
            if h and h.Health < Config.AutoHeal.Threshold and h.Health > 0 then
                -- Cari tool heal di backpack
                local bp = LocalPlayer:FindFirstChild("Backpack")
                if bp then
                    for _, tool in pairs(bp:GetChildren()) do
                        if tool:IsA("Tool") and (string.lower(tool.Name):find("med") or string.lower(tool.Name):find("heal") or string.lower(tool.Name):find("bandage")) then
                            tool.Parent = getChar()
                            tool:Activate()
                            break
                        end
                    end
                end
            end
        end
    end
end)

-- KILLER ALERT
task.spawn(function()
    while task.wait(1.5) do
        if Config.KillerAlert.Enabled then
            local myHrp = getHRP()
            if myHrp then
                for _, plr in pairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and isKiller(plr) and plr.Character then
                        local kHrp = plr.Character:FindFirstChild("HumanoidRootPart")
                        if kHrp and (myHrp.Position - kHrp.Position).Magnitude < Config.KillerAlert.Radius then
                            StarterGui:SetCore("SendNotification", {
                                Title = "🚨 KILLER ALERT 🚨",
                                Text = plr.Name .. " dalam radius " .. Config.KillerAlert.Radius .. " stud!",
                                Duration = 2,
                            })
                        end
                    end
                end
            end
        end
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
            if hrp then hrp.CFrame = CFrame.new(result.Position + Vector3.new(0, 3, 0)) end
        end
    end
end)

-- ANTI-AFK
task.spawn(function()
    while task.wait(60) do
        if Config.AntiAFK.Enabled then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton1(Vector2.new())
            end)
        end
    end
end)

-- ANTI-GRAB
task.spawn(function()
    while task.wait(0.5) do
        if Config.AntiGrab.Enabled then
            local c = getChar()
            if c then
                local hrp = c:FindFirstChild("HumanoidRootPart")
                if hrp then
                    -- Hapus constraint grab
                    for _, obj in pairs(hrp:GetChildren()) do
                        if obj:IsA("WeldConstraint") or obj:IsA("Weld") or obj:IsA("RopeConstraint") then
                            obj:Destroy()
                        end
                    end
                end
            end
        end
    end
end)

-- FOV CIRCLE
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
            fovCircle.Radius = Config.FOVRadius
        else
            fovCircle.Visible = false
        end
    end
end)

--==============================================================
-- ESP SYSTEM (Player + Killer + Item)
--==============================================================
local espObjs = {}
local itemESPObjs = {}

local function getESPColor(plr)
    if isKiller(plr) and Config.ESP.KillerTracker then return Config.ESP.KillerColor end
    if plr.Team and LocalPlayer.Team and plr.Team == LocalPlayer.Team then return Config.ESP.TeamColor end
    return Config.ESP.EnemyColor
end

local function createESP(plr)
    if plr == LocalPlayer then return end
    if espObjs[plr] then return end
    pcall(function()
        local box = Drawing.new("Square"); box.Visible = false; box.Thickness = 1; box.Filled = false; box.Transparency = 1
        local nameTag = Drawing.new("Text"); nameTag.Visible = false; nameTag.Size = 14; nameTag.Center = true; nameTag.Outline = true; nameTag.Font = 2
        local healthBar = Drawing.new("Line"); healthBar.Visible = false; healthBar.Thickness = 2; healthBar.Transparency = 1
        local distTag = Drawing.new("Text"); distTag.Visible = false; distTag.Size = 12; distTag.Center = true; distTag.Outline = true; distTag.Font = 2
        local line = Drawing.new("Line"); line.Visible = false; line.Thickness = 1; line.Transparency = 1
        local headDot = Drawing.new("Circle"); headDot.Visible = false; headDot.Thickness = 1; headDot.Filled = true; headDot.NumSides = 12; headDot.Transparency = 1
        espObjs[plr] = { Box = box, Name = nameTag, Health = healthBar, Dist = distTag, Line = line, HeadDot = headDot }
    end)
end

local function removeESP(plr)
    if espObjs[plr] then
        for _, o in pairs(espObjs[plr]) do pcall(function() o:Remove() end) end
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
        for _, o in pairs(itemESPObjs) do
            for _, d in pairs(o) do pcall(function() d.Visible = false end) end
        end
        return
    end

    -- Player ESP
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

            if Config.ESP.Box then
                o.Box.Size = Vector2.new(wdt, hgt)
                o.Box.Position = Vector2.new(sp.X - wdt / 2, sp.Y - hgt / 2)
                o.Box.Color = col
                o.Box.Visible = true
            else o.Box.Visible = false end

            if Config.ESP.Name then
                o.Name.Position = Vector2.new(sp.X, sp.Y - 40)
                o.Name.Text = (isKiller(plr) and "☠️ " or "") .. plr.Name
                o.Name.Color = col
                o.Name.Visible = true
            else o.Name.Visible = false end

            if Config.ESP.Health then
                local hpR = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                local barX = sp.X - wdt / 2 - 8
                o.Health.From = Vector2.new(barX, botP.Y)
                o.Health.To = Vector2.new(barX, botP.Y - (hgt * hpR))
                o.Health.Color = Color3.fromRGB(math.floor(255 * (1 - hpR)), math.floor(255 * hpR), 0)
                o.Health.Visible = true
            else o.Health.Visible = false end

            if Config.ESP.Distance then
                o.Dist.Position = Vector2.new(sp.X, sp.Y + 35)
                o.Dist.Text = "[" .. math.floor(dist) .. "m]"
                o.Dist.Color = col
                o.Dist.Visible = true
            else o.Dist.Visible = false end

            if Config.ESP.Line then
                o.Line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                o.Line.To = Vector2.new(sp.X, sp.Y)
                o.Line.Color = col
                o.Line.Visible = true
            else o.Line.Visible = false end

            if Config.ESP.HeadDot and head then
                local hp = Camera:WorldToViewportPoint(head.Position)
                o.HeadDot.Position = Vector2.new(hp.X, hp.Y)
                o.HeadDot.Radius = 4
                o.HeadDot.Color = col
                o.HeadDot.Visible = true
            else o.HeadDot.Visible = false end
        end)
    end

    -- ITEM ESP
    if Config.ESP.ItemESP then
        for _, obj in pairs(workspace:GetDescendants()) do
            if isItem(obj) then
                local pos
                if obj:IsA("BasePart") then pos = obj.Position
                elseif obj:IsA("Model") and obj.PrimaryPart then pos = obj.PrimaryPart.Position
                elseif obj:IsA("Model") then
                    local p = obj:FindFirstChildWhichIsA("BasePart")
                    if p then pos = p.Position end
                end
                if pos then
                    if not itemESPObjs[obj] then
                        pcall(function()
                            local tag = Drawing.new("Text")
                            tag.Visible = false; tag.Size = 12; tag.Center = true; tag.Outline = true; tag.Font = 2
                            itemESPObjs[obj] = { Tag = tag }
                        end)
                    end
                    local t = itemESPObjs[obj]
                    if t then
                        local sp, onScr = Camera:WorldToViewportPoint(pos)
                        local dist = (Camera.CFrame.Position - pos).Magnitude
                        if onScr and dist < Config.ESP.MaxDistance then
                            t.Tag.Position = Vector2.new(sp.X, sp.Y)
                            t.Tag.Text = "📦 " .. obj.Name .. " [" .. math.floor(dist) .. "m]"
                            t.Tag.Color = Config.ESP.ItemColor
                            t.Tag.Visible = true
                        else
                            t.Tag.Visible = false
                        end
                    end
                end
            end
        end
    else
        for _, o in pairs(itemESPObjs) do
            for _, d in pairs(o) do pcall(function() d.Visible = false end) end
        end
    end
end)

-- Init
for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then createESP(plr) end
end

--==============================================================
-- NOTIF LOAD
--==============================================================
StarterGui:SetCore("SendNotification", {
    Title = "⚡ BOLONG HUB v2.1",
    Text = "Survival Edition loaded! 60+ fitur ❤️",
    Duration = 5,
})

print("[BOLONG HUB v2.1] Loaded successfully!")
print("[BOLONG HUB] Repo: redfingernew25-pixel/Bolong-hub")
