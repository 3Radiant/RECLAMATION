local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage.Shared
local Shifter = Shared.Shifter
local ShifterBase = require(Shifter.ShifterBase)

local Events = ReplicatedStorage.Events
local ShiftTest = Events.ShiftTest

UserInputService.InputBegan:Connect(function(Input, GPE)
    if GPE then
        return
    end

    if Input.KeyCode == Enum.KeyCode.P then
        local player = game.Players.LocalPlayer --make betetr when u come back to 
        local AnimationController = require(ReplicatedStorage.Shared.AnimationHandler)
        local Anim = AnimationController:PlayAnimation(player.Character, game.ReplicatedStorage.Animations.R6.BiteHand.AnimationId)

        task.wait(Anim.Length - 0.05)

        ShiftTest:FireServer(player)
        local CharacterController = require(ReplicatedStorage.Shared.CharacterController)
        CharacterController:Change_Character()
    end
end)