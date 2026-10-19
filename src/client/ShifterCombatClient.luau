local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Configs = ReplicatedStorage.Shared.Configs
local Config = require(Configs.Config)
local AnimationConfigs = require(Configs.AnimationConfigs)

local ShifterFolder = ReplicatedStorage.Shifter
local ShifterBase = require(ShifterFolder.ShifterBase)

local Hitbox = require(ReplicatedStorage.Shared.Hitbox)
local CharacterController = require(ReplicatedStorage.Shared.CharacterController)

local Character = CharacterController:Get_Attribute("Character")

local ShifterCombatClient = {}
ShifterCombatClient.__index = ShifterCombatClient

function ShifterCombatClient.new()
    local self = {
        ShifterName = ShifterBase:GetModel().Name, -- will be used to require titan configs
        CurrentCombo = 1,
        LightDamage = 4
    }

    setmetatable(self, ShifterCombatClient)

    return self
end

function ShifterCombatClient:M1()
    CharacterController:PlayAnimation("LightAttack", 322323234232) -- replace with anim id
    
    local ShifterModelHeight = 30
    local ShifterModelWidth = 30 -- change to whatever bodyscale things r called
    local ShifterModelLength = 30

    local HitboxPart = Hitbox:CreateHitbox(Character.PrimaryPart, Vector3.new(ShifterModelLength, ShifterModelHeight, ShifterModelWidth), Character.PrimaryPart.CFrame * CFrame.new(ShifterModelWidth))
end

return ShifterCombatClient