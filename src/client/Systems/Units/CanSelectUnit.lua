local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Matter = require(Packages.Matter)
local Mouse = require(Packages.Input).Mouse

local Components = require(ReplicatedStorage.Source.Components)

type Mouse = typeof(Mouse.new())
type SelectedComponent = Components.SelectedComponent
type World = Matter.World

-- Systems shouldn't hold state so this should probably be stored elsewhere
-- We could likely have a player state somewhere for the local player that holds the mouse
-- (we do not want to create this every frame)
local mouse: Mouse = Mouse.new()

--[=[
    @within Unit
    @private

    Returns the entityId of any unit that is currently underneath the mouse of the localplayer. If no unit is underneath the mouse, returns nil.

    @return entityId: number | nil The entity id of the unit that was selected.
]=]
local function getUnitBelowMouse(): number?
    -- TODO: Should ignore units such as any player character. Maybe use a whitelist
    -- to add only units that can be accepted? Might not be worth the effort.
    -- Should player characters should be ignored? We may not even have characters.
    local params = RaycastParams.new()
    local result = mouse:Raycast(params)
    if not result then
        return nil
    end

    return result.Instance.Parent:GetAttribute("clientEntityId")
end

--[=[
    @within Unit
    @client

    Deselects all units that are currently selected.
]=]
local function deselectUnits(world: World)
    -- We probably wish to at some point have it so that we can pass in a set
    -- of entityIds that we wish to not deselect. Will need prototyping.
    for id: number, _selected: SelectedComponent in world:query(Components.Selected) do
        print("Deselecting Unit")
        world:remove(id, Components.Selected)
    end
end

--[=[
    @within Unit
    @tag System
    @client

    Gives the user the ability to select and deselect owned units.
]=]
local function CanSelectUnit(world: World)
    -- Select Units
    for _ in Matter.useEvent(mouse, mouse.LeftDown) do
        -- TODO: Currently we are deselecting all units and reselecting.
        -- Does this cause stuttering on visualisation?
        deselectUnits(world)

        local id = getUnitBelowMouse()
        if not id then
            continue
        end

        if not world:get(id, Components.Selectable) then
            -- unit isnt selectable, it could be a unit owned by another player
            continue
        end

        print("Selected Unit:", id)
        world:insert(id, Components.Selected())
    end

    -- Deselect Units
    for _ in Matter.useEvent(mouse, mouse.RightDown) do
        deselectUnits(world)
    end
end

return CanSelectUnit
