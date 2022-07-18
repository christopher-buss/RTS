local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages
local Matter = require(Packages.Matter)
local Components = require(ReplicatedStorage.Source.Components)

local function RemoveMissingModels(world)
    for id, model in world:query(Components.Model) do
        for _ in Matter.useEvent(model.model, "AncestryChanged") do
            if model.model:IsDescendantOf(game) == false then
                world:remove(id, Components.Model)
                break
            end
        end
        if not model.model.PrimaryPart then
            world:remove(id, Components.Model)
        end
    end

    for _id, modelRecord in world:queryChanged(Components.Model) do
        if modelRecord.new == nil then
            if modelRecord.old and modelRecord.old.model then
                modelRecord.old.model:Destroy()
            end
        end
    end
end

return RemoveMissingModels
