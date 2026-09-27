local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage.Shared
local Shifter = Shared.Shifter
local ShifterBase = require(Shifter.ShifterBase)

local Events = ReplicatedStorage.Events
local ShiftTest = Events.ShiftTest

ShiftTest.OnServerEvent:Connect(function(player)
    local currentshifter = ShifterBase.new()
    currentshifter:Inherit(player)
    currentshifter.Model = game.ServerStorage.Titans.ArmoredTitan

    currentshifter:Shift(player)
end)