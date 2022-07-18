local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Matter = require(Packages.Matter)

local Components = require(ReplicatedStorage.Source.Components)

-- Yeah do this better

local function PlayAnimaton(world)
    for id, animationRecord in world:queryChanged(Components.Animation) do
        warn("Animation System not Implemented")
        --     local animation = animationRecord.new
        --     if not animationRecord.new or not animation.info then
        --         continue
        --     end

        --     local model = world:get(id, Components.Model)
        --     if not model then
        --         continue
        --     end

        --     local humanoid = model.model.Humanoid
        --     if not humanoid then
        --         continue
        --     end

        --     local animationInstance = Instance.new("Animation")
        --     animationInstance.AnimationId = "http://www.roblox.com/asset/?id=" .. animation.info.Id
        --     local animator: Animator? = humanoid:FindFirstChildOfClass("Animator")
        --     if animator then
        --         local track = animator:LoadAnimation(animationInstance)
        --         track.Priority = animation.info.Priority
        --         if animation.info.Length ~= 0 then
        --             track.Looped = false
        --         end
        --         track:Play()

        --         -- Updating the component in queryChanged is UB so we have to nil out the info so we can ensure that we dont recursively end up updating the animation component
        --         world:insert(
        --             id,
        --             animation:patch({
        --                 animationTrack = track,
        --                 info = Matter.None,
        --             })
        --         )
        --     end
    end
end

return PlayAnimaton
