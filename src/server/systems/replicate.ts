import { AnyComponent, useEvent, World } from "@rbxts/matter";
import { ComponentCtor } from "@rbxts/matter/lib/component";
import { Players } from "@rbxts/services";
import { codecs } from "shared/codecs";
import * as Components from "shared/components";
import remotes from "shared/remotes";
import type { ComponentNames } from "shared/serde";

const remoteEvent = remotes.Server.Get("Replication");

const REPLICATED_COMPONENTS = new Set<ComponentCtor>([Components.Transform, Components.Movement, Components.Unit]);

function replication(world: World): void {
	for (const [, plr] of useEvent(Players, "PlayerAdded")) {
		const payload = new Map<string, Map<ComponentNames, { data: AnyComponent }>>();

		for (const [id, entityData] of world) {
			const entityPayload = new Map<ComponentNames, { data: AnyComponent }>();
			payload.set(tostring(id), entityPayload);

			for (let [component, componentData] of entityData) {
				const codec = codecs.get(tostring(component));
				if (codec) {
					componentData = codec.encode(componentData);
				}

				if (REPLICATED_COMPONENTS.has(component)) {
					entityPayload.set(tostring(component) as ComponentNames, { data: componentData });
				}
			}
		}

		remoteEvent.SendToPlayer(plr, payload);
	}

	const changes = new Map<string, Map<ComponentNames, { data: AnyComponent }>>();

	for (const component of REPLICATED_COMPONENTS) {
		for (const [entityId, record] of world.queryChanged(component)) {
			const key = tostring(entityId);
			const name = tostring(component) as ComponentNames;

			if (!changes.has(key)) {
				changes.set(key, new Map());
			}

			if (world.contains(entityId)) {
				changes.get(key)?.set(name, { data: record.new! });
			}
		}
	}

	// eslint-disable-next-line @typescript-eslint/no-unnecessary-condition
	if (next(changes)[0] !== undefined) {
		print(changes);
		remoteEvent.SendToAllPlayers(changes);
	}
}

export = {
	system: replication,
	priority: math.huge,
};
