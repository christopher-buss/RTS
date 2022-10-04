import { useDeltaTime, World } from "@rbxts/matter";
import type { ClientState } from "client/main.client";
import * as Components from "shared/components";

/**
 * @param world Matter
 * @param _state ClientState
 */
function updateUnitPosition(world: World, _state: ClientState): void {
	for (const [, transform, model, movement] of world.query(
		Components.Transform,
		Components.Renderable,
		Components.Movement,
	)) {
		const currentLocation = model.model.GetPivot().Position;
		const targetLocation = transform.position;

		if (currentLocation.sub(targetLocation).Magnitude < 0.1) {
			continue;
		}

		const direction = targetLocation.sub(currentLocation).Unit;
		const newLocation = currentLocation.add(direction.mul(movement.movementSpeed).mul(useDeltaTime()));

		model.model.PivotTo(new CFrame(newLocation));
	}
}

export = updateUnitPosition;
