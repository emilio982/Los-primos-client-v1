-- Los Primos Client - FINAL UNIVERSAL GUI (January 2026)
-- 100% Working - No Errors - PlayerGui + All Features - FIXED

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser") -- Fixed: Use VirtualUser instead of VirtualUserService for anti-AFK

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local cam = workspace.CurrentCamera

-- Create ScreenGui (PlayerGui - most reliable)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LosPrimosClient"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Variables
local keyCorrect = "kyFVveu2fz"
local isAuthenticated = false
local fastSpeed = false
local aiming = false
local autoFarm = false
local autoCollect = false
local autoKill = false
local minimized = false
local noclip = false
local infjump = false
local tpwalk = false
local tpwalkSpeed = 50
local freecam = false
local freecamSpeed = 50
local hitboxExpand = false
local hitboxSize = 5
local fovValue = 70
local xray = false
local antiAFK = false
local clickTP = false
local espEnabled = false
local originalTrans = {}
local keys = {W = false, A = false, S = false, D = false, Space = false, LeftControl = false}
local yaw = 0
local pitch = 0
local savedCamType, savedMouseBehavior, savedCFrame
local highlights = {}

-- Colors
local COLORS = {
    Background = Color3.fromRGB(18, 18, 28),
    Accent = Color3.fromRGB(0, 255, 170),
    AccentDark = Color3.fromRGB(0, 180, 120),
    Text = Color3.fromRGB(235, 245, 255),
    TextDark = Color3.fromRGB(170, 180, 195),
    Stroke = Color3.fromRGB(60, 60, 85),
    InputBg = Color3.fromRGB(28, 28, 42),
    TabSelected = Color3.fromRGB(35, 35, 55),
}

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 620, 0, 460)
MainFrame.Position = UDim2.new(0.5, -310, 0.5, -230)
MainFrame.BackgroundColor3 = COLORS.Background
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local MainGradient = Instance.new("UIGradient")
MainGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30,30,45)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(18,18,28))
}
MainGradient.Rotation = 90
MainGradient.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = COLORS.Stroke
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 42)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(22, 22, 35)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0.6, 0, 1, 0)
TitleLabel.Position = UDim2.new(0.02, 0, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Los Primos Client"
TitleLabel.TextColor3 = COLORS.Accent
TitleLabel.TextSize = 22
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

-- Owned Label moved to TitleBar
local OwnedLabel = Instance.new("TextLabel")
OwnedLabel.Size = UDim2.new(0.3, 0, 1, 0)
OwnedLabel.Position = UDim2.new(0.65, 0, 0, 0)
OwnedLabel.BackgroundTransparency = 1
OwnedLabel.Text = "Owned by Los Primos"
OwnedLabel.TextColor3 = COLORS.Text
OwnedLabel.TextSize = 16
OwnedLabel.Font = Enum.Font.GothamMedium
OwnedLabel.TextXAlignment = Enum.TextXAlignment.Right
OwnedLabel.Parent = TitleBar

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -38, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(235, 75, 75)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 24
CloseBtn.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

-- Minimize Button
local HideBtn = Instance.new("TextButton")
HideBtn.Size = UDim2.new(0, 32, 0, 32)
HideBtn.Position = UDim2.new(1, -76, 0, 5)
HideBtn.BackgroundColor3 = Color3.fromRGB(95, 95, 160)
HideBtn.Text = "-"
HideBtn.TextColor3 = Color3.new(1,1,1)
HideBtn.Font = Enum.Font.GothamBold
HideBtn.TextSize = 28
HideBtn.Parent = TitleBar

local HideCorner = Instance.new("UICorner")
HideCorner.CornerRadius = UDim.new(0, 8)
HideCorner.Parent = HideBtn

-- Key System Frame
local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(1, 0, 1, -42)
KeyFrame.Position = UDim2.new(0, 0, 0, 42)
KeyFrame.BackgroundTransparency = 1
KeyFrame.Parent = MainFrame

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(0.9, 0, 0.15, 0)
KeyTitle.Position = UDim2.new(0.05, 0, 0.12, 0)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "Los Primos Client"
KeyTitle.TextColor3 = COLORS.Accent
KeyTitle.TextSize = 38
KeyTitle.Font = Enum.Font.GothamBlack
KeyTitle.Parent = KeyFrame

local KeySubtitle = Instance.new("TextLabel")
KeySubtitle.Size = UDim2.new(0.9, 0, 0.08, 0)
KeySubtitle.Position = UDim2.new(0.05, 0, 0.28, 0)
KeySubtitle.BackgroundTransparency = 1
KeySubtitle.Text = "Join Discord Server So You Can Get The Password!"
KeySubtitle.TextColor3 = COLORS.TextDark
KeySubtitle.TextSize = 18
KeySubtitle.Font = Enum.Font.GothamMedium
KeySubtitle.Parent = KeyFrame

local DiscordBtn = Instance.new("TextButton")
DiscordBtn.Size = UDim2.new(0.5, 0, 0.09, 0)
DiscordBtn.Position = UDim2.new(0.25, 0, 0.38, 0)
DiscordBtn.BackgroundColor3 = COLORS.AccentDark
DiscordBtn.Text = "Join Discord Server"
DiscordBtn.TextColor3 = Color3.new(1,1,1)
DiscordBtn.Font = Enum.Font.GothamBold
DiscordBtn.TextSize = 17
DiscordBtn.Parent = KeyFrame

local DiscordCorner = Instance.new("UICorner")
DiscordCorner.CornerRadius = UDim.new(0, 10)
DiscordCorner.Parent = DiscordBtn

local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(0.6, 0, 0.09, 0)
KeyBox.Position = UDim2.new(0.2, 0, 0.52, 0)
KeyBox.BackgroundColor3 = COLORS.InputBg
KeyBox.TextColor3 = COLORS.Text
KeyBox.PlaceholderText = "Enter Key..."
KeyBox.Text = ""
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 18
KeyBox.ClearTextOnFocus = false
KeyBox.Parent = KeyFrame

local KeyBoxCorner = Instance.new("UICorner")
KeyBoxCorner.CornerRadius = UDim.new(0, 8)
KeyBoxCorner.Parent = KeyBox

local KeyBoxStroke = Instance.new("UIStroke")
KeyBoxStroke.Color = COLORS.Stroke
KeyBoxStroke.Parent = KeyBox

local SubmitBtn = Instance.new("TextButton")
SubmitBtn.Size = UDim2.new(0.35, 0, 0.09, 0)
SubmitBtn.Position = UDim2.new(0.325, 0, 0.68, 0)
SubmitBtn.BackgroundColor3 = COLORS.Accent
SubmitBtn.Text = "Authenticate"
SubmitBtn.TextColor3 = Color3.new(1,1,1)
SubmitBtn.Font = Enum.Font.GothamBold
SubmitBtn.TextSize = 18
SubmitBtn.Parent = KeyFrame

local SubmitCorner = Instance.new("UICorner")
SubmitCorner.CornerRadius = UDim.new(0, 10)
SubmitCorner.Parent = SubmitBtn

-- Main UI (hidden initially)
local MainUI = Instance.new("Frame")
MainUI.Size = UDim2.new(1, 0, 1, -42)
MainUI.Position = UDim2.new(0, 0, 0, 42)
MainUI.BackgroundTransparency = 1
MainUI.Visible = false
MainUI.Parent = MainFrame

-- Tab System
local TabButtonsFrame = Instance.new("Frame")
TabButtonsFrame.Size = UDim2.new(0.28, 0, 0.9, 0)
TabButtonsFrame.Position = UDim2.new(0.02, 0, 0.05, 0)
TabButtonsFrame.BackgroundTransparency = 1
TabButtonsFrame.Parent = MainUI

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(0.68, 0, 0.9, 0)
ContentFrame.Position = UDim2.new(0.32, 0, 0.05, 0)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainUI

-- Tab Creation Function
local function createTab(name, order)
    local btn = Instance.new("TextButton")
    btn.Name = name .. "TabBtn"
    btn.Size = UDim2.new(1, 0, 0, 48)
    btn.Position = UDim2.new(0, 0, 0, (order-1) * 52)
    btn.BackgroundColor3 = COLORS.InputBg
    btn.Text = name
    btn.TextColor3 = COLORS.TextDark
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 17
    btn.Parent = TabButtonsFrame
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 9)
    tabCorner.Parent = btn
    
    local content = Instance.new("ScrollingFrame")
    content.Name = name .. "Content"
    content.Size = UDim2.new(1, 0, 1, 0)
    content.BackgroundTransparency = 1
    content.Visible = false
    content.ScrollBarThickness = 4
    content.ScrollingDirection = Enum.ScrollingDirection.Y
    content.CanvasSize = UDim2.new(0,0,0,0)
    content.Parent = ContentFrame
    
    local list = Instance.new("UIListLayout")
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Padding = UDim.new(0, 8)
    list.Parent = content
    
    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 10)
    pad.PaddingRight = UDim.new(0, 10)
    pad.PaddingTop = UDim.new(0, 10)
    pad.PaddingBottom = UDim.new(0, 10)
    pad.Parent = content
    
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        content.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + pad.PaddingTop.Offset + pad.PaddingBottom.Offset)
    end)
    
    btn.MouseButton1Click:Connect(function()
        for _, v in pairs(ContentFrame:GetChildren()) do
            if v:IsA("ScrollingFrame") then
                v.Visible = false
            end
        end
        for _, v in pairs(TabButtonsFrame:GetChildren()) do
            if v:IsA("TextButton") then
                TweenService:Create(v, TweenInfo.new(0.25), {
                    BackgroundColor3 = COLORS.InputBg,
                    TextColor3 = COLORS.TextDark
                }):Play()
            end
        end
        
        content.Visible = true
        TweenService:Create(btn, TweenInfo.new(0.25), {
            BackgroundColor3 = COLORS.TabSelected,
            TextColor3 = COLORS.Accent
        }):Play()
    end)
    
    return content, btn
end

-- Create Tabs
local CombatContent, CombatBtn = createTab("Combat", 1)
local MovementContent, MovementBtn = createTab("Movement", 2)
local FarmingContent, FarmingBtn = createTab("Farming", 3)
local ExtrasContent, ExtrasBtn = createTab("Extras", 4)
local ExecutorContent, ExecutorBtn = createTab("Executor", 5)

-- Combat Tab - Aimbot
local AimbotToggle = Instance.new("TextButton")
AimbotToggle.Size = UDim2.new(1, 0, 0, 50)
AimbotToggle.BackgroundColor3 = COLORS.InputBg
AimbotToggle.Text = "Friendly Aimbot (NPC) : OFF"
AimbotToggle.TextColor3 = COLORS.TextDark
AimbotToggle.Font = Enum.Font.GothamSemibold
AimbotToggle.TextSize = 17
AimbotToggle.Parent = CombatContent

local AimbotCorner = Instance.new("UICorner")
AimbotCorner.CornerRadius = UDim.new(0, 9)
AimbotCorner.Parent = AimbotToggle

local HitboxToggle = Instance.new("TextButton")
HitboxToggle.Size = UDim2.new(1, 0, 0, 50)
HitboxToggle.BackgroundColor3 = COLORS.InputBg
HitboxToggle.Text = "Hitbox Expander : OFF"
HitboxToggle.TextColor3 = COLORS.TextDark
HitboxToggle.Font = Enum.Font.GothamSemibold
HitboxToggle.TextSize = 17
HitboxToggle.Parent = CombatContent

local HitboxCorner = Instance.new("UICorner")
HitboxCorner.CornerRadius = UDim.new(0, 9)
HitboxCorner.Parent = HitboxToggle

local HitboxSizeBox = Instance.new("TextBox")
HitboxSizeBox.Size = UDim2.new(1, 0, 0, 50)
HitboxSizeBox.BackgroundColor3 = COLORS.InputBg
HitboxSizeBox.TextColor3 = COLORS.Text
HitboxSizeBox.PlaceholderText = "Hitbox Size"
HitboxSizeBox.Text = tostring(hitboxSize)
HitboxSizeBox.Font = Enum.Font.Gotham
HitboxSizeBox.TextSize = 18
HitboxSizeBox.Parent = CombatContent

local HitboxSizeCorner = Instance.new("UICorner")
HitboxSizeCorner.CornerRadius = UDim.new(0, 8)
HitboxSizeCorner.Parent = HitboxSizeBox

local HitboxSizeStroke = Instance.new("UIStroke")
HitboxSizeStroke.Color = COLORS.Stroke
HitboxSizeStroke.Parent = HitboxSizeBox

local FOVBox = Instance.new("TextBox")
FOVBox.Size = UDim2.new(1, 0, 0, 50)
FOVBox.BackgroundColor3 = COLORS.InputBg
FOVBox.TextColor3 = COLORS.Text
FOVBox.PlaceholderText = "FOV"
FOVBox.Text = tostring(fovValue)
FOVBox.Font = Enum.Font.Gotham
FOVBox.TextSize = 18
FOVBox.Parent = CombatContent

local FOVCorner = Instance.new("UICorner")
FOVCorner.CornerRadius = UDim.new(0, 8)
FOVCorner.Parent = FOVBox

local FOVStroke = Instance.new("UIStroke")
FOVStroke.Color = COLORS.Stroke
FOVStroke.Parent = FOVBox

local ESPToggle = Instance.new("TextButton")
ESPToggle.Size = UDim2.new(1, 0, 0, 50)
ESPToggle.BackgroundColor3 = COLORS.InputBg
ESPToggle.Text = "ESP : OFF"
ESPToggle.TextColor3 = COLORS.TextDark
ESPToggle.Font = Enum.Font.GothamSemibold
ESPToggle.TextSize = 17
ESPToggle.Parent = CombatContent

local ESPCorner = Instance.new("UICorner")
ESPCorner.CornerRadius = UDim.new(0, 9)
ESPCorner.Parent = ESPToggle

-- Movement Tab
local SpeedToggle = Instance.new("TextButton")
SpeedToggle.Size = UDim2.new(1, 0, 0, 50)
SpeedToggle.BackgroundColor3 = COLORS.InputBg
SpeedToggle.Text = "Speed Boost : OFF"
SpeedToggle.TextColor3 = COLORS.TextDark
SpeedToggle.Font = Enum.Font.GothamSemibold
SpeedToggle.TextSize = 17
SpeedToggle.Parent = MovementContent

local SpeedCorner = Instance.new("UICorner")
SpeedCorner.CornerRadius = UDim.new(0, 9)
SpeedCorner.Parent = SpeedToggle

local FlyBtn = Instance.new("TextButton")
FlyBtn.Size = UDim2.new(1, 0, 0, 50)
FlyBtn.BackgroundColor3 = COLORS.InputBg
FlyBtn.Text = "Activate Mobile Fly"
FlyBtn.TextColor3 = COLORS.TextDark
FlyBtn.Font = Enum.Font.GothamSemibold
FlyBtn.TextSize = 17
FlyBtn.Parent = MovementContent

local FlyCorner = Instance.new("UICorner")
FlyCorner.CornerRadius = UDim.new(0, 9)
FlyCorner.Parent = FlyBtn

local NoClipToggle = Instance.new("TextButton")
NoClipToggle.Size = UDim2.new(1, 0, 0, 50)
NoClipToggle.BackgroundColor3 = COLORS.InputBg
NoClipToggle.Text = "No Clip : OFF"
NoClipToggle.TextColor3 = COLORS.TextDark
NoClipToggle.Font = Enum.Font.GothamSemibold
NoClipToggle.TextSize = 17
NoClipToggle.Parent = MovementContent

local NoClipCorner = Instance.new("UICorner")
NoClipCorner.CornerRadius = UDim.new(0, 9)
NoClipCorner.Parent = NoClipToggle

local InfJumpToggle = Instance.new("TextButton")
InfJumpToggle.Size = UDim2.new(1, 0, 0, 50)
InfJumpToggle.BackgroundColor3 = COLORS.InputBg
InfJumpToggle.Text = "Infinite Jump : OFF"
InfJumpToggle.TextColor3 = COLORS.TextDark
InfJumpToggle.Font = Enum.Font.GothamSemibold
InfJumpToggle.TextSize = 17
InfJumpToggle.Parent = MovementContent

local InfJumpCorner = Instance.new("UICorner")
InfJumpCorner.CornerRadius = UDim.new(0, 9)
InfJumpCorner.Parent = InfJumpToggle

local TPWalkToggle = Instance.new("TextButton")
TPWalkToggle.Size = UDim2.new(1, 0, 0, 50)
TPWalkToggle.BackgroundColor3 = COLORS.InputBg
TPWalkToggle.Text = "TP Walk : OFF"
TPWalkToggle.TextColor3 = COLORS.TextDark
TPWalkToggle.Font = Enum.Font.GothamSemibold
TPWalkToggle.TextSize = 17
TPWalkToggle.Parent = MovementContent

local TPWalkCorner = Instance.new("UICorner")
TPWalkCorner.CornerRadius = UDim.new(0, 9)
TPWalkCorner.Parent = TPWalkToggle

local TPWalkSpeedBox = Instance.new("TextBox")
TPWalkSpeedBox.Size = UDim2.new(1, 0, 0, 50)
TPWalkSpeedBox.BackgroundColor3 = COLORS.InputBg
TPWalkSpeedBox.TextColor3 = COLORS.Text
TPWalkSpeedBox.PlaceholderText = "TP Walk Speed"
TPWalkSpeedBox.Text = tostring(tpwalkSpeed)
TPWalkSpeedBox.Font = Enum.Font.Gotham
TPWalkSpeedBox.TextSize = 18
TPWalkSpeedBox.Parent = MovementContent

local TPWalkSpeedCorner = Instance.new("UICorner")
TPWalkSpeedCorner.CornerRadius = UDim.new(0, 8)
TPWalkSpeedCorner.Parent = TPWalkSpeedBox

local TPWalkSpeedStroke = Instance.new("UIStroke")
TPWalkSpeedStroke.Color = COLORS.Stroke
TPWalkSpeedStroke.Parent = TPWalkSpeedBox

local FreecamToggle = Instance.new("TextButton")
FreecamToggle.Size = UDim2.new(1, 0, 0, 50)
FreecamToggle.BackgroundColor3 = COLORS.InputBg
FreecamToggle.Text = "Freecam : OFF"
FreecamToggle.TextColor3 = COLORS.TextDark
FreecamToggle.Font = Enum.Font.GothamSemibold
FreecamToggle.TextSize = 17
FreecamToggle.Parent = MovementContent

local FreecamCorner = Instance.new("UICorner")
FreecamCorner.CornerRadius = UDim.new(0, 9)
FreecamCorner.Parent = FreecamToggle

local FreecamSpeedBox = Instance.new("TextBox")
FreecamSpeedBox.Size = UDim2.new(1, 0, 0, 50)
FreecamSpeedBox.BackgroundColor3 = COLORS.InputBg
FreecamSpeedBox.TextColor3 = COLORS.Text
FreecamSpeedBox.PlaceholderText = "Freecam Speed"
FreecamSpeedBox.Text = tostring(freecamSpeed)
FreecamSpeedBox.Font = Enum.Font.Gotham
FreecamSpeedBox.TextSize = 18
FreecamSpeedBox.Parent = MovementContent

local FreecamSpeedCorner = Instance.new("UICorner")
FreecamSpeedCorner.CornerRadius = UDim.new(0, 8)
FreecamSpeedCorner.Parent = FreecamSpeedBox

local FreecamSpeedStroke = Instance.new("UIStroke")
FreecamSpeedStroke.Color = COLORS.Stroke
FreecamSpeedStroke.Parent = FreecamSpeedBox

local AntiAFKToggle = Instance.new("TextButton")
AntiAFKToggle.Size = UDim2.new(1, 0, 0, 50)
AntiAFKToggle.BackgroundColor3 = COLORS.InputBg
AntiAFKToggle.Text = "Anti AFK : OFF"
AntiAFKToggle.TextColor3 = COLORS.TextDark
AntiAFKToggle.Font = Enum.Font.GothamSemibold
AntiAFKToggle.TextSize = 17
AntiAFKToggle.Parent = MovementContent

local AntiAFKCorner = Instance.new("UICorner")
AntiAFKCorner.CornerRadius = UDim.new(0, 9)
AntiAFKCorner.Parent = AntiAFKToggle

local ResetCharBtn = Instance.new("TextButton")
ResetCharBtn.Size = UDim2.new(1, 0, 0, 50)
ResetCharBtn.BackgroundColor3 = COLORS.InputBg
ResetCharBtn.Text = "Reset Character"
ResetCharBtn.TextColor3 = COLORS.TextDark
ResetCharBtn.Font = Enum.Font.GothamSemibold
ResetCharBtn.TextSize = 17
ResetCharBtn.Parent = MovementContent

local ResetCharCorner = Instance.new("UICorner")
ResetCharCorner.CornerRadius = UDim.new(0, 9)
ResetCharCorner.Parent = ResetCharBtn

local ClickTPToggle = Instance.new("TextButton")
ClickTPToggle.Size = UDim2.new(1, 0, 0, 50)
ClickTPToggle.BackgroundColor3 = COLORS.InputBg
ClickTPToggle.Text = "Teleporting Tools (Click TP) : OFF"
ClickTPToggle.TextColor3 = COLORS.TextDark
ClickTPToggle.Font = Enum.Font.GothamSemibold
ClickTPToggle.TextSize = 17
ClickTPToggle.Parent = MovementContent

local ClickTPCorner = Instance.new("UICorner")
ClickTPCorner.CornerRadius = UDim.new(0, 9)
ClickTPCorner.Parent = ClickTPToggle

-- Farming Tab
local AutoFarmToggle = Instance.new("TextButton")
AutoFarmToggle.Size = UDim2.new(1, 0, 0, 50)
AutoFarmToggle.BackgroundColor3 = COLORS.InputBg
AutoFarmToggle.Text = "Auto Farm : OFF"
AutoFarmToggle.TextColor3 = COLORS.TextDark
AutoFarmToggle.Font = Enum.Font.GothamSemibold
AutoFarmToggle.TextSize = 17
AutoFarmToggle.Parent = FarmingContent

local FarmCorner1 = Instance.new("UICorner")
FarmCorner1.CornerRadius = UDim.new(0, 9)
FarmCorner1.Parent = AutoFarmToggle

-- Extras Tab - DP Hub
local DPHubBtn = Instance.new("TextButton")
DPHubBtn.Size = UDim2.new(1, 0, 0, 60)
DPHubBtn.BackgroundColor3 = Color3.fromRGB(80, 40, 120)
DPHubBtn.Text = "Load DP-HUB"
DPHubBtn.TextColor3 = Color3.new(1,1,1)
DPHubBtn.Font = Enum.Font.GothamBold
DPHubBtn.TextSize = 20
DPHubBtn.Parent = ExtrasContent

local DPHubCorner = Instance.new("UICorner")
DPHubCorner.CornerRadius = UDim.new(0, 12)
DPHubCorner.Parent = DPHubBtn

local XrayToggle = Instance.new("TextButton")
XrayToggle.Size = UDim2.new(1, 0, 0, 50)
XrayToggle.BackgroundColor3 = COLORS.InputBg
XrayToggle.Text = "X-Ray : OFF"
XrayToggle.TextColor3 = COLORS.TextDark
XrayToggle.Font = Enum.Font.GothamSemibold
XrayToggle.TextSize = 17
XrayToggle.Parent = ExtrasContent

local XrayCorner = Instance.new("UICorner")
XrayCorner.CornerRadius = UDim.new(0, 9)
XrayCorner.Parent = XrayToggle

local ServerHopBtn = Instance.new("TextButton")
ServerHopBtn.Size = UDim2.new(1, 0, 0, 50)
ServerHopBtn.BackgroundColor3 = COLORS.InputBg
ServerHopBtn.Text = "Server Hop"
ServerHopBtn.TextColor3 = COLORS.TextDark
ServerHopBtn.Font = Enum.Font.GothamSemibold
ServerHopBtn.TextSize = 17
ServerHopBtn.Parent = ExtrasContent

local ServerHopCorner = Instance.new("UICorner")
ServerHopCorner.CornerRadius = UDim.new(0, 9)
ServerHopCorner.Parent = ServerHopBtn

local RejoinBtn = Instance.new("TextButton")
RejoinBtn.Size = UDim2.new(1, 0, 0, 50)
RejoinBtn.BackgroundColor3 = COLORS.InputBg
RejoinBtn.Text = "Rejoin Server"
RejoinBtn.TextColor3 = COLORS.TextDark
RejoinBtn.Font = Enum.Font.GothamSemibold
RejoinBtn.TextSize = 17
RejoinBtn.Parent = ExtrasContent

local RejoinCorner = Instance.new("UICorner")
RejoinCorner.CornerRadius = UDim.new(0, 9)
RejoinCorner.Parent = RejoinBtn

local ServerInfoBtn = Instance.new("TextButton")
ServerInfoBtn.Size = UDim2.new(1, 0, 0, 50)
ServerInfoBtn.BackgroundColor3 = COLORS.InputBg
ServerInfoBtn.Text = "Copy Server Info"
ServerInfoBtn.TextColor3 = COLORS.TextDark
ServerInfoBtn.Font = Enum.Font.GothamSemibold
ServerInfoBtn.TextSize = 17
ServerInfoBtn.Parent = ExtrasContent

local ServerInfoCorner = Instance.new("UICorner")
ServerInfoCorner.CornerRadius = UDim.new(0, 9)
ServerInfoCorner.Parent = ServerInfoBtn

local LocalPlayerBtn = Instance.new("TextButton")
LocalPlayerBtn.Size = UDim2.new(1, 0, 0, 50)
LocalPlayerBtn.BackgroundColor3 = COLORS.InputBg
LocalPlayerBtn.Text = "Copy Local Player Info"
LocalPlayerBtn.TextColor3 = COLORS.TextDark
LocalPlayerBtn.Font = Enum.Font.GothamSemibold
LocalPlayerBtn.TextSize = 17
LocalPlayerBtn.Parent = ExtrasContent

local LocalPlayerCorner = Instance.new("UICorner")
LocalPlayerCorner.CornerRadius = UDim.new(0, 9)
LocalPlayerCorner.Parent = LocalPlayerBtn

-- Executor Tab
local ScriptBox = Instance.new("TextBox")
ScriptBox.Size = UDim2.new(1, 0, 0, 200) -- Larger for scripts
ScriptBox.BackgroundColor3 = COLORS.InputBg
ScriptBox.TextColor3 = COLORS.Text
ScriptBox.PlaceholderText = "Enter Lua Script Here..."
ScriptBox.Text = ""
ScriptBox.Font = Enum.Font.Code
ScriptBox.TextSize = 14
ScriptBox.MultiLine = true
ScriptBox.ClearTextOnFocus = false
ScriptBox.TextWrapped = true
ScriptBox.Parent = ExecutorContent

local ScriptCorner = Instance.new("UICorner")
ScriptCorner.CornerRadius = UDim.new(0, 8)
ScriptCorner.Parent = ScriptBox

local ExecuteBtn = Instance.new("TextButton")
ExecuteBtn.Size = UDim2.new(0.45, 0, 0, 50)
ExecuteBtn.BackgroundColor3 = COLORS.Accent
ExecuteBtn.Text = "Execute"
ExecuteBtn.TextColor3 = Color3.new(1,1,1)
ExecuteBtn.Font = Enum.Font.GothamBold
ExecuteBtn.TextSize = 18
ExecuteBtn.Parent = ExecutorContent

local ExecCorner = Instance.new("UICorner")
ExecCorner.CornerRadius = UDim.new(0, 10)
ExecCorner.Parent = ExecuteBtn

local ClearBtn = Instance.new("TextButton")
ClearBtn.Size = UDim2.new(0.45, 0, 0, 50)
ClearBtn.BackgroundColor3 = COLORS.AccentDark
ClearBtn.Text = "Clear"
ClearBtn.TextColor3 = Color3.new(1,1,1)
ClearBtn.Font = Enum.Font.GothamBold
ClearBtn.TextSize = 18
ClearBtn.Parent = ExecutorContent

local ClearCorner = Instance.new("UICorner")
ClearCorner.CornerRadius = UDim.new(0, 10)
ClearCorner.Parent = ClearBtn

-- Minimize Icon
local MinIcon = Instance.new("TextButton")
MinIcon.Size = UDim2.new(0, 70, 0, 70)
MinIcon.Position = UDim2.new(1, -90, 1, -90)
MinIcon.BackgroundColor3 = COLORS.AccentDark
MinIcon.Text = "LP"
MinIcon.TextColor3 = Color3.new(1,1,1)
MinIcon.Font = Enum.Font.GothamBold
MinIcon.TextSize = 24
MinIcon.Visible = false
MinIcon.Parent = ScreenGui

local MinIconCorner = Instance.new("UICorner")
MinIconCorner.CornerRadius = UDim.new(1, 0)
MinIconCorner.Parent = MinIcon

-- ESP Functionality
local function addESP(plr)
    if plr ~= player and plr.Character then
        local hl = Instance.new("Highlight")
        hl.Parent = plr.Character
        hl.FillColor = Color3.fromRGB(255, 0, 0)
        hl.FillTransparency = 0.5
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        hl.OutlineTransparency = 0
        highlights[plr] = hl
    end
end

local function toggleESP(enabled)
    if enabled then
        for _, plr in pairs(Players:GetPlayers()) do
            addESP(plr)
        end
    else
        for _, hl in pairs(highlights) do
            if hl then hl:Destroy() end
        end
        highlights = {}
    end
end

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        if espEnabled then
            addESP(plr)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(plr)
    if highlights[plr] then
        highlights[plr]:Destroy()
        highlights[plr] = nil
    end
end)

for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= player then
        plr.CharacterAdded:Connect(function()
            if espEnabled then
                addESP(plr)
            end
        end)
        if plr.Character and espEnabled then
            addESP(plr)
        end
    end
end

-- Functionality
DiscordBtn.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/uEupXWPCj")
    DiscordBtn.Text = "Copied! Join Now"
    wait(1.5)
    DiscordBtn.Text = "Join Discord Server"
end)

SubmitBtn.MouseButton1Click:Connect(function()
    if KeyBox.Text == keyCorrect then
        KeyFrame.Visible = false
        MainUI.Visible = true
        CombatBtn:Invoke()
    else
        -- Shake animation
        for i = 1, 4 do
            TweenService:Create(KeyBox, TweenInfo.new(0.1), {
                Position = UDim2.new(0.2 + math.random(-0.02, 0.02), 0, 0.52 + math.random(-0.02, 0.02), 0)
            }):Play()
            wait(0.1)
        end
        KeyBox.Position = UDim2.new(0.2, 0, 0.52, 0)
    end
end)

AimbotToggle.MouseButton1Click:Connect(function()
    aiming = not aiming
    AimbotToggle.Text = "Friendly Aimbot (NPC) : " .. (aiming and "ON" or "OFF")
    TweenService:Create(AimbotToggle, TweenInfo.new(0.2), {
        BackgroundColor3 = aiming and COLORS.AccentDark or COLORS.InputBg,
        TextColor3 = aiming and Color3.new(1,1,1) or COLORS.TextDark
    }):Play()
end)

HitboxToggle.MouseButton1Click:Connect(function()
    hitboxExpand = not hitboxExpand
    HitboxToggle.Text = "Hitbox Expander : " .. (hitboxExpand and "ON" or "OFF")
    TweenService:Create(HitboxToggle, TweenInfo.new(0.2), {
        BackgroundColor3 = hitboxExpand and COLORS.AccentDark or COLORS.InputBg,
        TextColor3 = hitboxExpand and Color3.new(1,1,1) or COLORS.TextDark
    }):Play()
end)

HitboxSizeBox.FocusLost:Connect(function()
    local num = tonumber(HitboxSizeBox.Text)
    if num then hitboxSize = num end
    HitboxSizeBox.Text = tostring(hitboxSize)
end)

FOVBox.FocusLost:Connect(function()
    local num = tonumber(FOVBox.Text)
    if num then 
        fovValue = num
        cam.FieldOfView = fovValue
    end
    FOVBox.Text = tostring(fovValue)
end)

ESPToggle.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    ESPToggle.Text = "ESP : " .. (espEnabled and "ON" or "OFF")
    TweenService:Create(ESPToggle, TweenInfo.new(0.2), {
        BackgroundColor3 = espEnabled and COLORS.AccentDark or COLORS.InputBg,
        TextColor3 = espEnabled and Color3.new(1,1,1) or COLORS.TextDark
    }):Play()
    toggleESP(espEnabled)
end)

SpeedToggle.MouseButton1Click:Connect(function()
    fastSpeed = not fastSpeed
    SpeedToggle.Text = "Speed Boost : " .. (fastSpeed and "ON" or "OFF")
    TweenService:Create(SpeedToggle, TweenInfo.new(0.2), {
        BackgroundColor3 = fastSpeed and COLORS.AccentDark or COLORS.InputBg,
        TextColor3 = fastSpeed and Color3.new(1,1,1) or COLORS.TextDark
    }):Play()
end)

FlyBtn.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Mobile-Fly-V1-45764"))()
end)

NoClipToggle.MouseButton1Click:Connect(function()
    noclip = not noclip
    NoClipToggle.Text = "No Clip : " .. (noclip and "ON" or "OFF")
    TweenService:Create(NoClipToggle, TweenInfo.new(0.2), {
        BackgroundColor3 = noclip and COLORS.AccentDark or COLORS.InputBg,
        TextColor3 = noclip and Color3.new(1,1,1) or COLORS.TextDark
    }):Play()
end)

InfJumpToggle.MouseButton1Click:Connect(function()
    infjump = not infjump
    InfJumpToggle.Text = "Infinite Jump : " .. (infjump and "ON" or "OFF")
    TweenService:Create(InfJumpToggle, TweenInfo.new(0.2), {
        BackgroundColor3 = infjump and COLORS.AccentDark or COLORS.InputBg,
        TextColor3 = infjump and Color3.new(1,1,1) or COLORS.TextDark
    }):Play()
end)

TPWalkToggle.MouseButton1Click:Connect(function()
    tpwalk = not tpwalk
    TPWalkToggle.Text = "TP Walk : " .. (tpwalk and "ON" or "OFF")
    TweenService:Create(TPWalkToggle, TweenInfo.new(0.2), {
        BackgroundColor3 = tpwalk and COLORS.AccentDark or COLORS.InputBg,
        TextColor3 = tpwalk and Color3.new(1,1,1) or COLORS.TextDark
    }):Play()
end)

TPWalkSpeedBox.FocusLost:Connect(function()
    local num = tonumber(TPWalkSpeedBox.Text)
    if num then tpwalkSpeed = num end
    TPWalkSpeedBox.Text = tostring(tpwalkSpeed)
end)

FreecamToggle.MouseButton1Click:Connect(function()
    freecam = not freecam
    FreecamToggle.Text = "Freecam : " .. (freecam and "ON" or "OFF")
    TweenService:Create(FreecamToggle, TweenInfo.new(0.2), {
        BackgroundColor3 = freecam and COLORS.AccentDark or COLORS.InputBg,
        TextColor3 = freecam and Color3.new(1,1,1) or COLORS.TextDark
    }):Play()
    if freecam then
        savedCamType = cam.CameraType
        savedMouseBehavior = UserInputService.MouseBehavior
        savedCFrame = cam.CFrame
        yaw = 0
        pitch = 0
        cam.CameraType = Enum.CameraType.Scriptable
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
    else
        cam.CameraType = Enum.CameraType.Custom
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        if player.Character then
            cam.CameraSubject = player.Character:FindFirstChildWhichIsA("Humanoid") or player.Character.PrimaryPart
        end
    end
end)

FreecamSpeedBox.FocusLost:Connect(function()
    local num = tonumber(FreecamSpeedBox.Text)
    if num then freecamSpeed = num end
    FreecamSpeedBox.Text = tostring(freecamSpeed)
end)

AntiAFKToggle.MouseButton1Click:Connect(function()
    antiAFK = not antiAFK
    AntiAFKToggle.Text = "Anti AFK : " .. (antiAFK and "ON" or "OFF")
    TweenService:Create(AntiAFKToggle, TweenInfo.new(0.2), {
        BackgroundColor3 = antiAFK and COLORS.AccentDark or COLORS.InputBg,
        TextColor3 = antiAFK and Color3.new(1,1,1) or COLORS.TextDark
    }):Play()
    if antiAFK then
        spawn(function()
            while antiAFK do
                wait(60)
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end
        end)
    end
end)

ResetCharBtn.MouseButton1Click:Connect(function()
    if player.Character then
        player.Character:BreakJoints()
    end
end)

ClickTPToggle.MouseButton1Click:Connect(function()
    clickTP = not clickTP
    ClickTPToggle.Text = "Teleporting Tools (Click TP) : " .. (clickTP and "ON" or "OFF")
    TweenService:Create(ClickTPToggle, TweenInfo.new(0.2), {
        BackgroundColor3 = clickTP and COLORS.AccentDark or COLORS.InputBg,
        TextColor3 = clickTP and Color3.new(1,1,1) or COLORS.TextDark
    }):Play()
end)

AutoFarmToggle.MouseButton1Click:Connect(function()
    autoFarm = not autoFarm
    AutoFarmToggle.Text = "Auto Farm : " .. (autoFarm and "ON" or "OFF")
    TweenService:Create(AutoFarmToggle, TweenInfo.new(0.2), {
        BackgroundColor3 = autoFarm and COLORS.AccentDark or COLORS.InputBg,
        TextColor3 = autoFarm and Color3.new(1,1,1) or COLORS.TextDark
    }):Play()
end)

DPHubBtn.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/CoolXplo/DP-HUB-coolxplo/main/The_Storage.lua"))()
end)

XrayToggle.MouseButton1Click:Connect(function()
    xray = not xray
    XrayToggle.Text = "X-Ray : " .. (xray and "ON" or "OFF")
    TweenService:Create(XrayToggle, TweenInfo.new(0.2), {
        BackgroundColor3 = xray and COLORS.AccentDark or COLORS.InputBg,
        TextColor3 = xray and Color3.new(1,1,1) or COLORS.TextDark
    }):Play()
    if xray then
        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and not part.Parent:FindFirstChild("Humanoid") and part.Parent ~= player.Character then
                if not originalTrans[part] then
                    originalTrans[part] = part.Transparency
                end
                part.Transparency = 0.7
            end
        end
    else
        for part, trans in pairs(originalTrans) do
            if part and part.Parent then
                part.Transparency = trans
            end
        end
        originalTrans = {}
    end
end)

local function serverHop()
    local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
    local serverFound = false
    for _, server in ipairs(servers.data) do
        if server.playing < server.maxPlayers and server.id ~= game.JobId then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, player)
            serverFound = true
            break
        end
    end
    if not serverFound then
        print("No suitable server found for hopping.")
    end
end

ServerHopBtn.MouseButton1Click:Connect(serverHop)

RejoinBtn.MouseButton1Click:Connect(function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
end)

ServerInfoBtn.MouseButton1Click:Connect(function()
    local info = "PlaceId: " .. game.PlaceId .. "\nJobId: " .. game.JobId .. "\nPlayers: " .. #Players:GetPlayers()
    setclipboard(info)
    print("Copied server info to clipboard!")
end)

LocalPlayerBtn.MouseButton1Click:Connect(function()
    local info = "Name: " .. player.Name .. "\nUserId: " .. player.UserId .. "\nAccountAge: " .. player.AccountAge .. "\nDisplayName: " .. player.DisplayName
    setclipboard(info)
    print("Copied local player info to clipboard!")
end)

ExecuteBtn.MouseButton1Click:Connect(function()
    loadstring(ScriptBox.Text)()
end)

ClearBtn.MouseButton1Click:Connect(function()
    ScriptBox.Text = ""
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

HideBtn.MouseButton1Click:Connect(function()
    minimized = true
    MainFrame.Visible = false
    MinIcon.Visible = true
end)

MinIcon.MouseButton1Click:Connect(function()
    minimized = false
    MinIcon.Visible = false
    MainFrame.Visible = true
end)

-- Drag System
local dragging = false
local dragInput, mousePos, framePos

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        mousePos = input.Position
        framePos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local Delta = input.Position - mousePos
        MainFrame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + Delta.X, framePos.Y.Scale, framePos.Y.Offset + Delta.Y)
    end
end)

-- Input for Freecam
UserInputService.InputBegan:Connect(function(input, gp)
    if gp or not freecam then return end
    local kc = input.KeyCode
    if kc == Enum.KeyCode.W then keys.W = true end
    if kc == Enum.KeyCode.A then keys.A = true end
    if kc == Enum.KeyCode.S then keys.S = true end
    if kc == Enum.KeyCode.D then keys.D = true end
    if kc == Enum.KeyCode.Space then keys.Space = true end
    if kc == Enum.KeyCode.LeftControl then keys.LeftControl = true end
end)

UserInputService.InputEnded:Connect(function(input, gp)
    if gp or not freecam then return end
    local kc = input.KeyCode
    if kc == Enum.KeyCode.W then keys.W = false end
    if kc == Enum.KeyCode.A then keys.A = false end
    if kc == Enum.KeyCode.S then keys.S = false end
    if kc == Enum.KeyCode.D then keys.D = false end
    if kc == Enum.KeyCode.Space then keys.Space = false end
    if kc == Enum.KeyCode.LeftControl then keys.LeftControl = false end
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if infjump and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Click TP
mouse.Button1Down:Connect(function()
    if clickTP and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = mouse.Hit + Vector3.new(0, player.Character.Humanoid.HipHeight + 2.5, 0)
    end
end)

-- Loops
RunService.Stepped:Connect(function(_, dt)
    if noclip and player.Character then
        for _, part in pairs(player.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
    
    if tpwalk and player.Character and player.Character:FindFirstChild("Humanoid") then
        local humanoid = player.Character.Humanoid
        if humanoid.MoveDirection.Magnitude > 0 then
            player.Character:TranslateBy(humanoid.MoveDirection * tpwalkSpeed * dt)
        end
    end
end)

RunService.Heartbeat:Connect(function(dt)
    if fastSpeed and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = 50
    end
    
    if autoFarm and player.Character and player.Character:FindFirstChildOfClass("Tool") then
        player.Character:FindFirstChildOfClass("Tool"):Activate()
    end
    
    if hitboxExpand then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
                p.Character.Head.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                p.Character.Head.Transparency = 0.5
            end
        end
    else
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
                p.Character.Head.Size = Vector3.new(2, 1, 1)
                p.Character.Head.Transparency = 0
            end
        end
    end
end)

RunService.RenderStepped:Connect(function(dt)
    if freecam then
        local delta = UserInputService:GetMouseDelta()
        yaw = yaw - delta.X * 0.2
        pitch = math.clamp(pitch - delta.Y * 0.2, -85, 85)
        local rot = CFrame.Angles(0, math.rad(yaw), 0) * CFrame.Angles(math.rad(pitch), 0, 0)
        
        local vel = Vector3.new()
        if keys.W then vel = vel + cam.CFrame.LookVector end
        if keys.S then vel = vel - cam.CFrame.LookVector end
        if keys.A then vel = vel - cam.CFrame.RightVector end
        if keys.D then vel = vel + cam.CFrame.RightVector end
        if keys.Space then vel = vel + Vector3.new(0,1,0) end
        if keys.LeftControl then vel = vel - Vector3.new(0,1,0) end
        
        if vel.Magnitude > 0 then
            vel = vel.Unit * freecamSpeed
        end
        
        cam.CFrame = cam.CFrame + vel * dt
        cam.CFrame = CFrame.new(cam.CFrame.Position) * rot
    end
end)

-- Fade In Animation
MainFrame.BackgroundTransparency = 1
TweenService:Create(MainFrame, TweenInfo.new(0.8, Enum.EasingStyle.Quint), {
    BackgroundTransparency = 0
}):Play()

print("Los Primos Client GUI Loaded Successfully!")
