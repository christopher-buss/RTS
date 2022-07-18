local ReplicatedStorage = game:GetService("ReplicatedStorage")
local start = require(ReplicatedStorage.Source.Start)
local receiveReplication = require(script.ReceiveReplication)

local world, state = start(script.Parent.Systems)
receiveReplication(world, state)
