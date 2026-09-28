local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage.Shared
local Shifter = Shared.Shifter
local ShifterBase = require(Shifter.ShifterBase)

local Events = ReplicatedStorage.Events
local ShiftTest = Events.ShiftTest

ShiftTest.OnServerEvent:Connect(function(player)
    ShifterBase:Inherit(player)
    ShifterBase.Model = game.ServerStorage.Titans.ArmoredTitan

    local Shifted = ShifterBase.Shifted
    
    if Shifted == false then
        ShifterBase:Shift(player)
    else
        ShifterBase:Deshift(player)
    end
end)