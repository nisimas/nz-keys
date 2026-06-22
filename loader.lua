local KEY_CONFIG = {
    FIREBASE_URL = "https://nz-keys-default-rtdb.firebaseio.com",
    LINKVERTISE_URL = "https://link-center.net/6768376/3HCYVW6IyZJr",
    SCRIPT_NAME = "Nz Script",
    VERSION = "v2.0"
}

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")
local SoundService = game:GetService("SoundService")
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
if Lighting:FindFirstChild("NzBlur") then 
    Lighting:FindFirstChild("NzBlur"):Destroy() 
end

local LANGUAGES = {
    ru = {flag = "RU", name = "Русский", title = "Добро пожаловать", subtitle = "Введите ваш ключ для доступа", placeholder = "Введите ключ...", verify = "ПРОВЕРИТЬ КЛЮЧ", getkey = "ПОЛУЧИТЬ КЛЮЧ", checking = "ПРОВЕРКА...", empty = "Введите ключ", invalid = "Неверный ключ", expired = "Ключ просрочен", wrongHwid = "Ключ привязан к другому ПК", success = "Доступ разрешён", copied = "Ссылка скопирована", connectError = "Ошибка подключения", hwidCopied = "HWID скопирован", expires = "Истекает через", days = "д", hours = "ч", minutes = "м", seconds = "с"},
    en = {flag = "EN", name = "English", title = "Welcome", subtitle = "Enter your key to continue", placeholder = "Enter key...", verify = "VERIFY KEY", getkey = "GET KEY", checking = "CHECKING...", empty = "Enter key", invalid = "Invalid key", expired = "Key expired", wrongHwid = "Key bound to another PC", success = "Access granted", copied = "Link copied", connectError = "Connection error", hwidCopied = "HWID copied", expires = "Expires in", days = "d", hours = "h", minutes = "m", seconds = "s"},
    es = {flag = "ES", name = "Español", title = "Bienvenido", subtitle = "Ingresa tu clave para continuar", placeholder = "Ingresa clave...", verify = "VERIFICAR CLAVE", getkey = "OBTENER CLAVE", checking = "VERIFICANDO...", empty = "Ingresa clave", invalid = "Clave inválida", expired = "Clave expirada", wrongHwid = "Clave vinculada a otro PC", success = "Acceso concedido", copied = "Enlace copiado", connectError = "Error de conexión", hwidCopied = "HWID copiado", expires = "Expira en", days = "d", hours = "h", minutes = "m", seconds = "s"},
    de = {flag = "DE", name = "Deutsch", title = "Willkommen", subtitle = "Gib deinen Schlüssel ein", placeholder = "Schlüssel eingeben...", verify = "PRÜFEN", getkey = "SCHLÜSSEL HOLEN", checking = "PRÜFE...", empty = "Schlüssel eingeben", invalid = "Ungültiger Schlüssel", expired = "Abgelaufen", wrongHwid = "Anderer PC", success = "Zugriff gewährt", copied = "Link kopiert", connectError = "Verbindungsfehler", hwidCopied = "HWID kopiert", expires = "Läuft ab in", days = "T", hours = "St", minutes = "M", seconds = "S"},
    fr = {flag = "FR", name = "Français", title = "Bienvenue", subtitle = "Entrez votre clé pour continuer", placeholder = "Entrez la clé...", verify = "VÉRIFIER", getkey = "OBTENIR CLÉ", checking = "VÉRIFICATION...", empty = "Entrez la clé", invalid = "Clé invalide", expired = "Clé expirée", wrongHwid = "Lié à un autre PC", success = "Accès accordé", copied = "Lien copié", connectError = "Erreur de connexion", hwidCopied = "HWID copié", expires = "Expire dans", days = "j", hours = "h", minutes = "m", seconds = "s"},
    pt = {flag = "PT", name = "Português", title = "Bem-vindo", subtitle = "Digite sua chave para continuar", placeholder = "Digite a chave...", verify = "VERIFICAR", getkey = "OBTER CHAVE", checking = "VERIFICANDO...", empty = "Digite a chave", invalid = "Chave inválida", expired = "Chave expirada", wrongHwid = "Vinculada a outro PC", success = "Acesso liberado", copied = "Link copiado", connectError = "Erro de conexão", hwidCopied = "HWID copiado", expires = "Expira em", days = "d", hours = "h", minutes = "m", seconds = "s"},
    id = {flag = "ID", name = "Indonesia", title = "Selamat datang", subtitle = "Masukkan kunci untuk lanjut", placeholder = "Masukkan kunci...", verify = "VERIFIKASI", getkey = "DAPATKAN KUNCI", checking = "MEMERIKSA...", empty = "Masukkan kunci", invalid = "Kunci tidak valid", expired = "Kunci kadaluarsa", wrongHwid = "Terikat ke PC lain", success = "Akses diberikan", copied = "Link disalin", connectError = "Kesalahan koneksi", hwidCopied = "HWID disalin", expires = "Berakhir dalam", days = "h", hours = "j", minutes = "m", seconds = "d"},
    tr = {flag = "TR", name = "Türkçe", title = "Hoşgeldiniz", subtitle = "Devam etmek için anahtarı girin", placeholder = "Anahtar girin...", verify = "DOĞRULA", getkey = "ANAHTAR AL", checking = "KONTROL...", empty = "Anahtar girin", invalid = "Geçersiz anahtar", expired = "Süresi dolmuş", wrongHwid = "Başka PC'ye bağlı", success = "Erişim verildi", copied = "Bağlantı kopyalandı", connectError = "Bağlantı hatası", hwidCopied = "HWID kopyalandı", expires = "Süre", days = "g", hours = "s", minutes = "d", seconds = "s"}
}

local CurrentLang = "ru"
local L = LANGUAGES[CurrentLang]

local function playSound(soundId, volume, pitch)
    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://" .. soundId
    s.Volume = volume or 0.5
    s.PlaybackSpeed = pitch or 1
    s.Parent = SoundService
    s:Play()
    s.Ended:Connect(function() s:Destroy() end)
    task.delay(3, function() if s and s.Parent then s:Destroy() end end)
end

local function sndSuccess() playSound("9118823106", 0.6, 1) end
local function sndError() playSound("550209561", 0.5, 0.8) end
local function sndClick() playSound("6042053626", 0.4, 1) end
local function sndHover() playSound("10066931761", 0.2, 1.2) end

local function loadJailbreakFunctions()
    print("[Nz] Функции Jailbreak загружены!")
end

local function loadNzGUI()
    local function IsLightTheme(r,g,b) return (r+g+b)/3 > 128 end

    local function T(id,name,r1,g1,b1,r2,g2,b2,r3,g3,b3,r4,g4,b4,r5,g5,b5,tr)
        local bg=Color3.fromRGB(r1,g1,b1)
        local sb=Color3.fromRGB(r2,g2,b2)
        local tb=Color3.fromRGB(r3,g3,b3)
        local cd=Color3.fromRGB(r4,g4,b4)
        local tx=Color3.fromRGB(r5,g5,b5)
        local isLight = IsLightTheme(r1,g1,b1)
        return {
            Id=id, Name=name, Bg=bg, Sidebar=sb, TopBar=tb, Card=cd,
            IsLight=isLight,
            CardHover=Color3.fromRGB(math.min(r4+12,255),math.min(g4+12,255),math.min(b4+12,255)),
            CardActive=Color3.fromRGB(math.min(r4+20,255),math.min(g4+10,255),math.min(b4+30,255)),
            Text=tx,
            TextDim=isLight and Color3.fromRGB(math.floor(r5+(120-r5)*0.5),math.floor(g5+(120-g5)*0.5),math.floor(b5+(125-b5)*0.5)) or Color3.fromRGB(math.floor(r5*0.6),math.floor(g5*0.6),math.floor(b5*0.6)),
            TextDark=isLight and Color3.fromRGB(math.floor(r5+(150-r5)*0.6),math.floor(g5+(150-g5)*0.6),math.floor(b5+(160-b5)*0.6)) or Color3.fromRGB(math.floor(r5*0.4),math.floor(g5*0.4),math.floor(b5*0.4)),
            Border=Color3.fromRGB(math.floor((r2+r4)/2*0.8),math.floor((g2+g4)/2*0.8),math.floor((b2+b4)/2*0.8)),
            Divider=Color3.fromRGB(math.floor((r1+r2)/2),math.floor((g1+g2)/2),math.floor((b1+b2)/2)),
            TogOff=Color3.fromRGB(math.min(math.floor(r4*1.3),255),math.min(math.floor(g4*1.3),255),math.min(math.floor(b4*1.3),255)),
            TagBg=Color3.fromRGB(math.floor((r2+r4)/2),math.floor((g2+g4)/2),math.floor((b2+b4)/2)),
            Search=Color3.fromRGB(math.floor((r1+r2)/2),math.floor((g1+g2)/2),math.floor((b1+b2)/2)),
            NotifBg=sb, SettBg=sb,
            SliderBg=Color3.fromRGB(math.floor((r1+r2)/2),math.floor((g1+g2)/2),math.floor((b1+b2)/2)),
            Trans=tr or 0.07,
            Grad1=Color3.fromRGB(math.min(math.floor(r2*1.1),255),math.min(math.floor(g2*1.1),255),math.min(math.floor(b2*1.1),255)),
            Grad2=bg,
            TBGrad1=Color3.fromRGB(math.min(r3+5,255),math.min(g3+5,255),math.min(b3+5,255)),
            TBGrad2=tb,
        }
    end

    loadstring(game:HttpGet("https://raw.githubusercontent.com/nisimas/nz-keys/main/ui.lua"))()
end

local function StartMainScript()
    loadNzGUI()
    loadJailbreakFunctions()
end

local function CheckKey(key)
    local success, result = pcall(function()
        return game:HttpGet(KEY_CONFIG.FIREBASE_URL .. "/keys/" .. key .. ".json")
    end)
    
    if not success then return false, L.connectError end
    if result == "null" or result == nil or result == "" then
        return false, L.invalid
    end
    
    local ok, data = pcall(function()
        return HttpService:JSONDecode(result)
    end)
    
    if not ok or not data then return false, L.invalid end
    
    if data.expires and tonumber(data.expires) and tonumber(data.expires) < os.time() then
        pcall(function()
            local req = http_request or request or (syn and syn.request)
            if req then
                req({
                    Url = KEY_CONFIG.FIREBASE_URL .. "/keys/" .. key .. ".json",
                    Method = "DELETE"
                })
            end
        end)
        return false, L.expired
    end
    
    if data.hwid and data.hwid ~= "none" and data.hwid ~= HWID then
        return false, L.wrongHwid
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
    
    return true, L.success, data.expires
end

local KeyGui = Instance.new("ScreenGui")
KeyGui.Name = "NzKeySystem"
KeyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
KeyGui.ResetOnSpawn = false
KeyGui.IgnoreGuiInset = true
KeyGui.Parent = game.CoreGui

local Blur = Instance.new("BlurEffect")
Blur.Name = "NzKeyBlur"
Blur.Size = 0
Blur.Parent = Lighting
TweenService:Create(Blur, TweenInfo.new(0.6), {Size = 18}):Play()

local Overlay = Instance.new("Frame")
Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Overlay.BackgroundTransparency = 1
Overlay.Size = UDim2.new(1, 0, 1, 0)
Overlay.ZIndex = 100
Overlay.Parent = KeyGui
TweenService:Create(Overlay, TweenInfo.new(0.5), {BackgroundTransparency = 0.5}):Play()

local Card = Instance.new("Frame")
Card.BackgroundColor3 = Color3.fromRGB(10, 10, 16)
Card.BorderSizePixel = 0
Card.Position = UDim2.new(0.5, 0, 0.5, 0)
Card.AnchorPoint = Vector2.new(0.5, 0.5)
Card.Size = UDim2.new(0, 0, 0, 0)
Card.ZIndex = 101
Card.ClipsDescendants = true
Card.Parent = KeyGui
Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 18)

local cardGrad = Instance.new("UIGradient")
cardGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 14, 28)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 8, 14))
}
cardGrad.Rotation = 135
cardGrad.Parent = Card

local cardStroke = Instance.new("UIStroke")
cardStroke.Color = Color3.fromRGB(130, 100, 255)
cardStroke.Thickness = 1
cardStroke.Transparency = 0.5
cardStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
cardStroke.Parent = Card

local glowStroke = Instance.new("UIStroke")
glowStroke.Color = Color3.fromRGB(130, 100, 255)
glowStroke.Thickness = 3
glowStroke.Transparency = 0.85
glowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
glowStroke.Parent = Card

local goldLine = Instance.new("Frame")
goldLine.BackgroundColor3 = Color3.fromRGB(218, 165, 32)
goldLine.BorderSizePixel = 0
goldLine.Position = UDim2.new(0.5, 0, 0, 0)
goldLine.AnchorPoint = Vector2.new(0.5, 0)
goldLine.Size = UDim2.new(0, 60, 0, 2)
goldLine.ZIndex = 102
goldLine.Parent = Card
local goldGrad = Instance.new("UIGradient")
goldGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(184, 134, 11)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 215, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(184, 134, 11))
}
goldGrad.Parent = goldLine

local langBtn = Instance.new("TextButton")
langBtn.BackgroundColor3 = Color3.fromRGB(16, 16, 26)
langBtn.BorderSizePixel = 0
langBtn.Position = UDim2.new(1, -18, 0, 18)
langBtn.AnchorPoint = Vector2.new(1, 0)
langBtn.Size = UDim2.new(0, 46, 0, 28)
langBtn.Font = Enum.Font.GothamBold
langBtn.Text = L.flag
langBtn.TextColor3 = Color3.fromRGB(218, 165, 32)
langBtn.TextSize = 11
langBtn.ZIndex = 105
langBtn.AutoButtonColor = false
langBtn.Parent = Card
Instance.new("UICorner", langBtn).CornerRadius = UDim.new(0, 6)
local langBtnStroke = Instance.new("UIStroke")
langBtnStroke.Color = Color3.fromRGB(218, 165, 32)
langBtnStroke.Thickness = 1
langBtnStroke.Transparency = 0.6
langBtnStroke.Parent = langBtn

local LogoFrame = Instance.new("Frame")
LogoFrame.BackgroundColor3 = Color3.fromRGB(130, 100, 255)
LogoFrame.Position = UDim2.new(0.5, 0, 0, 55)
LogoFrame.AnchorPoint = Vector2.new(0.5, 0)
LogoFrame.Size = UDim2.new(0, 56, 0, 56)
LogoFrame.Rotation = -20
LogoFrame.ZIndex = 102
LogoFrame.Parent = Card
Instance.new("UICorner", LogoFrame).CornerRadius = UDim.new(0, 14)
local logoGrad = Instance.new("UIGradient")
logoGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(130, 100, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(165, 135, 255))
}
logoGrad.Rotation = 45
logoGrad.Parent = LogoFrame

local logoGlow = Instance.new("UIStroke")
logoGlow.Color = Color3.fromRGB(130, 100, 255)
logoGlow.Thickness = 6
logoGlow.Transparency = 0.85
logoGlow.Parent = LogoFrame

local BrandLabel = Instance.new("TextLabel")
BrandLabel.BackgroundTransparency = 1
BrandLabel.Position = UDim2.new(0.5, 0, 0, 130)
BrandLabel.AnchorPoint = Vector2.new(0.5, 0)
BrandLabel.Size = UDim2.new(1, -40, 0, 32)
BrandLabel.Font = Enum.Font.GothamBold
BrandLabel.Text = "Nz"
BrandLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
BrandLabel.TextSize = 28
BrandLabel.ZIndex = 102
BrandLabel.Parent = Card

local VerLabel = Instance.new("TextLabel")
VerLabel.BackgroundTransparency = 1
VerLabel.Position = UDim2.new(0.5, 0, 0, 162)
VerLabel.AnchorPoint = Vector2.new(0.5, 0)
VerLabel.Size = UDim2.new(1, -40, 0, 14)
VerLabel.Font = Enum.Font.Gotham
VerLabel.Text = KEY_CONFIG.VERSION
VerLabel.TextColor3 = Color3.fromRGB(218, 165, 32)
VerLabel.TextSize = 10
VerLabel.ZIndex = 102
VerLabel.Parent = Card

local TitleLabel = Instance.new("TextLabel")
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0.5, 0, 0, 190)
TitleLabel.AnchorPoint = Vector2.new(0.5, 0)
TitleLabel.Size = UDim2.new(1, -40, 0, 26)
TitleLabel.Font = Enum.Font.GothamMedium
TitleLabel.Text = L.title
TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 250)
TitleLabel.TextSize = 18
TitleLabel.ZIndex = 102
TitleLabel.Parent = Card

local SubLabel = Instance.new("TextLabel")
SubLabel.BackgroundTransparency = 1
SubLabel.Position = UDim2.new(0.5, 0, 0, 218)
SubLabel.AnchorPoint = Vector2.new(0.5, 0)
SubLabel.Size = UDim2.new(1, -40, 0, 18)
SubLabel.Font = Enum.Font.Gotham
SubLabel.Text = L.subtitle
SubLabel.TextColor3 = Color3.fromRGB(120, 120, 145)
SubLabel.TextSize = 12
SubLabel.ZIndex = 102
SubLabel.Parent = Card

local Divider = Instance.new("Frame")
Divider.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
Divider.BackgroundTransparency = 0.5
Divider.BorderSizePixel = 0
Divider.Position = UDim2.new(0.5, 0, 0, 252)
Divider.AnchorPoint = Vector2.new(0.5, 0)
Divider.Size = UDim2.new(0.85, 0, 0, 1)
Divider.ZIndex = 102
Divider.Parent = Card

local InputBox = Instance.new("Frame")
InputBox.BackgroundColor3 = Color3.fromRGB(14, 14, 22)
InputBox.BorderSizePixel = 0
InputBox.Position = UDim2.new(0.5, 0, 0, 272)
InputBox.AnchorPoint = Vector2.new(0.5, 0)
InputBox.Size = UDim2.new(0.85, 0, 0, 46)
InputBox.ZIndex = 102
InputBox.Parent = Card
Instance.new("UICorner", InputBox).CornerRadius = UDim.new(0, 10)

local inputStroke = Instance.new("UIStroke")
inputStroke.Color = Color3.fromRGB(45, 45, 65)
inputStroke.Thickness = 1
inputStroke.Transparency = 0.3
inputStroke.Parent = InputBox

local KeyInput = Instance.new("TextBox")
KeyInput.BackgroundTransparency = 1
KeyInput.Position = UDim2.new(0, 16, 0, 0)
KeyInput.Size = UDim2.new(1, -32, 1, 0)
KeyInput.Font = Enum.Font.GothamMedium
KeyInput.PlaceholderText = L.placeholder
KeyInput.PlaceholderColor3 = Color3.fromRGB(70, 70, 95)
KeyInput.Text = ""
KeyInput.TextColor3 = Color3.fromRGB(240, 240, 250)
KeyInput.TextSize = 14
KeyInput.TextXAlignment = Enum.TextXAlignment.Left
KeyInput.ClearTextOnFocus = false
KeyInput.ZIndex = 103
KeyInput.Parent = InputBox

local StatusLabel = Instance.new("TextLabel")
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0.5, 0, 0, 326)
StatusLabel.AnchorPoint = Vector2.new(0.5, 0)
StatusLabel.Size = UDim2.new(0.85, 0, 0, 18)
StatusLabel.Font = Enum.Font.GothamMedium
StatusLabel.Text = ""
StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
StatusLabel.TextSize = 11
StatusLabel.ZIndex = 102
StatusLabel.Parent = Card

local CheckBtn = Instance.new("TextButton")
CheckBtn.BackgroundColor3 = Color3.fromRGB(130, 100, 255)
CheckBtn.BorderSizePixel = 0
CheckBtn.Position = UDim2.new(0.5, 0, 0, 356)
CheckBtn.AnchorPoint = Vector2.new(0.5, 0)
CheckBtn.Size = UDim2.new(0.85, 0, 0, 44)
CheckBtn.Font = Enum.Font.GothamBold
CheckBtn.Text = L.verify
CheckBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CheckBtn.TextSize = 13
CheckBtn.ZIndex = 102
CheckBtn.AutoButtonColor = false
CheckBtn.Parent = Card
Instance.new("UICorner", CheckBtn).CornerRadius = UDim.new(0, 10)

local checkGrad = Instance.new("UIGradient")
checkGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(130, 100, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(165, 135, 255))
}
checkGrad.Rotation = 45
checkGrad.Parent = CheckBtn

local checkGlow = Instance.new("UIStroke")
checkGlow.Color = Color3.fromRGB(130, 100, 255)
checkGlow.Thickness = 4
checkGlow.Transparency = 0.85
checkGlow.Parent = CheckBtn

local GetKeyBtn = Instance.new("TextButton")
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
GetKeyBtn.BorderSizePixel = 0
GetKeyBtn.Position = UDim2.new(0.5, 0, 0, 410)
GetKeyBtn.AnchorPoint = Vector2.new(0.5, 0)
GetKeyBtn.Size = UDim2.new(0.85, 0, 0, 44)
GetKeyBtn.Font = Enum.Font.GothamBold
GetKeyBtn.Text = L.getkey
GetKeyBtn.TextColor3 = Color3.fromRGB(218, 165, 32)
GetKeyBtn.TextSize = 13
GetKeyBtn.ZIndex = 102
GetKeyBtn.AutoButtonColor = false
GetKeyBtn.Parent = Card
Instance.new("UICorner", GetKeyBtn).CornerRadius = UDim.new(0, 10)

local getKeyStroke = Instance.new("UIStroke")
getKeyStroke.Color = Color3.fromRGB(218, 165, 32)
getKeyStroke.Thickness = 1
getKeyStroke.Transparency = 0.5
getKeyStroke.Parent = GetKeyBtn

local HwidLabel = Instance.new("TextButton")
HwidLabel.BackgroundTransparency = 1
HwidLabel.Position = UDim2.new(0.5, 0, 1, -28)
HwidLabel.AnchorPoint = Vector2.new(0.5, 0)
HwidLabel.Size = UDim2.new(0.85, 0, 0, 14)
HwidLabel.Font = Enum.Font.Gotham
HwidLabel.Text = "HWID: " .. HWID:sub(1, 18) .. "..."
HwidLabel.TextColor3 = Color3.fromRGB(60, 60, 80)
HwidLabel.TextSize = 9
HwidLabel.ZIndex = 102
HwidLabel.AutoButtonColor = false
HwidLabel.Parent = Card

TweenService:Create(Card, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 400, 0, 510)
}):Play()

spawn(function()
    while Card and Card.Parent do
        TweenService:Create(glowStroke, TweenInfo.new(2, Enum.EasingStyle.Sine), {Transparency = 0.7}):Play()
        task.wait(2)
        TweenService:Create(glowStroke, TweenInfo.new(2, Enum.EasingStyle.Sine), {Transparency = 0.9}):Play()
        task.wait(2)
    end
end)

spawn(function()
    while LogoFrame and LogoFrame.Parent do
        TweenService:Create(LogoFrame, TweenInfo.new(3, Enum.EasingStyle.Sine), {Rotation = -15}):Play()
        task.wait(3)
        TweenService:Create(LogoFrame, TweenInfo.new(3, Enum.EasingStyle.Sine), {Rotation = -25}):Play()
        task.wait(3)
    end
end)

local langOpen = false
local langMenu

local function updateAllTexts()
    L = LANGUAGES[CurrentLang]
    langBtn.Text = L.flag
    TitleLabel.Text = L.title
    SubLabel.Text = L.subtitle
    KeyInput.PlaceholderText = L.placeholder
    CheckBtn.Text = L.verify
    GetKeyBtn.Text = L.getkey
end

langBtn.MouseEnter:Connect(function()
    sndHover()
    TweenService:Create(langBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(28, 28, 42)}):Play()
end)
langBtn.MouseLeave:Connect(function()
    TweenService:Create(langBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(16, 16, 26)}):Play()
end)

langBtn.MouseButton1Click:Connect(function()
    sndClick()
    if langMenu then 
        langMenu:Destroy()
        langMenu = nil
        return
    end
    
    langMenu = Instance.new("Frame")
    langMenu.BackgroundColor3 = Color3.fromRGB(14, 14, 22)
    langMenu.BorderSizePixel = 0
    langMenu.Position = UDim2.new(1, -18, 0, 50)
    langMenu.AnchorPoint = Vector2.new(1, 0)
    langMenu.Size = UDim2.new(0, 0, 0, 0)
    langMenu.ZIndex = 110
    langMenu.ClipsDescendants = true
    langMenu.Parent = Card
    Instance.new("UICorner", langMenu).CornerRadius = UDim.new(0, 8)
    local lmStroke = Instance.new("UIStroke")
    lmStroke.Color = Color3.fromRGB(218, 165, 32)
    lmStroke.Thickness = 1
    lmStroke.Transparency = 0.6
    lmStroke.Parent = langMenu
    
    local lmList = Instance.new("UIListLayout")
    lmList.Padding = UDim.new(0, 2)
    lmList.Parent = langMenu
    local lmPad = Instance.new("UIPadding")
    lmPad.PaddingTop = UDim.new(0, 4)
    lmPad.PaddingBottom = UDim.new(0, 4)
    lmPad.PaddingLeft = UDim.new(0, 4)
    lmPad.PaddingRight = UDim.new(0, 4)
    lmPad.Parent = langMenu
    
    for code, lang in pairs(LANGUAGES) do
        local item = Instance.new("TextButton")
        item.BackgroundColor3 = code == CurrentLang and Color3.fromRGB(28, 22, 44) or Color3.fromRGB(20, 20, 32)
        item.BorderSizePixel = 0
        item.Size = UDim2.new(1, 0, 0, 28)
        item.Font = Enum.Font.GothamMedium
        item.Text = "  " .. lang.flag .. "    " .. lang.name
        item.TextColor3 = code == CurrentLang and Color3.fromRGB(218, 165, 32) or Color3.fromRGB(200, 200, 220)
        item.TextSize = 11
        item.TextXAlignment = Enum.TextXAlignment.Left
        item.ZIndex = 111
        item.AutoButtonColor = false
        item.Parent = langMenu
        Instance.new("UICorner", item).CornerRadius = UDim.new(0, 6)
        
        item.MouseEnter:Connect(function()
            sndHover()
            TweenService:Create(item, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(32, 26, 50)}):Play()
        end)
        item.MouseLeave:Connect(function()
            TweenService:Create(item, TweenInfo.new(0.15), {BackgroundColor3 = code == CurrentLang and Color3.fromRGB(28, 22, 44) or Color3.fromRGB(20, 20, 32)}):Play()
        end)
        item.MouseButton1Click:Connect(function()
            sndClick()
            CurrentLang = code
            updateAllTexts()
            if langMenu then langMenu:Destroy() langMenu = nil end
        end)
    end
    
    TweenService:Create(langMenu, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 160, 0, #LANGUAGES * 30 + 12)
    }):Play()
end)

CheckBtn.MouseEnter:Connect(function()
    sndHover()
    TweenService:Create(CheckBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(150, 120, 255)}):Play()
    TweenService:Create(checkGlow, TweenInfo.new(0.2), {Transparency = 0.7}):Play()
end)
CheckBtn.MouseLeave:Connect(function()
    TweenService:Create(CheckBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(130, 100, 255)}):Play()
    TweenService:Create(checkGlow, TweenInfo.new(0.2), {Transparency = 0.85}):Play()
end)

GetKeyBtn.MouseEnter:Connect(function()
    sndHover()
    TweenService:Create(GetKeyBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(28, 28, 42)}):Play()
    TweenService:Create(getKeyStroke, TweenInfo.new(0.2), {Transparency = 0.2}):Play()
end)
GetKeyBtn.MouseLeave:Connect(function()
    TweenService:Create(GetKeyBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20, 20, 32)}):Play()
    TweenService:Create(getKeyStroke, TweenInfo.new(0.2), {Transparency = 0.5}):Play()
end)

HwidLabel.MouseButton1Click:Connect(function()
    sndClick()
    pcall(function() setclipboard(HWID) end)
    HwidLabel.Text = L.hwidCopied
    task.wait(1.5)
    HwidLabel.Text = "HWID: " .. HWID:sub(1, 18) .. "..."
end)

GetKeyBtn.MouseButton1Click:Connect(function()
    sndClick()
    pcall(function() setclipboard(KEY_CONFIG.LINKVERTISE_URL) end)
    StatusLabel.TextColor3 = Color3.fromRGB(218, 165, 32)
    StatusLabel.Text = L.copied
end)

local isChecking = false
CheckBtn.MouseButton1Click:Connect(function()
    if isChecking then return end
    sndClick()
    
    local key = KeyInput.Text:gsub("%s+", "")
    
    if key == "" then
        sndError()
        StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        StatusLabel.Text = L.empty
        return
    end
    
    isChecking = true
    CheckBtn.Text = L.checking
    StatusLabel.Text = ""
    
    task.wait(0.3)
    
    local valid, message, expires = CheckKey(key)
    
    if valid then
        sndSuccess()
        StatusLabel.TextColor3 = Color3.fromRGB(80, 255, 140)
        StatusLabel.Text = message
        
        TweenService:Create(cardStroke, TweenInfo.new(0.4), {Color = Color3.fromRGB(80, 255, 140)}):Play()
        TweenService:Create(glowStroke, TweenInfo.new(0.4), {Color = Color3.fromRGB(80, 255, 140), Transparency = 0.6}):Play()
        
        if expires then
            local remaining = tonumber(expires) - os.time()
            if remaining > 0 and remaining < 86400 * 365 then
                local hours = math.floor(remaining / 3600)
                local minutes = math.floor((remaining % 3600) / 60)
                StatusLabel.Text = L.expires .. " " .. hours .. L.hours .. " " .. minutes .. L.minutes
            end
        end
        
        task.wait(1.5)
        
        TweenService:Create(Card, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0)
        }):Play()
        TweenService:Create(Overlay, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
        TweenService:Create(Blur, TweenInfo.new(0.6), {Size = 0}):Play()
        
        task.wait(0.7)
        KeyGui:Destroy()
        if Blur then Blur:Destroy() end
        
        StartMainScript()
    else
        sndError()
        StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        StatusLabel.Text = message
        
        local origPos = Card.Position
        for i = 1, 4 do
            TweenService:Create(Card, TweenInfo.new(0.05), {Position = origPos + UDim2.new(0, 6, 0, 0)}):Play()
            task.wait(0.05)
            TweenService:Create(Card, TweenInfo.new(0.05), {Position = origPos + UDim2.new(0, -6, 0, 0)}):Play()
            task.wait(0.05)
        end
        TweenService:Create(Card, TweenInfo.new(0.05), {Position = origPos}):Play()
        
        TweenService:Create(inputStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(255, 80, 80)}):Play()
        task.wait(1.5)
        TweenService:Create(inputStroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(45, 45, 65)}):Play()
        
        CheckBtn.Text = L.verify
        isChecking = false
    end
end)
