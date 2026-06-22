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
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")
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

    local function Cn(p,r) local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,r or 8);c.Parent=p;return c end
    local function St(p,col,t,tr) local s=Instance.new("UIStroke");s.Color=col or C.Border;s.Thickness=t or 1;s.Transparency=tr or 0.6;s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border;s.Parent=p;return s end
    local function Pd(p,t,b,l,r) local d=Instance.new("UIPadding");d.PaddingTop=UDim.new(0,t or 0);d.PaddingBottom=UDim.new(0,b or 0);d.PaddingLeft=UDim.new(0,l or 0);d.PaddingRight=UDim.new(0,r or 0);d.Parent=p;return d end
    local function Tw(o,pr,d,s) return TweenService:Create(o,TweenInfo.new(d or 0.25,s or Enum.EasingStyle.Quint,Enum.EasingDirection.Out),pr):Play() end

    local function MakeGrad(parent,c1,c2,rot,k1,k2)
        local g=Instance.new("UIGradient")
        g.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,c1 or Color3.new(1,1,1)),ColorSequenceKeypoint.new(1,c2 or Color3.new(0,0,0))}
        g.Rotation=rot or 0
        g.Parent=parent
        if k1 and k2 then
            table.insert(GradientReg,{el=parent,grad=g,k1=k1,k2=k2})
        end
        return g
    end

    local Gui=Instance.new("ScreenGui")
    Gui.Name="NzGUI"
    Gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
    Gui.ResetOnSpawn=false
    Gui.IgnoreGuiInset=true
    Gui.Parent=game.CoreGui

    local Blur=Instance.new("BlurEffect")
    Blur.Name="NzBlur"
    Blur.Size=0
    Blur.Parent=Lighting

    local GUI_W,GUI_H,SB_W=820,500,190

    local NCont=Instance.new("Frame")
    NCont.BackgroundTransparency=1
    NCont.Position=UDim2.new(1,-16,1,-16)
    NCont.AnchorPoint=Vector2.new(1,1)
    NCont.Size=UDim2.new(0,280,0,400)
    NCont.ZIndex=100
    NCont.Parent=Gui
    local nLay=Instance.new("UIListLayout")
    nLay.FillDirection=Enum.FillDirection.Vertical
    nLay.VerticalAlignment=Enum.VerticalAlignment.Bottom
    nLay.HorizontalAlignment=Enum.HorizontalAlignment.Right
    nLay.Padding=UDim.new(0,8)
    nLay.Parent=NCont

    local function Notify(title,msg,_,dur)
        local n=Instance.new("Frame")
        n.BackgroundColor3=C.Card;n.BackgroundTransparency=0.05;n.BorderSizePixel=0
        n.Size=UDim2.new(0,0,0,58);n.AnchorPoint=Vector2.new(1,0);n.ClipsDescendants=true;n.ZIndex=101;n.Parent=NCont
        Cn(n,12);St(n,C.Border,1,0.5)
        local bl=Instance.new("Frame")
        bl.BackgroundColor3=C.Accent;bl.BackgroundTransparency=0.75;bl.BorderSizePixel=0
        bl.Position=UDim2.new(0,12,0.5,0);bl.AnchorPoint=Vector2.new(0,0.5);bl.Size=UDim2.new(0,36,0,36);bl.ZIndex=102;bl.Parent=n;Cn(bl,18)
        local bb=Instance.new("Frame")
        bb.BackgroundColor3=C.Accent;bb.BorderSizePixel=0;bb.Position=UDim2.new(0.5,0,0.45,0);bb.AnchorPoint=Vector2.new(0.5,0.5)
        bb.Size=UDim2.new(0,13,0,14);bb.ZIndex=103;bb.Parent=bl
        Instance.new("UICorner",bb).CornerRadius=UDim.new(0.5,0)
        local bbs=Instance.new("Frame")
        bbs.BackgroundColor3=C.Accent;bbs.BorderSizePixel=0;bbs.Position=UDim2.new(0.5,0,0.72,0);bbs.AnchorPoint=Vector2.new(0.5,0.5)
        bbs.Size=UDim2.new(0,18,0,2);bbs.ZIndex=103;bbs.Parent=bl;Cn(bbs,1)
        local bbc=Instance.new("Frame")
        bbc.BackgroundColor3=C.Accent;bbc.BorderSizePixel=0;bbc.Position=UDim2.new(0.5,0,0.88,0);bbc.AnchorPoint=Vector2.new(0.5,0.5)
        bbc.Size=UDim2.new(0,3,0,3);bbc.ZIndex=103;bbc.Parent=bl;Cn(bbc,100)
        spawn(function()
            for _=1,3 do
                if not bl or not bl.Parent then return end
                Tw(bl,{Rotation=-15},0.12);task.wait(0.12)
                Tw(bl,{Rotation=15},0.18);task.wait(0.18)
                Tw(bl,{Rotation=0},0.12);task.wait(0.4)
            end
        end)
        local tl=Instance.new("TextLabel")
        tl.BackgroundTransparency=1;tl.Position=UDim2.new(0,58,0,8);tl.Size=UDim2.new(1,-68,0,18)
        tl.Font=Enum.Font.GothamBold;tl.Text=title;tl.TextColor3=C.Text;tl.TextSize=14
        tl.TextXAlignment=Enum.TextXAlignment.Left;tl.TextTransparency=1;tl.ZIndex=102;tl.Parent=n
        local ml=Instance.new("TextLabel")
        ml.BackgroundTransparency=1;ml.Position=UDim2.new(0,58,0,28);ml.Size=UDim2.new(1,-68,0,22)
        ml.Font=Enum.Font.Gotham;ml.Text=msg;ml.TextColor3=C.TextDim;ml.TextSize=13
        ml.TextXAlignment=Enum.TextXAlignment.Left;ml.TextTransparency=1;ml.ZIndex=102;ml.Parent=n
        Tw(n,{Size=UDim2.new(1,0,0,58)},0.4);task.wait(0.15)
        Tw(tl,{TextTransparency=0},0.3);Tw(ml,{TextTransparency=0.15},0.3)
        task.delay(dur or 2.5,function()
            if not n or not n.Parent then return end
            Tw(tl,{TextTransparency=1},0.2);Tw(ml,{TextTransparency=1},0.2);task.wait(0.15)
            Tw(n,{Size=UDim2.new(0,0,0,58),BackgroundTransparency=1},0.35);task.wait(0.4)
            if n and n.Parent then n:Destroy() end
        end)
    end

    local BL={}
    local function SB2(n,k,c) BL[n]={key=k,cb=c} end
    UserInputService.InputBegan:Connect(function(i,g) if g then return end; if i.UserInputType==Enum.UserInputType.Keyboard then for _,d in pairs(BL) do if d.key==i.KeyCode and d.cb then d.cb() end end end end)

    local Intro=Instance.new("Frame")
    Intro.BackgroundColor3=Color3.fromRGB(4,4,8);Intro.Size=UDim2.new(1,0,1,0);Intro.ZIndex=200;Intro.Parent=Gui

    local IC=Instance.new("Frame")
    IC.BackgroundTransparency=1;IC.Position=UDim2.new(0.5,0,0.5,0);IC.AnchorPoint=Vector2.new(0.5,0.5);IC.Size=UDim2.new(0,300,0,160);IC.ZIndex=201;IC.Parent=Intro

    local IL=Instance.new("Frame")
    IL.BackgroundColor3=C.Accent;IL.Position=UDim2.new(0.5,0,0,10);IL.AnchorPoint=Vector2.new(0.5,0);IL.Size=UDim2.new(0,0,0,0);IL.Rotation=-20;IL.ZIndex=202;IL.Parent=IC;Cn(IL,10);MakeGrad(IL,C.Accent,C.AccentGlow,45)

    local IT=Instance.new("TextLabel")
    IT.BackgroundTransparency=1;IT.Position=UDim2.new(0.5,0,0,68);IT.AnchorPoint=Vector2.new(0.5,0);IT.Size=UDim2.new(1,0,0,36);IT.Font=Enum.Font.GothamBold;IT.Text="Nz";IT.TextColor3=Color3.new(1,1,1);IT.TextTransparency=1;IT.TextSize=34;IT.ZIndex=202;IT.Parent=IC

    local IS=Instance.new("TextLabel")
    IS.BackgroundTransparency=1;IS.Position=UDim2.new(0.5,0,0,108);IS.AnchorPoint=Vector2.new(0.5,0);IS.Size=UDim2.new(1,0,0,18);IS.Font=Enum.Font.Gotham;IS.Text="";IS.TextColor3=Color3.fromRGB(140,140,170);IS.TextTransparency=1;IS.TextSize=14;IS.ZIndex=202;IS.Parent=IC

    local IB=Instance.new("Frame")
    IB.BackgroundColor3=Color3.fromRGB(40,40,60);IB.BackgroundTransparency=0.5;IB.BorderSizePixel=0;IB.Position=UDim2.new(0.5,0,0,135);IB.AnchorPoint=Vector2.new(0.5,0);IB.Size=UDim2.new(0,220,0,3);IB.ZIndex=202;IB.Parent=IC;Cn(IB,2)

    local IFl=Instance.new("Frame")
    IFl.BackgroundColor3=C.Accent;IFl.BorderSizePixel=0;IFl.Size=UDim2.new(0,0,1,0);IFl.ZIndex=203;IFl.Parent=IB;Cn(IFl,2);MakeGrad(IFl,C.Accent,C.AccentGlow,0)

    task.wait(0.2);Tw(IL,{Size=UDim2.new(0,52,0,52)},0.5,Enum.EasingStyle.Back);task.wait(0.35);Tw(IT,{TextTransparency=0},0.5);task.wait(0.2)
    IS.Text="Loading...";Tw(IS,{TextTransparency=0},0.3);task.wait(0.15);Tw(IFl,{Size=UDim2.new(0.4,0,1,0)},0.4);task.wait(0.3)
    IS.Text="60 themes ready";Tw(IFl,{Size=UDim2.new(0.75,0,1,0)},0.35);task.wait(0.3)
    IS.Text="Done!";Tw(IFl,{Size=UDim2.new(1,0,1,0)},0.25);task.wait(0.4)
    Tw(IL,{BackgroundTransparency=1,Size=UDim2.new(0,70,0,70)},0.4);Tw(IT,{TextTransparency=1},0.35);Tw(IS,{TextTransparency=1},0.3);Tw(IB,{BackgroundTransparency=1},0.3);Tw(IFl,{BackgroundTransparency=1},0.3)
    task.wait(0.25);Tw(Intro,{BackgroundTransparency=1},0.45);task.wait(0.5);Intro:Destroy()

    local Main=Instance.new("Frame")
    Main.Name="Main";Main.BackgroundColor3=C.Bg;Main.BackgroundTransparency=1;Main.BorderSizePixel=0
    Main.Position=UDim2.new(0.5,0,0.5,0);Main.AnchorPoint=Vector2.new(0.5,0.5);Main.Size=UDim2.new(0,0,0,0)
    Main.ClipsDescendants=true;Main.Parent=Gui;Cn(Main,14)
    local mS=St(Main,C.Border,1.5,0.35)
    Reg(Main,"BackgroundColor3","Bg");Reg(mS,"Color","Border")

    local RH=Instance.new("TextButton")
    RH.BackgroundTransparency=1;RH.Position=UDim2.new(1,-20,1,-20);RH.Size=UDim2.new(0,20,0,20);RH.Text="";RH.ZIndex=20;RH.Parent=Main
    for _,p in ipairs({{1,-4,1,-4},{1,-4,1,-11},{1,-11,1,-4}}) do
        local d=Instance.new("Frame");d.BackgroundColor3=C.TextDark;d.BorderSizePixel=0
        d.Position=UDim2.new(p[1],p[2],p[3],p[4]);d.AnchorPoint=Vector2.new(1,1)
        d.Size=UDim2.new(0,3,0,3);d.ZIndex=21;d.Parent=RH;Cn(d,100)
    end
    local rsz,rsI,rsS=false,nil,nil
    RH.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then
            rsz=true;rsI=i.Position;rsS=Main.Size
            i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then rsz=false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if rsz and i.UserInputType==Enum.UserInputType.MouseMovement then
            local d=i.Position-rsI
            GUI_W=math.clamp(rsS.X.Offset+d.X,600,1300);GUI_H=math.clamp(rsS.Y.Offset+d.Y,350,800)
            Main.Size=UDim2.new(0,GUI_W,0,GUI_H)
        end
    end)

    local SB=Instance.new("Frame")
    SB.BackgroundColor3=C.Sidebar;SB.BackgroundTransparency=0.02;SB.BorderSizePixel=0
    SB.Size=UDim2.new(0,SB_W,1,0);SB.ZIndex=5;SB.Parent=Main;Cn(SB,14)
    Reg(SB,"BackgroundColor3","Sidebar")
    MakeGrad(SB,CurTheme.Grad1,CurTheme.Grad2,180,"Grad1","Grad2")

    local SBMask=Instance.new("Frame")
    SBMask.BackgroundColor3=C.Sidebar;SBMask.BackgroundTransparency=0.02;SBMask.BorderSizePixel=0
    SBMask.Position=UDim2.new(1,-14,0,0);SBMask.Size=UDim2.new(0,14,1,0);SBMask.ZIndex=4;SBMask.Parent=SB
    Reg(SBMask,"BackgroundColor3","Sidebar")
    MakeGrad(SBMask,CurTheme.Grad1,CurTheme.Grad2,180,"Grad1","Grad2")

    local SBDv=Instance.new("Frame")
    SBDv.BackgroundColor3=C.Divider;SBDv.BackgroundTransparency=0.3;SBDv.BorderSizePixel=0
    SBDv.Position=UDim2.new(1,0,0,10);SBDv.Size=UDim2.new(0,1,1,-20);SBDv.ZIndex=6;SBDv.Parent=SB
    Reg(SBDv,"BackgroundColor3","Divider")

    local LF=Instance.new("Frame");LF.BackgroundTransparency=1;LF.Size=UDim2.new(1,0,0,66);LF.ZIndex=6;LF.Parent=SB
    local LI=Instance.new("Frame")
    LI.BackgroundColor3=C.Accent;LI.Position=UDim2.new(0,14,0,16);LI.Size=UDim2.new(0,32,0,32);LI.Rotation=-20;LI.ZIndex=7;LI.Parent=LF;Cn(LI,8)
    Reg(LI,"BackgroundColor3","Accent");MakeGrad(LI,C.Accent,C.AccentGlow,45)
    local LT=Instance.new("TextLabel")
    LT.BackgroundTransparency=1;LT.Position=UDim2.new(0,54,0,14);LT.Size=UDim2.new(1,-62,0,22)
    LT.Font=Enum.Font.GothamBold;LT.Text="Nz";LT.TextColor3=C.Text;LT.TextSize=20
    LT.TextXAlignment=Enum.TextXAlignment.Left;LT.ZIndex=7;LT.Parent=LF;Reg(LT,"TextColor3","Text")
    local LV=Instance.new("TextLabel")
    LV.BackgroundTransparency=1;LV.Position=UDim2.new(0,54,0,36);LV.Size=UDim2.new(1,-62,0,16)
    LV.Font=Enum.Font.Gotham;LV.Text="v7.0";LV.TextColor3=C.AccentDim;LV.TextSize=12
    LV.TextXAlignment=Enum.TextXAlignment.Left;LV.ZIndex=7;LV.Parent=LF;Reg(LV,"TextColor3","AccentDim")
    local LD=Instance.new("Frame")
    LD.BackgroundColor3=C.Divider;LD.BackgroundTransparency=0.3;LD.BorderSizePixel=0
    LD.Position=UDim2.new(0,12,1,-1);LD.Size=UDim2.new(1,-24,0,1);LD.ZIndex=7;LD.Parent=LF;Reg(LD,"BackgroundColor3","Divider")

    local TC2=Instance.new("Frame")
    TC2.BackgroundTransparency=1;TC2.Position=UDim2.new(0,0,0,72);TC2.Size=UDim2.new(1,0,1,-130);TC2.ZIndex=6;TC2.Parent=SB
    local TCL=Instance.new("UIListLayout")
    TCL.Padding=UDim.new(0,3);TCL.HorizontalAlignment=Enum.HorizontalAlignment.Center;TCL.SortOrder=Enum.SortOrder.LayoutOrder;TCL.Parent=TC2
    Pd(TC2,2,2,10,10)

    local Tabs={{Name="Overlay",Ic="//"},{Name="Themes",Ic="::"}}
    local TBtns,TPages,ActiveTab={},{},nil

    local PF=Instance.new("Frame")
    PF.BackgroundTransparency=1;PF.Position=UDim2.new(0,0,1,-56);PF.Size=UDim2.new(1,0,0,56);PF.ZIndex=6;PF.Parent=SB
    local PFD=Instance.new("Frame")
    PFD.BackgroundColor3=C.Divider;PFD.BackgroundTransparency=0.3;PFD.BorderSizePixel=0
    PFD.Position=UDim2.new(0,12,0,0);PFD.Size=UDim2.new(1,-24,0,1);PFD.ZIndex=7;PFD.Parent=PF;Reg(PFD,"BackgroundColor3","Divider")
    local PA=Instance.new("ImageLabel")
    PA.BackgroundColor3=C.Card;PA.Position=UDim2.new(0,12,0,12);PA.Size=UDim2.new(0,32,0,32);PA.ZIndex=7;PA.Parent=PF;Cn(PA,16)
    pcall(function() PA.Image=Players:GetUserThumbnailAsync(Player.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size48x48) end)
    local PN=Instance.new("TextLabel")
    PN.BackgroundTransparency=1;PN.Position=UDim2.new(0,50,0,12);PN.Size=UDim2.new(1,-58,0,18)
    PN.Font=Enum.Font.GothamMedium;PN.Text=Player.Name;PN.TextColor3=C.Text;PN.TextSize=13
    PN.TextXAlignment=Enum.TextXAlignment.Left;PN.ZIndex=7;PN.Parent=PF;Reg(PN,"TextColor3","Text")
    local PSb=Instance.new("TextLabel")
    PSb.BackgroundTransparency=1;PSb.Position=UDim2.new(0,50,0,30);PSb.Size=UDim2.new(1,-58,0,16)
    PSb.Font=Enum.Font.Gotham;PSb.Text="Premium";PSb.TextColor3=C.AccentDim;PSb.TextSize=11
    PSb.TextXAlignment=Enum.TextXAlignment.Left;PSb.ZIndex=7;PSb.Parent=PF;Reg(PSb,"TextColor3","AccentDim")

    local TB2=Instance.new("Frame")
    TB2.BackgroundColor3=C.TopBar;TB2.BackgroundTransparency=0.05;TB2.BorderSizePixel=0
    TB2.Position=UDim2.new(0,SB_W,0,0);TB2.Size=UDim2.new(1,-SB_W,0,48);TB2.ZIndex=8;TB2.Parent=Main
    Cn(TB2,14)
    Reg(TB2,"BackgroundColor3","TopBar")
    MakeGrad(TB2,CurTheme.TBGrad1,CurTheme.TBGrad2,90,"TBGrad1","TBGrad2")

    local TB2MaskBot=Instance.new("Frame")
    TB2MaskBot.BackgroundColor3=C.TopBar;TB2MaskBot.BackgroundTransparency=0.05;TB2MaskBot.BorderSizePixel=0
    TB2MaskBot.Position=UDim2.new(0,0,1,-14);TB2MaskBot.Size=UDim2.new(1,0,0,14);TB2MaskBot.ZIndex=8;TB2MaskBot.Parent=TB2
    Reg(TB2MaskBot,"BackgroundColor3","TopBar")
    MakeGrad(TB2MaskBot,CurTheme.TBGrad1,CurTheme.TBGrad2,90,"TBGrad1","TBGrad2")

    local TB2MaskLeft=Instance.new("Frame")
    TB2MaskLeft.BackgroundColor3=C.TopBar;TB2MaskLeft.BackgroundTransparency=0.05;TB2MaskLeft.BorderSizePixel=0
    TB2MaskLeft.Position=UDim2.new(0,0,0,0);TB2MaskLeft.Size=UDim2.new(0,14,0,34);TB2MaskLeft.ZIndex=8;TB2MaskLeft.Parent=TB2
    Reg(TB2MaskLeft,"BackgroundColor3","TopBar")
    MakeGrad(TB2MaskLeft,CurTheme.TBGrad1,CurTheme.TBGrad2,90,"TBGrad1","TBGrad2")

    local TS=Instance.new("ScrollingFrame")
    TS.BackgroundTransparency=1;TS.Position=UDim2.new(0,15,0,0);TS.Size=UDim2.new(1,-30,1,0)
    TS.CanvasSize=UDim2.new(0,0,0,0);TS.AutomaticCanvasSize=Enum.AutomaticSize.X
    TS.ScrollBarThickness=0;TS.ScrollingDirection=Enum.ScrollingDirection.X
    TS.ZIndex=9;TS.ClipsDescendants=true;TS.Parent=TB2
    local tsL=Instance.new("UIListLayout")
    tsL.FillDirection=Enum.FillDirection.Horizontal;tsL.VerticalAlignment=Enum.VerticalAlignment.Center
    tsL.Padding=UDim.new(0,6);tsL.SortOrder=Enum.SortOrder.LayoutOrder;tsL.Parent=TS

    local TBDv=Instance.new("Frame")
    TBDv.BackgroundColor3=C.Divider;TBDv.BackgroundTransparency=0.3;TBDv.BorderSizePixel=0
    TBDv.Position=UDim2.new(0,SB_W,0,48);TBDv.Size=UDim2.new(1,-SB_W,0,1);TBDv.ZIndex=9;TBDv.Parent=Main
    Reg(TBDv,"BackgroundColor3","Divider")

    local Co=Instance.new("Frame")
    Co.BackgroundTransparency=1
    Co.Position=UDim2.new(0,SB_W+10,0,55)
    Co.Size=UDim2.new(1,-SB_W-20,1,-65)
    Co.ZIndex=3;Co.ClipsDescendants=true;Co.Parent=Main

    local dr,dI,dS,sP
    local function SDD(i) dr=true;dS=i.Position;sP=Main.Position;i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dr=false end end) end
    TB2.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then SDD(i) end end)
    TB2.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement then dI=i end end)
    SB.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then SDD(i) end end)
    SB.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement then dI=i end end)
    UserInputService.InputChanged:Connect(function(i)
        if i==dI and dr then
            local d=i.Position-dS
            Tw(Main,{Position=UDim2.new(sP.X.Scale,sP.X.Offset+d.X,sP.Y.Scale,sP.Y.Offset+d.Y)},0.06)
        end
    end)

    local TE={}
    local function AT(n)
        if TE[n] then return end
        local t=Instance.new("Frame")
        t.BackgroundColor3=C.AccentSoft;t.BackgroundTransparency=0.2;t.BorderSizePixel=0
        t.Size=UDim2.new(0,0,0,30);t.ZIndex=10;t.ClipsDescendants=true;t.Parent=TS;Cn(t,7)
        local d=Instance.new("Frame")
        d.BackgroundColor3=C.Accent;d.BorderSizePixel=0;d.Size=UDim2.new(0,6,0,6)
        d.Position=UDim2.new(0,10,0.5,0);d.AnchorPoint=Vector2.new(0,0.5);d.ZIndex=11;d.Parent=t;Cn(d,100)
        spawn(function()
            while d and d.Parent do
                Tw(d,{BackgroundTransparency=0.6},0.7,Enum.EasingStyle.Sine);task.wait(0.7)
                Tw(d,{BackgroundTransparency=0},0.7,Enum.EasingStyle.Sine);task.wait(0.7)
            end
        end)
        local tx=Instance.new("TextLabel")
        tx.BackgroundTransparency=1;tx.Position=UDim2.new(0,20,0,0);tx.Size=UDim2.new(1,-26,1,0)
        tx.Font=Enum.Font.GothamMedium;tx.Text=n;tx.TextColor3=C.AccentGlow;tx.TextSize=12;tx.ZIndex=11;tx.Parent=t
        local w=TextService:GetTextSize(n,12,Enum.Font.GothamMedium,Vector2.new(1000,30))
        Tw(t,{Size=UDim2.new(0,w.X+30,0,30)},0.3)
        TE[n]=t
    end
    local function RT(n)
        if not TE[n] then return end
        Tw(TE[n],{Size=UDim2.new(0,0,0,30)},0.25)
        task.delay(0.3,function() if TE[n] and TE[n].Parent then TE[n]:Destroy() end end)
        TE[n]=nil
    end

    local function MP(n)
        local s=Instance.new("ScrollingFrame")
        s.Name=n;s.BackgroundTransparency=1;s.BorderSizePixel=0
        s.Size=UDim2.new(1,0,1,0);s.CanvasSize=UDim2.new(0,0,0,0)
        s.AutomaticCanvasSize=Enum.AutomaticSize.Y;s.ScrollBarThickness=4
        s.ScrollBarImageColor3=C.Accent;s.ScrollBarImageTransparency=0.5
        s.ScrollingDirection=Enum.ScrollingDirection.Y;s.ZIndex=4
        s.Visible=false;s.ClipsDescendants=true;s.Parent=Co
        local l=Instance.new("UIListLayout")
        l.Padding=UDim.new(0,14)
        l.HorizontalAlignment=Enum.HorizontalAlignment.Center
        l.SortOrder=Enum.SortOrder.LayoutOrder;l.Parent=s
        Pd(s,15,15,10,15)
        return s
    end

    local function STT(n)
        if ActiveTab==n then return end
        ActiveTab=n
        for nn,p in pairs(TPages) do p.Visible=(nn==n) end
        for nn,b in pairs(TBtns) do
            local a=(nn==n)
            Tw(b,{BackgroundColor3=a and C.AccentSoft or C.Sidebar,BackgroundTransparency=a and 0.15 or 1},0.2)
            local lb=b:FindFirstChild("L");if lb then Tw(lb,{TextColor3=a and C.Text or C.TextDim},0.2) end
            local ic=b:FindFirstChild("I");if ic then Tw(ic,{TextColor3=a and C.Accent or C.TextDim},0.2) end
            local ln=b:FindFirstChild("Ln");if ln then Tw(ln,{BackgroundTransparency=a and 0 or 1},0.2) end
        end
    end

    for i,td in ipairs(Tabs) do
        local b=Instance.new("TextButton")
        b.Name=td.Name;b.BackgroundColor3=C.Sidebar;b.BackgroundTransparency=1;b.BorderSizePixel=0
        b.Size=UDim2.new(1,0,0,38);b.Text="";b.ZIndex=7;b.AutoButtonColor=false;b.LayoutOrder=i;b.Parent=TC2;Cn(b,8)
        local ln=Instance.new("Frame")
        ln.Name="Ln";ln.BackgroundColor3=C.Accent;ln.BackgroundTransparency=1;ln.BorderSizePixel=0
        ln.Position=UDim2.new(0,0,0.15,0);ln.Size=UDim2.new(0,3,0.7,0);ln.ZIndex=8;ln.Parent=b;Cn(ln,2)
        Reg(ln,"BackgroundColor3","Accent")
        local ic=Instance.new("TextLabel")
        ic.Name="I";ic.BackgroundTransparency=1;ic.Position=UDim2.new(0,14,0,0);ic.Size=UDim2.new(0,22,1,0)
        ic.Font=Enum.Font.GothamBold;ic.Text=td.Ic;ic.TextColor3=C.TextDim;ic.TextSize=16;ic.ZIndex=8;ic.Parent=b
        local lb=Instance.new("TextLabel")
        lb.Name="L";lb.BackgroundTransparency=1;lb.Position=UDim2.new(0,42,0,0);lb.Size=UDim2.new(1,-48,1,0)
        lb.Font=Enum.Font.GothamMedium;lb.Text=td.Name;lb.TextColor3=C.TextDim;lb.TextSize=14
        lb.TextXAlignment=Enum.TextXAlignment.Left;lb.ZIndex=8;lb.Parent=b
        b.MouseEnter:Connect(function() if ActiveTab~=td.Name then Tw(b,{BackgroundTransparency=0.5},0.12) end end)
        b.MouseLeave:Connect(function() if ActiveTab~=td.Name then Tw(b,{BackgroundTransparency=1},0.12) end end)
        b.MouseButton1Click:Connect(function() STT(td.Name) end)
        TBtns[td.Name]=b;TPages[td.Name]=MP(td.Name)
    end

    local SW=Instance.new("Frame")
    SW.BackgroundColor3=C.SettBg;SW.BackgroundTransparency=0.04;SW.BorderSizePixel=0
    SW.Position=UDim2.new(0.5,0,0.5,0);SW.AnchorPoint=Vector2.new(0.5,0.5);SW.Size=UDim2.new(0,0,0,0)
    SW.ZIndex=80;SW.ClipsDescendants=true;SW.Visible=false;SW.Parent=Gui;Cn(SW,12)
    St(SW,C.Border,1.5,0.35);Reg(SW,"BackgroundColor3","SettBg")

    local SWT=Instance.new("TextLabel")
    SWT.BackgroundTransparency=1;SWT.Position=UDim2.new(0,16,0,0);SWT.Size=UDim2.new(1,-56,0,46)
    SWT.Font=Enum.Font.GothamBold;SWT.Text="Settings";SWT.TextColor3=C.Text;SWT.TextSize=16
    SWT.TextXAlignment=Enum.TextXAlignment.Left;SWT.ZIndex=81;SWT.Parent=SW;Reg(SWT,"TextColor3","Text")

    local SWX=Instance.new("TextButton")
    SWX.BackgroundColor3=C.Card;SWX.BackgroundTransparency=0.3;SWX.BorderSizePixel=0
    SWX.Position=UDim2.new(1,-40,0,8);SWX.Size=UDim2.new(0,30,0,30)
    SWX.Font=Enum.Font.GothamBold;SWX.Text="x";SWX.TextColor3=Color3.fromRGB(255,80,80);SWX.TextSize=18
    SWX.ZIndex=82;SWX.AutoButtonColor=false;SWX.Parent=SW;Cn(SWX,8)

    local SWD=Instance.new("Frame")
    SWD.BackgroundColor3=C.Divider;SWD.BackgroundTransparency=0.3;SWD.BorderSizePixel=0
    SWD.Position=UDim2.new(0,10,0,46);SWD.Size=UDim2.new(1,-20,0,1);SWD.ZIndex=81;SWD.Parent=SW

    local SWC=Instance.new("ScrollingFrame")
    SWC.BackgroundTransparency=1;SWC.Position=UDim2.new(0,0,0,50);SWC.Size=UDim2.new(1,0,1,-50)
    SWC.CanvasSize=UDim2.new(0,0,0,0);SWC.AutomaticCanvasSize=Enum.AutomaticSize.Y
    SWC.ScrollBarThickness=2;SWC.ScrollBarImageColor3=C.Accent;SWC.ZIndex=81;SWC.ClipsDescendants=true;SWC.Parent=SW
    local swcL=Instance.new("UIListLayout")
    swcL.Padding=UDim.new(0,6);swcL.HorizontalAlignment=Enum.HorizontalAlignment.Center
    swcL.SortOrder=Enum.SortOrder.LayoutOrder;swcL.Parent=SWC
    Pd(SWC,8,8,12,12)

    local sO=false
    local function OS(n,b)
        for _,ch in ipairs(SWC:GetChildren()) do
            if not ch:IsA("UIListLayout") and not ch:IsA("UIPadding") then ch:Destroy() end
        end
        SWT.Text=n;if b then b(SWC) end
        SW.Visible=true;SW.Position=UDim2.new(0.5,0,0.5,0)
        Tw(SW,{Size=UDim2.new(0,340,0,380)},0.35,Enum.EasingStyle.Back);sO=true
    end
    local function CS() Tw(SW,{Size=UDim2.new(0,0,0,0)},0.3);task.delay(0.35,function() SW.Visible=false end);sO=false end
    SWX.MouseButton1Click:Connect(CS)

    local SC={}
    function SC.Slider(p,n,mn,mx,df,u,cb)
        local c=Instance.new("Frame");c.BackgroundColor3=C.Card;c.BackgroundTransparency=0.3;c.BorderSizePixel=0
        c.Size=UDim2.new(1,0,0,54);c.ZIndex=82;c.Parent=p;Cn(c,8)
        local l=Instance.new("TextLabel");l.BackgroundTransparency=1;l.Position=UDim2.new(0,12,0,5);l.Size=UDim2.new(0.55,-12,0,20)
        l.Font=Enum.Font.GothamMedium;l.Text=n;l.TextColor3=C.Text;l.TextSize=13;l.TextXAlignment=Enum.TextXAlignment.Left;l.ZIndex=83;l.Parent=c
        local v=Instance.new("TextLabel");v.BackgroundTransparency=1;v.Position=UDim2.new(0.55,0,0,5);v.Size=UDim2.new(0.45,-12,0,20)
        v.Font=Enum.Font.GothamBold;v.Text=df..(u or "");v.TextColor3=C.AccentGlow;v.TextSize=13;v.TextXAlignment=Enum.TextXAlignment.Right;v.ZIndex=83;v.Parent=c
        local bg=Instance.new("Frame");bg.BackgroundColor3=C.SliderBg;bg.BorderSizePixel=0;bg.Position=UDim2.new(0,12,0,32);bg.Size=UDim2.new(1,-24,0,7);bg.ZIndex=84;bg.Parent=c;Cn(bg,3)
        local fl=Instance.new("Frame");fl.BackgroundColor3=C.Accent;fl.BorderSizePixel=0;fl.Size=UDim2.new((df-mn)/(mx-mn),0,1,0);fl.ZIndex=85;fl.Parent=bg;Cn(fl,3);MakeGrad(fl,C.Accent,C.AccentGlow,0)
        local kn=Instance.new("Frame");kn.BackgroundColor3=C.Knob;kn.BorderSizePixel=0;kn.Size=UDim2.new(0,14,0,14);kn.Position=UDim2.new(1,0,0.5,0);kn.AnchorPoint=Vector2.new(0.5,0.5);kn.ZIndex=86;kn.Parent=fl;Cn(kn,100);St(kn,C.Accent,2,0)
        local sb=Instance.new("TextButton");sb.BackgroundTransparency=1;sb.Size=UDim2.new(1,0,1,16);sb.Position=UDim2.new(0,0,0.5,0);sb.AnchorPoint=Vector2.new(0,0.5);sb.Text="";sb.ZIndex=87;sb.Parent=bg
        local sl=false
        local function up(i) local pp=math.clamp((i.Position.X-bg.AbsolutePosition.X)/bg.AbsoluteSize.X,0,1);local cv=math.floor(mn+(mx-mn)*pp);v.Text=cv..(u or "");Tw(fl,{Size=UDim2.new(pp,0,1,0)},0.06);if cb then cb(cv) end end
        sb.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then sl=true;up(i) end end)
        UserInputService.InputChanged:Connect(function(i) if sl and i.UserInputType==Enum.UserInputType.MouseMovement then up(i) end end)
        UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then sl=false end end)
    end

    function SC.Toggle(p,n,df,cb)
        local c=Instance.new("Frame");c.BackgroundColor3=C.Card;c.BackgroundTransparency=0.3;c.BorderSizePixel=0;c.Size=UDim2.new(1,0,0,40);c.ZIndex=82;c.Parent=p;Cn(c,8)
        local l=Instance.new("TextLabel");l.BackgroundTransparency=1;l.Position=UDim2.new(0,12,0,0);l.Size=UDim2.new(1,-60,1,0)
        l.Font=Enum.Font.GothamMedium;l.Text=n;l.TextColor3=C.Text;l.TextSize=13;l.TextXAlignment=Enum.TextXAlignment.Left;l.ZIndex=83;l.Parent=c
        local tb=Instance.new("Frame");tb.BackgroundColor3=df and C.TogOn or C.TogOff;tb.BorderSizePixel=0;tb.Position=UDim2.new(1,-48,0.5,0);tb.AnchorPoint=Vector2.new(0,0.5);tb.Size=UDim2.new(0,36,0,20);tb.ZIndex=84;tb.Parent=c;Cn(tb,10)
        local cr=Instance.new("Frame");cr.BackgroundColor3=C.Knob;cr.BorderSizePixel=0;cr.Size=UDim2.new(0,14,0,14);cr.Position=df and UDim2.new(1,-17,0.5,0) or UDim2.new(0,3,0.5,0);cr.AnchorPoint=Vector2.new(0,0.5);cr.ZIndex=85;cr.Parent=tb;Cn(cr,100)
        local on=df or false
        local bt=Instance.new("TextButton");bt.BackgroundTransparency=1;bt.Size=UDim2.new(1,0,1,0);bt.Text="";bt.ZIndex=86;bt.Parent=c
        bt.MouseButton1Click:Connect(function() on=not on;Tw(tb,{BackgroundColor3=on and C.TogOn or C.TogOff},0.2);Tw(cr,{Position=on and UDim2.new(1,-17,0.5,0) or UDim2.new(0,3,0.5,0)},0.2);if cb then cb(on) end end)
    end

    function SC.Dropdown(p,n,o,df,cb)
        local e=false
        local c=Instance.new("Frame");c.BackgroundColor3=C.Card;c.BackgroundTransparency=0.3;c.BorderSizePixel=0;c.Size=UDim2.new(1,0,0,40);c.ZIndex=82;c.ClipsDescendants=true;c.Parent=p;Cn(c,8)
        local l=Instance.new("TextLabel");l.BackgroundTransparency=1;l.Position=UDim2.new(0,12,0,0);l.Size=UDim2.new(0.45,0,0,40)
        l.Font=Enum.Font.GothamMedium;l.Text=n;l.TextColor3=C.Text;l.TextSize=13;l.TextXAlignment=Enum.TextXAlignment.Left;l.ZIndex=83;l.Parent=c
        local s=Instance.new("TextLabel");s.BackgroundTransparency=1;s.Position=UDim2.new(0.45,0,0,0);s.Size=UDim2.new(0.55,-30,0,40)
        s.Font=Enum.Font.GothamMedium;s.Text=df or o[1];s.TextColor3=C.AccentGlow;s.TextSize=12;s.TextXAlignment=Enum.TextXAlignment.Right;s.ZIndex=83;s.Parent=c
        local a=Instance.new("TextLabel");a.BackgroundTransparency=1;a.Position=UDim2.new(1,-22,0,0);a.Size=UDim2.new(0,16,0,40)
        a.Font=Enum.Font.GothamBold;a.Text="v";a.TextColor3=C.TextDim;a.TextSize=12;a.ZIndex=83;a.Parent=c
        local of=Instance.new("Frame");of.BackgroundTransparency=1;of.Position=UDim2.new(0,4,0,42);of.Size=UDim2.new(1,-8,0,#o*30);of.ZIndex=84;of.Parent=c
        local ofL=Instance.new("UIListLayout");ofL.Padding=UDim.new(0,2);ofL.Parent=of
        for _,opt in ipairs(o) do
            local ob=Instance.new("TextButton");ob.BackgroundColor3=C.Sidebar;ob.BackgroundTransparency=0.3;ob.BorderSizePixel=0;ob.Size=UDim2.new(1,0,0,28)
            ob.Font=Enum.Font.GothamMedium;ob.Text=opt;ob.TextColor3=C.TextDim;ob.TextSize=12;ob.ZIndex=85;ob.AutoButtonColor=false;ob.Parent=of;Cn(ob,6)
            ob.MouseEnter:Connect(function() Tw(ob,{BackgroundTransparency=0.05,TextColor3=C.Text},0.1) end)
            ob.MouseLeave:Connect(function() Tw(ob,{BackgroundTransparency=0.3,TextColor3=C.TextDim},0.1) end)
            ob.MouseButton1Click:Connect(function() s.Text=opt;e=false;Tw(c,{Size=UDim2.new(1,0,0,40)},0.2);Tw(a,{Rotation=0},0.2);if cb then cb(opt) end end)
        end
        local hb=Instance.new("TextButton");hb.BackgroundTransparency=1;hb.Size=UDim2.new(1,0,0,40);hb.Text="";hb.ZIndex=86;hb.Parent=c
        hb.MouseButton1Click:Connect(function() e=not e;Tw(c,{Size=UDim2.new(1,0,0,e and (44+#o*32) or 40)},0.25);Tw(a,{Rotation=e and 180 or 0},0.25) end)
    end

    function SC.Label(p,t)
        local l=Instance.new("TextLabel");l.BackgroundTransparency=1;l.Size=UDim2.new(1,0,0,18)
        l.Font=Enum.Font.GothamBold;l.Text=t;l.TextColor3=C.TextDim;l.TextSize=12;l.TextXAlignment=Enum.TextXAlignment.Left;l.ZIndex=82;l.Parent=p
    end

    local function FCTile(pr,cf)
        local nm=cf.Name
        local cd=Instance.new("Frame")
        cd.Name=nm;cd.BackgroundColor3=C.Card;cd.BackgroundTransparency=0.25;cd.BorderSizePixel=0
        cd.Size=UDim2.new(1,0,1,0);cd.ZIndex=5;cd.LayoutOrder=cf.Order or 0;cd.Parent=pr
        Cn(cd,12)
        local cs=St(cd,C.Border,1.2,0.7)
        Reg(cd,"BackgroundColor3","Card");Reg(cs,"Color","Border")

        local gw=Instance.new("UIStroke")
        gw.Color=C.Accent;gw.Thickness=2;gw.Transparency=1;gw.ApplyStrokeMode=Enum.ApplyStrokeMode.Border;gw.Parent=cd

        local iconBg=Instance.new("Frame")
        iconBg.BackgroundColor3=C.Accent;iconBg.BackgroundTransparency=0.8;iconBg.BorderSizePixel=0
        iconBg.Position=UDim2.new(0,14,0,14);iconBg.Size=UDim2.new(0,38,0,38);iconBg.ZIndex=6;iconBg.Parent=cd
        Cn(iconBg,10)

        local iconTxt=Instance.new("TextLabel")
        iconTxt.BackgroundTransparency=1;iconTxt.Size=UDim2.new(1,0,1,0)
        iconTxt.Font=Enum.Font.GothamBold;iconTxt.Text=nm:sub(1,1):upper();iconTxt.TextColor3=C.Accent;iconTxt.TextSize=20
        iconTxt.ZIndex=7;iconTxt.Parent=iconBg

        local nl=Instance.new("TextLabel")
        nl.BackgroundTransparency=1;nl.Position=UDim2.new(0,62,0,14);nl.Size=UDim2.new(1,-72,0,20)
        nl.Font=Enum.Font.GothamBold;nl.Text=nm;nl.TextColor3=C.Text;nl.TextSize=14
        nl.TextXAlignment=Enum.TextXAlignment.Left;nl.ZIndex=6;nl.Parent=cd
        Reg(nl,"TextColor3","Text")

        local stTxt=Instance.new("TextLabel")
        stTxt.Name="StTxt";stTxt.BackgroundTransparency=1
        stTxt.Position=UDim2.new(0,62,0,34);stTxt.Size=UDim2.new(1,-72,0,16)
        stTxt.Font=Enum.Font.Gotham;stTxt.Text="Отключено";stTxt.TextColor3=C.TextDim;stTxt.TextSize=11
        stTxt.TextXAlignment=Enum.TextXAlignment.Left;stTxt.ZIndex=6;stTxt.Parent=cd
        Reg(stTxt,"TextColor3","TextDim")

        local bottomPanel=Instance.new("Frame")
        bottomPanel.BackgroundTransparency=1;bottomPanel.Position=UDim2.new(0,12,1,-32);bottomPanel.Size=UDim2.new(1,-24,0,28);bottomPanel.ZIndex=6;bottomPanel.Parent=cd

        local bb=Instance.new("TextButton")
        bb.BackgroundColor3=C.TagBg;bb.BackgroundTransparency=0.2;bb.BorderSizePixel=0
        bb.Position=UDim2.new(0,0,0.5,0);bb.AnchorPoint=Vector2.new(0,0.5);bb.Size=UDim2.new(0,52,0,24)
        bb.Font=Enum.Font.GothamBold;bb.Text="NONE";bb.TextColor3=C.TextDim;bb.TextSize=10
        bb.ZIndex=7;bb.AutoButtonColor=false;bb.Parent=bottomPanel;Cn(bb,6)

        local gr=Instance.new("TextButton")
        gr.BackgroundTransparency=1;gr.Position=UDim2.new(0,60,0.5,0);gr.AnchorPoint=Vector2.new(0,0.5)
        gr.Size=UDim2.new(0,24,0,24);gr.Font=Enum.Font.GothamBold;gr.Text="*";gr.TextColor3=C.TextDim;gr.TextSize=20
        gr.ZIndex=7;gr.AutoButtonColor=false;gr.Parent=bottomPanel

        local tb=Instance.new("Frame")
        tb.BackgroundColor3=C.TogOff;tb.BorderSizePixel=0
        tb.Position=UDim2.new(1,0,0.5,0);tb.AnchorPoint=Vector2.new(1,0.5);tb.Size=UDim2.new(0,38,0,22)
        tb.ZIndex=7;tb.Parent=bottomPanel;Cn(tb,11)

        local tc=Instance.new("Frame")
        tc.BackgroundColor3=C.Knob;tc.BorderSizePixel=0;tc.Size=UDim2.new(0,16,0,16)
        tc.Position=UDim2.new(0,3,0.5,0);tc.AnchorPoint=Vector2.new(0,0.5);tc.ZIndex=8;tc.Parent=tb;Cn(tc,100)

        local en=cf.Default or false
        local function SS(s,si)
            en=s
            if s then
                Tw(tb,{BackgroundColor3=C.TogOn},0.25)
                Tw(tc,{Position=UDim2.new(1,-19,0.5,0)},0.25)
                Tw(cd,{BackgroundColor3=C.CardActive,BackgroundTransparency=0.1},0.3)
                Tw(gw,{Transparency=0.2},0.3)
                Tw(nl,{TextColor3=C.AccentGlow},0.2)
                stTxt.Text="Активно"
                Tw(stTxt,{TextColor3=C.Accent},0.2)
                Tw(iconBg,{BackgroundTransparency=0.5},0.2)
                AT(nm)
                if not si then Notify(nm,"Функция активирована",nil,2.5) end
            else
                Tw(tb,{BackgroundColor3=C.TogOff},0.25)
                Tw(tc,{Position=UDim2.new(0,3,0.5,0)},0.25)
                Tw(cd,{BackgroundColor3=C.Card,BackgroundTransparency=0.25},0.3)
                Tw(gw,{Transparency=1},0.3)
                Tw(nl,{TextColor3=C.Text},0.2)
                stTxt.Text="Отключено"
                Tw(stTxt,{TextColor3=C.TextDim},0.2)
                Tw(iconBg,{BackgroundTransparency=0.8},0.2)
                RT(nm)
                if not si then Notify(nm,"Функция деактивирована",nil,2.5) end
            end
            if cf.OnToggle then cf.OnToggle(s) end
        end
        if cf.Default then SS(true,true) end

        local tB=Instance.new("TextButton")
        tB.BackgroundTransparency=1;tB.Position=UDim2.new(1,-44,0,0);tB.Size=UDim2.new(0,44,1,0);tB.Text="";tB.ZIndex=9;tB.Parent=bottomPanel
        tB.MouseButton1Click:Connect(function() SS(not en) end)

        gr.MouseButton1Click:Connect(function() OS(nm,cf.Settings or function(c) SC.Label(c,"No settings") end) end)
        gr.MouseEnter:Connect(function() Tw(gr,{TextColor3=C.Accent,Rotation=45},0.2) end)
        gr.MouseLeave:Connect(function() Tw(gr,{TextColor3=C.TextDim,Rotation=0},0.2) end)

        local li=false
        if cf.Bind then bb.Text=cf.Bind.Name;SB2(nm,cf.Bind,function() SS(not en) end) end
        bb.MouseButton1Click:Connect(function() li=true;bb.Text="...";Tw(bb,{BackgroundColor3=C.Accent,BackgroundTransparency=0.1},0.15) end)
        UserInputService.InputBegan:Connect(function(inp,gpe)
            if li and not gpe and inp.UserInputType==Enum.UserInputType.Keyboard then
                if inp.KeyCode==Enum.KeyCode.Escape then bb.Text="NONE";BL[nm]=nil
                else bb.Text=inp.KeyCode.Name;SB2(nm,inp.KeyCode,function() SS(not en) end) end
                li=false;Tw(bb,{BackgroundColor3=C.TagBg,BackgroundTransparency=0.2},0.15)
                Notify("Keybind",nm.." -> "..bb.Text,nil,2)
            end
        end)
    end

    local pOv=TPages["Overlay"]

    local ovH=Instance.new("TextLabel")
    ovH.BackgroundTransparency=1;ovH.Size=UDim2.new(1,-10,0,28);ovH.Font=Enum.Font.GothamBold
    ovH.Text="Overlay Modules";ovH.TextColor3=C.Text;ovH.TextSize=16;ovH.TextXAlignment=Enum.TextXAlignment.Left
    ovH.ZIndex=5;ovH.LayoutOrder=1;ovH.Parent=pOv
    Reg(ovH,"TextColor3","Text")

    local gOv=Instance.new("Frame")
    gOv.BackgroundTransparency=1;gOv.Size=UDim2.new(1,-10,0,0);gOv.AutomaticSize=Enum.AutomaticSize.Y
    gOv.ZIndex=4;gOv.LayoutOrder=2;gOv.Parent=pOv
    local glOv=Instance.new("UIGridLayout")
    glOv.CellSize=UDim2.new(0,180,0,110)
    glOv.CellPadding=UDim2.new(0,12,0,12)
    glOv.SortOrder=Enum.SortOrder.LayoutOrder
    glOv.FillDirectionMaxCells=3
    glOv.HorizontalAlignment=Enum.HorizontalAlignment.Center
    glOv.Parent=gOv

    local wF
    FCTile(gOv,{Name="Watermark",Order=1,Settings=function(c) SC.Toggle(c,"Show FPS",true) end,OnToggle=function(s)
        if s then
            wF=Instance.new("Frame");wF.BackgroundColor3=C.Card;wF.BackgroundTransparency=0.15;wF.BorderSizePixel=0
            wF.Position=UDim2.new(1,-260,0,8);wF.Size=UDim2.new(0,250,0,32);wF.ZIndex=90;wF.Parent=Gui;Cn(wF,8);St(wF,C.Accent,1,0.5)
            local wt=Instance.new("TextLabel");wt.Name="WT";wt.BackgroundTransparency=1;wt.Size=UDim2.new(1,0,1,0)
            wt.Font=Enum.Font.GothamBold;wt.Text="Nz | "..Player.Name;wt.TextColor3=C.Text;wt.TextSize=13;wt.ZIndex=91;wt.Parent=wF
            spawn(function() while wF and wF.Parent do local fps=math.floor(1/RunService.Heartbeat:Wait());if wF and wF:FindFirstChild("WT") then wF.WT.Text="Nz | "..Player.Name.." | "..fps.." FPS" end end end)
        else if wF then wF:Destroy();wF=nil end end
    end})

    local fF
    FCTile(gOv,{Name="FPSCounter",Order=2,Settings=function(c) SC.Dropdown(c,"Position",{"Top","Bottom"},"Top") end,OnToggle=function(s)
        if s then
            fF=Instance.new("TextLabel");fF.BackgroundColor3=C.Card;fF.BackgroundTransparency=0.2;fF.BorderSizePixel=0
            fF.Position=UDim2.new(0.5,0,0,8);fF.AnchorPoint=Vector2.new(0.5,0);fF.Size=UDim2.new(0,95,0,30)
            fF.Font=Enum.Font.GothamBold;fF.Text="0 FPS";fF.TextColor3=C.AccentGlow;fF.TextSize=15;fF.ZIndex=90;fF.Parent=Gui
            Cn(fF,8);St(fF,C.Accent,1,0.5)
            spawn(function() while fF and fF.Parent do local fps=math.floor(1/RunService.Heartbeat:Wait());if fF then fF.Text=fps.." FPS" end end end)
        else if fF then fF:Destroy();fF=nil end end
    end})

    local cF
    FCTile(gOv,{Name="Coords",Order=3,Settings=function(c) SC.Dropdown(c,"Position",{"Top Left","Bottom"},"Top Left") end,OnToggle=function(s)
        if s then
            cF=Instance.new("TextLabel");cF.BackgroundColor3=C.Card;cF.BackgroundTransparency=0.2;cF.BorderSizePixel=0
            cF.Position=UDim2.new(0,8,0,46);cF.Size=UDim2.new(0,230,0,26)
            cF.Font=Enum.Font.GothamMedium;cF.Text="X:0 Y:0 Z:0";cF.TextColor3=C.Text;cF.TextSize=13
            cF.TextXAlignment=Enum.TextXAlignment.Left;cF.ZIndex=90;cF.Parent=Gui;Cn(cF,6);Pd(cF,0,0,10,0)
            spawn(function() while cF and cF.Parent do task.wait(0.1);local ch=Player.Character;if ch and ch:FindFirstChild("HumanoidRootPart") and cF then local pp=ch.HumanoidRootPart.Position;cF.Text=string.format("X:%.0f Y:%.0f Z:%.0f",pp.X,pp.Y,pp.Z) end end end)
        else if cF then cF:Destroy();cF=nil end end
    end})

    local pF
    FCTile(gOv,{Name="PingDisplay",Order=4,Settings=function(c) SC.Toggle(c,"Color Coded",true) end,OnToggle=function(s)
        if s then
            pF=Instance.new("TextLabel");pF.BackgroundColor3=C.Card;pF.BackgroundTransparency=0.2;pF.BorderSizePixel=0
            pF.Position=UDim2.new(0,8,0,8);pF.Size=UDim2.new(0,100,0,26)
            pF.Font=Enum.Font.GothamBold;pF.Text="0 ms";pF.TextColor3=C.AccentGlow;pF.TextSize=13;pF.ZIndex=90;pF.Parent=Gui;Cn(pF,6);St(pF,C.Accent,1,0.6)
            spawn(function() while pF and pF.Parent do task.wait(0.5);local ok,pg=pcall(function() return math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end);if ok and pF then pF.Text=pg.." ms";pF.TextColor3=pg<80 and Color3.fromRGB(80,255,140) or pg<150 and Color3.fromRGB(255,200,50) or Color3.fromRGB(255,80,80) end end end)
        else if pF then pF:Destroy();pF=nil end end
    end})

    local aF
    FCTile(gOv,{Name="ArrayList",Order=5,Settings=function(c) SC.Dropdown(c,"Sort",{"Length","Alpha"},"Length") end,OnToggle=function(s)
        if s then
            aF=Instance.new("Frame");aF.BackgroundTransparency=1;aF.Position=UDim2.new(1,-180,0,46);aF.Size=UDim2.new(0,175,0,320);aF.ZIndex=89;aF.Parent=Gui
            local al=Instance.new("UIListLayout");al.Padding=UDim.new(0,2);al.HorizontalAlignment=Enum.HorizontalAlignment.Right;al.SortOrder=Enum.SortOrder.Name;al.Parent=aF
            spawn(function() while aF and aF.Parent do for _,ch in ipairs(aF:GetChildren()) do if ch:IsA("TextLabel") then ch:Destroy() end end;for nn,_ in pairs(TE) do local a=Instance.new("TextLabel");a.BackgroundColor3=C.Accent;a.BackgroundTransparency=0.7;a.BorderSizePixel=0;a.Size=UDim2.new(0,#nn*8+20,0,22);a.Font=Enum.Font.GothamMedium;a.Text=nn;a.TextColor3=C.Text;a.TextSize=12;a.ZIndex=90;a.Name=nn;a.Parent=aF;Cn(a,4) end;task.wait(0.5) end end)
        else if aF then aF:Destroy();aF=nil end end
    end})

    local afC
    FCTile(gOv,{Name="AntiAFK",Order=6,Settings=function(c) SC.Label(c,"Prevents idle kick") end,OnToggle=function(s)
        if s then
            afC=Player.Idled:Connect(function() local vu=game:GetService("VirtualUser");vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame);task.wait(1);vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame) end)
        else if afC then afC:Disconnect();afC=nil end end
    end})

    local pTh=TPages["Themes"]

    local h1=Instance.new("TextLabel")
    h1.BackgroundTransparency=1;h1.Size=UDim2.new(1,-10,0,28);h1.Font=Enum.Font.GothamBold
    h1.Text="Базовые темы (60)";h1.TextColor3=C.Text;h1.TextSize=16;h1.TextXAlignment=Enum.TextXAlignment.Left
    h1.ZIndex=5;h1.LayoutOrder=1;h1.Parent=pTh
    Reg(h1,"TextColor3","Text")

    local tG=Instance.new("Frame")
    tG.BackgroundTransparency=1;tG.Size=UDim2.new(1,-10,0,0);tG.AutomaticSize=Enum.AutomaticSize.Y
    tG.ZIndex=5;tG.LayoutOrder=2;tG.Parent=pTh
    local tGL=Instance.new("UIGridLayout")
    tGL.CellSize=UDim2.new(0,140,0,56);tGL.CellPadding=UDim2.new(0,8,0,8)
    tGL.SortOrder=Enum.SortOrder.LayoutOrder;tGL.FillDirectionMaxCells=4;tGL.HorizontalAlignment=Enum.HorizontalAlignment.Center;tGL.Parent=tG

    local tBtns={}
    for i,th in ipairs(ThemeList) do
        local tb=Instance.new("TextButton")
        tb.BackgroundColor3=th.Sidebar;tb.BorderSizePixel=0;tb.Size=UDim2.new(1,0,1,0)
        tb.Text="";tb.ZIndex=6;tb.AutoButtonColor=false;tb.LayoutOrder=i;tb.Parent=tG;Cn(tb,8)
        local tbGrad=Instance.new("UIGradient")
        tbGrad.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,th.Grad1),ColorSequenceKeypoint.new(1,th.Grad2)};tbGrad.Rotation=180;tbGrad.Parent=tb
        local tSt=St(tb,(CurTheme.Id==th.Id) and C.Accent or th.Border,1.5,(CurTheme.Id==th.Id) and 0.15 or 0.7)
        local shortName=th.Name:len()>16 and th.Name:sub(1,16).."..." or th.Name
        local tnl=Instance.new("TextLabel")
        tnl.BackgroundTransparency=1;tnl.Position=UDim2.new(0,8,0,6);tnl.Size=UDim2.new(1,-16,0,18)
        tnl.Font=Enum.Font.GothamBold;tnl.Text=shortName;tnl.TextColor3=th.Text;tnl.TextSize=12
        tnl.TextXAlignment=Enum.TextXAlignment.Left;tnl.ZIndex=7;tnl.Parent=tb
        local pvw=Instance.new("Frame")
        pvw.BackgroundTransparency=1;pvw.Position=UDim2.new(0,8,0,30);pvw.Size=UDim2.new(1,-16,0,18);pvw.ZIndex=7;pvw.Parent=tb
        local pvL=Instance.new("UIListLayout")
        pvL.FillDirection=Enum.FillDirection.Horizontal;pvL.Padding=UDim.new(0,4);pvL.Parent=pvw
        for _,col in ipairs({th.Bg,th.Card,th.Text}) do
            local dot=Instance.new("Frame")
            dot.BackgroundColor3=col;dot.BorderSizePixel=0;dot.Size=UDim2.new(0,14,0,14);dot.ZIndex=8;dot.Parent=pvw;Cn(dot,4)
        end
        tBtns[th.Id]={btn=tb,st=tSt}
        tb.MouseEnter:Connect(function() Tw(tb,{BackgroundTransparency=0.15},0.12) end)
        tb.MouseLeave:Connect(function() Tw(tb,{BackgroundTransparency=0},0.12) end)
        tb.MouseButton1Click:Connect(function()
            CurTheme=th;ApplyAll()
            for id,d in pairs(tBtns) do
                if id==th.Id then Tw(d.st,{Color=C.Accent,Transparency=0.15},0.25)
                else Tw(d.st,{Transparency=0.7},0.25) end
            end
            Notify("Тема",th.Name,nil,2)
        end)
    end

    local s1=Instance.new("Frame")
    s1.BackgroundColor3=C.Divider;s1.BackgroundTransparency=0.3;s1.BorderSizePixel=0
    s1.Size=UDim2.new(1,-10,0,1);s1.ZIndex=5;s1.LayoutOrder=3;s1.Parent=pTh
    Reg(s1,"BackgroundColor3","Divider")

    local h2=Instance.new("TextLabel")
    h2.BackgroundTransparency=1;h2.Size=UDim2.new(1,-10,0,28);h2.Font=Enum.Font.GothamBold
    h2.Text="Акцент";h2.TextColor3=C.Text;h2.TextSize=16;h2.TextXAlignment=Enum.TextXAlignment.Left
    h2.ZIndex=5;h2.LayoutOrder=4;h2.Parent=pTh
    Reg(h2,"TextColor3","Text")

    local cG=Instance.new("Frame")
    cG.BackgroundTransparency=1;cG.Size=UDim2.new(1,-10,0,0);cG.AutomaticSize=Enum.AutomaticSize.Y
    cG.ZIndex=5;cG.LayoutOrder=5;cG.Parent=pTh
    local cGL=Instance.new("UIGridLayout")
    cGL.CellSize=UDim2.new(0,140,0,52);cGL.CellPadding=UDim2.new(0,8,0,8)
    cGL.SortOrder=Enum.SortOrder.LayoutOrder;cGL.FillDirectionMaxCells=4;cGL.HorizontalAlignment=Enum.HorizontalAlignment.Center;cGL.Parent=cG

    for i,ac in ipairs(AccentList) do
        local cc=Instance.new("TextButton")
        cc.BackgroundColor3=ac.C1;cc.BorderSizePixel=0;cc.Size=UDim2.new(1,0,1,0)
        cc.Text="";cc.ZIndex=6;cc.AutoButtonColor=false;cc.LayoutOrder=i;cc.Parent=cG;Cn(cc,8)
        local ccGrad=Instance.new("UIGradient")
        ccGrad.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,ac.C1),ColorSequenceKeypoint.new(1,ac.C2)};ccGrad.Rotation=45;ccGrad.Parent=cc
        local cSt=St(cc,Color3.new(1,1,1),2,(CurAccent.Name==ac.Name) and 0.15 or 1)
        local nl=Instance.new("TextLabel")
        nl.BackgroundTransparency=1;nl.Position=UDim2.new(0,10,0.5,0);nl.AnchorPoint=Vector2.new(0,0.5)
        nl.Size=UDim2.new(1,-20,0,20);nl.Font=Enum.Font.GothamBold;nl.Text=ac.Name
        nl.TextColor3=Color3.new(1,1,1);nl.TextSize=14;nl.TextXAlignment=Enum.TextXAlignment.Left;nl.ZIndex=7;nl.Parent=cc
        cc.MouseEnter:Connect(function() Tw(cc,{BackgroundTransparency=0.15},0.12) end)
        cc.MouseLeave:Connect(function() Tw(cc,{BackgroundTransparency=0},0.12) end)
        cc.MouseButton1Click:Connect(function()
            CurAccent=ac;ApplyAll()
            for _,ch in ipairs(cG:GetChildren()) do
                if ch:IsA("TextButton") then local s=ch:FindFirstChildOfClass("UIStroke");if s then Tw(s,{Transparency=1},0.2) end end
            end
            Tw(cSt,{Transparency=0.15},0.3)
            Notify("Акцент",ac.Name,nil,2)
        end)
    end

    local s2=Instance.new("Frame")
    s2.BackgroundColor3=C.Divider;s2.BackgroundTransparency=0.3;s2.BorderSizePixel=0
    s2.Size=UDim2.new(1,-10,0,1);s2.ZIndex=5;s2.LayoutOrder=6;s2.Parent=pTh
    Reg(s2,"BackgroundColor3","Divider")

    local h3=Instance.new("TextLabel")
    h3.BackgroundTransparency=1;h3.Size=UDim2.new(1,-10,0,28);h3.Font=Enum.Font.GothamBold
    h3.Text="Настройки GUI";h3.TextColor3=C.Text;h3.TextSize=16;h3.TextXAlignment=Enum.TextXAlignment.Left
    h3.ZIndex=5;h3.LayoutOrder=7;h3.Parent=pTh
    Reg(h3,"TextColor3","Text")

    local bC=Instance.new("Frame")
    bC.BackgroundColor3=C.Card;bC.BackgroundTransparency=0.3;bC.BorderSizePixel=0
    bC.Size=UDim2.new(1,-10,0,46);bC.ZIndex=5;bC.LayoutOrder=8;bC.Parent=pTh
    Cn(bC,10);Reg(bC,"BackgroundColor3","Card")

    local bL=Instance.new("TextLabel")
    bL.BackgroundTransparency=1;bL.Position=UDim2.new(0,14,0,0);bL.Size=UDim2.new(1,-90,1,0)
    bL.Font=Enum.Font.GothamMedium;bL.Text="Бинд переключения GUI";bL.TextColor3=C.Text;bL.TextSize=14
    bL.TextXAlignment=Enum.TextXAlignment.Left;bL.ZIndex=6;bL.Parent=bC
    Reg(bL,"TextColor3","Text")

    local gK=Enum.KeyCode.RightControl
    local gKL=false
    local gKB=Instance.new("TextButton")
    gKB.BackgroundColor3=C.TagBg;gKB.BackgroundTransparency=0.2;gKB.BorderSizePixel=0
    gKB.Position=UDim2.new(1,-76,0.5,0);gKB.AnchorPoint=Vector2.new(0,0.5);gKB.Size=UDim2.new(0,62,0,28)
    gKB.Font=Enum.Font.GothamBold;gKB.Text="RCtrl";gKB.TextColor3=C.AccentGlow;gKB.TextSize=12
    gKB.ZIndex=7;gKB.AutoButtonColor=false;gKB.Parent=bC;Cn(gKB,7)
    gKB.MouseButton1Click:Connect(function() gKL=true;gKB.Text="...";Tw(gKB,{BackgroundColor3=C.Accent},0.15) end)

    local blC=Instance.new("Frame")
    blC.BackgroundColor3=C.Card;blC.BackgroundTransparency=0.3;blC.BorderSizePixel=0
    blC.Size=UDim2.new(1,-10,0,46);blC.ZIndex=5;blC.LayoutOrder=9;blC.Parent=pTh
    Cn(blC,10);Reg(blC,"BackgroundColor3","Card")

    local blL=Instance.new("TextLabel")
    blL.BackgroundTransparency=1;blL.Position=UDim2.new(0,14,0,0);blL.Size=UDim2.new(1,-60,1,0)
    blL.Font=Enum.Font.GothamMedium;blL.Text="Эффект размытия";blL.TextColor3=C.Text;blL.TextSize=14
    blL.TextXAlignment=Enum.TextXAlignment.Left;blL.ZIndex=6;blL.Parent=blC
    Reg(blL,"TextColor3","Text")

    local blT=Instance.new("Frame")
    blT.BackgroundColor3=C.TogOn;blT.BorderSizePixel=0
    blT.Position=UDim2.new(1,-54,0.5,0);blT.AnchorPoint=Vector2.new(0,0.5);blT.Size=UDim2.new(0,38,0,22)
    blT.ZIndex=7;blT.Parent=blC;Cn(blT,11)

    local blCr=Instance.new("Frame")
    blCr.BackgroundColor3=C.Knob;blCr.BorderSizePixel=0;blCr.Size=UDim2.new(0,16,0,16)
    blCr.Position=UDim2.new(1,-19,0.5,0);blCr.AnchorPoint=Vector2.new(0,0.5);blCr.ZIndex=8;blCr.Parent=blT;Cn(blCr,100)

    local blOn=true
    local blBt=Instance.new("TextButton")
    blBt.BackgroundTransparency=1;blBt.Size=UDim2.new(1,0,1,0);blBt.Text="";blBt.ZIndex=9;blBt.Parent=blC
    blBt.MouseButton1Click:Connect(function()
        blOn=not blOn
        Tw(blT,{BackgroundColor3=blOn and C.TogOn or C.TogOff},0.2)
        Tw(blCr,{Position=blOn and UDim2.new(1,-19,0.5,0) or UDim2.new(0,3,0.5,0)},0.2)
        Blur.Size=blOn and 5 or 0
    end)

    local rzC=Instance.new("Frame")
    rzC.BackgroundColor3=C.Card;rzC.BackgroundTransparency=0.3;rzC.BorderSizePixel=0
    rzC.Size=UDim2.new(1,-10,0,42);rzC.ZIndex=5;rzC.LayoutOrder=10;rzC.Parent=pTh
    Cn(rzC,10);Reg(rzC,"BackgroundColor3","Card")

    local rzL=Instance.new("TextLabel")
    rzL.BackgroundTransparency=1;rzL.Position=UDim2.new(0,14,0,0);rzL.Size=UDim2.new(1,-20,1,0)
    rzL.Font=Enum.Font.GothamMedium;rzL.Text="Размер: тяни за правый нижний угол";rzL.TextColor3=C.TextDim
    rzL.TextSize=13;rzL.TextXAlignment=Enum.TextXAlignment.Left;rzL.ZIndex=6;rzL.Parent=rzC
    Reg(rzL,"TextColor3","TextDim")

    local guiOpen=true
    UserInputService.InputBegan:Connect(function(inp,gpe)
        if gKL and not gpe and inp.UserInputType==Enum.UserInputType.Keyboard then
            gK=inp.KeyCode;gKB.Text=inp.KeyCode.Name;gKL=false
            Tw(gKB,{BackgroundColor3=C.TagBg},0.15)
            Notify("Бинд","GUI: "..inp.KeyCode.Name,nil,2)
            return
        end
        if gpe then return end
        if not gKL and inp.UserInputType==Enum.UserInputType.Keyboard and inp.KeyCode==gK then
            guiOpen=not guiOpen
            if guiOpen then
                Gui.Enabled=true
                Tw(Main,{Size=UDim2.new(0,GUI_W,0,GUI_H),BackgroundTransparency=CurTheme.Trans},0.4,Enum.EasingStyle.Back)
                if blOn then Blur.Size=5 end
            else
                if sO then CS() end
                Tw(Main,{Size=UDim2.new(0,0,0,0),BackgroundTransparency=1},0.35)
                Blur.Size=0;task.wait(0.35)
                if not guiOpen then Gui.Enabled=false end
            end
        end
    end)

    task.wait(0.1)
    Tw(Main,{Size=UDim2.new(0,GUI_W,0,GUI_H),BackgroundTransparency=CurTheme.Trans},0.55,Enum.EasingStyle.Back)
    Blur.Size=5;task.wait(0.4);STT("Overlay");task.wait(0.3)
    Notify("Nz","GUI загружен!",nil,3)

    print("[Nz v7.0] Loaded! Default bind: RCtrl")
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
    pcall(function()
        local req = http_request or request or (syn and syn.request)
        if req then
            req({
                Url = KEY_CONFIG.FIREBASE_URL .. "/keys/" .. key .. ".json",
                Method = "DELETE"
            })
        end
    end)
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

GetKeyButton.MouseButton1Click:Connect(function()
    pcall(function() setclipboard(KEY_CONFIG.LINKVERTISE_URL) end)
    StatusLabel.TextColor3 = Color3.fromRGB(130, 100, 255)
    StatusLabel.Text = "Ссылка скопирована! Вставь в браузер."
end)

local isChecking = false
CheckButton.MouseButton1Click:Connect(function()
    if isChecking then return end
    
    local key = KeyInput.Text:gsub("%s+", "")
    
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
