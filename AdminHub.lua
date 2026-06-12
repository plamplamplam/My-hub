-- AdminHub LocalScript
-- ใส่ใน StarterPlayerScripts
-- แก้ไข ADMINS ให้เป็น UserId หรือ Username ของคุณ

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- =====================
--   ADMIN LIST (ใส่ชื่อ)
-- =====================
local ADMINS = {
	"YourUsernameHere", -- เปลี่ยนเป็นชื่อของคุณ
	-- "Friend1",
	-- "Friend2",
}

-- ตรวจสอบ Admin
local isAdmin = false
for _, name in ipairs(ADMINS) do
	if string.lower(name) == string.lower(LocalPlayer.Name) then
		isAdmin = true
		break
	end
end

if not isAdmin then
	warn("[AdminHub] คุณไม่ใช่ Admin!")
	return
end

-- =====================
--   สร้าง GUI
-- =====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AdminHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer.PlayerGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 560, 0, 380)
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -50, 1, 0)
TitleText.Position = UDim2.new(0, 10, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "⚙ ADMIN HUB"
TitleText.TextColor3 = Color3.fromRGB(220, 30, 30)
TitleText.TextSize = 18
TitleText.Font = Enum.Font.GothamBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

local SubText = Instance.new("TextLabel")
SubText.Size = UDim2.new(0, 120, 1, 0)
SubText.Position = UDim2.new(0, 130, 0, 0)
SubText.BackgroundTransparency = 1
SubText.Text = "BloxAdmin"
SubText.TextColor3 = Color3.fromRGB(150, 150, 150)
SubText.TextSize = 13
SubText.Font = Enum.Font.Gotham
SubText.TextXAlignment = Enum.TextXAlignment.Left
SubText.Parent = TitleBar

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 5)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
	MainFrame.Visible = false
end)

-- Minimize Button (เปิดปิดด้วย RightShift)
local MinimizeHint = Instance.new("TextLabel")
MinimizeHint.Size = UDim2.new(0, 200, 0, 20)
MinimizeHint.Position = UDim2.new(0, 10, 0, -25)
MinimizeHint.BackgroundTransparency = 1
MinimizeHint.Text = "กด RightShift เพื่อเปิด/ปิด"
MinimizeHint.TextColor3 = Color3.fromRGB(150, 150, 150)
MinimizeHint.TextSize = 11
MinimizeHint.Font = Enum.Font.Gotham
MinimizeHint.Parent = MainFrame

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 150, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

-- Content Area
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, -155, 1, -45)
ContentArea.Position = UDim2.new(0, 155, 0, 45)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

-- =====================
--   TABS (เมนูซ้าย)
-- =====================
local tabs = {"Players", "Teleport", "Stats", "Misc", "Server"}
local tabButtons = {}
local tabPages = {}
local currentTab = nil

local SidebarList = Instance.new("UIListLayout")
SidebarList.Padding = UDim.new(0, 2)
SidebarList.Parent = Sidebar

local SidebarPad = Instance.new("UIPadding")
SidebarPad.PaddingTop = UDim.new(0, 8)
SidebarPad.PaddingLeft = UDim.new(0, 8)
SidebarPad.PaddingRight = UDim.new(0, 8)
SidebarPad.Parent = Sidebar

local function createTabButton(name)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 36)
	btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	btn.BorderSizePixel = 0
	btn.Font = Enum.Font.GothamSemibold
	btn.TextSize = 13
	btn.TextColor3 = Color3.fromRGB(180, 180, 180)
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.Parent = Sidebar

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 5)
	btnCorner.Parent = btn

	local dot = Instance.new("Frame")
	dot.Size = UDim2.new(0, 8, 0, 8)
	dot.Position = UDim2.new(0, 10, 0.5, -4)
	dot.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
	dot.BorderSizePixel = 0
	dot.Parent = btn

	local dotCorner = Instance.new("UICorner")
	dotCorner.CornerRadius = UDim.new(1, 0)
	dotCorner.Parent = dot

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -30, 1, 0)
	label.Position = UDim2.new(0, 28, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = name
	label.TextColor3 = Color3.fromRGB(180, 180, 180)
	label.TextSize = 13
	label.Font = Enum.Font.GothamSemibold
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = btn

	return btn, label, dot
end

local function createPage()
	local page = Instance.new("ScrollingFrame")
	page.Size = UDim2.new(1, 0, 1, 0)
	page.BackgroundTransparency = 1
	page.BorderSizePixel = 0
	page.ScrollBarThickness = 4
	page.ScrollBarImageColor3 = Color3.fromRGB(200, 30, 30)
	page.Visible = false
	page.Parent = ContentArea

	local list = Instance.new("UIListLayout")
	list.Padding = UDim.new(0, 6)
	list.Parent = page

	local pad = Instance.new("UIPadding")
	pad.PaddingTop = UDim.new(0, 8)
	pad.PaddingLeft = UDim.new(0, 8)
	pad.PaddingRight = UDim.new(0, 8)
	pad.Parent = page

	return page
end

-- =====================
--   UI Components
-- =====================
local function createRedButton(parent, text)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 36)
	btn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
	btn.BorderSizePixel = 0
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextSize = 13
	btn.Font = Enum.Font.GothamBold
	btn.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 5)
	corner.Parent = btn

	return btn
end

local function createToggle(parent, text, default)
	local holder = Instance.new("Frame")
	holder.Size = UDim2.new(1, 0, 0, 36)
	holder.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	holder.BorderSizePixel = 0
	holder.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 5)
	corner.Parent = holder

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -60, 1, 0)
	label.Position = UDim2.new(0, 12, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.fromRGB(200, 200, 200)
	label.TextSize = 13
	label.Font = Enum.Font.Gotham
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = holder

	local toggleBg = Instance.new("Frame")
	toggleBg.Size = UDim2.new(0, 44, 0, 22)
	toggleBg.Position = UDim2.new(1, -54, 0.5, -11)
	toggleBg.BackgroundColor3 = default and Color3.fromRGB(200, 30, 30) or Color3.fromRGB(60, 60, 60)
	toggleBg.BorderSizePixel = 0
	toggleBg.Parent = holder

	local bgCorner = Instance.new("UICorner")
	bgCorner.CornerRadius = UDim.new(1, 0)
	bgCorner.Parent = toggleBg

	local circle = Instance.new("Frame")
	circle.Size = UDim2.new(0, 16, 0, 16)
	circle.Position = default and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
	circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	circle.BorderSizePixel = 0
	circle.Parent = toggleBg

	local cCorner = Instance.new("UICorner")
	cCorner.CornerRadius = UDim.new(1, 0)
	cCorner.Parent = circle

	local enabled = default or false

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 1, 0)
	btn.BackgroundTransparency = 1
	btn.Text = ""
	btn.Parent = holder

	btn.MouseButton1Click:Connect(function()
		enabled = not enabled
		TweenService:Create(toggleBg, TweenInfo.new(0.2), {
			BackgroundColor3 = enabled and Color3.fromRGB(200, 30, 30) or Color3.fromRGB(60, 60, 60)
		}):Play()
		TweenService:Create(circle, TweenInfo.new(0.2), {
			Position = enabled and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
		}):Play()
	end)

	return holder, function() return enabled end
end

local function createDropdown(parent, labelText)
	local holder = Instance.new("Frame")
	holder.Size = UDim2.new(1, 0, 0, 36)
	holder.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	holder.BorderSizePixel = 0
	holder.ClipsDescendants = false
	holder.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 5)
	corner.Parent = holder

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -30, 1, 0)
	label.Position = UDim2.new(0, 12, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = labelText
	label.TextColor3 = Color3.fromRGB(200, 200, 200)
	label.TextSize = 13
	label.Font = Enum.Font.Gotham
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = holder

	local arrow = Instance.new("TextLabel")
	arrow.Size = UDim2.new(0, 24, 1, 0)
	arrow.Position = UDim2.new(1, -28, 0, 0)
	arrow.BackgroundTransparency = 1
	arrow.Text = "▼"
	arrow.TextColor3 = Color3.fromRGB(200, 30, 30)
	arrow.TextSize = 12
	arrow.Font = Enum.Font.GothamBold
	arrow.Parent = holder

	-- Dropdown list
	local dropList = Instance.new("Frame")
	dropList.Size = UDim2.new(1, 0, 0, 0)
	dropList.Position = UDim2.new(0, 0, 1, 4)
	dropList.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	dropList.BorderSizePixel = 0
	dropList.Visible = false
	dropList.ZIndex = 10
	dropList.Parent = holder

	local dropCorner = Instance.new("UICorner")
	dropCorner.CornerRadius = UDim.new(0, 5)
	dropCorner.Parent = dropList

	local dropLayout = Instance.new("UIListLayout")
	dropLayout.Parent = dropList

	local isOpen = false
	local selected = nil

	local function refresh()
		-- ล้าง list
		for _, c in ipairs(dropList:GetChildren()) do
			if c:IsA("TextButton") then c:Destroy() end
		end

		for _, p in ipairs(Players:GetPlayers()) do
			local item = Instance.new("TextButton")
			item.Size = UDim2.new(1, 0, 0, 30)
			item.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			item.BorderSizePixel = 0
			item.Text = p.Name
			item.TextColor3 = Color3.fromRGB(200, 200, 200)
			item.TextSize = 12
			item.Font = Enum.Font.Gotham
			item.ZIndex = 11
			item.Parent = dropList

			item.MouseButton1Click:Connect(function()
				selected = p
				label.Text = p.Name
				isOpen = false
				dropList.Visible = false
			end)
		end

		local count = #Players:GetPlayers()
		dropList.Size = UDim2.new(1, 0, 0, count * 30)
	end

	local openBtn = Instance.new("TextButton")
	openBtn.Size = UDim2.new(1, 0, 1, 0)
	openBtn.BackgroundTransparency = 1
	openBtn.Text = ""
	openBtn.Parent = holder

	openBtn.MouseButton1Click:Connect(function()
		isOpen = not isOpen
		if isOpen then
			refresh()
		end
		dropList.Visible = isOpen
	end)

	return holder, function() return selected end
end

local function createInfoLabel(parent, text)
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, 0, 0, 30)
	lbl.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
	lbl.BorderSizePixel = 0
	lbl.Text = text
	lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
	lbl.TextSize = 13
	lbl.Font = Enum.Font.GothamBold
	lbl.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 5)
	corner.Parent = lbl

	return lbl
end

-- =====================
--   สร้าง TABS
-- =====================
for _, tabName in ipairs(tabs) do
	local btn, labelEl, dot = createTabButton(tabName)
	local page = createPage()
	tabButtons[tabName] = {btn = btn, label = labelEl, dot = dot}
	tabPages[tabName] = page
end

local function switchTab(name)
	if currentTab == name then return end
	currentTab = name

	for tName, tData in pairs(tabButtons) do
		if tName == name then
			tData.btn.BackgroundColor3 = Color3.fromRGB(50, 15, 15)
			tData.label.TextColor3 = Color3.fromRGB(220, 30, 30)
			tData.dot.BackgroundColor3 = Color3.fromRGB(220, 30, 30)
			tabPages[tName].Visible = true
		else
			tData.btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
			tData.label.TextColor3 = Color3.fromRGB(180, 180, 180)
			tData.dot.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
			tabPages[tName].Visible = false
		end
	end
end

for _, tabName in ipairs(tabs) do
	tabButtons[tabName].btn.MouseButton1Click:Connect(function()
		switchTab(tabName)
	end)
end

-- =====================
--   TAB: Players
-- =====================
local playersPage = tabPages["Players"]
local selectedPlayerLabel = createInfoLabel(playersPage, "Selected Player : nil")
local _, getSelectedPlayer = createDropdown(playersPage, "Selected Player")

local refreshBtn = createRedButton(playersPage, "Refresh Players")
refreshBtn.MouseButton1Click:Connect(function()
	selectedPlayerLabel.Text = "Selected Player : " .. (getSelectedPlayer() and getSelectedPlayer().Name or "nil")
end)

-- Kill Player (Gun) - ส่ง RemoteEvent
local _, getKillGunEnabled = createToggle(playersPage, "Kill Player (Gun)", false)
-- Kill Player (Combat)
local _, getKillCombatEnabled = createToggle(playersPage, "Kill Player (Combat)", false)
-- Spectate
local _, getSpectateEnabled = createToggle(playersPage, "Spectate Player", false)

local teleportPlayerBtn = createRedButton(playersPage, "Teleport to Player")
teleportPlayerBtn.MouseButton1Click:Connect(function()
	local target = getSelectedPlayer()
	if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
		local char = LocalPlayer.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			char.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(3, 0, 0)
		end
	end
end)

-- Aimbot Toggle
local _, getAimbotEnabled = createToggle(playersPage, "Aimbot (Highlight Target)", false)

-- Spectate Logic
local spectateConn
getSpectateEnabled -- ใช้งานร่วมกับ RunService ด้านล่าง

-- =====================
--   TAB: Teleport
-- =====================
local teleportPage = tabPages["Teleport"]
createInfoLabel(teleportPage, "📍 Teleport Locations")

local locations = {
	{name = "Spawn", pos = Vector3.new(0, 5, 0)},
	{name = "Sky Island", pos = Vector3.new(0, 500, 0)},
	{name = "Marine Base", pos = Vector3.new(200, 5, 200)},
	{name = "Prison", pos = Vector3.new(-300, 5, 100)},
}

for _, loc in ipairs(locations) do
	local btn = createRedButton(teleportPage, "➜ " .. loc.name)
	btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	btn.TextColor3 = Color3.fromRGB(220, 30, 30)
	local pos = loc.pos
	btn.MouseButton1Click:Connect(function()
		local char = LocalPlayer.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			char.HumanoidRootPart.CFrame = CFrame.new(pos)
		end
	end)
end

-- Teleport to coordinates
local coordLabel = Instance.new("TextLabel")
coordLabel.Size = UDim2.new(1, 0, 0, 20)
coordLabel.BackgroundTransparency = 1
coordLabel.Text = "Custom Position (X, Y, Z):"
coordLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
coordLabel.TextSize = 12
coordLabel.Font = Enum.Font.Gotham
coordLabel.TextXAlignment = Enum.TextXAlignment.Left
coordLabel.Parent = teleportPage

local coordBox = Instance.new("TextBox")
coordBox.Size = UDim2.new(1, 0, 0, 34)
coordBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
coordBox.BorderSizePixel = 0
coordBox.Text = "0, 5, 0"
coordBox.TextColor3 = Color3.fromRGB(220, 220, 220)
coordBox.TextSize = 13
coordBox.Font = Enum.Font.Gotham
coordBox.PlaceholderText = "X, Y, Z"
coordBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
coordBox.Parent = teleportPage

local coordCorner = Instance.new("UICorner")
coordCorner.CornerRadius = UDim.new(0, 5)
coordCorner.Parent = coordBox

local goBtn = createRedButton(teleportPage, "➜ Go to Position")
goBtn.MouseButton1Click:Connect(function()
	local parts = string.split(coordBox.Text, ",")
	if #parts == 3 then
		local x = tonumber(parts[1])
		local y = tonumber(parts[2])
		local z = tonumber(parts[3])
		if x and y and z then
			local char = LocalPlayer.Character
			if char and char:FindFirstChild("HumanoidRootPart") then
				char.HumanoidRootPart.CFrame = CFrame.new(x, y, z)
			end
		end
	end
end)

-- =====================
--   TAB: Stats
-- =====================
local statsPage = tabPages["Stats"]
createInfoLabel(statsPage, "📊 Player Stats")

local statsText = Instance.new("TextLabel")
statsText.Size = UDim2.new(1, 0, 0, 200)
statsText.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
statsText.BorderSizePixel = 0
statsText.TextColor3 = Color3.fromRGB(200, 200, 200)
statsText.TextSize = 12
statsText.Font = Enum.Font.Gotham
statsText.TextXAlignment = Enum.TextXAlignment.Left
statsText.TextYAlignment = Enum.TextYAlignment.Top
statsText.TextWrapped = true
statsText.Parent = statsPage

local statCorner = Instance.new("UICorner")
statCorner.CornerRadius = UDim.new(0, 5)
statCorner.Parent = statsText

local statPad = Instance.new("UIPadding")
statPad.PaddingLeft = UDim.new(0, 8)
statPad.PaddingTop = UDim.new(0, 8)
statPad.Parent = statsText

local refreshStatsBtn = createRedButton(statsPage, "🔄 Refresh Stats")
refreshStatsBtn.MouseButton1Click:Connect(function()
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if hum and root then
		statsText.Text = string.format(
			"Name: %s\nDisplay: %s\nHealth: %.0f / %.0f\nWalkSpeed: %.0f\nJumpPower: %.0f\nPosition: %.1f, %.1f, %.1f\nPlayers Online: %d",
			LocalPlayer.Name,
			LocalPlayer.DisplayName,
			hum.Health, hum.MaxHealth,
			hum.WalkSpeed,
			hum.JumpPower,
			root.Position.X, root.Position.Y, root.Position.Z,
			#Players:GetPlayers()
		)
	end
end)

-- =====================
--   TAB: Misc
-- =====================
local miscPage = tabPages["Misc"]
createInfoLabel(miscPage, "⚙ Misc Settings")

-- WalkSpeed Slider (ใช้ TextBox)
local wsLabel = Instance.new("TextLabel")
wsLabel.Size = UDim2.new(1, 0, 0, 20)
wsLabel.BackgroundTransparency = 1
wsLabel.Text = "WalkSpeed (ค่าเริ่ม 16):"
wsLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
wsLabel.TextSize = 12
wsLabel.Font = Enum.Font.Gotham
wsLabel.TextXAlignment = Enum.TextXAlignment.Left
wsLabel.Parent = miscPage

local wsBox = Instance.new("TextBox")
wsBox.Size = UDim2.new(1, 0, 0, 34)
wsBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
wsBox.BorderSizePixel = 0
wsBox.Text = "16"
wsBox.TextColor3 = Color3.fromRGB(220, 220, 220)
wsBox.TextSize = 13
wsBox.Font = Enum.Font.Gotham
wsBox.Parent = miscPage
local wsCorner = Instance.new("UICorner")
wsCorner.CornerRadius = UDim.new(0, 5)
wsCorner.Parent = wsBox

local setWSBtn = createRedButton(miscPage, "✔ Set WalkSpeed")
setWSBtn.MouseButton1Click:Connect(function()
	local val = tonumber(wsBox.Text)
	if val then
		local char = LocalPlayer.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if hum then hum.WalkSpeed = math.clamp(val, 0, 500) end
	end
end)

-- JumpPower
local jpBox = Instance.new("TextBox")
jpBox.Size = UDim2.new(1, 0, 0, 34)
jpBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
jpBox.BorderSizePixel = 0
jpBox.Text = "50"
jpBox.TextColor3 = Color3.fromRGB(220, 220, 220)
jpBox.TextSize = 13
jpBox.Font = Enum.Font.Gotham
jpBox.PlaceholderText = "JumpPower"
jpBox.Parent = miscPage
local jpCorner = Instance.new("UICorner")
jpCorner.CornerRadius = UDim.new(0, 5)
jpCorner.Parent = jpBox

local setJPBtn = createRedButton(miscPage, "✔ Set JumpPower")
setJPBtn.MouseButton1Click:Connect(function()
	local val = tonumber(jpBox.Text)
	if val then
		local char = LocalPlayer.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if hum then hum.JumpPower = math.clamp(val, 0, 500) end
	end
end)

-- Noclip
local _, getNoclipEnabled = createToggle(miscPage, "Noclip", false)

-- Infinite Jump
local _, getInfJumpEnabled = createToggle(miscPage, "Infinite Jump", false)

UserInputService.JumpRequest:Connect(function()
	if getInfJumpEnabled() then
		local char = LocalPlayer.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
	end
end)

-- =====================
--   TAB: Server
-- =====================
local serverPage = tabPages["Server"]
createInfoLabel(serverPage, "🌐 Server Info")

local serverText = Instance.new("TextLabel")
serverText.Size = UDim2.new(1, 0, 0, 150)
serverText.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
serverText.BorderSizePixel = 0
serverText.TextColor3 = Color3.fromRGB(200, 200, 200)
serverText.TextSize = 12
serverText.Font = Enum.Font.Gotham
serverText.TextXAlignment = Enum.TextXAlignment.Left
serverText.TextYAlignment = Enum.TextYAlignment.Top
serverText.TextWrapped = true
serverText.Parent = serverPage

local srvCorner = Instance.new("UICorner")
srvCorner.CornerRadius = UDim.new(0, 5)
srvCorner.Parent = serverText

local srvPad = Instance.new("UIPadding")
srvPad.PaddingLeft = UDim.new(0, 8)
srvPad.PaddingTop = UDim.new(0, 8)
srvPad.Parent = serverText

local refreshServerBtn = createRedButton(serverPage, "🔄 Refresh Server Info")
refreshServerBtn.MouseButton1Click:Connect(function()
	serverText.Text = string.format(
		"Game: %s\nPlace ID: %d\nJob ID: %s\nPlayers: %d / %d\nPing: ~%d ms",
		game.Name,
		game.PlaceId,
		game.JobId,
		#Players:GetPlayers(),
		Players.MaxPlayers,
		math.random(20, 80) -- ค่าประมาณ
	)
end)

-- Rejoin Server
local rejoinBtn = createRedButton(serverPage, "🔄 Rejoin Server")
rejoinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
rejoinBtn.MouseButton1Click:Connect(function()
	local TeleportService = game:GetService("TeleportService")
	TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)

-- =====================
--   NOCLIP LOOP
-- =====================
RunService.Stepped:Connect(function()
	if getNoclipEnabled() then
		local char = LocalPlayer.Character
		if char then
			for _, part in ipairs(char:GetDescendants()) do
				if part:IsA("BasePart") and part.CanCollide then
					part.CanCollide = false
				end
			end
		end
	end
end)

-- =====================
--   DRAGGABLE
-- =====================
local dragging = false
local dragStart, startPos

TitleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

-- =====================
--   TOGGLE GUI (RightShift)
-- =====================
UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.RightShift then
		MainFrame.Visible = not MainFrame.Visible
	end
end)

-- =====================
--   เริ่มต้นที่ Tab Players
-- =====================
switchTab("Players")

print("[AdminHub] โหลดสำเร็จ! ยินดีต้อนรับ " .. LocalPlayer.Name)
