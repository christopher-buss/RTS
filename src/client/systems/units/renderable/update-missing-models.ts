import { World } from "@rbxts/matter";
import * as Components from "shared/components";

function updateMissingModels(world: World) {
	for (const [id, transform, unit] of world
		.query(Components.Transform, Components.Unit)
		.without(Components.Renderable)) {
		{
			const model = unit.appearance.Clone();
			model.PrimaryPart!.Position = transform.position;
			model.Parent = game.Workspace;

			world.insert(id, Components.Renderable({ model: model }));
		}
	}
}

export = updateMissingModels;
