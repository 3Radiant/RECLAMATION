local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Config = require(ReplicatedStorage.Shared.Configs.Config)

local CameraEvent = ReplicatedStorage.Events.CameraEvent


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

function ShifterBase:Shift(ShiftingPlayer)
    if self.ShiftCount <= self.MaxShifts and ShiftingPlayer == self.Inheritor and self.Shifted == false then
    
        self.ShiftCount = self.ShiftCount + 1
        self.Shifted = true
        print(self.Shifted)
        self.State = "Idle"

        local TitanClone = self.Model:Clone()
        local InheritorCharacter = self.Inheritor.Character
        InheritorCharacter.Archivable = true
        local InheritorCharacterClone = InheritorCharacter:Clone()

        InheritorCharacterClone.Parent = ReplicatedStorage.ShifterCharacters
        TitanClone.Parent = game.Workspace
        TitanClone.PrimaryPart.CFrame = InheritorCharacter.PrimaryPart.CFrame * CFrame.new(0, 150, 0)
        TitanClone.PrimaryPart:SetNetworkOwner(self.Inheritor)
        self.Inheritor.Character = TitanClone
        
        CameraEvent:FireClient(ShiftingPlayer, true)

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

function ShifterBase:Deshift(ShiftingPlayer)
    print("Deshift function called for player: ", ShiftingPlayer.Name)
    self.Shifted = false
    self.State = nil

    local InheritorCharacter = ReplicatedStorage.ShifterCharacters:FindFirstChild(ShiftingPlayer.Name)
    InheritorCharacter.Parent = game.Workspace
    InheritorCharacter.PrimaryPart:SetNetworkOwner(ShiftingPlayer)
    InheritorCharacter.PrimaryPart.CFrame = ShiftingPlayer.Character.PrimaryPart.CFrame * CFrame.new(0, 20, 0)
    ShiftingPlayer.Character:Destroy()
    ShiftingPlayer.Character = InheritorCharacter

    CameraEvent:FireClient(ShiftingPlayer, false)
end

return ShifterBase.new()