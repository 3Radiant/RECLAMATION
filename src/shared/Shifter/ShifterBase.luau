local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ShifterBase = {}
ShifterBase.__index = ShifterBase

function ShifterBase.new()
    local self = {

        Inheritor = nil, -- will be player of titan
        Model = nil, -- will be titan model
        CurrentState = "Idle", --potentially change this to be a state table
        ShiftCount = 0,
        MaxShifts = 3,
        Shifted = false,

    }

    setmetatable(self, ShifterBase)

    return self
end

function ShifterBase:Inherit(Player)
    self.Inheritor = Player
end

function ShifterBase:Shift()
    if self.ShiftCount <= self.MaxShifts then
        self.ShiftCount = self.ShiftCount + 1
        self.Shifted = true
        self.State = "Idle"

        local TitanClone = self.Model:Clone()
        local InheritorCharacter = self.Inheritor.Character or self.Inheritor.CharacterAdded:Wait()

        InheritorCharacter.Parent = ReplicatedStorage
        TitanClone.Parent = game.Workspace
        TitanClone.PrimaryPart.CFrame = InheritorCharacter.PrimaryPart.CFrame * Vector3.new(0, 100, 0)
        self.Inheritor.Character = TitanClone
        TitanClone.PrimaryPart:SetNetworkOwnership(self.Inheritor)

        local TitanCamera = require(self.Inheritor)
        print("logic should also go here where u prolly fire remoteevent to shift stuff")
    else
        warn("Max shifts reached")
    end
end

function ShifterBase:AssignModel(ShifterModel) -- SHIFTERMODEL MUST BE OUT OF SERVERSTORAGE!!!!!!!!!!!!!!!
    if not ShifterModel then
        return
    end

    self.Model = ShifterModel
end

function ShifterBase:ChangeState(NewState)
    self.CurrentState = NewState
end

function ShifterBase:Deshift()
    self.Shifted = false
    self.State = nil
end

return ShifterBase