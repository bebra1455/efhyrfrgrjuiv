--[[
    MegolaHub | LOADER
    Выбор версии + проверка ключа + загрузка с GitHub
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")

-- ============================================================
-- НАСТРОЙКИ
-- ============================================================
local URLS = {
    User    = "https://raw.githubusercontent.com/bebra1455/rgththynjyu/refs/heads/main/rgjtugtyujk.lua",
    Premium = "https://raw.githubusercontent.com/bebra1455/frgthktgjtujgvmtkbv/refs/heads/main/rgttjhgty.lua",
    Dev     = "https://raw.githubusercontent.com/bebra1455/rgthytnynjuyjnu/refs/heads/main/rgrhgrgrm.lua",
}

local KEYS = {
    User    = {"MEGOLA-USER-7K4P", "MEGOLA-USER-2X9M", "MEGOLA-USER-8Q3L", "MEGOLA-USER-5R7T", "MEGOLA-USER-9W2N"},
    Premium = {"MEGOLA-PREM-3H8B", "MEGOLA-PREM-6Y1V", "MEGOLA-PREM-4D9F", "MEGOLA-PREM-7C2J", "MEGOLA-PREM-1L5S"},
    Dev     = {"MEGOLA-DEV-9Z6A", "MEGOLA-DEV-2G4E", "MEGOLA-DEV-8T1Q", "MEGOLA-DEV-5P7R", "MEGOLA-DEV-3M9K"},
}

local KEY_FILE = "megolahub_key.txt"

-- ============================================================
-- ЦВЕТА
-- ============================================================
local Colors = {
    Background = Color3.fromRGB(20, 20, 22),
    Sidebar = Color3.fromRGB(15, 15, 17),
    CardBackground = Color3.fromRGB(35, 35, 40),
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(160, 160, 170),
    AccentBlue = Color3.fromRGB(90, 130, 255),
    AccentPurple = Color3.fromRGB(160, 90, 255),
    Border = Color3.fromRGB(60, 60, 70),
    SearchBar = Color3.fromRGB(30, 30, 35),
    Error = Color3.fromRGB(230, 60, 60),
    Success = Color3.fromRGB(60, 220, 120),
}

-- ============================================================
-- ФУНКЦИИ ЗАЩИТЫ / ФАЙЛА
-- ============================================================
local function SaveKey(version, key)
    pcall(function()
        writefile(KEY_FILE, version .. "|" .. key)
    end)
end

local function LoadKey()
    local ok, data = pcall(function()
        if isfile and isfile(KEY_FILE) then
            return readfile(KEY_FILE)
        end
        return nil
    end)
    if ok and data and data ~= "" then
        local version, key = data:match("^(.-)|(.+)$")
        if version and key then
            return version, key
        end
    end
    return nil, nil
end

local function ClearKey()
    pcall(function()
        if delfile then delfile(KEY_FILE) end
    end)
end

local function CheckKey(version, key)
    local list = KEYS[version]
    if not list then return false end
    for _, k in ipairs(list) do
        if k == key then return true end
    end
    return false
end

-- ============================================================
-- SCREEN GUI
-- ============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MegolaHubLoader"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = game.CoreGui

local BlurEffect = Instance.new("BlurEffect")
BlurEffect.Name = "MegolaHubLoader_Blur"
BlurEffect.Size = 12
BlurEffect.Parent = Lighting

-- ============================================================
-- ГЛАВНАЯ КАРТОЧКА
-- ============================================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "LoaderFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 340)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -170)
MainFrame.BackgroundColor3 = Colors.Background
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Colors.Border
MainStroke.Thickness = 1
MainStroke.Transparency = 0.4
MainStroke.Parent = MainFrame

local MainGradient = Instance.new("UIGradient")
MainGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 28, 34)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 18, 22)),
})
MainGradient.Rotation = 45
MainGradient.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 0, 35)
Title.Position = UDim2.new(0, 20, 0, 18)
Title.BackgroundTransparency = 1
Title.Text = "MegolaHub"
Title.TextColor3 = Colors.Text
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 26
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 180, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 90, 255)),
})
TitleGradient.Parent = Title

task.spawn(function()
    while Title.Parent do
        for i = 0, 1, 0.02 do
            TitleGradient.Offset = Vector2.new(i, 0)
            task.wait(0.03)
        end
        for i = 1, 0, -0.02 do
            TitleGradient.Offset = Vector2.new(i, 0)
            task.wait(0.03)
        end
    end
end)

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1, -40, 0, 18)
SubTitle.Position = UDim2.new(0, 20, 0, 54)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "Выберите версию для запуска"
SubTitle.TextColor3 = Colors.TextDim
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextSize = 12
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = MainFrame

local VersionContainer = Instance.new("Frame")
VersionContainer.Size = UDim2.new(1, -40, 0, 90)
VersionContainer.Position = UDim2.new(0, 20, 0, 85)
VersionContainer.BackgroundTransparency = 1
VersionContainer.Parent = MainFrame

local VList = Instance.new("UIListLayout")
VList.FillDirection = Enum.FillDirection.Horizontal
VList.Padding = UDim.new(0, 10)
VList.Parent = VersionContainer

local function CreateVersionCard(name, subtitle, color)
    local card = Instance.new("TextButton")
    card.Size = UDim2.new(0, 150, 1, 0)
    card.BackgroundColor3 = Colors.CardBackground
    card.BackgroundTransparency = 0.05
    card.BorderSizePixel = 0
    card.Text = ""
    card.AutoButtonColor = false
    card.Parent = VersionContainer

    local cCorner = Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(0, 10)
    cCorner.Parent = card

    local cStroke = Instance.new("UIStroke")
    cStroke.Color = color
    cStroke.Thickness = 1.5
    cStroke.Transparency = 0.3
    cStroke.Parent = card

    local cGradient = Instance.new("UIGradient")
    cGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 32)),
    })
    cGradient.Rotation = 90
    cGradient.Parent = card

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -20, 0, 30)
    nameLabel.Position = UDim2.new(0, 10, 0, 15)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = name
    nameLabel.TextColor3 = color
    nameLabel.Font = Enum.Font.GothamBlack
    nameLabel.TextSize = 18
    nameLabel.Parent = card

    local subLabel = Instance.new("TextLabel")
    subLabel.Size = UDim2.new(1, -20, 0, 18)
    subLabel.Position = UDim2.new(0, 10, 0, 48)
    subLabel.BackgroundTransparency = 1
    subLabel.Text = subtitle
    subLabel.TextColor3 = Colors.TextDim
    subLabel.Font = Enum.Font.Gotham
    subLabel.TextSize = 11
    subLabel.Parent = card

    return card
end

local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(1, -40, 0, 90)
KeyFrame.Position = UDim2.new(0, 20, 0, 85)
KeyFrame.BackgroundTransparency = 1
KeyFrame.Visible = false
KeyFrame.Parent = MainFrame

local KeyBackBtn = Instance.new("TextButton")
KeyBackBtn.Size = UDim2.new(0, 60, 0, 24)
KeyBackBtn.Position = UDim2.new(0, 0, 0, 0)
KeyBackBtn.BackgroundColor3 = Colors.SearchBar
KeyBackBtn.BackgroundTransparency = 0.2
KeyBackBtn.BorderSizePixel = 0
KeyBackBtn.Text = "← Назад"
KeyBackBtn.TextColor3 = Colors.TextDim
KeyBackBtn.Font = Enum.Font.GothamSemibold
KeyBackBtn.TextSize = 11
KeyBackBtn.AutoButtonColor = false
KeyBackBtn.Parent = KeyFrame

local kbCorner = Instance.new("UICorner")
kbCorner.CornerRadius = UDim.new(0, 5)
kbCorner.Parent = KeyBackBtn

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, -70, 0, 24)
KeyTitle.Position = UDim2.new(0, 70, 0, 0)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "Введите ключ"
KeyTitle.TextColor3 = Colors.Text
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.TextSize = 14
KeyTitle.TextXAlignment = Enum.TextXAlignment.Left
KeyTitle.Parent = KeyFrame

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(1, 0, 0, 40)
KeyInput.Position = UDim2.new(0, 0, 0, 34)
KeyInput.BackgroundColor3 = Colors.SearchBar
KeyInput.BackgroundTransparency = 0.2
KeyInput.BorderSizePixel = 0
KeyInput.Text = ""
KeyInput.PlaceholderText = "MEGOLA-XXXX-0000"
KeyInput.PlaceholderColor3 = Colors.TextDim
KeyInput.TextColor3 = Colors.Text
KeyInput.Font = Enum.Font.GothamSemibold
KeyInput.TextSize = 14
KeyInput.ClearTextOnFocus = false
KeyInput.Parent = KeyFrame

local kiCorner = Instance.new("UICorner")
kiCorner.CornerRadius = UDim.new(0, 8)
kiCorner.Parent = KeyInput

local kiStroke = Instance.new("UIStroke")
kiStroke.Color = Colors.Border
kiStroke.Thickness = 1
kiStroke.Transparency = 0.4
kiStroke.Parent = KeyInput

local LoadFrame = Instance.new("Frame")
LoadFrame.Size = UDim2.new(1, -40, 0, 90)
LoadFrame.Position = UDim2.new(0, 20, 0, 85)
LoadFrame.BackgroundTransparency = 1
LoadFrame.Visible = false
LoadFrame.Parent = MainFrame

local LoadStatus = Instance.new("TextLabel")
LoadStatus.Size = UDim2.new(1, 0, 0, 24)
LoadStatus.Position = UDim2.new(0, 0, 0, 10)
LoadStatus.BackgroundTransparency = 1
LoadStatus.Text = "Проверка ключа..."
LoadStatus.TextColor3 = Colors.Text
LoadStatus.Font = Enum.Font.GothamBold
LoadStatus.TextSize = 14
LoadStatus.Parent = LoadFrame

local LoadPercent = Instance.new("TextLabel")
LoadPercent.Size = UDim2.new(1, 0, 0, 20)
LoadPercent.Position = UDim2.new(0, 0, 0, 36)
LoadPercent.BackgroundTransparency = 1
LoadPercent.Text = "0%"
LoadPercent.TextColor3 = Colors.AccentBlue
LoadPercent.Font = Enum.Font.GothamBlack
LoadPercent.TextSize = 16
LoadPercent.Parent = LoadFrame

local BarBg = Instance.new("Frame")
BarBg.Size = UDim2.new(1, 0, 0, 8)
BarBg.Position = UDim2.new(0, 0, 0, 68)
BarBg.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
BarBg.BorderSizePixel = 0
BarBg.Parent = LoadFrame

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(1, 0)
barCorner.Parent = BarBg

local BarFill = Instance.new("Frame")
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Colors.AccentBlue
BarFill.BorderSizePixel = 0
BarFill.Parent = BarBg

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(1, 0)
fillCorner.Parent = BarFill

local BarGradient = Instance.new("UIGradient")
BarGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 130, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 90, 255)),
})
BarGradient.Parent = BarFill

local BottomBar = Instance.new("Frame")
BottomBar.Size = UDim2.new(1, -40, 0, 40)
BottomBar.Position = UDim2.new(0, 20, 1, -55)
BottomBar.BackgroundTransparency = 1
BottomBar.Parent = MainFrame

local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(1, -140, 1, 0)
StatusText.Position = UDim2.new(0, 0, 0, 0)
StatusText.BackgroundTransparency = 1
StatusText.Text = ""
StatusText.TextColor3 = Colors.TextDim
StatusText.Font = Enum.Font.Gotham
StatusText.TextSize = 12
StatusText.TextXAlignment = Enum.TextXAlignment.Left
StatusText.Parent = BottomBar

local ActionBtn = Instance.new("TextButton")
ActionBtn.Size = UDim2.new(0, 130, 1, 0)
ActionBtn.Position = UDim2.new(1, -130, 0, 0)
ActionBtn.BackgroundColor3 = Colors.AccentBlue
ActionBtn.BorderSizePixel = 0
ActionBtn.Text = "ЗАПУСТИТЬ"
ActionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ActionBtn.Font = Enum.Font.GothamBlack
ActionBtn.TextSize = 13
ActionBtn.AutoButtonColor = false
ActionBtn.Visible = false
ActionBtn.Parent = BottomBar

local abCorner = Instance.new("UICorner")
abCorner.CornerRadius = UDim.new(0, 8)
abCorner.Parent = ActionBtn

-- ============================================================
-- ЛОГИКА
-- ============================================================
local CurrentVersion = nil

local function ShowVersions()
    VersionContainer.Visible = true
    KeyFrame.Visible = false
    LoadFrame.Visible = false
    ActionBtn.Visible = false
    SubTitle.Text = "Выберите версию для запуска"
    StatusText.Text = ""
    StatusText.TextColor3 = Colors.TextDim
end

local function ShowKeyInput(version)
    CurrentVersion = version
    VersionContainer.Visible = false
    KeyFrame.Visible = true
    LoadFrame.Visible = false
    ActionBtn.Visible = true
    ActionBtn.Text = "ВОЙТИ"
    SubTitle.Text = "Версия: " .. version
    StatusText.Text = ""
    StatusText.TextColor3 = Colors.TextDim

    -- Автоподстановка сохранённого ключа для этой версии
    local savedVersion, savedKey = LoadKey()
    if savedVersion == version and savedKey and CheckKey(version, savedKey) then
        KeyInput.Text = savedKey
        StatusText.Text = "Ключ подставлен из сохранения"
        StatusText.TextColor3 = Colors.Success
    else
        KeyInput.Text = ""
    end

    KeyInput:CaptureFocus()
end

local function ShowLoad()
    VersionContainer.Visible = false
    KeyFrame.Visible = false
    LoadFrame.Visible = true
    ActionBtn.Visible = false
end

local function SetProgress(percent, text)
    TweenService:Create(BarFill, TweenInfo.new(0.3), {Size = UDim2.new(percent / 100, 0, 1, 0)}):Play()
    LoadPercent.Text = math.floor(percent) .. "%"
    if text then LoadStatus.Text = text end
end

local function ShakeFrame()
    local originalPos = MainFrame.Position
    for i = 1, 3 do
        TweenService:Create(MainFrame, TweenInfo.new(0.04), {Position = originalPos + UDim2.new(0, 8, 0, 0)}):Play()
        task.wait(0.05)
        TweenService:Create(MainFrame, TweenInfo.new(0.04), {Position = originalPos - UDim2.new(0, 8, 0, 0)}):Play()
        task.wait(0.05)
    end
    TweenService:Create(MainFrame, TweenInfo.new(0.06), {Position = originalPos}):Play()
end

local function DoLoad(version)
    ShowLoad()
    SetProgress(0, "Проверка ключа...")
    task.wait(0.4)
    SetProgress(20, "Ключ верный")
    task.wait(0.3)
    SetProgress(40, "Загрузка модулей...")
    task.wait(0.4)
    SetProgress(60, "Подключение к GitHub...")

    local ok, err = pcall(function()
        local code = game:HttpGet(URLS[version])
        SetProgress(80, "Компиляция...")
        task.wait(0.3)
        local fn = loadstring(code)
        if not fn then error("loadstring failed") end
        SetProgress(100, "Запуск...")
        task.wait(0.3)
        fn()
    end)

    if not ok then
        SetProgress(0, "Ошибка: " .. tostring(err))
        task.wait(2)
        ShowVersions()
        StatusText.Text = "Ошибка загрузки. Проверь ссылки."
        StatusText.TextColor3 = Colors.Error
    else
        task.wait(0.4)
        TweenService:Create(BlurEffect, TweenInfo.new(0.3), {Size = 0}):Play()
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
        }):Play()
        task.wait(0.35)
        ScreenGui:Destroy()
        BlurEffect:Destroy()
    end
end

local function TrySubmitKey()
    local key = KeyInput.Text
    if not key or key == "" then
        StatusText.Text = "Введите ключ"
        StatusText.TextColor3 = Colors.Error
        ShakeFrame()
        return
    end
    if CheckKey(CurrentVersion, key) then
        StatusText.Text = "Ключ принят"
        StatusText.TextColor3 = Colors.Success
        SaveKey(CurrentVersion, key)
        task.wait(0.3)
        DoLoad(CurrentVersion)
    else
        StatusText.Text = "Неверный ключ"
        StatusText.TextColor3 = Colors.Error
        kiStroke.Color = Colors.Error
        ShakeFrame()
        task.wait(1)
        kiStroke.Color = Colors.Border
    end
end

local UserCard = CreateVersionCard("USER", "Базовые функции", Color3.fromRGB(90, 180, 255))
UserCard.MouseButton1Click:Connect(function() ShowKeyInput("User") end)

local PremiumCard = CreateVersionCard("PREMIUM", "Расширенные функции", Color3.fromRGB(255, 215, 0))
PremiumCard.MouseButton1Click:Connect(function() ShowKeyInput("Premium") end)

local DevCard = CreateVersionCard("DEV", "Полный доступ", Color3.fromRGB(255, 80, 80))
DevCard.MouseButton1Click:Connect(function() ShowKeyInput("Dev") end)

ActionBtn.MouseButton1Click:Connect(function()
    if CurrentVersion then
        TrySubmitKey()
    end
end)

KeyInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        TrySubmitKey()
    end
end)

KeyBackBtn.MouseButton1Click:Connect(function()
    ShowVersions()
end)

-- Просто показываем подсказку, что ключ сохранён, но НЕ запускаем автоматически
task.spawn(function()
    task.wait(0.5)
    local version, key = LoadKey()
    if version and key and KEYS[version] then
        if CheckKey(version, key) then
            StatusText.Text = "Сохранён ключ (" .. version .. "). Выберите версию."
            StatusText.TextColor3 = Colors.Success
        else
            ClearKey()
        end
    end
end)

print("MegolaHub Loader загружен. Выберите версию.")
