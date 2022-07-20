local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Matter = require(Packages.Matter)

local Components = require(ReplicatedStorage.Shared.Components)

local RemoteEvent = ReplicatedStorage.MatterRemote

type World = Matter.World

-- This will need updating. We do not want to replicate movement data to the client if the enemy unit is supposed to be in fog of war.

local REPLICATED_COMPONENTS = {
    "Movement",
    "Transform",
    "Unit",
}

local replicatedComponents = {}

for _, name in REPLICATED_COMPONENTS do
    replicatedComponents[Components[name]] = true
end

local function Replication(world: World)
    for _, player: Player in Matter.useEvent(Players, "PlayerAdded") do
        local payload = {}
        for entityId, entityData in world do
            local entityPayload = {}
            payload[tostring(entityId)] = entityPayload

            for component, componentData in entityData do
                if replicatedComponents[component] then
                    entityPayload[tostring(component)] = { data = componentData }
                end
            end
        end

        print("Sending initial payload to " .. player.Name)
        RemoteEvent:FireClient(player, payload)
    end

    local changes = {}
    for component in replicatedComponents do
        for entityId, record in world:queryChanged(component) do
            local key = tostring(entityId)
            local name = tostring(component)

            if changes[key] == nil then
                changes[key] = {}
            end

            if world:contains(entityId) then
                changes[key][name] = { data = record.new }
            end
        end
    end

    if next(changes) then
        RemoteEvent:FireAllClients(changes)
    end
end

return {
    system = Replication,
    priority = math.huge,
}
