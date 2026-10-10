local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

local Configs = ReplicatedStorage.Shared.Configs
local Config = require(ReplicatedStorage.Shared.Configs.Config)
local AnimationConfigs = require(Configs.AnimationConfigs)

local Camera = require(LocalPlayer.PlayerScripts.Client.Camera)

local R6_Animation_IDs = AnimationConfigs.R6_Animations
local R15_Animation_IDs = AnimationConfigs.R15_Animations

local CharacterController = {}
CharacterController.__index = CharacterController

local MovementStates = {
    "Crouching",
    "Walking",
    "Running",
}

local StateTable = {
    Jumping = Enum.HumanoidStateType.Jumping,
    Swimming = Enum.HumanoidStateType.Swimming,
    Falling = Enum.HumanoidStateType.Freefall,
}

function CharacterController.new()
    local self = {
        Character = nil,
        Humanoid = nil,
        Animator = nil,

        CurrentAnimation = nil,
        Animations = {},

        State = "Idle",

        Health = 100,
        WalkSpeed = 10,
        JumpHeight = 7.2,

    }

    setmetatable(self, CharacterController)

    RunService.RenderStepped:Connect(function(DeltaTime)
        self:Update()
    end)

    UserInputService.InputBegan:Connect(function(Input, GPE)
        if Input.KeyCode == Enum.KeyCode.LeftShift then
            self:Change_State("Running")
    
        elseif Input.KeyCode == Enum.KeyCode.LeftControl then
           self:Change_State("Crouching")
        end
    end)
    
    UserInputService.InputEnded:Connect(function(Input, GPE)
        if Input.KeyCode == Enum.KeyCode.LeftShift then
            if self:Get_Humanoid().MoveDirection.Magnitude > 0 then
                print("state should be walking")
                self:Change_State("Walking")
            else
                print("state should be idle")
                self:Change_State("Idle")
            end
    
        elseif Input.KeyCode == Enum.KeyCode.LeftControl then
            if (self:Get_Humanoid().MoveDirection.Magnitude) > 0 then
                self:Change_State("Walking")
            else
                self:Change_State("Idle")
            end
        end
    end)

    return self
end

function CharacterController:Change_Character()
    print(LocalPlayer.Character)
    self.Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    self.Humanoid = self.Character:WaitForChild("Humanoid", 30)
    self.Animator = self.Humanoid:WaitForChild("Animator")

    if self.Humanoid.RigType == Enum.HumanoidRigType.R6 then
        for index, AnimationId in R6_Animation_IDs do 
            local AnimationInstance = Instance.new("Animation")
            AnimationInstance.AnimationId = "rbxassetid://"..tostring(AnimationId)
            local AnimationTrack = self.Animator:LoadAnimation(AnimationInstance)
            self.Animations[index] = AnimationTrack 
        end

    elseif self.Humanoid.RigType == Enum.HumanoidRigType.R15 then
        for index, AnimationId in R15_Animation_IDs do
            print(index)
            local AnimationInstance = Instance.new("Animation")
            AnimationInstance.AnimationId = "rbxassetid://"..tostring(AnimationId)
            local AnimationTrack = self.Animator:LoadAnimation(AnimationInstance)
            self.Animations[index] = AnimationTrack 
        end
    end

    self:Update_Walkspeed()
end

function CharacterController:Change_State(NewState)
    if not (table.find(MovementStates, NewState)) then
        return
    end

    self.State = NewState

    if NewState == "Crouching" then
        self.WalkSpeed = 9 -- have configs that change ws depending on shifter/nnonshfiter
        Camera:UpdateFOV(70)
        
    elseif NewState == "Walking" then
        self.WalkSpeed = 12
        Camera:UpdateFOV(70)

    elseif NewState == "Running" then
        self.WalkSpeed = 26
        Camera:UpdateFOV(80)
    end

    self:Update_Walkspeed()
end

function CharacterController:Change_Animation(Key)
    if self.CurrentAnimation ~= nil and self.CurrentAnimation ~= self.Animations[Key] then
        self.CurrentAnimation:Stop()
    end

    self.CurrentAnimation = self.Animations[Key]

    if self.CurrentAnimation == nil or self.CurrentAnimation.IsPlaying == true then
        return
    end

    self.CurrentAnimation:Play(Config.Animation_Fade_Time)
end

function CharacterController:Update_Walkspeed()
    print(self.WalkSpeed)
    LocalPlayer.Character.Humanoid.WalkSpeed = self.WalkSpeed
end

function CharacterController:Get_Character()
    return self.Character -- self.character this what it should be but the self.character isnt set properly for soe reason
end

function CharacterController:Get_Humanoid()
    return self.Humanoid
end

function CharacterController:Get_Running_Value()
    return self.State == "Running"
end

function CharacterController:Get_Walking_Value()
    return self.State == "Walking"
end

function CharacterController:Get_Crouching_Value()
    return self.State == "Crouching"
end

function CharacterController:Update()
    local Humanoid = self:Get_Humanoid()
    local MoveDirection = Humanoid.MoveDirection
    local State_Animation = "idle"

    if (MoveDirection.Magnitude) == 0 then
        self:Change_State("Idle")
        State_Animation = "idle"
    end

    if MoveDirection.Magnitude > 0 then
        if not self:Get_Running_Value() and not self:Get_Crouching_Value() then
            State_Animation = "walk"
        end

        if self:Get_Running_Value() == true and not self:Get_Crouching_Value() then
            --print("should be running")
            State_Animation = "run"
        elseif self:Get_Crouching_Value() == true and not self:Get_Running_Value() then
            --print("should be crouching")
            State_Animation = "crouch"
        end
    end

    if Humanoid.FloorMaterial == Enum.Material.Air or Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
        State_Animation = "fall"
    end

    self:Change_Animation(State_Animation)
end

return CharacterController.new()