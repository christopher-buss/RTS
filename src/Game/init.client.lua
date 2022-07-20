local ReplicatedStorage = game:GetService("ReplicatedStorage")
local start = require(ReplicatedStorage.Shared.Start)
local receiveReplication = require(script.ReceiveReplication)

local world, state = start({
    ReplicatedStorage.Client.Systems,
    ReplicatedStorage.Shared.Systems,
})
receiveReplication(world, state)
