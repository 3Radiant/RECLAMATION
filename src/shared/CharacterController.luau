local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

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

        State = nil,

        Health = 100,
        WalkSpeed = 16,
        JumpHeight = 7.2,

    }

    setmetatable(self, CharacterController)
    return self
end

function CharacterController:Update_Character()
    LocalPlayer.Character = self.Character
end

function CharacterController:Update_Walkspeed()
    LocalPlayer.Character.WalkSpeed = self.WalkSpeed
end

function CharacterController:Change_state(NewState)
    if not (table.find(MovementStates, NewState)) then
        return
    end

    if NewState == "Crouching" then
        self.WalkSpeed = 8
        
        self:Update_WalkSpeed()
    elseif NewState == "Walking" then
        self.WalkSpeed = 16

        self:Update_WalkSpeed()
    elseif NewState == "Running" then
        self.WalkSpeed = 30

        self:Update_WalkSpeed()
    end
end





