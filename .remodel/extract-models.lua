local game = remodel.readPlaceFile("remodel-test.rbxlx")

-- In this example, we have a bunch of models stored in
-- ReplicatedStorage.Models. We want to put them into a folder named models,
-- maybe for a tool like Rojo.
local Models = game.ReplicatedStorage.Prefabs
remodel.createDirAll("assets/prefabs")

for _, model in ipairs(Models:GetChildren()) do
    remodel.writeModelFile(model, "assets/prefabs/" .. model.Name .. ".rbxmx")
end
