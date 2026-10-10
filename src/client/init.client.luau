local camera = require(script.Camera)
local CharacterController = require(game.ReplicatedStorage.Shared.CharacterController)

local LocalPlayer = game.Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

CharacterController:Change_Character()