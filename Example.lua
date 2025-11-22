--[[
    Eclipse UI Library - Example Hub

    This script:
    - Loads Eclipse library from GitHub
    - Creates a window with a dashboard home
    - Adds three tabs (Combat, Visuals, Settings)
    - Shows how to use Sections, Toggles, Buttons, and ConfigSystem
]]

--// Load Library (change URL to wherever you host Eclipse Source)
local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Black69Weeds/Dark-Matter-Ui/refs/heads/main/Source"
))()

--// Create Window
local Window = Library:CreateWindow({
    Name   = "Eclipse Hub",                       -- Title in the top bar
    Accent = Color3.fromRGB(0, 255, 128)         -- Main accent color
})

--// Create Tabs (icons are image asset IDs)
local CombatTab   = Window:CreateTab("rbxassetid://10888379573") -- sword icon
local VisualsTab  = Window:CreateTab("rbxassetid://10888380809") -- eye icon
local SettingsTab = Window:CreateTab("rbxassetid://10888381891") -- gear icon

---------------------------------------------------------------------
-- COMBAT TAB
---------------------------------------------------------------------
CombatTab:CreateSection("Aimbot")

-- Flags will be stored in Library.Flags["AimEnabled"], etc.
CombatTab:AddToggle("Enable Aimbot", "AimEnabled", function(state)
    print("[Combat] Aimbot enabled:", state)
    -- your aimbot logic here
end)

CombatTab:AddToggle("Silent Aim", "SilentEnabled", function(state)
    print("[Combat] Silent Aim:", state)
end)

CombatTab:CreateSection("Gun Mods")

CombatTab:AddButton("Force Headshot", function()
    print("[Combat] Force Headshot clicked")
    -- example: modify hitbox / damage here
end)

---------------------------------------------------------------------
-- VISUALS TAB
---------------------------------------------------------------------
VisualsTab:CreateSection("ESP Settings")

VisualsTab:AddToggle("Box ESP", "BoxESP", function(state)
    print("[Visuals] Box ESP:", state)
    -- your ESP rendering logic here
end)

VisualsTab:AddToggle("Tracers", "Tracers", function(state)
    print("[Visuals] Tracers:", state)
end)

---------------------------------------------------------------------
-- SETTINGS TAB (CONFIG SYSTEM)
---------------------------------------------------------------------
-- This will create:
-- - "Configuration" section title
-- - TextBox for config name
-- - "Save Config" button
-- - "Load Config" button
SettingsTab:AddConfigSystem()

print("[Eclipse Example] Loaded successfully.")
