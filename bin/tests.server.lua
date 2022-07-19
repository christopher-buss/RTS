local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TestService = game:GetService("TestService")
local TestEZ = require(ReplicatedStorage.Packages.TestEZ)

local results = TestEZ.TestBootstrap:run(
    {
        TestService.Tests,
    },
    TestEZ.Reporters.TextReporter,
    {
        noXpcallByDefault = true,
    }
)

if #results.errors > 0 or results.failureCount > 0 then
    error("Tests failed")
end
