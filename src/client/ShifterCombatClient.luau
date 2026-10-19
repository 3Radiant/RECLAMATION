local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Configs = ReplicatedStorage.Shared.Configs
local Config = require(Configs.Config)
local AnimationConfigs = require(Configs.AnimationConfigs)

local ShifterFolder = ReplicatedStorage.Shifter
local ShifterBase = require(ShifterFolder.ShifterBase)

local Hitbox = require(ReplicatedStorage.Shared.Hitbox)
local CharacterController = require(ReplicatedStorage.Shared.CharacterController)

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
    CharacterController:PlayAnimation()
end

return ShifterCombatClient