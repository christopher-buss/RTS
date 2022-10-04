import { AnyEntity, useEvent, World } from "@rbxts/matter";
import type { ClientState } from "client/main.client";
import * as Components from "shared/components";
import Remotes from "shared/remotes";

const moveUnitRemote = Remotes.Client.Get("MoveUnits");

/**
 *
 * @param world
 * @param state
 */
function playerCanMoveUnit(world: World, state: ClientState): void {
	const mouse = state.input.mouse;
	for (const [_] of useEvent(mouse, mouse.getButtonDownSignal(Enum.UserInputType.MouseButton1))) {
		const unitsToMove = new Array<AnyEntity>();

		for (const [id] of world.query(Components.Unit, Components.Selected)) {
			unitsToMove.push(id);
		}

		if (unitsToMove.size() > 0) {
			const raycastParams = new RaycastParams();
			const result = mouse.raycast(raycastParams);
			if (!result) {
				return;
			}

			const worldPosition = new Vector2int16(result.Position.X, result.Position.Z);
			moveUnitRemote.SendToServer(worldPosition, unitsToMove);
		}
	}
}

export = playerCanMoveUnit;
