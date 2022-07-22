local codecs = {}

for _, child in ipairs(script:GetChildren()) do
    if child:IsA("ModuleScript") then
        codecs[tostring(child)] = require(child)
    end
end

return codecs
