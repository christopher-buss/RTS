local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Matter = require(Packages.Matter)

local Components = require(ReplicatedStorage.Source.Components)

type UnitComponent = Components.UnitComponent
type World = Matter.World

--[=[
    @within Unit
    @tag System
    @client

    A system that initialises a unit client-side.
    Adds any missing components that do not need to exist on the server.
]=]
local function InitialiseUnit(world: World)
    for id: number, unit: UnitComponent in world:query(Components.Unit):without(Components.Selectable) do
        if not world:contains(id) then
            continue
        end

        if Players.LocalPlayer == unit.owner then
            print("Unit Is Selectable")
            world:insert(id, Components.Selectable())
        end
    end
end

return InitialiseUnit
