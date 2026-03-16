-- ╔══════════════════════════════════════════════════════════════╗
-- ║                   REVELENCY  ·  BETA v1.0                    ║
-- ╚══════════════════════════════════════════════════════════════╝

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local SoundService     = game:GetService("SoundService")
local Lighting         = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")

-- ─── SCREEN GUI ───────────────────────────────────────────────
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name           = "REVELENCY_GUI"
ScreenGui.ResetOnSpawn   = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent         = PlayerGui

-- ─── SOUNDS ───────────────────────────────────────────────────
local SndWhoosh = Instance.new("Sound")
SndWhoosh.SoundId = "rbxassetid://6518811702"
SndWhoosh.Volume  = 0.55
SndWhoosh.Parent  = SoundService

local SndChime = Instance.new("Sound")
SndChime.SoundId = "rbxassetid://4964706015"
SndChime.Volume  = 0.40
SndChime.Parent  = SoundService

-- ─── BLUR ─────────────────────────────────────────────────────
local Blur = Instance.new("BlurEffect")
Blur.Size   = 0
Blur.Parent = Lighting
TweenService:Create(Blur, TweenInfo.new(1.6, Enum.EasingStyle.Sine), {Size = 44}):Play()

-- ═══════════════════════════════════════════════════════════════
--  LOADING FRAME
-- ═══════════════════════════════════════════════════════════════
local LoadFrame = Instance.new("Frame")
LoadFrame.Size             = UDim2.new(1, 0, 1, 0)
LoadFrame.BackgroundColor3 = Color3.fromRGB(3, 1, 10)
LoadFrame.BorderSizePixel  = 0
LoadFrame.ZIndex           = 200
LoadFrame.Parent           = ScreenGui

local LGrad = Instance.new("UIGradient")
LGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,    Color3.fromRGB(0,   0,   0)),
    ColorSequenceKeypoint.new(0.28, Color3.fromRGB(8,   3,  24)),
    ColorSequenceKeypoint.new(0.55, Color3.fromRGB(5,   2,  18)),
    ColorSequenceKeypoint.new(1,    Color3.fromRGB(0,   0,   0)),
})
LGrad.Rotation = 135
LGrad.Parent   = LoadFrame

-- Subtle grid
for i = 1, 8 do
    local g = Instance.new("Frame")
    g.Size = UDim2.new(1,0,0,1); g.Position = UDim2.new(0,0,i/9,0)
    g.BackgroundColor3 = Color3.fromRGB(40,18,100); g.BackgroundTransparency = 0.9
    g.BorderSizePixel = 0; g.ZIndex = 200; g.Parent = LoadFrame
end
for i = 1, 12 do
    local g = Instance.new("Frame")
    g.Size = UDim2.new(0,1,1,0); g.Position = UDim2.new(i/13,0,0,0)
    g.BackgroundColor3 = Color3.fromRGB(40,18,100); g.BackgroundTransparency = 0.92
    g.BorderSizePixel = 0; g.ZIndex = 200; g.Parent = LoadFrame
end

-- Floating particles
for _ = 1, 42 do
    local sz = math.random(2,7)
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0,sz,0,sz)
    dot.Position = UDim2.new(math.random(2,98)/100, 0, math.random(5,95)/100, 0)
    dot.BackgroundColor3 = Color3.fromRGB(math.random(50,130), math.random(8,45), math.random(155,255))
    dot.BackgroundTransparency = math.random(38,75)/100
    dot.BorderSizePixel = 0; dot.ZIndex = 201; dot.Parent = LoadFrame
    local dc = Instance.new("UICorner"); dc.CornerRadius = UDim.new(1,0); dc.Parent = dot
    task.spawn(function()
        while dot and dot.Parent do
            TweenService:Create(dot, TweenInfo.new(math.random(5,13), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, true), {
                Position = UDim2.new(math.clamp(dot.Position.X.Scale+math.random(-6,6)/100,0.01,0.99), 0,
                                     math.clamp(dot.Position.Y.Scale-math.random(4,16)/100,0.01,0.99), 0),
                BackgroundTransparency = math.random(55,88)/100,
            }):Play()
            task.wait(math.random(5,13))
        end
    end)
end

-- ─── EMBLEM: 3 rotating rings + orbiting satellites ───────────
local EW = 240; local EC = EW/2

local function mkBar(p, w, h, cx, cy, rot, col, transp, z)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(0,w,0,h); f.Position = UDim2.new(0,cx-w/2,0,cy-h/2)
    f.BackgroundColor3 = col; f.BackgroundTransparency = transp or 0
    f.BorderSizePixel = 0; f.Rotation = rot or 0; f.ZIndex = z or 203; f.Parent = p
    return f
end

local ringData = {
    {sz=220, bars=8, col=Color3.fromRGB(75,35,195),  thick=2, spd= 0.30},
    {sz=158, bars=6, col=Color3.fromRGB(105,55,238), thick=2, spd=-0.52},
    {sz= 98, bars=4, col=Color3.fromRGB(148,88,255), thick=3, spd= 0.82},
}
local ringRoots = {}
for ri, d in ipairs(ringData) do
    local root = Instance.new("Frame")
    root.Size = UDim2.new(0,EW,0,EW); root.Position = UDim2.new(0.5,-EC,0.5,-EC-30)
    root.BackgroundTransparency = 1; root.BorderSizePixel = 0; root.ZIndex = 202; root.Parent = LoadFrame
    local step = 180/d.bars
    for b = 0, d.bars-1 do mkBar(root, d.sz, d.thick, EC, EC, b*step, d.col, 0, 202) end
    ringRoots[ri] = {root=root, spd=d.spd}
end
task.spawn(function()
    local ang = {0,0,0}
    while ringRoots[1] and ringRoots[1].root.Parent do
        for ri, r in ipairs(ringRoots) do ang[ri]=ang[ri]+r.spd; r.root.Rotation=ang[ri] end
        task.wait(0.05)
    end
end)

local CoreRoot = Instance.new("Frame")
CoreRoot.Size = UDim2.new(0,EW,0,EW); CoreRoot.Position = UDim2.new(0.5,-EC,0.5,-EC-30)
CoreRoot.BackgroundTransparency = 1; CoreRoot.BorderSizePixel = 0; CoreRoot.ZIndex = 204; CoreRoot.Parent = LoadFrame

local CoreDia = Instance.new("Frame")
CoreDia.Size = UDim2.new(0,34,0,34); CoreDia.Position = UDim2.new(0,EC-17,0,EC-17)
CoreDia.BackgroundColor3 = Color3.fromRGB(108,58,255); CoreDia.BorderSizePixel = 0
CoreDia.Rotation = 45; CoreDia.ZIndex = 205; CoreDia.Parent = CoreRoot

mkBar(CoreRoot,80,1,EC,EC,  0, Color3.fromRGB(78,38,196),  0.4, 204)
mkBar(CoreRoot,80,1,EC,EC, 90, Color3.fromRGB(78,38,196),  0.4, 204)
mkBar(CoreRoot,80,1,EC,EC, 45, Color3.fromRGB(98,58,226),  0.6, 204)
mkBar(CoreRoot,80,1,EC,EC,-45, Color3.fromRGB(98,58,226),  0.6, 204)

task.spawn(function()
    while CoreDia and CoreDia.Parent do
        TweenService:Create(CoreDia, TweenInfo.new(1.05,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut), {
            BackgroundColor3=Color3.fromRGB(192,138,255), Size=UDim2.new(0,46,0,46), Position=UDim2.new(0,EC-23,0,EC-23)
        }):Play(); task.wait(1.05)
        TweenService:Create(CoreDia, TweenInfo.new(1.05,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut), {
            BackgroundColor3=Color3.fromRGB(88,38,218),  Size=UDim2.new(0,28,0,28), Position=UDim2.new(0,EC-14,0,EC-14)
        }):Play(); task.wait(1.05)
    end
end)

local sats = {}
for si = 1, 4 do
    local s = Instance.new("Frame")
    s.Size = UDim2.new(0,10,0,10); s.BackgroundColor3 = Color3.fromRGB(155,95,255)
    s.BorderSizePixel = 0; s.Rotation = 45; s.ZIndex = 206; s.Parent = CoreRoot
    sats[si] = s
end
task.spawn(function()
    local t = 0
    while CoreRoot and CoreRoot.Parent do
        t = t + 0.042
        for si, s in ipairs(sats) do
            local ph = t + (si-1)*math.pi/2
            s.Position = UDim2.new(0, EC+math.cos(ph)*64-5, 0, EC+math.sin(ph)*64-5)
        end
        task.wait(0.05)
    end
end)

-- Expanding halo pulses
task.spawn(function()
    while LoadFrame and LoadFrame.Parent do
        for _, r in ipairs({78,100,122}) do
            local h = Instance.new("Frame")
            h.Size = UDim2.new(0,r*2,0,r*2); h.Position = UDim2.new(0.5,-r,0.5,-r-30)
            h.BackgroundTransparency = 1; h.BorderSizePixel = 0; h.ZIndex = 201; h.Parent = LoadFrame
            local hc = Instance.new("UICorner"); hc.CornerRadius = UDim.new(1,0); hc.Parent = h
            local hs = Instance.new("UIStroke"); hs.Color = Color3.fromRGB(88,38,198); hs.Thickness = 1; hs.Transparency = 0.28; hs.Parent = h
            local tr = r+58
            TweenService:Create(h, TweenInfo.new(2.6,Enum.EasingStyle.Sine), {
                Size=UDim2.new(0,tr*2,0,tr*2), Position=UDim2.new(0.5,-tr,0.5,-tr-30)
            }):Play()
            TweenService:Create(hs, TweenInfo.new(2.6,Enum.EasingStyle.Sine), {Transparency=1}):Play()
            task.delay(2.7, function() if h then h:Destroy() end end)
        end
        task.wait(2.9)
    end
end)

-- ─── TITLE (WHITE text, subtle stroke) ───────────────────────
local TitleGlow = Instance.new("TextLabel")
TitleGlow.Size=UDim2.new(1,0,0,110); TitleGlow.Position=UDim2.new(0,0,0.635,0)
TitleGlow.BackgroundTransparency=1; TitleGlow.Text=""
TitleGlow.TextColor3=Color3.fromRGB(230,230,255)   -- very light, almost white glow
TitleGlow.TextSize=82; TitleGlow.Font=Enum.Font.GothamBlack
TitleGlow.TextXAlignment=Enum.TextXAlignment.Center
TitleGlow.TextTransparency=0.82; TitleGlow.ZIndex=203; TitleGlow.Parent=LoadFrame

local TitleLbl = Instance.new("TextLabel")
TitleLbl.Size=UDim2.new(1,0,0,110); TitleLbl.Position=UDim2.new(0,0,0.635,0)
TitleLbl.BackgroundTransparency=1; TitleLbl.Text=""
TitleLbl.TextColor3=Color3.fromRGB(255,255,255)     -- PURE WHITE
TitleLbl.TextSize=82; TitleLbl.Font=Enum.Font.GothamBlack
TitleLbl.TextXAlignment=Enum.TextXAlignment.Center
TitleLbl.ZIndex=204; TitleLbl.Parent=LoadFrame

-- Thin white/silver stroke – not neon
local TitleStroke = Instance.new("UIStroke")
TitleStroke.Color=Color3.fromRGB(200,200,220)
TitleStroke.Thickness=1.8; TitleStroke.Transparency=0.5; TitleStroke.Parent=TitleLbl

-- Blinking cursor
local Cursor = Instance.new("TextLabel")
Cursor.Size=UDim2.new(0,6,0,76); Cursor.Position=UDim2.new(0.5,10,0.640,13)
Cursor.BackgroundTransparency=1; Cursor.Text="|"
Cursor.TextColor3=Color3.fromRGB(255,255,255)   -- white cursor
Cursor.TextSize=56; Cursor.Font=Enum.Font.GothamBold
Cursor.TextXAlignment=Enum.TextXAlignment.Left
Cursor.ZIndex=205; Cursor.Parent=LoadFrame
task.spawn(function()
    while Cursor and Cursor.Parent do
        Cursor.TextTransparency=0; task.wait(0.50)
        Cursor.TextTransparency=1; task.wait(0.42)
    end
end)

-- Tagline – white/light grey
local TagLbl = Instance.new("TextLabel")
TagLbl.Size=UDim2.new(1,0,0,22); TagLbl.Position=UDim2.new(0,0,0.773,0)
TagLbl.BackgroundTransparency=1; TagLbl.Text="❮  BETA VERSION  ❯"
TagLbl.TextColor3=Color3.fromRGB(200,200,218)   -- light silver-white
TagLbl.TextSize=14; TagLbl.Font=Enum.Font.GothamBold
TagLbl.TextXAlignment=Enum.TextXAlignment.Center
TagLbl.TextTransparency=1; TagLbl.ZIndex=204; TagLbl.Parent=LoadFrame

-- ─── PROGRESS BAR ─────────────────────────────────────────────
local BarBG = Instance.new("Frame")
BarBG.Size=UDim2.new(0,562,0,7); BarBG.Position=UDim2.new(0.5,-281,0.852,0)
BarBG.BackgroundColor3=Color3.fromRGB(13,7,30); BarBG.BorderSizePixel=0; BarBG.ZIndex=203; BarBG.Parent=LoadFrame
local BBGC=Instance.new("UICorner"); BBGC.CornerRadius=UDim.new(1,0); BBGC.Parent=BarBG
local BBGS=Instance.new("UIStroke"); BBGS.Color=Color3.fromRGB(58,18,138); BBGS.Thickness=1; BBGS.Transparency=0.42; BBGS.Parent=BarBG

local BarFill = Instance.new("Frame")
BarFill.Size=UDim2.new(0,0,1,0); BarFill.BackgroundColor3=Color3.fromRGB(88,38,218)
BarFill.BorderSizePixel=0; BarFill.ZIndex=204; BarFill.Parent=BarBG
local BFC=Instance.new("UICorner"); BFC.CornerRadius=UDim.new(1,0); BFC.Parent=BarFill
local BFG=Instance.new("UIGradient")
BFG.Color=ColorSequence.new({
    ColorSequenceKeypoint.new(0,  Color3.fromRGB(48,14,165)),
    ColorSequenceKeypoint.new(0.5,Color3.fromRGB(98,42,232)),
    ColorSequenceKeypoint.new(1,  Color3.fromRGB(198,138,255)),
}); BFG.Parent=BarFill

-- Shimmer on bar
local BShim=Instance.new("Frame")
BShim.Size=UDim2.new(0.24,0,1,0); BShim.Position=UDim2.new(-0.3,0,0,0)
BShim.BackgroundColor3=Color3.fromRGB(255,255,255); BShim.BackgroundTransparency=0.78
BShim.BorderSizePixel=0; BShim.ZIndex=205; BShim.Parent=BarFill
local BSC2=Instance.new("UICorner"); BSC2.CornerRadius=UDim.new(1,0); BSC2.Parent=BShim
local BSG2=Instance.new("UIGradient")
BSG2.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(0.5,0.65),NumberSequenceKeypoint.new(1,1)})
BSG2.Parent=BShim
task.spawn(function()
    while BShim and BShim.Parent do
        BShim.Position=UDim2.new(-0.3,0,0,0)
        TweenService:Create(BShim,TweenInfo.new(2.2,Enum.EasingStyle.Sine),{Position=UDim2.new(1.1,0,0,0)}):Play()
        task.wait(2.9)
    end
end)

-- End glow dot
local BarDot=Instance.new("Frame")
BarDot.Size=UDim2.new(0,15,0,15); BarDot.Position=UDim2.new(1,-8,0.5,-8)
BarDot.BackgroundColor3=Color3.fromRGB(200,148,255); BarDot.BorderSizePixel=0; BarDot.ZIndex=206; BarDot.Parent=BarFill
local BDC2=Instance.new("UICorner"); BDC2.CornerRadius=UDim.new(1,0); BDC2.Parent=BarDot
task.spawn(function()
    while BarDot and BarDot.Parent do
        TweenService:Create(BarDot,TweenInfo.new(0.82,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{BackgroundColor3=Color3.fromRGB(238,195,255)}):Play(); task.wait(0.82)
        TweenService:Create(BarDot,TweenInfo.new(0.82,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{BackgroundColor3=Color3.fromRGB(108,48,228)}):Play(); task.wait(0.82)
    end
end)

-- Percent label – white
local PctLbl=Instance.new("TextLabel")
PctLbl.Size=UDim2.new(1,0,0,28); PctLbl.Position=UDim2.new(0,0,0.876,0)
PctLbl.BackgroundTransparency=1; PctLbl.Text="0%"
PctLbl.TextColor3=Color3.fromRGB(255,255,255)   -- white
PctLbl.TextSize=21; PctLbl.Font=Enum.Font.GothamBold
PctLbl.TextXAlignment=Enum.TextXAlignment.Center
PctLbl.ZIndex=203; PctLbl.Parent=LoadFrame

-- Status label – light grey/silver (not neon)
local StatusLbl=Instance.new("TextLabel")
StatusLbl.Size=UDim2.new(0.68,0,0,22); StatusLbl.Position=UDim2.new(0.16,0,0.916,0)
StatusLbl.BackgroundTransparency=1; StatusLbl.Text="Initializing REVELENCY..."
StatusLbl.TextColor3=Color3.fromRGB(160,160,180)   -- muted silver-white
StatusLbl.TextSize=13; StatusLbl.Font=Enum.Font.Gotham
StatusLbl.TextXAlignment=Enum.TextXAlignment.Center
StatusLbl.ZIndex=203; StatusLbl.Parent=LoadFrame

-- Animated dots – white
local DotsLbl=Instance.new("TextLabel")
DotsLbl.Size=UDim2.new(0,30,0,22); DotsLbl.Position=UDim2.new(0.84,0,0.916,0)
DotsLbl.BackgroundTransparency=1; DotsLbl.Text="."
DotsLbl.TextColor3=Color3.fromRGB(210,210,228)
DotsLbl.TextSize=14; DotsLbl.Font=Enum.Font.GothamBold
DotsLbl.ZIndex=203; DotsLbl.Parent=LoadFrame
task.spawn(function()
    local c={".","..","..."}; local i=1
    while DotsLbl and DotsLbl.Parent do DotsLbl.Text=c[i]; i=i%3+1; task.wait(0.44) end
end)

-- Footer – dim white
local FooterLbl=Instance.new("TextLabel")
FooterLbl.Size=UDim2.new(1,0,0,18); FooterLbl.Position=UDim2.new(0,0,0.955,0)
FooterLbl.BackgroundTransparency=1; FooterLbl.Text="REVELENCY  ·  2025  ·  BETA  ·  v1.0"
FooterLbl.TextColor3=Color3.fromRGB(80,80,100)
FooterLbl.TextSize=11; FooterLbl.Font=Enum.Font.Gotham
FooterLbl.TextXAlignment=Enum.TextXAlignment.Center
FooterLbl.ZIndex=203; FooterLbl.Parent=LoadFrame

local StatusSteps={
    [5]="Connecting to remote server...",  [15]="Verifying license key...",
    [27]="Loading core modules...",         [39]="Patching memory hooks...",
    [51]="Bypassing anti-cheat layer...",   [63]="Injecting aimbot engine...",
    [74]="Applying visual patches...",      [84]="Loading user configuration...",
    [93]="Finalizing startup...",           [99]="Almost ready...",
    [100]="Welcome to REVELENCY!",
}

-- ═══════════════════════════════════════════════════════════════
--  MAIN MENU
-- ═══════════════════════════════════════════════════════════════
local MENU_W, MENU_H = 720, 700

local Menu = Instance.new("Frame")
Menu.Name="Menu"; Menu.Size=UDim2.new(0,MENU_W,0,MENU_H)
Menu.Position=UDim2.new(0.5,-MENU_W/2,0.5,-MENU_H/2)
Menu.BackgroundColor3=Color3.fromRGB(5,4,11); Menu.BackgroundTransparency=0
Menu.BorderSizePixel=0; Menu.Visible=false; Menu.ZIndex=10; Menu.Parent=ScreenGui
Menu.ClipsDescendants=true

local MBG=Instance.new("UIGradient")
MBG.Color=ColorSequence.new({
    ColorSequenceKeypoint.new(0,  Color3.fromRGB(10,8,22)),
    ColorSequenceKeypoint.new(0.5,Color3.fromRGB(5,4,12)),
    ColorSequenceKeypoint.new(1,  Color3.fromRGB(2,2,6)),
}); MBG.Rotation=145; MBG.Parent=Menu

-- Animated border
local MenuStroke=Instance.new("UIStroke")
MenuStroke.Color=Color3.fromRGB(0,112,255); MenuStroke.Thickness=1.8; MenuStroke.Parent=Menu
task.spawn(function()
    while MenuStroke and MenuStroke.Parent do
        TweenService:Create(MenuStroke,TweenInfo.new(2.3,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Color=Color3.fromRGB(78,38,198)}):Play(); task.wait(2.3)
        TweenService:Create(MenuStroke,TweenInfo.new(2.3,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Color=Color3.fromRGB(0,130,255)}):Play(); task.wait(2.3)
    end
end)

-- Corner brackets
local CLEN=28
local function mkCorner(p,ax,ay)
    local ox=ax==0 and 0 or -CLEN; local oy=ay==0 and 0 or -CLEN
    local h=Instance.new("Frame"); h.Size=UDim2.new(0,CLEN,0,2); h.Position=UDim2.new(ax,ox,ay,oy)
    h.BackgroundColor3=Color3.fromRGB(0,142,255); h.BorderSizePixel=0; h.ZIndex=15; h.Parent=p
    local v=Instance.new("Frame"); v.Size=UDim2.new(0,2,0,CLEN); v.Position=UDim2.new(ax,ox,ay,oy)
    v.BackgroundColor3=Color3.fromRGB(0,142,255); v.BorderSizePixel=0; v.ZIndex=15; v.Parent=p
    local d=Instance.new("Frame"); d.Size=UDim2.new(0,7,0,7)
    d.Position=UDim2.new(ax,ox+(ax==0 and 0 or CLEN-7),ay,oy+(ay==0 and 0 or CLEN-7))
    d.BackgroundColor3=Color3.fromRGB(118,202,255); d.BorderSizePixel=0; d.ZIndex=16; d.Parent=p
    local dc=Instance.new("UICorner"); dc.CornerRadius=UDim.new(1,0); dc.Parent=d
    task.spawn(function()
        while d and d.Parent do
            TweenService:Create(d,TweenInfo.new(1.7,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{BackgroundColor3=Color3.fromRGB(222,242,255),Size=UDim2.new(0,9,0,9)}):Play(); task.wait(1.7)
            TweenService:Create(d,TweenInfo.new(1.7,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{BackgroundColor3=Color3.fromRGB(58,148,255),Size=UDim2.new(0,5,0,5)}):Play(); task.wait(1.7)
        end
    end)
    task.spawn(function()
        while h and h.Parent do
            TweenService:Create(h,TweenInfo.new(2.3,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{BackgroundColor3=Color3.fromRGB(78,38,208)}):Play()
            TweenService:Create(v,TweenInfo.new(2.3,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{BackgroundColor3=Color3.fromRGB(78,38,208)}):Play(); task.wait(2.3)
            TweenService:Create(h,TweenInfo.new(2.3,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{BackgroundColor3=Color3.fromRGB(0,142,255)}):Play()
            TweenService:Create(v,TweenInfo.new(2.3,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{BackgroundColor3=Color3.fromRGB(0,142,255)}):Play(); task.wait(2.3)
        end
    end)
end
mkCorner(Menu,0,0); mkCorner(Menu,1,0); mkCorner(Menu,0,1); mkCorner(Menu,1,1)

-- ─── TITLE BAR (NO minimize or close buttons) ─────────────────
local TBar=Instance.new("Frame")
TBar.Size=UDim2.new(1,0,0,36); TBar.BackgroundColor3=Color3.fromRGB(4,3,10)
TBar.BorderSizePixel=0; TBar.ZIndex=11; TBar.Parent=Menu

local TBG=Instance.new("UIGradient")
TBG.Color=ColorSequence.new({
    ColorSequenceKeypoint.new(0,  Color3.fromRGB(0,48,138)),
    ColorSequenceKeypoint.new(0.4,Color3.fromRGB(4,3,14)),
    ColorSequenceKeypoint.new(1,  Color3.fromRGB(4,3,14)),
}); TBG.Parent=TBar

local TBDiv=Instance.new("Frame"); TBDiv.Size=UDim2.new(1,0,0,1); TBDiv.Position=UDim2.new(0,0,1,-1)
TBDiv.BackgroundColor3=Color3.fromRGB(0,100,248); TBDiv.BorderSizePixel=0; TBDiv.ZIndex=12; TBDiv.Parent=TBar

-- Shimmer sweep on title bar divider
local TShim=Instance.new("Frame"); TShim.Size=UDim2.new(0.18,0,1,0); TShim.Position=UDim2.new(-0.22,0,0,0)
TShim.BackgroundColor3=Color3.fromRGB(200,228,255); TShim.BackgroundTransparency=0.44
TShim.BorderSizePixel=0; TShim.ZIndex=13; TShim.Parent=TBDiv
local TSSGr=Instance.new("UIGradient")
TSSGr.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(0.5,0.22),NumberSequenceKeypoint.new(1,1)}); TSSGr.Parent=TShim
task.spawn(function()
    while TShim and TShim.Parent do
        TShim.Position=UDim2.new(-0.22,0,0,0)
        TweenService:Create(TShim,TweenInfo.new(3.0,Enum.EasingStyle.Sine),{Position=UDim2.new(1.05,0,0,0)}):Play(); task.wait(4.2)
    end
end)

local TAccBar=Instance.new("Frame"); TAccBar.Size=UDim2.new(0,3,0.6,0); TAccBar.Position=UDim2.new(0,10,0.2,0)
TAccBar.BackgroundColor3=Color3.fromRGB(0,148,255); TAccBar.BorderSizePixel=0; TAccBar.ZIndex=12; TAccBar.Parent=TBar
local TABC=Instance.new("UICorner"); TABC.CornerRadius=UDim.new(1,0); TABC.Parent=TAccBar

local TDiamond=Instance.new("Frame"); TDiamond.Size=UDim2.new(0,8,0,8); TDiamond.Position=UDim2.new(0,22,0.5,-4)
TDiamond.BackgroundColor3=Color3.fromRGB(0,168,255); TDiamond.BorderSizePixel=0; TDiamond.Rotation=45; TDiamond.ZIndex=12; TDiamond.Parent=TBar

local MTLbl=Instance.new("TextLabel"); MTLbl.Size=UDim2.new(1,-50,1,0); MTLbl.Position=UDim2.new(0,38,0,0)
MTLbl.BackgroundTransparency=1; MTLbl.Text="REVELENCY  [BETA VERSION]"
MTLbl.TextColor3=Color3.fromRGB(225,230,248); MTLbl.TextSize=13
MTLbl.Font=Enum.Font.GothamBold; MTLbl.TextXAlignment=Enum.TextXAlignment.Left; MTLbl.ZIndex=12; MTLbl.Parent=TBar

-- ─── TAB BAR ──────────────────────────────────────────────────
local TabBar=Instance.new("Frame"); TabBar.Size=UDim2.new(1,0,0,32); TabBar.Position=UDim2.new(0,0,0,36)
TabBar.BackgroundColor3=Color3.fromRGB(4,3,9); TabBar.BorderSizePixel=0; TabBar.ZIndex=11; TabBar.Parent=Menu

local TDL=Instance.new("Frame"); TDL.Size=UDim2.new(1,0,0,1); TDL.Position=UDim2.new(0,0,1,-1)
TDL.BackgroundColor3=Color3.fromRGB(0,80,205); TDL.BorderSizePixel=0; TDL.ZIndex=12; TDL.Parent=TabBar

-- ─── CONTENT HOLDER ───────────────────────────────────────────
local ContentHolder=Instance.new("Frame")
ContentHolder.Size=UDim2.new(1,0,1,-68); ContentHolder.Position=UDim2.new(0,0,0,68)
ContentHolder.BackgroundTransparency=1; ContentHolder.ZIndex=11; ContentHolder.Parent=Menu
ContentHolder.ClipsDescendants=true

-- ─── COMING SOON PAGE FACTORY ─────────────────────────────────
local function mkComingSoon(parent)
    local frame=Instance.new("Frame"); frame.Size=UDim2.new(1,0,1,0)
    frame.BackgroundTransparency=1; frame.ZIndex=12; frame.Parent=parent
    local dia=Instance.new("Frame"); dia.Size=UDim2.new(0,52,0,52)
    dia.Position=UDim2.new(0.5,-26,0.38,0); dia.BackgroundColor3=Color3.fromRGB(0,90,200)
    dia.BackgroundTransparency=0.55; dia.BorderSizePixel=0; dia.Rotation=45; dia.ZIndex=13; dia.Parent=frame
    local dcs=Instance.new("UIStroke"); dcs.Color=Color3.fromRGB(0,140,255); dcs.Thickness=1.5; dcs.Transparency=0.2; dcs.Parent=dia
    local lbl=Instance.new("TextLabel"); lbl.Size=UDim2.new(0.6,0,0,36); lbl.Position=UDim2.new(0.2,0,0.52,0)
    lbl.BackgroundTransparency=1; lbl.Text="COMING SOON"
    lbl.TextColor3=Color3.fromRGB(200,210,240); lbl.TextSize=22; lbl.Font=Enum.Font.GothamBlack
    lbl.TextXAlignment=Enum.TextXAlignment.Center; lbl.ZIndex=13; lbl.Parent=frame
    local sub=Instance.new("TextLabel"); sub.Size=UDim2.new(0.65,0,0,22); sub.Position=UDim2.new(0.175,0,0.62,0)
    sub.BackgroundTransparency=1; sub.Text="This section is under development"
    sub.TextColor3=Color3.fromRGB(80,86,115); sub.TextSize=13; sub.Font=Enum.Font.Gotham
    sub.TextXAlignment=Enum.TextXAlignment.Center; sub.ZIndex=13; sub.Parent=frame
    local ubar=Instance.new("Frame"); ubar.Size=UDim2.new(0,0,0,2); ubar.Position=UDim2.new(0.2,0,0.695,0)
    ubar.BackgroundColor3=Color3.fromRGB(0,110,255); ubar.BorderSizePixel=0; ubar.ZIndex=13; ubar.Parent=frame
    task.spawn(function()
        task.wait(0.3)
        TweenService:Create(ubar,TweenInfo.new(0.8,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=UDim2.new(0.6,0,0,2)}):Play()
    end)
    return frame
end

-- ─── RAGE PAGE ────────────────────────────────────────────────
local RagePage=Instance.new("Frame"); RagePage.Size=UDim2.new(1,0,1,0)
RagePage.BackgroundTransparency=1; RagePage.ZIndex=12; RagePage.Parent=ContentHolder

local LCol=Instance.new("Frame"); LCol.Size=UDim2.new(0,350,1,0); LCol.BackgroundTransparency=1; LCol.ZIndex=12; LCol.Parent=RagePage
local ColSep=Instance.new("Frame"); ColSep.Size=UDim2.new(0,1,0.96,0); ColSep.Position=UDim2.new(0,350,0.02,0)
ColSep.BackgroundColor3=Color3.fromRGB(0,88,215); ColSep.BackgroundTransparency=0.42
ColSep.BorderSizePixel=0; ColSep.ZIndex=11; ColSep.Parent=RagePage
local RCol=Instance.new("Frame"); RCol.Size=UDim2.new(0,364,1,0); RCol.Position=UDim2.new(0,354,0,0)
RCol.BackgroundTransparency=1; RCol.ZIndex=12; RCol.Parent=RagePage

-- ─── HELPER: Section header ───────────────────────────────────
local function mkSection(parent, text, posY)
    local dia=Instance.new("Frame"); dia.Size=UDim2.new(0,7,0,7); dia.Position=UDim2.new(0,12,0,posY+6)
    dia.BackgroundColor3=Color3.fromRGB(0,130,255); dia.BorderSizePixel=0; dia.Rotation=45; dia.ZIndex=13; dia.Parent=parent
    local h=Instance.new("TextLabel"); h.Size=UDim2.new(1,-30,0,19); h.Position=UDim2.new(0,26,0,posY)
    h.BackgroundTransparency=1; h.Text=text; h.TextColor3=Color3.fromRGB(220,225,248)
    h.TextSize=13; h.Font=Enum.Font.GothamBold; h.TextXAlignment=Enum.TextXAlignment.Left; h.ZIndex=13; h.Parent=parent
    local uLine=Instance.new("Frame"); uLine.Size=UDim2.new(1,-20,0,1); uLine.Position=UDim2.new(0,12,0,posY+21)
    uLine.BackgroundColor3=Color3.fromRGB(0,100,225); uLine.BorderSizePixel=0; uLine.ZIndex=13; uLine.Parent=parent
    local uG=Instance.new("UIGradient"); uG.Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,  Color3.fromRGB(0,122,255)),
        ColorSequenceKeypoint.new(0.55,Color3.fromRGB(0,74,174)),
        ColorSequenceKeypoint.new(1,  Color3.fromRGB(0,0,0))}); uG.Parent=uLine
end

-- ─── HELPER: Label ────────────────────────────────────────────
local function mkLabel(parent, text, posY, color)
    local l=Instance.new("TextLabel"); l.Size=UDim2.new(1,-20,0,16); l.Position=UDim2.new(0,14,0,posY)
    l.BackgroundTransparency=1; l.Text=text; l.TextColor3=color or Color3.fromRGB(118,124,148)
    l.TextSize=11; l.Font=Enum.Font.Gotham; l.TextXAlignment=Enum.TextXAlignment.Left; l.ZIndex=13; l.Parent=parent
end

-- ─── HELPER: Checkbox (functional toggle) ─────────────────────
local function mkCheckbox(parent, text, posY, initOn)
    local state={on=initOn}
    local row=Instance.new("Frame"); row.Size=UDim2.new(1,-20,0,20); row.Position=UDim2.new(0,14,0,posY)
    row.BackgroundTransparency=1; row.ZIndex=13; row.Parent=parent

    local box=Instance.new("Frame"); box.Size=UDim2.new(0,13,0,13); box.Position=UDim2.new(0,0,0.5,-7)
    box.BackgroundColor3=state.on and Color3.fromRGB(0,112,255) or Color3.fromRGB(10,9,20)
    box.BorderSizePixel=0; box.ZIndex=14; box.Parent=row
    local boxC=Instance.new("UICorner"); boxC.CornerRadius=UDim.new(0,2); boxC.Parent=box
    local boxS=Instance.new("UIStroke"); boxS.Color=state.on and Color3.fromRGB(60,165,255) or Color3.fromRGB(42,50,92); boxS.Thickness=1; boxS.Parent=box
    local ig=Instance.new("Frame"); ig.Size=UDim2.new(0.56,0,0.56,0); ig.Position=UDim2.new(0.22,0,0.22,0)
    ig.BackgroundColor3=Color3.fromRGB(175,220,255); ig.BackgroundTransparency=state.on and 0.08 or 1
    ig.BorderSizePixel=0; ig.ZIndex=15; ig.Parent=box
    local igC=Instance.new("UICorner"); igC.CornerRadius=UDim.new(0,2); igC.Parent=ig

    local lbl=Instance.new("TextLabel"); lbl.Size=UDim2.new(1,-20,1,0); lbl.Position=UDim2.new(0,20,0,0)
    lbl.BackgroundTransparency=1; lbl.Text=text
    lbl.TextColor3=state.on and Color3.fromRGB(200,212,238) or Color3.fromRGB(130,135,158)
    lbl.TextSize=11; lbl.Font=Enum.Font.Gotham; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.ZIndex=14; lbl.Parent=row

    local btn=Instance.new("TextButton"); btn.Size=UDim2.new(1,0,1,0)
    btn.BackgroundTransparency=1; btn.Text=""; btn.ZIndex=16; btn.Parent=row
    btn.MouseEnter:Connect(function() if not state.on then lbl.TextColor3=Color3.fromRGB(168,174,198) end end)
    btn.MouseLeave:Connect(function() if not state.on then lbl.TextColor3=Color3.fromRGB(130,135,158) end end)
    btn.MouseButton1Click:Connect(function()
        state.on=not state.on
        local bc=state.on and Color3.fromRGB(0,112,255) or Color3.fromRGB(10,9,20)
        local sc=state.on and Color3.fromRGB(60,165,255) or Color3.fromRGB(42,50,92)
        local it=state.on and 0.08 or 1
        local tc=state.on and Color3.fromRGB(200,212,238) or Color3.fromRGB(130,135,158)
        TweenService:Create(box,TweenInfo.new(0.18,Enum.EasingStyle.Sine),{BackgroundColor3=bc}):Play()
        TweenService:Create(boxS,TweenInfo.new(0.18,Enum.EasingStyle.Sine),{Color=sc}):Play()
        TweenService:Create(ig,TweenInfo.new(0.18,Enum.EasingStyle.Sine),{BackgroundTransparency=it}):Play()
        TweenService:Create(lbl,TweenInfo.new(0.18,Enum.EasingStyle.Sine),{TextColor3=tc}):Play()
    end)
end

-- ─── HELPER: Slider (functional drag) ─────────────────────────
local function mkSlider(parent, posY, initVal, maxVal)
    local state={val=initVal}
    local track=Instance.new("Frame"); track.Size=UDim2.new(1,-28,0,6); track.Position=UDim2.new(0,14,0,posY)
    track.BackgroundColor3=Color3.fromRGB(11,10,22); track.BorderSizePixel=0; track.ZIndex=13; track.Parent=parent
    local tC=Instance.new("UICorner"); tC.CornerRadius=UDim.new(1,0); tC.Parent=track
    local tS=Instance.new("UIStroke"); tS.Color=Color3.fromRGB(0,42,108); tS.Thickness=1; tS.Parent=track

    local fill=Instance.new("Frame"); fill.Size=UDim2.new(state.val/maxVal,0,1,0)
    fill.BackgroundColor3=Color3.fromRGB(0,112,245); fill.BorderSizePixel=0; fill.ZIndex=14; fill.Parent=track
    local fC=Instance.new("UICorner"); fC.CornerRadius=UDim.new(1,0); fC.Parent=fill
    local fG=Instance.new("UIGradient"); fG.Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,Color3.fromRGB(0,68,188)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(78,188,255))}); fG.Parent=fill

    local thumb=Instance.new("Frame"); thumb.Size=UDim2.new(0,12,0,12); thumb.Position=UDim2.new(1,-6,0.5,-6)
    thumb.BackgroundColor3=Color3.fromRGB(118,205,255); thumb.BorderSizePixel=0; thumb.ZIndex=15; thumb.Parent=fill
    local thC=Instance.new("UICorner"); thC.CornerRadius=UDim.new(1,0); thC.Parent=thumb

    local valLbl=Instance.new("TextLabel"); valLbl.Size=UDim2.new(0,52,0,14); valLbl.Position=UDim2.new(1,-58,0,posY-16)
    valLbl.BackgroundTransparency=1; valLbl.Text=tostring(state.val)
    valLbl.TextColor3=Color3.fromRGB(62,100,160); valLbl.TextSize=11; valLbl.Font=Enum.Font.GothamBold
    valLbl.TextXAlignment=Enum.TextXAlignment.Right; valLbl.ZIndex=13; valLbl.Parent=parent

    local btn=Instance.new("TextButton"); btn.Size=UDim2.new(1,0,0,20); btn.Position=UDim2.new(0,0,0,-7)
    btn.BackgroundTransparency=1; btn.Text=""; btn.ZIndex=16; btn.Parent=track

    local sliding=false
    local function upd(inputX)
        local ax=track.AbsolutePosition.X; local aw=track.AbsoluteSize.X
        local frac=math.clamp((inputX-ax)/aw,0,1)
        state.val=math.round(frac*maxVal)
        TweenService:Create(fill,TweenInfo.new(0.08),{Size=UDim2.new(frac,0,1,0)}):Play()
        valLbl.Text=tostring(state.val)
    end
    btn.MouseButton1Down:Connect(function(x) sliding=true; upd(x) end)
    btn.MouseButton1Up:Connect(function() sliding=false end)
    UserInputService.InputChanged:Connect(function(inp)
        if sliding and inp.UserInputType==Enum.UserInputType.MouseMovement then upd(inp.Position.X) end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 then sliding=false end
    end)
    btn.MouseEnter:Connect(function()
        TweenService:Create(thumb,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(200,235,255)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(thumb,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(118,205,255)}):Play()
    end)
end

-- ─── HELPER: Dropdown — panel parented to ScreenGui so it's never clipped ──
-- This means the popup always renders on top of everything, regardless of
-- ClipsDescendants on the menu or column frames.
local openDropdown = nil   -- {panel, arr, closeFunc}

local function mkDropdown(parent, options, posY)
    local state = {idx = 1}
    local itemH  = 26
    local panW   = 0   -- will be set from bg.AbsoluteSize once rendered

    -- ── Button bar ──────────────────────────────────────────
    local bg = Instance.new("Frame")
    bg.Size             = UDim2.new(1,-28,0,24)
    bg.Position         = UDim2.new(0,14,0,posY)
    bg.BackgroundColor3 = Color3.fromRGB(9,8,20)
    bg.BorderSizePixel  = 0; bg.ZIndex = 13; bg.Parent = parent
    local bgC = Instance.new("UICorner"); bgC.CornerRadius = UDim.new(0,4); bgC.Parent = bg
    local bgS = Instance.new("UIStroke"); bgS.Color = Color3.fromRGB(0,52,128); bgS.Thickness = 1; bgS.Parent = bg

    local acc = Instance.new("Frame"); acc.Size = UDim2.new(0,2,0.7,0); acc.Position = UDim2.new(0,0,0.15,0)
    acc.BackgroundColor3 = Color3.fromRGB(0,115,245); acc.BorderSizePixel = 0; acc.ZIndex = 14; acc.Parent = bg

    local lbl = Instance.new("TextLabel"); lbl.Size = UDim2.new(1,-30,1,0); lbl.Position = UDim2.new(0,10,0,0)
    lbl.BackgroundTransparency = 1; lbl.Text = options[1]
    lbl.TextColor3 = Color3.fromRGB(200,205,228); lbl.TextSize = 11; lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.ZIndex = 14; lbl.Parent = bg

    local arr = Instance.new("TextLabel"); arr.Size = UDim2.new(0,22,1,0); arr.Position = UDim2.new(1,-24,0,0)
    arr.BackgroundTransparency = 1; arr.Text = "▾"; arr.TextColor3 = Color3.fromRGB(0,122,238)
    arr.TextSize = 13; arr.Font = Enum.Font.GothamBold; arr.TextXAlignment = Enum.TextXAlignment.Center
    arr.ZIndex = 14; arr.Parent = bg

    -- ── Popup panel — parented to ScreenGui, positioned via AbsolutePosition ──
    local panelH = #options * itemH + 6
    local panel = Instance.new("Frame")
    panel.Size             = UDim2.new(0,160,0,panelH)   -- width set on open
    panel.BackgroundColor3 = Color3.fromRGB(11,9,24)
    panel.BorderSizePixel  = 0
    panel.ZIndex           = 500          -- far above everything
    panel.Visible          = false
    panel.Parent           = ScreenGui    -- KEY: not inside menu, so never clipped

    local panC = Instance.new("UICorner"); panC.CornerRadius = UDim.new(0,5); panC.Parent = panel
    local panS = Instance.new("UIStroke"); panS.Color = Color3.fromRGB(0,80,190); panS.Thickness = 1; panS.Transparency = 0.1; panS.Parent = panel

    -- Subtle inner gradient
    local panG = Instance.new("UIGradient"); panG.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(15,12,32)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 7, 18)),
    }); panG.Rotation = 90; panG.Parent = panel

    -- ── Option rows ─────────────────────────────────────────
    local optRows = {}
    for oi, opt in ipairs(options) do
        local row = Instance.new("Frame")
        row.Size             = UDim2.new(1,0,0,itemH)
        row.Position         = UDim2.new(0,0,0,(oi-1)*itemH+3)
        row.BackgroundColor3 = Color3.fromRGB(0,60,155)
        row.BackgroundTransparency = 1
        row.BorderSizePixel  = 0; row.ZIndex = 501; row.Parent = panel

        -- Left active marker bar
        local mark = Instance.new("Frame")
        mark.Size             = UDim2.new(0,3,0.55,0)
        mark.Position         = UDim2.new(0,0,0.225,0)
        mark.BackgroundColor3 = Color3.fromRGB(0,130,255)
        mark.BorderSizePixel  = 0; mark.ZIndex = 502; mark.Parent = row
        mark.Visible          = (oi == state.idx)

        local optLbl = Instance.new("TextLabel")
        optLbl.Size             = UDim2.new(1,-20,1,0)
        optLbl.Position         = UDim2.new(0,12,0,0)
        optLbl.BackgroundTransparency = 1
        optLbl.Text             = opt
        optLbl.TextColor3       = (oi==state.idx) and Color3.fromRGB(255,255,255) or Color3.fromRGB(148,153,178)
        optLbl.TextSize         = 11
        optLbl.Font             = (oi==state.idx) and Enum.Font.GothamBold or Enum.Font.Gotham
        optLbl.TextXAlignment   = Enum.TextXAlignment.Left
        optLbl.ZIndex           = 502; optLbl.Parent = row

        local rowBtn = Instance.new("TextButton")
        rowBtn.Size             = UDim2.new(1,0,1,0)
        rowBtn.BackgroundTransparency = 1; rowBtn.Text = ""
        rowBtn.ZIndex           = 503; rowBtn.Parent = row

        rowBtn.MouseEnter:Connect(function()
            TweenService:Create(row,TweenInfo.new(0.1),{BackgroundTransparency=0.82}):Play()
        end)
        rowBtn.MouseLeave:Connect(function()
            if oi ~= state.idx then
                TweenService:Create(row,TweenInfo.new(0.1),{BackgroundTransparency=1}):Play()
            end
        end)

        rowBtn.MouseButton1Click:Connect(function()
            state.idx = oi
            lbl.Text  = opt
            -- Update all rows
            for ci, r in ipairs(optRows) do
                local m  = r:FindFirstChildOfClass("Frame")
                local ol = r:FindFirstChildOfClass("TextLabel")
                if m  then m.Visible = (ci==oi) end
                if ol then
                    ol.TextColor3 = (ci==oi) and Color3.fromRGB(255,255,255) or Color3.fromRGB(148,153,178)
                    ol.Font       = (ci==oi) and Enum.Font.GothamBold or Enum.Font.Gotham
                end
                TweenService:Create(r,TweenInfo.new(0.1),{BackgroundTransparency=1}):Play()
            end
            -- Close
            panel.Visible = false
            openDropdown  = nil
            arr.Text      = "▾"
            TweenService:Create(arr,TweenInfo.new(0.15),{TextColor3=Color3.fromRGB(0,122,238)}):Play()
            TweenService:Create(bgS,TweenInfo.new(0.15),{Color=Color3.fromRGB(0,52,128)}):Play()
        end)

        optRows[oi] = row
    end

    -- ── Helper: position panel below the button on screen ───
    local function openPanel()
        -- Read button's screen-space position
        local abs  = bg.AbsolutePosition
        local sz   = bg.AbsoluteSize
        panW       = sz.X   -- match button width exactly

        panel.Size     = UDim2.new(0,panW,0,panelH)
        panel.Position = UDim2.new(0, abs.X, 0, abs.Y + sz.Y + 3)
        panel.Visible  = true
    end

    local function closePanel()
        panel.Visible = false
        openDropdown  = nil
        arr.Text      = "▾"
        TweenService:Create(arr,TweenInfo.new(0.15),{TextColor3=Color3.fromRGB(0,122,238)}):Play()
        TweenService:Create(bgS,TweenInfo.new(0.15),{Color=Color3.fromRGB(0,52,128)}):Play()
    end

    -- ── Toggle button ────────────────────────────────────────
    local mainBtn = Instance.new("TextButton")
    mainBtn.Size             = UDim2.new(1,0,1,0)
    mainBtn.BackgroundTransparency = 1; mainBtn.Text = ""
    mainBtn.ZIndex           = 15; mainBtn.Parent = bg

    mainBtn.MouseEnter:Connect(function()
        TweenService:Create(bg,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(14,12,30)}):Play()
    end)
    mainBtn.MouseLeave:Connect(function()
        TweenService:Create(bg,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(9,8,20)}):Play()
    end)

    mainBtn.MouseButton1Click:Connect(function()
        -- Close any other open dropdown first
        if openDropdown and openDropdown ~= closePanel then
            openDropdown()   -- call its close function
        end

        if panel.Visible then
            closePanel()
        else
            openPanel()
            openDropdown = closePanel   -- store close function
            arr.Text     = "▴"
            TweenService:Create(arr,TweenInfo.new(0.15),{TextColor3=Color3.fromRGB(120,190,255)}):Play()
            TweenService:Create(bgS,TweenInfo.new(0.15),{Color=Color3.fromRGB(0,90,200)}):Play()
        end
    end)
end

-- ─── RAGE TAB — LEFT COLUMN ───────────────────────────────────
mkSection(LCol,"Target Aim",6)
mkCheckbox(LCol,"Enabled",32,true)
mkLabel(LCol,"Keybind",58,Color3.fromRGB(90,95,120))
mkLabel(LCol,"Aim Part",76,Color3.fromRGB(100,106,132))
mkDropdown(LCol,{"HumanoidRootPart","Head","UpperTorso","LowerTorso","RightArm","LeftArm"},91)
mkCheckbox(LCol,"Auto Shoot",125,false)
mkCheckbox(LCol,"Auto Reload",148,false)
mkCheckbox(LCol,"Look At Target",171,false)
mkCheckbox(LCol,"Spectate Target",194,false)
mkCheckbox(LCol,"Auto Switch",217,false)
mkCheckbox(LCol,"Closest Body Part",240,false)
mkCheckbox(LCol,"Use Air Part",265,false)
mkLabel(LCol,"Air Part",289,Color3.fromRGB(100,106,132))
mkDropdown(LCol,{"LowerTorso","UpperTorso","Head","HumanoidRootPart"},304)
mkCheckbox(LCol,"Anti Ground Shots",338,false)
mkLabel(LCol,"Takeoff Amount",365,Color3.fromRGB(100,106,132))
mkSlider(LCol,382,7,20)
mkCheckbox(LCol,"Use FOV",407,false)
mkCheckbox(LCol,"Visualize FOV",430,false)
mkLabel(LCol,"FOV Radius",456,Color3.fromRGB(100,106,132))
mkSlider(LCol,473,100,500)
mkLabel(LCol,"FOV Color",494,Color3.fromRGB(100,106,132))

local FovSwatch=Instance.new("Frame"); FovSwatch.Size=UDim2.new(0,28,0,16); FovSwatch.Position=UDim2.new(1,-44,0,494)
FovSwatch.BackgroundColor3=Color3.fromRGB(220,30,80); FovSwatch.BorderSizePixel=0; FovSwatch.ZIndex=14; FovSwatch.Parent=LCol
local FSC=Instance.new("UICorner"); FSC.CornerRadius=UDim.new(0,3); FSC.Parent=FovSwatch
local FSS=Instance.new("UIStroke"); FSS.Color=Color3.fromRGB(255,80,130); FSS.Thickness=1; FSS.Transparency=0.38; FSS.Parent=FovSwatch

mkCheckbox(LCol,"Use Checks",520,false)

-- ─── RAGE TAB — RIGHT COLUMN ──────────────────────────────────
mkSection(RCol,"Target Strafe",6)
mkCheckbox(RCol,"Enabled",32,false)
mkLabel(RCol,"Keybind",58,Color3.fromRGB(90,95,120))
mkCheckbox(RCol,"Bypass Destroy",76,false)
mkLabel(RCol,"Pattern",102,Color3.fromRGB(100,106,132))
mkDropdown(RCol,{"Normal","Circle","Figure8","Random"},117)
mkLabel(RCol,"Speed",154,Color3.fromRGB(100,106,132))
mkSlider(RCol,171,1,10)
mkLabel(RCol,"Height",197,Color3.fromRGB(100,106,132))
mkSlider(RCol,214,5,30)
mkLabel(RCol,"Distance",240,Color3.fromRGB(100,106,132))
mkSlider(RCol,257,10,50)
mkSection(RCol,"Stomp",284)
mkCheckbox(RCol,"Auto Stomp",310,false)
mkCheckbox(RCol,"Target Only (TP Mode)",333,false)
mkCheckbox(RCol,"Knock Stomp",360,false)
mkCheckbox(RCol,"Target Only",383,false)
mkCheckbox(RCol,"Use Range",406,true)
mkLabel(RCol,"Range (studs)",434,Color3.fromRGB(100,106,132))
local RangeLbl=Instance.new("TextLabel"); RangeLbl.Size=UDim2.new(1,-20,0,20); RangeLbl.Position=UDim2.new(0,14,0,452)
RangeLbl.BackgroundTransparency=1; RangeLbl.Text="50"
RangeLbl.TextColor3=Color3.fromRGB(76,148,232); RangeLbl.TextSize=15
RangeLbl.Font=Enum.Font.GothamBold; RangeLbl.TextXAlignment=Enum.TextXAlignment.Left; RangeLbl.ZIndex=13; RangeLbl.Parent=RCol

-- ─── OTHER PAGES ──────────────────────────────────────────────
local VisualsPage  = mkComingSoon(ContentHolder)
local WorldPage    = mkComingSoon(ContentHolder)
local ExploitsPage = mkComingSoon(ContentHolder)
local SettingsPage = mkComingSoon(ContentHolder)

VisualsPage.Visible=false; WorldPage.Visible=false
ExploitsPage.Visible=false; SettingsPage.Visible=false

-- ─── TAB BUTTONS ──────────────────────────────────────────────
local tabPages={RagePage,VisualsPage,WorldPage,ExploitsPage,SettingsPage}
local tabNames={"Rage","Visuals","World","Exploits","Settings"}
local tabBtns={}

for i, name in ipairs(tabNames) do
    local btn=Instance.new("TextButton")
    btn.Size=UDim2.new(0,108,1,0); btn.Position=UDim2.new(0,(i-1)*108,0,0)
    btn.BackgroundTransparency=1; btn.Text=name
    btn.TextColor3=(i==1) and Color3.fromRGB(255,255,255) or Color3.fromRGB(110,116,144)
    btn.TextSize=12; btn.Font=(i==1) and Enum.Font.GothamBold or Enum.Font.Gotham
    btn.ZIndex=12; btn.Parent=TabBar

    local ul=Instance.new("Frame"); ul.Position=UDim2.new(0.175,0,1,-2); ul.BorderSizePixel=0; ul.ZIndex=13; ul.Parent=btn
    ul.BackgroundColor3=Color3.fromRGB(0,135,255)
    ul.Size=(i==1) and UDim2.new(0.65,0,0,2) or UDim2.new(0,0,0,2)
    local ULC=Instance.new("UICorner"); ULC.CornerRadius=UDim.new(1,0); ULC.Parent=ul

    local tbg=Instance.new("Frame"); tbg.Size=UDim2.new(1,0,1,0)
    tbg.BackgroundColor3=Color3.fromRGB(0,55,145)
    tbg.BackgroundTransparency=(i==1) and 0.87 or 1
    tbg.BorderSizePixel=0; tbg.ZIndex=11; tbg.Parent=btn

    tabBtns[i]={btn=btn,ul=ul,tbg=tbg}

    btn.MouseButton1Click:Connect(function()
        -- Close any open dropdown
        if openDropdown then openDropdown() end
        for j=1,#tabPages do
            tabPages[j].Visible=false
            TweenService:Create(tabBtns[j].ul,TweenInfo.new(0.22,Enum.EasingStyle.Sine),{Size=UDim2.new(0,0,0,2)}):Play()
            TweenService:Create(tabBtns[j].tbg,TweenInfo.new(0.22,Enum.EasingStyle.Sine),{BackgroundTransparency=1}):Play()
            tabBtns[j].btn.TextColor3=Color3.fromRGB(110,116,144); tabBtns[j].btn.Font=Enum.Font.Gotham
        end
        tabPages[i].Visible=true
        TweenService:Create(tabBtns[i].ul,TweenInfo.new(0.25,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=UDim2.new(0.65,0,0,2)}):Play()
        TweenService:Create(tabBtns[i].tbg,TweenInfo.new(0.22,Enum.EasingStyle.Sine),{BackgroundTransparency=0.87}):Play()
        btn.TextColor3=Color3.fromRGB(255,255,255); btn.Font=Enum.Font.GothamBold
    end)

    btn.MouseEnter:Connect(function()
        if tabPages[i].Visible then return end
        TweenService:Create(btn,TweenInfo.new(0.14),{TextColor3=Color3.fromRGB(180,186,210)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        if tabPages[i].Visible then return end
        TweenService:Create(btn,TweenInfo.new(0.14),{TextColor3=Color3.fromRGB(110,116,144)}):Play()
    end)
end

-- Close any open dropdown when clicking outside
UserInputService.InputBegan:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.MouseButton1 and openDropdown then
        task.defer(function()
            if openDropdown then openDropdown() end
        end)
    end
end)

-- ─── DRAG ─────────────────────────────────────────────────────
local dragging,dragStart,dragOrigin=false,nil,nil
TBar.InputBegan:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.MouseButton1 then
        dragging=true; dragStart=inp.Position; dragOrigin=Menu.Position
    end
end)
TBar.InputEnded:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
end)
UserInputService.InputChanged:Connect(function(inp)
    if dragging and inp.UserInputType==Enum.UserInputType.MouseMovement then
        local d=inp.Position-dragStart
        Menu.Position=UDim2.new(dragOrigin.X.Scale,dragOrigin.X.Offset+d.X,dragOrigin.Y.Scale,dragOrigin.Y.Offset+d.Y)
    end
end)

-- ═══════════════════════════════════════════════════════════════
--  LOADING SEQUENCE
-- ═══════════════════════════════════════════════════════════════
task.spawn(function()
    task.wait(1.0)

    -- Letter-by-letter
    local full="REVELENCY"
    for i=1,#full do
        TitleLbl.Text=full:sub(1,i); TitleGlow.Text=full:sub(1,i)
        task.wait(0.28)
    end
    task.delay(1.5,function() if Cursor then Cursor.TextTransparency=1 end end)
    TweenService:Create(TagLbl,TweenInfo.new(1.1),{TextTransparency=0}):Play()
    task.wait(0.8)

    -- Progress bar
    local pct=0
    while pct<100 do
        pct=math.min(pct+1,100)
        TweenService:Create(BarFill,TweenInfo.new(0.22,Enum.EasingStyle.Sine),{Size=UDim2.new(pct/100,0,1,0)}):Play()
        PctLbl.Text=pct.."%"
        if StatusSteps[pct] then StatusLbl.Text=StatusSteps[pct] end
        local d
        if     pct<10  then d=math.random(26,46)/100
        elseif pct<40  then d=math.random(14,28)/100
        elseif pct<70  then d=math.random(10,21)/100
        elseif pct<90  then d=math.random(14,28)/100
        else                d=math.random(28,50)/100
        end
        task.wait(d)
    end
    task.wait(1.5)

    -- === FADE OUT LOADING ===
    TweenService:Create(Blur,TweenInfo.new(1.1),{Size=0}):Play()
    for _,c in ipairs(LoadFrame:GetDescendants()) do
        pcall(function()
            if c:IsA("TextLabel") then TweenService:Create(c,TweenInfo.new(0.75),{TextTransparency=1}):Play() end
            if c:IsA("Frame")     then TweenService:Create(c,TweenInfo.new(0.75),{BackgroundTransparency=1}):Play() end
        end)
    end
    TweenService:Create(LoadFrame,TweenInfo.new(0.9,Enum.EasingStyle.Sine),{BackgroundTransparency=1}):Play()
    task.wait(1.0)
    LoadFrame.Visible=false

    -- === SOUNDS ===
    pcall(function() SndWhoosh:Play() end)
    task.delay(0.1,function() pcall(function() SndChime:Play() end) end)

    -- === MENU SLIDE-IN ===
    Menu.Visible=true
    Menu.Position=UDim2.new(0.5,-MENU_W/2,0.5,-MENU_H/2-48)
    Menu.BackgroundTransparency=1

    TweenService:Create(Menu,TweenInfo.new(0.75,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
        Position=UDim2.new(0.5,-MENU_W/2,0.5,-MENU_H/2),
        BackgroundTransparency=0,
    }):Play()

    -- Fade in all text after the slide completes
    task.delay(0.3,function()
        for _,c in ipairs(Menu:GetDescendants()) do
            pcall(function()
                if c:IsA("TextLabel") or c:IsA("TextButton") then
                    c.TextTransparency=1
                    TweenService:Create(c,TweenInfo.new(0.5),{TextTransparency=0}):Play()
                end
            end)
        end
    end)
end)

print("[REVELENCY] Loaded.")
