local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SetupTags = require(ReplicatedStorage.Shared.SetupTags)
local Start = require(ReplicatedStorage.Shared.Start)

local world = Start({
    script.Parent.Systems,
    ReplicatedStorage.Shared.Systems,
})
SetupTags(world)
