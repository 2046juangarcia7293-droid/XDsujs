local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local function createESP(part, text, color)
	if part:FindFirstChild("ESP") then return end

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "ESP"
	billboard.Adornee = part
	billboard.Size = UDim2.new(0, 200, 0, 50)
	billboard.AlwaysOnTop = true
	billboard.StudsOffset = Vector3.new(0, 3, 0)

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = color
	label.TextScaled = true
	label.Font = Enum.Font.SourceSansBold
	label.Parent = billboard

	billboard.Parent = part
end

-- ESP NOTEBOOKS
local function updateNotebooks()
	for _, notebook in pairs(CollectionService:GetTagged("Notebook")) do
		if notebook:Is
