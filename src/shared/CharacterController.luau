local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local AnimationHandler = require(ReplicatedStorage.Shared.AnimationHandler)

local CharacterController = {}
CharacterController.__index = CharacterController


local MovementStates = {
    "Crouching",
    "Walking",
    "Sprinting",
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
    LocalPlayer.Character = self.Character
    self.Humanoid = self.Character:WaitForChild("Humanoid")
    self.Animator = self.Humanoid:WaitForChild("Animator")
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

function CharacterController:Get_State()
    return self.State
end




