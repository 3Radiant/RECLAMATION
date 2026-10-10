local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage.Shared
local Shifter = Shared.Shifter
local ShifterBase = require(Shifter.ShifterBase)

local CharacterController = require(ReplicatedStorage.Shared.CharacterController)

local Events = ReplicatedStorage.Events
local ShiftTest = Events.ShiftTest

UserInputService.InputBegan:Connect(function(Input, GPE)
    if GPE then
        return
    end

    if Input.KeyCode == Enum.KeyCode.P then
        local player = game.Players.LocalPlayer --make betetr when u come back to 
        
        CharacterController:Change_Animation("bitehand")

        task.wait(CharacterController.Animations.bitehand.Length - 0.05)

        ShiftTest:FireServer(player)
        CharacterController:Change_Character()
    end
end)

ShiftTest.OnClientEvent:Connect(function()
    CharacterController:Change_Character()
end)