local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Matter = require(Packages.Matter)

local Components = require(ReplicatedStorage.Shared.Components)

type ModelComponent = Components.ModelComponent
type MovementComponent = Components.MovementComponent
type TransformComponent = Components.TransformComponent
type World = Matter.World

local function UpdateUnitModel(world: World)
    -- for id: number, transformRecord in world:queryChanged(Components.Transform) do
    --     if not world:contains(id) then
    --         continue
    --     end

    --     local transform: TransformComponent = transformRecord.new
    --     if not transform then
    --         continue
    --     end

    --     local model: ModelComponent = world:get(id, Components.Model)
    --     if not model then
    --         warn("Missing Model for entity " .. id)
    --         continue
    --     end

    --     local position = CFrame.new(transform.position)
    --     local orientation = CFrame.Angles(0, transform.orientation, 0)

    --     -- print(transform.position)

    --     -- TODO: Rather than just moving the unit we need to lineraly iterpolate this so that it's smooth on the client
    --     model.model:SetPrimaryPartCFrame(position * orientation)
    -- end

    -- TODO: This definitely needs some work to smooth out more, but for now
    -- does the job at sort of representing movement.

    for id: number, transform: TransformComponent, model: ModelComponent, movement: MovementComponent in
        world:query(Components.Transform, Components.Model, Components.Movement)
    do
        local currentLocation = model.model:GetPivot().Position
        local targetLocation = transform.position

        if (currentLocation - targetLocation).Magnitude < 0.1 then
            continue
        end

        local direction = (targetLocation - currentLocation).unit / 100
        local newLocation = currentLocation + direction * movement.movementSpeed

        model.model:PivotTo(CFrame.new(newLocation))
    end
end

return UpdateUnitModel
