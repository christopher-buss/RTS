--[=[
    @class Components
    @server @client

    This is a single store of truth for any [Component](https://eryn.io/matter/api/Component)
    that is present in the world.
]=]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Matter = require(Packages.Matter)

local components = {}

--[=[
    @within Components
    @private

    Helper function to create a component in Matter.
]=]
local function createComponent(name: string, defaultData: any)
    -- I can probably remove this and just supply it with the empty {}
    if not next(defaultData) then
        components[name] = Matter.component(name)
        return
    end

    components[name] = Matter.component(name, defaultData)
end

-------------------------------------------------------------------------------
-- Component definitions
-------------------------------------------------------------------------------

createComponent("Animation", {})
export type AnimationComponent = {}

createComponent("Health", {})
export type HealthComponent = {
    currentHealth: number,
    initialHealth: number,
    maxHealth: number,
}

createComponent("Model", {})
export type ModelComponent = {
    model: Model,
}

createComponent("Movement", {})
export type MovementComponent = {
    movemementSpeed: number,
}

createComponent("Selected", {
    selected = false,
})
export type SelectedComponent = {}

createComponent("Selectable", {})
export type SelectableComponent = {}

createComponent("Target", {})
export type TargetComponent = {}

createComponent("Transform", {})
export type TransformComponent = {
    position: Vector3,
    rotation: Vector3?,
}

createComponent("Unit", {})
export type UnitComponent = {
    appearance: Model,
    owner: Player,
}

return components
