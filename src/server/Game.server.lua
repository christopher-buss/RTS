local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SetupTags = require(ReplicatedStorage.Source.SetupTags)
local Start = require(ReplicatedStorage.Source.Start)

local world = Start({
    script.Parent.Systems,
    ReplicatedStorage.Source.Systems,
})

SetupTags(world)
