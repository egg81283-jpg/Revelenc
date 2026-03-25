--// UNIVERSAL Da Hood / Da Strike / Zee Hood — FINAL (NO PREDICTION FOR ZEE)
--// 🔥 Для Zee Hood: предсказание = 0, camlock без смещения
--// 🔥 Автоматический поиск ремоута + fallback на tool:Activate()

-- ========== НАСТРОЙКИ ==========
getgenv().ResolveKey = "C"
getgenv().CamlockKey = "F"
getgenv().SilentKey = "V"
getgenv().AutoAirKey = "B"
getgenv().TriggerKey = "T"
getgenv().GuiKey = "M"
getgenv().LegitSmoothKey = "L"
getgenv().BlatantKey = "K"
getgenv().SilentLockKey = "Q"
getgenv().AutoShootKey = "J"
getgenv().ComboKey = "N"

getgenv().Smoothing = 0.35
getgenv().LegitSmoothing = 0.018
getgenv().BlatantSmoothing = 0.070
getgenv().Radius = 235
getgenv().TriggerFOV = 50
getgenv().JumpOffsetBase = -0.5
getgenv().FallOffsetBase = -0.5
getgenv().AirExtraBoostBase = 0.048
getgenv().AirVelFactor = 0.00285
getgenv().VelSmooth = 0.78
getgenv().airTriggerDelay = 0.15
getgenv().airFireRate = 0.015
getgenv().TriggerFireRate = 0.032
getgenv().useHoldMode = false

-- ========== ОТКЛЮЧАЕМ ПРЕДСКАЗАНИЕ ДЛЯ ZEE HOOD ==========
local placeId = game.PlaceId
if placeId == 99692075138533 then
    getgenv().BasePred = 0
    getgenv().PredPingFactor = 0
    getgenv().PredDistFactor = 0
    getgenv().PredVelFactor = 0
    getgenv().MaxPred = 0
    getgenv().MinPred = 0
    getgenv().PredX = 0
    getgenv().PredY = 0
    print("🔧 Zee Hood: предсказание отключено (0)")
else
    getgenv().BasePred = 0.16382699999999998
    getgenv().PredPingFactor = 0.00029
    getgenv().PredDistFactor = 0.000052
    getgenv().PredVelFactor = 0.0102
    getgenv().MaxPred = 0.16382699999999998
    getgenv().MinPred = 0.16382699999999998
    getgenv().PredX = 0.16382699999999998
    getgenv().PredY = 0.16382699999999998
end

-- ========== АНТИЧИТ БАЙПАС (Adonis) ==========
local g = getinfo or debug.getinfo
local d = false
local h = {}
local x, y
setthreadidentity(2)
for i, v in getgc(true) do
    if typeof(v) == "table" then
        local a = rawget(v, "Detected")
        local b = rawget(v, "Kill")
        if typeof(a) == "function" and not x then
            x = a
            local o; o = hookfunction(x, function(c, f, n) if c ~= "_" then if d then warn(`Adonis AntiCheat flagged\nMethod: {c}\nInfo: {f}`) end end return true end)
            table.insert(h, x)
        end
        if rawget(v, "Variables") and rawget(v, "Process") and typeof(b) == "function" and not y then
            y = b
            local o; o = hookfunction(y, function(f) if d then warn(`Adonis AntiCheat tried to kill (fallback): {f}`) end end)
            table.insert(h, y)
        end
    end
end
local o; o = hookfunction(getrenv().debug.info, newcclosure(function(...)
    local a, f = ...
    if x and a == x then if d then warn(`zins | adonis bypassed`) end return coroutine.yield(coroutine.running()) end
    return o(...)
end))
setthreadidentity(7)
-- ========== КОНЕЦ БАЙПАСА ==========

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Stats = game:GetService("Stats")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local WS = game:GetService("Workspace")
local RS = game:GetService("ReplicatedStorage")

local MainRemote = nil
local ShootArg = nil
local detectedGame = "Unknown"

-- ========== ОПРЕДЕЛЕНИЕ РЕМОУТА ==========
local function findShootRemote()
    -- Приоритетные названия и аргументы
    local candidates = {
        {name = "MainEvent", arg = "UpdateMousePos"},
        {name = "MAINEVENT", arg = "MOUSE"},
        {name = "ChangeCharEvent", arg = "UpdateMousePos"},
        {name = "MacroSpeedRemote", arg = "UpdateMousePos"},
        {name = "MacroToggleRemote", arg = "UpdateMousePos"},
        {name = "SprintToggle", arg = "UpdateMousePos"},
        {name = "IsAFK", arg = "UpdateMousePos"},
        {name = "NotifyEvent", arg = "UpdateMousePos"},
        {name = "EmojiToggleEvent", arg = "UpdateMousePos"},
        {name = "SaveFOV", arg = "UpdateMousePos"},
        {name = "5dbf757a-9c7c-4551-ad0e-89ffa3b8ab1f", arg = "UpdateMousePos"},
    }
    
    for _, cand in ipairs(candidates) do
        local remote = RS:FindFirstChild(cand.name)
        if remote and (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) then
            return remote, cand.arg
        end
    end
    
    -- Если не нашли, берём любой RemoteEvent
    for _, obj in ipairs(RS:GetChildren()) do
        if obj:IsA("RemoteEvent") then
            return obj, "UpdateMousePos"
        end
    end
    return nil, nil
end

local function detectRemote()
    if placeId == 99692075138533 then
        detectedGame = "Zee Hood"
        local remote, arg = findShootRemote()
        if remote then
            MainRemote = remote
            ShootArg = arg
            detectedGame = "Zee Hood (" .. remote.Name .. ")"
            print("✅ Используем ремоут: " .. remote.Name .. " с аргументом: " .. arg)
            return true
        else
            warn("⚠️ Не найден RemoteEvent. Будет использован tool:Activate()")
            return false
        end
    elseif placeId == 2788229376 or placeId == 7213786345 then
        MainRemote = RS:FindFirstChild("MainEvent")
        ShootArg = "UpdateMousePos"
        detectedGame = "Da Hood"
    elseif placeId == 5602055394 or placeId == 7951883376 then
        MainRemote = RS:FindFirstChild("Bullets")
        ShootArg = "MousePos"
        detectedGame = "Hood Modded"
    elseif RS:FindFirstChild("MAINEVENT") then
        MainRemote = RS.MAINEVENT
        ShootArg = "MOUSE"
        detectedGame = "Da Strike"
    else
        for _, remote in ipairs(RS:GetChildren()) do
            if remote:IsA("RemoteEvent") and (remote.Name:lower():find("main") or remote.Name:lower():find("shoot") or remote.Name:lower():find("mouse")) then
                MainRemote = remote
                ShootArg = "UpdateMousePos"
                detectedGame = "Copy (" .. remote.Name .. ")"
                break
            end
        end
    end
    return MainRemote ~= nil
end

detectRemote()

if not MainRemote then
    warn("⚠️ Remote не найден. Silent Aim работать не будет, но Auto Shoot (J) будет стрелять через Activate()")
end

print("✅ Detected: " .. detectedGame)
if MainRemote then
    print("   Remote: " .. MainRemote.Name .. " | Arg: " .. tostring(ShootArg))
end

-- ========== ОСТАЛЬНЫЕ ПЕРЕМЕННЫЕ ==========
local resolver = false
local silentAim = false
local camlock = false
local lockedTarget = nil
local autoAirFire = false
local triggerBot = false
local legitSmooth = false
local blatantMode = false
local silentLockEnabled = false
local silentLockedTarget = nil
local autoShoot = false
local comboMode = false

local lastPos, lastTime, lastVel, velHistory = {}, {}, {}, {}
local airStart = {}
local hitCount = 0
local currentPing = 50
local lastAutoFire = 0
local lastTriggerFire = 0
local lastAutoShoot = 0
local forceTarget = nil

local function isKatana(tool)
    if not tool then return false end
    local n = tool.Name:lower()
    return n:find("katana") or (tool.ToolTip and tool.ToolTip:lower():find("katana"))
end

local function isVisible(plr)
    if not plr or not plr.Character or not LocalPlayer.Character then return false end
    local targetPart = plr.Character:FindFirstChild("Head") or plr.Character:FindFirstChild("UpperTorso") or plr.Character:FindFirstChild("HumanoidRootPart")
    if not targetPart then return false end
    local origin = Camera.CFrame.Position
    local direction = (targetPart.Position - origin)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.IgnoreWater = true
    local result = workspace:Raycast(origin, direction, raycastParams)
    if not result then return true end
    return result.Instance and result.Instance:IsDescendantOf(plr.Character)
end

spawn(function()
    while wait(0.3) do
        local pingItem = Stats.Network.ServerStatsItem["Data Ping"]
        currentPing = pingItem and pingItem:GetValue() or 50
    end
end)

-- Функция предсказания (в Zee Hood возвращает 0)
local function getPred(target)
    if placeId == 99692075138533 then return 0 end
    local pingMs = currentPing
    local base = getgenv().BasePred + (pingMs * getgenv().PredPingFactor)
    if target and target.Character and LocalPlayer.Character then
        local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
        local myRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if targetRoot and myRoot then
            local dist = (targetRoot.Position - myRoot.Position).Magnitude
            base = base + dist * getgenv().PredDistFactor
            local targetVel = targetRoot.AssemblyLinearVelocity
            local myVel = myRoot.AssemblyLinearVelocity
            local relVel = (targetVel - myVel).Magnitude
            base = base + relVel * getgenv().PredVelFactor
            if relVel > 55 then base = base + (relVel - 55) * 0.0028 end
            if blatantMode then base = base - 0.0035 end
            local hum = target.Character:FindFirstChild("Humanoid")
            if hum and (hum:GetState() == Enum.HumanoidStateType.Jumping or hum:GetState() == Enum.HumanoidStateType.Freefall) then
                base = base + (math.abs(targetVel.Y) > 12 and 0.0032 or 0.001)
            end
        end
    end
    return math.clamp(base, getgenv().MinPred, getgenv().MaxPred)
end

local function findClosest(customRadius)
    local r = customRadius or getgenv().Radius
    local closest, minDist = nil, r
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChild("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local screen, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    local dist2d = (Vector2.new(screen.X, screen.Y) - center).Magnitude
                    if dist2d < minDist then minDist = dist2d; closest = plr end
                end
            end
        end
    end
    return closest
end

local function getCustomVel(hrp, plr)
    local t = tick()
    if not lastPos[plr] then
        lastPos[plr], lastTime[plr] = hrp.Position, t
        return hrp.AssemblyLinearVelocity
    end
    local dt = math.clamp(t - lastTime[plr], 1/240, 1/30)
    local newVel = (hrp.Position - lastPos[plr]) / dt
    local hist = velHistory[plr] or {}
    table.insert(hist, newVel)
    if #hist > 15 then table.remove(hist, 1) end
    velHistory[plr] = hist
    local avgVel = #hist > 1 and (function() local s = Vector3.zero; for _,v in hist do s += v end; return s/#hist end)() or newVel
    if lastVel[plr] then avgVel = avgVel:Lerp(lastVel[plr], getgenv().VelSmooth) end
    lastVel[plr], lastPos[plr], lastTime[plr] = avgVel, hrp.Position, t
    return avgVel
end

local function getAimPos(plr)
    if not plr or not plr.Character then return Vector3.new() end
    local root = plr.Character:FindFirstChild("HumanoidRootPart")
    if not root then return Vector3.new() end
    
    local partName = blatantMode and "UpperTorso" or "Head"
    local aimPart = plr.Character:FindFirstChild(partName) or root
    
    local pos = aimPart.Position
    local vel = resolver and getCustomVel(root, plr) or root.AssemblyLinearVelocity
    local g = WS.Gravity
    local offsetY = 0
    local hum = plr.Character:FindFirstChild("Humanoid")
    local isAir = hum and (hum:GetState() == Enum.HumanoidStateType.Jumping or hum:GetState() == Enum.HumanoidStateType.Freefall)
    if isAir then
        local baseOffset = (hum:GetState() == Enum.HumanoidStateType.Freefall) and getgenv().FallOffsetBase or getgenv().JumpOffsetBase
        local velEffect = math.abs(vel.Y) * getgenv().AirVelFactor
        offsetY = baseOffset + velEffect + (vel.Y > 0 and getgenv().AirExtraBoostBase or 0)
        if vel.Y > 22 then offsetY = offsetY + (vel.Y - 22) * 0.0011 end
    end
    pos = pos + Vector3.new(0, offsetY, 0)
    
    -- Предсказание (в Zee Hood = 0)
    local predTime = getPred(plr)
    local tX = getgenv().PredX
    local tY = getgenv().PredY
    local predXZ = Vector3.new(vel.X * tX * predTime, 0, vel.Z * tX * predTime)
    local predY = isAir and (vel.Y * tY * predTime - 0.5 * g * (tY * predTime)^2 + (vel.Y > 0 and 0.24 * (tY * predTime) or 0)) or (vel.Y * tY * predTime)
    
    return pos + predXZ + Vector3.new(0, predY, 0)
end

local function hookTool(tool)
    if not tool:IsA("Tool") then return end
    tool.Activated:Connect(function()
        local target = forceTarget
        if not target and silentLockEnabled and silentLockedTarget then target = silentLockedTarget
        elseif not target and silentAim then target = findClosest() end
        if target then
            if MainRemote then
                local aimPos = getAimPos(target)
                pcall(function()
                    MainRemote:FireServer(ShootArg, aimPos)
                end)
                hitCount += 1
            else
                tool:Activate()
                hitCount += 1
            end
        else
            -- Если нет цели, просто стреляем (для Auto Shoot)
            tool:Activate()
        end
    end)
end

local function onChar(char)
    char.ChildAdded:Connect(hookTool)
    for _, v in char:GetChildren() do hookTool(v) end
end
if LocalPlayer.Character then onChar(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(onChar)

-- ========== GUI ==========
local sg = Instance.new("ScreenGui")
sg.Name = "UniversalNeverMissDH"
sg.Parent = game.CoreGui
sg.Enabled = true
local fr = Instance.new("Frame", sg)
fr.Size = UDim2.new(0,460,0,460)
fr.Position = UDim2.new(0,15,0,15)
fr.BackgroundColor3 = Color3.fromRGB(10,10,10)
fr.Draggable = true
Instance.new("UICorner", fr).CornerRadius = UDim.new(0,12)
local lbl = Instance.new("TextLabel", fr)
lbl.Size = UDim2.new(1,0,1,0)
lbl.BackgroundTransparency = 1
lbl.TextColor3 = Color3.new(1,1,1)
lbl.Font = Enum.Font.Code
lbl.TextSize = 13.5
lbl.TextXAlignment = Enum.TextXAlignment.Left
lbl.Position = UDim2.new(0,12,0,0)

local dotGui = Instance.new("ScreenGui")
dotGui.Name = "SilentLockDot"
dotGui.Parent = game.CoreGui
dotGui.ResetOnSpawn = false
local dot = Instance.new("Frame", dotGui)
dot.Size = UDim2.new(0,9,0,9)
dot.AnchorPoint = Vector2.new(0.5,0.5)
dot.BackgroundColor3 = Color3.new(1,1,1)
dot.BorderSizePixel = 0
dot.Visible = false
Instance.new("UICorner", dot).CornerRadius = UDim.new(0,4)

RunService.Heartbeat:Connect(function()
    local lt = lockedTarget and lockedTarget.Name or "None"
    local slt = silentLockedTarget and silentLockedTarget.Name or "None"
    lbl.Text = "Game: "..detectedGame.." | PRED: "..(getgenv().PredX == 0 and "OFF" or "ON").." | PING: "..currentPing.."ms\n"..
               "Silent: "..(silentAim and "ON (V)" or "OFF").."\n"..
               "Silent Lock: "..(silentLockEnabled and "ON (Q) ["..slt.."]" or "OFF").."\n"..
               "Camlock: "..(camlock and "ON (F) ["..lt.."]" or "OFF").."\n"..
               "Combo: "..(comboMode and "ON (N)" or "OFF").."\n"..
               "Resolver: "..(resolver and "ON (C)" or "OFF").."\n"..
               "Blatant: "..(blatantMode and "ON (K)" or "OFF").."\n"..
               "Auto Air: "..(autoAirFire and "ON (B)" or "OFF").."\n"..
               "Trigger: "..(triggerBot and "ON (T)" or "OFF").."\n"..
               "Auto Shoot: "..(autoShoot and "ON (J)" or "OFF").."\n"..
               "Hits: "..hitCount
end)

-- ========== KEYBINDS ==========
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    local k = input.KeyCode.Name
    if k == getgenv().ResolveKey then resolver = not resolver
    elseif k == getgenv().CamlockKey then
        if comboMode then
            local wasOn = camlock
            camlock = not camlock
            silentLockEnabled = camlock
            if camlock and not wasOn then
                local target = findClosest()
                if target then
                    lockedTarget = target
                    silentLockedTarget = target
                    print("🔒 COMBO LOCK ON → "..target.Name)
                end
            else
                lockedTarget = nil
                silentLockedTarget = nil
                print("🔓 COMBO LOCK OFF")
            end
        else
            camlock = not camlock
            lockedTarget = camlock and findClosest() or nil
        end
    elseif k == getgenv().SilentKey then silentAim = not silentAim
    elseif k == getgenv().AutoAirKey then autoAirFire = not autoAirFire
    elseif k == getgenv().TriggerKey then triggerBot = not triggerBot
    elseif k == getgenv().GuiKey then sg.Enabled = not sg.Enabled
    elseif k == getgenv().LegitSmoothKey and not blatantMode then
        legitSmooth = not legitSmooth
        if legitSmooth then blatantMode = false end
    elseif k == getgenv().BlatantKey then
        blatantMode = not blatantMode
        if blatantMode then legitSmooth = false end
    elseif k == getgenv().SilentLockKey then
        if not silentLockEnabled then
            local target = findClosest()
            if target then
                silentLockEnabled = true
                silentLockedTarget = target
                print("🔒 Silent Lock ON → "..target.Name)
            end
        else
            silentLockEnabled = false
            silentLockedTarget = nil
            print("🔓 Silent Lock OFF")
        end
    elseif k == getgenv().AutoShootKey then
        autoShoot = not autoShoot
        print("Auto Shoot: "..(autoShoot and "ВКЛ" or "ВЫКЛ"))
    elseif k == getgenv().ComboKey then
        comboMode = not comboMode
        print("Combo Mode: "..(comboMode and "ВКЛ" or "ВЫКЛ"))
    end
end)

-- ========== CAMLOCK ==========
RunService.RenderStepped:Connect(function()
    if camlock and lockedTarget then
        local aim = getAimPos(lockedTarget)
        local targetCFrame = CFrame.lookAt(Camera.CFrame.Position, aim)
        if blatantMode then
            Camera.CFrame = targetCFrame
        elseif legitSmooth then
            Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, getgenv().LegitSmoothing)
        else
            Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, getgenv().Smoothing)
        end
    end
    
    if silentLockEnabled and silentLockedTarget and silentLockedTarget.Character then
        local partName = blatantMode and "UpperTorso" or "Head"
        local torso = silentLockedTarget.Character:FindFirstChild(partName) or silentLockedTarget.Character:FindFirstChild("HumanoidRootPart")
        if torso then
            local screenPos, onScreen = Camera:WorldToViewportPoint(torso.Position)
            if onScreen then
                dot.Position = UDim2.new(0, screenPos.X, 0, screenPos.Y)
                dot.Visible = true
            else
                dot.Visible = false
            end
        else
            dot.Visible = false
        end
    else
        dot.Visible = false
    end
end)

-- ========== AUTO FUNCTIONS ==========
RunService.Heartbeat:Connect(function()
    local function isLowHP(target)
        if not target or not target.Character then return true end
        local hum = target.Character:FindFirstChild("Humanoid")
        return not hum or hum.Health <= 1
    end
    
    if camlock and lockedTarget and isLowHP(lockedTarget) then
        camlock = false; lockedTarget = nil
    end
    if silentLockEnabled and silentLockedTarget and isLowHP(silentLockedTarget) then
        silentLockEnabled = false; silentLockedTarget = nil
    end
    
    if triggerBot then
        local shouldFire = not getgenv().useHoldMode or UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
        if shouldFire and tick() - lastTriggerFire >= getgenv().TriggerFireRate then
            local target = nil
            if silentLockEnabled and silentLockedTarget then target = silentLockedTarget
            elseif camlock and lockedTarget then target = lockedTarget
            else target = findClosest(getgenv().TriggerFOV) end
            if target and isVisible(target) then
                local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool and not isKatana(tool) then
                    forceTarget = target
                    if MainRemote then
                        local aimPos = getAimPos(target)
                        pcall(function()
                            MainRemote:FireServer(ShootArg, aimPos)
                        end)
                    else
                        tool:Activate()
                    end
                    forceTarget = nil
                    lastTriggerFire = tick()
                    hitCount += 1
                end
            end
        end
    end
    
    if autoShoot then
        if tick() - lastAutoShoot >= getgenv().TriggerFireRate then
            local target = nil
            if silentLockEnabled and silentLockedTarget then target = silentLockedTarget
            elseif camlock and lockedTarget then target = lockedTarget
            elseif silentAim then target = findClosest() end
            if target and isVisible(target) then
                local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool and not isKatana(tool) then
                    forceTarget = target
                    if MainRemote then
                        local aimPos = getAimPos(target)
                        pcall(function()
                            MainRemote:FireServer(ShootArg, aimPos)
                        end)
                    else
                        tool:Activate()
                    end
                    forceTarget = nil
                    lastAutoShoot = tick()
                    hitCount += 1
                end
            end
        end
    end
    
    if autoAirFire then
        local target = (silentLockEnabled and silentLockedTarget) or (camlock and lockedTarget)
        if target and target.Character then
            local hum = target.Character:FindFirstChild("Humanoid")
            if hum then
                local isAir = (hum:GetState() == Enum.HumanoidStateType.Jumping or hum:GetState() == Enum.HumanoidStateType.Freefall)
                if isAir then
                    if not airStart[target] then airStart[target] = tick() end
                    if tick() - airStart[target] >= getgenv().airTriggerDelay and tick() - lastAutoFire >= getgenv().airFireRate then
                        local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                        if tool and not isKatana(tool) then
                            forceTarget = target
                            if MainRemote then
                                local aimPos = getAimPos(target)
                                pcall(function()
                                    MainRemote:FireServer(ShootArg, aimPos)
                                end)
                            else
                                tool:Activate()
                            end
                            forceTarget = nil
                            lastAutoFire = tick()
                            hitCount += 1
                        end
                    end
                else
                    airStart[target] = nil
                end
            end
        end
    end
end)

print("🚀 ULTRA v14 FINAL — Silent Aim для Zee Hood (prediction = 0)")
print("Q — Silent Lock | J — Auto Shoot | N — Combo | F — Camlock | T — Trigger | B — Auto Air | V — Silent Aim | K — Blatant")
if placeId == 99692075138533 then
    if MainRemote then
        print("✅ Используется ремоут: " .. MainRemote.Name .. " с аргументом " .. tostring(ShootArg))
    else
        print("⚠️ Remote не найден, используется tool:Activate() (Silent Aim работать не будет)")
    end
    print("🎯 Camlock работает без предсказания (0 prediction)")
end
