local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

local AnimationHandler = require(ReplicatedStorage.Shared.AnimationHandler)

local Animations = ReplicatedStorage.Animations
local R15_Animations = Animations.R15


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
        State = nil,

        Health = 100,
        WalkSpeed = 16,
        JumpHeight = 7.2,

    }

    setmetatable(self, CharacterController)
    return self
end

function CharacterController:Change_Character()
    self.Character = LocalPlayer.Character
    self.Humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
    self.Animator = LocalPlayer.Character.Humanoid:WaitForChild("Animator")
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

function CharacterController:Change_Animation(AnimationTrack)
    self.CurrentAnimation = AnimationTrack
end

function CharacterController:Update_Walkspeed()
    self.Humanoid.WalkSpeed = self.WalkSpeed
end

function CharacterController:Update_Animation()
    AnimationHandler:PlayAnimation(self.Character, self.CurrentAnimation.Animation.AnimationId)
end

function CharacterController:Get_Character()
    return LocalPlayer.Character -- self.character this what it should be but the self.character isnt set properly for soe reason
end

function CharacterController:Get_Humanoid()
    return LocalPlayer.Character.Humanoid
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

--User

RunService.RenderStepped:Connect(function(DeltaTime)
    print(CharacterController:Get_Humanoid())
    local Humanoid = CharacterController:Get_Humanoid()
    local MoveDirection = Humanoid.MoveDirection

    if (MoveDirection.Magnitude) <= 0 then
        AnimationHandler:PlayAnimation(CharacterController:Get_Character(), require(R15_Animations.IDs).idle)
        return
    end

    if MoveDirection.Magnitude > 0 then
        if CharacterController:Get_Walking_Value() == true then
            local anim = AnimationHandler:PlayAnimation(LocalPlayer.Character, require(R15_Animations.IDs).walk) -- FIGURE OTU WHY GET FUNCTONS WONT WORK OR R RETURNING NIL
            CharacterController:Change_Animation(anim)
        elseif CharacterController:Get_Running_Value() == true then
            local anim = AnimationHandler:PlayAnimation(LocalPlayer.Character, require(R15_Animations.IDs).run)
            CharacterController:Change_Animation(anim)
        elseif CharacterController:Get_Crouching_Value() == true then
            local anim = AnimationHandler:PlayAnimation(LocalPlayer.Character, require(R15_Animations.IDs).crouch)
            CharacterController:Change_Animation(anim)
        end
    end

    CharacterController:Update_Animation()
end)



return CharacterController.new()