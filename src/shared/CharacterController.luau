local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

local Configs = ReplicatedStorage.Shared.Configs
local Config = require(ReplicatedStorage.Shared.Configs.Config)
local AnimationConfigs = require(Configs.AnimationConfigs)

local R6_Animation_IDs = AnimationConfigs.R6_Animations
local R15_Animation_IDs = AnimationConfigs.R15_Animations

local CharacterController = {}
CharacterController.__index = CharacterController

local MovementStates = {
    "Crouching",
    "Walking",
    "Sprinting",
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
        WalkSpeed = 16,
        JumpHeight = 7.2,

    }

    setmetatable(self, CharacterController)

    RunService.RenderStepped:Connect(function(DeltaTime)
        self:Update()
    end)

    return self
end

function CharacterController:Change_Character()
    print(LocalPlayer.Character)
    self.Character = LocalPlayer.Character
    self.Humanoid = self.Character:WaitForChild("Humanoid")
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
        self.WalkSpeed = 8 -- have configs that change ws depending on shifter/nnonshfiter
        
    elseif NewState == "Walking" then
        self.WalkSpeed = 16

    elseif NewState == "Running" then
        self.WalkSpeed = 30

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
    self.Humanoid.WalkSpeed = self.WalkSpeed
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

    if (MoveDirection.Magnitude) == 0 then
        self:Change_State("Idle")
        self:Change_Animation("idle")
    end

    if MoveDirection.Magnitude > 0 then
        self:Change_Animation("walk")
    end
end

UserInputService.InputBegan:Connect(function(Input, GPE)
    if Input.KeyCode == Enum.KeyCode.LeftShift then
        print("shift being poressed")
        CharacterController:Change_State("Running")
        print("state SHOULD be changed")
    --elseif Input.KeyCode == Enum.KeyCode.LeftControl then
       -- CharacterController:Change_State("Crouching")
    end
end)

return CharacterController.new()