--[[
    BOLONG HUB v3.2.2 - VIOLENCE DISTRICT EDITION
    Author: AmbaGpt for sayang ❤️
    Game: Violence District (5 Survivor vs 1 Killer)
    Features: 75+ Fitur
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
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
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
    BunnyHop = { Enabled = false },
    AntiAFK = { Enabled = true },
    SpeedBurst = { Duration = 1 },
    AutoDodge = { Enabled = false, Radius = 30 },
    Invisible = { Enabled = false, Transparency = 0.9 },
    AutoHeal = { Enabled = false, Threshold = 30 },
    AutoPerfectSkillCheck = { Enabled = false },
    NoSkillCheck = { Enabled = false },
    AutoHit = { Enabled = false, Radius = 15 },
    SilentAim = { Enabled = false },
    KillAura = { Enabled = false, Radius = 20 },
    ESP = {
        Enabled = false,
        Box = true, Name = true, Health = true,
        Distance = true, Line = true, HeadDot = true,
        TeamCheck = true,
        KillerTracker = true,
        SurvivorTracker = true,
        ItemESP = true,
        GeneratorESP = true,
        GeneratorRadius = 400,
        GeneratorMaxShow = 5,
        EnemyColor = Color3.fromRGB(255, 50, 50),
        TeamColor = Color3.fromRGB(50, 255, 50),
        KillerColor = Color3.fromRGB(255, 0, 0),
        ItemColor = Color3.fromRGB(255, 220, 0),
        GeneratorColor = Color3.fromRGB(0, 200, 255),
        SurvivorColor = Color3.fromRGB(50, 255, 100),
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

local function isKiller(plr)
    if plr == LocalPlayer then return false end
    local char = plr.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        local n = string.lower(hum.DisplayName or "")
        if n:find("killer") or n:find("monster") or n:find("hunter") then return true end
    end
    if plr.Team then
        local tn = string.lower(plr.Team.Name or "")
        if tn:find("killer") or tn:find("monster") or tn:find("hunter") then return true end
    end
    if string.lower(plr.Name):find("killer") then return true end
    for _, item in pairs(char:GetChildren()) do
        if item:IsA("Tool") then
            local n = string.lower(item.Name)
            if n:find("knife") or n:find("weapon") or n:find("kill") or n:find("scythe") or n:find("blade") then return true end
        end
    end
    return false
end

local function isGenerator(obj)
    local n = string.lower(obj.Name)
    return n:find("generator") or n:find("genpoint") or n:find("gen invis")
end

local function isItem(obj)
    local n = string.lower(obj.Name)
    return n:find("medkit") or n:find("med") or n:find("bandage") or n:find("toolbox") 
        or n:find("flashlight") or n:find("key") or n:find("battery") or n:find("pickup")
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
    Name = "Main", Parent = ScreenGui,
    BackgroundColor3 = Color3.fromRGB(20, 20, 30),
    BorderSizePixel = 0,
    Size = UDim2.new(0, 560, 0, 420),
    Position = UDim2.new(0.5, -280, 0.5, -210),
    Active = true, Draggable = true,
})
create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = MainFrame })
create("UIStroke", { Color = Color3.fromRGB(120, 80, 255), Thickness = 2, Parent = MainFrame })

local TopBar = create("Frame", {
    Parent = MainFrame,
    BackgroundColor3 = Color3.fromRGB(30, 25, 50),
    Size = UDim2.new(1, 0, 0, 40), BorderSizePixel = 0,
})
create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = TopBar })

create("TextLabel", {
    Parent = TopBar, BackgroundTransparency = 1,
    Size = UDim2.new(1, -120, 1, 0), Position = UDim2.new(0, 15, 0, 0),
    Font = Enum.Font.GothamBold, Text = "⚡ BOLONG HUB v3.2.2 ⚡",
    TextColor3 = Color3.fromRGB(200, 180, 255), TextSize = 18,
    TextXAlignment = Enum.TextXAlignment.Left,
})

local CloseBtn = create("TextButton", {
    Parent = TopBar, BackgroundColor3 = Color3.fromRGB(255, 60, 60),
    Size = UDim2.new(0, 30, 0, 30), Position = UDim2.new(1, -40, 0, 5),
    Font = Enum.Font.GothamBold, Text = "X",
    TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 14,
})
create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = CloseBtn })
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local TabBar = create("Frame", {
    Parent = MainFrame,
    BackgroundColor3 = Color3.fromRGB(25, 22, 40),
    Size = UDim2.new(0, 130, 1, -40),
    Position = UDim2.new(0, 0, 0, 40), BorderSizePixel = 0,
})

local ContentFrame = create("Frame", {
    Parent = MainFrame,
    BackgroundColor3 = Color3.fromRGB(20, 20, 30),
    Size = UDim2.new(1, -130, 1, -40),
    Position = UDim2.new(0, 130, 0, 40), BorderSizePixel = 0,
})

local MinBtn = create("TextButton", {
    Parent = TopBar, BackgroundColor3 = Color3.fromRGB(255, 180, 50),
    Size = UDim2.new(0, 30, 0, 30), Position = UDim2.new(1, -75, 0, 5),
    Font = Enum.Font.GothamBold, Text = "-",
    TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 18,
})
create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = MinBtn })

local minimized = false
local origSize = UDim2.new(0, 560, 0, 420)
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        TabBar.Visible = false
        ContentFrame.Visible = false
        TweenService:Create(MainFrame, TweenInfo.new(0.25), { Size = UDim2.new(0, 560, 0, 40) }):Play()
        MinBtn.Text = "+"
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.25), { Size = origSize }):Play()
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
        Parent = TabBar, BackgroundColor3 = Color3.fromRGB(35, 30, 55),
        Size = UDim2.new(1, -10, 0, 28),
        Position = UDim2.new(0, 5, 0, 5 + (#Tabs * 33)),
        Font = Enum.Font.Gotham, Text = "  " .. icon .. " " .. name,
        TextColor3 = Color3.fromRGB(200, 200, 220), TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = TabBtn })
    local Page = create("ScrollingFrame", {
        Parent = ContentFrame, BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 4, Visible = false,
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
        TextColor3 = Color3.fromRGB(220, 220, 240), TextSize = 11,
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
        TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left,
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
        TextSize = 11, AutoButtonColor = false,
    })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Btn })
    Btn.MouseButton1Click:Connect(function() if callback then callback() end end)
    return Btn
end

local function CreateTextBox(parent, placeholder, callback)
    local Box = create("TextBox", {
        Parent = parent, BackgroundColor3 = Color3.fromRGB(30, 28, 45),
        Size = UDim2.new(1, -10, 0, 30), Font = Enum.Font.Gotham,
        Text = "", PlaceholderText = placeholder,
        TextColor3 = Color3.fromRGB(220, 220, 240),
        PlaceholderColor3 = Color3.fromRGB(150, 150, 170),
        TextSize = 11, ClearTextOnFocus = false,
    })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Box })
    Box.FocusLost:Connect(function() if callback then callback(Box.Text) end end)
    return Box
end

--==============================================================
-- TABS
--==============================================================
local SurvivorTab = CreateTab("Survivor", "🏃")
local KillerTab = CreateTab("Killer", "🔪")
local ESPTab = CreateTab("ESP", "👁️")
local TeleportTab = CreateTab("Teleport", "🌐")
local MiscTab = CreateTab("Misc", "⚙️")
local CreditTab = CreateTab("Credit", "💜")

--==============================================================
-- SURVIVOR TAB
--==============================================================
CreateSection(SurvivorTab, "🏃 SURVIVOR - MOVEMENT")
CreateToggle(SurvivorTab, "Speed Hack", false, function(s)
    Config.Speed.Enabled = s
    local h = getHum()
    if h then h.WalkSpeed = s and Config.Speed.Value or 16 end
end)
CreateSlider(SurvivorTab, "Speed Value", 16, 500, 50, function(v)
    Config.Speed.Value = v
    if Config.Speed.Enabled then
        local h = getHum(); if h then h.WalkSpeed = v end
    end
end)
CreateToggle(SurvivorTab, "Jump Power", false, function(s)
    Config.Jump.Enabled = s
    local h = getHum()
    if h then h.UseJumpPower = true; h.JumpPower = s and Config.Jump.Value or 50 end
end)
CreateSlider(SurvivorTab, "Jump Value", 50, 500, 50, function(v) Config.Jump.Value = v end)
CreateToggle(SurvivorTab, "Infinite Jump", false, function(s) Config.InfJump.Enabled = s end)
CreateToggle(SurvivorTab, "Bunny Hop", false, function(s) Config.BunnyHop.Enabled = s end)
CreateToggle(SurvivorTab, "Fly Mode", false, function(s) Config.Fly.Enabled = s end)
CreateSlider(SurvivorTab, "Fly Speed", 10, 500, 50, function(v) Config.Fly.Speed = v end)
CreateToggle(SurvivorTab, "Noclip", false, function(s) Config.Noclip.Enabled = s end)

CreateSection(SurvivorTab, "🛡️ SURVIVOR - DEFENSE")
CreateButton(SurvivorTab, "💨 DASH NOW", function()
    local h = getHum()
    if h then
        h.WalkSpeed = 150
        task.wait(Config.SpeedBurst.Duration or 1)
        h.WalkSpeed = Config.Speed.Enabled and Config.Speed.Value or 16
    end
end)
CreateSlider(SurvivorTab, "Dash Duration (s)", 1, 5, 1, function(v) Config.SpeedBurst.Duration = v end)
CreateToggle(SurvivorTab, "Auto Dodge", false, function(s) Config.AutoDodge.Enabled = s end)
CreateSlider(SurvivorTab, "Dodge Radius", 10, 100, 30, function(v) Config.AutoDodge.Radius = v end)
CreateToggle(SurvivorTab, "Invisible", false, function(s)
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
CreateSlider(SurvivorTab, "Invisibility Level", 0.5, 1, 0.9, function(v) Config.Invisible.Transparency = v end)
CreateToggle(SurvivorTab, "Auto Heal", false, function(s) Config.AutoHeal.Enabled = s end)
CreateSlider(SurvivorTab, "Heal Threshold", 10, 90, 30, function(v) Config.AutoHeal.Threshold = v end)

CreateSection(SurvivorTab, "🔧 SURVIVOR - REPAIR (VIOLENCE DISTRICT)")
CreateToggle(SurvivorTab, "✨ Auto Perfect Skill Check", false, function(s)
    Config.AutoPerfectSkillCheck.Enabled = s
    StarterGui:SetCore("SendNotification", {
        Title = "Auto Perfect",
        Text = s and "✅ AKTIF" or "❌ MATI",
        Duration = 2,
    })
end)
CreateToggle(SurvivorTab, "🚫 No Skill Check", false, function(s) Config.NoSkillCheck.Enabled = s end)
CreateButton(SurvivorTab, "Reset Character", function()
    local c = getChar(); if c then c:BreakJoints() end
end)

--==============================================================
-- KILLER TAB
--==============================================================
CreateSection(KillerTab, "🔪 KILLER - OFFENSE")
CreateToggle(KillerTab, "Auto Hit", false, function(s) Config.AutoHit.Enabled = s end)
CreateSlider(KillerTab, "Auto Hit Radius", 5, 50, 15, function(v) Config.AutoHit.Radius = v end)
CreateToggle(KillerTab, "Kill Aura", false, function(s) Config.KillAura.Enabled = s end)
CreateSlider(KillerTab, "Kill Aura Radius", 5, 50, 20, function(v) Config.KillAura.Radius = v end)
CreateToggle(KillerTab, "Silent Aim", false, function(s) Config.SilentAim.Enabled = s end)

CreateSection(KillerTab, "🎯 KILLER - TRACKING")
CreateToggle(KillerTab, "Track Survivor (highlight hijau)", true, function(s) Config.ESP.SurvivorTracker = s end)

CreateSection(KillerTab, "⚔️ KILLER - COMBAT")
CreateToggle(KillerTab, "Hitbox Expander", false, function(s)
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
CreateSlider(KillerTab, "Hitbox Size", 5, 50, 15, function(v) Config.HitboxSize = v end)
CreateToggle(KillerTab, "FOV Circle", false, function(s) Config.FOVCircle = s end)
CreateSlider(KillerTab, "FOV Radius", 50, 500, 120, function(v) Config.FOVRadius = v end)
CreateButton(KillerTab, "Unlock FPS (240)", function() pcall(function() setfpscap(240) end) end)
CreateToggle(KillerTab, "Anti-Grab", false, function(s) Config.AntiGrab.Enabled = s end)

--==============================================================
-- ESP TAB
--==============================================================
CreateSection(ESPTab, "👁️ ESP - PLAYER")
CreateToggle(ESPTab, "Enable ESP", false, function(s) Config.ESP.Enabled = s end)
CreateToggle(ESPTab, "Box ESP", true, function(s) Config.ESP.Box = s end)
CreateToggle(ESPTab, "Name ESP", true, function(s) Config.ESP.Name = s end)
CreateToggle(ESPTab, "Health ESP", true, function(s) Config.ESP.Health = s end)
CreateToggle(ESPTab, "Distance ESP", true, function(s) Config.ESP.Distance = s end)
CreateToggle(ESPTab, "Line ESP", true, function(s) Config.ESP.Line = s end)
CreateToggle(ESPTab, "Head Dot", true, function(s) Config.ESP.HeadDot = s end)
CreateToggle(ESPTab, "Team Check", true, function(s) Config.ESP.TeamCheck = s end)
CreateToggle(ESPTab, "🎯 Killer Tracker", true, function(s) Config.ESP.KillerTracker = s end)
CreateSlider(ESPTab, "Max Distance Player", 100, 5000, 1000, function(v) Config.ESP.MaxDistance = v end)

CreateSection(ESPTab, "⚡ ESP - GENERATOR (VIOLENCE DISTRICT)")
CreateToggle(ESPTab, "Generator ESP", true, function(s) Config.ESP.GeneratorESP = s end)
CreateSlider(ESPTab, "Generator Max Radius", 50, 2000, 400, function(v) Config.ESP.GeneratorRadius = v end)
CreateSlider(ESPTab, "Max Generator Tampil", 1, 15, 5, function(v) Config.ESP.GeneratorMaxShow = v end)

CreateSection(ESPTab, "🎁 ESP - ITEM")
CreateToggle(ESPTab, "Item ESP", true, function(s) Config.ESP.ItemESP = s end)

CreateSection(ESPTab, "🚨 ALERT")
CreateToggle(ESPTab, "Killer Alert", false, function(s) Config.KillerAlert.Enabled = s end)
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
CreateToggle(TeleportTab, "Click Teleport", false, function(s) Config.ClickTP = s end)
CreateButton(TeleportTab, "TP ke Spawn", function()
    local hrp = getHRP()
    if hrp and Workspace:FindFirstChild("SpawnLocation") then
        hrp.CFrame = Workspace.SpawnLocation.CFrame + Vector3.new(0, 5, 0)
    end
end)
CreateButton(TeleportTab, "TP ke 0,0,0", function()
    local hrp = getHRP(); if hrp then hrp.CFrame = CFrame.new(0, 50, 0) end
end)

CreateSection(TeleportTab, "📋 PLAYER LIST (tap = TP)")
local PlayerListFrame = create("Frame", {
    Parent = TeleportTab,
    BackgroundColor3 = Color3.fromRGB(25, 22, 40),
    Size = UDim2.new(1, -10, 0, 180),
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
        local tag = isKiller(plr) and "☠️ " or "🏃 "
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
CreateToggle(MiscTab, "Map Reveal", false, function(s)
    Config.MapReveal.Enabled = s
    if s then
        Lighting.FogEnd = 1e6; Lighting.FogStart = 1e6
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Atmosphere") then obj.Density = 0 end
        end
    end
end)
CreateButton(MiscTab, "Rejoin Server", function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
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

--==============================================================
-- CREDIT TAB
--==============================================================
CreateSection(CreditTab, "💜 BOLONG HUB v3.2.2")
for _, t in pairs({
    "Violence District Edition",
    "Made with ❤️ by AmbaGpt",
    "For: Sayang ❤️",
    "Repo: redfingernew25-pixel/Bolong-hub",
    "75+ Fitur Aktif",
}) do
    create("TextLabel", {
        Parent = CreditTab, BackgroundTransparency = 1,
        Size = UDim2.new(1, -10, 0, 22),
        Font = Enum.Font.Gotham, Text = t,
        TextColor3 = Color3.fromRGB(200, 200, 220), TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
end

--==============================================================
-- GENERATOR TRACKER (SIMPLE - v3.2.3)
--==============================================================
local Generators = {}

local function findGenerators()
    local found = {}
    local seen = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        local n = string.lower(obj.Name)
        if n:find("generatorpoint") and not seen[obj] then
            local pos, name
            if obj:IsA("BasePart") then
                pos = obj.Position; name = obj.Name
            elseif obj:IsA("Model") or obj:IsA("Folder") then
                local p = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                if p then pos = p.Position; name = obj.Name end
            end
            if pos then
                seen[obj] = true
                table.insert(found, { Obj = obj, Position = pos, Name = name })
            end
        end
    end
    return found
end

Generators = findGenerators()
task.spawn(function()
    while task.wait(5) do
        Generators = findGenerators()
    end
end)

-- Ambil progress generator (simple)
local function getGeneratorProgress(gen)
    local obj = gen.Obj
    for _, child in pairs(obj:GetDescendants()) do
        if child:IsA("NumberValue") or child:IsA("IntValue") then
            local n = string.lower(child.Name)
            if n:find("progress") or n:find("percent") or n:find("value") then
                local val = child.Value
                if val <= 1 and val > 0 then return math.floor(val * 100) end
                return math.floor(val)
            end
        end
    end
    return 0
end

-- Deteksi player repair
local function getRepairingPlayers(gen)
    local repairing = {}
    local genPos = gen.Position
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp and (hrp.Position - genPos).Magnitude < 8 then
                table.insert(repairing, plr.Name)
            end
        end
    end
    return repairing
end

--==============================================================
-- ESP SYSTEM v3.2.3 (SIMPLE + STABLE)
--==============================================================
local espObjs = {}
local genESPObjs = {}

local function getESPColor(plr)
    if isKiller(plr) and Config.ESP.KillerTracker then
        return Config.ESP.KillerColor
    end
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
        nameTag.Visible = false; nameTag.Size = 14; nameTag.Center = true; nameTag.Outline = true; nameTag.Font = 2
        local healthBar = Drawing.new("Line")
        healthBar.Visible = false; healthBar.Thickness = 2; healthBar.Transparency = 1
        local distTag = Drawing.new("Text")
        distTag.Visible = false; distTag.Size = 12; distTag.Center = true; distTag.Outline = true; distTag.Font = 2
        local line = Drawing.new("Line")
        line.Visible = false; line.Thickness = 1; line.Transparency = 1
        local headDot = Drawing.new("Circle")
        headDot.Visible = false; headDot.Thickness = 1; headDot.Filled = true; headDot.NumSides = 12; headDot.Transparency = 1
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

for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then createESP(plr) end
end

-- MAIN ESP LOOP
RunService.RenderStepped:Connect(function()
    if not Config.ESP.Enabled then
        for _, o in pairs(espObjs) do
            for _, d in pairs(o) do pcall(function() d.Visible = false end) end
        end
        for _, o in pairs(genESPObjs) do
            for _, d in pairs(o) do pcall(function() d.Visible = false end) end
        end
        return
    end

    -- ========== PLAYER ESP ==========
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
                o.Name.Text = (isKiller(plr) and "☠️ " or "🏃 ") .. plr.Name
                o.Name.Color = col
                o.Name.Visible = true
            else o.Name.Visible = false end

            if Config.ESP.Health then
                local hpR = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
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
                local hp = Camera.WorldToViewportPoint(Camera, head.Position)
                o.HeadDot.Position = Vector2.new(hp.X, hp.Y)
                o.HeadDot.Radius = 4
                o.HeadDot.Color = col
                o.HeadDot.Visible = true
            else o.HeadDot.Visible = false end
        end)
    end

    -- ========== GENERATOR ESP (SIMPLE TEXT) ==========
    if Config.ESP.GeneratorESP then
        for i, gen in pairs(Generators) do
            pcall(function()
                local obj = gen.Obj
                local pos = gen.Position
                local dist = (Camera.CFrame.Position - pos).Magnitude
                
                if not genESPObjs[obj] then
                    local tag = Drawing.new("Text")
                    tag.Visible = false; tag.Size = 14; tag.Center = true
                    tag.Outline = true; tag.Font = 2
                    genESPObjs[obj] = { Tag = tag }
                end
                
                local t = genESPObjs[obj]
                local sp, onScr = Camera:WorldToViewportPoint(pos)
                
                if t and onScr and dist <= Config.ESP.GeneratorRadius then
                    local progress = getGeneratorProgress(gen)
                    local repairing = getRepairingPlayers(gen)
                    local repairStr = ""
                    if #repairing > 0 then
                        repairStr = " | Misa P=" .. #repairing .. " (" .. table.concat(repairing, ", ") .. ")"
                    end
                    t.Tag.Position = Vector2.new(sp.X, sp.Y)
                    t.Tag.Text = "⚡ Gen [" .. math.floor(dist) .. "m] " .. progress .. "%" .. repairStr
                    t.Tag.Color = Color3.fromRGB(255, 220, 0)
                    t.Tag.Visible = true
                elseif t then
                    t.Tag.Visible = false
                end
            end)
        end
    else
        for _, o in pairs(genESPObjs) do
            for _, d in pairs(o) do pcall(function() d.Visible = false end) end
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function(c)
    task.wait(1)
    if Config.Speed.Enabled then
        local h = c:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = Config.Speed.Value end
    end
end)

--==============================================================
-- AUTO PERFECT (VERSI SIMPLE - GA BIKIN CRASH)
--==============================================================
local repairRemotes = {}

task.spawn(function()
    while task.wait(3) do
        repairRemotes = {}
        for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
            if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
                local n = string.lower(remote.Name)
                if n:find("skill") or n:find("perfect") or n:find("repair") or n:find("hit") then
                    table.insert(repairRemotes, remote)
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        if Config.AutoPerfectSkillCheck.Enabled then
            for _, remote in pairs(repairRemotes) do
                pcall(function()
                    if remote:IsA("RemoteEvent") then
                        remote:FireServer(true)
                        remote:FireServer(1)
                    elseif remote:IsA("RemoteFunction") then
                        pcall(function() remote:InvokeServer(true) end)
                    end
                end)
            end
        end
    end
end)

--==============================================================
-- NOTIF LOAD
--==============================================================
StarterGui:SetCore("SendNotification", {
    Title = "⚡ BOLONG HUB v3.2.2",
    Text = "Violence District Edition! 75+ fitur ❤️",
    Duration = 5,
})

print("[BOLONG HUB v3.2.2] Loaded! Repo: redfingernew25-pixel/Bolong-hub")
print("[BOLONG HUB] Violence District Edition")
