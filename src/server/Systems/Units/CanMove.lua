local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Matter = require(Packages.Matter)

local Components = require(ReplicatedStorage.Shared.Components)

local MoveUnitsRemote = ReplicatedStorage.MoveUnitsRemote

type MovementComponent = Components.MovementComponent
type TargetComponent = Components.TargetComponent
type TransformComponent = Components.TransformComponent
type UnitComponent = Components.UnitComponent
type World = Matter.World

local function CanMove(world: World)
    -- This may not want to be in this?
    for _, sender, position, selectedUnits in Matter.useEvent(MoveUnitsRemote, MoveUnitsRemote.OnServerEvent) do
        local x = position.X
        local z = position.Y

        for _, id in selectedUnits do
            local unit: UnitComponent = world:get(id, Components.Unit)
            if unit.owner ~= sender then
                warn("Received units not owned by sender")
                return
            end

            world:insert(
                id,
                Components.Target({
                    location = Vector3.new(x, 2, z),
                })
            )
        end
    end

    for id: number, target: TargetComponent, transform: TransformComponent, movement: MovementComponent in
        world:query(Components.Target, Components.Transform, Components.Movement, Components.Unit)
    do
        local direction = (target.location - transform.position).unit
        local newLocation = transform.position + direction * movement.movementSpeed * Matter.useDeltaTime()

        world:insert(
            id,
            transform:patch({
                position = newLocation,
            })
        )

        if (target.location - transform.position).Magnitude < 0.1 then
            world:remove(id, Components.Target)
        end
    end
end

return CanMove

--[=[
    User clicks on the ground. The player then needs to replicate the position of the location to the server along with the selected components.

    Could the troops have a target component that is replicated client > server?
]=]
