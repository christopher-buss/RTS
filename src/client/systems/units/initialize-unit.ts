import { World } from "@rbxts/matter";
import type { ClientState } from "client/main.client";
import * as Components from "shared/components";

/**
 * Initializes any client-side only components for a unit.
 *
 * @param world Matter
 * @param state
 */
function initializeUnit(world: World, state: ClientState): void {
	for (const [id, unit] of world.query(Components.Unit).without(Components.Selectable)) {
		if (!world.contains(id)) {
			continue;
		}

		if (state.player === unit.owner) {
			world.insert(id, Components.Selectable());
		}
	}
}

export = initializeUnit;
