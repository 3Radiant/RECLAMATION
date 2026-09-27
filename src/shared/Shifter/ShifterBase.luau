local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage.Shared.Configs.Config)

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
        self.State = "Idle"

        local TitanClone = self.Model:Clone()

        local InheritorCharacter = self.Inheritor.Character

        --[[for _, CharacterChild in InheritorCharacter:GetChildren() do
            if CharacterChild:IsA("Accessory") then
                if CharacterChild.AccessoryType == Enum.AccessoryType.Hair then
                    local HairClone = CharacterChild:Clone()
                    HairClone.Parent = TitanClone

                    local HairScale = (TitanClone.Head.Size.Y) / (InheritorCharacter.Head.Size)
                    HairClone.Handle.Size *= HairScale
                    HairClone.Handle.HairAttachment.Position *= HairScale
                end
            end
        end]]

        InheritorCharacter.Parent = ReplicatedStorage
        TitanClone.Parent = game.Workspace
        TitanClone.PrimaryPart.CFrame = InheritorCharacter.PrimaryPart.CFrame * CFrame.new(0, 150, 0)
        TitanClone.PrimaryPart:SetNetworkOwner(self.Inheritor)
        self.Inheritor.Character = TitanClone
        
        local camevent = ReplicatedStorage.Events.CameraEvent
        camevent:FireClient(ShiftingPlayer)

        --local TitanCamera = require(ShiftingPlayer.PlayerScripts.Client.Camera)
       -- TitanCamera:UpdateOffset(Config.ShifterCameraOffset)
        --TitanCamera:UpdateZooms(Config.ShifterMinimumZoomDistance, Config.ShifterMaximumZoomDistance)
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