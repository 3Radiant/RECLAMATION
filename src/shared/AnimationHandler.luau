local AnimationHandler = {}

-- FIX THIS SHITTY SCRIPT CUZ ITS BROKEN 

function AnimationHandler:PlayAnimation(Character, AnimationId)
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    if Humanoid then
        --local Animation = Instance.new("Animation")
        --Animation.AnimationId =  AnimationId
        local AnimationTrack = Humanoid.Animator:LoadAnimation(AnimationId)
        AnimationTrack:Play()

        return AnimationTrack
    end
end

function AnimationHandler:StopAnimation(Character, AnimationId)
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    if Humanoid then
        for _, AnimationTrack in pairs(Humanoid:GetPlayingAnimationTracks()) do
            if AnimationTrack.Animation.AnimationId == "rbxassetid://" .. AnimationId then
                AnimationTrack:Stop()
            end
        end
    end
end

function AnimationHandler:StopAllAnimations(Character)
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    if Humanoid then
        for _, AnimationTrack in pairs(Humanoid:GetPlayingAnimationTracks()) do
            AnimationTrack:Stop()
        end
    end
end

return AnimationHandler