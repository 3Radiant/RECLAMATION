local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage.Events

local CameraEvent = Events.CameraEvent

local Camera = require(script.Parent.Camera)
local Config = require(ReplicatedStorage.Shared.Configs.Config)

CameraEvent.OnClientEvent:Connect(function()
    Camera:UpdateOffset(Config.ShifterCameraOffset)
    Camera:UpdateZooms(Config.ShifterMinimumZoomDistance, Config.ShifterMaximumZoomDistance)
    Camera:SetMouseEnabled(true)
end)