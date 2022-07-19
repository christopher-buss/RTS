local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Matter = require(Packages.Matter)

local Components = require(script.Parent.Components)

local boundTags = {
    -- Boss = Components.Boss,
}

local function setupTags(world: Matter.World)
    local function spawnBound(instance, component)
        local id = world:spawn(
            component(),
            Components.Model({
                model = instance,
            }),
            Components.Transform({
                cframe = instance.PrimaryPart.CFrame,
            })
        )

        instance:SetAttribute("serverEntityId", id)
    end

    for tagName, component in pairs(boundTags) do
        for _, instance in ipairs(CollectionService:GetTagged(tagName)) do
            spawnBound(instance, component)
        end

        CollectionService:GetInstanceAddedSignal(tagName):Connect(function(instance)
            spawnBound(instance, component)
        end)

        CollectionService:GetInstanceRemovedSignal(tagName):Connect(function(instance)
            local id = instance:GetAttribute("serverEntityId")
            if id then
                world:despawn(id)
            end
        end)
    end
end

return setupTags
