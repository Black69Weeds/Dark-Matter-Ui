--========================================================
-- Load Eclipse UI
--========================================================
local Eclipse = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Black69Weeds/Dark-Matter-Ui/refs/heads/main/Source"
))()

--========================================================
-- ICONS FROM GOOGLE MATERIAL ICONS (YOUR UPLOADS)
--========================================================
local Icons = {
    home       = "rbxassetid://12345678901", -- Home icon you uploaded
    visibility = "rbxassetid://12345678902", -- Eye icon (Visibility)
    target     = "rbxassetid://12345678903", -- Crosshair icon (Target)
    person     = "rbxassetid://12345678904", -- Person icon
    settings   = "rbxassetid://12345678905"  -- Tune/Settings icon
}

--========================================================
-- Create Window
--========================================================
local Window = Eclipse:CreateWindow({
    Name           = "SyzenHub",
    Subtitle       = "Steal a SpongeBob",
    Accent         = Color3.fromRGB(0, 255, 128),
    HomeEnabled    = true,
    OpenButtonText = "Open SyzenHub",

    ConfigSettings = {
        RootFolder   = nil,
        ConfigFolder = "SyzenHub"
    },

    KeySystem = true,
    KeySettings = {
        Title      = "SyzenHub Key System",
        Subtitle   = "Steal a SpongeBob",
        Note       = "Join Discord for the key",
        SaveKey    = true,
        Key        = {"SyzenHub"},
        SecondAction = {
            Enabled   = true,
            Type      = "Discord",
            Parameter = "W8qeVXK8"
        }
    }
})

--========================================================
-- TABS (These now use YOUR Material Icons)
--========================================================
local ESPTab    = Window:CreateTab(Icons.visibility)
local CombatTab = Window:CreateTab(Icons.target)
local PlayerTab = Window:CreateTab(Icons.person)
local Settings  = Window:CreateTab(Icons.settings)

--========================================================
-- BASIC ESP STRUCTURE
--========================================================
local ESPEnabled = false

task.spawn(function()
    while task.wait(0.2) do
        if ESPEnabled then
            print("[ESP] Running...")
            -- put real ESP code here
        end
    end
end)

--========================================================
-- ESP TAB CONTENT
--========================================================
ESPTab:CreateSection("ESP")

ESPTab:AddToggle("Enable ESP", "ESP_MAIN", function(state)
    ESPEnabled = state
end)

--========================================================
-- COMBAT TAB CONTENT
--========================================================
CombatTab:CreateSection("Aimbot")

CombatTab:AddToggle("Silent Aim", "SilentAim", function(v)
    print("Silent:", v)
end)

CombatTab:AddSlider("FOV", "AIM_FOV", 10, 500, 100, function(v)
    print("FOV:", v)
end)

--========================================================
-- PLAYER TAB CONTENT
--========================================================
PlayerTab:CreateSection("Movement")

PlayerTab:AddTextbox("Custom Tag", "TagName", "Enter text...", function(t)
    print("Tag:", t)
end)

--========================================================
-- SETTINGS / CONFIG TAB
--========================================================
Settings:CreateSection("Config")
Settings:AddConfigSystem()

-- Optional webhook input
Settings:CreateSection("Webhook")
Settings:AddWebhookInput("MainWebhook", "Paste Discord webhook here", function(url)
    print("Webhook saved:", url)
end)

print("[SyzenHub] Example Loaded (Material Icons)")
