local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage.Events

local CameraEvent = Events.CameraEvent

local Camera = require(script.Parent.Camera)
local Config = require(ReplicatedStorage.Shared.Configs.Config)

CameraEvent.OnClientEvent:Connect(function(IsShifting)
    if IsShifting == true then
        Camera:UpdateOffset(Config.ShifterCameraOffset)
        Camera:UpdateZooms(Config.ShifterMinimumZoomDistance, Config.ShifterMaximumZoomDistance)
        Camera:SetMouseEnabled(true)
    else
        Camera:UpdateOffset(Config.NormalCameraOffset)
        Camera:UpdateZooms(Config.MinimumZoomDistance, Config.MaximumZoomDistance)
        Camera:SetMouseEnabled(false)
    end
end)