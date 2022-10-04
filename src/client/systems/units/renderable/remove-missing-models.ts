import { useEvent, World } from "@rbxts/matter";
import * as Components from "shared/components";

/**
 * Handles the removal of the model component from units that are no longer in
 * the game, along with removing the physical model from the game for units
 * that are no longer in the world.
 *
 * @param world from Matter
 */
function removeMissingModels(world: World): void {
	for (const [id, model] of world.query(Components.Renderable)) {
		for (const [_] of useEvent(model.model, model.model.AncestryChanged)) {
			if (!model.model.IsDescendantOf(game)) {
				world.remove(id, Components.Renderable);
				break;
			}
		}
		if (!model.model.PrimaryPart) {
			world.remove(id, Components.Renderable);
		}
	}

	for (const [, modelRecord] of world.queryChanged(Components.Renderable)) {
		if (modelRecord.new !== undefined) {
			continue;
		}
		if (modelRecord.old) {
			modelRecord.old.model.Destroy();
		}
	}
}

export = removeMissingModels;
