-- EFEITO GLOBAL DE GELO
-- Roblox Studio | Script de servidor

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local SoundService = game:GetService("SoundService")

local VELOCIDADE = 50
local TEXTURA = "rbxassetid://7447690378"
local AUDIO = "rbxassetid://74464434454195"

-- SKYBOX
local sky = Instance.new("Sky")
sky.SkyboxBk = TEXTURA
sky.SkyboxDn = TEXTURA
sky.SkyboxFt = TEXTURA
sky.SkyboxLf = TEXTURA
sky.SkyboxRt = TEXTURA
sky.SkyboxUp = TEXTURA
sky.Parent = Lighting

-- ÁUDIO GLOBAL
local sound = Instance.new("Sound")
sound.SoundId = AUDIO
sound.Looped = true
sound.Volume = 1
sound.Parent = SoundService
sound:Play()

-- VELOCIDADE DOS JOGADORES
local function configurarJogador(player)
    local function personagem(character)
        local humanoid = character:WaitForChild("Humanoid")

        humanoid.WalkSpeed = VELOCIDADE

        -- Partículas
        local attachment = Instance.new("Attachment")
        attachment.Parent = character:WaitForChild("HumanoidRootPart")

        local particles = Instance.new("ParticleEmitter")
        particles.Texture = TEXTURA
        particles.Rate = 15
        particles.Lifetime = NumberRange.new(1, 2)
        particles.Speed = NumberRange.new(1, 3)
        particles.Parent = attachment
    end

    player.CharacterAdded:Connect(personagem)

    if player.Character then
        personagem(player.Character)
    end
end

Players.PlayerAdded:Connect(configurarJogador)

for _, player in ipairs(Players:GetPlayers()) do
    configurarJogador(player)
end

-- NPCS
local function configurarNPC(model)
    if not model:IsA("Model") then return end
    if Players:GetPlayerFromCharacter(model) then return end

    local humanoid = model:FindFirstChildOfClass("Humanoid")
    local root = model:FindFirstChild("HumanoidRootPart")

    if humanoid and root then
        local attachment = Instance.new("Attachment")
        attachment.Parent = root

        local particles = Instance.new("ParticleEmitter")
        particles.Texture = TEXTURA
        particles.Rate = 15
        particles.Parent = attachment
    end
end

-- GELO NO WORKSPACE
for _, object in ipairs(Workspace:GetDescendants()) do
    if object:IsA("BasePart") then
        local character = object:FindFirstAncestorOfClass("Model")

        if not character or not character:FindFirstChildOfClass("Humanoid") then
            object.Material = Enum.Material.Ice
            object.CustomPhysicalProperties =
                PhysicalProperties.new(0.7, 0.01, 0.1)

            for _, face in ipairs(Enum.NormalId:GetEnumItems()) do
                local texture = Instance.new("Texture")
                texture.Texture = TEXTURA
                texture.Face = face
                texture.Parent = object
            end
        end
    end
end

-- NPCS EXISTENTES
for _, object in ipairs(Workspace:GetDescendants()) do
    if object:IsA("Model") then
        configurarNPC(object)
    end
end

-- NPCS NOVOS
Workspace.DescendantAdded:Connect(function(object)
    if object:IsA("Model") then
        task.wait(0.5)
        configurarNPC(object)
    end
end)

print("Efeito global de gelo ativado!")
