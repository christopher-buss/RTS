import { AnyEntity, useDeltaTime, useEvent, World } from "@rbxts/matter";
import * as Components from "shared/components";
import Remotes from "shared/remotes";

const moveUnitRemote = Remotes.Server.Get("MoveUnits");

/**
 * @param world Matter
 */
function canMove(world: World): void {
	Components.Health;
	for (const [, player, position, selectedUnits] of useEvent(moveUnitRemote, moveUnitRemote)) {
		print("Received move request");
		print(position);
		const x = position.X;
		const z = position.Y;

		selectedUnits.forEach((id) => {
			const unit = world.get(id as AnyEntity, Components.Unit);
			if (unit?.owner !== player) {
				warn("Received units not owned by sender");
				return;
			}

			world.insert(
				id as AnyEntity,
				Components.Target({
					location: new Vector3(x, 2, z),
				}),
			);
		});
	}

	for (const [id, target, transform, movement] of world.query(
		Components.Target,
		Components.Transform,
		Components.Movement,
		Components.Unit,
	)) {
		const direction = target.location.sub(transform.position).Unit;
		const newLocation = transform.position.add(direction.mul(movement.movementSpeed).mul(useDeltaTime()));

		world.insert(id, transform.patch({ position: newLocation }));

		if (target.location.sub(transform.position).Magnitude <= 0.1) {
			world.remove(id, Components.Target);
		}
	}
}

export = canMove;
