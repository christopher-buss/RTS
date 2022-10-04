local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Matter = require(Packages.Matter)

local Components = require(ReplicatedStorage.Shared.Components)

type TransformComponent = Components.TransformComponent
type UnitComponent = Components.UnitComponent
type World = Matter.World

local function UnitMovement(world: World, state)
    -- if state.debugEnabled then
    --     print("?")
    for id: number, transform: TransformComponent, unit: UnitComponent in
        world:query(Components.Transform, Components.Unit):without(Components.Model)
    do
        local model = unit.appearance:Clone()

        for _, part in ipairs(model:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Color = Color3.fromRGB(62, 60, 215)
            end
        end

        model.PrimaryPart.Position = transform.position
        model.Parent = workspace

        world:insert(
            id,
            Components.Model({
                model = model,
            })
        )
    end

    for id, transformRecord in world:queryChanged(Components.Transform) do
        local model: Components.ModelComponent = world:get(id, Components.Model)

        model.model:PivotTo(CFrame.new(transformRecord.new.position))
    end
    -- else
    --     for id: number, model: Components.ModelComponent in world:query(Components.Model) do
    --         model.model:Destroy()
    --         world:remove(id, Components.Model)
    --     end
    -- end
end

return UnitMovement
