import { World } from "@rbxts/matter";
import { RunService } from "@rbxts/services";
import * as Components from "shared/components";

const name = RunService.IsServer() ? "serverEntityId" : "clientEntityId";

/**
 * Adds entity id to renderable model in the game.
 *
 * @param world Matter
 */
function updateModelAttribute(world: World): void {
	for (const [id, modelRecord] of world.queryChanged(Components.Renderable)) {
		const model = modelRecord.new;
		if (model) {
			model.model.SetAttribute(name, id);
		}
	}
}

export = updateModelAttribute;
