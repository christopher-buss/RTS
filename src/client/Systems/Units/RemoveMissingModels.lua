local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Matter = require(Packages.Matter)

local Components = require(ReplicatedStorage.Source.Components)

type ModelComponent = Components.ModelComponent
type World = Matter.World

--[=[
    @within Unit
    @tag System
    @client
    
    Handles the removal of the model component from units that are no longer in
    the game, along with removing the physical model from the game for units
    that are no longer in the world.
]=]
local function RemoveMissingModels(world: World)
    for id: number, model: ModelComponent in world:query(Components.Model) do
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

    for _id: number, modelRecord in world:queryChanged(Components.Model) do
        if modelRecord.new == nil then
            if modelRecord.old and modelRecord.old.model then
                modelRecord.old.model:Destroy()
            end
        end
    end
end

return RemoveMissingModels
