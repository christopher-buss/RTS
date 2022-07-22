local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Matter = require(Packages.Matter)
local Mouse = require(Packages.Input).Mouse
local Keyboard = require(Packages.Input).Keyboard

local Components = require(ReplicatedStorage.Shared.Components)

type Keyboard = typeof(Keyboard.new())
type ModelComponent = Components.ModelComponent
type Mouse = typeof(Mouse.new())
type SelectedComponent = Components.SelectedComponent
type World = Matter.World

local Inset = GuiService:GetGuiInset()

-- Systems shouldn't hold state so this should probably be stored elsewhere
-- We could likely have a player state somewhere for the local player that holds the mouse
-- (we do not want to create this every frame)
local mouse: Mouse = Mouse.new()
local keyboard: Keyboard = Keyboard.new()

local Camera = workspace.CurrentCamera
local lastPos

-- TODO: Selection frame wont be visible if player resets
local selectionFrame = Players.LocalPlayer.PlayerGui:WaitForChild("SelectionGui").SelectionFrame
---------------------------------

--[=[
    @within Unit
    @client
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
    @private

    Deselects all units that are currently selected.
]=]
local function deselectAllUnits(world: World)
    -- We probably wish to at some point have it so that we can pass in a set
    -- of entityIds that we wish to not deselect. Will need prototyping.
    for id: number, _selected: SelectedComponent in world:query(Components.Selected) do
        world:remove(id, Components.Selected)
    end
end

--[=[
    @within Unit
    @private

    Deselects a specified unit.
]=]
local function deselectUnit(world: World, id: number)
    world:remove(id, Components.Selected)
end

--[=[
    @within Unit
    @private
    
    Gets the number of entities that have a set of given components.
]=]
local function getTotalEntitiesWithComponents(world: World, ...)
    local totalEntities = 0
    for _ in world:query(...) do
        totalEntities += 1
    end
    return totalEntities
end

-------------------------------------------------------------------------------
--- Functions for the Selection Box
-------------------------------------------------------------------------------
local function hitPos(position)
    local unitRay = Camera:ScreenPointToRay(position.x, position.y)
    local result = workspace:Raycast(unitRay.Origin, unitRay.Direction * 1000)
    return result and result.Position or unitRay.Origin
end

local function calcSlope(vec)
    local rel = Camera.CFrame:pointToObjectSpace(vec)
    return Vector2.new(rel.x / -rel.z, rel.y / -rel.z)
end

local function overlaps(cf, a1, a2)
    local rel = Camera.CFrame:ToObjectSpace(cf)
    local x, y = rel.x / -rel.z, rel.y / -rel.z

    return a1.x < x and x < a2.x and (a1.y < y and y < a2.y) and rel.z < 0
end

local function swap(a1, a2)
    return Vector2.new(math.min(a1.x, a2.x), math.min(a1.y, a2.y)),
        Vector2.new(math.max(a1.x, a2.x), math.max(a1.y, a2.y))
end

local function search(objs, p1, p2)
    local Found = {}
    local a1 = calcSlope(p1)
    local a2 = calcSlope(p2)

    a1, a2 = swap(a1, a2)

    for _, obj in ipairs(objs) do
        local cf = obj:IsA("Model") and obj:GetBoundingBox() or obj.CFrame
        if overlaps(cf, a1, a2) then
            table.insert(Found, obj)
        end
    end

    return Found
end

--[=[
    @within Unit
    @private
    
    Marks any unit within the selection frame as selected.

    TODO: The selection frame bounding is probably not as accurate as we'd
    expect, and as such the parameters for marking an object as selected should
    be increased.
]=]
local function selectUnitsInSelectionFrame(world: World, lastPosition: Vector3, mousePosition: Vector3)
    local models = {}

    for id: number, model: ModelComponent in world:query(Components.Model, Components.Selectable) do
        models[id] = model.model
    end

    local results = search(models, hitPos(lastPosition), hitPos(mousePosition))

    for _, unit in results do
        local id = unit:GetAttribute("clientEntityId")
        if id then
            world:insert(id, Components.Selected())
        end
    end
end

--[=[
    @within Unit
    @tag System

    Gives the user the ability to select and deselect owned units.
]=]
local function CanSelectUnit(world: World)
    -- Select Units
    for _ in Matter.useEvent(mouse, mouse.LeftDown) do
        lastPos = mouse:GetPosition()
        local id = getUnitBelowMouse()
        if not id then
            continue
        end

        if not world:get(id, Components.Selectable) then
            -- unit isnt selectable, it could be a unit owned by another player
            continue
        end

        local alreadySelected = world:get(id, Components.Selected)
        if alreadySelected then
            if keyboard:IsKeyDown(Enum.KeyCode.LeftControl) then
                deselectUnit(world, id)
                continue
            end
            local amount = getTotalEntitiesWithComponents(world, Components.Selected)
            if amount < 2 then
                deselectAllUnits(world)
                continue
            end
        end

        if not keyboard:IsKeyDown(Enum.KeyCode.LeftControl) then
            deselectAllUnits(world)
        end

        world:insert(id, Components.Selected())
        return
    end

    -- Deselect Units
    for _ in Matter.useEvent(mouse, mouse.RightDown) do
        deselectAllUnits(world)
    end

    if keyboard:IsKeyDown(Enum.KeyCode.C) then
        deselectAllUnits(world)
    end

    -- Selection Frame
    if mouse:IsLeftDown() then
        local mousePosition = mouse:GetPosition()

        local SOME_SMALL_MAGNITUDE = 10
        if (mousePosition - lastPos).magnitude < SOME_SMALL_MAGNITUDE then
            return
        end

        local lastPosition = lastPos
        local Center = ((lastPos + mousePosition) * 0.5) - Inset

        local DistX = math.abs(lastPosition.X - mousePosition.X)
        local DistY = math.abs(lastPosition.Y - mousePosition.Y)

        selectionFrame.Position = UDim2.new(0, Center.X, 0, Center.Y)
        selectionFrame.Size = UDim2.new(0, DistX, 0, DistY)

        selectionFrame.Visible = true

        deselectAllUnits(world)
        selectUnitsInSelectionFrame(world, lastPosition, mousePosition)
    else
        selectionFrame.Visible = false
    end
end

return CanSelectUnit
