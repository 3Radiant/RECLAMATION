local Hitbox = {}

function Hitbox.CreateHitbox(Parent, Part, Size, Position)
    local HitboxPart = Instance.new("Part")
    HitboxPart.Size = Size
    HitboxPart.Position = Position
    HitboxPart.Anchored = true
    HitboxPart.CanCollide = false
    HitboxPart.Transparency = 0.7
    HitboxPart.BrickColor = Color3.fromRGB(255, 0, 0)
    HitboxPart.Parent = game.Workspace:FindFirstChild("Hitboxes") 

    local WeldConstraint = Instance.new("WeldConstraint")
    WeldConstraint.Part0 = Part
    WeldConstraint.Part1 = HitboxPart
    WeldConstraint.Parent = HitboxPart

    return HitboxPart
end

function Hitbox.DestroyHitbox(HitboxPart)
    if HitboxPart and HitboxPart.Parent then
        HitboxPart:Destroy()
    end
end

function Hitbox.GetHumanoidsInHitbox(HitboxPart)
    local Humanoids = {}
    for _, Character in pairs(game.Workspace:GetChildren()) do
        if Character:IsA("Model") and Character:FindFirstChild("Humanoid") then
            local Humanoid = Character.Humanoid
            if HitboxPart:IsPointInside(Humanoid.RootPart.Position) then
                table.insert(Humanoids, Humanoid)
            end
        end
    end
    return Humanoids
end

return Hitbox