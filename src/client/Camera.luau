local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Config = require(ReplicatedStorage.Shared.Configs.Config)

local Player = Players.LocalPlayer

local CurrentCamera = game.Workspace.CurrentCamera

local Camera = {}
Camera.__index = Camera

function Camera.new()
    local self = {
        CFrame = CFrame.new(),
        MinimumZoomDistance = Config.MinimumZoomDistance,
        MaximumZoomDistance = Config.MaximumZoomDistance,
        Zoom = Vector3.new(0,0,5),
        HeadOffset = Vector3.new(0,1.5,0),
        FieldOfView = 70,

    }

    local CurrentX, CurrentY, CurrentZ = self.CFrame:ToOrientation()
    CurrentY = math.clamp(CurrentY, -90, 90)

    UserInputService.InputChanged:Connect(function(Input, GPE)
        if GPE == true then
            return
        end

        if Input.UserInputType == Enum.UserInputType.MouseWheel then
            local NewZoom = math.clamp((self.Zoom.Z - Input.Position.Z), self.MinimumZoomDistance, self.MaximumZoomDistance)
            self.Zoom = Vector3.new(0, 0, NewZoom)
        end
    end)

    function Camera:SetMouseEnabled(Enabled)
        if Enabled == true then
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
        elseif Enabled == false then
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        else
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        end
    end 

    function Camera:UpdateOffset(NewOffset)
        self.HeadOffset = NewOffset
    end

    function Camera:UpdateZooms(MinZoom, MaxZoom)
        self.MinimumZoomDistance = MinZoom
        self.MaximumZoomDistance = MaxZoom
    end

    function Camera:UpdateCFrame()
        local Character = Player.Character
        if Character == nil then
            return
        end

        local PrimaryPartPosition = Character.PrimaryPart.Position
        print(Character, Character.PrimaryPart)    
        local MouseDelta = UserInputService:GetMouseDelta() * 0.01
        local PreviousCFrame = self.CFrame

        local CurrentX, CurrentY, CurrentZ = self.CFrame:ToOrientation()

        local NewX = math.clamp((CurrentX - MouseDelta.Y), math.rad(-85), math.rad(85))
        local NewY = CurrentY - MouseDelta.X

        local Rotation = CFrame.fromOrientation(NewX, NewY, 0)

        self.CFrame = Rotation * CFrame.new(self.Zoom) + self.HeadOffset + PrimaryPartPosition
        CurrentCamera.CFrame = self.CFrame
    end 

    function Camera:UpdateFOV(NewFov)
        self.FieldOfView = NewFov
    end
    
    function Camera:Update()
        self:UpdateCFrame()
    end

    RunService.RenderStepped:Connect(function(deltatime)
        self:Update()
    end)

    setmetatable(self, Camera)

    return self
end

return Camera.new()