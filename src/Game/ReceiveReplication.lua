local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Components = require(ReplicatedStorage.Shared.Components)
local RemoteEvent = ReplicatedStorage:WaitForChild("MatterRemote")

local Codecs = require(ReplicatedStorage.Shared.Codecs)

local function SetupReplication(world, state)
    local function debugPrint(...)
        if state.debugEnabled then
            print("Replication>", ...)
        end
    end

    local entityIdMap = {}

    RemoteEvent.OnClientEvent:Connect(function(entities)
        for serverEntityId, componentMap in entities do
            local clientEntityId = entityIdMap[serverEntityId]

            if clientEntityId and next(componentMap) == nil then
                world:despawn(clientEntityId)
                entityIdMap[serverEntityId] = nil
                debugPrint(string.format("Despawn %ds%d", clientEntityId, serverEntityId))
                continue
            end

            local componentsToInsert = {}
            local componentsToRemove = {}

            local insertNames = {}
            local removeNames = {}

            for name, container in componentMap do
                -- If we have encoded any data then first we want to decode it
                -- before adding it to the component.
                if Codecs[name] then
                    container.data = Codecs[name].decode(container.data)
                end

                if container.data then
                    table.insert(componentsToInsert, Components[name](container.data))
                    table.insert(insertNames, name)
                else
                    table.insert(componentsToRemove, Components[name])
                    table.insert(removeNames, name)
                end
            end

            if clientEntityId == nil then
                clientEntityId = world:spawn(unpack(componentsToInsert))

                entityIdMap[serverEntityId] = clientEntityId

                debugPrint(
                    string.format("Spawn %ds%d with %s", clientEntityId, serverEntityId, table.concat(insertNames, ","))
                )
            else
                if #componentsToInsert > 0 then
                    world:insert(clientEntityId, unpack(componentsToInsert))
                end

                if #componentsToRemove > 0 then
                    world:remove(clientEntityId, unpack(componentsToRemove))
                end

                debugPrint(
                    string.format(
                        "Modify %ds%d adding %s, removing %s",
                        clientEntityId,
                        serverEntityId,
                        if #insertNames > 0 then table.concat(insertNames, ", ") else "nothing",
                        if #removeNames > 0 then table.concat(removeNames, ", ") else "nothing"
                    )
                )
            end
        end
    end)
end

return SetupReplication
