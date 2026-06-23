local KEY_CONFIG = {
    FIREBASE_URL = "https://nz-keys-default-rtdb.firebaseio.com",
    LINKVERTISE_URL = "https://link-center.net/6768376/3HCYVW6IyZJr",
    SCRIPT_NAME = "Nz",
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
pcall(function() HWID = game:GetService("RbxAnalyticsService"):GetClientId() end)
if HWID == "" then HWID = tostring(Player.UserId) .. "_" .. tostring(game.PlaceId) end

for _, name in ipairs({"NzKeySystem","NzGUI","NzTooltip"}) do
    if game.CoreGui:FindFirstChild(name) then game.CoreGui:FindFirstChild(name):Destroy() end
end
if Lighting:FindFirstChild("NzBlur") then Lighting:FindFirstChild("NzBlur"):Destroy() end
if Lighting:FindFirstChild("NzKeyBlur") then Lighting:FindFirstChild("NzKeyBlur"):Destroy() end

_G.NzLang = _G.NzLang or "en"

local LANGS = {
    ru = {
        f="🇷🇺", n="Русский",
        title="Key System", tab="Ключ", input="Введите ключ",
        check="Проверить ключ", getkey="Получить ключ", checking="Проверка...",
        empty="Введите ключ!", invalid="Неверный ключ!", expired="Ключ просрочен!",
        wrongpc="Привязан к другому ПК!", success="Доступ разрешён!",
        copied="Ссылка скопирована!", err="Ошибка подключения", hwid_c="HWID скопирован!",
        exp="Истекает через", h="ч", m="м", s="с", premium="Premium",
        loading="Загрузка...", themes_ready="60 тем готово", done="Готово!",
        notif_loaded="GUI загружен!",
        cat_vehicle="Машины", cat_player="Игрок", cat_criminal="Преступник",
        cat_cop="Полиция", cat_visuals="Визуал", cat_utility="Утилиты",
        cat_overlay="Overlay", cat_themes="Темы", cat_settings="Настройки",
        coming_soon="Скоро будет",
        f_activated="Активировано", f_deactivated="Отключено",
        f_carspeed="CarSpeed", f_carspeed_desc="Спидхак для машины с 5 режимами",
        f_antifling="AntiFling", f_antifling_desc="Защита от отлёта при ударе",
        f_faststop="FastStop", f_faststop_desc="Мгновенный стоп по двойному S",
        f_antiflip="AntiFlip", f_antiflip_desc="Защита от переворота машины",
        f_fastkill="FastKill", f_fastkill_desc="Быстрый респавн (уход от копов)",
        f_infjump="InfiniteJump", f_infjump_desc="Бесконечный прыжок в воздухе",
        set_lang="Язык / Language", set_bind="Бинд переключения GUI", set_blur="Эффект размытия", set_resize="Размер: тяни за правый нижний угол",
        base_themes="Базовые темы (60)", accent="Акцент", gui_settings="Настройки GUI",
        notify_theme="Тема", notify_accent="Акцент",
        howto="Как использовать", bind_label="Бинд", tip="Совет"
    },
    en = {
        f="🇬🇧", n="English",
        title="Key System", tab="Key", input="Enter key",
        check="Check Key", getkey="Get Key", checking="Checking...",
        empty="Enter key!", invalid="Invalid key!", expired="Key expired!",
        wrongpc="Bound to another PC!", success="Access granted!",
        copied="Link copied!", err="Connection error", hwid_c="HWID copied!",
        exp="Expires in", h="h", m="m", s="s", premium="Premium",
        loading="Loading...", themes_ready="60 themes ready", done="Done!",
        notif_loaded="GUI loaded!",
        cat_vehicle="Vehicle", cat_player="Player", cat_criminal="Criminal",
        cat_cop="Cop", cat_visuals="Visuals", cat_utility="Utility",
        cat_overlay="Overlay", cat_themes="Themes", cat_settings="Settings",
        coming_soon="Coming Soon",
        f_activated="Activated", f_deactivated="Deactivated",
        f_carspeed="CarSpeed", f_carspeed_desc="Vehicle speed hack with 5 modes",
        f_antifling="AntiFling", f_antifling_desc="Prevents fling on collision",
        f_faststop="FastStop", f_faststop_desc="Instant brake on double S",
        f_antiflip="AntiFlip", f_antiflip_desc="Prevents vehicle from flipping",
        f_fastkill="FastKill", f_fastkill_desc="Quick respawn (escape cops)",
        f_infjump="InfiniteJump", f_infjump_desc="Jump infinitely in air",
        set_lang="Language", set_bind="GUI toggle bind", set_blur="Blur effect", set_resize="Size: drag bottom right corner",
        base_themes="Base themes (60)", accent="Accent", gui_settings="GUI Settings",
        notify_theme="Theme", notify_accent="Accent",
        howto="How to use", bind_label="Bind", tip="Tip"
    },
    es = {
        f="🇪🇸", n="Español",
        title="Key System", tab="Clave", input="Ingresa clave",
        check="Verificar", getkey="Obtener clave", checking="Verificando...",
        empty="Ingresa clave!", invalid="Clave inválida!", expired="Clave expirada!",
        wrongpc="Vinculada a otro PC!", success="Acceso concedido!",
        copied="Enlace copiado!", err="Error de conexión", hwid_c="HWID copiado!",
        exp="Expira en", h="h", m="m", s="s", premium="Premium",
        loading="Cargando...", themes_ready="60 temas listos", done="Listo!",
        notif_loaded="GUI cargado!",
        cat_vehicle="Vehículo", cat_player="Jugador", cat_criminal="Criminal",
        cat_cop="Policía", cat_visuals="Visual", cat_utility="Utilidad",
        cat_overlay="Overlay", cat_themes="Temas", cat_settings="Ajustes",
        coming_soon="Próximamente",
        f_activated="Activado", f_deactivated="Desactivado",
        f_carspeed="CarSpeed", f_carspeed_desc="Hack de velocidad con 5 modos",
        f_antifling="AntiFling", f_antifling_desc="Previene salir disparado",
        f_faststop="FastStop", f_faststop_desc="Freno instantáneo doble S",
        f_antiflip="AntiFlip", f_antiflip_desc="Previene volcar el vehículo",
        f_fastkill="FastKill", f_fastkill_desc="Respawn rápido (escapar)",
        f_infjump="InfiniteJump", f_infjump_desc="Salta infinitamente en el aire",
        set_lang="Idioma", set_bind="Tecla del GUI", set_blur="Efecto blur", set_resize="Tamaño: arrastra esquina inferior derecha",
        base_themes="Temas base (60)", accent="Acento", gui_settings="Ajustes GUI",
        notify_theme="Tema", notify_accent="Acento",
        howto="Cómo usar", bind_label="Tecla", tip="Consejo"
    },
    de = {
        f="🇩🇪", n="Deutsch",
        title="Key System", tab="Schlüssel", input="Schlüssel eingeben",
        check="Prüfen", getkey="Schlüssel holen", checking="Prüfe...",
        empty="Schlüssel eingeben!", invalid="Ungültig!", expired="Abgelaufen!",
        wrongpc="Anderer PC!", success="Zugriff gewährt!",
        copied="Link kopiert!", err="Verbindungsfehler", hwid_c="HWID kopiert!",
        exp="Läuft ab in", h="St", m="M", s="S", premium="Premium",
        loading="Lade...", themes_ready="60 Themes bereit", done="Fertig!",
        notif_loaded="GUI geladen!",
        cat_vehicle="Fahrzeug", cat_player="Spieler", cat_criminal="Krimineller",
        cat_cop="Polizei", cat_visuals="Visuell", cat_utility="Werkzeuge",
        cat_overlay="Overlay", cat_themes="Themes", cat_settings="Einstellungen",
        coming_soon="Bald verfügbar",
        f_activated="Aktiviert", f_deactivated="Deaktiviert",
        f_carspeed="CarSpeed", f_carspeed_desc="Speed-Hack mit 5 Modi",
        f_antifling="AntiFling", f_antifling_desc="Schutz vor Wegschleudern",
        f_faststop="FastStop", f_faststop_desc="Sofortbremse mit Doppel-S",
        f_antiflip="AntiFlip", f_antiflip_desc="Verhindert Überschlag",
        f_fastkill="FastKill", f_fastkill_desc="Schnelles Respawn",
        f_infjump="InfiniteJump", f_infjump_desc="Unendlich in der Luft springen",
        set_lang="Sprache", set_bind="GUI-Taste", set_blur="Blur-Effekt", set_resize="Größe: ziehe rechte untere Ecke",
        base_themes="Basis-Themes (60)", accent="Akzent", gui_settings="GUI-Einstellungen",
        notify_theme="Theme", notify_accent="Akzent",
        howto="Anleitung", bind_label="Taste", tip="Tipp"
    },
    fr = {
        f="🇫🇷", n="Français",
        title="Key System", tab="Clé", input="Entrez la clé",
        check="Vérifier", getkey="Obtenir clé", checking="Vérification...",
        empty="Entrez la clé!", invalid="Clé invalide!", expired="Clé expirée!",
        wrongpc="Lié à un autre PC!", success="Accès accordé!",
        copied="Lien copié!", err="Erreur connexion", hwid_c="HWID copié!",
        exp="Expire dans", h="h", m="m", s="s", premium="Premium",
        loading="Chargement...", themes_ready="60 thèmes prêts", done="Terminé!",
        notif_loaded="GUI chargé!",
        cat_vehicle="Véhicule", cat_player="Joueur", cat_criminal="Criminel",
        cat_cop="Police", cat_visuals="Visuel", cat_utility="Utilitaires",
        cat_overlay="Overlay", cat_themes="Thèmes", cat_settings="Paramètres",
        coming_soon="Bientôt disponible",
        f_activated="Activé", f_deactivated="Désactivé",
        f_carspeed="CarSpeed", f_carspeed_desc="Hack de vitesse 5 modes",
        f_antifling="AntiFling", f_antifling_desc="Empêche de partir en l'air",
        f_faststop="FastStop", f_faststop_desc="Frein instantané double S",
        f_antiflip="AntiFlip", f_antiflip_desc="Empêche le tonneau",
        f_fastkill="FastKill", f_fastkill_desc="Respawn rapide (fuir)",
        f_infjump="InfiniteJump", f_infjump_desc="Sauts infinis en l'air",
        set_lang="Langue", set_bind="Touche GUI", set_blur="Effet flou", set_resize="Taille: glisser coin bas droit",
        base_themes="Thèmes de base (60)", accent="Accent", gui_settings="Paramètres GUI",
        notify_theme="Thème", notify_accent="Accent",
        howto="Comment utiliser", bind_label="Touche", tip="Astuce"
    },
    pt = {
        f="🇧🇷", n="Português",
        title="Key System", tab="Chave", input="Digite a chave",
        check="Verificar", getkey="Obter chave", checking="Verificando...",
        empty="Digite a chave!", invalid="Chave inválida!", expired="Chave expirada!",
        wrongpc="Vinculada a outro PC!", success="Acesso liberado!",
        copied="Link copiado!", err="Erro de conexão", hwid_c="HWID copiado!",
        exp="Expira em", h="h", m="m", s="s", premium="Premium",
        loading="Carregando...", themes_ready="60 temas prontos", done="Pronto!",
        notif_loaded="GUI carregada!",
        cat_vehicle="Veículo", cat_player="Jogador", cat_criminal="Criminoso",
        cat_cop="Polícia", cat_visuals="Visual", cat_utility="Utilitários",
        cat_overlay="Overlay", cat_themes="Temas", cat_settings="Configurações",
        coming_soon="Em breve",
        f_activated="Ativado", f_deactivated="Desativado",
        f_carspeed="CarSpeed", f_carspeed_desc="Speedhack com 5 modos",
        f_antifling="AntiFling", f_antifling_desc="Previne voar pelos ares",
        f_faststop="FastStop", f_faststop_desc="Freio instantâneo duplo S",
        f_antiflip="AntiFlip", f_antiflip_desc="Previne capotar",
        f_fastkill="FastKill", f_fastkill_desc="Respawn rápido (fugir)",
        f_infjump="InfiniteJump", f_infjump_desc="Pula infinitamente no ar",
        set_lang="Idioma", set_bind="Tecla do GUI", set_blur="Efeito blur", set_resize="Tamanho: arraste canto inferior direito",
        base_themes="Temas base (60)", accent="Acento", gui_settings="Configurações GUI",
        notify_theme="Tema", notify_accent="Acento",
        howto="Como usar", bind_label="Tecla", tip="Dica"
    },
    id = {
        f="🇮🇩", n="Indonesia",
        title="Key System", tab="Kunci", input="Masukkan kunci",
        check="Verifikasi", getkey="Dapatkan kunci", checking="Memeriksa...",
        empty="Masukkan kunci!", invalid="Tidak valid!", expired="Kadaluarsa!",
        wrongpc="Terikat PC lain!", success="Akses diberikan!",
        copied="Link disalin!", err="Kesalahan koneksi", hwid_c="HWID disalin!",
        exp="Berakhir dalam", h="j", m="m", s="d", premium="Premium",
        loading="Memuat...", themes_ready="60 tema siap", done="Selesai!",
        notif_loaded="GUI dimuat!",
        cat_vehicle="Kendaraan", cat_player="Pemain", cat_criminal="Kriminal",
        cat_cop="Polisi", cat_visuals="Visual", cat_utility="Utilitas",
        cat_overlay="Overlay", cat_themes="Tema", cat_settings="Pengaturan",
        coming_soon="Segera hadir",
        f_activated="Aktif", f_deactivated="Nonaktif",
        f_carspeed="CarSpeed", f_carspeed_desc="Speedhack kendaraan 5 mode",
        f_antifling="AntiFling", f_antifling_desc="Cegah terpental",
        f_faststop="FastStop", f_faststop_desc="Rem instan dengan double S",
        f_antiflip="AntiFlip", f_antiflip_desc="Cegah kendaraan terbalik",
        f_fastkill="FastKill", f_fastkill_desc="Respawn cepat (kabur)",
        f_infjump="InfiniteJump", f_infjump_desc="Lompat tanpa batas di udara",
        set_lang="Bahasa", set_bind="Tombol GUI", set_blur="Efek blur", set_resize="Ukuran: tarik pojok kanan bawah",
        base_themes="Tema dasar (60)", accent="Aksen", gui_settings="Pengaturan GUI",
        notify_theme="Tema", notify_accent="Aksen",
        howto="Cara pakai", bind_label="Tombol", tip="Tips"
    },
    tr = {
        f="🇹🇷", n="Türkçe",
        title="Key System", tab="Anahtar", input="Anahtar girin",
        check="Doğrula", getkey="Anahtar al", checking="Kontrol...",
        empty="Anahtar girin!", invalid="Geçersiz!", expired="Süresi dolmuş!",
        wrongpc="Başka PC!", success="Erişim verildi!",
        copied="Link kopyalandı!", err="Bağlantı hatası", hwid_c="HWID kopyalandı!",
        exp="Süre", h="s", m="d", s="s", premium="Premium",
        loading="Yükleniyor...", themes_ready="60 tema hazır", done="Tamam!",
        notif_loaded="GUI yüklendi!",
        cat_vehicle="Araç", cat_player="Oyuncu", cat_criminal="Suçlu",
        cat_cop="Polis", cat_visuals="Görsel", cat_utility="Araçlar",
        cat_overlay="Overlay", cat_themes="Temalar", cat_settings="Ayarlar",
        coming_soon="Yakında",
        f_activated="Aktif", f_deactivated="Pasif",
        f_carspeed="CarSpeed", f_carspeed_desc="5 modlu hız hilesi",
        f_antifling="AntiFling", f_antifling_desc="Fırlama önleyici",
        f_faststop="FastStop", f_faststop_desc="Çift S ile anında fren",
        f_antiflip="AntiFlip", f_antiflip_desc="Takla atmayı önler",
        f_fastkill="FastKill", f_fastkill_desc="Hızlı respawn (kaçmak)",
        f_infjump="InfiniteJump", f_infjump_desc="Havada sonsuz zıpla",
        set_lang="Dil", set_bind="GUI tuşu", set_blur="Bulanıklık", set_resize="Boyut: sağ alt köşeyi sürükle",
        base_themes="Temel temalar (60)", accent="Vurgu", gui_settings="GUI Ayarları",
        notify_theme="Tema", notify_accent="Vurgu",
        howto="Nasıl kullanılır", bind_label="Tuş", tip="İpucu"
    }
}

local function L() return LANGS[_G.NzLang] or LANGS.en end

local function playS(id, v, p)
    pcall(function()
        local s = Instance.new("Sound")
        s.SoundId = "rbxassetid://" .. id
        s.Volume = v or 0.5
        s.PlaybackSpeed = p or 1
        s.Parent = SoundService
        s:Play()
        s.Ended:Connect(function() s:Destroy() end)
        task.delay(3, function() if s and s.Parent then s:Destroy() end end)
    end)
end

local function sndOk() playS("9118823106", 0.6, 1) end
local function sndErr() playS("550209561", 0.5, 0.8) end
local function sndClick() playS("6042053626", 0.3, 1.2) end
local function sndHover() playS("10066931761", 0.15, 1.3) end

local function Cn(p, r) local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,r or 8);c.Parent=p;return c end
local function St(p, col, t, tr) local s=Instance.new("UIStroke");s.Color=col;s.Thickness=t or 1;s.Transparency=tr or 0;s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border;s.Parent=p;return s end
local function Tw(o, pr, d, s) TweenService:Create(o,TweenInfo.new(d or 0.25,s or Enum.EasingStyle.Quint,Enum.EasingDirection.Out),pr):Play() end

local function CheckKey(key)
    local LL = L()
    local ok, res = pcall(function() return game:HttpGet(KEY_CONFIG.FIREBASE_URL.."/keys/"..key..".json") end)
    if not ok then return false, LL.err end
    if res == "null" or res == nil or res == "" then return false, LL.invalid end
    local ok2, data = pcall(function() return HttpService:JSONDecode(res) end)
    if not ok2 or not data then return false, LL.invalid end
    if data.expires and tonumber(data.expires) and tonumber(data.expires) < os.time() then
        pcall(function()
            local req = http_request or request or (syn and syn.request)
            if req then req({Url=KEY_CONFIG.FIREBASE_URL.."/keys/"..key..".json", Method="DELETE"}) end
        end)
        return false, LL.expired
    end
    if data.hwid and data.hwid ~= "none" and data.hwid ~= HWID then return false, LL.wrongpc end
    if data.hwid == "none" then
        pcall(function()
            local req = http_request or request or (syn and syn.request)
            if req then req({Url=KEY_CONFIG.FIREBASE_URL.."/keys/"..key..".json", Method="PATCH", Headers={["Content-Type"]="application/json"}, Body=HttpService:JSONEncode({hwid=HWID})}) end
        end)
    end
    return true, LL.success, data.expires
end

local KG = Instance.new("ScreenGui")
KG.Name = "NzKeySystem"
KG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
KG.ResetOnSpawn = false
KG.IgnoreGuiInset = true
KG.Parent = game.CoreGui

local KB = Instance.new("BlurEffect")
KB.Name = "NzKeyBlur"
KB.Size = 0
KB.Parent = Lighting
Tw(KB, {Size=12}, 0.6)

local OV = Instance.new("Frame")
OV.BackgroundColor3 = Color3.fromRGB(0,0,0)
OV.BackgroundTransparency = 1
OV.Size = UDim2.new(1,0,1,0)
OV.ZIndex = 100
OV.Parent = KG
Tw(OV, {BackgroundTransparency=0.45}, 0.5)

local MW = Instance.new("Frame")
MW.BackgroundColor3 = Color3.fromRGB(14,14,20)
MW.BorderSizePixel = 0
MW.Position = UDim2.new(0.5,0,0.5,0)
MW.AnchorPoint = Vector2.new(0.5,0.5)
MW.Size = UDim2.new(0,0,0,0)
MW.ZIndex = 101
MW.ClipsDescendants = true
MW.Parent = KG
Cn(MW, 12)

local mwGrad = Instance.new("UIGradient")
mwGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(18,16,26)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10,10,16))
}
mwGrad.Rotation = 160
mwGrad.Parent = MW

local mwStr = St(MW, Color3.fromRGB(50,45,70), 1, 0.3)
local mwGlow = St(MW, Color3.fromRGB(130,100,255), 3, 0.88)

local SBW = 180

local SB = Instance.new("Frame")
SB.BackgroundColor3 = Color3.fromRGB(12,12,18)
SB.BackgroundTransparency = 0.02
SB.BorderSizePixel = 0
SB.Size = UDim2.new(0,SBW,1,0)
SB.ZIndex = 102
SB.Parent = MW
Cn(SB, 12)

local sbGrad = Instance.new("UIGradient")
sbGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(16,14,24)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10,10,16))
}
sbGrad.Rotation = 180
sbGrad.Parent = SB

local SBMask = Instance.new("Frame")
SBMask.BackgroundColor3 = Color3.fromRGB(12,12,18)
SBMask.BackgroundTransparency = 0.02
SBMask.BorderSizePixel = 0
SBMask.Position = UDim2.new(1,-14,0,0)
SBMask.Size = UDim2.new(0,14,1,0)
SBMask.ZIndex = 101
SBMask.Parent = SB

local sbDiv = Instance.new("Frame")
sbDiv.BackgroundColor3 = Color3.fromRGB(50,45,70)
sbDiv.BackgroundTransparency = 0.5
sbDiv.BorderSizePixel = 0
sbDiv.Position = UDim2.new(1,0,0,8)
sbDiv.Size = UDim2.new(0,1,1,-16)
sbDiv.ZIndex = 103
sbDiv.Parent = SB

local logoF = Instance.new("Frame")
logoF.BackgroundColor3 = Color3.fromRGB(130,100,255)
logoF.Position = UDim2.new(0,16,0,18)
logoF.Size = UDim2.new(0,34,0,34)
logoF.Rotation = -20
logoF.ZIndex = 104
logoF.Parent = SB
Cn(logoF, 9)
local lgGrad = Instance.new("UIGradient")
lgGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(130,100,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(165,135,255))
}
lgGrad.Rotation = 45
lgGrad.Parent = logoF

local brandL = Instance.new("TextLabel")
brandL.BackgroundTransparency = 1
brandL.Position = UDim2.new(0,58,0,16)
brandL.Size = UDim2.new(1,-66,0,22)
brandL.Font = Enum.Font.GothamBold
brandL.Text = KEY_CONFIG.SCRIPT_NAME
brandL.TextColor3 = Color3.fromRGB(240,240,250)
brandL.TextSize = 18
brandL.TextXAlignment = Enum.TextXAlignment.Left
brandL.ZIndex = 104
brandL.Parent = SB

local verL = Instance.new("TextLabel")
verL.BackgroundTransparency = 1
verL.Position = UDim2.new(0,58,0,38)
verL.Size = UDim2.new(1,-66,0,14)
verL.Font = Enum.Font.Gotham
verL.Text = KEY_CONFIG.VERSION
verL.TextColor3 = Color3.fromRGB(218,165,32)
verL.TextSize = 10
verL.TextXAlignment = Enum.TextXAlignment.Left
verL.ZIndex = 104
verL.Parent = SB

local logoDiv = Instance.new("Frame")
logoDiv.BackgroundColor3 = Color3.fromRGB(50,45,70)
logoDiv.BackgroundTransparency = 0.5
logoDiv.BorderSizePixel = 0
logoDiv.Position = UDim2.new(0,14,0,64)
logoDiv.Size = UDim2.new(1,-28,0,1)
logoDiv.ZIndex = 104
logoDiv.Parent = SB

local keyTab = Instance.new("Frame")
keyTab.BackgroundColor3 = Color3.fromRGB(130,100,255)
keyTab.BackgroundTransparency = 0.85
keyTab.BorderSizePixel = 0
keyTab.Position = UDim2.new(0,10,0,78)
keyTab.Size = UDim2.new(1,-20,0,38)
keyTab.ZIndex = 104
keyTab.Parent = SB
Cn(keyTab, 8)

local keyTabLine = Instance.new("Frame")
keyTabLine.BackgroundColor3 = Color3.fromRGB(130,100,255)
keyTabLine.BorderSizePixel = 0
keyTabLine.Position = UDim2.new(0,0,0.15,0)
keyTabLine.Size = UDim2.new(0,3,0.7,0)
keyTabLine.ZIndex = 105
keyTabLine.Parent = keyTab
Cn(keyTabLine, 2)

local keyTabIcon = Instance.new("TextLabel")
keyTabIcon.BackgroundTransparency = 1
keyTabIcon.Position = UDim2.new(0,14,0,0)
keyTabIcon.Size = UDim2.new(0,22,1,0)
keyTabIcon.Font = Enum.Font.GothamBold
keyTabIcon.Text = "◇"
keyTabIcon.TextColor3 = Color3.fromRGB(130,100,255)
keyTabIcon.TextSize = 16
keyTabIcon.ZIndex = 105
keyTabIcon.Parent = keyTab

local keyTabLabel = Instance.new("TextLabel")
keyTabLabel.BackgroundTransparency = 1
keyTabLabel.Position = UDim2.new(0,40,0,0)
keyTabLabel.Size = UDim2.new(1,-46,1,0)
keyTabLabel.Font = Enum.Font.GothamMedium
keyTabLabel.Text = L().tab
keyTabLabel.TextColor3 = Color3.fromRGB(240,240,250)
keyTabLabel.TextSize = 13
keyTabLabel.TextXAlignment = Enum.TextXAlignment.Left
keyTabLabel.ZIndex = 105
keyTabLabel.Parent = keyTab

local langContainer = Instance.new("ScrollingFrame")
langContainer.BackgroundTransparency = 1
langContainer.BorderSizePixel = 0
langContainer.Position = UDim2.new(0,10,0,128)
langContainer.Size = UDim2.new(1,-20,1,-200)
langContainer.CanvasSize = UDim2.new(0,0,0,0)
langContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
langContainer.ScrollBarThickness = 2
langContainer.ScrollBarImageColor3 = Color3.fromRGB(130,100,255)
langContainer.ScrollBarImageTransparency = 0.5
langContainer.ZIndex = 104
langContainer.Parent = SB
local langList = Instance.new("UIListLayout")
langList.Padding = UDim.new(0,3)
langList.Parent = langContainer

local langBtns = {}
local keyInputBox, checkBtn, getKeyBtn, titleR

local LANG_ORDER = {"en","ru","es","de","fr","pt","id","tr"}

for _, code in ipairs(LANG_ORDER) do
    local lang = LANGS[code]
    local lb = Instance.new("TextButton")
    lb.BackgroundColor3 = code == _G.NzLang and Color3.fromRGB(24,20,36) or Color3.fromRGB(16,16,24)
    lb.BackgroundTransparency = code == _G.NzLang and 0.3 or 0.8
    lb.BorderSizePixel = 0
    lb.Size = UDim2.new(1,0,0,28)
    lb.Font = Enum.Font.GothamMedium
    lb.Text = "  " .. lang.f .. "  " .. lang.n
    lb.TextColor3 = code == _G.NzLang and Color3.fromRGB(218,165,32) or Color3.fromRGB(160,160,180)
    lb.TextSize = 11
    lb.TextXAlignment = Enum.TextXAlignment.Left
    lb.ZIndex = 105
    lb.AutoButtonColor = false
    lb.Name = code
    lb.Parent = langContainer
    Cn(lb, 6)
    langBtns[code] = lb
    
    lb.MouseEnter:Connect(function()
        sndHover()
        if code ~= _G.NzLang then Tw(lb, {BackgroundTransparency=0.4, TextColor3=Color3.fromRGB(200,200,220)}, 0.15) end
    end)
    lb.MouseLeave:Connect(function()
        if code ~= _G.NzLang then Tw(lb, {BackgroundTransparency=0.8, TextColor3=Color3.fromRGB(160,160,180)}, 0.15) end
    end)
    lb.MouseButton1Click:Connect(function()
        sndClick()
        _G.NzLang = code
        local LL = L()
        keyTabLabel.Text = LL.tab
        if keyInputBox then keyInputBox.PlaceholderText = LL.input end
        if checkBtn then checkBtn.Text = LL.check end
        if getKeyBtn then getKeyBtn.Text = LL.getkey end
        if titleR then titleR.Text = LL.title end
        for c, b in pairs(langBtns) do
            if c == code then
                Tw(b, {BackgroundTransparency=0.3, TextColor3=Color3.fromRGB(218,165,32)}, 0.2)
            else
                Tw(b, {BackgroundTransparency=0.8, TextColor3=Color3.fromRGB(160,160,180)}, 0.2)
            end
        end
    end)
end

local profDiv = Instance.new("Frame")
profDiv.BackgroundColor3 = Color3.fromRGB(50,45,70)
profDiv.BackgroundTransparency = 0.5
profDiv.BorderSizePixel = 0
profDiv.Position = UDim2.new(0,14,1,-58)
profDiv.Size = UDim2.new(1,-28,0,1)
profDiv.ZIndex = 104
profDiv.Parent = SB

local profAvatar = Instance.new("ImageLabel")
profAvatar.BackgroundColor3 = Color3.fromRGB(30,30,45)
profAvatar.Position = UDim2.new(0,14,1,-48)
profAvatar.Size = UDim2.new(0,32,0,32)
profAvatar.ZIndex = 104
profAvatar.Parent = SB
Cn(profAvatar, 16)
pcall(function() profAvatar.Image = Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48) end)

local profName = Instance.new("TextLabel")
profName.BackgroundTransparency = 1
profName.Position = UDim2.new(0,52,1,-50)
profName.Size = UDim2.new(1,-60,0,18)
profName.Font = Enum.Font.GothamMedium
profName.Text = Player.Name
profName.TextColor3 = Color3.fromRGB(240,240,250)
profName.TextSize = 12
profName.TextXAlignment = Enum.TextXAlignment.Left
profName.ZIndex = 104
profName.Parent = SB

local profSub = Instance.new("TextLabel")
profSub.BackgroundTransparency = 1
profSub.Position = UDim2.new(0,52,1,-32)
profSub.Size = UDim2.new(1,-60,0,14)
profSub.Font = Enum.Font.Gotham
profSub.Text = L().premium
profSub.TextColor3 = Color3.fromRGB(218,165,32)
profSub.TextSize = 10
profSub.TextXAlignment = Enum.TextXAlignment.Left
profSub.ZIndex = 104
profSub.Parent = SB

titleR = Instance.new("TextLabel")
titleR.BackgroundTransparency = 1
titleR.Position = UDim2.new(0,SBW+20,0,14)
titleR.Size = UDim2.new(1,-SBW-40,0,24)
titleR.Font = Enum.Font.GothamBold
titleR.Text = L().title
titleR.TextColor3 = Color3.fromRGB(240,240,250)
titleR.TextSize = 16
titleR.TextXAlignment = Enum.TextXAlignment.Left
titleR.ZIndex = 102
titleR.Parent = MW

local closeBtn = Instance.new("TextButton")
closeBtn.BackgroundColor3 = Color3.fromRGB(80,30,30)
closeBtn.BackgroundTransparency = 0.5
closeBtn.BorderSizePixel = 0
closeBtn.Position = UDim2.new(1,-38,0,14)
closeBtn.Size = UDim2.new(0,24,0,24)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255,100,100)
closeBtn.TextSize = 12
closeBtn.ZIndex = 105
closeBtn.AutoButtonColor = false
closeBtn.Parent = MW
Cn(closeBtn, 6)

closeBtn.MouseEnter:Connect(function() sndHover() Tw(closeBtn, {BackgroundTransparency=0.2}, 0.15) end)
closeBtn.MouseLeave:Connect(function() Tw(closeBtn, {BackgroundTransparency=0.5}, 0.15) end)
closeBtn.MouseButton1Click:Connect(function()
    sndClick()
    Tw(MW, {Size=UDim2.new(0,0,0,0)}, 0.4, Enum.EasingStyle.Back)
    Tw(OV, {BackgroundTransparency=1}, 0.5)
    Tw(KB, {Size=0}, 0.5)
    task.wait(0.5)
    KG:Destroy()
    if KB then KB:Destroy() end
end)

local topDiv = Instance.new("Frame")
topDiv.BackgroundColor3 = Color3.fromRGB(50,45,70)
topDiv.BackgroundTransparency = 0.5
topDiv.BorderSizePixel = 0
topDiv.Position = UDim2.new(0,SBW,0,48)
topDiv.Size = UDim2.new(1,-SBW,0,1)
topDiv.ZIndex = 103
topDiv.Parent = MW

local contentArea = Instance.new("Frame")
contentArea.BackgroundTransparency = 1
contentArea.Position = UDim2.new(0,SBW+20,0,65)
contentArea.Size = UDim2.new(1,-SBW-40,1,-80)
contentArea.ZIndex = 102
contentArea.Parent = MW

local inputLabel = Instance.new("TextLabel")
inputLabel.BackgroundTransparency = 1
inputLabel.Position = UDim2.new(0,0,0,0)
inputLabel.Size = UDim2.new(1,0,0,16)
inputLabel.Font = Enum.Font.GothamMedium
inputLabel.Text = "INPUT"
inputLabel.TextColor3 = Color3.fromRGB(120,120,145)
inputLabel.TextSize = 10
inputLabel.TextXAlignment = Enum.TextXAlignment.Right
inputLabel.ZIndex = 103
inputLabel.Parent = contentArea

local inputFrame = Instance.new("Frame")
inputFrame.BackgroundColor3 = Color3.fromRGB(14,14,22)
inputFrame.BorderSizePixel = 0
inputFrame.Position = UDim2.new(0,0,0,22)
inputFrame.Size = UDim2.new(1,0,0,42)
inputFrame.ZIndex = 103
inputFrame.Parent = contentArea
Cn(inputFrame, 8)
local inpStr = St(inputFrame, Color3.fromRGB(45,42,60), 1, 0.3)

keyInputBox = Instance.new("TextBox")
keyInputBox.Name = "KeyInput"
keyInputBox.BackgroundTransparency = 1
keyInputBox.Position = UDim2.new(0,14,0,0)
keyInputBox.Size = UDim2.new(1,-28,1,0)
keyInputBox.Font = Enum.Font.GothamMedium
keyInputBox.PlaceholderText = L().input
keyInputBox.PlaceholderColor3 = Color3.fromRGB(70,70,90)
keyInputBox.Text = ""
keyInputBox.TextColor3 = Color3.fromRGB(240,240,250)
keyInputBox.TextSize = 14
keyInputBox.TextXAlignment = Enum.TextXAlignment.Left
keyInputBox.ClearTextOnFocus = false
keyInputBox.ZIndex = 104
keyInputBox.Parent = inputFrame

keyInputBox.Focused:Connect(function() Tw(inpStr, {Color=Color3.fromRGB(130,100,255), Transparency=0}, 0.2) end)
keyInputBox.FocusLost:Connect(function() Tw(inpStr, {Color=Color3.fromRGB(45,42,60), Transparency=0.3}, 0.2) end)

checkBtn = Instance.new("TextButton")
checkBtn.BackgroundColor3 = Color3.fromRGB(14,14,22)
checkBtn.BorderSizePixel = 0
checkBtn.Position = UDim2.new(0,0,0,74)
checkBtn.Size = UDim2.new(1,0,0,42)
checkBtn.Font = Enum.Font.GothamMedium
checkBtn.Text = L().check
checkBtn.TextColor3 = Color3.fromRGB(200,200,220)
checkBtn.TextSize = 13
checkBtn.TextXAlignment = Enum.TextXAlignment.Left
checkBtn.ZIndex = 103
checkBtn.AutoButtonColor = false
checkBtn.Parent = contentArea
Cn(checkBtn, 8)
local chkStr = St(checkBtn, Color3.fromRGB(45,42,60), 1, 0.3)
local chkPad = Instance.new("UIPadding")
chkPad.PaddingLeft = UDim.new(0,14)
chkPad.Parent = checkBtn

local chkToggle = Instance.new("Frame")
chkToggle.BackgroundColor3 = Color3.fromRGB(60,60,80)
chkToggle.BorderSizePixel = 0
chkToggle.Position = UDim2.new(1,-48,0.5,0)
chkToggle.AnchorPoint = Vector2.new(0,0.5)
chkToggle.Size = UDim2.new(0,36,0,20)
chkToggle.ZIndex = 104
chkToggle.Parent = checkBtn
Cn(chkToggle, 10)

local chkCircle = Instance.new("Frame")
chkCircle.BackgroundColor3 = Color3.fromRGB(200,200,220)
chkCircle.BorderSizePixel = 0
chkCircle.Position = UDim2.new(0,3,0.5,0)
chkCircle.AnchorPoint = Vector2.new(0,0.5)
chkCircle.Size = UDim2.new(0,14,0,14)
chkCircle.ZIndex = 105
chkCircle.Parent = chkToggle
Cn(chkCircle, 100)

checkBtn.MouseEnter:Connect(function() sndHover() Tw(checkBtn, {BackgroundColor3=Color3.fromRGB(22,20,32)}, 0.15) end)
checkBtn.MouseLeave:Connect(function() Tw(checkBtn, {BackgroundColor3=Color3.fromRGB(14,14,22)}, 0.15) end)

local statusLabel = Instance.new("TextLabel")
statusLabel.BackgroundTransparency = 1
statusLabel.Position = UDim2.new(0,0,0,124)
statusLabel.Size = UDim2.new(1,0,0,18)
statusLabel.Font = Enum.Font.GothamMedium
statusLabel.Text = ""
statusLabel.TextColor3 = Color3.fromRGB(255,80,80)
statusLabel.TextSize = 11
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.ZIndex = 103
statusLabel.Parent = contentArea

local timerLabel = Instance.new("TextLabel")
timerLabel.BackgroundTransparency = 1
timerLabel.Position = UDim2.new(0,0,0,144)
timerLabel.Size = UDim2.new(1,0,0,16)
timerLabel.Font = Enum.Font.Gotham
timerLabel.Text = ""
timerLabel.TextColor3 = Color3.fromRGB(218,165,32)
timerLabel.TextSize = 10
timerLabel.TextXAlignment = Enum.TextXAlignment.Left
timerLabel.ZIndex = 103
timerLabel.Parent = contentArea

getKeyBtn = Instance.new("TextButton")
getKeyBtn.BackgroundColor3 = Color3.fromRGB(14,14,22)
getKeyBtn.BorderSizePixel = 0
getKeyBtn.Position = UDim2.new(0,0,1,-50)
getKeyBtn.Size = UDim2.new(1,0,0,42)
getKeyBtn.Font = Enum.Font.GothamMedium
getKeyBtn.Text = L().getkey
getKeyBtn.TextColor3 = Color3.fromRGB(218,165,32)
getKeyBtn.TextSize = 13
getKeyBtn.TextXAlignment = Enum.TextXAlignment.Left
getKeyBtn.ZIndex = 103
getKeyBtn.AutoButtonColor = false
getKeyBtn.Parent = contentArea
Cn(getKeyBtn, 8)
local gkStr = St(getKeyBtn, Color3.fromRGB(218,165,32), 1, 0.6)
local gkPad = Instance.new("UIPadding")
gkPad.PaddingLeft = UDim.new(0,14)
gkPad.Parent = getKeyBtn

getKeyBtn.MouseEnter:Connect(function()
    sndHover()
    Tw(getKeyBtn, {BackgroundColor3=Color3.fromRGB(22,20,32)}, 0.15)
    Tw(gkStr, {Transparency=0.3}, 0.15)
end)
getKeyBtn.MouseLeave:Connect(function()
    Tw(getKeyBtn, {BackgroundColor3=Color3.fromRGB(14,14,22)}, 0.15)
    Tw(gkStr, {Transparency=0.6}, 0.15)
end)

getKeyBtn.MouseButton1Click:Connect(function()
    sndClick()
    pcall(function() setclipboard(KEY_CONFIG.LINKVERTISE_URL) end)
    statusLabel.TextColor3 = Color3.fromRGB(218,165,32)
    statusLabel.Text = L().copied
end)

local hwidBtn = Instance.new("TextButton")
hwidBtn.BackgroundTransparency = 1
hwidBtn.Position = UDim2.new(0,SBW+20,1,-20)
hwidBtn.Size = UDim2.new(1,-SBW-40,0,14)
hwidBtn.Font = Enum.Font.Gotham
hwidBtn.Text = "HWID: " .. HWID:sub(1,18) .. "..."
hwidBtn.TextColor3 = Color3.fromRGB(55,55,72)
hwidBtn.TextSize = 9
hwidBtn.TextXAlignment = Enum.TextXAlignment.Left
hwidBtn.ZIndex = 102
hwidBtn.AutoButtonColor = false
hwidBtn.Parent = MW

hwidBtn.MouseButton1Click:Connect(function()
    sndClick()
    pcall(function() setclipboard(HWID) end)
    hwidBtn.Text = L().hwid_c
    task.wait(1.5)
    hwidBtn.Text = "HWID: " .. HWID:sub(1,18) .. "..."
end)

local dr, dI, dS, sP
local function SDD(i) dr=true; dS=i.Position; sP=MW.Position; i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dr=false end end) end
MW.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 and i.Position.Y<MW.AbsolutePosition.Y+50 then SDD(i) end end)
UserInputService.InputChanged:Connect(function(i)
    if dr and dI and i.UserInputType==Enum.UserInputType.MouseMovement then
        local d = i.Position - dS
        MW.Position = UDim2.new(sP.X.Scale, sP.X.Offset+d.X, sP.Y.Scale, sP.Y.Offset+d.Y)
    end
end)
MW.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement then dI=i end end)

Tw(MW, {Size=UDim2.new(0,640,0,380)}, 0.6, Enum.EasingStyle.Back)

spawn(function()
    while mwGlow and mwGlow.Parent do
        Tw(mwGlow, {Transparency=0.8}, 2, Enum.EasingStyle.Sine)
        task.wait(2)
        Tw(mwGlow, {Transparency=0.92}, 2, Enum.EasingStyle.Sine)
        task.wait(2)
    end
end)

spawn(function()
    while logoF and logoF.Parent do
        Tw(logoF, {Rotation=-15}, 3, Enum.EasingStyle.Sine)
        task.wait(3)
        Tw(logoF, {Rotation=-25}, 3, Enum.EasingStyle.Sine)
        task.wait(3)
    end
end)

local StartMainScript

local isChecking = false
checkBtn.MouseButton1Click:Connect(function()
    if isChecking then return end
    sndClick()
    local LL = L()
    local key = keyInputBox.Text:gsub("%s+", "")
    if key == "" then
        sndErr()
        statusLabel.TextColor3 = Color3.fromRGB(255,80,80)
        statusLabel.Text = LL.empty
        return
    end
    isChecking = true
    checkBtn.Text = LL.checking
    statusLabel.Text = ""
    timerLabel.Text = ""
    task.wait(0.3)
    local valid, message, expires = CheckKey(key)
    if valid then
        sndOk()
        statusLabel.TextColor3 = Color3.fromRGB(80,255,140)
        statusLabel.Text = message
        Tw(chkToggle, {BackgroundColor3=Color3.fromRGB(80,255,140)}, 0.3)
        Tw(chkCircle, {Position=UDim2.new(1,-17,0.5,0)}, 0.3)
        Tw(mwStr, {Color=Color3.fromRGB(80,255,140)}, 0.4)
        Tw(mwGlow, {Color=Color3.fromRGB(80,255,140), Transparency=0.7}, 0.4)
        if expires then
            local rem = tonumber(expires) - os.time()
            if rem > 0 and rem < 86400*365 then
                local h = math.floor(rem/3600)
                local m = math.floor((rem%3600)/60)
                timerLabel.Text = LL.exp .. " " .. h .. LL.h .. " " .. m .. LL.m
            end
        end
        task.wait(1.5)
        Tw(MW, {Size=UDim2.new(0,0,0,0)}, 0.5, Enum.EasingStyle.Back)
        Tw(OV, {BackgroundTransparency=1}, 0.6)
        Tw(KB, {Size=0}, 0.6)
        task.wait(0.7)
        KG:Destroy()
        if KB then KB:Destroy() end
        if StartMainScript then StartMainScript() end
    else
        sndErr()
        statusLabel.TextColor3 = Color3.fromRGB(255,80,80)
        statusLabel.Text = message
        local origPos = MW.Position
        for _ = 1, 4 do
            Tw(MW, {Position=origPos+UDim2.new(0,6,0,0)}, 0.04)
            task.wait(0.04)
            Tw(MW, {Position=origPos+UDim2.new(0,-6,0,0)}, 0.04)
            task.wait(0.04)
        end
        Tw(MW, {Position=origPos}, 0.04)
        Tw(inpStr, {Color=Color3.fromRGB(255,80,80)}, 0.2)
        task.wait(1.5)
        Tw(inpStr, {Color=Color3.fromRGB(45,42,60)}, 0.3)
        checkBtn.Text = L().check
        isChecking = false
    end
end)

local FUNCTIONS = {}

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
            NotifBg=sb, SettBg=sb,
            SliderBg=Color3.fromRGB(math.floor((r1+r2)/2),math.floor((g1+g2)/2),math.floor((b1+b2)/2)),
            Trans=tr or 0.07,
            Grad1=Color3.fromRGB(math.min(math.floor(r2*1.1),255),math.min(math.floor(g2*1.1),255),math.min(math.floor(b2*1.1),255)),
            Grad2=bg,
            TBGrad1=Color3.fromRGB(math.min(r3+5,255),math.min(g3+5,255),math.min(b3+5,255)),
            TBGrad2=tb,
        }
    end

    local ThemeList = {
        T("t01","Midnight Black",5,5,8,8,8,14,10,10,16,16,16,24,235,235,248,0.06),
        T("t02","Dark Slate",18,18,26,22,22,34,24,24,36,32,32,48,242,242,252,0.08),
        T("t03","Obsidian",3,3,5,6,6,10,8,8,12,14,14,20,230,230,240,0.05),
        T("t04","Charcoal",20,20,22,26,26,28,28,28,32,36,36,42,238,238,240,0.08),
        T("t05","Graphite",22,22,25,28,28,32,30,30,35,38,38,45,235,235,242,0.08),
        T("t06","Purple Night",12,8,22,16,10,30,18,12,32,28,20,48,235,230,255,0.07),
        T("t07","Violet Abyss",8,4,18,12,6,25,14,8,28,22,14,42,228,220,255,0.06),
        T("t08","Amethyst",15,10,28,20,14,36,22,16,38,32,24,52,240,232,255,0.07),
        T("t09","Plum",18,8,20,24,12,28,26,14,30,36,20,42,248,230,245,0.07),
        T("t10","Indigo",10,8,25,14,12,32,16,14,35,24,20,48,230,225,255,0.07),
        T("t11","Deep Ocean",6,14,22,8,18,28,10,20,32,14,28,42,220,240,255,0.07),
        T("t12","Navy",5,8,18,8,12,24,10,14,28,16,22,38,218,232,255,0.06),
        T("t13","Cobalt",6,10,22,10,16,30,12,18,34,18,26,46,225,238,255,0.07),
        T("t14","Steel Blue",12,18,28,16,24,36,18,26,40,26,36,52,228,240,255,0.07),
        T("t15","Arctic",8,16,24,12,22,32,14,24,36,20,34,48,222,242,255,0.07),
        T("t16","Dark Forest",8,16,10,10,20,14,12,24,16,18,34,22,225,248,230,0.07),
        T("t17","Emerald",6,18,12,8,24,16,10,28,18,16,38,24,220,252,228,0.07),
        T("t18","Jade",8,14,12,12,20,16,14,24,18,20,32,26,228,245,232,0.07),
        T("t19","Moss",12,16,8,16,22,12,18,24,14,26,34,20,240,248,225,0.07),
        T("t20","Olive Night",14,14,6,18,18,10,22,22,12,30,30,18,245,245,220,0.07),
        T("t21","Sunset",22,10,14,28,12,18,32,14,20,42,22,30,255,235,240,0.07),
        T("t22","Crimson",20,6,8,26,10,12,30,12,14,40,18,22,255,228,232,0.06),
        T("t23","Blood Moon",18,4,6,24,8,10,28,10,12,38,16,18,252,225,228,0.06),
        T("t24","Maroon",16,8,10,22,12,14,24,14,16,34,20,24,248,232,235,0.07),
        T("t25","Burgundy",14,6,10,20,10,16,22,12,18,32,18,26,245,228,238,0.07),
        T("t26","Rose Dream",20,10,18,26,12,24,30,14,28,42,22,38,255,230,248,0.07),
        T("t27","Fuchsia",22,6,20,28,10,26,32,12,30,44,18,42,255,225,252,0.07),
        T("t28","Blush",24,14,20,30,18,26,34,20,28,46,28,40,255,235,245,0.07),
        T("t29","Magenta",20,4,18,26,8,24,30,10,28,42,16,38,252,222,248,0.06),
        T("t30","Pink Panther",25,10,16,32,14,22,36,16,24,48,24,34,255,232,242,0.07),
        T("t31","Golden Night",16,14,8,22,18,10,26,22,12,38,32,18,255,248,225,0.07),
        T("t32","Amber",20,14,4,26,18,8,30,22,10,42,30,14,255,245,218,0.07),
        T("t33","Copper",18,12,8,24,16,12,28,18,14,38,26,18,252,242,228,0.07),
        T("t34","Bronze",16,12,6,22,16,10,24,18,12,34,26,16,248,240,222,0.07),
        T("t35","Caramel",22,16,8,28,20,12,32,24,14,44,32,20,255,248,230,0.07),
        T("t36","Teal Depths",6,16,18,8,20,24,10,24,28,14,34,40,215,248,252,0.07),
        T("t37","Aqua",4,18,20,8,24,26,10,28,30,16,38,42,218,252,255,0.07),
        T("t38","Turquoise",6,16,16,10,22,22,12,26,26,18,36,36,222,250,250,0.07),
        T("t39","Sea Green",6,18,14,10,24,18,12,28,22,18,38,30,220,252,242,0.07),
        T("t40","Lagoon",4,14,18,8,20,24,10,22,28,14,32,40,215,245,255,0.07),
        T("t41","Storm",14,14,18,18,18,24,20,20,26,28,28,36,232,232,242,0.07),
        T("t42","Ash",18,18,18,24,24,24,26,26,26,34,34,34,240,240,240,0.08),
        T("t43","Slate",16,18,20,22,24,28,24,26,30,32,36,42,235,240,248,0.07),
        T("t44","Smoke",20,20,22,26,26,30,28,28,32,36,36,44,238,238,248,0.08),
        T("t45","Zinc",15,16,18,20,22,24,22,24,28,30,32,38,234,238,244,0.07),
        T("t46","Clean Light",244,244,250,236,236,244,250,250,254,255,255,255,18,18,32,0.04),
        T("t47","Sakura Light",252,242,248,248,235,244,254,248,252,255,250,254,45,20,35,0.04),
        T("t48","Mint Breeze",238,252,248,230,248,242,244,254,250,248,255,252,15,40,30,0.04),
        T("t49","Lavender Mist",245,240,255,238,232,252,250,246,255,252,248,255,30,20,50,0.04),
        T("t50","Cream",255,252,245,250,246,238,255,254,250,255,255,252,35,30,15,0.04),
        T("t51","Sky",240,248,255,232,242,252,246,252,255,250,254,255,15,30,50,0.04),
        T("t52","Peach",255,245,240,252,238,232,255,250,246,255,252,248,50,25,15,0.04),
        T("t53","Ice",242,250,255,235,244,252,248,254,255,252,255,255,10,25,45,0.04),
        T("t54","Sand",252,248,238,246,242,230,255,252,244,255,254,248,40,35,18,0.04),
        T("t55","Pearl",248,248,252,242,242,248,252,252,255,255,255,255,22,22,30,0.04),
        T("t56","Neon Dark",4,4,12,8,8,20,10,10,24,16,16,36,200,255,220,0.06),
        T("t57","Void",2,2,4,4,4,8,6,6,10,10,10,16,220,220,235,0.05),
        T("t58","Rust",22,12,8,28,16,12,32,18,14,44,26,18,255,238,225,0.07),
        T("t59","Wine",18,6,12,24,10,18,28,12,20,38,18,28,252,228,238,0.07),
        T("t60","Matrix",2,8,2,4,14,4,6,18,6,10,26,10,180,255,180,0.06),
    }

    local AccentList = {
        {Name="Purple",C1=Color3.fromRGB(130,100,255),C2=Color3.fromRGB(165,135,255)},
        {Name="Blue",C1=Color3.fromRGB(55,130,255),C2=Color3.fromRGB(100,168,255)},
        {Name="Cyan",C1=Color3.fromRGB(0,200,220),C2=Color3.fromRGB(55,228,248)},
        {Name="Green",C1=Color3.fromRGB(48,205,100),C2=Color3.fromRGB(95,232,148)},
        {Name="Pink",C1=Color3.fromRGB(255,78,158),C2=Color3.fromRGB(255,128,198)},
        {Name="Red",C1=Color3.fromRGB(255,68,68),C2=Color3.fromRGB(255,118,118)},
        {Name="Orange",C1=Color3.fromRGB(255,148,48),C2=Color3.fromRGB(255,188,98)},
        {Name="Mint",C1=Color3.fromRGB(0,210,178),C2=Color3.fromRGB(78,238,208)},
        {Name="Rose",C1=Color3.fromRGB(228,88,128),C2=Color3.fromRGB(248,138,168)},
        {Name="Gold",C1=Color3.fromRGB(255,198,48),C2=Color3.fromRGB(255,222,98)},
        {Name="Lavender",C1=Color3.fromRGB(178,128,255),C2=Color3.fromRGB(208,168,255)},
        {Name="Coral",C1=Color3.fromRGB(255,118,98),C2=Color3.fromRGB(255,158,138)},
    }

    local CurTheme = ThemeList[1]
    local CurAccent = AccentList[1]
    local C = {}
    local ThemeReg = {}
    local GradientReg = {}

    local function UpdC()
        for k,v in pairs(CurTheme) do if typeof(v)=="Color3" or type(v)=="number" then C[k]=v end end
        C.Accent=CurAccent.C1
        C.AccentGlow=CurAccent.C2
        C.AccentDim=Color3.fromRGB(math.floor(CurAccent.C1.R*255*0.55),math.floor(CurAccent.C1.G*255*0.55),math.floor(CurAccent.C1.B*255*0.55))
        C.AccentSoft=Color3.fromRGB(math.floor(CurAccent.C1.R*255*0.3+CurTheme.Card.R*255*0.7),math.floor(CurAccent.C1.G*255*0.3+CurTheme.Card.G*255*0.7),math.floor(CurAccent.C1.B*255*0.3+CurTheme.Card.B*255*0.7))
        C.TogOn=CurAccent.C1
        C.Knob=Color3.new(1,1,1)
    end
    UpdC()

    local function Reg(el,prop,key) table.insert(ThemeReg,{el=el,prop=prop,key=key}) end

    local function ApplyAll()
        UpdC()
        for _,r in ipairs(ThemeReg) do
            if r.el and r.el.Parent then
                local col = C[r.key]
                if col and typeof(col)=="Color3" then
                    pcall(function()
                        TweenService:Create(r.el,TweenInfo.new(0.5,Enum.EasingStyle.Quint),{[r.prop]=col}):Play()
                    end)
                end
            end
        end
        for _,g in ipairs(GradientReg) do
            if g.el and g.el.Parent and g.grad then
                pcall(function()
                    local c1 = CurTheme[g.k1] or C.Sidebar
                    local c2 = CurTheme[g.k2] or C.Bg
                    g.grad.Color = ColorSequence.new{ColorSequenceKeypoint.new(0,c1),ColorSequenceKeypoint.new(1,c2)}
                end)
            end
        end
    end

    local function Cn2(p,r) local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,r or 8);c.Parent=p;return c end
    local function St2(p,col,t,tr) local s=Instance.new("UIStroke");s.Color=col or C.Border;s.Thickness=t or 1;s.Transparency=tr or 0.6;s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border;s.Parent=p;return s end
    local function Pd2(p,t,b,l,r) local d=Instance.new("UIPadding");d.PaddingTop=UDim.new(0,t or 0);d.PaddingBottom=UDim.new(0,b or 0);d.PaddingLeft=UDim.new(0,l or 0);d.PaddingRight=UDim.new(0,r or 0);d.Parent=p;return d end
    local function Tw2(o,pr,d,s) return TweenService:Create(o,TweenInfo.new(d or 0.25,s or Enum.EasingStyle.Quint,Enum.EasingDirection.Out),pr):Play() end

    local function MakeGrad(parent,c1,c2,rot,k1,k2)
        local g=Instance.new("UIGradient")
        g.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,c1 or Color3.new(1,1,1)),ColorSequenceKeypoint.new(1,c2 or Color3.new(0,0,0))}
        g.Rotation=rot or 0
        g.Parent=parent
        if k1 and k2 then table.insert(GradientReg,{el=parent,grad=g,k1=k1,k2=k2}) end
        return g
    end

    local Gui = Instance.new("ScreenGui")
    Gui.Name = "NzGUI"
    Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    Gui.ResetOnSpawn = false
    Gui.IgnoreGuiInset = true
    Gui.Parent = game.CoreGui

    local Blur = Instance.new("BlurEffect")
    Blur.Name = "NzBlur"
    Blur.Size = 0
    Blur.Parent = Lighting

    local GUI_W, GUI_H, SB_W = 820, 500, 190

    local NCont = Instance.new("Frame")
    NCont.BackgroundTransparency = 1
    NCont.Position = UDim2.new(1,-16,1,-16)
    NCont.AnchorPoint = Vector2.new(1,1)
    NCont.Size = UDim2.new(0,280,0,400)
    NCont.ZIndex = 100
    NCont.Parent = Gui
    local nLay = Instance.new("UIListLayout")
    nLay.FillDirection = Enum.FillDirection.Vertical
    nLay.VerticalAlignment = Enum.VerticalAlignment.Bottom
    nLay.HorizontalAlignment = Enum.HorizontalAlignment.Right
    nLay.Padding = UDim.new(0,8)
    nLay.Parent = NCont

    local function Notify(title, msg, _, dur)
        local n = Instance.new("Frame")
        n.BackgroundColor3 = C.Card; n.BackgroundTransparency = 0.05; n.BorderSizePixel = 0
        n.Size = UDim2.new(0,0,0,58); n.AnchorPoint = Vector2.new(1,0); n.ClipsDescendants = true; n.ZIndex = 101; n.Parent = NCont
        Cn2(n,12); St2(n,C.Border,1,0.5)
        local bl = Instance.new("Frame")
        bl.BackgroundColor3 = C.Accent; bl.BackgroundTransparency = 0.75; bl.BorderSizePixel = 0
        bl.Position = UDim2.new(0,12,0.5,0); bl.AnchorPoint = Vector2.new(0,0.5); bl.Size = UDim2.new(0,36,0,36); bl.ZIndex = 102; bl.Parent = n; Cn2(bl,18)
        local tl = Instance.new("TextLabel")
        tl.BackgroundTransparency = 1; tl.Position = UDim2.new(0,58,0,8); tl.Size = UDim2.new(1,-68,0,18)
        tl.Font = Enum.Font.GothamBold; tl.Text = title; tl.TextColor3 = C.Text; tl.TextSize = 14
        tl.TextXAlignment = Enum.TextXAlignment.Left; tl.TextTransparency = 1; tl.ZIndex = 102; tl.Parent = n
        local ml = Instance.new("TextLabel")
        ml.BackgroundTransparency = 1; ml.Position = UDim2.new(0,58,0,28); ml.Size = UDim2.new(1,-68,0,22)
        ml.Font = Enum.Font.Gotham; ml.Text = msg; ml.TextColor3 = C.TextDim; ml.TextSize = 13
        ml.TextXAlignment = Enum.TextXAlignment.Left; ml.TextTransparency = 1; ml.ZIndex = 102; ml.Parent = n
        Tw2(n,{Size=UDim2.new(1,0,0,58)},0.4); task.wait(0.15)
        Tw2(tl,{TextTransparency=0},0.3); Tw2(ml,{TextTransparency=0.15},0.3)
        task.delay(dur or 2.5, function()
            if not n or not n.Parent then return end
            Tw2(tl,{TextTransparency=1},0.2); Tw2(ml,{TextTransparency=1},0.2); task.wait(0.15)
            Tw2(n,{Size=UDim2.new(0,0,0,58),BackgroundTransparency=1},0.35); task.wait(0.4)
            if n and n.Parent then n:Destroy() end
        end)
    end
    _G.NzNotify = Notify

    local BL = {}
    local function SB2(n, k, c) BL[n] = {key=k, cb=c} end
    _G.NzSetBind = SB2
    UserInputService.InputBegan:Connect(function(i, g)
        if g then return end
        if i.UserInputType == Enum.UserInputType.Keyboard then
            for _, d in pairs(BL) do
                if d.key == i.KeyCode and d.cb then d.cb() end
            end
        end
    end)

    local TooltipGui = Instance.new("ScreenGui")
    TooltipGui.Name = "NzTooltip"
    TooltipGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    TooltipGui.ResetOnSpawn = false
    TooltipGui.IgnoreGuiInset = true
    TooltipGui.Parent = game.CoreGui

    local TooltipFrame = Instance.new("Frame")
    TooltipFrame.BackgroundColor3 = Color3.fromRGB(10,10,16)
    TooltipFrame.BorderSizePixel = 0
    TooltipFrame.Size = UDim2.new(0,260,0,0)
    TooltipFrame.AutomaticSize = Enum.AutomaticSize.Y
    TooltipFrame.Visible = false
    TooltipFrame.ZIndex = 999
    TooltipFrame.Parent = TooltipGui
    Cn2(TooltipFrame, 8)
    St2(TooltipFrame, Color3.fromRGB(130,100,255), 1, 0.5)

    local tipTitle = Instance.new("TextLabel")
    tipTitle.BackgroundTransparency = 1
    tipTitle.Position = UDim2.new(0,12,0,8)
    tipTitle.Size = UDim2.new(1,-24,0,18)
    tipTitle.Font = Enum.Font.GothamBold
    tipTitle.Text = ""
    tipTitle.TextColor3 = Color3.fromRGB(218,165,32)
    tipTitle.TextSize = 13
    tipTitle.TextXAlignment = Enum.TextXAlignment.Left
    tipTitle.ZIndex = 1000
    tipTitle.Parent = TooltipFrame

    local tipDesc = Instance.new("TextLabel")
    tipDesc.BackgroundTransparency = 1
    tipDesc.Position = UDim2.new(0,12,0,30)
    tipDesc.Size = UDim2.new(1,-24,0,0)
    tipDesc.AutomaticSize = Enum.AutomaticSize.Y
    tipDesc.Font = Enum.Font.Gotham
    tipDesc.Text = ""
    tipDesc.TextColor3 = Color3.fromRGB(200,200,220)
    tipDesc.TextSize = 11
    tipDesc.TextXAlignment = Enum.TextXAlignment.Left
    tipDesc.TextYAlignment = Enum.TextYAlignment.Top
    tipDesc.TextWrapped = true
    tipDesc.ZIndex = 1000
    tipDesc.Parent = TooltipFrame

    local tipPad = Instance.new("UIPadding")
    tipPad.PaddingBottom = UDim.new(0,10)
    tipPad.Parent = TooltipFrame

    local function ShowTooltip(title, desc)
        tipTitle.Text = title
        tipDesc.Text = desc
        TooltipFrame.Visible = true
        local mouse = Player:GetMouse()
        TooltipFrame.Position = UDim2.new(0, mouse.X + 16, 0, mouse.Y + 16)
    end
    local function HideTooltip()
        TooltipFrame.Visible = false
    end
    local function UpdateTooltipPos()
        if TooltipFrame.Visible then
            local mouse = Player:GetMouse()
            TooltipFrame.Position = UDim2.new(0, mouse.X + 16, 0, mouse.Y + 16)
        end
    end
    UserInputService.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement then UpdateTooltipPos() end
    end)

    local Intro = Instance.new("Frame")
    Intro.BackgroundColor3 = Color3.fromRGB(4,4,8); Intro.Size = UDim2.new(1,0,1,0); Intro.ZIndex = 200; Intro.Parent = Gui
    local IC = Instance.new("Frame")
    IC.BackgroundTransparency = 1; IC.Position = UDim2.new(0.5,0,0.5,0); IC.AnchorPoint = Vector2.new(0.5,0.5); IC.Size = UDim2.new(0,300,0,160); IC.ZIndex = 201; IC.Parent = Intro
    local IL = Instance.new("Frame")
    IL.BackgroundColor3 = C.Accent; IL.Position = UDim2.new(0.5,0,0,10); IL.AnchorPoint = Vector2.new(0.5,0); IL.Size = UDim2.new(0,0,0,0); IL.Rotation = -20; IL.ZIndex = 202; IL.Parent = IC; Cn2(IL,10); MakeGrad(IL,C.Accent,C.AccentGlow,45)
    local IT = Instance.new("TextLabel")
    IT.BackgroundTransparency = 1; IT.Position = UDim2.new(0.5,0,0,68); IT.AnchorPoint = Vector2.new(0.5,0); IT.Size = UDim2.new(1,0,0,36); IT.Font = Enum.Font.GothamBold; IT.Text = "Nz"; IT.TextColor3 = Color3.new(1,1,1); IT.TextTransparency = 1; IT.TextSize = 34; IT.ZIndex = 202; IT.Parent = IC
    local IS = Instance.new("TextLabel")
    IS.BackgroundTransparency = 1; IS.Position = UDim2.new(0.5,0,0,108); IS.AnchorPoint = Vector2.new(0.5,0); IS.Size = UDim2.new(1,0,0,18); IS.Font = Enum.Font.Gotham; IS.Text = ""; IS.TextColor3 = Color3.fromRGB(140,140,170); IS.TextTransparency = 1; IS.TextSize = 14; IS.ZIndex = 202; IS.Parent = IC
    local IB = Instance.new("Frame")
    IB.BackgroundColor3 = Color3.fromRGB(40,40,60); IB.BackgroundTransparency = 0.5; IB.BorderSizePixel = 0; IB.Position = UDim2.new(0.5,0,0,135); IB.AnchorPoint = Vector2.new(0.5,0); IB.Size = UDim2.new(0,220,0,3); IB.ZIndex = 202; IB.Parent = IC; Cn2(IB,2)
    local IFl = Instance.new("Frame")
    IFl.BackgroundColor3 = C.Accent; IFl.BorderSizePixel = 0; IFl.Size = UDim2.new(0,0,1,0); IFl.ZIndex = 203; IFl.Parent = IB; Cn2(IFl,2); MakeGrad(IFl,C.Accent,C.AccentGlow,0)

    task.wait(0.2); Tw2(IL,{Size=UDim2.new(0,52,0,52)},0.5,Enum.EasingStyle.Back); task.wait(0.35); Tw2(IT,{TextTransparency=0},0.5); task.wait(0.2)
    IS.Text = L().loading; Tw2(IS,{TextTransparency=0},0.3); task.wait(0.15); Tw2(IFl,{Size=UDim2.new(0.4,0,1,0)},0.4); task.wait(0.3)
    IS.Text = L().themes_ready; Tw2(IFl,{Size=UDim2.new(0.75,0,1,0)},0.35); task.wait(0.3)
    IS.Text = L().done; Tw2(IFl,{Size=UDim2.new(1,0,1,0)},0.25); task.wait(0.4)
    Tw2(IL,{BackgroundTransparency=1,Size=UDim2.new(0,70,0,70)},0.4); Tw2(IT,{TextTransparency=1},0.35); Tw2(IS,{TextTransparency=1},0.3); Tw2(IB,{BackgroundTransparency=1},0.3); Tw2(IFl,{BackgroundTransparency=1},0.3)
    task.wait(0.25); Tw2(Intro,{BackgroundTransparency=1},0.45); task.wait(0.5); Intro:Destroy()

    local Main = Instance.new("Frame")
    Main.Name = "Main"; Main.BackgroundColor3 = C.Bg; Main.BackgroundTransparency = 1; Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.5,0,0.5,0); Main.AnchorPoint = Vector2.new(0.5,0.5); Main.Size = UDim2.new(0,0,0,0)
    Main.ClipsDescendants = true; Main.Parent = Gui; Cn2(Main,14)
    local mS = St2(Main, C.Border, 1.5, 0.35)
    Reg(Main,"BackgroundColor3","Bg"); Reg(mS,"Color","Border")

    local RH = Instance.new("TextButton")
    RH.BackgroundTransparency = 1; RH.Position = UDim2.new(1,-20,1,-20); RH.Size = UDim2.new(0,20,0,20); RH.Text = ""; RH.ZIndex = 20; RH.Parent = Main
    for _, p in ipairs({{1,-4,1,-4},{1,-4,1,-11},{1,-11,1,-4}}) do
        local d = Instance.new("Frame"); d.BackgroundColor3 = C.TextDark; d.BorderSizePixel = 0
        d.Position = UDim2.new(p[1],p[2],p[3],p[4]); d.AnchorPoint = Vector2.new(1,1)
        d.Size = UDim2.new(0,3,0,3); d.ZIndex = 21; d.Parent = RH; Cn2(d,100)
    end
    local rsz, rsI, rsS = false, nil, nil
    RH.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            rsz = true; rsI = i.Position; rsS = Main.Size
            i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then rsz = false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if rsz and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - rsI
            GUI_W = math.clamp(rsS.X.Offset+d.X, 600, 1300); GUI_H = math.clamp(rsS.Y.Offset+d.Y, 350, 800)
            Main.Size = UDim2.new(0,GUI_W,0,GUI_H)
        end
    end)

    local SB = Instance.new("Frame")
    SB.BackgroundColor3 = C.Sidebar; SB.BackgroundTransparency = 0.02; SB.BorderSizePixel = 0
    SB.Size = UDim2.new(0,SB_W,1,0); SB.ZIndex = 5; SB.Parent = Main; Cn2(SB,14)
    Reg(SB,"BackgroundColor3","Sidebar")
    MakeGrad(SB,CurTheme.Grad1,CurTheme.Grad2,180,"Grad1","Grad2")

    local SBMask2 = Instance.new("Frame")
    SBMask2.BackgroundColor3 = C.Sidebar; SBMask2.BackgroundTransparency = 0.02; SBMask2.BorderSizePixel = 0
    SBMask2.Position = UDim2.new(1,-14,0,0); SBMask2.Size = UDim2.new(0,14,1,0); SBMask2.ZIndex = 4; SBMask2.Parent = SB
    Reg(SBMask2,"BackgroundColor3","Sidebar")
    MakeGrad(SBMask2,CurTheme.Grad1,CurTheme.Grad2,180,"Grad1","Grad2")

    local SBDv = Instance.new("Frame")
    SBDv.BackgroundColor3 = C.Divider; SBDv.BackgroundTransparency = 0.3; SBDv.BorderSizePixel = 0
    SBDv.Position = UDim2.new(1,0,0,10); SBDv.Size = UDim2.new(0,1,1,-20); SBDv.ZIndex = 6; SBDv.Parent = SB
    Reg(SBDv,"BackgroundColor3","Divider")

    local LF = Instance.new("Frame"); LF.BackgroundTransparency = 1; LF.Size = UDim2.new(1,0,0,66); LF.ZIndex = 6; LF.Parent = SB
    local LI = Instance.new("Frame")
    LI.BackgroundColor3 = C.Accent; LI.Position = UDim2.new(0,14,0,16); LI.Size = UDim2.new(0,32,0,32); LI.Rotation = -20; LI.ZIndex = 7; LI.Parent = LF; Cn2(LI,8)
    Reg(LI,"BackgroundColor3","Accent"); MakeGrad(LI,C.Accent,C.AccentGlow,45)
    local LT = Instance.new("TextLabel")
    LT.BackgroundTransparency = 1; LT.Position = UDim2.new(0,54,0,14); LT.Size = UDim2.new(1,-62,0,22)
    LT.Font = Enum.Font.GothamBold; LT.Text = "Nz"; LT.TextColor3 = C.Text; LT.TextSize = 20
    LT.TextXAlignment = Enum.TextXAlignment.Left; LT.ZIndex = 7; LT.Parent = LF; Reg(LT,"TextColor3","Text")
    local LV = Instance.new("TextLabel")
    LV.BackgroundTransparency = 1; LV.Position = UDim2.new(0,54,0,36); LV.Size = UDim2.new(1,-62,0,16)
    LV.Font = Enum.Font.Gotham; LV.Text = KEY_CONFIG.VERSION; LV.TextColor3 = C.AccentDim; LV.TextSize = 12
    LV.TextXAlignment = Enum.TextXAlignment.Left; LV.ZIndex = 7; LV.Parent = LF; Reg(LV,"TextColor3","AccentDim")
    local LD = Instance.new("Frame")
    LD.BackgroundColor3 = C.Divider; LD.BackgroundTransparency = 0.3; LD.BorderSizePixel = 0
    LD.Position = UDim2.new(0,12,1,-1); LD.Size = UDim2.new(1,-24,0,1); LD.ZIndex = 7; LD.Parent = LF; Reg(LD,"BackgroundColor3","Divider")

    local TabsScroll = Instance.new("ScrollingFrame")
    TabsScroll.BackgroundTransparency = 1
    TabsScroll.BorderSizePixel = 0
    TabsScroll.Position = UDim2.new(0,0,0,72)
    TabsScroll.Size = UDim2.new(1,0,1,-130)
    TabsScroll.CanvasSize = UDim2.new(0,0,0,0)
    TabsScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabsScroll.ScrollBarThickness = 2
    TabsScroll.ScrollBarImageColor3 = C.Accent
    TabsScroll.ScrollBarImageTransparency = 0.5
    TabsScroll.ZIndex = 6
    TabsScroll.Parent = SB
    local TCL = Instance.new("UIListLayout")
    TCL.Padding = UDim.new(0,3); TCL.HorizontalAlignment = Enum.HorizontalAlignment.Center; TCL.SortOrder = Enum.SortOrder.LayoutOrder; TCL.Parent = TabsScroll
    Pd2(TabsScroll,2,2,10,10)

    local Tabs = {
        {Name="cat_vehicle",  Ic="🚗", Implemented=true},
        {Name="cat_player",   Ic="👤", Implemented=true},
        {Name="cat_criminal", Ic="💰", Implemented=false},
        {Name="cat_cop",      Ic="🚔", Implemented=false},
        {Name="cat_visuals",  Ic="👁", Implemented=false},
        {Name="cat_utility",  Ic="🛠", Implemented=false},
        {Name="cat_overlay",  Ic="//", Implemented=true},
        {Name="cat_themes",   Ic="::", Implemented=true},
        {Name="cat_settings", Ic="⚙", Implemented=true}
    }
    local TBtns, TPages, ActiveTab = {}, {}, nil

    local PF = Instance.new("Frame")
    PF.BackgroundTransparency = 1; PF.Position = UDim2.new(0,0,1,-56); PF.Size = UDim2.new(1,0,0,56); PF.ZIndex = 6; PF.Parent = SB
    local PFD = Instance.new("Frame")
    PFD.BackgroundColor3 = C.Divider; PFD.BackgroundTransparency = 0.3; PFD.BorderSizePixel = 0
    PFD.Position = UDim2.new(0,12,0,0); PFD.Size = UDim2.new(1,-24,0,1); PFD.ZIndex = 7; PFD.Parent = PF; Reg(PFD,"BackgroundColor3","Divider")
    local PA = Instance.new("ImageLabel")
    PA.BackgroundColor3 = C.Card; PA.Position = UDim2.new(0,12,0,12); PA.Size = UDim2.new(0,32,0,32); PA.ZIndex = 7; PA.Parent = PF; Cn2(PA,16)
    pcall(function() PA.Image = Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48) end)
    local PN = Instance.new("TextLabel")
    PN.BackgroundTransparency = 1; PN.Position = UDim2.new(0,50,0,12); PN.Size = UDim2.new(1,-58,0,18)
    PN.Font = Enum.Font.GothamMedium; PN.Text = Player.Name; PN.TextColor3 = C.Text; PN.TextSize = 13
    PN.TextXAlignment = Enum.TextXAlignment.Left; PN.ZIndex = 7; PN.Parent = PF; Reg(PN,"TextColor3","Text")
    local PSb = Instance.new("TextLabel")
    PSb.BackgroundTransparency = 1; PSb.Position = UDim2.new(0,50,0,30); PSb.Size = UDim2.new(1,-58,0,16)
    PSb.Font = Enum.Font.Gotham; PSb.Text = L().premium; PSb.TextColor3 = C.AccentDim; PSb.TextSize = 11
    PSb.TextXAlignment = Enum.TextXAlignment.Left; PSb.ZIndex = 7; PSb.Parent = PF; Reg(PSb,"TextColor3","AccentDim")

    local TB2 = Instance.new("Frame")
    TB2.BackgroundColor3 = C.TopBar; TB2.BackgroundTransparency = 0.05; TB2.BorderSizePixel = 0
    TB2.Position = UDim2.new(0,SB_W,0,0); TB2.Size = UDim2.new(1,-SB_W,0,48); TB2.ZIndex = 8; TB2.Parent = Main
    Cn2(TB2,14)
    Reg(TB2,"BackgroundColor3","TopBar")
    MakeGrad(TB2,CurTheme.TBGrad1,CurTheme.TBGrad2,90,"TBGrad1","TBGrad2")

    local TB2MaskBot = Instance.new("Frame")
    TB2MaskBot.BackgroundColor3 = C.TopBar; TB2MaskBot.BackgroundTransparency = 0.05; TB2MaskBot.BorderSizePixel = 0
    TB2MaskBot.Position = UDim2.new(0,0,1,-14); TB2MaskBot.Size = UDim2.new(1,0,0,14); TB2MaskBot.ZIndex = 8; TB2MaskBot.Parent = TB2
    Reg(TB2MaskBot,"BackgroundColor3","TopBar")
    MakeGrad(TB2MaskBot,CurTheme.TBGrad1,CurTheme.TBGrad2,90,"TBGrad1","TBGrad2")

    local TB2MaskLeft = Instance.new("Frame")
    TB2MaskLeft.BackgroundColor3 = C.TopBar; TB2MaskLeft.BackgroundTransparency = 0.05; TB2MaskLeft.BorderSizePixel = 0
    TB2MaskLeft.Position = UDim2.new(0,0,0,0); TB2MaskLeft.Size = UDim2.new(0,14,0,34); TB2MaskLeft.ZIndex = 8; TB2MaskLeft.Parent = TB2
    Reg(TB2MaskLeft,"BackgroundColor3","TopBar")
    MakeGrad(TB2MaskLeft,CurTheme.TBGrad1,CurTheme.TBGrad2,90,"TBGrad1","TBGrad2")

    local TS = Instance.new("ScrollingFrame")
    TS.BackgroundTransparency = 1; TS.Position = UDim2.new(0,15,0,0); TS.Size = UDim2.new(1,-30,1,0)
    TS.CanvasSize = UDim2.new(0,0,0,0); TS.AutomaticCanvasSize = Enum.AutomaticSize.X
    TS.ScrollBarThickness = 0; TS.ScrollingDirection = Enum.ScrollingDirection.X
    TS.ZIndex = 9; TS.ClipsDescendants = true; TS.Parent = TB2
    local tsL = Instance.new("UIListLayout")
    tsL.FillDirection = Enum.FillDirection.Horizontal; tsL.VerticalAlignment = Enum.VerticalAlignment.Center
    tsL.Padding = UDim.new(0,6); tsL.SortOrder = Enum.SortOrder.LayoutOrder; tsL.Parent = TS

    local TBDv = Instance.new("Frame")
    TBDv.BackgroundColor3 = C.Divider; TBDv.BackgroundTransparency = 0.3; TBDv.BorderSizePixel = 0
    TBDv.Position = UDim2.new(0,SB_W,0,48); TBDv.Size = UDim2.new(1,-SB_W,0,1); TBDv.ZIndex = 9; TBDv.Parent = Main
    Reg(TBDv,"BackgroundColor3","Divider")

    local Co = Instance.new("Frame")
    Co.BackgroundTransparency = 1
    Co.Position = UDim2.new(0,SB_W+10,0,55)
    Co.Size = UDim2.new(1,-SB_W-20,1,-65)
    Co.ZIndex = 3; Co.ClipsDescendants = true; Co.Parent = Main

    local dr2, dI2, dS2, sP2
    local function SDD2(i) dr2=true; dS2=i.Position; sP2=Main.Position; i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dr2=false end end) end
    TB2.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then SDD2(i) end end)
    TB2.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement then dI2=i end end)
    SB.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then SDD2(i) end end)
    SB.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement then dI2=i end end)
    UserInputService.InputChanged:Connect(function(i)
        if i == dI2 and dr2 then
            local d = i.Position - dS2
            Tw2(Main,{Position=UDim2.new(sP2.X.Scale,sP2.X.Offset+d.X,sP2.Y.Scale,sP2.Y.Offset+d.Y)},0.06)
        end
    end)

    local TE = {}
    local function AT(n)
        if TE[n] then return end
        local t = Instance.new("Frame")
        t.BackgroundColor3 = C.AccentSoft; t.BackgroundTransparency = 0.2; t.BorderSizePixel = 0
        t.Size = UDim2.new(0,0,0,30); t.ZIndex = 10; t.ClipsDescendants = true; t.Parent = TS; Cn2(t,7)
        local d = Instance.new("Frame")
        d.BackgroundColor3 = C.Accent; d.BorderSizePixel = 0; d.Size = UDim2.new(0,6,0,6)
        d.Position = UDim2.new(0,10,0.5,0); d.AnchorPoint = Vector2.new(0,0.5); d.ZIndex = 11; d.Parent = t; Cn2(d,100)
        local tx = Instance.new("TextLabel")
        tx.BackgroundTransparency = 1; tx.Position = UDim2.new(0,20,0,0); tx.Size = UDim2.new(1,-26,1,0)
        tx.Font = Enum.Font.GothamMedium; tx.Text = n; tx.TextColor3 = C.AccentGlow; tx.TextSize = 12; tx.ZIndex = 11; tx.Parent = t
        local w = TextService:GetTextSize(n,12,Enum.Font.GothamMedium,Vector2.new(1000,30))
        Tw2(t,{Size=UDim2.new(0,w.X+30,0,30)},0.3)
        TE[n] = t
    end
    local function RT(n)
        if not TE[n] then return end
        Tw2(TE[n],{Size=UDim2.new(0,0,0,30)},0.25)
        task.delay(0.3, function() if TE[n] and TE[n].Parent then TE[n]:Destroy() end end)
        TE[n] = nil
    end
    _G.NzAddTag = AT
    _G.NzRemoveTag = RT

    local function MP(n)
        local s = Instance.new("ScrollingFrame")
        s.Name = n; s.BackgroundTransparency = 1; s.BorderSizePixel = 0
        s.Size = UDim2.new(1,0,1,0); s.CanvasSize = UDim2.new(0,0,0,0)
        s.AutomaticCanvasSize = Enum.AutomaticSize.Y; s.ScrollBarThickness = 4
        s.ScrollBarImageColor3 = C.Accent; s.ScrollBarImageTransparency = 0.5
        s.ScrollingDirection = Enum.ScrollingDirection.Y; s.ZIndex = 4
        s.Visible = false; s.ClipsDescendants = true; s.Parent = Co
        local l = Instance.new("UIListLayout")
        l.Padding = UDim.new(0,14)
        l.HorizontalAlignment = Enum.HorizontalAlignment.Center
        l.SortOrder = Enum.SortOrder.LayoutOrder; l.Parent = s
        Pd2(s,15,15,10,15)
        return s
    end

    local function STT(n)
        if ActiveTab == n then return end
        ActiveTab = n
        for nn, p in pairs(TPages) do p.Visible = (nn == n) end
        for nn, b in pairs(TBtns) do
            local a = (nn == n)
            Tw2(b,{BackgroundColor3=a and C.AccentSoft or C.Sidebar, BackgroundTransparency=a and 0.15 or 1},0.2)
            local lb = b:FindFirstChild("L"); if lb then Tw2(lb,{TextColor3=a and C.Text or C.TextDim},0.2) end
            local ic = b:FindFirstChild("I"); if ic then Tw2(ic,{TextColor3=a and C.Accent or C.TextDim},0.2) end
            local ln = b:FindFirstChild("Ln"); if ln then Tw2(ln,{BackgroundTransparency=a and 0 or 1},0.2) end
        end
    end

    local tabBtnsRefs = {}
    for i, td in ipairs(Tabs) do
        local b = Instance.new("TextButton")
        b.Name = td.Name; b.BackgroundColor3 = C.Sidebar; b.BackgroundTransparency = 1; b.BorderSizePixel = 0
        b.Size = UDim2.new(1,0,0,38); b.Text = ""; b.ZIndex = 7; b.AutoButtonColor = false; b.LayoutOrder = i; b.Parent = TabsScroll; Cn2(b,8)
        local ln = Instance.new("Frame")
        ln.Name = "Ln"; ln.BackgroundColor3 = C.Accent; ln.BackgroundTransparency = 1; ln.BorderSizePixel = 0
        ln.Position = UDim2.new(0,0,0.15,0); ln.Size = UDim2.new(0,3,0.7,0); ln.ZIndex = 8; ln.Parent = b; Cn2(ln,2)
        Reg(ln,"BackgroundColor3","Accent")
        local ic = Instance.new("TextLabel")
        ic.Name = "I"; ic.BackgroundTransparency = 1; ic.Position = UDim2.new(0,14,0,0); ic.Size = UDim2.new(0,22,1,0)
        ic.Font = Enum.Font.GothamBold; ic.Text = td.Ic; ic.TextColor3 = C.TextDim; ic.TextSize = 16; ic.ZIndex = 8; ic.Parent = b
        local lb = Instance.new("TextLabel")
        lb.Name = "L"; lb.BackgroundTransparency = 1; lb.Position = UDim2.new(0,42,0,0); lb.Size = UDim2.new(1,-48,1,0)
        lb.Font = Enum.Font.GothamMedium; lb.Text = L()[td.Name] or td.Name; lb.TextColor3 = C.TextDim; lb.TextSize = 13
        lb.TextXAlignment = Enum.TextXAlignment.Left; lb.ZIndex = 8; lb.Parent = b
        b.MouseEnter:Connect(function() sndHover(); if ActiveTab~=td.Name then Tw2(b,{BackgroundTransparency=0.5},0.12) end end)
        b.MouseLeave:Connect(function() if ActiveTab~=td.Name then Tw2(b,{BackgroundTransparency=1},0.12) end end)
        b.MouseButton1Click:Connect(function() sndClick(); STT(td.Name) end)
        TBtns[td.Name] = b; TPages[td.Name] = MP(td.Name)
        tabBtnsRefs[td.Name] = {btn=b, lb=lb, data=td}
    end

    local function makeComingSoonPage(page, catName)
        local cs = Instance.new("Frame")
        cs.BackgroundTransparency = 1
        cs.Size = UDim2.new(1,-20,1,-40)
        cs.ZIndex = 5
        cs.Parent = page
        local csIcon = Instance.new("TextLabel")
        csIcon.BackgroundTransparency = 1
        csIcon.Position = UDim2.new(0.5,0,0.35,0)
        csIcon.AnchorPoint = Vector2.new(0.5,0.5)
        csIcon.Size = UDim2.new(0,80,0,80)
        csIcon.Font = Enum.Font.GothamBold
        csIcon.Text = "⏳"
        csIcon.TextColor3 = C.Accent
        csIcon.TextSize = 60
        csIcon.ZIndex = 6
        csIcon.Parent = cs
        Reg(csIcon,"TextColor3","Accent")
        local csTitle = Instance.new("TextLabel")
        csTitle.BackgroundTransparency = 1
        csTitle.Position = UDim2.new(0.5,0,0.5,0)
        csTitle.AnchorPoint = Vector2.new(0.5,0.5)
        csTitle.Size = UDim2.new(1,0,0,30)
        csTitle.Font = Enum.Font.GothamBold
        csTitle.Text = L().coming_soon
        csTitle.TextColor3 = C.Text
        csTitle.TextSize = 22
        csTitle.ZIndex = 6
        csTitle.Parent = cs
        Reg(csTitle,"TextColor3","Text")
        local csSub = Instance.new("TextLabel")
        csSub.BackgroundTransparency = 1
        csSub.Position = UDim2.new(0.5,0,0.58,0)
        csSub.AnchorPoint = Vector2.new(0.5,0.5)
        csSub.Size = UDim2.new(1,-40,0,40)
        csSub.Font = Enum.Font.Gotham
        csSub.Text = "We are working hard on this category. Stay tuned!"
        csSub.TextColor3 = C.TextDim
        csSub.TextSize = 13
        csSub.TextWrapped = true
        csSub.ZIndex = 6
        csSub.Parent = cs
        Reg(csSub,"TextColor3","TextDim")
    end

    for _, td in ipairs(Tabs) do
        if not td.Implemented then
            makeComingSoonPage(TPages[td.Name], td.Name)
        end
    end

    _G.NzPages = TPages
    _G.NzColors = C
    _G.NzCn = Cn2
    _G.NzSt = St2
    _G.NzPd = Pd2
    _G.NzTw = Tw2
    _G.NzMakeGrad = MakeGrad
    _G.NzReg = Reg
    _G.NzShowTooltip = ShowTooltip
    _G.NzHideTooltip = HideTooltip
    _G.NzGui = Gui
    _G.NzBlur = Blur
    _G.NzMain = Main
    _G.NzApplyAll = ApplyAll
    _G.NzCurTheme = function() return CurTheme end
    _G.NzCurAccent = function() return CurAccent end
    _G.NzSetTheme = function(t) CurTheme = t; ApplyAll() end
    _G.NzSetAccent = function(a) CurAccent = a; ApplyAll() end
    _G.NzThemeList = ThemeList
    _G.NzAccentList = AccentList
    _G.NzTabBtnsRefs = tabBtnsRefs

    _G.NzUpdateLangTexts = function()
        local LL = L()
        for name, ref in pairs(tabBtnsRefs) do
            if ref.lb then ref.lb.Text = LL[name] or name end
        end
        PSb.Text = LL.premium
    end

    task.wait(0.1)
    Tw2(Main, {Size=UDim2.new(0,GUI_W,0,GUI_H), BackgroundTransparency=CurTheme.Trans}, 0.55, Enum.EasingStyle.Back)
    Blur.Size = 5
    task.wait(0.4)
    STT("cat_vehicle")
    task.wait(0.3)
    Notify("Nz", L().notif_loaded, nil, 3)

    _G.NzGUI_W = function() return GUI_W end
    _G.NzGUI_H = function() return GUI_H end
end

local function loadAllFeatures()
    local C = _G.NzColors
    local Pages = _G.NzPages
    local Cn3 = _G.NzCn
    local St3 = _G.NzSt
    local Pd3 = _G.NzPd
    local Tw3 = _G.NzTw
    local Reg3 = _G.NzReg
    local MakeGrad = _G.NzMakeGrad
    local Notify = _G.NzNotify
    local AT = _G.NzAddTag
    local RT = _G.NzRemoveTag
    local ShowTooltip = _G.NzShowTooltip
    local HideTooltip = _G.NzHideTooltip
    local SB2 = _G.NzSetBind

    local SC = {}
    
    function SC.Slider(p, n, mn, mx, df, u, cb)
        local c = Instance.new("Frame"); c.BackgroundColor3=C.Card; c.BackgroundTransparency=0.3; c.BorderSizePixel=0
        c.Size = UDim2.new(1,0,0,54); c.ZIndex=82; c.Parent=p; Cn3(c,8)
        local l = Instance.new("TextLabel"); l.BackgroundTransparency=1; l.Position=UDim2.new(0,12,0,5); l.Size=UDim2.new(0.55,-12,0,20)
        l.Font=Enum.Font.GothamMedium; l.Text=n; l.TextColor3=C.Text; l.TextSize=13; l.TextXAlignment=Enum.TextXAlignment.Left; l.ZIndex=83; l.Parent=c
        local v = Instance.new("TextLabel"); v.BackgroundTransparency=1; v.Position=UDim2.new(0.55,0,0,5); v.Size=UDim2.new(0.45,-12,0,20)
        v.Font=Enum.Font.GothamBold; v.Text=df..(u or ""); v.TextColor3=C.AccentGlow; v.TextSize=13; v.TextXAlignment=Enum.TextXAlignment.Right; v.ZIndex=83; v.Parent=c
        local bg = Instance.new("Frame"); bg.BackgroundColor3=C.SliderBg; bg.BorderSizePixel=0; bg.Position=UDim2.new(0,12,0,32); bg.Size=UDim2.new(1,-24,0,7); bg.ZIndex=84; bg.Parent=c; Cn3(bg,3)
        local fl = Instance.new("Frame"); fl.BackgroundColor3=C.Accent; fl.BorderSizePixel=0; fl.Size=UDim2.new((df-mn)/(mx-mn),0,1,0); fl.ZIndex=85; fl.Parent=bg; Cn3(fl,3); MakeGrad(fl,C.Accent,C.AccentGlow,0)
        local kn = Instance.new("Frame"); kn.BackgroundColor3=C.Knob; kn.BorderSizePixel=0; kn.Size=UDim2.new(0,14,0,14); kn.Position=UDim2.new(1,0,0.5,0); kn.AnchorPoint=Vector2.new(0.5,0.5); kn.ZIndex=86; kn.Parent=fl; Cn3(kn,100); St3(kn,C.Accent,2,0)
        local sb = Instance.new("TextButton"); sb.BackgroundTransparency=1; sb.Size=UDim2.new(1,0,1,16); sb.Position=UDim2.new(0,0,0.5,0); sb.AnchorPoint=Vector2.new(0,0.5); sb.Text=""; sb.ZIndex=87; sb.Parent=bg
        local sl = false
        local function up(i) local pp=math.clamp((i.Position.X-bg.AbsolutePosition.X)/bg.AbsoluteSize.X,0,1); local cv=math.floor(mn+(mx-mn)*pp); v.Text=cv..(u or ""); Tw3(fl,{Size=UDim2.new(pp,0,1,0)},0.06); if cb then cb(cv) end end
        sb.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then sl=true; up(i) end end)
        UserInputService.InputChanged:Connect(function(i) if sl and i.UserInputType==Enum.UserInputType.MouseMovement then up(i) end end)
        UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then sl=false end end)
    end

    function SC.Toggle(p, n, df, cb)
        local c = Instance.new("Frame"); c.BackgroundColor3=C.Card; c.BackgroundTransparency=0.3; c.BorderSizePixel=0; c.Size=UDim2.new(1,0,0,40); c.ZIndex=82; c.Parent=p; Cn3(c,8)
        local l = Instance.new("TextLabel"); l.BackgroundTransparency=1; l.Position=UDim2.new(0,12,0,0); l.Size=UDim2.new(1,-60,1,0)
        l.Font=Enum.Font.GothamMedium; l.Text=n; l.TextColor3=C.Text; l.TextSize=13; l.TextXAlignment=Enum.TextXAlignment.Left; l.ZIndex=83; l.Parent=c
        local tb = Instance.new("Frame"); tb.BackgroundColor3=df and C.TogOn or C.TogOff; tb.BorderSizePixel=0; tb.Position=UDim2.new(1,-48,0.5,0); tb.AnchorPoint=Vector2.new(0,0.5); tb.Size=UDim2.new(0,36,0,20); tb.ZIndex=84; tb.Parent=c; Cn3(tb,10)
        local cr = Instance.new("Frame"); cr.BackgroundColor3=C.Knob; cr.BorderSizePixel=0; cr.Size=UDim2.new(0,14,0,14); cr.Position=df and UDim2.new(1,-17,0.5,0) or UDim2.new(0,3,0.5,0); cr.AnchorPoint=Vector2.new(0,0.5); cr.ZIndex=85; cr.Parent=tb; Cn3(cr,100)
        local on = df or false
        local bt = Instance.new("TextButton"); bt.BackgroundTransparency=1; bt.Size=UDim2.new(1,0,1,0); bt.Text=""; bt.ZIndex=86; bt.Parent=c
        bt.MouseButton1Click:Connect(function() on=not on; sndClick(); Tw3(tb,{BackgroundColor3=on and C.TogOn or C.TogOff},0.2); Tw3(cr,{Position=on and UDim2.new(1,-17,0.5,0) or UDim2.new(0,3,0.5,0)},0.2); if cb then cb(on) end end)
    end

    function SC.Label(p, t)
        local l = Instance.new("TextLabel"); l.BackgroundTransparency=1; l.Size=UDim2.new(1,0,0,18)
        l.Font=Enum.Font.GothamBold; l.Text=t; l.TextColor3=C.TextDim; l.TextSize=12; l.TextXAlignment=Enum.TextXAlignment.Left; l.ZIndex=82; l.Parent=p
    end

    function SC.Input(p, n, df, cb)
        local c = Instance.new("Frame"); c.BackgroundColor3=C.Card; c.BackgroundTransparency=0.3; c.BorderSizePixel=0; c.Size=UDim2.new(1,0,0,40); c.ZIndex=82; c.Parent=p; Cn3(c,8)
        local l = Instance.new("TextLabel"); l.BackgroundTransparency=1; l.Position=UDim2.new(0,12,0,0); l.Size=UDim2.new(0.4,0,1,0)
        l.Font=Enum.Font.GothamMedium; l.Text=n; l.TextColor3=C.Text; l.TextSize=13; l.TextXAlignment=Enum.TextXAlignment.Left; l.ZIndex=83; l.Parent=c
        local inp = Instance.new("TextBox"); inp.BackgroundColor3=C.SliderBg; inp.BorderSizePixel=0; inp.Position=UDim2.new(0.45,0,0.5,0); inp.AnchorPoint=Vector2.new(0,0.5); inp.Size=UDim2.new(0.5,-12,0,26)
        inp.Font=Enum.Font.GothamMedium; inp.Text=tostring(df); inp.TextColor3=C.Text; inp.TextSize=12; inp.ClearTextOnFocus=false; inp.ZIndex=84; inp.Parent=c; Cn3(inp,6)
        inp.FocusLost:Connect(function() if cb then cb(inp.Text) end end)
    end

    local SW = Instance.new("Frame")
    SW.BackgroundColor3 = C.SettBg; SW.BackgroundTransparency = 0.04; SW.BorderSizePixel = 0
    SW.Position = UDim2.new(0.5,0,0.5,0); SW.AnchorPoint = Vector2.new(0.5,0.5); SW.Size = UDim2.new(0,0,0,0)
    SW.ZIndex = 80; SW.ClipsDescendants = true; SW.Visible = false; SW.Parent = _G.NzGui; Cn3(SW,12)
    St3(SW, C.Border, 1.5, 0.35); Reg3(SW,"BackgroundColor3","SettBg")

    local SWT = Instance.new("TextLabel")
    SWT.BackgroundTransparency = 1; SWT.Position = UDim2.new(0,16,0,0); SWT.Size = UDim2.new(1,-56,0,46)
    SWT.Font = Enum.Font.GothamBold; SWT.Text = "Settings"; SWT.TextColor3 = C.Text; SWT.TextSize = 16
    SWT.TextXAlignment = Enum.TextXAlignment.Left; SWT.ZIndex = 81; SWT.Parent = SW; Reg3(SWT,"TextColor3","Text")

    local SWX = Instance.new("TextButton")
    SWX.BackgroundColor3 = C.Card; SWX.BackgroundTransparency = 0.3; SWX.BorderSizePixel = 0
    SWX.Position = UDim2.new(1,-40,0,8); SWX.Size = UDim2.new(0,30,0,30)
    SWX.Font = Enum.Font.GothamBold; SWX.Text = "x"; SWX.TextColor3 = Color3.fromRGB(255,80,80); SWX.TextSize = 18
    SWX.ZIndex = 82; SWX.AutoButtonColor = false; SWX.Parent = SW; Cn3(SWX,8)

    local SWD = Instance.new("Frame")
    SWD.BackgroundColor3 = C.Divider; SWD.BackgroundTransparency = 0.3; SWD.BorderSizePixel = 0
    SWD.Position = UDim2.new(0,10,0,46); SWD.Size = UDim2.new(1,-20,0,1); SWD.ZIndex = 81; SWD.Parent = SW

    local SWC = Instance.new("ScrollingFrame")
    SWC.BackgroundTransparency = 1; SWC.Position = UDim2.new(0,0,0,50); SWC.Size = UDim2.new(1,0,1,-50)
    SWC.CanvasSize = UDim2.new(0,0,0,0); SWC.AutomaticCanvasSize = Enum.AutomaticSize.Y
    SWC.ScrollBarThickness = 2; SWC.ScrollBarImageColor3 = C.Accent; SWC.ZIndex = 81; SWC.ClipsDescendants = true; SWC.Parent = SW
    local swcL = Instance.new("UIListLayout"); swcL.Padding = UDim.new(0,6); swcL.HorizontalAlignment = Enum.HorizontalAlignment.Center; swcL.SortOrder = Enum.SortOrder.LayoutOrder; swcL.Parent = SWC
    Pd3(SWC,8,8,12,12)

    local sO = false
    local function OS(n, b)
        for _, ch in ipairs(SWC:GetChildren()) do
            if not ch:IsA("UIListLayout") and not ch:IsA("UIPadding") then ch:Destroy() end
        end
        SWT.Text = n; if b then b(SWC) end
        SW.Visible = true; SW.Position = UDim2.new(0.5,0,0.5,0)
        Tw3(SW, {Size=UDim2.new(0,340,0,380)}, 0.35, Enum.EasingStyle.Back); sO = true
    end
    local function CS() Tw3(SW, {Size=UDim2.new(0,0,0,0)}, 0.3); task.delay(0.35, function() SW.Visible = false end); sO = false end
    SWX.MouseButton1Click:Connect(function() sndClick(); CS() end)

    local function FCTile(pr, cf)
        local nm = cf.Name
        local L_key = cf.LangKey
        local desc_key = cf.DescKey
        local LL = L()
        local displayName = LL[L_key] or nm
        local displayDesc = LL[desc_key] or ""
        
        local cd = Instance.new("Frame")
        cd.Name = nm; cd.BackgroundColor3 = C.Card; cd.BackgroundTransparency = 0.25; cd.BorderSizePixel = 0
        cd.Size = UDim2.new(1,0,1,0); cd.ZIndex = 5; cd.LayoutOrder = cf.Order or 0; cd.Parent = pr
        Cn3(cd,12)
        local cs = St3(cd, C.Border, 1.2, 0.7)
        Reg3(cd,"BackgroundColor3","Card"); Reg3(cs,"Color","Border")

        local gw = Instance.new("UIStroke")
        gw.Color = C.Accent; gw.Thickness = 2; gw.Transparency = 1; gw.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; gw.Parent = cd

        local iconBg = Instance.new("Frame")
        iconBg.BackgroundColor3 = C.Accent; iconBg.BackgroundTransparency = 0.8; iconBg.BorderSizePixel = 0
        iconBg.Position = UDim2.new(0,14,0,14); iconBg.Size = UDim2.new(0,38,0,38); iconBg.ZIndex = 6; iconBg.Parent = cd
        Cn3(iconBg,10)

        local iconTxt = Instance.new("TextLabel")
        iconTxt.BackgroundTransparency = 1; iconTxt.Size = UDim2.new(1,0,1,0)
        iconTxt.Font = Enum.Font.GothamBold; iconTxt.Text = cf.Icon or nm:sub(1,1):upper(); iconTxt.TextColor3 = C.Accent; iconTxt.TextSize = 20
        iconTxt.ZIndex = 7; iconTxt.Parent = iconBg

        local nl = Instance.new("TextLabel")
        nl.BackgroundTransparency = 1; nl.Position = UDim2.new(0,62,0,14); nl.Size = UDim2.new(1,-72,0,20)
        nl.Font = Enum.Font.GothamBold; nl.Text = displayName; nl.TextColor3 = C.Text; nl.TextSize = 14
        nl.TextXAlignment = Enum.TextXAlignment.Left; nl.ZIndex = 6; nl.Parent = cd
        Reg3(nl,"TextColor3","Text")

        local stTxt = Instance.new("TextLabel")
        stTxt.Name = "StTxt"; stTxt.BackgroundTransparency = 1
        stTxt.Position = UDim2.new(0,62,0,34); stTxt.Size = UDim2.new(1,-72,0,16)
        stTxt.Font = Enum.Font.Gotham; stTxt.Text = L().f_deactivated; stTxt.TextColor3 = C.TextDim; stTxt.TextSize = 11
        stTxt.TextXAlignment = Enum.TextXAlignment.Left; stTxt.ZIndex = 6; stTxt.Parent = cd
        Reg3(stTxt,"TextColor3","TextDim")

        local bottomPanel = Instance.new("Frame")
        bottomPanel.BackgroundTransparency = 1; bottomPanel.Position = UDim2.new(0,12,1,-32); bottomPanel.Size = UDim2.new(1,-24,0,28); bottomPanel.ZIndex = 6; bottomPanel.Parent = cd

        local bb = Instance.new("TextButton")
        bb.BackgroundColor3 = C.TagBg; bb.BackgroundTransparency = 0.2; bb.BorderSizePixel = 0
        bb.Position = UDim2.new(0,0,0.5,0); bb.AnchorPoint = Vector2.new(0,0.5); bb.Size = UDim2.new(0,52,0,24)
        bb.Font = Enum.Font.GothamBold; bb.Text = cf.Bind and cf.Bind.Name or "NONE"; bb.TextColor3 = C.TextDim; bb.TextSize = 10
        bb.ZIndex = 7; bb.AutoButtonColor = false; bb.Parent = bottomPanel; Cn3(bb,6)

        local gr = Instance.new("TextButton")
        gr.BackgroundTransparency = 1; gr.Position = UDim2.new(0,60,0.5,0); gr.AnchorPoint = Vector2.new(0,0.5)
        gr.Size = UDim2.new(0,24,0,24); gr.Font = Enum.Font.GothamBold; gr.Text = "*"; gr.TextColor3 = C.TextDim; gr.TextSize = 20
        gr.ZIndex = 7; gr.AutoButtonColor = false; gr.Parent = bottomPanel

        local tb = Instance.new("Frame")
        tb.BackgroundColor3 = C.TogOff; tb.BorderSizePixel = 0
        tb.Position = UDim2.new(1,0,0.5,0); tb.AnchorPoint = Vector2.new(1,0.5); tb.Size = UDim2.new(0,38,0,22)
        tb.ZIndex = 7; tb.Parent = bottomPanel; Cn3(tb,11)

        local tc = Instance.new("Frame")
        tc.BackgroundColor3 = C.Knob; tc.BorderSizePixel = 0; tc.Size = UDim2.new(0,16,0,16)
        tc.Position = UDim2.new(0,3,0.5,0); tc.AnchorPoint = Vector2.new(0,0.5); tc.ZIndex = 8; tc.Parent = tb; Cn3(tc,100)

        local en = cf.Default or false
        local function SS(s, si)
            en = s
            if s then
                Tw3(tb,{BackgroundColor3=C.TogOn},0.25)
                Tw3(tc,{Position=UDim2.new(1,-19,0.5,0)},0.25)
                Tw3(cd,{BackgroundColor3=C.CardActive, BackgroundTransparency=0.1},0.3)
                Tw3(gw,{Transparency=0.2},0.3)
                Tw3(nl,{TextColor3=C.AccentGlow},0.2)
                stTxt.Text = L().f_activated
                Tw3(stTxt,{TextColor3=C.Accent},0.2)
                Tw3(iconBg,{BackgroundTransparency=0.5},0.2)
                AT(displayName)
                if not si then sndOk(); Notify(displayName, L().f_activated, nil, 2.5) end
            else
                Tw3(tb,{BackgroundColor3=C.TogOff},0.25)
                Tw3(tc,{Position=UDim2.new(0,3,0.5,0)},0.25)
                Tw3(cd,{BackgroundColor3=C.Card, BackgroundTransparency=0.25},0.3)
                Tw3(gw,{Transparency=1},0.3)
                Tw3(nl,{TextColor3=C.Text},0.2)
                stTxt.Text = L().f_deactivated
                Tw3(stTxt,{TextColor3=C.TextDim},0.2)
                Tw3(iconBg,{BackgroundTransparency=0.8},0.2)
                RT(displayName)
                if not si then sndClick(); Notify(displayName, L().f_deactivated, nil, 2.5) end
            end
            if cf.OnToggle then cf.OnToggle(s) end
        end
        if cf.Default then SS(true, true) end

        local tB = Instance.new("TextButton")
        tB.BackgroundTransparency = 1; tB.Position = UDim2.new(1,-44,0,0); tB.Size = UDim2.new(0,44,1,0); tB.Text = ""; tB.ZIndex = 9; tB.Parent = bottomPanel
        tB.MouseButton1Click:Connect(function() SS(not en) end)

        gr.MouseButton1Click:Connect(function() sndClick(); OS(displayName, cf.Settings or function(c) SC.Label(c, "No settings") end) end)
        gr.MouseEnter:Connect(function() sndHover(); Tw3(gr,{TextColor3=C.Accent, Rotation=45},0.2) end)
        gr.MouseLeave:Connect(function() Tw3(gr,{TextColor3=C.TextDim, Rotation=0},0.2) end)

        cd.MouseEnter:Connect(function()
            sndHover()
            if displayDesc ~= "" then
                local tipText = displayDesc
                if cf.Bind then
                    tipText = tipText .. "\n\n" .. L().bind_label .. ": " .. (cf.Bind.Name or "NONE")
                end
                if cf.Tip then
                    tipText = tipText .. "\n\n" .. L().tip .. ": " .. cf.Tip
                end
                ShowTooltip(displayName, tipText)
            end
        end)
        cd.MouseLeave:Connect(function() HideTooltip() end)

        local li = false
        if cf.Bind then SB2(nm, cf.Bind, function() SS(not en) end) end
        bb.MouseButton1Click:Connect(function() sndClick(); li = true; bb.Text = "..."; Tw3(bb,{BackgroundColor3=C.Accent, BackgroundTransparency=0.1},0.15) end)
        UserInputService.InputBegan:Connect(function(inp, gpe)
            if li and not gpe and inp.UserInputType == Enum.UserInputType.Keyboard then
                if inp.KeyCode == Enum.KeyCode.Escape then
                    bb.Text = "NONE"; SB2(nm, nil, nil)
                else
                    bb.Text = inp.KeyCode.Name; SB2(nm, inp.KeyCode, function() SS(not en) end)
                end
                li = false; Tw3(bb,{BackgroundColor3=C.TagBg, BackgroundTransparency=0.2},0.15)
                Notify("Keybind", displayName .. " → " .. bb.Text, nil, 2)
            end
        end)
    end

    local pVeh = Pages["cat_vehicle"]
    local vH = Instance.new("TextLabel")
    vH.BackgroundTransparency = 1; vH.Size = UDim2.new(1,-10,0,28); vH.Font = Enum.Font.GothamBold
    vH.Text = L().cat_vehicle; vH.TextColor3 = C.Text; vH.TextSize = 16; vH.TextXAlignment = Enum.TextXAlignment.Left
    vH.ZIndex = 5; vH.LayoutOrder = 1; vH.Parent = pVeh
    Reg3(vH,"TextColor3","Text")

    local vG = Instance.new("Frame")
    vG.BackgroundTransparency = 1; vG.Size = UDim2.new(1,-10,0,0); vG.AutomaticSize = Enum.AutomaticSize.Y
    vG.ZIndex = 4; vG.LayoutOrder = 2; vG.Parent = pVeh
    local vGL = Instance.new("UIGridLayout")
    vGL.CellSize = UDim2.new(0,180,0,110); vGL.CellPadding = UDim2.new(0,12,0,12); vGL.SortOrder = Enum.SortOrder.LayoutOrder
    vGL.FillDirectionMaxCells = 3; vGL.HorizontalAlignment = Enum.HorizontalAlignment.Center; vGL.Parent = vG

    local CarSpeed = {Enabled=false, CurMode=1, AutoOnSeat=false, Modes={{n="STOCK",p=0},{n="LIGHT",p=0.2},{n="FAST",p=0.4},{n="QUICK",p=1.0},{n="ROCKET",p=45.0}}, _dir=0, _cm=nil, _cv=nil, _conns={}}
    function CarSpeed:_getMass(m) local mm=0; for _,p in next,m:GetDescendants() do if p:IsA("BasePart") then mm=mm+p:GetMass() end end; return mm end
    function CarSpeed:Enable()
        if self.Enabled then return end; self.Enabled = true
        self._conns.r = RunService.RenderStepped:Connect(function()
            if not self.Enabled then return end
            local lp = Players.LocalPlayer; local vf = workspace:FindFirstChild("Vehicles"); if not vf then return end
            for _, v in next, vf:GetChildren() do
                local engine = v:FindFirstChild("Engine"); local seat = v:FindFirstChild("Seat")
                if engine and seat and seat:FindFirstChild("PlayerName") then
                    if seat.PlayerName.Value == lp.Name then
                        if self._cv ~= v then self._cv = v; self._cm = self:_getMass(v); if self._cm < 10 then self._cm = 2000 end end
                        local bf = engine:FindFirstChild("NewForce"); if not bf then bf = Instance.new("BodyForce", engine); bf.Name = "NewForce" end
                        local pwr = self.Modes[self.CurMode].p
                        if self._dir ~= 0 and pwr > 0 then
                            local cf = v:GetPrimaryPartCFrame().lookVector
                            local ff = self._cm * pwr * 100 * self._dir
                            bf.Force = Vector3.new(cf.X * ff, 0, cf.Z * ff)
                        else
                            bf.Force = Vector3.new(0,0,0)
                        end
                    else
                        local ob = engine:FindFirstChild("NewForce"); if ob then ob.Force = Vector3.new(0,0,0) end
                    end
                end
            end
        end)
        self._conns.b = UserInputService.InputBegan:Connect(function(k, p)
            if p or not self.Enabled then return end
            if k.KeyCode == Enum.KeyCode.W then self._dir = 1
            elseif k.KeyCode == Enum.KeyCode.S then self._dir = -1 end
        end)
        self._conns.e = UserInputService.InputEnded:Connect(function(k)
            if k.KeyCode == Enum.KeyCode.W and self._dir == 1 then self._dir = 0
            elseif k.KeyCode == Enum.KeyCode.S and self._dir == -1 then self._dir = 0 end
        end)
    end
    function CarSpeed:Disable()
        if not self.Enabled then return end; self.Enabled = false
        for _, c in pairs(self._conns) do c:Disconnect() end; self._conns = {}
        if self._cv then local e = self._cv:FindFirstChild("Engine"); if e then local bf = e:FindFirstChild("NewForce"); if bf then bf.Force = Vector3.new(0,0,0) end end end
        self._dir = 0
    end
    FUNCTIONS.CarSpeed = CarSpeed

    FCTile(vG, {Name="CarSpeed", LangKey="f_carspeed", DescKey="f_carspeed_desc", Icon="⚡", Order=1, Bind=Enum.KeyCode.X,
        Tip="Mode 5 = ROCKET 🚀",
        Settings = function(c)
            SC.Label(c, "Speed Mode (1-5)")
            SC.Slider(c, "Mode", 1, 5, CarSpeed.CurMode, "", function(v) CarSpeed.CurMode = v end)
            SC.Toggle(c, "Auto-enable on seat", false, function(v) CarSpeed.AutoOnSeat = v end)
        end,
        OnToggle = function(s) if s then CarSpeed:Enable() else CarSpeed:Disable() end end
    })

    local AntiFling = {Enabled=false, _lv=Vector3.new(0,0,0), _conn=nil}
    function AntiFling:Enable()
        if self.Enabled then return end; self.Enabled = true
        self._conn = RunService.Heartbeat:Connect(function()
            if not self.Enabled then return end
            local lp = Players.LocalPlayer; if not lp.Character then return end
            local vf = workspace:FindFirstChild("Vehicles"); if not vf then return end
            for _, v in next, vf:GetChildren() do
                local seat = v:FindFirstChild("Seat") or v:FindFirstChildWhichIsA("VehicleSeat")
                if seat and seat:FindFirstChild("PlayerName") and seat.PlayerName.Value == lp.Name then
                    local root = v.PrimaryPart
                    if root then
                        local cv = root.Velocity
                        local dv = (self._lv - cv).Magnitude
                        if dv > 50 then
                            root.Velocity = Vector3.new(0,0,0); root.RotVelocity = Vector3.new(0,0,0); cv = Vector3.new(0,0,0)
                        end
                        self._lv = cv
                    end
                end
            end
        end)
    end
    function AntiFling:Disable()
        if not self.Enabled then return end; self.Enabled = false
        if self._conn then self._conn:Disconnect(); self._conn = nil end
        self._lv = Vector3.new(0,0,0)
    end
    FUNCTIONS.AntiFling = AntiFling

    FCTile(vG, {Name="AntiFling", LangKey="f_antifling", DescKey="f_antifling_desc", Icon="🛡", Order=2, Bind=Enum.KeyCode.J,
        Tip="Perfect with CarSpeed!",
        OnToggle = function(s) if s then AntiFling:Enable() else AntiFling:Disable() end end
    })

    local FastStop = {Enabled=false, _last=0, _delay=0.3, _conn=nil}
    function FastStop:Enable()
        if self.Enabled then return end; self.Enabled = true
        self._conn = UserInputService.InputBegan:Connect(function(k, p)
            if p or not self.Enabled then return end
            if k.KeyCode == Enum.KeyCode.S then
                local now = tick()
                if (now - self._last) < self._delay then
                    self:_stop(); self._last = 0
                else self._last = now end
            end
        end)
    end
    function FastStop:Disable()
        if not self.Enabled then return end; self.Enabled = false
        if self._conn then self._conn:Disconnect(); self._conn = nil end
        self._last = 0
    end
    function FastStop:_stop()
        local lp = Players.LocalPlayer; local vf = workspace:FindFirstChild("Vehicles"); if not vf then return end
        for _, v in next, vf:GetChildren() do
            local seat = v:FindFirstChild("Seat") or v:FindFirstChildWhichIsA("VehicleSeat")
            if seat and seat:FindFirstChild("PlayerName") and seat.PlayerName.Value == lp.Name then
                local root = v.PrimaryPart
                if root then
                    root.Velocity = Vector3.new(0,0,0); root.RotVelocity = Vector3.new(0,0,0)
                    Notify("⛔ FastStop", "STOPPED!", nil, 1.5)
                end
                break
            end
        end
    end
    FUNCTIONS.FastStop = FastStop

    FCTile(vG, {Name="FastStop", LangKey="f_faststop", DescKey="f_faststop_desc", Icon="⛔", Order=3, Bind=Enum.KeyCode.N,
        Tip="Press S twice to STOP!",
        OnToggle = function(s) if s then FastStop:Enable() else FastStop:Disable() end end
    })

    local AntiFlip = {Enabled=false, _last=0, _conn=nil}
    function AntiFlip:Enable()
        if self.Enabled then return end; self.Enabled = true
        self._conn = RunService.Heartbeat:Connect(function()
            if not self.Enabled then return end
            if (tick() - self._last) < 0.5 then return end
            local lp = Players.LocalPlayer; local vf = workspace:FindFirstChild("Vehicles"); if not vf then return end
            for _, v in next, vf:GetChildren() do
                local seat = v:FindFirstChild("Seat") or v:FindFirstChildWhichIsA("VehicleSeat")
                if seat and seat:FindFirstChild("PlayerName") and seat.PlayerName.Value == lp.Name then
                    local root = v.PrimaryPart
                    if root and root.CFrame.UpVector.Y < 0.2 then
                        root.CFrame = CFrame.new(root.Position + Vector3.new(0,3,0)) * CFrame.Angles(0, math.rad(root.Orientation.Y), 0)
                        root.RotVelocity = Vector3.new(0,0,0)
                        root.Velocity = root.Velocity * 0.5
                        self._last = tick()
                        Notify("✈ AntiFlip", "Flipped back!", nil, 1.5)
                    end
                    break
                end
            end
        end)
    end
    function AntiFlip:Disable()
        if not self.Enabled then return end; self.Enabled = false
        if self._conn then self._conn:Disconnect(); self._conn = nil end
        self._last = 0
    end
    FUNCTIONS.AntiFlip = AntiFlip

    FCTile(vG, {Name="AntiFlip", LangKey="f_antiflip", DescKey="f_antiflip_desc", Icon="✈", Order=4, Bind=Enum.KeyCode.H,
        Tip="No more flipped car!",
        OnToggle = function(s) if s then AntiFlip:Enable() else AntiFlip:Disable() end end
    })

    local pPlr = Pages["cat_player"]
    local pH = Instance.new("TextLabel")
    pH.BackgroundTransparency = 1; pH.Size = UDim2.new(1,-10,0,28); pH.Font = Enum.Font.GothamBold
    pH.Text = L().cat_player; pH.TextColor3 = C.Text; pH.TextSize = 16; pH.TextXAlignment = Enum.TextXAlignment.Left
    pH.ZIndex = 5; pH.LayoutOrder = 1; pH.Parent = pPlr
    Reg3(pH,"TextColor3","Text")

    local pG = Instance.new("Frame")
    pG.BackgroundTransparency = 1; pG.Size = UDim2.new(1,-10,0,0); pG.AutomaticSize = Enum.AutomaticSize.Y
    pG.ZIndex = 4; pG.LayoutOrder = 2; pG.Parent = pPlr
    local pGL = Instance.new("UIGridLayout")
    pGL.CellSize = UDim2.new(0,180,0,110); pGL.CellPadding = UDim2.new(0,12,0,12); pGL.SortOrder = Enum.SortOrder.LayoutOrder
    pGL.FillDirectionMaxCells = 3; pGL.HorizontalAlignment = Enum.HorizontalAlignment.Center; pGL.Parent = pG

    local FastKill = {Enabled=false, ReqDouble=false, _last=0, _delay=0.5, _conn=nil}
    function FastKill:Enable()
        if self.Enabled then return end; self.Enabled = true
        self._conn = UserInputService.InputBegan:Connect(function(i, gp)
            if gp or not self.Enabled then return end
            if i.KeyCode == Enum.KeyCode.Y then
                if self.ReqDouble then
                    local now = tick()
                    if (now - self._last) < self._delay then self:_kill(); self._last = 0
                    else self._last = now; Notify("FastKill", "Press Y again to confirm", nil, 1) end
                else self:_kill() end
            end
        end)
    end
    function FastKill:Disable()
        if not self.Enabled then return end; self.Enabled = false
        if self._conn then self._conn:Disconnect(); self._conn = nil end
        self._last = 0
    end
    function FastKill:_kill()
        local p = Players.LocalPlayer; local ch = p.Character
        if ch then local h = ch:FindFirstChildOfClass("Humanoid"); if h and h.Health > 0 then h.Health = 0; Notify("💀 FastKill", "Respawning...", nil, 2) end end
    end
    FUNCTIONS.FastKill = FastKill

    FCTile(pG, {Name="FastKill", LangKey="f_fastkill", DescKey="f_fastkill_desc", Icon="💀", Order=1, Bind=Enum.KeyCode.Y,
        Tip="Escape cops with Y!",
        Settings = function(c)
            SC.Toggle(c, "Require double tap", false, function(v) FastKill.ReqDouble = v end)
        end,
        OnToggle = function(s) if s then FastKill:Enable() else FastKill:Disable() end end
    })

    local InfJump = {Enabled=false, _conn=nil}
    function InfJump:Enable()
        if self.Enabled then return end; self.Enabled = true
        self._conn = UserInputService.JumpRequest:Connect(function()
            if not self.Enabled then return end
            local ch = Players.LocalPlayer.Character
            if ch then local h = ch:FindFirstChildOfClass("Humanoid"); if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end
        end)
    end
    function InfJump:Disable()
        if not self.Enabled then return end; self.Enabled = false
        if self._conn then self._conn:Disconnect(); self._conn = nil end
    end
    FUNCTIONS.InfJump = InfJump

    FCTile(pG, {Name="InfiniteJump", LangKey="f_infjump", DescKey="f_infjump_desc", Icon="🦘", Order=2, Bind=Enum.KeyCode.I,
        Tip="Jump on roofs to escape cops!",
        OnToggle = function(s) if s then InfJump:Enable() else InfJump:Disable() end end
    })

    local pOv = Pages["cat_overlay"]
    local ovH = Instance.new("TextLabel")
    ovH.BackgroundTransparency = 1; ovH.Size = UDim2.new(1,-10,0,28); ovH.Font = Enum.Font.GothamBold
    ovH.Text = "Overlay Modules"; ovH.TextColor3 = C.Text; ovH.TextSize = 16; ovH.TextXAlignment = Enum.TextXAlignment.Left
    ovH.ZIndex = 5; ovH.LayoutOrder = 1; ovH.Parent = pOv
    Reg3(ovH,"TextColor3","Text")

    local gOv = Instance.new("Frame")
    gOv.BackgroundTransparency = 1; gOv.Size = UDim2.new(1,-10,0,0); gOv.AutomaticSize = Enum.AutomaticSize.Y
    gOv.ZIndex = 4; gOv.LayoutOrder = 2; gOv.Parent = pOv
    local glOv = Instance.new("UIGridLayout")
    glOv.CellSize = UDim2.new(0,180,0,110); glOv.CellPadding = UDim2.new(0,12,0,12); glOv.SortOrder = Enum.SortOrder.LayoutOrder
    glOv.FillDirectionMaxCells = 3; glOv.HorizontalAlignment = Enum.HorizontalAlignment.Center; glOv.Parent = gOv

    local wF
    FCTile(gOv, {Name="Watermark", Icon="W", Order=1, OnToggle = function(s)
        if s then
            wF = Instance.new("Frame"); wF.BackgroundColor3 = C.Card; wF.BackgroundTransparency = 0.15; wF.BorderSizePixel = 0
            wF.Position = UDim2.new(1,-260,0,8); wF.Size = UDim2.new(0,250,0,32); wF.ZIndex = 90; wF.Parent = _G.NzGui; Cn3(wF,8); St3(wF, C.Accent, 1, 0.5)
            local wt = Instance.new("TextLabel"); wt.Name = "WT"; wt.BackgroundTransparency = 1; wt.Size = UDim2.new(1,0,1,0)
            wt.Font = Enum.Font.GothamBold; wt.Text = "Nz | " .. Player.Name; wt.TextColor3 = C.Text; wt.TextSize = 13; wt.ZIndex = 91; wt.Parent = wF
            spawn(function() while wF and wF.Parent do local fps = math.floor(1/RunService.Heartbeat:Wait()); if wF and wF:FindFirstChild("WT") then wF.WT.Text = "Nz | " .. Player.Name .. " | " .. fps .. " FPS" end end end)
        else if wF then wF:Destroy(); wF = nil end end
    end})

    local fF
    FCTile(gOv, {Name="FPSCounter", Icon="F", Order=2, OnToggle = function(s)
        if s then
            fF = Instance.new("TextLabel"); fF.BackgroundColor3 = C.Card; fF.BackgroundTransparency = 0.2; fF.BorderSizePixel = 0
            fF.Position = UDim2.new(0.5,0,0,8); fF.AnchorPoint = Vector2.new(0.5,0); fF.Size = UDim2.new(0,95,0,30)
            fF.Font = Enum.Font.GothamBold; fF.Text = "0 FPS"; fF.TextColor3 = C.AccentGlow; fF.TextSize = 15; fF.ZIndex = 90; fF.Parent = _G.NzGui
            Cn3(fF,8); St3(fF, C.Accent, 1, 0.5)
            spawn(function() while fF and fF.Parent do local fps = math.floor(1/RunService.Heartbeat:Wait()); if fF then fF.Text = fps .. " FPS" end end end)
        else if fF then fF:Destroy(); fF = nil end end
    end})

    local cF
    FCTile(gOv, {Name="Coords", Icon="C", Order=3, OnToggle = function(s)
        if s then
            cF = Instance.new("TextLabel"); cF.BackgroundColor3 = C.Card; cF.BackgroundTransparency = 0.2; cF.BorderSizePixel = 0
            cF.Position = UDim2.new(0,8,0,46); cF.Size = UDim2.new(0,230,0,26)
            cF.Font = Enum.Font.GothamMedium; cF.Text = "X:0 Y:0 Z:0"; cF.TextColor3 = C.Text; cF.TextSize = 13
            cF.TextXAlignment = Enum.TextXAlignment.Left; cF.ZIndex = 90; cF.Parent = _G.NzGui; Cn3(cF,6); Pd3(cF,0,0,10,0)
            spawn(function() while cF and cF.Parent do task.wait(0.1); local ch = Player.Character; if ch and ch:FindFirstChild("HumanoidRootPart") and cF then local pp = ch.HumanoidRootPart.Position; cF.Text = string.format("X:%.0f Y:%.0f Z:%.0f", pp.X, pp.Y, pp.Z) end end end)
        else if cF then cF:Destroy(); cF = nil end end
    end})

    local pF
    FCTile(gOv, {Name="PingDisplay", Icon="P", Order=4, OnToggle = function(s)
        if s then
            pF = Instance.new("TextLabel"); pF.BackgroundColor3 = C.Card; pF.BackgroundTransparency = 0.2; pF.BorderSizePixel = 0
            pF.Position = UDim2.new(0,8,0,8); pF.Size = UDim2.new(0,100,0,26)
            pF.Font = Enum.Font.GothamBold; pF.Text = "0 ms"; pF.TextColor3 = C.AccentGlow; pF.TextSize = 13; pF.ZIndex = 90; pF.Parent = _G.NzGui; Cn3(pF,6); St3(pF, C.Accent, 1, 0.6)
            spawn(function() while pF and pF.Parent do task.wait(0.5); local ok, pg = pcall(function() return math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end); if ok and pF then pF.Text = pg .. " ms"; pF.TextColor3 = pg<80 and Color3.fromRGB(80,255,140) or pg<150 and Color3.fromRGB(255,200,50) or Color3.fromRGB(255,80,80) end end end)
        else if pF then pF:Destroy(); pF = nil end end
    end})

    local cmF
    FCTile(gOv, {Name="CarMode", Icon="⚡", Order=5, OnToggle = function(s)
        if s then
            cmF = Instance.new("Frame"); cmF.BackgroundColor3 = C.Card; cmF.BackgroundTransparency = 0.2; cmF.BorderSizePixel = 0
            cmF.Position = UDim2.new(0,8,0,80); cmF.Size = UDim2.new(0,200,0,50); cmF.ZIndex = 90; cmF.Parent = _G.NzGui; Cn3(cmF,8); St3(cmF, C.Accent, 1, 0.6)
            local cmT = Instance.new("TextLabel"); cmT.BackgroundTransparency = 1; cmT.Position = UDim2.new(0,12,0,4); cmT.Size = UDim2.new(1,-24,0,18)
            cmT.Font = Enum.Font.GothamBold; cmT.Text = "⚡ CarSpeed"; cmT.TextColor3 = C.AccentGlow; cmT.TextSize = 13; cmT.TextXAlignment = Enum.TextXAlignment.Left; cmT.ZIndex = 91; cmT.Parent = cmF
            local cmM = Instance.new("TextLabel"); cmM.BackgroundTransparency = 1; cmM.Position = UDim2.new(0,12,0,22); cmM.Size = UDim2.new(1,-24,0,22)
            cmM.Font = Enum.Font.GothamMedium; cmM.Text = ""; cmM.TextColor3 = C.Text; cmM.TextSize = 12; cmM.TextXAlignment = Enum.TextXAlignment.Left; cmM.ZIndex = 91; cmM.Parent = cmF
            spawn(function()
                while cmF and cmF.Parent do
                    task.wait(0.2)
                    if cmF and CarSpeed then
                        if CarSpeed.Enabled then
                            local dots = ""
                            for i = 1, 5 do dots = dots .. (i <= CarSpeed.CurMode and "●" or "○") end
                            cmM.Text = dots .. "  " .. CarSpeed.Modes[CarSpeed.CurMode].n
                            cmF.Visible = true
                        else
                            cmF.Visible = false
                        end
                    end
                end
            end)
        else if cmF then cmF:Destroy(); cmF = nil end end
    end})

    local afC
    FCTile(gOv, {Name="AntiAFK", Icon="A", Order=6, OnToggle = function(s)
        if s then
            afC = Player.Idled:Connect(function() local vu = game:GetService("VirtualUser"); vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame); task.wait(1); vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame) end)
        else if afC then afC:Disconnect(); afC = nil end end
    end})

    local pTh = Pages["cat_themes"]
    local h1 = Instance.new("TextLabel")
    h1.BackgroundTransparency = 1; h1.Size = UDim2.new(1,-10,0,28); h1.Font = Enum.Font.GothamBold
    h1.Text = L().base_themes; h1.TextColor3 = C.Text; h1.TextSize = 16; h1.TextXAlignment = Enum.TextXAlignment.Left
    h1.ZIndex = 5; h1.LayoutOrder = 1; h1.Parent = pTh; Reg3(h1,"TextColor3","Text")

    local tG = Instance.new("Frame"); tG.BackgroundTransparency=1; tG.Size=UDim2.new(1,-10,0,0); tG.AutomaticSize=Enum.AutomaticSize.Y; tG.ZIndex=5; tG.LayoutOrder=2; tG.Parent=pTh
    local tGL = Instance.new("UIGridLayout"); tGL.CellSize=UDim2.new(0,140,0,56); tGL.CellPadding=UDim2.new(0,8,0,8); tGL.SortOrder=Enum.SortOrder.LayoutOrder; tGL.FillDirectionMaxCells=4; tGL.HorizontalAlignment=Enum.HorizontalAlignment.Center; tGL.Parent=tG

    local tBtns = {}
    for i, th in ipairs(_G.NzThemeList) do
        local tb = Instance.new("TextButton"); tb.BackgroundColor3=th.Sidebar; tb.BorderSizePixel=0; tb.Size=UDim2.new(1,0,1,0); tb.Text=""; tb.ZIndex=6; tb.AutoButtonColor=false; tb.LayoutOrder=i; tb.Parent=tG; Cn3(tb,8)
        local tbGrad = Instance.new("UIGradient"); tbGrad.Color = ColorSequence.new{ColorSequenceKeypoint.new(0,th.Grad1), ColorSequenceKeypoint.new(1,th.Grad2)}; tbGrad.Rotation=180; tbGrad.Parent=tb
        local tSt = St3(tb, (_G.NzCurTheme().Id == th.Id) and C.Accent or th.Border, 1.5, (_G.NzCurTheme().Id == th.Id) and 0.15 or 0.7)
        local sn = th.Name:len()>16 and th.Name:sub(1,16).."..." or th.Name
        local tnl = Instance.new("TextLabel"); tnl.BackgroundTransparency=1; tnl.Position=UDim2.new(0,8,0,6); tnl.Size=UDim2.new(1,-16,0,18); tnl.Font=Enum.Font.GothamBold; tnl.Text=sn; tnl.TextColor3=th.Text; tnl.TextSize=12; tnl.TextXAlignment=Enum.TextXAlignment.Left; tnl.ZIndex=7; tnl.Parent=tb
        local pvw = Instance.new("Frame"); pvw.BackgroundTransparency=1; pvw.Position=UDim2.new(0,8,0,30); pvw.Size=UDim2.new(1,-16,0,18); pvw.ZIndex=7; pvw.Parent=tb
        local pvL = Instance.new("UIListLayout"); pvL.FillDirection=Enum.FillDirection.Horizontal; pvL.Padding=UDim.new(0,4); pvL.Parent=pvw
        for _, col in ipairs({th.Bg, th.Card, th.Text}) do local dot = Instance.new("Frame"); dot.BackgroundColor3=col; dot.BorderSizePixel=0; dot.Size=UDim2.new(0,14,0,14); dot.ZIndex=8; dot.Parent=pvw; Cn3(dot,4) end
        tBtns[th.Id] = {btn=tb, st=tSt}
        tb.MouseEnter:Connect(function() sndHover(); Tw3(tb,{BackgroundTransparency=0.15},0.12) end)
        tb.MouseLeave:Connect(function() Tw3(tb,{BackgroundTransparency=0},0.12) end)
        tb.MouseButton1Click:Connect(function()
            sndClick(); _G.NzSetTheme(th)
            for id, d in pairs(tBtns) do
                if id == th.Id then Tw3(d.st,{Color=C.Accent, Transparency=0.15},0.25)
                else Tw3(d.st,{Transparency=0.7},0.25) end
            end
            Notify(L().notify_theme, th.Name, nil, 2)
        end)
    end

    local s1 = Instance.new("Frame"); s1.BackgroundColor3=C.Divider; s1.BackgroundTransparency=0.3; s1.BorderSizePixel=0; s1.Size=UDim2.new(1,-10,0,1); s1.ZIndex=5; s1.LayoutOrder=3; s1.Parent=pTh; Reg3(s1,"BackgroundColor3","Divider")
    local h2 = Instance.new("TextLabel"); h2.BackgroundTransparency=1; h2.Size=UDim2.new(1,-10,0,28); h2.Font=Enum.Font.GothamBold; h2.Text=L().accent; h2.TextColor3=C.Text; h2.TextSize=16; h2.TextXAlignment=Enum.TextXAlignment.Left; h2.ZIndex=5; h2.LayoutOrder=4; h2.Parent=pTh; Reg3(h2,"TextColor3","Text")

    local cG = Instance.new("Frame"); cG.BackgroundTransparency=1; cG.Size=UDim2.new(1,-10,0,0); cG.AutomaticSize=Enum.AutomaticSize.Y; cG.ZIndex=5; cG.LayoutOrder=5; cG.Parent=pTh
    local cGL = Instance.new("UIGridLayout"); cGL.CellSize=UDim2.new(0,140,0,52); cGL.CellPadding=UDim2.new(0,8,0,8); cGL.SortOrder=Enum.SortOrder.LayoutOrder; cGL.FillDirectionMaxCells=4; cGL.HorizontalAlignment=Enum.HorizontalAlignment.Center; cGL.Parent=cG

    for i, ac in ipairs(_G.NzAccentList) do
        local cc = Instance.new("TextButton"); cc.BackgroundColor3=ac.C1; cc.BorderSizePixel=0; cc.Size=UDim2.new(1,0,1,0); cc.Text=""; cc.ZIndex=6; cc.AutoButtonColor=false; cc.LayoutOrder=i; cc.Parent=cG; Cn3(cc,8)
        local ccGrad = Instance.new("UIGradient"); ccGrad.Color = ColorSequence.new{ColorSequenceKeypoint.new(0,ac.C1), ColorSequenceKeypoint.new(1,ac.C2)}; ccGrad.Rotation=45; ccGrad.Parent=cc
        local cSt = St3(cc, Color3.new(1,1,1), 2, (_G.NzCurAccent().Name == ac.Name) and 0.15 or 1)
        local nl = Instance.new("TextLabel"); nl.BackgroundTransparency=1; nl.Position=UDim2.new(0,10,0.5,0); nl.AnchorPoint=Vector2.new(0,0.5); nl.Size=UDim2.new(1,-20,0,20); nl.Font=Enum.Font.GothamBold; nl.Text=ac.Name; nl.TextColor3=Color3.new(1,1,1); nl.TextSize=14; nl.TextXAlignment=Enum.TextXAlignment.Left; nl.ZIndex=7; nl.Parent=cc
        cc.MouseEnter:Connect(function() sndHover(); Tw3(cc,{BackgroundTransparency=0.15},0.12) end)
        cc.MouseLeave:Connect(function() Tw3(cc,{BackgroundTransparency=0},0.12) end)
        cc.MouseButton1Click:Connect(function()
            sndClick(); _G.NzSetAccent(ac)
            for _, ch in ipairs(cG:GetChildren()) do if ch:IsA("TextButton") then local s = ch:FindFirstChildOfClass("UIStroke"); if s then Tw3(s,{Transparency=1},0.2) end end end
            Tw3(cSt,{Transparency=0.15},0.3)
            Notify(L().notify_accent, ac.Name, nil, 2)
        end)
    end

    local pSet = Pages["cat_settings"]
    local sH = Instance.new("TextLabel"); sH.BackgroundTransparency=1; sH.Size=UDim2.new(1,-10,0,28); sH.Font=Enum.Font.GothamBold; sH.Text=L().cat_settings; sH.TextColor3=C.Text; sH.TextSize=16; sH.TextXAlignment=Enum.TextXAlignment.Left; sH.ZIndex=5; sH.LayoutOrder=1; sH.Parent=pSet; Reg3(sH,"TextColor3","Text")

    local langCard = Instance.new("Frame"); langCard.BackgroundColor3=C.Card; langCard.BackgroundTransparency=0.3; langCard.BorderSizePixel=0; langCard.Size=UDim2.new(1,-10,0,180); langCard.ZIndex=5; langCard.LayoutOrder=2; langCard.Parent=pSet; Cn3(langCard,10); Reg3(langCard,"BackgroundColor3","Card")
    local langLabel = Instance.new("TextLabel"); langLabel.BackgroundTransparency=1; langLabel.Position=UDim2.new(0,14,0,8); langLabel.Size=UDim2.new(1,-28,0,22); langLabel.Font=Enum.Font.GothamBold; langLabel.Text=L().set_lang; langLabel.TextColor3=C.Text; langLabel.TextSize=14; langLabel.TextXAlignment=Enum.TextXAlignment.Left; langLabel.ZIndex=6; langLabel.Parent=langCard; Reg3(langLabel,"TextColor3","Text")
    
    local langGrid = Instance.new("Frame"); langGrid.BackgroundTransparency=1; langGrid.Position=UDim2.new(0,12,0,38); langGrid.Size=UDim2.new(1,-24,1,-46); langGrid.ZIndex=5; langGrid.Parent=langCard
    local lggL = Instance.new("UIGridLayout"); lggL.CellSize=UDim2.new(0,150,0,32); lggL.CellPadding=UDim2.new(0,6,0,6); lggL.FillDirectionMaxCells=4; lggL.HorizontalAlignment=Enum.HorizontalAlignment.Left; lggL.Parent=langGrid

    local langSetBtns = {}
    local LANG_ORDER2 = {"en","ru","es","de","fr","pt","id","tr"}
    for _, code in ipairs(LANG_ORDER2) do
        local lang = LANGS[code]
        local lb = Instance.new("TextButton")
        lb.BackgroundColor3 = code == _G.NzLang and C.AccentSoft or C.Sidebar
        lb.BackgroundTransparency = code == _G.NzLang and 0.1 or 0.5
        lb.BorderSizePixel = 0
        lb.Size = UDim2.new(1,0,1,0)
        lb.Font = Enum.Font.GothamMedium
        lb.Text = "  " .. lang.f .. "  " .. lang.n
        lb.TextColor3 = code == _G.NzLang and C.AccentGlow or C.Text
        lb.TextSize = 11
        lb.TextXAlignment = Enum.TextXAlignment.Left
        lb.ZIndex = 6
        lb.AutoButtonColor = false
        lb.Name = code
        lb.Parent = langGrid
        Cn3(lb, 6)
        langSetBtns[code] = lb
        lb.MouseEnter:Connect(function() sndHover(); if code ~= _G.NzLang then Tw3(lb,{BackgroundTransparency=0.2},0.15) end end)
        lb.MouseLeave:Connect(function() if code ~= _G.NzLang then Tw3(lb,{BackgroundTransparency=0.5},0.15) end end)
        lb.MouseButton1Click:Connect(function()
            sndClick()
            _G.NzLang = code
            local LL = L()
            for c, b in pairs(langSetBtns) do
                if c == code then Tw3(b,{BackgroundColor3=C.AccentSoft, BackgroundTransparency=0.1, TextColor3=C.AccentGlow},0.2)
                else Tw3(b,{BackgroundColor3=C.Sidebar, BackgroundTransparency=0.5, TextColor3=C.Text},0.2) end
            end
            langLabel.Text = LL.set_lang
            sH.Text = LL.cat_settings
            vH.Text = LL.cat_vehicle
            pH.Text = LL.cat_player
            h1.Text = LL.base_themes
            h2.Text = LL.accent
            if _G.NzUpdateLangTexts then _G.NzUpdateLangTexts() end
            Notify("Language", lang.n, nil, 2)
        end)
    end

    local bindCard = Instance.new("Frame"); bindCard.BackgroundColor3=C.Card; bindCard.BackgroundTransparency=0.3; bindCard.BorderSizePixel=0; bindCard.Size=UDim2.new(1,-10,0,46); bindCard.ZIndex=5; bindCard.LayoutOrder=3; bindCard.Parent=pSet; Cn3(bindCard,10); Reg3(bindCard,"BackgroundColor3","Card")
    local bL = Instance.new("TextLabel"); bL.BackgroundTransparency=1; bL.Position=UDim2.new(0,14,0,0); bL.Size=UDim2.new(1,-90,1,0); bL.Font=Enum.Font.GothamMedium; bL.Text=L().set_bind; bL.TextColor3=C.Text; bL.TextSize=14; bL.TextXAlignment=Enum.TextXAlignment.Left; bL.ZIndex=6; bL.Parent=bindCard; Reg3(bL,"TextColor3","Text")
    local gK = Enum.KeyCode.RightControl
    local gKL = false
    local gKB = Instance.new("TextButton"); gKB.BackgroundColor3=C.TagBg; gKB.BackgroundTransparency=0.2; gKB.BorderSizePixel=0; gKB.Position=UDim2.new(1,-76,0.5,0); gKB.AnchorPoint=Vector2.new(0,0.5); gKB.Size=UDim2.new(0,62,0,28); gKB.Font=Enum.Font.GothamBold; gKB.Text="RCtrl"; gKB.TextColor3=C.AccentGlow; gKB.TextSize=12; gKB.ZIndex=7; gKB.AutoButtonColor=false; gKB.Parent=bindCard; Cn3(gKB,7)
    gKB.MouseButton1Click:Connect(function() sndClick(); gKL=true; gKB.Text="..."; Tw3(gKB,{BackgroundColor3=C.Accent},0.15) end)

    local blC = Instance.new("Frame"); blC.BackgroundColor3=C.Card; blC.BackgroundTransparency=0.3; blC.BorderSizePixel=0; blC.Size=UDim2.new(1,-10,0,46); blC.ZIndex=5; blC.LayoutOrder=4; blC.Parent=pSet; Cn3(blC,10); Reg3(blC,"BackgroundColor3","Card")
    local blL = Instance.new("TextLabel"); blL.BackgroundTransparency=1; blL.Position=UDim2.new(0,14,0,0); blL.Size=UDim2.new(1,-60,1,0); blL.Font=Enum.Font.GothamMedium; blL.Text=L().set_blur; blL.TextColor3=C.Text; blL.TextSize=14; blL.TextXAlignment=Enum.TextXAlignment.Left; blL.ZIndex=6; blL.Parent=blC; Reg3(blL,"TextColor3","Text")
    local blT = Instance.new("Frame"); blT.BackgroundColor3=C.TogOn; blT.BorderSizePixel=0; blT.Position=UDim2.new(1,-54,0.5,0); blT.AnchorPoint=Vector2.new(0,0.5); blT.Size=UDim2.new(0,38,0,22); blT.ZIndex=7; blT.Parent=blC; Cn3(blT,11)
    local blCr = Instance.new("Frame"); blCr.BackgroundColor3=C.Knob; blCr.BorderSizePixel=0; blCr.Size=UDim2.new(0,16,0,16); blCr.Position=UDim2.new(1,-19,0.5,0); blCr.AnchorPoint=Vector2.new(0,0.5); blCr.ZIndex=8; blCr.Parent=blT; Cn3(blCr,100)
    local blOn = true
    local blBt = Instance.new("TextButton"); blBt.BackgroundTransparency=1; blBt.Size=UDim2.new(1,0,1,0); blBt.Text=""; blBt.ZIndex=9; blBt.Parent=blC
    blBt.MouseButton1Click:Connect(function()
        sndClick(); blOn = not blOn
        Tw3(blT,{BackgroundColor3=blOn and C.TogOn or C.TogOff},0.2)
        Tw3(blCr,{Position=blOn and UDim2.new(1,-19,0.5,0) or UDim2.new(0,3,0.5,0)},0.2)
        _G.NzBlur.Size = blOn and 5 or 0
    end)

    local rzC = Instance.new("Frame"); rzC.BackgroundColor3=C.Card; rzC.BackgroundTransparency=0.3; rzC.BorderSizePixel=0; rzC.Size=UDim2.new(1,-10,0,42); rzC.ZIndex=5; rzC.LayoutOrder=5; rzC.Parent=pSet; Cn3(rzC,10); Reg3(rzC,"BackgroundColor3","Card")
    local rzL = Instance.new("TextLabel"); rzL.BackgroundTransparency=1; rzL.Position=UDim2.new(0,14,0,0); rzL.Size=UDim2.new(1,-20,1,0); rzL.Font=Enum.Font.GothamMedium; rzL.Text=L().set_resize; rzL.TextColor3=C.TextDim; rzL.TextSize=13; rzL.TextXAlignment=Enum.TextXAlignment.Left; rzL.ZIndex=6; rzL.Parent=rzC; Reg3(rzL,"TextColor3","TextDim")

    local guiOpen = true
    UserInputService.InputBegan:Connect(function(inp, gpe)
        if gKL and not gpe and inp.UserInputType == Enum.UserInputType.Keyboard then
            gK = inp.KeyCode; gKB.Text = inp.KeyCode.Name; gKL = false
            Tw3(gKB,{BackgroundColor3=C.TagBg},0.15)
            Notify("Bind", "GUI: " .. inp.KeyCode.Name, nil, 2)
            return
        end
        if gpe then return end
        if not gKL and inp.UserInputType == Enum.UserInputType.Keyboard and inp.KeyCode == gK then
            guiOpen = not guiOpen
            if guiOpen then
                _G.NzGui.Enabled = true
                Tw3(_G.NzMain, {Size=UDim2.new(0, _G.NzGUI_W(), 0, _G.NzGUI_H()), BackgroundTransparency=_G.NzCurTheme().Trans}, 0.4, Enum.EasingStyle.Back)
                if blOn then _G.NzBlur.Size = 5 end
            else
                if sO then CS() end
                Tw3(_G.NzMain, {Size=UDim2.new(0,0,0,0), BackgroundTransparency=1}, 0.35)
                _G.NzBlur.Size = 0
                task.wait(0.35)
                if not guiOpen then _G.NzGui.Enabled = false end
            end
        end
    end)
end

StartMainScript = function()
    loadNzGUI()
    task.wait(0.5)
    loadAllFeatures()
    print("[Nz v2.0] Loaded! Default bind: RCtrl")
end

print("[Nz Loader v2.0] Started!")
