import { World } from "@rbxts/matter";
import { Workspace } from "@rbxts/services";
import type { ServerState } from "server/main.server";
import * as Components from "shared/components";

/**
 * Renders the unit's model on the server for debugging purposes.
 *
 * @param world Matter
 */
function debug_unitModelOnServer(world: World, state: ServerState): void {
	if (!state.debugEnabled) {
		return;
	}

	for (const [id, transform, unit] of world
		.query(Components.Transform, Components.Unit)
		.without(Components.Renderable)) {
		{
			const model = unit.appearance.Clone();

			model.GetDescendants().forEach((part) => {
				if (part.IsA("BasePart")) {
					(part as BasePart).Color = Color3.fromRGB(62, 60, 215);
				}
			});

			model.PrimaryPart!.Position = transform.position;
			model.Parent = Workspace;

			world.insert(id, Components.Renderable({ model: model }));
		}
	}

	for (const [id, transformRecord] of world.queryChanged(Components.Transform)) {
		const model = world.get(id, Components.Renderable);
		const transform = transformRecord.new;
		if (transform) {
			model?.model.PivotTo(new CFrame(transform.position));
		}
	}
}

export = debug_unitModelOnServer;
