--// SERVICIOS
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

--// CONFIGURACIÓN
local NOTEBOOK_NAME = "Notebook"
local BALDI_ROLE = "Baldi"

local NOTEBOOK_COLOR = Color3.fromRGB(0, 255, 0)
local BALDI_COLOR = Color3.fromRGB(255, 0, 0)

--// FUNCIONES UTILIDAD
local function createHighlight(parent, color)
	if parent:FindFirstChild("ESP_Highlight") then return end

	local h = Instance.new("Highlight")
	h.Name = "ESP_Highlight"
	h.Adornee = parent
	h.FillColor = color
	h.OutlineColor = Color3.new(1,1,1)
	h.FillTransparency = 0.4
	h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	h.Parent = parent
end

local function createBillboard(parent, text, color)
	if parent:FindFirstChild("ESP_Billboard") then return end

	local bb = Instance.new("BillboardGui")
	bb.Name = "ESP_Billboard"
	bb.Size = UDim2.fromScale(4, 1)
	bb.StudsOffset = Vector3.new(0, 3, 0)
	bb.AlwaysOnTop = true
	bb.Parent = parent

	local label = Instance.new("TextLabel")
	label.Size = UDim2.fromScale(1,1)
	label.BackgroundTransparency = 1
	label.TextScaled = true
	label.Font = Enum.Font.SourceSansBold
	label.TextColor3 = color
	label.TextStrokeTransparency = 0
	label.Text = text
	label.Parent = bb

	return label
end

--// NOTEBOOK ESP
local function setupNotebookESP(notebook)
	if not notebook:IsA("BasePart") then return end

	createHighlight(notebook, NOTEBOOK_COLOR)
	local label = createBillboard(notebook, "Notebook", NOTEBOOK_COLOR)

	RunService.RenderStepped:Connect(function()
		if notebook.Parent and label then
			local dist = (camera.CFrame.Position - notebook.Position).Magnitude
			label.Text = ("Notebook\n%.0f studs"):format(dist)
		end
	end)
end

-- Buscar notebooks existentes
for _, obj in ipairs(workspace:GetDescendants()) do
	if obj.Name == NOTEBOOK_NAME then
		setupNotebookESP(obj)
	end
end

-- Notebooks que aparezcan después
workspace.DescendantAdded:Connect(function(obj)
	if obj.Name == NOTEBOOK_NAME then
		task.wait(0.1)
		setupNotebookESP(obj)
	end
end)

--// BALDI ESP
local function setupBaldiESP(character)
	local hrp = character:WaitForChild("HumanoidRootPart", 5)
	if not hrp then return end

	createHighlight(character, BALDI_COLOR)
	local label = createBillboard(hrp, "BALDI", BALDI_COLOR)

	RunService.RenderStepped:Connect(function()
		if character.Parent and label then
			local dist = (camera.CFrame.Position - hrp.Position).Magnitude
			label.Text = ("BALDI\n%.0f studs"):format(dist)
		end
	end)
end

local function checkPlayer(plr)
	if plr == player then return end

	plr.CharacterAdded:Connect(function(char)
		task.wait(0.2)
		if plr:GetAttribute("Role") == BALDI_ROLE then
			setupBaldiESP(char)
		end
	end)

	if plr.Character and plr:GetAttribute("Role") == BALDI_ROLE then
		setupBaldiESP(plr.Character)
	end
end

-- Players existentes
for _, plr in ipairs(Players:GetPlayers()) do
	checkPlayer(plr)
end

-- Players nuevos
Players.PlayerAdded:Connect(checkPlayer)
