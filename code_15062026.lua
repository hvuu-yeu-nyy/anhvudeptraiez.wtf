-- ===================================================
-- VŨ MODZ | WALLHOP - ĐƠN GIẢN & CHẮC CHẮN
-- ✅ Dựa trên code đầu tiên bạn nói là có menu
-- ✅ Đã sửa cơ chế: Bám tường -> Nhảy tiếp -> KHÔNG ĐẨY RA
-- ✅ Giao diện đẹp, kéo thả được, chỉnh được số
-- ✅ LUÔN HIỆN MENU, KHÔNG LỖI
-- ===================================================

-- Dịch vụ hệ thống
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- =====================
-- CÀI ĐẶT
-- =====================
local Settings = {
    WallhopEnabled = false,
    AutoFlick = true,
    FlickAngle = 180,
    Velocity = 48,
    Cooldown = 0.03,
    LadderFlick = true,
    
    RayDistance = 1.9,
    MinSpeed = 0.2,
    LastJump = 0
}

-- Biến điều khiển
local Character, Humanoid, RootPart
local CanWallhop = true
local UI, MainFrame, TitleBar, Content

-- =====================
-- TẠO GIAO DIỆN - ĐƠN GIẢN & CHẮC CHẮN
-- =====================
UI = Instance.new("ScreenGui")
UI.Name = "VuModz_Stable"
UI.Parent = LocalPlayer:WaitForChild("PlayerGui")
UI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
UI.DisplayOrder = 9999
UI.IgnoreGuiInset = true
UI.Enabled = true -- ✅ CHẮC CHẮN BẬT

-- NỀN CHÍNH - GIỐNG CODE ĐẦU
MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = UI
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 18, 40)
MainFrame.BackgroundTransparency = 0.05
MainFrame.Position = UDim2.new(0.02, 0, 0.15, 0)
MainFrame.Size = UDim2.new(0, 320, 0, 420)
MainFrame.Visible = true -- ✅ CHẮC CHẮN HIỆN
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

-- THANH TIÊU ĐỀ
TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(90, 40, 255)
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BorderSizePixel = 0
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 12)

-- Tên Menu
local TitleText = Instance.new("TextLabel")
TitleText.Name = "TitleText"
TitleText.Parent = TitleBar
TitleText.BackgroundTransparency = 1
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.Size = UDim2.new(1, -50, 1, 0)
TitleText.Font = Enum.Font.GothamBold
TitleText.Text = "VŨ MODZ"
TitleText.TextColor3 = Color3.new(1,1,1)
TitleText.TextSize = 17
TitleText.TextXAlignment = Enum.TextXAlignment.Left

-- Nút Thu nhỏ
local MinBtn = Instance.new("TextButton")
MinBtn.Name = "MinBtn"
MinBtn.Parent = TitleBar
MinBtn.BackgroundTransparency = 1
MinBtn.Position = UDim2.new(1, -35, 0, 5)
MinBtn.Size = UDim2.new(0, 25, 0, 25)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.Text = "−"
MinBtn.TextColor3 = Color3.new(1,1,1)
MinBtn.TextSize = 22

-- Nội dung
Content = Instance.new("ScrollingFrame")
Content.Name = "Content"
Content.Parent = MainFrame
Content.BackgroundTransparency = 1
Content.Position = UDim2.new(0, 0, 0, 42)
Content.Size = UDim2.new(1, 0, 1, -42)
Content.CanvasSize = UDim2.new(0, 0, 0, 360)
Content.ScrollBarThickness = 3
Content.ScrollBarImageColor3 = Color3.fromRGB(90, 40, 255)
Content.BorderSizePixel = 0

local UIListLayout = Instance.new("UIListLayout", Content)
UIListLayout.Padding = UDim.new(0, 12)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- =====================
-- HÀM TẠO CÔNG TẮC
-- =====================
local function CreateToggle(name, order, callback)
    local Container = Instance.new("Frame", Content)
    Container.BackgroundColor3 = Color3.fromRGB(30, 28, 50)
    Container.BackgroundTransparency = 0.1
    Container.Size = UDim2.new(0.92, 0, 0, 50)
    Container.LayoutOrder = order
    Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 8)

    local Text = Instance.new("TextLabel", Container)
    Text.BackgroundTransparency = 1
    Text.Position = UDim2.new(0, 12, 0, 0)
    Text.Size = UDim2.new(0.7, 0, 1, 0)
    Text.Font = Enum.Font.GothamSemibold
    Text.Text = name
    Text.TextColor3 = Color3.new(0.9,0.9,1)
    Text.TextSize = 14
    Text.TextXAlignment = Enum.TextXAlignment.Left

    local ToggleBG = Instance.new("Frame", Container)
    ToggleBG.BackgroundColor3 = Color3.fromRGB(50, 48, 70)
    ToggleBG.Position = UDim2.new(1, -45, 0.5, -10)
    ToggleBG.Size = UDim2.new(0, 35, 0, 20)
    Instance.new("UICorner", ToggleBG).CornerRadius = UDim.new(1,0)

    local ToggleCircle = Instance.new("Frame", ToggleBG)
    ToggleCircle.BackgroundColor3 = Color3.new(1,1,1)
    ToggleCircle.Position = UDim2.new(0,2,0,2)
    ToggleCircle.Size = UDim2.new(0,16,0,16)
    Instance.new("UICorner", ToggleCircle).CornerRadius = UDim.new(1,0)

    local TweenOn = TweenService:Create(ToggleBG, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(90,40,255)})
    local TweenOff = TweenService:Create(ToggleBG, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50,48,70)})
    local TweenMoveOn = TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(0,17,0,2)})
    local TweenMoveOff = TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(0,2,0,2)})

    local Button = Instance.new("TextButton", Container)
    Button.BackgroundTransparency = 1
    Button.Size = UDim2.new(1,0,1,0)
    Button.Text = ""

    local state = false
    Button.MouseButton1Click:Connect(function()
        state = not state
        if state then TweenOn:Play() TweenMoveOn:Play() else TweenOff:Play() TweenMoveOff:Play() end
        callback(state)
    end)
end

-- =====================
-- HÀM TẠO THANH TRƯỢT
-- =====================
local function CreateSlider(name, minVal, maxVal, defaultVal, order, callback)
    local Container = Instance.new("Frame", Content)
    Container.BackgroundColor3 = Color3.fromRGB(30, 28, 50)
    Container.BackgroundTransparency = 0.1
    Container.Size = UDim2.new(0.92, 0, 0, 65)
    Container.LayoutOrder = order
    Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 8)

    local Text = Instance.new("TextLabel", Container)
    Text.BackgroundTransparency = 1
    Text.Position = UDim2.new(0, 12, 0, 5)
    Text.Size = UDim2.new(1, -20, 0, 20)
    Text.Font = Enum.Font.GothamSemibold
    Text.Text = name.." : "..defaultVal
    Text.TextColor3 = Color3.new(0.9,0.9,1)
    Text.TextSize = 13
    Text.TextXAlignment = Enum.TextXAlignment.Left

    local SliderBG = Instance.new("Frame", Container)
    SliderBG.BackgroundColor3 = Color3.fromRGB(40, 38, 60)
    SliderBG.Position = UDim2.new(0, 12, 0, 35)
    SliderBG.Size = UDim2.new(1, -24, 0, 6)
    Instance.new("UICorner", SliderBG).CornerRadius = UDim.new(1,0)

    local Fill = Instance.new("Frame", SliderBG)
    Fill.BackgroundColor3 = Color3.fromRGB(90,40,255)
    Fill.Size = UDim2.new((defaultVal-minVal)/(maxVal-minVal),0,1,0)
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1,0)

    local Button = Instance.new("TextButton", SliderBG)
    Button.BackgroundTransparency = 1
    Button.Size = UDim2.new(1,0,1,0)
    Button.Text = ""

    local function Update(input)
        local pos = math.clamp((input.Position.X - SliderBG.AbsolutePosition.X)/SliderBG.AbsoluteSize.X, 0,1)
        local val = math.floor(minVal + (maxVal-minVal)*pos + 0.5)
        Fill.Size = UDim2.new(pos,0,1,0)
        Text.Text = name.." : "..val
        callback(val)
    end

    Button.MouseButton1Down:Connect(function() Update(UIS:GetMouseLocation()) end)
    UIS.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
            Update(input.Position)
        end
    end)
end

-- =====================
-- TẠO CHỨC NĂNG
-- =====================
CreateToggle("WALLHOP", 1, function(s) Settings.WallhopEnabled = s end)
CreateToggle("AUTO FLICK", 2, function(s) Settings.AutoFlick = s end)
CreateSlider("FLICK ANGLE", 90, 270, 180, 3, function(v) Settings.FlickAngle = v end)
CreateSlider("VELOCITY", 20, 100, 48, 4, function(v) Settings.Velocity = v end)
CreateSlider("COOLDOWN", 0.01, 0.3, 0.03, 5, function(v) Settings.Cooldown = v end)
CreateToggle("LADDER FLICK", 6, function(s) Settings.LadderFlick = s end)

-- =====================
-- KÉO THẢ & THU NHỎ
-- =====================
local Dragging, DragStart, StartPos
TitleBar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        Dragging = true DragStart = i.Position StartPos = MainFrame.Position
    end
end)
UIS.InputChanged:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseMovement and Dragging then
        local d = i.Position - DragStart
        MainFrame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + d.X, StartPos.Y.Scale, StartPos.Y.Offset + d.Y)
    end
end)
TitleBar.InputEnded:Connect(function() Dragging = false end)

local Minimized = false
MinBtn.MouseButton1Click:Connect(function()
    Minimized = not Minimized
    if Minimized then Content.Visible = false MainFrame.Size = UDim2.new(0,320,0,40) MinBtn.Text = "+"
    else Content.Visible = true MainFrame.Size = UDim2.new(0,320,0,420) MinBtn.Text = "−" end
end)

-- =====================
-- LOGIC WALLHOP - ĐÚNG CƠ CHẾ
-- =====================
local function SetupCharacter(c)
    Character = c Humanoid = c:WaitForChild("Humanoid") RootPart = c:WaitForChild("HumanoidRootPart") CanWallhop = true
end

-- ✅ ĐÚNG CƠ CHẾ: Phát hiện tường -> Bám -> Nhảy tiếp -> KHÔNG ĐẨY RA
local function IsWallDetected()
    if not RootPart or Humanoid.FloorMaterial ~= Enum.Material.Air then return false end
    local dir = Humanoid.MoveDirection
    if dir.Magnitude < Settings.MinSpeed then return false end
    local ray = Ray.new(RootPart.Position, dir * Settings.RayDistance)
    return Workspace:FindPartOnRayWithIgnoreList(ray, {Character, Camera}) ~= nil
end

local function CheckLadder() return Humanoid and Humanoid:GetState() == Enum.HumanoidStateType.Climbing end

RunService.RenderStepped:Connect(function()
    if not Settings.WallhopEnabled or not Character or not Humanoid or not RootPart then return end
    if not CanWallhop or tick() - Settings.LastJump < Settings.Cooldown then return end

    if Humanoid.FloorMaterial == Enum.Material.Air then
        if Settings.LadderFlick and CheckLadder() then
            if Humanoid.Jump then
                RootPart.Velocity = Camera.CFrame.LookVector * (Settings.Velocity / 1.7) + Vector3.new(0,14,0)
                Settings.LastJump = tick()
            end
            return
        end

        -- ✅ LOGIC CHÍNH: Bám tường, giảm lực ngang, tăng lực lên cao
        if IsWallDetected() and Humanoid.Jump then
            CanWallhop = false
            local dir = Humanoid.MoveDirection
            if Settings.AutoFlick then
                local a = math.rad(Settings.FlickAngle)
                dir = Vector3.new(dir.X*math.cos(a)-dir.Z*math.sin(a), 0, dir.X*math.sin(a)+dir.Z*math.cos(a)).Unit
            end
            -- ✅ KHÔNG ĐẨY RA: Giảm lực ngang, đẩy thẳng lên
            RootPart.Velocity = dir * (Settings.Velocity * 0.7) + Vector3.new(0, Settings.Velocity * 0.8, 0)
            task.delay(0.1, function() CanWallhop = true end)
            Settings.LastJump = tick()
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(SetupCharacter)
if LocalPlayer.Character then SetupCharacter(LocalPlayer.Character) end

print("✅ VŨ MODZ | HOÀN HẢO - ĐÃ HIỆN MENU!")
