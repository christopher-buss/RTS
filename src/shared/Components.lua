local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Matter = require(Packages.Matter)

local Model = require(script.Parent.Components.Model)

local test: Model.Model = {
    ree = 5,
    model = Instance.new("Model"),
}

local COMPONENTS = {
    "Animation",
    "Health",
    "Model",
    "Target",
    "Transform",
}

local components = {}

for _, name in ipairs(COMPONENTS) do
    components[name] = Matter.component(name)
end

return components
