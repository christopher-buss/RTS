local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Matter = require(Packages.Matter)

local Components = require(ReplicatedStorage.Shared.Components)

type TransformComponent = Components.TransformComponent
type UnitComponent = Components.UnitComponent
type World = Matter.World

--[=[
    @within Unit
    @tag System
    @client

    Adds a model to any unit that currently does not have a model component.
    Models are only present on the client and are not replicated.
    
    @note Each client will have their own representation of models, and while
    it is likely that models will not sync with 100% accuracy, it is good enough
    for the purposes of this game.
]=]
local function UpdateMissingModels(world: World)
    for id: number, transform: TransformComponent, unit: UnitComponent in
        world:query(Components.Transform, Components.Unit):without(Components.Model)
    do
        local model = unit.appearance:Clone()
        model.PrimaryPart.Position = transform.position
        model.Parent = workspace

        world:insert(
            id,
            Components.Model({
                model = model,
            })
        )
    end
end

return UpdateMissingModels
