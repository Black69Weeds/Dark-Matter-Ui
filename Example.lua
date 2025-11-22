--[[
    DarkMatter UI Library - Example Script
    Uses your hosted source:
    https://raw.githubusercontent.com/Black69Weeds/Dark-Matter-Ui/refs/heads/main/Source
]]

--// Load Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Black69Weeds/Dark-Matter-Ui/refs/heads/main/Source"))()

--// Create Window
local Window = Library:CreateWindow({
    Title = "DarkMatter Hub"
})

--// Create Tabs
local CombatTab   = Window:CreateTab("Combat")
local VisualTab   = Window:CreateTab("Visuals")
local PlayerTab   = Window:CreateTab("Player")
local MiscTab     = Window:CreateTab("Misc")

--// Create Sections
local AimbotSection       = CombatTab:CreateSection("Aimbot", "Left")
local GunModsSection      = CombatTab:CreateSection("Gun Mods", "Right")

local ESPSection          = VisualTab:CreateSection("ESP", "Left")
local VisualMiscSection   = VisualTab:CreateSection("Visual Extras", "Right")

local MovementSection     = PlayerTab:CreateSection("Movement", "Left")
local PlayerUtilSection   = PlayerTab:CreateSection("Player Utility", "Right")

local MiscConfigSection   = MiscTab:CreateSection("Config", "Left")
local MiscInfoSection     = MiscTab:CreateSection("Info / Credits", "Right")

---------------------------------------------------------------------
-- Aimbot Section
---------------------------------------------------------------------
local AimbotEnabled = false
local AimbotHitbox  = "Head"
local AimbotFOV     = 90

local AimbotToggle = AimbotSection:AddToggle("Aimbot Enabled", false, function(state)
    AimbotEnabled = state
    print("[Aimbot] Enabled:", state)
end)

local HitboxDropdown = AimbotSection:AddDropdown("Aim Part", {"Head", "Torso", "HumanoidRootPart"}, function(option)
    AimbotHitbox = option
    print("[Aimbot] Hitbox set to:", option)
end)

local FOVSlider = AimbotSection:AddSlider("FOV", 20, 300, 90, function(value)
    AimbotFOV = value
    print("[Aimbot] FOV set to:", value)
end)

AimbotSection:AddLabel("Warning: Aimbot may be bannable if detected.")

---------------------------------------------------------------------
-- Gun Mods Section
---------------------------------------------------------------------
local InfAmmoEnabled  = false
local NoRecoilEnabled = false
local FireRateValue   = 10

GunModsSection:AddToggle("Infinite Ammo", false, function(state)
    InfAmmoEnabled = state
    print("[GunMods] Infinite Ammo:", state)
    -- your gun logic here
end)

GunModsSection:AddToggle("No Recoil", false, function(state)
    NoRecoilEnabled = state
    print("[GunMods] No Recoil:", state)
    -- your recoil logic here
end)

GunModsSection:AddSlider("Fire Rate", 1, 50, 10, function(value)
    FireRateValue = value
    print("[GunMods] Fire Rate:", value)
    -- your fire rate logic here
end)

GunModsSection:AddLabel("High risk features. Use at your own risk.")

---------------------------------------------------------------------
-- ESP Section
---------------------------------------------------------------------
local BoxESPEnabled  = false
local NameESPEnabled = true
local ESPDistance    = 500

ESPSection:AddToggle("Box ESP", false, function(state)
    BoxESPEnabled = state
    print("[ESP] Box ESP:", state)
    -- your ESP box logic
end)

ESPSection:AddToggle("Name ESP", true, function(state)
    NameESPEnabled = state
    print("[ESP] Name ESP:", state)
    -- your ESP name logic
end)

ESPSection:AddSlider("ESP Distance", 50, 2000, 500, function(value)
    ESPDistance = value
    print("[ESP] Distance:", value)
    -- your distance logic
end)

---------------------------------------------------------------------
-- Visual Extras Section
---------------------------------------------------------------------
local CrosshairEnabled = true
local ThemeValue       = "Dark"

VisualMiscSection:AddToggle("Crosshair", true, function(state)
    CrosshairEnabled = state
    print("[Visual] Crosshair:", state)
end)

local ThemeDropdown = VisualMiscSection:AddDropdown("Theme", {"Dark", "Light", "Neon"}, function(option)
    ThemeValue = option
    print("[Visual] Theme:", option)
    -- you could change colors here based on theme
end)

---------------------------------------------------------------------
-- Movement Section
---------------------------------------------------------------------
local WalkSpeedValue = 16
local JumpPowerValue = 50

MovementSection:AddSlider("WalkSpeed", 16, 200, 16, function(value)
    WalkSpeedValue = value
    local plr = game.Players.LocalPlayer
    local char = plr.Character or plr.CharacterAdded:Wait()
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = value
    end
    print("[Movement] WalkSpeed:", value)
end)

MovementSection:AddSlider("JumpPower", 50, 300, 50, function(value)
    JumpPowerValue = value
    local plr = game.Players.LocalPlayer
    local char = plr.Character or plr.CharacterAdded:Wait()
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.JumpPower = value
    end
    print("[Movement] JumpPower:", value)
end)

MovementSection:AddLabel("If your character glitches, reset and re-open the UI.")

---------------------------------------------------------------------
-- Player Utility Section
---------------------------------------------------------------------
local NoclipEnabled = false

PlayerUtilSection:AddToggle("Noclip (example)", false, function(state)
    NoclipEnabled = state
    print("[Utility] Noclip:", state)
    -- add your noclip loop here if you want
end)

local UsernameBox = PlayerUtilSection:AddTextbox("Target Player", "Exact username", function(text)
    print("[Utility] Target player:", text)
    -- your target logic here
end)

---------------------------------------------------------------------
-- Misc Config Section
---------------------------------------------------------------------
local WebhookURL = ""

MiscConfigSection:AddTextbox("Webhook URL", "Paste webhook here", function(text)
    WebhookURL = text
    print("[Config] Webhook set to:", text)
end)

MiscConfigSection:AddDropdown("Config Preset", {"Legit", "Rage", "Visual Only"}, function(preset)
    print("[Config] Preset selected:", preset)
    -- you can set multiple values depending on preset here
end)

MiscConfigSection:AddLabel("Presets are just visual here. Add your own logic inside callbacks.")

---------------------------------------------------------------------
-- Misc Info Section
---------------------------------------------------------------------
local InfoLabel = MiscInfoSection:AddLabel("DarkMatter UI by Black Weed")

-- Example of changing label text later:
task.delay(5, function()
    InfoLabel.Text = "Thanks for using DarkMatter UI <3"
end)

MiscInfoSection:AddLabel("Source: GitHub /Dark-Matter-Ui/Source")
MiscInfoSection:AddLabel("Make sure to star the repo if you like it!")

---------------------------------------------------------------------
-- OPTIONAL: Example of programmatically changing elements
---------------------------------------------------------------------
task.delay(3, function()
    -- enable aimbot & set some defaults after 3 seconds
    if AimbotToggle and HitboxDropdown and FOVSlider then
        AimbotToggle:Set(true)
        HitboxDropdown:Set("Head")
        FOVSlider:Set(120)
        print("[Auto-Setup] Aimbot enabled with Head / 120 FOV.")
    end
end)
