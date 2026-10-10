local GunHandler = {}

GunHandler.__index = GunHandler

function GunHandler.new()
    self = {
        BodyDamage = 42,
        HeadshotDamage = 87,
        LimbDamage = 17,

        CurrentAmmo = 5,
        Ammo = 5,
        RPM = 55,

        BulletSpeed = 1100,

        AnimationGroup = "Rifle", 
        Type = "Bolt", 

        Tracer = "Default",

        Recoil = 0, 
    }

    setmetatable(self, GunHandler)

    return self
end

function GunHandler:Reload()
    self.CurrentAmmo = self.Ammo
end

function GunHandler:Fire()
    
end

function GunHandler:AlignCharacter()
    local AlignOrientation = Instance.new("AlignOrientation")
end

return GunHandler.new()