local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Matter = require(Packages.Matter)

local Components = require(ReplicatedStorage.Shared.Components)

local CanSelectUnit = require(script.Parent.CanSelectUnit)

type ModelComponent = Components.ModelComponent
type SelectedComponent = Components.SelectedComponent
type World = Matter.World

--[=[
    @within Unit
    @tag System
    @client

    Adds a highlight box to any unit that is currently selected for user
    visualisation.
]=]
local function SelectedUnitsAreHighlighted(world: World)
    -- Currently this only appears on a unit when they have been selected.
    -- We could potentially add in a Visualisation component of sorts for
    -- selection so that if the model is removed and readded then the highlight
    -- would reappear, but for it's unlikely a disappeared entity will need to
    -- automatically be reselected.
    for id: number, selectedRecord in world:queryChanged(Components.Selected) do
        if not world:contains(id) then
            continue
        end

        local model: ModelComponent? = world:get(id, Components.Model)
        if model then
            if selectedRecord.new then
                local highlight = model.model:FindFirstChild("Highlight")
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Parent = model.model
                end
            elseif selectedRecord.old then
                local highlight = model.model:FindFirstChild("Highlight")
                highlight:Destroy()
            end
        end
    end
end

return {
    system = SelectedUnitsAreHighlighted,
    after = { CanSelectUnit },
}
