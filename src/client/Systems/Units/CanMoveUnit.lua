local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Matter = require(Packages.Matter)
local Mouse = require(Packages.Input).Mouse

local Components = require(ReplicatedStorage.Shared.Components)

local MoveUnitsRemote = ReplicatedStorage:WaitForChild("MoveUnitsRemote")

type Mouse = typeof(Mouse.new())
type World = Matter.World

local mouse: Mouse = Mouse.new()

local function CanMoveUnit(world: World)
    for _ in Matter.useEvent(mouse, mouse.LeftDown) do
        local unitsToMove = {}

        for id: number, _, _ in world:query(Components.Unit, Components.Selected) do
            table.insert(unitsToMove, id)
        end

        if #unitsToMove > 0 then
            local params = RaycastParams.new()
            local result = mouse:Raycast(params)
            if not result then
                return
            end

            local worldPosition = Vector2int16.new(result.Position.X, result.Position.Z)

            -- TODO: Probably look at somehow serialising/encoding unitsToMove?
            MoveUnitsRemote:FireServer(worldPosition, unitsToMove)
        end
    end
end

return CanMoveUnit
