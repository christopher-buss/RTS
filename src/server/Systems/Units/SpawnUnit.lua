local Players = game:GetService("Players")
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
    @server
    
    Used to spawn a unit on the server.
]=]
local function SpawnUnit(world: World)
    -- For now we just want a test unit so that we can test unit systems
    if #Players:GetPlayers() == 0 then
        return
    end

    for _ in world:query(Components.Unit) do
        return
    end

    local transformData: TransformComponent = {
        position = Vector3.new(14, 0.5, -11),
    }
    local secondTransformData: TransformComponent = {
        position = Vector3.new(17, 0.5, -11),
    }
    local unitData: UnitComponent = {
        appearance = ReplicatedStorage.Prefabs.Units.Dummy,
        owner = Players:GetPlayers()[1],
    }
    world:spawn(Components.Transform(transformData), Components.Unit(unitData))
    world:spawn(
        Components.Transform(secondTransformData),
        Components.Unit({
            appearance = ReplicatedStorage.Prefabs.Units.Dummy,
            owner = Players:GetPlayers()[1],
        })
    )
end

return SpawnUnit
