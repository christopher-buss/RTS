local COORD_MULTIPLIER = 5 -- Numbers have accuracy within 0.2
local ORIENTATION_MULTIPLIER = 100 -- Numbers have accuracy within 0.01

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Components = require(ReplicatedStorage.Shared.Components)

type TransformComponent = Components.TransformComponent

local Transform = {}

Transform.replicationRate = 0.166

function Transform.encode(transformData)
    -- Orientation has range [0, 2pi)
    local orientation = math.floor(ORIENTATION_MULTIPLIER * transformData.orientation + 0.5)
    local x = math.floor(COORD_MULTIPLIER * transformData.position.X + 0.5)
    local z = math.floor(COORD_MULTIPLIER * transformData.position.Z + 0.5)

    return { Vector3int16.new(orientation, x, z) }
end

function Transform.decode(positioningData)
    local orientation = positioningData[1].X / ORIENTATION_MULTIPLIER
    local x = positioningData[1].Y / COORD_MULTIPLIER
    local z = positioningData[1].Z / COORD_MULTIPLIER

    local y = 2 -- calculateHeightOfUnit(x, z)

    local transform: TransformComponent = {
        orientation = orientation,
        position = Vector3.new(x, y, z),
    }
    return transform
end

return Transform
