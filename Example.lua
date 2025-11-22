--[[
    Luna V2 UI Library - Example Hub
    Uses your GitHub Source:
    https://raw.githubusercontent.com/Black69Weeds/Dark-Matter-Ui/refs/heads/main/Source
]]

--// Load Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Black69Weeds/Dark-Matter-Ui/refs/heads/main/Source"))()

--// Create Window
local Window = Library:CreateWindow({
    Name = "Luna V2 Hub",
    ThemeColor = Color3.fromRGB(120, 85, 255), -- Purple theme
    -- HomeIcon = 3926305904 -- optional custom home icon id
})

--// Create Tabs (icons are asset IDs – numbers / strings / "rbxassetid://id")
local CombatTab   = Window:CreateTab("Combat",   "10888379573") -- sword icon
local VisualsTab  = Window:CreateTab("Visuals",  "10888380809") -- eye icon
local PlayerTab   = Window:CreateTab("Player",   "10888294202") -- person icon
local ConfigTab   = Window:CreateTab("Config",   "10888331180") -- settings icon

---------------------------------------------------------------------
-- COMBAT TAB
---------------------------------------------------------------------
CombatTab:CreateSection("Aimbot")

local AimbotEnabled = false
local AimbotFOV     = 90

local AimbotToggle = CombatTab:AddToggle("Silent Aim", false, function(state)
    AimbotEnabled = state
    print("[Combat] Silent Aim:", state)
end)

local FOVSlider = CombatTab:AddSlider("FOV Radius", 10, 500, 90, function(value)
    AimbotFOV = value
    print("[Combat] FOV:", value)
end)

CombatTab:CreateSection("Gun Mods")

local NoRecoil = false
local NoSpread = false

CombatTab:AddToggle("No Recoil", false, function(state)
    NoRecoil = state
    print("[Combat] No Recoil:", state)
end)

CombatTab:AddToggle("No Spread", false, function(state)
    NoSpread = state
    print("[Combat] No Spread:", state)
end)

---------------------------------------------------------------------
-- VISUALS TAB
---------------------------------------------------------------------
VisualsTab:CreateSection("ESP")

local BoxESP      = false
local NameESP     = true
local ESPDistance = 500

VisualsTab:AddToggle("Box ESP", false, function(state)
    BoxESP = state
    print("[Visuals] Box ESP:", state)
end)

VisualsTab:AddToggle("Name ESP", true, function(state)
    NameESP = state
    print("[Visuals] Name ESP:", state)
end)

VisualsTab:AddSlider("ESP Distance", 50, 3000, 500, function(value)
    ESPDistance = value
    print("[Visuals] ESP Distance:", value)
end)

VisualsTab:CreateSection("World")

local FullBright = false

VisualsTab:AddToggle("FullBright", false, function(state)
    FullBright = state
    print("[Visuals] FullBright:", state)

    -- basic example (you can replace with your own fullbright function)
    if state then
        game.Lighting.Brightness = 3
        game.Lighting.ClockTime = 14
    else
        -- do nothing / restore if you store previous values
    end
end)

---------------------------------------------------------------------
-- PLAYER TAB
---------------------------------------------------------------------
PlayerTab:CreateSection("Movement")

local WalkSpeedVal = 16
local JumpPowerVal = 50

PlayerTab:AddSlider("WalkSpeed", 16, 200, 16, function(value)
    WalkSpeedVal = value
    local plr = game.Players.LocalPlayer
    local char = plr.Character or plr.CharacterAdded:Wait()
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = value
    end
    print("[Player] WalkSpeed:", value)
end)

PlayerTab:AddSlider("JumpPower", 50, 200, 50, function(value)
    JumpPowerVal = value
    local plr = game.Players.LocalPlayer
    local char = plr.Character or plr.CharacterAdded:Wait()
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.JumpPower = value
    end
    print("[Player] JumpPower:", value)
end)

PlayerTab:CreateSection("Extra")

local Noclip = false

PlayerTab:AddToggle("Noclip (example)", false, function(state)
    Noclip = state
    print("[Player] Noclip:", state)
end)

-- simple noclip loop example (you can change or remove)
task.spawn(function()
    while task.wait() do
        if Noclip then
            local char = game.Players.LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end
    end
end)

---------------------------------------------------------------------
-- CONFIG TAB
---------------------------------------------------------------------
ConfigTab:CreateSection("Presets")

ConfigTab:AddToggle("Legit Mode", true, function(state)
    if state then
        -- Example: safe settings
        if AimbotToggle then AimbotToggle:Set(false) end
        if FOVSlider then FOVSlider:Set(60) end
        print("[Config] Legit Mode applied.")
    end
end)

ConfigTab:AddToggle("Rage Mode", false, function(state)
    if state then
        if AimbotToggle then AimbotToggle:Set(true) end
        if FOVSlider then FOVSlider:Set(300) end
        print("[Config] Rage Mode applied.")
    end
end)

ConfigTab:CreateSection("Info")

ConfigTab:AddSlider("UI Accent Demo", 0, 100, 50, function(v)
    print("[Config] Accent slider (visual only):", v)
end)

print("[Luna V2 Example] Loaded successfully.")
