local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Components = require(ReplicatedStorage.Source.Components)

type ModelComponent = Components.ModelComponent

local name = RunService:IsServer() and "serverEntityId" or "clientEntityId"

--[=[
    @server @client

    Adds the id of an entity to a model for reconciliation purposes.
]=]
local function updateModelAttribute(world)
    for id: number, modelRecord in world:queryChanged(Components.Model) do
        local model: ModelComponent = modelRecord.new
        if model then
            model.model:SetAttribute(name, id)
        end
    end
end

return updateModelAttribute
