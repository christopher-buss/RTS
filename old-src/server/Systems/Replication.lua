local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Matter = require(Packages.Matter)

local Components = require(ReplicatedStorage.Shared.Components)
local Codecs = require(ReplicatedStorage.Shared.Codecs)

local RemoteEvent = ReplicatedStorage.MatterRemote

type TransformComponent = Components.TransformComponent
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
                if Codecs[tostring(component)] then
                    componentData = Codecs[tostring(component)].encode(componentData)
                end

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
        local encoder = Codecs[tostring(component)]

        if encoder and not Matter.useThrottle(encoder.replicationRate, component) then
            continue
        end

        for entityId, record in world:queryChanged(component) do
            if not world:contains(entityId) then
                continue
            end

            local data = record.new

            if encoder then
                data = encoder.encode(data)
            end

            local key = tostring(entityId)
            local name = tostring(component)

            if changes[key] == nil then
                changes[key] = {}
            end

            changes[key][name] = { data = data }
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
