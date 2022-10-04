import { component } from "@rbxts/matter";

export const Health = component<{
	currentHealth: number;
	initialHealth: number;
	maxHealth: number;
}>("Health");
export type Health = ReturnType<typeof Health>;

/**
 * Represents an entity that can move.
 *
 * @param movementSpeed grids per second
 * @param maxForce rate of acceleration
 */
export const Movement = component<{
	movementSpeed: number;
	maxForce: number;
}>("Movement");
export type Movement = ReturnType<typeof Movement>;

export const Renderable = component<{
	model: Model;
}>("Renderable");
export type Renderable = ReturnType<typeof Renderable>;

export const Selected = component<{
	selected: boolean;
}>("Selected", {
	selected: false,
});
export type Selected = ReturnType<typeof Selected>;

export const Selectable = component<{}>("Selectable");
export type Selectable = ReturnType<typeof Selectable>;

export const Target = component<{
	location: Vector3;
}>("Target");
export type Target = ReturnType<typeof Target>;

export const Transform = component<{
	orientation: number;
	position: Vector3;
}>("Transform");
export type Transform = ReturnType<typeof Transform>;

export const Unit = component<{
	appearance: Model;
	owner: Player;
	team?: Team;
}>("Unit");
export type Unit = ReturnType<typeof Unit>;
