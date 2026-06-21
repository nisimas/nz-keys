--// ═══════════════════════════════════════════
--// Nz Script - Loader v1.1 (FIXED)
--// ═══════════════════════════════════════════

local KEY_CONFIG = {
    FIREBASE_URL = "https://nz-keys-default-rtdb.firebaseio.com",
    LINKVERTISE_URL = "https://link-center.net/6768376/3HCYVW6IyZJr",
    SCRIPT_NAME = "Nz Script",
    VERSION = "v1.0"
}

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Player = Players.LocalPlayer

local HWID = ""
pcall(function()
    HWID = game:GetService("RbxAnalyticsService"):GetClientId()
end)
if HWID == "" then
    HWID = tostring(Player.UserId) .. "_" .. tostring(game.PlaceId)
end

if game.CoreGui:FindFirstChild("NzKeySystem") then 
    game.CoreGui:FindFirstChild("NzKeySystem"):Destroy() 
end
if game.CoreGui:FindFirstChild("NzGUI") then 
    game.CoreGui:FindFirstChild("NzGUI"):Destroy() 
end

--// ═══════════════════════════════════════════
--// СЕКЦИЯ 1: ФУНКЦИИ (ОБЪЯВЛЯЕМ В НАЧАЛЕ!)
--// ═══════════════════════════════════════════

local function loadNzGUI()
    print("[Nz] GUI загружается...")
    -- Сюда вставим твой GUI код позже
end

local function loadJailbreakFunctions()
    print("[Nz] Функции Jailbreak загружены!")
    -- Сюда вставим функции Jailbreak позже
end

local function StartMainScript()
    loadNzGUI()
    loadJailbreakFunctions()
end

local function CheckKey(key)
    local success, result = pcall(function()
        return game:HttpGet(KEY_CONFIG.FIREBASE_URL .. "/keys/" .. key .. ".json")
    end)
    
    if not success then return false, "Ошибка подключения" end
    if result == "null" or result == nil or result == "" then
        return false, "Неверный ключ!"
    end
    
    local ok, data = pcall(function()
        return HttpService:JSONDecode(result)
    end)
    
    if not ok or not data then return false, "Ошибка обработки ключа" end
    
    if data.expires and tonumber(data.expires) and tonumber(data.expires) < os.time() then
        return false, "Ключ просрочен!"
    end
    
    if data.hwid and data.hwid ~= "none" and data.hwid ~= HWID then
        return false, "Ключ привязан к другому ПК!"
    end
    
    if data.hwid == "none" then
        pcall(function()
            local req = http_request or request or (syn and syn.request)
            if req then
                req({
                    Url = KEY_CONFIG.FIREBASE_URL .. "/keys/" .. key .. ".json",
                    Method = "PATCH",
                    Headers = {["Content-Type"] = "application/json"},
                    Body = HttpService:JSONEncode({hwid = HWID})
                })
            end
        end)
    end
    
    return true, "Доступ разрешён!"
end

--// ═══════════════════════════════════════════
--// СЕКЦИЯ 2: GUI КЛЮЧ-СИСТЕМЫ
--// ═══════════════════════════════════════════

local KeyGui = Instance.new("ScreenGui")
KeyGui.Name = "NzKeySystem"
KeyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
KeyGui.ResetOnSpawn = false
KeyGui.IgnoreGuiInset = true
KeyGui.Parent = game.CoreGui

local Overlay = Instance.new("Frame")
Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Overlay.BackgroundTransparency = 1
Overlay.Size = UDim2.new(1, 0, 1, 0)
Overlay.ZIndex = 100
Overlay.Parent = KeyGui

TweenService:Create(Overlay, TweenInfo.new(0.4), {BackgroundTransparency = 0.4}):Play()

local KeyFrame = Instance.new("Frame")
KeyFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 20)
KeyFrame.BorderSizePixel = 0
KeyFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
KeyFrame.AnchorPoint = Vector2.new(0.5, 0.5)
KeyFrame.Size = UDim2.new(0, 0, 0, 0)
KeyFrame.ZIndex = 101
KeyFrame.ClipsDescendants = true
KeyFrame.Parent = KeyGui
Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 14)

local keyStroke = Instance.new("UIStroke")
keyStroke.Color = Color3.fromRGB(130, 100, 255)
keyStroke.Thickness = 1.5
keyStroke.Transparency = 0.4
keyStroke.Parent = KeyFrame

local LogoIcon = Instance.new("Frame")
LogoIcon.BackgroundColor3 = Color3.fromRGB(130, 100, 255)
LogoIcon.Position = UDim2.new(0.5, 0, 0, 35)
LogoIcon.AnchorPoint = Vector2.new(0.5, 0)
LogoIcon.Size = UDim2.new(0, 42, 0, 42)
LogoIcon.Rotation = -20
LogoIcon.ZIndex = 102
LogoIcon.Parent = KeyFrame
Instance.new("UICorner", LogoIcon).CornerRadius = UDim.new(0, 10)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0.5, 0, 0, 88)
TitleLabel.AnchorPoint = Vector2.new(0.5, 0)
TitleLabel.Size = UDim2.new(1, -20, 0, 30)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = KEY_CONFIG.SCRIPT_NAME
TitleLabel.TextColor3 = Color3.new(1, 1, 1)
TitleLabel.TextSize = 22
TitleLabel.ZIndex = 102
TitleLabel.Parent = KeyFrame

local SubLabel = Instance.new("TextLabel")
SubLabel.BackgroundTransparency = 1
SubLabel.Position = UDim2.new(0.5, 0, 0, 118)
SubLabel.AnchorPoint = Vector2.new(0.5, 0)
SubLabel.Size = UDim2.new(1, -20, 0, 20)
SubLabel.Font = Enum.Font.Gotham
SubLabel.Text = "Введи ключ для доступа"
SubLabel.TextColor3 = Color3.fromRGB(140, 140, 170)
SubLabel.TextSize = 13
SubLabel.ZIndex = 102
SubLabel.Parent = KeyFrame

local InputFrame = Instance.new("Frame")
InputFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 30)
InputFrame.BorderSizePixel = 0
InputFrame.Position = UDim2.new(0.5, 0, 0, 168)
InputFrame.AnchorPoint = Vector2.new(0.5, 0)
InputFrame.Size = UDim2.new(0.82, 0, 0, 42)
InputFrame.ZIndex = 102
InputFrame.Parent = KeyFrame
Instance.new("UICorner", InputFrame).CornerRadius = UDim.new(0, 8)

local inputStroke = Instance.new("UIStroke")
inputStroke.Color = Color3.fromRGB(50, 50, 80)
inputStroke.Thickness = 1
inputStroke.Transparency = 0.3
inputStroke.Parent = InputFrame

local KeyInput = Instance.new("TextBox")
KeyInput.BackgroundTransparency = 1
KeyInput.Position = UDim2.new(0, 14, 0, 0)
KeyInput.Size = UDim2.new(1, -28, 1, 0)
KeyInput.Font = Enum.Font.GothamMedium
KeyInput.PlaceholderText = "Вставь ключ сюда..."
KeyInput.PlaceholderColor3 = Color3.fromRGB(80, 80, 110)
KeyInput.Text = ""
KeyInput.TextColor3 = Color3.new(1, 1, 1)
KeyInput.TextSize = 14
KeyInput.TextXAlignment = Enum.TextXAlignment.Left
KeyInput.ClearTextOnFocus = false
KeyInput.ZIndex = 103
KeyInput.Parent = InputFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0.5, 0, 0, 218)
StatusLabel.AnchorPoint = Vector2.new(0.5, 0)
StatusLabel.Size = UDim2.new(0.82, 0, 0, 20)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Text = ""
StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
StatusLabel.TextSize = 12
StatusLabel.ZIndex = 102
StatusLabel.Parent = KeyFrame

local CheckButton = Instance.new("TextButton")
CheckButton.BackgroundColor3 = Color3.fromRGB(130, 100, 255)
CheckButton.BorderSizePixel = 0
CheckButton.Position = UDim2.new(0.5, 0, 0, 248)
CheckButton.AnchorPoint = Vector2.new(0.5, 0)
CheckButton.Size = UDim2.new(0.82, 0, 0, 40)
CheckButton.Font = Enum.Font.GothamBold
CheckButton.Text = "ПРОВЕРИТЬ КЛЮЧ"
CheckButton.TextColor3 = Color3.new(1, 1, 1)
CheckButton.TextSize = 14
CheckButton.ZIndex = 102
CheckButton.AutoButtonColor = false
CheckButton.Parent = KeyFrame
Instance.new("UICorner", CheckButton).CornerRadius = UDim.new(0, 8)

local GetKeyButton = Instance.new("TextButton")
GetKeyButton.BackgroundColor3 = Color3.fromRGB(22, 22, 36)
GetKeyButton.BorderSizePixel = 0
GetKeyButton.Position = UDim2.new(0.5, 0, 0, 298)
GetKeyButton.AnchorPoint = Vector2.new(0.5, 0)
GetKeyButton.Size = UDim2.new(0.82, 0, 0, 40)
GetKeyButton.Font = Enum.Font.GothamBold
GetKeyButton.Text = "ПОЛУЧИТЬ КЛЮЧ"
GetKeyButton.TextColor3 = Color3.fromRGB(130, 100, 255)
GetKeyButton.TextSize = 14
GetKeyButton.ZIndex = 102
GetKeyButton.AutoButtonColor = false
GetKeyButton.Parent = KeyFrame
Instance.new("UICorner", GetKeyButton).CornerRadius = UDim.new(0, 8)

local getKeyStroke = Instance.new("UIStroke")
getKeyStroke.Color = Color3.fromRGB(130, 100, 255)
getKeyStroke.Thickness = 1.5
getKeyStroke.Transparency = 0.4
getKeyStroke.Parent = GetKeyButton

local HWIDLabel = Instance.new("TextLabel")
HWIDLabel.BackgroundTransparency = 1
HWIDLabel.Position = UDim2.new(0.5, 0, 0, 352)
HWIDLabel.AnchorPoint = Vector2.new(0.5, 0)
HWIDLabel.Size = UDim2.new(0.82, 0, 0, 16)
HWIDLabel.Font = Enum.Font.Gotham
HWIDLabel.Text = "HWID: " .. HWID:sub(1, 20) .. "..."
HWIDLabel.TextColor3 = Color3.fromRGB(60, 60, 80)
HWIDLabel.TextSize = 10
HWIDLabel.ZIndex = 102
HWIDLabel.Parent = KeyFrame

TweenService:Create(KeyFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
    Size = UDim2.new(0, 380, 0, 390)
}):Play()

--// ═══════════════════════════════════════════
--// СЕКЦИЯ 3: ОБРАБОТЧИКИ КНОПОК
--// ═══════════════════════════════════════════

GetKeyButton.MouseButton1Click:Connect(function()
    print("[Nz] Кнопка 'Получить ключ' нажата")
    local copied = false
    pcall(function() 
        setclipboard(KEY_CONFIG.LINKVERTISE_URL)
        copied = true
    end)
    
    if copied then
        StatusLabel.TextColor3 = Color3.fromRGB(130, 100, 255)
        StatusLabel.Text = "Ссылка скопирована! Вставь в браузер."
    else
        StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        StatusLabel.Text = "Не удалось скопировать. Перейди вручную."
    end
end)

local isChecking = false
CheckButton.MouseButton1Click:Connect(function()
    print("[Nz] Кнопка 'Проверить' нажата")
    if isChecking then return end
    
    local key = KeyInput.Text:gsub("%s+", "")
    print("[Nz] Введённый ключ:", key)
    
    if key == "" then
        StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        StatusLabel.Text = "Введи ключ!"
        return
    end
    
    isChecking = true
    CheckButton.Text = "ПРОВЕРЯЮ..."
    StatusLabel.Text = ""
    
    task.wait(0.3)
    
    local valid, message = CheckKey(key)
    print("[Nz] Результат проверки:", valid, message)
    
    if valid then
        StatusLabel.TextColor3 = Color3.fromRGB(80, 255, 140)
        StatusLabel.Text = message
        
        TweenService:Create(keyStroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(80, 255, 140)}):Play()
        
        task.wait(1)
        
        TweenService:Create(KeyFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0)
        }):Play()
        TweenService:Create(Overlay, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        
        task.wait(0.6)
        KeyGui:Destroy()
        
        StartMainScript()
    else
        StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        StatusLabel.Text = message
        
        TweenService:Create(inputStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(255, 80, 80)}):Play()
        task.wait(1)
        TweenService:Create(inputStroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(50, 50, 80)}):Play()
        
        CheckButton.Text = "ПРОВЕРИТЬ КЛЮЧ"
        isChecking = false
    end
end)

print("[Nz Loader] Запущен! Введи ключ.")
