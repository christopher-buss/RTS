import { World } from "@rbxts/matter";
import * as Components from "shared/components";
import playerCanSelectUnit from "../player-can-select-unit";

/**
 * Adds a visual indicator to a unit when it is selected.
 *
 * @param world
 */
function selectedIsHighlighted(world: World) {
	for (const [id, selectedRecord] of world.queryChanged(Components.Selected)) {
		if (!world.contains(id)) {
			continue;
		}

		const model = world.get(id, Components.Renderable);
		if (model) {
			if (selectedRecord.new) {
				let highlight = model.model.FindFirstChild("Highlight");
				if (!highlight) {
					highlight = new Instance("Highlight");
					highlight.Parent = model.model;
				}
			} else if (selectedRecord.old) {
				const highlight = model.model.FindFirstChild("Highlight");
				if (highlight) {
					highlight.Destroy();
				}
			}
		}
	}
}

export = {
	system: selectedIsHighlighted,
	after: [playerCanSelectUnit],
};
