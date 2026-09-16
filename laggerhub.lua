--[[
    LAGGERHUB | MM2 Script
    GUI Style: Relake-like with nested settings & 2-column layout
    Open: RightShift (по умолчанию)
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")

local MM2_PLACE_ID = 142823291
local MMV_PLACE_ID = 116924926476457
local IS_MM_GAME = (game.PlaceId == MM2_PLACE_ID) or (game.PlaceId == MMV_PLACE_ID)

-- ============ НАСТРОЙКИ ============
local Settings = {
    AutoGunLooter = false,
    KillAll = false,
    ChooseMap100 = false,
    SelectedMap = nil,
    PlayerESP = false,
    NameTags = false,
    SeeInvisibles = false,
    Tracers = false,
    Fly = false,
    NoClip = false,
    AimBot = false,
    AimBotFOV = 100,
    AimBotPrediction = 50,
    AimBotOnlyMurderer = false,
    AimBotWallCheck = true,
    LockMouse = false,
    MurderNotification = false,
    SheriffNotification = false,
    Ambience = false,
    AmbienceType = "Day",
    Shaders = false,
    ShaderMode = 1,
    Aura = false,
    AuraType = 1,
    Particles = false,
    FlyKey = nil,
    AimBotKey = nil,
    LockMouseKey = nil,
    NoClipKey = nil,
    OpenMode = "Key",
}

local Colors = {
    WindowBg        = Color3.fromRGB(22, 22, 26),
    WindowTransp    = 0.05,
    SidebarBg       = Color3.fromRGB(18, 18, 22),
    SidebarTransp   = 0.1,
    CardBg          = Color3.fromRGB(30, 30, 35),
    CardTransp      = 0.35,
    CardStroke      = Color3.fromRGB(55, 55, 65),
    CardStrokeTr    = 0.5,
    InnerBg         = Color3.fromRGB(38, 38, 44),
    InnerTransp     = 0.3,
    Text            = Color3.fromRGB(235, 235, 240),
    TextDim         = Color3.fromRGB(140, 140, 150),
    TextMuted       = Color3.fromRGB(100, 100, 110),
    Accent          = Color3.fromRGB(180, 120, 255),
    ToggleOn        = Color3.fromRGB(180, 120, 255),
    ToggleOff       = Color3.fromRGB(60, 60, 70),
    SliderFill      = Color3.fromRGB(180, 120, 255),
    SliderBg        = Color3.fromRGB(55, 55, 62),
    SearchBg        = Color3.fromRGB(28, 28, 34),
    CategoryActive  = Color3.fromRGB(45, 45, 55),
    CategoryHover   = Color3.fromRGB(35, 35, 42),
    Divider         = Color3.fromRGB(45, 45, 52),
}

-- ============ ScreenGui ============
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LAGGERHUB"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = game.CoreGui

-- ============ Notifications ============
local NotifContainer = Instance.new("Frame")
NotifContainer.Size = UDim2.new(0, 300, 1, -40)
NotifContainer.Position = UDim2.new(1, -320, 0, 20)
NotifContainer.BackgroundTransparency = 1
NotifContainer.Parent = ScreenGui

local NotifList = Instance.new("UIListLayout")
NotifList.SortOrder = Enum.SortOrder.LayoutOrder
NotifList.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifList.HorizontalAlignment = Enum.HorizontalAlignment.Right
NotifList.Padding = UDim.new(0, 8)
NotifList.Parent = NotifContainer

local function ShowNotification(title, text, iconColor)
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 300, 0, 64)
    notif.BackgroundColor3 = Colors.CardBg
    notif.BackgroundTransparency = 0.1
    notif.BorderSizePixel = 0
    notif.Position = UDim2.new(1, 400, 0, 0)
    notif.Parent = NotifContainer
    local nCorner = Instance.new("UICorner") nCorner.CornerRadius = UDim.new(0, 10) nCorner.Parent = notif
    local nStroke = Instance.new("UIStroke") nStroke.Color = iconColor or Colors.Accent
    nStroke.Thickness = 1.2 nStroke.Transparency = 0.4 nStroke.Parent = notif
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 16) titleLabel.Position = UDim2.new(0, 12, 0, 10)
    titleLabel.BackgroundTransparency = 1 titleLabel.Text = title
    titleLabel.TextColor3 = Colors.Text titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 12 titleLabel.TextXAlignment = Enum.TextXAlignment.Left titleLabel.Parent = notif
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -20, 0, 16) textLabel.Position = UDim2.new(0, 12, 0, 30)
    textLabel.BackgroundTransparency = 1 textLabel.Text = text
    textLabel.TextColor3 = iconColor or Colors.TextDim
    textLabel.Font = Enum.Font.Gotham textLabel.TextSize = 11
    textLabel.TextXAlignment = Enum.TextXAlignment.Left textLabel.Parent = notif
    TweenService:Create(notif, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {Position = UDim2.new(1, -320, 0, 0)}):Play()
    task.delay(4, function()
        if notif and notif.Parent then
            local t = TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
                {Position = UDim2.new(1, 400, 0, 0), BackgroundTransparency = 1})
            t:Play()
            t.Completed:Connect(function() notif:Destroy() end)
        end
    end)
end

-- ============ ОКНО ============
local MainFrame = Instance.new("Frame")
MainFrame.Name = "Main"
MainFrame.Size = UDim2.new(0, 640, 0, 420)
MainFrame.Position = UDim2.new(0.5, -320, 0.5, -210)
MainFrame.BackgroundColor3 = Colors.WindowBg
MainFrame.BackgroundTransparency = Colors.WindowTransp
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Colors.CardStroke
MainStroke.Thickness = 1
MainStroke.Transparency = 0.5
MainStroke.Parent = MainFrame

-- ============ САЙДБАР ============
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 170, 1, 0)
Sidebar.BackgroundColor3 = Colors.SidebarBg
Sidebar.BackgroundTransparency = Colors.SidebarTransp
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame
local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 12)
SidebarCorner.Parent = Sidebar

local SidebarMask = Instance.new("Frame")
SidebarMask.Size = UDim2.new(0, 12, 1, 0)
SidebarMask.Position = UDim2.new(1, -12, 0, 0)
SidebarMask.BackgroundColor3 = Colors.SidebarBg
SidebarMask.BackgroundTransparency = Colors.SidebarTransp
SidebarMask.BorderSizePixel = 0
SidebarMask.Parent = Sidebar

local LogoFrame = Instance.new("Frame")
LogoFrame.Name = "Logo"
LogoFrame.Size = UDim2.new(1, -20, 0, 32)
LogoFrame.Position = UDim2.new(0, 10, 0, 12)
LogoFrame.BackgroundTransparency = 1
LogoFrame.Parent = Sidebar

local LogoIcon = Instance.new("Frame")
LogoIcon.Size = UDim2.new(0, 22, 0, 22)
LogoIcon.Position = UDim2.new(0, 0, 0.5, -11)
LogoIcon.BackgroundColor3 = Colors.Accent
LogoIcon.BorderSizePixel = 0
LogoIcon.Parent = LogoFrame
local LogoIconCorner = Instance.new("UICorner")
LogoIconCorner.CornerRadius = UDim.new(0, 5)
LogoIconCorner.Parent = LogoIcon

local LogoIconLabel = Instance.new("TextLabel")
LogoIconLabel.Size = UDim2.new(1, 0, 1, 0)
LogoIconLabel.BackgroundTransparency = 1
LogoIconLabel.Text = "L"
LogoIconLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
LogoIconLabel.Font = Enum.Font.GothamBlack
LogoIconLabel.TextSize = 14
LogoIconLabel.Parent = LogoIcon

local LogoText = Instance.new("TextLabel")
LogoText.Size = UDim2.new(1, -30, 1, 0)
LogoText.Position = UDim2.new(0, 30, 0, 0)
LogoText.BackgroundTransparency = 1
LogoText.Text = "LAGGERHUB"
LogoText.TextColor3 = Colors.Text
LogoText.Font = Enum.Font.GothamBold
LogoText.TextSize = 14
LogoText.TextXAlignment = Enum.TextXAlignment.Left
LogoText.Parent = LogoFrame

local SearchFrame = Instance.new("Frame")
SearchFrame.Name = "Search"
SearchFrame.Size = UDim2.new(1, -20, 0, 28)
SearchFrame.Position = UDim2.new(0, 10, 0, 52)
SearchFrame.BackgroundColor3 = Colors.SearchBg
SearchFrame.BackgroundTransparency = 0.1
SearchFrame.BorderSizePixel = 0
SearchFrame.Parent = Sidebar
local SearchFrameCorner = Instance.new("UICorner")
SearchFrameCorner.CornerRadius = UDim.new(0, 7)
SearchFrameCorner.Parent = SearchFrame

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, -16, 1, 0)
SearchBox.Position = UDim2.new(0, 10, 0, 0)
SearchBox.BackgroundTransparency = 1
SearchBox.Text = ""
SearchBox.PlaceholderText = "Search..."
SearchBox.PlaceholderColor3 = Colors.TextMuted
SearchBox.TextColor3 = Colors.Text
SearchBox.Font = Enum.Font.Gotham
SearchBox.TextSize = 11
SearchBox.TextXAlignment = Enum.TextXAlignment.Left
SearchBox.ClearTextOnFocus = false
SearchBox.Parent = SearchFrame

local CategoryContainer = Instance.new("Frame")
CategoryContainer.Name = "Categories"
CategoryContainer.Size = UDim2.new(1, -20, 1, -170)
CategoryContainer.Position = UDim2.new(0, 10, 0, 92)
CategoryContainer.BackgroundTransparency = 1
CategoryContainer.Parent = Sidebar

local CategoryList = Instance.new("UIListLayout")
CategoryList.SortOrder = Enum.SortOrder.LayoutOrder
CategoryList.Padding = UDim.new(0, 3)
CategoryList.Parent = CategoryContainer

local BottomFrame = Instance.new("Frame")
BottomFrame.Name = "Bottom"
BottomFrame.Size = UDim2.new(1, -20, 0, 30)
BottomFrame.Position = UDim2.new(0, 10, 1, -42)
BottomFrame.BackgroundTransparency = 1
BottomFrame.Parent = Sidebar

local UserDot = Instance.new("Frame")
UserDot.Size = UDim2.new(0, 7, 0, 7)
UserDot.Position = UDim2.new(0, 3, 0.5, -3.5)
UserDot.BackgroundColor3 = Color3.fromRGB(80, 220, 120)
UserDot.BorderSizePixel = 0
UserDot.Parent = BottomFrame
local UserDotCorner = Instance.new("UICorner")
UserDotCorner.CornerRadius = UDim.new(1, 0)
UserDotCorner.Parent = UserDot

local UserLabel = Instance.new("TextLabel")
UserLabel.Size = UDim2.new(1, -18, 1, 0)
UserLabel.Position = UDim2.new(0, 18, 0, 0)
UserLabel.BackgroundTransparency = 1
UserLabel.Text = LocalPlayer.Name
UserLabel.TextColor3 = Colors.TextDim
UserLabel.Font = Enum.Font.GothamMedium
UserLabel.TextSize = 11
UserLabel.TextXAlignment = Enum.TextXAlignment.Left
UserLabel.Parent = BottomFrame

-- ============ ПРАВАЯ ЧАСТЬ ============
local ContentArea = Instance.new("Frame")
ContentArea.Name = "Content"
ContentArea.Size = UDim2.new(1, -170, 1, 0)
ContentArea.Position = UDim2.new(0, 170, 0, 0)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, -24, 0, 40)
TopBar.Position = UDim2.new(0, 12, 0, 12)
TopBar.BackgroundTransparency = 1
TopBar.Parent = ContentArea

local CatTitle = Instance.new("TextLabel")
CatTitle.Size = UDim2.new(0, 160, 1, 0)
CatTitle.Position = UDim2.new(0, 0, 0, 0)
CatTitle.BackgroundTransparency = 1
CatTitle.Text = "Combat"
CatTitle.TextColor3 = Colors.Text
CatTitle.Font = Enum.Font.GothamBold
CatTitle.TextSize = 18
CatTitle.TextXAlignment = Enum.TextXAlignment.Left
CatTitle.Parent = TopBar

local TitleDivider = Instance.new("Frame")
TitleDivider.Size = UDim2.new(0, 1, 0, 22)
TitleDivider.Position = UDim2.new(0, 170, 0.5, -11)
TitleDivider.BackgroundColor3 = Colors.Divider
TitleDivider.BorderSizePixel = 0
TitleDivider.Parent = TopBar

local DescLabel = Instance.new("TextLabel")
DescLabel.Size = UDim2.new(1, -186, 1, 0)
DescLabel.Position = UDim2.new(0, 186, 0, 0)
DescLabel.BackgroundTransparency = 1
DescLabel.Text = ""
DescLabel.TextColor3 = Colors.TextDim
DescLabel.Font = Enum.Font.Gotham
DescLabel.TextSize = 11
DescLabel.TextWrapped = true
DescLabel.TextXAlignment = Enum.TextXAlignment.Left
DescLabel.TextYAlignment = Enum.TextYAlignment.Center
DescLabel.Parent = TopBar

local CardsScroll = Instance.new("ScrollingFrame")
CardsScroll.Name = "Cards"
CardsScroll.Size = UDim2.new(1, -24, 1, -66)
CardsScroll.Position = UDim2.new(0, 12, 0, 58)
CardsScroll.BackgroundTransparency = 1
CardsScroll.BorderSizePixel = 0
CardsScroll.ScrollBarThickness = 3
CardsScroll.ScrollBarImageColor3 = Colors.CardStroke
CardsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
CardsScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
CardsScroll.Parent = ContentArea

local ScrollPad = Instance.new("UIPadding")
ScrollPad.PaddingTop = UDim.new(0, 6)
ScrollPad.PaddingBottom = UDim.new(0, 6)
ScrollPad.PaddingLeft = UDim.new(0, 4)
ScrollPad.PaddingRight = UDim.new(0, 6)
ScrollPad.Parent = CardsScroll

-- Две вертикальные колонки внутри скролла
local ColLeft = Instance.new("Frame")
ColLeft.Name = "ColLeft"
ColLeft.BackgroundTransparency = 1
ColLeft.Size = UDim2.new(0, 218, 0, 0)
ColLeft.Position = UDim2.new(0, 0, 0, 0)
ColLeft.AutomaticSize = Enum.AutomaticSize.Y
ColLeft.Parent = CardsScroll

local ColLeftList = Instance.new("UIListLayout")
ColLeftList.SortOrder = Enum.SortOrder.LayoutOrder
ColLeftList.Padding = UDim.new(0, 10)
ColLeftList.Parent = ColLeft

local ColRight = Instance.new("Frame")
ColRight.Name = "ColRight"
ColRight.BackgroundTransparency = 1
ColRight.Size = UDim2.new(0, 218, 0, 0)
ColRight.Position = UDim2.new(0, 228, 0, 0)
ColRight.AutomaticSize = Enum.AutomaticSize.Y
ColRight.Parent = CardsScroll

local ColRightList = Instance.new("UIListLayout")
ColRightList.SortOrder = Enum.SortOrder.LayoutOrder
ColRightList.Padding = UDim.new(0, 10)
ColRightList.Parent = ColRight

-- Счётчик для чередования
local CardIndex = 0

-- ============ ВНУТРЕННИЕ ЭЛЕМЕНТЫ НАСТРОЕК ============

local function CreateSwitch(parent, defaultValue, callback)
    local state = defaultValue or false

    local wrap = Instance.new("TextButton")
    wrap.Size = UDim2.new(0, 30, 0, 16)
    wrap.BackgroundColor3 = state and Colors.ToggleOn or Colors.ToggleOff
    wrap.BackgroundTransparency = state and 0 or 0.15
    wrap.BorderSizePixel = 0
    wrap.Text = ""
    wrap.AutoButtonColor = false
    wrap.Parent = parent

    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(1, 0)
    bc.Parent = wrap

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 12, 0, 12)
    knob.Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.Parent = wrap
    local kc = Instance.new("UICorner")
    kc.CornerRadius = UDim.new(1, 0)
    kc.Parent = knob

    local function apply()
        TweenService:Create(wrap, TweenInfo.new(0.15),
            {BackgroundColor3 = state and Colors.ToggleOn or Colors.ToggleOff,
             BackgroundTransparency = state and 0 or 0.15}):Play()
        TweenService:Create(knob, TweenInfo.new(0.15),
            {Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)}):Play()
    end

    wrap.MouseButton1Click:Connect(function()
        state = not state
        apply()
        if callback then callback(state) end
    end)

    return wrap
end

local function CreateCircleToggle(parent, defaultValue, callback)
    local state = defaultValue or false

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 16, 0, 16)
    btn.BackgroundColor3 = state and Colors.ToggleOn or Colors.ToggleOff
    btn.BackgroundTransparency = state and 0 or 0.3
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.Parent = parent

    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(1, 0)
    bc.Parent = btn

    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 6, 0, 6)
    dot.Position = UDim2.new(0.5, -3, 0.5, -3)
    dot.BackgroundColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 140, 150)
    dot.BorderSizePixel = 0
    dot.Parent = btn
    local dc = Instance.new("UICorner")
    dc.CornerRadius = UDim.new(1, 0)
    dc.Parent = dot

    local function apply()
        TweenService:Create(btn, TweenInfo.new(0.15),
            {BackgroundColor3 = state and Colors.ToggleOn or Colors.ToggleOff,
             BackgroundTransparency = state and 0 or 0.3}):Play()
        TweenService:Create(dot, TweenInfo.new(0.15),
            {BackgroundColor3 = state and Color3.fromRGB(255,255,255) or Color3.fromRGB(140,140,150)}):Play()
    end

    btn.MouseButton1Click:Connect(function()
        state = not state
        apply()
        if callback then callback(state) end
    end)

    return btn
end

-- ============ СИСТЕМА КАРТОЧЕК ============
local AllCards = {}
local CategoryButtons = {}
local CurrentCategory = "Combat"
local CurrentDescTarget = nil

local function SetDescription(text)
    DescLabel.Text = text or ""
end

local function CreateSettingSwitch(parent, name, default, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 22)
    row.BackgroundTransparency = 1
    row.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -50, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.TextColor3 = Colors.Text
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local sw = CreateSwitch(row, default, callback)
    sw.Position = UDim2.new(1, -30, 0.5, -8)
    sw.Parent = row

    return row
end

local function CreateSettingSlider(parent, name, min, max, default, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 36)
    row.BackgroundTransparency = 1
    row.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -60, 0, 14)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.TextColor3 = Colors.Text
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local valLabel = Instance.new("TextLabel")
    valLabel.Size = UDim2.new(0, 60, 0, 14)
    valLabel.Position = UDim2.new(1, -60, 0, 0)
    valLabel.BackgroundTransparency = 1
    valLabel.Text = tostring(default)
    valLabel.TextColor3 = Colors.TextDim
    valLabel.Font = Enum.Font.Gotham
    valLabel.TextSize = 11
    valLabel.TextXAlignment = Enum.TextXAlignment.Right
    valLabel.Parent = row

    local bar = Instance.new("TextButton")
    bar.Size = UDim2.new(1, 0, 0, 5)
    bar.Position = UDim2.new(0, 0, 0, 22)
    bar.BackgroundColor3 = Colors.SliderBg
    bar.BorderSizePixel = 0
    bar.Text = ""
    bar.AutoButtonColor = false
    bar.Parent = row
    local barc = Instance.new("UICorner")
    barc.CornerRadius = UDim.new(1, 0)
    barc.Parent = bar

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Colors.SliderFill
    fill.BorderSizePixel = 0
    fill.Parent = bar
    local fillc = Instance.new("UICorner")
    fillc.CornerRadius = UDim.new(1, 0)
    fillc.Parent = fill

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 9, 0, 9)
    knob.Position = UDim2.new((default - min) / (max - min), -4.5, 0.5, -4.5)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.ZIndex = 2
    knob.Parent = bar
    local knc = Instance.new("UICorner")
    knc.CornerRadius = UDim.new(1, 0)
    knc.Parent = knob

    local value = default
    local dragging = false

    local function update(input)
        local p = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        value = min + (max - min) * p
        fill.Size = UDim2.new(p, 0, 1, 0)
        knob.Position = UDim2.new(p, -4.5, 0.5, -4.5)
        valLabel.Text = tostring(math.floor(value * 100) / 100)
        if callback then callback(value) end
    end

    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(input)
        end
    end)
    bar.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    return row
end

local function CreateSettingCycle(parent, name, values, defaultIndex, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 44)
    row.BackgroundTransparency = 1
    row.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 14)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.TextColor3 = Colors.Text
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local currentIndex = defaultIndex or 1

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 22)
    btn.Position = UDim2.new(0, 0, 0, 18)
    btn.BackgroundColor3 = Colors.InnerBg
    btn.BackgroundTransparency = Colors.InnerTransp
    btn.BorderSizePixel = 0
    btn.Text = "  " .. values[currentIndex] .. "  ..."
    btn.TextColor3 = Colors.Text
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 11
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn.Parent = row
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 6)
    bc.Parent = btn

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15),
            {BackgroundColor3 = Colors.CategoryHover, BackgroundTransparency = 0.1}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15),
            {BackgroundColor3 = Colors.InnerBg, BackgroundTransparency = Colors.InnerTransp}):Play()
    end)

    btn.MouseButton1Click:Connect(function()
        currentIndex = currentIndex + 1
        if currentIndex > #values then currentIndex = 1 end
        btn.Text = "  " .. values[currentIndex] .. "  ..."
        if callback then callback(currentIndex, values[currentIndex]) end
    end)

    return row
end

local function CreateSettingBind(parent, name, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 22)
    row.BackgroundTransparency = 1
    row.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -60, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.TextColor3 = Colors.Text
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 40, 0, 18)
    btn.Position = UDim2.new(1, -40, 0.5, -9)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    btn.BackgroundTransparency = 0.2
    btn.BorderSizePixel = 0
    btn.Text = "Key"
    btn.TextColor3 = Colors.TextDim
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 10
    btn.AutoButtonColor = false
    btn.Parent = row
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 5)
    bc.Parent = btn

    local listening = false
    btn.MouseButton1Click:Connect(function()
        listening = true
        btn.Text = "..."
        btn.TextColor3 = Colors.Accent
    end)

    UserInputService.InputBegan:Connect(function(input, gp)
        if listening and not gp and input.UserInputType == Enum.UserInputType.Keyboard then
            listening = false
            btn.Text = tostring(input.KeyCode):gsub("Enum.KeyCode.", "")
            btn.TextColor3 = Colors.Text
            if callback then callback(input.KeyCode) end
        end
    end)

    return row
end

-- Главная карточка функции
local function CreateFunctionCard(cat, cfg)
    local card = Instance.new("Frame")
    card.Name = cfg.name .. "_Card"
    card.BackgroundColor3 = Colors.CardBg
    card.BackgroundTransparency = Colors.CardTransp
    card.BorderSizePixel = 0
    card.Visible = false
    card.ClipsDescendants = false
    card.Size = UDim2.new(0, 218, 0, 42)

    CardIndex = CardIndex + 1
    card.LayoutOrder = CardIndex
    if CardIndex % 2 == 1 then
        card.Parent = ColLeft
    else
        card.Parent = ColRight
    end

    local cc = Instance.new("UICorner")
    cc.CornerRadius = UDim.new(0, 10)
    cc.Parent = card

    local cs = Instance.new("UIStroke")
    cs.Color = Colors.CardStroke
    cs.Thickness = 1
    cs.Transparency = Colors.CardStrokeTr
    cs.Parent = card

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)
    layout.Parent = card

    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 8)
    pad.PaddingRight = UDim.new(0, 8)
    pad.PaddingTop = UDim.new(0, 8)
    pad.PaddingBottom = UDim.new(0, 8)
    pad.Parent = card

    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 22)
    header.BackgroundTransparency = 1
    header.LayoutOrder = 1
    header.Parent = card

    local mainToggle = CreateCircleToggle(header, cfg.default or false, cfg.callback)
    mainToggle.Position = UDim2.new(0, 0, 0.5, -8)
    mainToggle.Parent = header

    local helpBtn = Instance.new("TextButton")
    helpBtn.Size = UDim2.new(0, 16, 0, 16)
    helpBtn.Position = UDim2.new(0, 22, 0.5, -8)
    helpBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    helpBtn.BackgroundTransparency = 0.2
    helpBtn.BorderSizePixel = 0
    helpBtn.Text = "?"
    helpBtn.TextColor3 = Colors.TextDim
    helpBtn.Font = Enum.Font.GothamBold
    helpBtn.TextSize = 10
    helpBtn.AutoButtonColor = false
    helpBtn.Parent = header
    local hbc = Instance.new("UICorner")
    hbc.CornerRadius = UDim.new(1, 0)
    hbc.Parent = helpBtn

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -46, 1, 0)
    nameLabel.Position = UDim2.new(0, 44, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = cfg.name
    nameLabel.TextColor3 = Colors.Text
    nameLabel.Font = Enum.Font.GothamMedium
    nameLabel.TextSize = 12
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    nameLabel.Parent = header

    helpBtn.MouseEnter:Connect(function()
        TweenService:Create(helpBtn, TweenInfo.new(0.15),
            {BackgroundColor3 = Colors.Accent, TextColor3 = Color3.fromRGB(255,255,255)}):Play()
    end)
    helpBtn.MouseLeave:Connect(function()
        TweenService:Create(helpBtn, TweenInfo.new(0.15),
            {BackgroundColor3 = Color3.fromRGB(45,45,52), TextColor3 = Colors.TextDim}):Play()
    end)
    helpBtn.MouseButton1Click:Connect(function()
        if CurrentDescTarget == card then
            CurrentDescTarget = nil
            SetDescription("")
        else
            CurrentDescTarget = card
            SetDescription(cfg.desc or ("Функция: " .. cfg.name))
        end
    end)

    if cfg.settings and #cfg.settings > 0 then
        local sep = Instance.new("Frame")
        sep.Size = UDim2.new(1, 0, 0, 1)
        sep.BackgroundColor3 = Colors.Divider
        sep.BorderSizePixel = 0
        sep.LayoutOrder = 2
        sep.Parent = card

        for i, s in ipairs(cfg.settings) do
            local row
            if s.type == "switch" then
                row = CreateSettingSwitch(card, s.name, s.default, s.callback)
            elseif s.type == "slider" then
                row = CreateSettingSlider(card, s.name, s.min, s.max, s.default, s.callback)
            elseif s.type == "cycle" then
                row = CreateSettingCycle(card, s.name, s.values, s.default, s.callback)
            elseif s.type == "bind" then
                row = CreateSettingBind(card, s.name, s.callback)
            end
            if row then
                row.LayoutOrder = 10 + i
                row.Parent = card
            end
        end
    end

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        card.Size = UDim2.new(0, 218, 0, layout.AbsoluteContentSize.Y + 16)
    end)

    table.insert(AllCards, {category = cat, frame = card, name = cfg.name, desc = cfg.desc})
    return card
end

local function SetCatVis(cat, query)
    query = (query or ""):lower()
    for _, card in pairs(AllCards) do
        if card.category == cat then
            card.frame.Visible = (query == "" or card.name:lower():find(query, 1, true) ~= nil)
        else
            card.frame.Visible = false
        end
    end
    if CurrentDescTarget and not CurrentDescTarget.Visible then
        CurrentDescTarget = nil
        SetDescription("")
    end
end

local function CreateCatBtn(name)
    local b = Instance.new("TextButton")
    b.Name = name .. "_Cat"
    b.Size = UDim2.new(1, 0, 0, 28)
    b.BackgroundColor3 = Colors.SidebarBg
    b.BackgroundTransparency = 1
    b.BorderSizePixel = 0
    b.Text = "   " .. name
    b.TextColor3 = Colors.TextDim
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 12
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.AutoButtonColor = false
    b.Parent = CategoryContainer

    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 7)
    bc.Parent = b

    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 3, 0, 14)
    indicator.Position = UDim2.new(0, 0, 0.5, -7)
    indicator.BackgroundColor3 = Colors.Accent
    indicator.BorderSizePixel = 0
    indicator.Visible = false
    indicator.Parent = b
    local ic = Instance.new("UICorner")
    ic.CornerRadius = UDim.new(1, 0)
    ic.Parent = indicator

    CategoryButtons[name] = {button = b, indicator = indicator}

    b.MouseEnter:Connect(function()
        if CurrentCategory ~= name then
            TweenService:Create(b, TweenInfo.new(0.15),
                {BackgroundColor3 = Colors.CategoryHover, BackgroundTransparency = 0.5}):Play()
        end
    end)
    b.MouseLeave:Connect(function()
        if CurrentCategory ~= name then
            TweenService:Create(b, TweenInfo.new(0.15),
                {BackgroundTransparency = 1}):Play()
        end
    end)

    b.MouseButton1Click:Connect(function()
        CurrentCategory = name
        for cn, data in pairs(CategoryButtons) do
            local isActive = (cn == name)
            data.indicator.Visible = isActive
            TweenService:Create(data.button, TweenInfo.new(0.15), {
                BackgroundColor3 = isActive and Colors.CategoryActive or Colors.SidebarBg,
                BackgroundTransparency = isActive and 0.4 or 1,
                TextColor3 = isActive and Colors.Text or Colors.TextDim,
            }):Play()
        end
        CatTitle.Text = name
        CurrentDescTarget = nil
        SetDescription("")
        SetCatVis(name, SearchBox.Text)
    end)

    return b
end

-- ============ Открытие / закрытие ============
local BlurEffect = Instance.new("BlurEffect")
BlurEffect.Size = 0
BlurEffect.Parent = Lighting

local isOpen = false
local isAnimating = false

local function OpenGUI()
    if isAnimating or isOpen then return end
    isAnimating = true
    isOpen = true
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 640, 0, 420)
    MainFrame.Position = UDim2.new(0.5, -320, 0.5, -210)
    MainFrame.BackgroundTransparency = 1
    Sidebar.BackgroundTransparency = 1
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        BackgroundTransparency = Colors.WindowTransp,
    }):Play()
    TweenService:Create(Sidebar, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        BackgroundTransparency = Colors.SidebarTransp,
    }):Play()
    TweenService:Create(BlurEffect, TweenInfo.new(0.3), {Size = 14}):Play()
    task.wait(0.3)
    isAnimating = false
end

local function CloseGUI()
    if isAnimating or not isOpen then return end
    isAnimating = true
    isOpen = false
    TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
        BackgroundTransparency = 1,
    }):Play()
    TweenService:Create(Sidebar, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
        BackgroundTransparency = 1,
    }):Play()
    TweenService:Create(BlurEffect, TweenInfo.new(0.25), {Size = 0}):Play()
    task.wait(0.25)
    MainFrame.Visible = false
    isAnimating = false
end

local OpenModeButton = Instance.new("TextButton")
OpenModeButton.Size = UDim2.new(0, 120, 0, 36)
OpenModeButton.Position = UDim2.new(0, 20, 0.5, -18)
OpenModeButton.BackgroundColor3 = Colors.WindowBg
OpenModeButton.BackgroundTransparency = 0.1
OpenModeButton.BorderSizePixel = 0
OpenModeButton.Text = "LAGGERHUB"
OpenModeButton.TextColor3 = Colors.Text
OpenModeButton.Font = Enum.Font.GothamBlack
OpenModeButton.TextSize = 12
OpenModeButton.AutoButtonColor = false
OpenModeButton.Visible = false
OpenModeButton.Active = true
OpenModeButton.Draggable = true
OpenModeButton.Parent = ScreenGui
local ombC = Instance.new("UICorner") ombC.CornerRadius = UDim.new(0, 10) ombC.Parent = OpenModeButton
local ombS = Instance.new("UIStroke") ombS.Color = Colors.Accent ombS.Thickness = 1.2 ombS.Transparency = 0.4 ombS.Parent = OpenModeButton

local function SetOpenMode(mode)
    Settings.OpenMode = mode
    OpenModeButton.Visible = (mode == "Button")
end

SetOpenMode(Settings.OpenMode)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if Settings.OpenMode == "Key" and input.KeyCode == Enum.KeyCode.RightShift then
        if isOpen then CloseGUI() else OpenGUI() end
    end
end)

OpenModeButton.MouseButton1Click:Connect(function()
    if isOpen then CloseGUI() else OpenGUI() end
end)

SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    SetCatVis(CurrentCategory, SearchBox.Text)
end)

-- ============ Forward declarations ============
local ToggleAutoGunLooter, ToggleKillAll, Toggle100ChooseMap
local ToggleFly, ToggleNoClip, ToggleAimBot, ToggleLockMouse
local ToggleTracers, ToggleAura, ToggleParticles, ToggleShaders
local RefreshAura, SetShaderModeByNumber, OpenChooseMapSelector
local UpdateAllVisuals, ClearAllESP, ClearAllNameTags, ClearAllInvisibleESP
local ApplySkybox, RemoveSkybox

-- ============ КАТЕГОРИИ ============
CreateCatBtn("Combat")
CreateCatBtn("Movement")
CreateCatBtn("Render")
CreateCatBtn("Player")
CreateCatBtn("Misc")
if IS_MM_GAME then CreateCatBtn("WebHook") end
CreateCatBtn("Binds")

do
    local data = CategoryButtons["Combat"]
    data.indicator.Visible = true
    data.button.BackgroundColor3 = Colors.CategoryActive
    data.button.BackgroundTransparency = 0.4
    data.button.TextColor3 = Colors.Text
    CatTitle.Text = "Combat"
end

-- ============ COMBAT ============
CreateFunctionCard("Combat", {
    name = "AimBot",
    desc = "Автоматически наводит камеру на ближайшего игрока в радиусе FOV.",
    default = false,
    callback = function(s) if ToggleAimBot then ToggleAimBot(s) end end,
    settings = {
        {type = "switch", name = "Only Murderer",
            default = false,
            callback = function(s) Settings.AimBotOnlyMurderer = s end},
        {type = "switch", name = "Wall Check",
            default = true,
            callback = function(s) Settings.AimBotWallCheck = s end},
        {type = "slider", name = "FOV", min = 50, max = 300, default = 100,
            callback = function(v) Settings.AimBotFOV = v end},
        {type = "slider", name = "Prediction", min = 0, max = 100, default = 50,
            callback = function(v) Settings.AimBotPrediction = v end},
    }
})

CreateFunctionCard("Combat", {
    name = "Lock Mouse",
    desc = "Блокирует курсор в центре экрана. Удобно для AimBot-режима.",
    default = false,
    callback = function(s) if ToggleLockMouse then ToggleLockMouse(s) end end,
})

if IS_MM_GAME then
    CreateFunctionCard("Combat", {
        name = "KillAll",
        desc = "Телепортируется к каждому живому игроку и активирует нож.",
        default = false,
        callback = function(s) if ToggleKillAll then ToggleKillAll(s) end end,
    })
end

-- ============ MOVEMENT ============
CreateFunctionCard("Movement", {
    name = "Fly",
    desc = "Полёт по карте. WASD — движение, Space — вверх, LeftShift — вниз.",
    default = false,
    callback = function(s) if ToggleFly then ToggleFly(s) end end,
})

CreateFunctionCard("Movement", {
    name = "NoClip",
    desc = "Отключает коллизии у персонажа — можно проходить сквозь стены.",
    default = false,
    callback = function(s) if ToggleNoClip then ToggleNoClip(s) end end,
})

-- ============ RENDER ============
CreateFunctionCard("Render", {
    name = "Player ESP",
    desc = "Подсвечивает игроков через стены цветом их роли.",
    default = false,
    callback = function(s)
        Settings.PlayerESP = s
        if s then if UpdateAllVisuals then UpdateAllVisuals() end
        else if ClearAllESP then ClearAllESP() end end
    end,
})

CreateFunctionCard("Render", {
    name = "NameTags",
    desc = "Показывает над головой игрока его ник, роль и метку Invisible.",
    default = false,
    callback = function(s)
        Settings.NameTags = s
        if s then if UpdateAllVisuals then UpdateAllVisuals() end
        else if ClearAllNameTags then ClearAllNameTags() end end
    end,
})

CreateFunctionCard("Render", {
    name = "SeeInvisibles",
    desc = "Подсвечивает игроков, которые стали невидимыми.",
    default = false,
    callback = function(s)
        Settings.SeeInvisibles = s
        if not s and ClearAllInvisibleESP then ClearAllInvisibleESP() end
    end,
})

if IS_MM_GAME then
    CreateFunctionCard("Render", {
        name = "Tracers",
        desc = "Рисует линии от низа экрана к каждому игроку.",
        default = false,
        callback = function(s) if ToggleTracers then ToggleTracers(s) end end,
    })
end

CreateFunctionCard("Render", {
    name = "Ambience",
    desc = "Меняет небо и освещение.",
    default = false,
    callback = function(s)
        Settings.Ambience = s
        if s then if ApplySkybox then ApplySkybox(Settings.AmbienceType) end
        else if RemoveSkybox then RemoveSkybox() end end
    end,
    settings = {
        {type = "cycle", name = "Type", values = {"Day", "Night", "Evening", "Sunset", "Anime"}, default = 1,
            callback = function(idx, val)
                Settings.AmbienceType = val
                if Settings.Ambience and ApplySkybox then ApplySkybox(val) end
            end},
    }
})

CreateFunctionCard("Render", {
    name = "Shaders",
    desc = "Пост-обработка экрана: Blur или Ultra Realism.",
    default = false,
    callback = function(s) if ToggleShaders then ToggleShaders(s) end end,
    settings = {
        {type = "cycle", name = "Mode", values = {"Blur", "Ultra"}, default = 1,
            callback = function(idx, val)
                Settings.ShaderMode = idx
                if SetShaderModeByNumber then SetShaderModeByNumber(idx) end
            end},
    }
})

CreateFunctionCard("Render", {
    name = "Aura",
    desc = "Круговая аура вокруг персонажа: огонь, лёд или молнии.",
    default = false,
    callback = function(s) if ToggleAura then ToggleAura(s) end end,
    settings = {
        {type = "cycle", name = "Type", values = {"Fire", "Ice", "Bolt"}, default = 1,
            callback = function(idx, val)
                Settings.AuraType = idx
                if Settings.Aura and RefreshAura then RefreshAura() end
            end},
    }
})

CreateFunctionCard("Render", {
    name = "Particles",
    desc = "Спавнит вокруг игрока около 60 светящихся шариков-снежинок.",
    default = false,
    callback = function(s) if ToggleParticles then ToggleParticles(s) end end,
})

-- ============ PLAYER ============
if IS_MM_GAME then
    CreateFunctionCard("Player", {
        name = "AutoGunLooter",
        desc = "Автоматически подтягивает к вам выпавшее оружие с земли.",
        default = false,
        callback = function(s) if ToggleAutoGunLooter then ToggleAutoGunLooter(s) end end,
    })
end

-- ============ MISC ============
if IS_MM_GAME then
    CreateFunctionCard("Misc", {
        name = "100 Choose Map",
        desc = "Открывает список карт и заспамливает голосование за выбранную карту.",
        default = false,
        callback = function(s) if Toggle100ChooseMap then Toggle100ChooseMap(s) end end,
    })
end

CreateFunctionCard("Misc", {
    name = "Open Mode",
    desc = "Key — открытие по RightShift, Button — отдельная кнопка на экране.",
    default = false,
    callback = function() end,
    settings = {
        {type = "cycle", name = "Mode", values = {"Key", "Button"}, default = 1,
            callback = function(idx, val)
                SetOpenMode(idx == 1 and "Key" or "Button")
            end},
    }
})

-- ============ WEBHOOK ============
if IS_MM_GAME then
    CreateFunctionCard("WebHook", {
        name = "MurderNotification",
        desc = "Показывает всплывающее уведомление, когда в раунде найден убийца.",
        default = false,
        callback = function(s) Settings.MurderNotification = s end,
    })
    CreateFunctionCard("WebHook", {
        name = "SheriffNotification",
        desc = "Показывает всплывающее уведомление, когда в раунде найден шериф.",
        default = false,
        callback = function(s) Settings.SheriffNotification = s end,
    })
end

-- ============ BINDS ============
CreateFunctionCard("Binds", {
    name = "Fly Key",
    desc = "Клавиша быстрого включения и выключения Fly.",
    default = false,
    callback = function() end,
    settings = {
        {type = "bind", name = "Key",
            callback = function(k) Settings.FlyKey = k end},
    }
})

CreateFunctionCard("Binds", {
    name = "NoClip Key",
    desc = "Клавиша быстрого включения и выключения NoClip.",
    default = false,
    callback = function() end,
    settings = {
        {type = "bind", name = "Key",
            callback = function(k) Settings.NoClipKey = k end},
    }
})

CreateFunctionCard("Binds", {
    name = "AimBot Key",
    desc = "Клавиша быстрого включения и выключения AimBot.",
    default = false,
    callback = function() end,
    settings = {
        {type = "bind", name = "Key",
            callback = function(k) Settings.AimBotKey = k end},
    }
})

CreateFunctionCard("Binds", {
    name = "Lock Mouse Key",
    desc = "Клавиша быстрого включения и выключения Lock Mouse.",
    default = false,
    callback = function() end,
    settings = {
        {type = "bind", name = "Key",
            callback = function(k) Settings.LockMouseKey = k end},
    }
})

SetCatVis("Combat", "")

-- ============================================================
-- ЛОГИКА ФУНКЦИЙ
-- ============================================================

-- ============ MM2 REMOTES / PLAYER DATA ============
local PlayerData = {}
local GameplayRemotes, GetCurrentPlayerData, PlayerDataChanged = nil, nil, nil

if IS_MM_GAME then
    local ok, remotes = pcall(function() return ReplicatedStorage:WaitForChild("Remotes", 10) end)
    if ok and remotes then
        local ok2, gameplay = pcall(function() return remotes:WaitForChild("Gameplay", 10) end)
        if ok2 and gameplay then
            GameplayRemotes = gameplay
            GetCurrentPlayerData = gameplay:WaitForChild("GetCurrentPlayerData", 10)
            PlayerDataChanged = gameplay:WaitForChild("PlayerDataChanged", 10)
        end
    end
end

local function GetRoleFromInfo(info)
    if not info then return nil end
    local role = tostring(info.Role or ""):lower()
    if role:find("murder") or role:find("killer") then return "Murderer" end
    if role:find("sheriff") or role:find("police") then return "Sheriff" end
    if role:find("hero") then return "Hero" end
    if role:find("innocent") or role:find("civilian") then return "Innocent" end
    return nil
end

local function UpdatePlayerData(newData)
    if type(newData) ~= "table" then return end
    PlayerData = newData
end

local function FetchPlayerData()
    if not GetCurrentPlayerData then return end
    task.spawn(function()
        local ok, data = pcall(function() return GetCurrentPlayerData:InvokeServer() end)
        if ok and type(data) == "table" then UpdatePlayerData(data) end
    end)
end

if IS_MM_GAME and GetCurrentPlayerData then FetchPlayerData() end
if IS_MM_GAME and PlayerDataChanged then
    PlayerDataChanged.OnClientEvent:Connect(function(newData)
        if type(newData) == "table" then UpdatePlayerData(newData) else FetchPlayerData() end
    end)
end

if IS_MM_GAME and GameplayRemotes then
    for _, remoteName in ipairs({"RoleSelect", "ShowRoleSelect", "ShowRoleSelectNew", "RoundStart"}) do
        local remote = GameplayRemotes:FindFirstChild(remoteName)
        if remote then
            remote.OnClientEvent:Connect(function() task.wait(0.05) FetchPlayerData() end)
        end
    end
    local RoundEndFade = GameplayRemotes:FindFirstChild("RoundEndFade")
    if RoundEndFade then
        RoundEndFade.OnClientEvent:Connect(function() PlayerData = {} end)
    end
end

local function GetPlayerRole(player)
    if not player then return "Lobby" end
    if not IS_MM_GAME then return "Innocent" end
    local info = PlayerData[player.Name]
    if not info or type(info) ~= "table" then return "Lobby" end
    if info.Dead == true then return "Lobby" end
    local role = info.Role
    if not role or role == "" then return "Lobby" end
    return GetRoleFromInfo(info) or "Innocent"
end

local function GetRoleColor(role)
    if not IS_MM_GAME then return Color3.fromRGB(160, 90, 255) end
    if role == "Murderer" then return Color3.fromRGB(230, 40, 40) end
    if role == "Sheriff" then return Color3.fromRGB(40, 120, 255) end
    if role == "Hero" then return Color3.fromRGB(255, 215, 0) end
    if role == "Innocent" then return Color3.fromRGB(0, 220, 40) end
    return Color3.fromRGB(200, 200, 210)
end

local function IsSheriffDead()
    if not IS_MM_GAME then return false end
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local info = PlayerData[player.Name]
            if info and type(info) == "table" then
                local role = tostring(info.Role or ""):lower()
                if role:find("sheriff") or role:find("police") then
                    if info.Dead ~= true then return false end
                end
            end
        end
    end
    return true
end

local function PlayerHasGun(player)
    local char = player.Character
    if not char then return false end
    local bp = player:FindFirstChild("Backpack")
    local function check(c)
        if not c then return false end
        for _, t in pairs(c:GetChildren()) do
            if t:IsA("Tool") then
                local n = t.Name:lower()
                if n:find("gun") or n:find("revolver") or n:find("pistol") or n:find("sheriff") then return true end
            end
        end
        return false
    end
    return check(char) or check(bp)
end

local function IsHero(player)
    if not IS_MM_GAME then return false end
    local role = GetPlayerRole(player)
    if role == "Sheriff" or role == "Murderer" then return false end
    if not IsSheriffDead() then return false end
    if not PlayerHasGun(player) then return false end
    return true
end

-- ============ ESP / HIGHLIGHTS ============
local InvisibleHighlights = {}
local ESPHighlights = {}
local NameTagGuis = {}

local function IsCharacterInvisible(player)
    local char = player.Character
    if not char then return false end
    local h = char:FindFirstChildOfClass("Humanoid")
    if not h or h.Health <= 0 then return false end
    local total, invis = 0, 0
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            total = total + 1
            if part.Transparency >= 0.9 or part.LocalTransparencyModifier >= 0.9 then invis = invis + 1 end
        end
    end
    return total > 0 and invis / total >= 0.8
end

local function UpdateInvisibleESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local invis = IsCharacterInvisible(player)
            local existing = InvisibleHighlights[player]
            if invis then
                if not existing or not existing.Parent then
                    local h = Instance.new("Highlight")
                    h.FillColor = Color3.fromRGB(255, 255, 255) h.FillTransparency = 0.6
                    h.OutlineColor = Color3.fromRGB(255, 255, 255) h.OutlineTransparency = 0
                    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    h.Adornee = player.Character h.Parent = player.Character
                    InvisibleHighlights[player] = h
                end
            else
                if existing then existing:Destroy() InvisibleHighlights[player] = nil end
            end
        end
    end
end

function ClearAllInvisibleESP()
    for _, h in pairs(InvisibleHighlights) do if h then h:Destroy() end end
    InvisibleHighlights = {}
end

local function CreateESP(player)
    if ESPHighlights[player] then ESPHighlights[player]:Destroy() ESPHighlights[player] = nil end
    if Settings.SeeInvisibles and IsCharacterInvisible(player) then return end
    local role = GetPlayerRole(player)
    if IS_MM_GAME and role == "Lobby" then return end
    local character = player.Character
    if not character then return end
    local color = GetRoleColor(role)
    if IS_MM_GAME and IsHero(player) then color = GetRoleColor("Hero") end
    local h = Instance.new("Highlight")
    h.FillColor = color h.FillTransparency = 0.7
    h.OutlineColor = color h.OutlineTransparency = 0
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Adornee = character h.Parent = character
    ESPHighlights[player] = h
end

function ClearAllESP()
    for _, h in pairs(ESPHighlights) do if h then h:Destroy() end end
    ESPHighlights = {}
end

local function CreateNameTag(player)
    if NameTagGuis[player] then NameTagGuis[player]:Destroy() end
    local character = player.Character
    if not character then return end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local b = Instance.new("BillboardGui")
    b.Size = UDim2.new(0, 200, 0, 50) b.StudsOffset = Vector3.new(0, 3.5, 0)
    b.AlwaysOnTop = true b.MaxDistance = 300 b.Adornee = root b.Parent = root

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0, 18) nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeTransparency = 0 nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.Font = Enum.Font.GothamBold nameLabel.TextSize = 14 nameLabel.Parent = b

    local role = GetPlayerRole(player)
    local roleColor = GetRoleColor(role)
    local roleText = role
    if IS_MM_GAME and IsHero(player) then roleText = "Hero" roleColor = GetRoleColor("Hero") end

    local roleLabel = Instance.new("TextLabel")
    roleLabel.Name = "RoleLabel" roleLabel.Size = UDim2.new(1, 0, 0, 14)
    roleLabel.Position = UDim2.new(0, 0, 0, 17) roleLabel.BackgroundTransparency = 1
    roleLabel.Text = roleText roleLabel.TextColor3 = roleColor
    roleLabel.TextStrokeTransparency = 0 roleLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    roleLabel.Font = Enum.Font.GothamSemibold roleLabel.TextSize = 12 roleLabel.Parent = b

    local invisLabel = Instance.new("TextLabel")
    invisLabel.Name = "InvisLabel" invisLabel.Size = UDim2.new(1, 0, 0, 14)
    invisLabel.Position = UDim2.new(0, 0, 0, 31) invisLabel.BackgroundTransparency = 1
    invisLabel.Text = "Invisible" invisLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    invisLabel.TextStrokeTransparency = 0 invisLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    invisLabel.Font = Enum.Font.GothamBold invisLabel.TextSize = 12 invisLabel.Visible = false invisLabel.Parent = b

    NameTagGuis[player] = b
end

function ClearAllNameTags()
    for _, g in pairs(NameTagGuis) do if g then g:Destroy() end end
    NameTagGuis = {}
end

function UpdateAllVisuals()
    ClearAllESP() ClearAllNameTags()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if Settings.PlayerESP then CreateESP(player) end
            if Settings.NameTags then CreateNameTag(player) end
        end
    end
end

local lastRoleCheck = 0
RunService.Heartbeat:Connect(function()
    if not Settings.PlayerESP and not Settings.NameTags and not Settings.SeeInvisibles then return end
    local now = tick()
    if now - lastRoleCheck < 0.1 then return end
    lastRoleCheck = now
    if Settings.SeeInvisibles then UpdateInvisibleESP() end
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local role = GetPlayerRole(player)
            local hero = IS_MM_GAME and IsHero(player)
            local invisible = Settings.SeeInvisibles and IsCharacterInvisible(player)
            if Settings.PlayerESP then
                local existing = ESPHighlights[player]
                if (IS_MM_GAME and role == "Lobby") and not invisible then
                    if existing then existing:Destroy() ESPHighlights[player] = nil end
                elseif invisible then
                    if existing then existing:Destroy() ESPHighlights[player] = nil end
                else
                    local color = hero and GetRoleColor("Hero") or GetRoleColor(role)
                    if existing then
                        if existing.FillColor ~= color then existing.FillColor = color existing.OutlineColor = color end
                    else CreateESP(player) end
                end
            end
            if Settings.NameTags then
                local gui = NameTagGuis[player]
                if not gui or not gui.Parent then CreateNameTag(player) gui = NameTagGuis[player] end
                if gui then
                    local roleLabel = gui:FindFirstChild("RoleLabel")
                    local invisLabel = gui:FindFirstChild("InvisLabel")
                    if roleLabel then
                        local roleText = hero and "Hero" or role
                        local roleColor = hero and GetRoleColor("Hero") or GetRoleColor(role)
                        if roleLabel.Text ~= roleText then roleLabel.Text = roleText end
                        if roleLabel.TextColor3 ~= roleColor then roleLabel.TextColor3 = roleColor end
                    end
                    if invisLabel then invisLabel.Visible = invisible end
                end
            end
        end
    end
end)

local function OnCharacterAdded(player, character)
    task.wait(0.2)
    if player ~= LocalPlayer then
        if Settings.PlayerESP then CreateESP(player) end
        if Settings.NameTags then CreateNameTag(player) end
    end
end

for _, player in pairs(Players:GetPlayers()) do
    player.CharacterAdded:Connect(function(c) OnCharacterAdded(player, c) end)
end
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(c) OnCharacterAdded(player, c) end)
end)

-- ============ ROLE NOTIFICATIONS ============
local NotifiedPlayers = { Murderer = {}, Sheriff = {} }

RunService.Heartbeat:Connect(function()
    if not IS_MM_GAME then return end
    if not Settings.MurderNotification and not Settings.SheriffNotification then return end
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local role = GetPlayerRole(player)
            if Settings.MurderNotification and role == "Murderer" and not NotifiedPlayers.Murderer[player] then
                NotifiedPlayers.Murderer[player] = true
                ShowNotification("УБИЙЦА НАЙДЕН", player.Name, Color3.fromRGB(230, 40, 40))
            end
            if Settings.SheriffNotification and role == "Sheriff" and not NotifiedPlayers.Sheriff[player] then
                NotifiedPlayers.Sheriff[player] = true
                ShowNotification("ШЕРИФ НАЙДЕН", player.Name, Color3.fromRGB(40, 120, 255))
            end
        end
    end
end)

if IS_MM_GAME and GameplayRemotes then
    local RoundEndFadeReset = GameplayRemotes:FindFirstChild("RoundEndFade")
    if RoundEndFadeReset then
        RoundEndFadeReset.OnClientEvent:Connect(function()
            NotifiedPlayers.Murderer = {} NotifiedPlayers.Sheriff = {}
        end)
    end
end

-- ============ SKYBOX / AMBIENCE ============
local Skyboxes = {
    Day = {SkyboxBk="rbxassetid://159454299",SkyboxDn="rbxassetid://159454296",SkyboxFt="rbxassetid://159454293",SkyboxLf="rbxassetid://159454286",SkyboxRt="rbxassetid://159454300",SkyboxUp="rbxassetid://159454288",Brightness=2,ClockTime=14,Ambient=Color3.fromRGB(130,130,130),OutdoorAmbient=Color3.fromRGB(128,128,128),FogEnd=100000,FogColor=Color3.fromRGB(200,200,200)},
    Night = {SkyboxBk="rbxassetid://12064107",SkyboxDn="rbxassetid://12064152",SkyboxFt="rbxassetid://12064121",SkyboxLf="rbxassetid://12063984",SkyboxRt="rbxassetid://12064115",SkyboxUp="rbxassetid://12064130",Brightness=1,ClockTime=0,Ambient=Color3.fromRGB(30,30,50),OutdoorAmbient=Color3.fromRGB(25,25,40),FogEnd=500,FogColor=Color3.fromRGB(20,20,40)},
    Evening = {SkyboxBk="rbxassetid://271042516",SkyboxDn="rbxassetid://271077243",SkyboxFt="rbxassetid://271042556",SkyboxLf="rbxassetid://271042310",SkyboxRt="rbxassetid://271042467",SkyboxUp="rbxassetid://271077958",Brightness=1.5,ClockTime=18,Ambient=Color3.fromRGB(100,80,80),OutdoorAmbient=Color3.fromRGB(90,70,70),FogEnd=1000,FogColor=Color3.fromRGB(150,100,80)},
    Sunset = {SkyboxBk="rbxassetid://105092364",SkyboxDn="rbxassetid://105092385",SkyboxFt="rbxassetid://105092306",SkyboxLf="rbxassetid://105092413",SkyboxRt="rbxassetid://105092351",SkyboxUp="rbxassetid://105092442",Brightness=2,ClockTime=17,Ambient=Color3.fromRGB(180,120,80),OutdoorAmbient=Color3.fromRGB(160,100,60),FogEnd=2000,FogColor=Color3.fromRGB(255,140,80)},
    Anime = {SkyboxBk="rbxassetid://6444884337",SkyboxDn="rbxassetid://6444884951",SkyboxFt="rbxassetid://6444884415",SkyboxLf="rbxassetid://6444883914",SkyboxRt="rbxassetid://6444883684",SkyboxUp="rbxassetid://6444885256",Brightness=3,ClockTime=12,Ambient=Color3.fromRGB(200,200,255),OutdoorAmbient=Color3.fromRGB(180,180,255),FogEnd=5000,FogColor=Color3.fromRGB(220,220,255)},
}

local CurrentSky, SavedLighting = nil, nil

local function SaveLighting()
    if SavedLighting then return end
    SavedLighting = {Brightness=Lighting.Brightness,ClockTime=Lighting.ClockTime,Ambient=Lighting.Ambient,OutdoorAmbient=Lighting.OutdoorAmbient,FogEnd=Lighting.FogEnd,FogColor=Lighting.FogColor,EnvironmentDiffuseScale=Lighting.EnvironmentDiffuseScale,EnvironmentSpecularScale=Lighting.EnvironmentSpecularScale}
end

function ApplySkybox(name)
    local d = Skyboxes[name]
    if not d then return end
    SaveLighting()
    if CurrentSky then CurrentSky:Destroy() end
    CurrentSky = Instance.new("Sky")
    CurrentSky.SkyboxBk = d.SkyboxBk CurrentSky.SkyboxDn = d.SkyboxDn CurrentSky.SkyboxFt = d.SkyboxFt
    CurrentSky.SkyboxLf = d.SkyboxLf CurrentSky.SkyboxRt = d.SkyboxRt CurrentSky.SkyboxUp = d.SkyboxUp
    CurrentSky.Parent = Lighting
    Lighting.Brightness = d.Brightness Lighting.ClockTime = d.ClockTime
    Lighting.Ambient = d.Ambient Lighting.OutdoorAmbient = d.OutdoorAmbient
    Lighting.FogEnd = d.FogEnd Lighting.FogColor = d.FogColor
end

function RemoveSkybox()
    if CurrentSky then CurrentSky:Destroy() CurrentSky = nil end
    if SavedLighting then
        Lighting.Brightness = SavedLighting.Brightness
        Lighting.ClockTime = SavedLighting.ClockTime
        Lighting.Ambient = SavedLighting.Ambient
        Lighting.OutdoorAmbient = SavedLighting.OutdoorAmbient
        Lighting.FogEnd = SavedLighting.FogEnd
        Lighting.FogColor = SavedLighting.FogColor
        Lighting.EnvironmentDiffuseScale = SavedLighting.EnvironmentDiffuseScale or 1
        Lighting.EnvironmentSpecularScale = SavedLighting.EnvironmentSpecularScale or 1
        SavedLighting = nil
    end
end

-- ============ SHADERS ============
local ShaderDOF = Instance.new("DepthOfFieldEffect")
ShaderDOF.FocusDistance = 5 ShaderDOF.InFocusRadius = 20 ShaderDOF.NearIntensity = 0 ShaderDOF.FarIntensity = 0 ShaderDOF.Parent = Lighting
local UltraBloom = Instance.new("BloomEffect")
UltraBloom.Intensity = 0 UltraBloom.Size = 24 UltraBloom.Threshold = 0.9 UltraBloom.Parent = Lighting
local UltraCC = Instance.new("ColorCorrectionEffect")
UltraCC.Brightness = 0 UltraCC.Contrast = 0 UltraCC.Saturation = 0 UltraCC.TintColor = Color3.fromRGB(255,255,255) UltraCC.Parent = Lighting
local UltraSun = Instance.new("SunRaysEffect")
UltraSun.Intensity = 0 UltraSun.Spread = 1 UltraSun.Parent = Lighting
local UltraAtmo = Instance.new("Atmosphere")
UltraAtmo.Density = 0 UltraAtmo.Offset = 0 UltraAtmo.Color = Color3.fromRGB(199,199,199)
UltraAtmo.Decay = Color3.fromRGB(106,112,125) UltraAtmo.Glare = 0 UltraAtmo.Haze = 0 UltraAtmo.Parent = Lighting

local function ApplyBlurShader(enabled)
    if enabled then
        TweenService:Create(ShaderDOF, TweenInfo.new(0.4), {FarIntensity = 1}):Play()
        TweenService:Create(UltraBloom, TweenInfo.new(0.4), {Intensity = 0}):Play()
        TweenService:Create(UltraCC, TweenInfo.new(0.4), {Saturation = 0, Contrast = 0, Brightness = 0}):Play()
        TweenService:Create(UltraSun, TweenInfo.new(0.4), {Intensity = 0}):Play()
        TweenService:Create(UltraAtmo, TweenInfo.new(0.4), {Density = 0, Haze = 0}):Play()
    else
        TweenService:Create(ShaderDOF, TweenInfo.new(0.4), {FarIntensity = 0}):Play()
    end
end

local function ApplyUltraRealismShader(enabled)
    if enabled then
        ShaderDOF.FocusDistance = 12 ShaderDOF.InFocusRadius = 40 ShaderDOF.NearIntensity = 0.15
        TweenService:Create(ShaderDOF, TweenInfo.new(0.6), {FarIntensity = 0.7}):Play()
        TweenService:Create(UltraBloom, TweenInfo.new(0.6), {Intensity = 0.6, Size = 28, Threshold = 0.85}):Play()
        TweenService:Create(UltraCC, TweenInfo.new(0.6), {Brightness = 0.05, Contrast = 0.15, Saturation = 0.25, TintColor = Color3.fromRGB(255,250,245)}):Play()
        TweenService:Create(UltraSun, TweenInfo.new(0.6), {Intensity = 0.12, Spread = 0.9}):Play()
        TweenService:Create(UltraAtmo, TweenInfo.new(0.6), {Density = 0.35, Haze = 1.5, Glare = 0.15, Color = Color3.fromRGB(190,195,205), Decay = Color3.fromRGB(115,120,135)}):Play()
        if not SavedLighting then
            SaveLighting()
            Lighting.OutdoorAmbient = Color3.fromRGB(80,85,95)
            Lighting.Ambient = Color3.fromRGB(70,75,85)
            Lighting.Brightness = 3
            Lighting.EnvironmentDiffuseScale = 0.6
            Lighting.EnvironmentSpecularScale = 0.8
        end
    else
        TweenService:Create(ShaderDOF, TweenInfo.new(0.6), {FarIntensity = 0, NearIntensity = 0}):Play()
        TweenService:Create(UltraBloom, TweenInfo.new(0.6), {Intensity = 0}):Play()
        TweenService:Create(UltraCC, TweenInfo.new(0.6), {Brightness = 0, Contrast = 0, Saturation = 0, TintColor = Color3.fromRGB(255,255,255)}):Play()
        TweenService:Create(UltraSun, TweenInfo.new(0.6), {Intensity = 0}):Play()
        TweenService:Create(UltraAtmo, TweenInfo.new(0.6), {Density = 0, Haze = 0, Glare = 0}):Play()
        if SavedLighting then
            Lighting.OutdoorAmbient = SavedLighting.OutdoorAmbient
            Lighting.Ambient = SavedLighting.Ambient
            Lighting.Brightness = SavedLighting.Brightness
            Lighting.EnvironmentDiffuseScale = SavedLighting.EnvironmentDiffuseScale or 1
            Lighting.EnvironmentSpecularScale = SavedLighting.EnvironmentSpecularScale or 1
            SavedLighting = nil
        end
    end
end

local ShaderModeName = "None"
local function SetShaderMode(mode)
    if ShaderModeName == mode then return end
    ShaderModeName = mode
    if mode == "None" then ApplyBlurShader(false) ApplyUltraRealismShader(false)
    elseif mode == "Blur" then ApplyUltraRealismShader(false) ApplyBlurShader(true)
    elseif mode == "Ultra" then ApplyBlurShader(false) ApplyUltraRealismShader(true) end
end

function ToggleShaders(enabled)
    Settings.Shaders = enabled
    if enabled then
        if ShaderModeName == "None" then SetShaderMode("Blur") else SetShaderMode(ShaderModeName) end
    else SetShaderMode("None") end
end

function SetShaderModeByNumber(num)
    if not Settings.Shaders then return end
    if num == 1 then SetShaderMode("Blur")
    elseif num == 2 then SetShaderMode("Ultra") end
end

-- ============ AURA ============
local AuraParts, AuraConnection, AuraLoopConnection = {}, nil, nil
local AuraTypes = {[1]={Mode="Fire"},[2]={Mode="Ice"},[3]={Mode="Lightning"}}

local function ClearAura()
    for _, p in pairs(AuraParts) do if p and p.Parent then p:Destroy() end end
    AuraParts = {}
    if AuraLoopConnection then AuraLoopConnection:Disconnect() AuraLoopConnection = nil end
end

local function ApplyAura()
    ClearAura()
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local d = AuraTypes[Settings.AuraType] or AuraTypes[1]
    if d.Mode == "Fire" then
        local att = Instance.new("Attachment") att.Position = Vector3.new(0,-2,0) att.Parent = root
        table.insert(AuraParts, att)
        local em = Instance.new("ParticleEmitter")
        em.Texture = "rbxassetid://243660364"
        em.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,200,50)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,100,20)),ColorSequenceKeypoint.new(1,Color3.fromRGB(150,20,0))})
        em.Size = NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(0.5,2),NumberSequenceKeypoint.new(1,0)})
        em.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(0.2,0.3),NumberSequenceKeypoint.new(1,1)})
        em.Lifetime = NumberRange.new(0.8,1.3) em.Rate = 60 em.Speed = NumberRange.new(4,8)
        em.SpreadAngle = Vector2.new(30,30) em.Rotation = NumberRange.new(0,360) em.RotSpeed = NumberRange.new(-30,30)
        em.LightEmission = 1 em.LightInfluence = 0 em.Acceleration = Vector3.new(0,8,0)
        em.Parent = att table.insert(AuraParts, em)
        local l = Instance.new("PointLight") l.Color = Color3.fromRGB(255,120,30) l.Range = 12 l.Brightness = 2 l.Parent = root
        table.insert(AuraParts, l)
    elseif d.Mode == "Ice" then
        local orbs = {}
        for i = 1, 8 do
            local c = Instance.new("Part")
            c.Size = Vector3.new(0.4,1.2,0.4) c.Material = Enum.Material.Glass c.Color = Color3.fromRGB(150,220,255)
            c.Transparency = 0.3 c.Anchored = true c.CanCollide = false c.CanQuery = false c.CanTouch = false c.CastShadow = false c.Parent = workspace
            table.insert(AuraParts, c) table.insert(orbs, c)
        end
        local t0 = tick()
        AuraLoopConnection = RunService.Heartbeat:Connect(function()
            if not Settings.Aura or Settings.AuraType ~= 2 then return end
            local ch = LocalPlayer.Character
            if not ch or not ch:FindFirstChild("HumanoidRootPart") then return end
            local rp = ch.HumanoidRootPart local e = tick() - t0
            for i, c in ipairs(orbs) do
                if c and c.Parent then
                    local a = e*1.5 + (i/8)*math.pi*2
                    c.CFrame = CFrame.new(rp.Position + Vector3.new(math.cos(a)*4, math.sin(e*2+i)*1.5, math.sin(a)*4)) * CFrame.Angles(e*2,e*3,e*2)
                end
            end
        end)
        local att = Instance.new("Attachment") att.Parent = root table.insert(AuraParts, att)
        local em = Instance.new("ParticleEmitter")
        em.Texture = "rbxassetid://243660364"
        em.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(200,240,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(100,180,255))})
        em.Size = NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(0.5,1.5),NumberSequenceKeypoint.new(1,0)})
        em.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(0.3,0.4),NumberSequenceKeypoint.new(1,1)})
        em.Lifetime = NumberRange.new(1,1.8) em.Rate = 30 em.Speed = NumberRange.new(1,3)
        em.SpreadAngle = Vector2.new(180,180) em.Rotation = NumberRange.new(0,360) em.RotSpeed = NumberRange.new(-60,60)
        em.LightEmission = 1 em.LightInfluence = 0
        em.Parent = att table.insert(AuraParts, em)
        local l = Instance.new("PointLight") l.Color = Color3.fromRGB(150,220,255) l.Range = 14 l.Brightness = 2 l.Parent = root
        table.insert(AuraParts, l)
    elseif d.Mode == "Lightning" then
        AuraLoopConnection = RunService.Heartbeat:Connect(function()
            if not Settings.Aura or Settings.AuraType ~= 3 then return end
            local ch = LocalPlayer.Character
            if not ch or not ch:FindFirstChild("HumanoidRootPart") then return end
            local rp = ch.HumanoidRootPart
            if math.random() < 0.3 then
                local b = Instance.new("Part")
                b.Size = Vector3.new(0.3,0.3,math.random(3,8)) b.Material = Enum.Material.Neon
                b.Color = Color3.fromRGB(150,200,255) b.Transparency = 0.3 b.Anchored = true
                b.CanCollide = false b.CanQuery = false b.CanTouch = false b.CastShadow = false b.Parent = workspace
                local l = Instance.new("PointLight") l.Color = Color3.fromRGB(150,200,255) l.Range = 8 l.Brightness = 3 l.Parent = b
                local a = math.random()*math.pi*2 local dd = math.random(20,50)/10
                b.CFrame = CFrame.new(rp.Position + Vector3.new(math.cos(a)*dd, math.random(-2,4), math.sin(a)*dd)) * CFrame.Angles(math.random()*math.pi*2,math.random()*math.pi*2,math.random()*math.pi*2)
                task.spawn(function()
                    for i = 1, 3 do
                        if b and b.Parent then b.Transparency = 0.8 task.wait(0.03) b.Transparency = 0.2 task.wait(0.03) end
                    end
                    if b then
                        TweenService:Create(b, TweenInfo.new(0.2), {Transparency = 1}):Play()
                        task.wait(0.2)
                        if b and b.Parent then b:Destroy() end
                    end
                end)
            end
        end)
        local att = Instance.new("Attachment") att.Parent = root table.insert(AuraParts, att)
        local em = Instance.new("ParticleEmitter")
        em.Texture = "rbxassetid://243660364"
        em.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(200,220,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(100,150,255))})
        em.Size = NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(0.5,1.2),NumberSequenceKeypoint.new(1,0)})
        em.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(0.3,0.3),NumberSequenceKeypoint.new(1,1)})
        em.Lifetime = NumberRange.new(0.5,1) em.Rate = 40 em.Speed = NumberRange.new(3,8)
        em.SpreadAngle = Vector2.new(180,180) em.Rotation = NumberRange.new(0,360) em.RotSpeed = NumberRange.new(-180,180)
        em.LightEmission = 1 em.LightInfluence = 0
        em.Parent = att table.insert(AuraParts, em)
        local l = Instance.new("PointLight") l.Color = Color3.fromRGB(150,200,255) l.Range = 14 l.Brightness = 2.5 l.Parent = root
        table.insert(AuraParts, l)
    end
end

function ToggleAura(enabled)
    Settings.Aura = enabled
    if enabled then
        ApplyAura()
        AuraConnection = LocalPlayer.CharacterAdded:Connect(function() task.wait(0.5) if Settings.Aura then ApplyAura() end end)
    else
        if AuraConnection then AuraConnection:Disconnect() AuraConnection = nil end
        ClearAura()
    end
end

function RefreshAura() if Settings.Aura then ApplyAura() end end

-- ============ PARTICLES ============
local ParticleParts, ParticleConnection = {}, nil
local PARTICLE_COUNT = 60

local function CreateSnowflake()
    local p = Instance.new("Part")
    p.Size = Vector3.new(0.25,0.25,0.25) p.Shape = Enum.PartType.Ball p.Material = Enum.Material.Neon
    p.Color = Color3.fromRGB(220,240,255) p.Transparency = 0.2 p.Anchored = true
    p.CanCollide = false p.CanQuery = false p.CanTouch = false p.CastShadow = false p.Locked = true p.Parent = workspace
    local l = Instance.new("PointLight") l.Color = Color3.fromRGB(220,240,255) l.Range = 3 l.Brightness = 1 l.Parent = p
    return p
end

local function GetRandomParticlePosition()
    local char = LocalPlayer.Character
    local cp = Vector3.new(0,50,0)
    if char and char:FindFirstChild("HumanoidRootPart") then cp = char.HumanoidRootPart.Position end
    local a = math.random()*math.pi*2 local d = math.random(150,600)/10
    return cp + Vector3.new(math.cos(a)*d, math.random(-40,40), math.sin(a)*d)
end

local function ClearParticles()
    for _, p in pairs(ParticleParts) do if p and p.Parent then p:Destroy() end end
    ParticleParts = {}
    if ParticleConnection then ParticleConnection:Disconnect() ParticleConnection = nil end
end

local function SpawnParticles()
    ClearParticles()
    for i = 1, PARTICLE_COUNT do
        local s = CreateSnowflake() s.Position = GetRandomParticlePosition() table.insert(ParticleParts, s)
    end
end

local function StartParticleAnimation()
    if ParticleConnection then ParticleConnection:Disconnect() ParticleConnection = nil end
    local pd = {}
    for i, p in ipairs(ParticleParts) do
        pd[p] = {basePos=p.Position,phaseX=math.random()*math.pi*2,phaseY=math.random()*math.pi*2,phaseZ=math.random()*math.pi*2,speedX=math.random(5,15)/10,speedY=math.random(8,20)/10,speedZ=math.random(5,15)/10,ampX=math.random(15,40)/10,ampY=math.random(20,50)/10,ampZ=math.random(15,40)/10,rotSpeed=math.random(-30,30)/10}
    end
    local t0 = tick()
    ParticleConnection = RunService.Heartbeat:Connect(function()
        if not Settings.Particles then return end
        local e = tick() - t0
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local pp = char.HumanoidRootPart.Position
        for i, p in ipairs(ParticleParts) do
            if not p or not p.Parent then continue end
            local d = pd[p]
            if not d then continue end
            local ox = math.sin(e*d.speedX+d.phaseX)*d.ampX
            local oy = math.cos(e*d.speedY+d.phaseY)*d.ampY
            local oz = math.sin(e*d.speedZ+d.phaseZ)*d.ampZ
            local tp = d.basePos + Vector3.new(ox,oy,oz)
            if (tp-pp).Magnitude > 120 then
                d.basePos = GetRandomParticlePosition()
                d.phaseX = math.random()*math.pi*2 d.phaseY = math.random()*math.pi*2 d.phaseZ = math.random()*math.pi*2
                tp = d.basePos
            end
            p.Position = tp
            p.CFrame = CFrame.new(p.Position) * CFrame.Angles(e*d.rotSpeed, e*d.rotSpeed*0.7, e*d.rotSpeed*0.5)
            local l = p:FindFirstChildOfClass("PointLight")
            if l then l.Brightness = 0.8 + math.sin(e*2+d.phaseX)*0.4 end
        end
    end)
end

function ToggleParticles(enabled)
    Settings.Particles = enabled
    if enabled then SpawnParticles() StartParticleAnimation() else ClearParticles() end
end

-- ============ TRACERS ============
local TracerLines = {}
local TracerConnection = nil

local function ClearAllTracers()
    for _, line in pairs(TracerLines) do if line then pcall(function() line:Remove() end) end end
    TracerLines = {}
end

local function StartTracers()
    if TracerConnection then TracerConnection:Disconnect() TracerConnection = nil end
    TracerConnection = RunService.RenderStepped:Connect(function()
        if not Settings.Tracers then return end
        if not IS_MM_GAME then return end
        if GetPlayerRole(LocalPlayer) == "Lobby" then
            for player, line in pairs(TracerLines) do
                if line then pcall(function() line:Remove() end) end
                TracerLines[player] = nil
            end
            return
        end
        local localChar = LocalPlayer.Character
        if not localChar then return end
        local localRoot = localChar:FindFirstChild("HumanoidRootPart")
        if not localRoot then return end
        local originX = Camera.ViewportSize.X / 2
        local originY = Camera.ViewportSize.Y - 10
        local activePlayers = {}
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local role = GetPlayerRole(player)
                if role ~= "Lobby" then
                    local char = player.Character
                    local root = char:FindFirstChild("HumanoidRootPart")
                    local humanoid = char:FindFirstChildOfClass("Humanoid")
                    if root and humanoid and humanoid.Health > 0 then
                        local camToPlayer = root.Position - Camera.CFrame.Position
                        local dot = camToPlayer:Dot(Camera.CFrame.LookVector)
                        if dot > 0 then
                            local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)
                            if onScreen then
                                activePlayers[player] = true
                                local line = TracerLines[player]
                                if not line then
                                    line = Drawing.new("Line")
                                    line.Thickness = 1.5
                                    line.Transparency = 0.9
                                    TracerLines[player] = line
                                end
                                local color = GetRoleColor(role)
                                if IS_MM_GAME and IsHero(player) then color = GetRoleColor("Hero") end
                                line.Color = color
                                line.From = Vector2.new(originX, originY)
                                line.To = Vector2.new(screenPos.X, screenPos.Y)
                                line.Visible = true
                            end
                        end
                    end
                end
            end
        end
        for player, line in pairs(TracerLines) do
            if not activePlayers[player] then
                if line then pcall(function() line:Remove() end) end
                TracerLines[player] = nil
            end
        end
    end)
end

function ToggleTracers(enabled)
    Settings.Tracers = enabled
    if enabled then StartTracers()
    else
        if TracerConnection then TracerConnection:Disconnect() TracerConnection = nil end
        ClearAllTracers()
    end
end

-- ============ AUTO GUN LOOTER ============
local GunLooterConnection = nil
local LastLootTime = 0
local LOOT_COOLDOWN = 0.15
local CachedGunDrops = {}
local LastCacheUpdate = 0
local CACHE_UPDATE_INTERVAL = 0.5

local function IsGunDrop(obj)
    if not obj then return false end
    if not (obj:IsA("Model") or obj:IsA("BasePart") or obj:IsA("Tool")) then return false end
    local name = obj.Name:lower()
    if name == "gundrop" or name:find("gundrop") then return true end
    if name == "knifedrop" or name:find("knifedrop") then return true end
    if name == "droppedgun" or name == "dropped_gun" then return true end
    return false
end

local function IsMineOrInHands(obj, myChar)
    if myChar and obj:IsDescendantOf(myChar) then return true end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Character and obj:IsDescendantOf(plr.Character) then return true end
        local bp = plr:FindFirstChild("Backpack")
        if bp and obj:IsDescendantOf(bp) then return true end
    end
    return false
end

local function UpdateGunDropCache()
    local myChar = LocalPlayer.Character
    local newCache = {}
    local seen = {}
    for _, obj in pairs(workspace:GetChildren()) do
        if IsGunDrop(obj) and not seen[obj] then
            seen[obj] = true
            if not IsMineOrInHands(obj, myChar) then table.insert(newCache, obj) end
        end
    end
    local foldersToCheck = {"DroppedItems", "Items", "Drops", "Weapons", "Objects", "Map", "ItemsFolder", "ToolDrops"}
    for _, folderName in ipairs(foldersToCheck) do
        local folder = workspace:FindFirstChild(folderName)
        if folder then
            for _, obj in pairs(folder:GetDescendants()) do
                if IsGunDrop(obj) and not seen[obj] then
                    seen[obj] = true
                    if not IsMineOrInHands(obj, myChar) then table.insert(newCache, obj) end
                end
            end
        end
    end
    for _, child in pairs(workspace:GetChildren()) do
        if child:IsA("Folder") or child:IsA("Model") then
            for _, obj in pairs(child:GetChildren()) do
                if IsGunDrop(obj) and not seen[obj] then
                    seen[obj] = true
                    if not IsMineOrInHands(obj, myChar) then table.insert(newCache, obj) end
                end
            end
        end
    end
    CachedGunDrops = newCache
    LastCacheUpdate = tick()
end

local function TeleportGunToMe(gunDrop, myRoot)
    if not gunDrop or not myRoot then return false end
    local targetCFrame = CFrame.new(myRoot.Position + Vector3.new(0, -2.5, 0))
    local moved = false
    if gunDrop:IsA("Model") then
        for _, part in pairs(gunDrop:GetDescendants()) do
            if part:IsA("BasePart") then
                if part.Anchored then pcall(function() part.Anchored = false end) end
                if part.CanCollide then pcall(function() part.CanCollide = false end) end
            end
        end
        pcall(function() gunDrop:PivotTo(targetCFrame) moved = true end)
    elseif gunDrop:IsA("BasePart") then
        if gunDrop.Anchored then pcall(function() gunDrop.Anchored = false end) end
        local ok = pcall(function() gunDrop.CFrame = targetCFrame gunDrop.Velocity = Vector3.zero end)
        if ok then moved = true end
    end
    return moved
end

local function FindNearestGunFromCache()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local myPos = char.HumanoidRootPart.Position
    local nearest, nearestDist = nil, math.huge
    for _, obj in ipairs(CachedGunDrops) do
        if obj and obj.Parent then
            local pos = nil
            if obj:IsA("Model") then
                local primary = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                if primary then pos = primary.Position end
            elseif obj:IsA("BasePart") then
                pos = obj.Position
            elseif obj:IsA("Tool") then
                local h = obj:FindFirstChild("Handle")
                if h and h:IsA("BasePart") then pos = h.Position end
            end
            if pos then
                local dist = (pos - myPos).Magnitude
                if dist < nearestDist then nearestDist = dist nearest = obj end
            end
        end
    end
    return nearest
end

function ToggleAutoGunLooter(enabled)
    Settings.AutoGunLooter = enabled
    if enabled then
        UpdateGunDropCache()
        GunLooterConnection = RunService.Heartbeat:Connect(function()
            if not Settings.AutoGunLooter then return end
            local now = tick()
            if now - LastLootTime < LOOT_COOLDOWN then return end
            local char = LocalPlayer.Character
            if not char then return end
            if char:FindFirstChildOfClass("Tool") then return end
            local myRoot = char:FindFirstChild("HumanoidRootPart")
            if not myRoot then return end
            if now - LastCacheUpdate > CACHE_UPDATE_INTERVAL then UpdateGunDropCache() end
            local gun = FindNearestGunFromCache()
            if gun then LastLootTime = now TeleportGunToMe(gun, myRoot) end
        end)
    else
        if GunLooterConnection then GunLooterConnection:Disconnect() GunLooterConnection = nil end
        CachedGunDrops = {}
    end
end

-- ============ KILL ALL ============
local KillAllRunning = false

local function GetKnifeTool(char)
    for _, tool in pairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            local n = tool.Name:lower()
            if n:find("knife") or n:find("sword") or n:find("blade") or n:find("dagger") then return tool end
        end
    end
    return nil
end

local function RunKillAll()
    if not IS_MM_GAME then return end
    if KillAllRunning then return end
    KillAllRunning = true
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        local myRoot = char:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end
        local orig = myRoot.CFrame
        local knife = GetKnifeTool(char)
        if not knife then return end
        for _, player in pairs(Players:GetPlayers()) do
            if not Settings.KillAll then break end
            if player ~= LocalPlayer then
                local info = PlayerData[player.Name]
                if info and type(info) == "table" and info.Dead ~= true and info.Role and info.Role ~= "" then
                    local tChar = player.Character
                    if tChar then
                        local h = tChar:FindFirstChildOfClass("Humanoid")
                        local root = tChar:FindFirstChild("HumanoidRootPart")
                        if h and root and h.Health > 0 then
                            myRoot.CFrame = root.CFrame + Vector3.new(0, 3, 0)
                            task.wait(0.08)
                            myRoot.CFrame = CFrame.lookAt(myRoot.Position, root.Position)
                            pcall(function() knife:Activate() end)
                            task.wait(0.15)
                        end
                    end
                end
            end
        end
        if myRoot and myRoot.Parent then myRoot.CFrame = orig end
    end)
    KillAllRunning = false
end

function ToggleKillAll(enabled)
    if not IS_MM_GAME then return end
    Settings.KillAll = enabled
    if enabled then
        task.spawn(function()
            while Settings.KillAll do RunKillAll() task.wait(1) end
        end)
    end
end

-- ============ CHOOSE MAP ============
local ChooseMapRunning = false

local function FindAllVotePads()
    local pads = {}
    local lobby = workspace:FindFirstChild("RegularLobby")
    local root = lobby or workspace
    for _, obj in pairs(root:GetChildren()) do
        if obj.Name:match("^VotePad%d+$") then table.insert(pads, obj) end
    end
    return pads
end

local function GetMapNameFromPad(votePad)
    local mi = votePad:FindFirstChild("MapInfoGui")
    if not mi then return nil end
    local gm = mi:FindFirstChild("GameMode")
    if gm and gm:IsA("TextLabel") and gm.Text ~= "" then return gm.Text end
    for _, obj in pairs(mi:GetDescendants()) do
        if obj:IsA("TextLabel") and obj.Text ~= "" then return obj.Text end
    end
    return nil
end

local function GetPadPart(votePad)
    local pad = votePad:FindFirstChild("Pad")
    if pad then
        if pad:IsA("BasePart") then return pad end
        if pad:IsA("Model") then return pad.PrimaryPart or pad:FindFirstChildWhichIsA("BasePart") end
    end
    return votePad:FindFirstChildWhichIsA("BasePart")
end

local function GetAvailableMaps()
    local result = {}
    for _, pad in ipairs(FindAllVotePads()) do
        local n = GetMapNameFromPad(pad)
        if n then result[n] = pad end
    end
    return result
end

local function RespawnSelf()
    local char = LocalPlayer.Character
    if char then
        local h = char:FindFirstChildOfClass("Humanoid")
        if h then h.Health = 0 end
    end
end

local function VoteOnPad(votePad)
    if not votePad or not votePad.Parent then return false end
    local part = GetPadPart(votePad)
    if not part then return false end
    local char = LocalPlayer.Character
    if not char then return false end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    root.CFrame = CFrame.new(part.Position + Vector3.new(0,3,0)) root.Velocity = Vector3.zero
    return true
end

local function Start100ChooseMap(mapName)
    if ChooseMapRunning then return end
    ChooseMapRunning = true
    task.spawn(function()
        for i = 1, 20 do
            if not Settings.ChooseMap100 then break end
            local maps = GetAvailableMaps()
            local pad = maps[mapName]
            if pad then VoteOnPad(pad) task.wait(0.4) end
            RespawnSelf() task.wait(0.8)
        end
        ChooseMapRunning = false Settings.ChooseMap100 = false
    end)
end

function OpenChooseMapSelector()
    local existing = ScreenGui:FindFirstChild("ChooseMapSelector")
    if existing then existing:Destroy() end
    local frame = Instance.new("Frame")
    frame.Name = "ChooseMapSelector"
    frame.Size = UDim2.new(0, 300, 0, 400)
    frame.Position = UDim2.new(0.5, -150, 0.5, -200)
    frame.BackgroundColor3 = Colors.CardBg
    frame.BackgroundTransparency = 0.05
    frame.BorderSizePixel = 0
    frame.ZIndex = 50
    frame.Active = true
    frame.Draggable = true
    frame.Parent = ScreenGui
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 10) c.Parent = frame
    local s = Instance.new("UIStroke") s.Color = Colors.Accent s.Thickness = 1.2 s.Transparency = 0.3 s.Parent = frame
    local t = Instance.new("TextLabel") t.Size = UDim2.new(1, -40, 0, 26) t.Position = UDim2.new(0, 14, 0, 10)
    t.BackgroundTransparency = 1 t.Text = "Choose Map - 100x" t.TextColor3 = Colors.Text
    t.Font = Enum.Font.GothamBold t.TextSize = 12 t.TextXAlignment = Enum.TextXAlignment.Left t.Parent = frame
    local cb = Instance.new("TextButton") cb.Size = UDim2.new(0, 22, 0, 22) cb.Position = UDim2.new(1, -30, 0, 10)
    cb.BackgroundColor3 = Color3.fromRGB(220, 50, 50) cb.BorderSizePixel = 0
    cb.Text = "X" cb.TextColor3 = Color3.fromRGB(255, 255, 255)
    cb.Font = Enum.Font.GothamBold cb.TextSize = 11 cb.Parent = frame
    local cbc = Instance.new("UICorner") cbc.CornerRadius = UDim.new(0, 5) cbc.Parent = cb
    cb.MouseButton1Click:Connect(function() frame:Destroy() end)
    local rb = Instance.new("TextButton") rb.Size = UDim2.new(1, -28, 0, 26) rb.Position = UDim2.new(0, 14, 0, 50)
    rb.BackgroundColor3 = Colors.CardBg rb.BackgroundTransparency = 0.1
    rb.BorderSizePixel = 0 rb.Text = "ОБНОВИТЬ СПИСОК КАРТ"
    rb.TextColor3 = Colors.Text rb.Font = Enum.Font.GothamBold rb.TextSize = 10 rb.Parent = frame
    local rbc = Instance.new("UICorner") rbc.CornerRadius = UDim.new(0, 6) rbc.Parent = rb
    local rbs = Instance.new("UIStroke") rbs.Color = Colors.Accent rbs.Thickness = 1 rbs.Transparency = 0.4 rbs.Parent = rb
    local scroll = Instance.new("ScrollingFrame") scroll.Size = UDim2.new(1, -28, 1, -116) scroll.Position = UDim2.new(0, 14, 0, 88)
    scroll.BackgroundTransparency = 1 scroll.BorderSizePixel = 0 scroll.ScrollBarThickness = 3
    scroll.ScrollBarImageColor3 = Colors.CardStroke scroll.CanvasSize = UDim2.new(0, 0, 0, 0) scroll.Parent = frame
    local ll = Instance.new("UIListLayout") ll.SortOrder = Enum.SortOrder.LayoutOrder ll.Padding = UDim.new(0, 5) ll.Parent = scroll
    local function Populate()
        for _, ch in pairs(scroll:GetChildren()) do if ch:IsA("TextButton") then ch:Destroy() end end
        local maps = GetAvailableMaps()
        local yPos = 0
        for name, pad in pairs(maps) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 30) btn.BackgroundColor3 = Colors.CardBg
            btn.BackgroundTransparency = 0.35 btn.BorderSizePixel = 0
            btn.Text = name btn.TextColor3 = Colors.Text btn.Font = Enum.Font.GothamMedium
            btn.TextSize = 11 btn.AutoButtonColor = false btn.Parent = scroll
            local bc = Instance.new("UICorner") bc.CornerRadius = UDim.new(0, 6) bc.Parent = btn
            btn.MouseButton1Click:Connect(function()
                Settings.SelectedMap = name Settings.ChooseMap100 = true Start100ChooseMap(name) frame:Destroy()
            end)
            yPos = yPos + 35
        end
        if yPos == 0 then
            local e = Instance.new("TextLabel")
            e.Size = UDim2.new(1, 0, 0, 30) e.BackgroundTransparency = 1 e.Text = "Карты не найдены."
            e.TextColor3 = Colors.TextDim e.Font = Enum.Font.Gotham e.TextSize = 11 e.TextWrapped = true e.Parent = scroll
            yPos = 40
        end
        scroll.CanvasSize = UDim2.new(0, 0, 0, yPos)
    end
    rb.MouseButton1Click:Connect(Populate) Populate()
end

function Toggle100ChooseMap(enabled)
    if not IS_MM_GAME then return end
    Settings.ChooseMap100 = enabled
    if enabled then OpenChooseMapSelector() else Settings.ChooseMap100 = false end
end

-- ============ FLY ============
local FlyBV, FlyBG, FlyConnection = nil, nil, nil
function ToggleFly(enabled)
    Settings.Fly = enabled
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return end
    if enabled then
        hum.PlatformStand = true hum:ChangeState(Enum.HumanoidStateType.Physics)
        FlyBV = Instance.new("BodyVelocity") FlyBV.MaxForce = Vector3.new(1e5,1e5,1e5) FlyBV.P = 1250 FlyBV.Velocity = Vector3.zero FlyBV.Parent = root
        FlyBG = Instance.new("BodyGyro") FlyBG.MaxTorque = Vector3.new(1e6,1e6,1e6) FlyBG.P = 3000 FlyBG.D = 500 FlyBG.CFrame = root.CFrame FlyBG.Parent = root
        FlyConnection = RunService.RenderStepped:Connect(function()
            if not Settings.Fly or not root or not root.Parent or not FlyBV or not FlyBG then return end
            local v = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then v += Vector3.new(0,50,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then v += Vector3.new(0,-50,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then v += Camera.CFrame.LookVector*50 end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then v -= Camera.CFrame.LookVector*50 end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then v -= Camera.CFrame.RightVector*50 end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then v += Camera.CFrame.RightVector*50 end
            FlyBV.Velocity = v
            local ld = Camera.CFrame.LookVector local fl = Vector3.new(ld.X,0,ld.Z)
            if fl.Magnitude > 0.01 then FlyBG.CFrame = CFrame.lookAt(root.Position, root.Position+fl.Unit) end
            root.AssemblyAngularVelocity = Vector3.zero root.RotVelocity = Vector3.zero
        end)
    else
        if FlyConnection then FlyConnection:Disconnect() FlyConnection = nil end
        if FlyBV then FlyBV:Destroy() FlyBV = nil end
        if FlyBG then FlyBG:Destroy() FlyBG = nil end
        if hum then hum.PlatformStand = false hum:ChangeState(Enum.HumanoidStateType.GettingUp) end
    end
end

-- ============ NOCLIP ============
local NoClipConnection = nil
function ToggleNoClip(enabled)
    Settings.NoClip = enabled
    if enabled then
        NoClipConnection = RunService.Stepped:Connect(function()
            if not Settings.NoClip then return end
            local char = LocalPlayer.Character
            if not char then return end
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
            end
        end)
    else
        if NoClipConnection then NoClipConnection:Disconnect() NoClipConnection = nil end
        local char = LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
        end
    end
end

-- ============ LOCK MOUSE ============
function ToggleLockMouse(enabled)
    Settings.LockMouse = enabled
    UserInputService.MouseBehavior = enabled and Enum.MouseBehavior.LockCenter or Enum.MouseBehavior.Default
end

-- ============ AIMBOT ============
local AimBotConnection
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2 FOVCircle.Radius = 100 FOVCircle.Color = Color3.fromRGB(150,100,255)
FOVCircle.Transparency = 0.8 FOVCircle.Visible = false FOVCircle.Filled = false

local function IsVisibleCheck(targetPart)
    if not Settings.AimBotWallCheck then return true end
    local origin = Camera.CFrame.Position
    local dir = (targetPart.Position - origin)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {LocalPlayer.Character, targetPart.Parent}
    return workspace:Raycast(origin, dir, params) == nil
end

function ToggleAimBot(enabled)
    Settings.AimBot = enabled
    FOVCircle.Visible = enabled FOVCircle.Radius = Settings.AimBotFOV
    if enabled then
        AimBotConnection = RunService.RenderStepped:Connect(function()
            if not Settings.AimBot then return end
            local target, closest = nil, Settings.AimBotFOV
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local h = player.Character:FindFirstChildOfClass("Humanoid")
                    local rp = player.Character:FindFirstChild("HumanoidRootPart")
                    if h and rp and h.Health > 0 then
                        local skip = false
                        if IS_MM_GAME and Settings.AimBotOnlyMurderer then
                            if GetPlayerRole(player) ~= "Murderer" then skip = true end
                        end
                        if not skip then
                            if IsVisibleCheck(rp) then
                                local sp, onScreen = Camera:WorldToScreenPoint(rp.Position)
                                if onScreen then
                                    local dd = (Vector2.new(sp.X,sp.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                                    if dd < closest then closest = dd target = rp end
                                end
                            end
                        end
                    end
                end
            end
            if target then
                local pred = target.Velocity * (Settings.AimBotPrediction/100)
                Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, target.Position + pred)
            end
        end)
    else
        if AimBotConnection then AimBotConnection:Disconnect() AimBotConnection = nil end
    end
end

RunService.RenderStepped:Connect(function()
    if FOVCircle.Visible then
        FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    end
end)

-- ============ BIND KEYS ============
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if Settings.FlyKey and input.KeyCode == Settings.FlyKey then ToggleFly(not Settings.Fly) end
    if Settings.NoClipKey and input.KeyCode == Settings.NoClipKey then ToggleNoClip(not Settings.NoClip) end
    if Settings.AimBotKey and input.KeyCode == Settings.AimBotKey then ToggleAimBot(not Settings.AimBot) end
    if Settings.LockMouseKey and input.KeyCode == Settings.LockMouseKey then ToggleLockMouse(not Settings.LockMouse) end
end)

print("LAGGERHUB загружен | MM-игра: " .. tostring(IS_MM_GAME))
