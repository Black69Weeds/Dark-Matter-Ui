--[[
    Eclipse UI Library - Example Script

    This file only uses the library.
    Make sure your GitHub "Source" file is the Eclipse library that returns Library.
]]

---------------------------------------------------------------------
-- 1. Load the Eclipse library from your GitHub
---------------------------------------------------------------------

local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Black69Weeds/Dark-Matter-Ui/refs/heads/main/Source"
))()
--  ^ This should return the Library table from your Source file.


---------------------------------------------------------------------
-- 2. Create the main window
---------------------------------------------------------------------

local Window = Library:CreateWindow({
    Name   = "Eclipse Hub",                 -- Title text in top bar
    Accent = Color3.fromRGB(0, 255, 128)    -- Main accent color (toggles / icons)
})

-- NOTE:
-- The window automatically creates:
--  - A sidebar with icons
--  - A top bar with title + minimize + close
--  - A Home dashboard (profile, server stats, game info)


---------------------------------------------------------------------
-- 3. Create tabs (sidebar icons)
---------------------------------------------------------------------

-- Each tab is created with an icon image id (no text on the button).
-- The returned value is an object you use to add sections, toggles, buttons, etc.

local CombatTab   = Window:CreateTab("rbxassetid://10888379573") -- 🗡 Combat
local VisualsTab  = Window:CreateTab("rbxassetid://10888380809") -- 👁 Visuals
local SettingsTab = Window:CreateTab("rbxassetid://10888381891") -- ⚙ Settings


---------------------------------------------------------------------
-- 4. COMBAT TAB
---------------------------------------------------------------------

-- Sections are just headers to keep things organized.
CombatTab:CreateSection("Aimbot")

-- Toggles:
--   AddToggle("Display Name", "FlagName", function(state) ... end)
--   - "FlagName" is stored in Library.Flags[FlagName]
--   - state is true / false

CombatTab:AddToggle("Enable Aimbot", "AimEnabled", function(isEnabled)
    print("[Combat] Aimbot enabled:", isEnabled)
    -- TODO: put your aimbot logic here (using isEnabled)
end)

CombatTab:AddToggle("Silent Aim", "SilentEnabled", function(isEnabled)
    print("[Combat] Silent Aim:", isEnabled)
    -- TODO: your silent-aim code here
end)

-- Another section in the same tab
CombatTab:CreateSection("Gun Mods")

-- Buttons:
--   AddButton("Display Name", function() ... end)

CombatTab:AddButton("Force Headshot", function()
    print("[Combat] Force Headshot clicked")
    -- TODO: do something like setting hitbox / forcing headshot
end)


---------------------------------------------------------------------
-- 5. VISUALS TAB
---------------------------------------------------------------------

VisualsTab:CreateSection("ESP Settings")

VisualsTab:AddToggle("Box ESP", "BoxESP", function(isEnabled)
    print("[Visuals] Box ESP:", isEnabled)
    -- TODO: enable/disable your Box ESP here
end)

VisualsTab:AddToggle("Tracers", "Tracers", function(isEnabled)
    print("[Visuals] Tracers:", isEnabled)
    -- TODO: enable/disable tracers here
end)


---------------------------------------------------------------------
-- 6. SETTINGS TAB (CONFIG SYSTEM)
---------------------------------------------------------------------

-- AddConfigSystem() creates:
--   - "Configuration" section
--   - TextBox for config name (e.g. "legit", "rage")
--   - "Save Config" button  → Library:SaveConfig(name)
--   - "Load Config" button  → Library:LoadConfig(name)
--
-- Flags used by toggles above are stored in Library.Flags:
--   Library.Flags["AimEnabled"]
--   Library.Flags["SilentEnabled"]
--   Library.Flags["BoxESP"]
--   Library.Flags["Tracers"]
--   ...and are written into the config JSON file.

SettingsTab:AddConfigSystem()


---------------------------------------------------------------------
-- 7. Done
---------------------------------------------------------------------

print("[Eclipse Example] Loaded successfully.")
