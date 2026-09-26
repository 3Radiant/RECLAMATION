local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

local CurrentCamera = game.Workspace.CurrentCamera

local Camera = {}
Camera.__index = Camera

function Camera.new()
    local self = {
        CFrame = CFrame.new(),
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
            local NewZoom = math.clamp((self.Zoom.Z - Input.Position.Z), 3, 80)
            self.Zoom = Vector3.new(0, 0, NewZoom)
        end
    end)

    function Camera:UpdateCFrame()
        local HumanoidRootPartPosition = Character:WaitForChild("HumanoidRootPart").Position
        local MouseDelta = UserInputService:GetMouseDelta() * 0.01
        local PreviousCFrame = self.CFrame

        local CurrentX, CurrentY, CurrentZ = self.CFrame:ToOrientation()

        local NewX = math.clamp((CurrentX - MouseDelta.Y), math.rad(-85), math.rad(85))
        local NewY = CurrentY - MouseDelta.X

        local Rotation = CFrame.fromOrientation(NewX, NewY, 0)

        self.CFrame = Rotation * CFrame.new(self.Zoom) + self.HeadOffset + HumanoidRootPartPosition
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