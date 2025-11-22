--[[ 
    Luna V2 UI Library
    - Dashboard Home Page (Profile, Server Stats, Executor Info)
    - Mobile Friendly (Draggable & Touchable)
    - Minimized Toggle Button
    - Tab Icons with helper (supports numeric IDs, rbxassetid://, etc.)
    - To use icons from https://fonts.google.com/icons :
        -> Download the icon as PNG/WebP
        -> Upload to Roblox as decal/image
        -> Use its asset ID in CreateTab(Name, IconId)
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local Library = {}

---------------------------------------------------------------------
-- Utility: Draggable
---------------------------------------------------------------------
local function MakeDraggable(topbarobject, object)
    local Dragging = false
    local DragInput
    local DragStart
    local StartPosition

    local function Update(input)
        local Delta = input.Position - DragStart
        object.Position = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + Delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + Delta.Y
        )
    end

    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = object.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    topbarobject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            Update(input)
        end
    end)
end

---------------------------------------------------------------------
-- Utility: Get Executor Name
---------------------------------------------------------------------
local function GetExecutor()
    return (identifyexecutor and identifyexecutor()) or "Standard Client"
end

---------------------------------------------------------------------
-- Utility: Safe parent (CoreGui if possible)
---------------------------------------------------------------------
local function GetGuiParent()
    local ok, core = pcall(function()
        return game:GetService("CoreGui")
    end)
    if ok and core then
        return core
    end
    return LocalPlayer:WaitForChild("PlayerGui")
end

---------------------------------------------------------------------
-- Utility: Icon Resolver
-- Accepts:
--   - "rbxassetid://123"
--   - "12345678" (numeric string)
--   - 12345678  (number)
---------------------------------------------------------------------
local function ResolveIcon(icon)
    if not icon then return nil end

    local t = typeof(icon)
    if t == "number" then
        return "rbxassetid://" .. icon
    elseif t == "string" then
        if icon:match("^%d+$") then
            return "rbxassetid://" .. icon
        else
            return icon
        end
    end

    return nil
end

---------------------------------------------------------------------
-- Library: CreateWindow
---------------------------------------------------------------------
function Library:CreateWindow(Config)
    Config = Config or {}
    local TitleText = Config.Name or "Luna UI"
    local ThemeColor = Config.ThemeColor or Color3.fromRGB(100, 100, 255)
    local HomeIconId = ResolveIcon(Config.HomeIcon or "3926305904") -- material-ish sprite

    -- 1. Main ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "LunaLib"
    ScreenGui.Parent = GetGuiParent()
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false

    -- 2. Minimize Button
    local OpenBtn = Instance.new("TextButton")
    OpenBtn.Name = "OpenButton"
    OpenBtn.Parent = ScreenGui
    OpenBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    OpenBtn.Position = UDim2.new(0.5, -60, 0, -50) -- off screen initially
    OpenBtn.Size = UDim2.new(0, 120, 0, 30)
    OpenBtn.Font = Enum.Font.GothamBold
    OpenBtn.Text = "Open Menu"
    OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    OpenBtn.TextSize = 12
    OpenBtn.Visible = false

    local OpenCorner = Instance.new("UICorner")
    OpenCorner.CornerRadius = UDim.new(0, 6)
    OpenCorner.Parent = OpenBtn

    -- 3. Main Window Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MainFrame.Position = UDim2.new(0.5, -325, 0.5, -200)
    MainFrame.Size = UDim2.new(0, 650, 0, 400)
    MainFrame.ClipsDescendants = true

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = MainFrame

    -- Top Bar (Header)
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Parent = MainFrame
    TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    TopBar.Size = UDim2.new(1, 0, 0, 35)

    local Logo = Instance.new("ImageLabel")
    Logo.Parent = TopBar
    Logo.BackgroundTransparency = 1
    Logo.Position = UDim2.new(0, 10, 0, 5)
    Logo.Size = UDim2.new(0, 25, 0, 25)
    Logo.Image = "rbxassetid://13351669446" -- Moon Icon

    local TopTitle = Instance.new("TextLabel")
    TopTitle.Parent = TopBar
    TopTitle.BackgroundTransparency = 1
    TopTitle.Position = UDim2.new(0, 50, 0, 0)
    TopTitle.Size = UDim2.new(0, 200, 1, 0)
    TopTitle.Font = Enum.Font.GothamBold
    TopTitle.Text = TitleText
    TopTitle.TextColor3 = Color3.fromRGB(240, 240, 240)
    TopTitle.TextSize = 14
    TopTitle.TextXAlignment = Enum.TextXAlignment.Left

    -- Window Controls
    local ControlContainer = Instance.new("Frame")
    ControlContainer.Parent = TopBar
    ControlContainer.BackgroundTransparency = 1
    ControlContainer.Position = UDim2.new(1, -70, 0, 0)
    ControlContainer.Size = UDim2.new(0, 70, 1, 0)

    local MinBtn = Instance.new("TextButton")
    MinBtn.Name = "Min"
    MinBtn.Parent = ControlContainer
    MinBtn.BackgroundTransparency = 1
    MinBtn.Size = UDim2.new(0.5, 0, 1, 0)
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.Text = "-"
    MinBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    MinBtn.TextSize = 18

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "Close"
    CloseBtn.Parent = ControlContainer
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Position = UDim2.new(0.5, 0, 0, 0)
    CloseBtn.Size = UDim2.new(0.5, 0, 1, 0)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    CloseBtn.TextSize = 14

    -- Toggle Logic (minimize/restore)
    local function ToggleUI()
        if MainFrame.Visible then
            TweenService:Create(MainFrame, TweenInfo.new(0.3), {
                Size = UDim2.new(0, 650, 0, 0)
            }):Play()
            task.wait(0.3)
            MainFrame.Visible = false
            OpenBtn.Visible = true
            TweenService:Create(OpenBtn, TweenInfo.new(0.5, Enum.EasingStyle.Bounce), {
                Position = UDim2.new(0.5, -60, 0, 10)
            }):Play()
        else
            OpenBtn.Visible = false
            OpenBtn.Position = UDim2.new(0.5, -60, 0, -50)
            MainFrame.Visible = true
            TweenService:Create(MainFrame, TweenInfo.new(0.3), {
                Size = UDim2.new(0, 650, 0, 400)
            }):Play()
        end
    end

    CloseBtn.MouseButton1Click:Connect(ToggleUI)
    MinBtn.MouseButton1Click:Connect(ToggleUI)
    OpenBtn.MouseButton1Click:Connect(ToggleUI)

    MakeDraggable(TopBar, MainFrame)

    -- Sidebar
    local Sidebar = Instance.new("ScrollingFrame")
    Sidebar.Parent = MainFrame
    Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Sidebar.BorderSizePixel = 0
    Sidebar.Position = UDim2.new(0, 0, 0, 35)
    Sidebar.Size = UDim2.new(0, 50, 1, -35)
    Sidebar.ScrollBarThickness = 0
    Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)

    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.Parent = Sidebar
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarLayout.Padding = UDim.new(0, 10)
    SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local SidebarPadding = Instance.new("UIPadding")
    SidebarPadding.Parent = Sidebar
    SidebarPadding.PaddingTop = UDim.new(0, 10)

    SidebarLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Sidebar.CanvasSize = UDim2.new(0, 0, 0, SidebarLayout.AbsoluteContentSize.Y + 20)
    end)

    -- Content Area
    local Pages = Instance.new("Frame")
    Pages.Parent = MainFrame
    Pages.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    Pages.BorderSizePixel = 0
    Pages.Position = UDim2.new(0, 50, 0, 35)
    Pages.Size = UDim2.new(1, -50, 1, -35)

    -----------------------------------------------------------------
    -- HOME TAB (Dashboard)
    -----------------------------------------------------------------
    local HomeTabBtn = Instance.new("TextButton")
    HomeTabBtn.Parent = Sidebar
    HomeTabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35) -- default selected
    HomeTabBtn.Size = UDim2.new(0, 35, 0, 35)
    HomeTabBtn.Text = ""
    HomeTabBtn.AutoButtonColor = false

    local HomeIcon = Instance.new("ImageLabel")
    HomeIcon.Parent = HomeTabBtn
    HomeIcon.BackgroundTransparency = 1
    HomeIcon.Position = UDim2.new(0, 5, 0, 5)
    HomeIcon.Size = UDim2.new(0, 25, 0, 25)
    HomeIcon.Image = HomeIconId or "rbxassetid://3926305904" -- default sprite
    HomeIcon.ImageColor3 = ThemeColor

    local HomeCorner = Instance.new("UICorner")
    HomeCorner.CornerRadius = UDim.new(0, 6)
    HomeCorner.Parent = HomeTabBtn

    local HomePage = Instance.new("Frame")
    HomePage.Name = "HomePage"
    HomePage.Parent = Pages
    HomePage.BackgroundTransparency = 1
    HomePage.Size = UDim2.new(1, 0, 1, 0)
    HomePage.Visible = true

    -- Home: User Profile Card
    local ProfileCard = Instance.new("Frame")
    ProfileCard.Parent = HomePage
    ProfileCard.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    ProfileCard.Position = UDim2.new(0, 15, 0, 15)
    ProfileCard.Size = UDim2.new(1, -30, 0, 80)
    Instance.new("UICorner", ProfileCard).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", ProfileCard).Color = Color3.fromRGB(40, 40, 40)

    local Avatar = Instance.new("ImageLabel")
    Avatar.Parent = ProfileCard
    Avatar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Avatar.Position = UDim2.new(0, 10, 0, 10)
    Avatar.Size = UDim2.new(0, 60, 0, 60)
    Instance.new("UICorner", Avatar).CornerRadius = UDim.new(0, 30)

    -- safer thumbnail call
    task.spawn(function()
        local ok, content = pcall(function()
            return Players:GetUserThumbnailAsync(
                LocalPlayer.UserId,
                Enum.ThumbnailType.HeadShot,
                Enum.ThumbnailSize.Size100x100
            )
        end)
        if ok then
            Avatar.Image = content
        end
    end)

    local WelcomeLbl = Instance.new("TextLabel")
    WelcomeLbl.Parent = ProfileCard
    WelcomeLbl.BackgroundTransparency = 1
    WelcomeLbl.Position = UDim2.new(0, 85, 0, 15)
    WelcomeLbl.Size = UDim2.new(0, 200, 0, 20)
    WelcomeLbl.Font = Enum.Font.GothamBold
    WelcomeLbl.Text = "Hello, " .. LocalPlayer.DisplayName
    WelcomeLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    WelcomeLbl.TextSize = 18
    WelcomeLbl.TextXAlignment = Enum.TextXAlignment.Left

    local UserLbl = Instance.new("TextLabel")
    UserLbl.Parent = ProfileCard
    UserLbl.BackgroundTransparency = 1
    UserLbl.Position = UDim2.new(0, 85, 0, 40)
    UserLbl.Size = UDim2.new(0, 200, 0, 15)
    UserLbl.Font = Enum.Font.Gotham
    UserLbl.Text = "@" .. LocalPlayer.Name
    UserLbl.TextColor3 = Color3.fromRGB(150, 150, 150)
    UserLbl.TextSize = 12
    UserLbl.TextXAlignment = Enum.TextXAlignment.Left

    -- Home: Server Info Card
    local ServerCard = Instance.new("Frame")
    ServerCard.Parent = HomePage
    ServerCard.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    ServerCard.Position = UDim2.new(0, 15, 0, 110)
    ServerCard.Size = UDim2.new(0.55, 0, 0, 200)
    Instance.new("UICorner", ServerCard).CornerRadius = UDim.new(0, 8)

    local S_Grad = Instance.new("UIGradient")
    S_Grad.Parent = ServerCard
    S_Grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 40, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 25)),
    })
    S_Grad.Rotation = 45

    local ServerTitle = Instance.new("TextLabel")
    ServerTitle.Parent = ServerCard
    ServerTitle.BackgroundTransparency = 1
    ServerTitle.Position = UDim2.new(0, 15, 0, 10)
    ServerTitle.Size = UDim2.new(1, -20, 0, 20)
    ServerTitle.Font = Enum.Font.GothamBold
    ServerTitle.Text = "Server Information"
    ServerTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
    ServerTitle.TextSize = 14
    ServerTitle.TextXAlignment = Enum.TextXAlignment.Left

    local StatGrid = Instance.new("Frame")
    StatGrid.Parent = ServerCard
    StatGrid.BackgroundTransparency = 1
    StatGrid.Position = UDim2.new(0, 15, 0, 40)
    StatGrid.Size = UDim2.new(1, -30, 1, -50)

    local SGrid = Instance.new("UIGridLayout")
    SGrid.Parent = StatGrid
    SGrid.CellSize = UDim2.new(0.48, 0, 0.4, 0)
    SGrid.CellPadding = UDim2.new(0, 5, 0, 5)

    local function CreateStat(title, valFunc)
        local Box = Instance.new("Frame")
        Box.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        Box.Parent = StatGrid
        Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4)

        local T = Instance.new("TextLabel")
        T.Parent = Box
        T.BackgroundTransparency = 1
        T.Position = UDim2.new(0, 5, 0, 5)
        T.Size = UDim2.new(1, -5, 0, 10)
        T.Font = Enum.Font.GothamBold
        T.Text = title
        T.TextColor3 = Color3.fromRGB(255, 255, 255)
        T.TextSize = 10
        T.TextXAlignment = Enum.TextXAlignment.Left

        local V = Instance.new("TextLabel")
        V.Parent = Box
        V.BackgroundTransparency = 1
        V.Position = UDim2.new(0, 5, 0, 20)
        V.Size = UDim2.new(1, -5, 0, 10)
        V.Font = Enum.Font.Gotham
        V.Text = "Loading..."
        V.TextColor3 = Color3.fromRGB(150, 150, 150)
        V.TextSize = 10
        V.TextXAlignment = Enum.TextXAlignment.Left

        task.spawn(function()
            while Box.Parent do
                local ok, txt = pcall(valFunc)
                if ok and typeof(txt) == "string" or typeof(txt) == "number" then
                    V.Text = tostring(txt)
                end
                task.wait(1)
            end
        end)
    end

    CreateStat("Players", function()
        return #Players:GetPlayers() .. "/" .. tostring(Players.MaxPlayers or "?")
    end)

    CreateStat("Ping", function()
        local ok, ping = pcall(function()
            return LocalPlayer:GetNetworkPing()
        end)
        if not ok or not ping then
            return "N/A"
        end
        ping = math.floor(ping * 1000 + 0.5)
        return tostring(ping) .. "ms"
    end)

    CreateStat("Time", function()
        local t = workspace.DistributedGameTime
        local h = math.floor(t / 3600)
        local m = math.floor((t % 3600) / 60)
        return string.format("%02d:%02d", h, m)
    end)

    CreateStat("Game ID", function()
        return tostring(game.PlaceId)
    end)

    -- Home: Executor Card
    local ExecCard = Instance.new("Frame")
    ExecCard.Parent = HomePage
    ExecCard.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    ExecCard.Position = UDim2.new(0.6, 0, 0, 110)
    ExecCard.Size = UDim2.new(0.37, 0, 0, 120)
    Instance.new("UICorner", ExecCard).CornerRadius = UDim.new(0, 8)

    local E_Grad = Instance.new("UIGradient")
    E_Grad.Parent = ExecCard
    E_Grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 20, 20)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 25)),
    })
    E_Grad.Rotation = -45

    local ExecTitle = Instance.new("TextLabel")
    ExecTitle.Parent = ExecCard
    ExecTitle.BackgroundTransparency = 1
    ExecTitle.Position = UDim2.new(0, 10, 0, 10)
    ExecTitle.Size = UDim2.new(1, -20, 0, 20)
    ExecTitle.Font = Enum.Font.GothamBold
    ExecTitle.Text = GetExecutor()
    ExecTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    ExecTitle.TextSize = 14
    ExecTitle.TextXAlignment = Enum.TextXAlignment.Left

    local ExecDesc = Instance.new("TextLabel")
    ExecDesc.Parent = ExecCard
    ExecDesc.BackgroundTransparency = 1
    ExecDesc.Position = UDim2.new(0, 10, 0, 35)
    ExecDesc.Size = UDim2.new(1, -20, 0, 40)
    ExecDesc.Font = Enum.Font.Gotham
    ExecDesc.Text = "Your executor seems to support this script."
    ExecDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
    ExecDesc.TextSize = 11
    ExecDesc.TextWrapped = true
    ExecDesc.TextXAlignment = Enum.TextXAlignment.Left

    -----------------------------------------------------------------
    -- Tab switching logic (Home button)
    -----------------------------------------------------------------
    local function ResetTabsHighlight()
        for _, b in ipairs(Sidebar:GetChildren()) do
            if b:IsA("TextButton") then
                TweenService:Create(b, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                }):Play()
                local img = b:FindFirstChildWhichIsA("ImageLabel")
                if img then
                    img.ImageColor3 = Color3.fromRGB(150, 150, 150)
                end
            end
        end
    end

    HomeTabBtn.MouseButton1Click:Connect(function()
        for _, p in ipairs(Pages:GetChildren()) do
            if p:IsA("GuiObject") then
                p.Visible = false
            end
        end
        ResetTabsHighlight()
        HomePage.Visible = true
        TweenService:Create(HomeTabBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        }):Play()
        HomeIcon.ImageColor3 = ThemeColor
    end)

    -----------------------------------------------------------------
    -- PUBLIC API: Tabs table
    -----------------------------------------------------------------
    local Tabs = {}

    -- CreateTab(Name, IconId)
    -- IconId can be: number, "123", "rbxassetid://123"
    function Tabs:CreateTab(Name, IconId)
        Name = Name or "Tab"

        local TabBtn = Instance.new("TextButton")
        TabBtn.Parent = Sidebar
        TabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        TabBtn.Size = UDim2.new(0, 35, 0, 35)
        TabBtn.Text = ""
        TabBtn.AutoButtonColor = false

        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Parent = TabBtn
        TabIcon.BackgroundTransparency = 1
        TabIcon.Position = UDim2.new(0, 5, 0, 5)
        TabIcon.Size = UDim2.new(0, 25, 0, 25)
        TabIcon.Image = ResolveIcon(IconId) or "rbxassetid://4483345998"
        TabIcon.ImageColor3 = Color3.fromRGB(150, 150, 150)

        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 6)
        TabCorner.Parent = TabBtn

        local Page = Instance.new("ScrollingFrame")
        Page.Name = Name .. "Page"
        Page.Parent = Pages
        Page.BackgroundTransparency = 1
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.Visible = false
        Page.ScrollBarThickness = 2
        Page.BorderSizePixel = 0
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Parent = Page
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Padding = UDim.new(0, 5)

        local PagePad = Instance.new("UIPadding")
        PagePad.Parent = Page
        PagePad.PaddingTop = UDim.new(0, 10)
        PagePad.PaddingLeft = UDim.new(0, 10)
        PagePad.PaddingRight = UDim.new(0, 10)

        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
        end)

        TabBtn.MouseButton1Click:Connect(function()
            for _, p in ipairs(Pages:GetChildren()) do
                if p:IsA("GuiObject") then
                    p.Visible = false
                end
            end
            ResetTabsHighlight()
            Page.Visible = true
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            }):Play()
            TabIcon.ImageColor3 = ThemeColor
        end)

        -------------------------------------------------------------
        -- Elements object for this tab
        -------------------------------------------------------------
        local Elements = {}

        function Elements:CreateSection(Title)
            local SectionLabel = Instance.new("TextLabel")
            SectionLabel.Parent = Page
            SectionLabel.BackgroundTransparency = 1
            SectionLabel.Size = UDim2.new(1, 0, 0, 25)
            SectionLabel.Font = Enum.Font.GothamBold
            SectionLabel.Text = Title or "Section"
            SectionLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
            SectionLabel.TextSize = 12
            SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
        end

        function Elements:AddToggle(Text, Default, Callback)
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Parent = Page
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
            Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 6)

            local Label = Instance.new("TextLabel")
            Label.Parent = ToggleFrame
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.Size = UDim2.new(0.7, 0, 1, 0)
            Label.Font = Enum.Font.GothamSemibold
            Label.Text = Text or "Toggle"
            Label.TextColor3 = Color3.fromRGB(200, 200, 200)
            Label.TextSize = 12
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local Btn = Instance.new("TextButton")
            Btn.Parent = ToggleFrame
            Btn.BackgroundColor3 = Default and ThemeColor or Color3.fromRGB(50, 50, 50)
            Btn.Position = UDim2.new(1, -40, 0.5, -8)
            Btn.Size = UDim2.new(0, 30, 0, 16)
            Btn.Text = ""
            Btn.AutoButtonColor = false
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(1, 0)

            local Circle = Instance.new("Frame")
            Circle.Parent = Btn
            Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Circle.Position = Default and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
            Circle.Size = UDim2.new(0, 12, 0, 12)
            Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

            local State = Default and true or false

            local function Set(newState)
                State = newState and true or false
                local TargetPos = State and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
                local TargetCol = State and ThemeColor or Color3.fromRGB(50, 50, 50)
                TweenService:Create(Circle, TweenInfo.new(0.2), {Position = TargetPos}):Play()
                TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = TargetCol}):Play()
                if Callback then
                    task.spawn(Callback, State)
                end
            end

            Btn.MouseButton1Click:Connect(function()
                Set(not State)
            end)

            -- whole frame clickable for mobile
            local Hitbox = Instance.new("TextButton")
            Hitbox.Parent = ToggleFrame
            Hitbox.BackgroundTransparency = 1
            Hitbox.Size = UDim2.new(1, 0, 1, 0)
            Hitbox.Text = ""
            Hitbox.ZIndex = 2
            Hitbox.MouseButton1Click:Connect(function()
                Set(not State)
            end)

            local ToggleObject = {}
            function ToggleObject:Set(v) Set(v) end
            function ToggleObject:Get() return State end

            return ToggleObject
        end

        function Elements:AddSlider(Text, Min, Max, Default, Callback)
            Min = Min or 0
            Max = Max or 100
            Default = Default or Min

            local SliderFrame = Instance.new("Frame")
            SliderFrame.Parent = Page
            SliderFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            SliderFrame.Size = UDim2.new(1, 0, 0, 50)
            Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 6)

            local Label = Instance.new("TextLabel")
            Label.Parent = SliderFrame
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 10, 0, 5)
            Label.Size = UDim2.new(1, -20, 0, 20)
            Label.Font = Enum.Font.GothamSemibold
            Label.Text = Text or "Slider"
            Label.TextColor3 = Color3.fromRGB(200, 200, 200)
            Label.TextSize = 12
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local ValLbl = Instance.new("TextLabel")
            ValLbl.Parent = SliderFrame
            ValLbl.BackgroundTransparency = 1
            ValLbl.Position = UDim2.new(1, -40, 0, 5)
            ValLbl.Size = UDim2.new(0, 30, 0, 20)
            ValLbl.Font = Enum.Font.Gotham
            ValLbl.Text = tostring(Default)
            ValLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            ValLbl.TextSize = 12

            local Bar = Instance.new("Frame")
            Bar.Parent = SliderFrame
            Bar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            Bar.Position = UDim2.new(0, 10, 0, 35)
            Bar.Size = UDim2.new(1, -20, 0, 4)
            Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)

            local Fill = Instance.new("Frame")
            Fill.Parent = Bar
            Fill.BackgroundColor3 = ThemeColor
            Fill.Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0)
            Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

            local Trigger = Instance.new("TextButton")
            Trigger.Parent = SliderFrame
            Trigger.BackgroundTransparency = 1
            Trigger.Size = UDim2.new(1, 0, 1, 0)
            Trigger.Text = ""

            local Value = Default
            local Dragging = false

            local function SetFromRatio(r)
                r = math.clamp(r, 0, 1)
                Value = math.floor(Min + (Max - Min) * r + 0.5)
                ValLbl.Text = tostring(Value)
                TweenService:Create(Fill, TweenInfo.new(0.1), {
                    Size = UDim2.new(r, 0, 1, 0)
                }):Play()
                if Callback then
                    task.spawn(Callback, Value)
                end
            end

            local function Update(input)
                local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                SetFromRatio(pos)
            end

            Trigger.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = true
                    Update(input)
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch) then
                    Update(input)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = false
                end
            end)

            local SliderObject = {}
            function SliderObject:Set(v)
                v = math.clamp(v, Min, Max)
                SetFromRatio((v - Min) / (Max - Min))
            end
            function SliderObject:Get()
                return Value
            end

            return SliderObject
        end

        return Elements
    end

    return Tabs
end

return Library
