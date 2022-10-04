import { AnyComponent, AnyEntity, World } from "@rbxts/matter";
import { ComponentCtor } from "@rbxts/matter/lib/component";
import { codecs } from "shared/codecs";
import * as Components from "shared/components";
import Remotes from "shared/remotes";
import { UnionComponentsMap } from "shared/serde";

const remoteEvent = Remotes.Client.Get("Replication");

function receiveReplication(world: World): void {
	const entityIdMap = new Map<string, AnyEntity>();

	remoteEvent.Connect((entities) => {
		for (const [serverEntityId, componentMap] of entities) {
			let clientEntityId = entityIdMap.get(serverEntityId);

			// eslint-disable-next-line @typescript-eslint/no-unnecessary-condition
			if (clientEntityId !== undefined && next(componentMap)[0] === undefined) {
				world.despawn(clientEntityId);
				entityIdMap.delete(serverEntityId);
				continue;
			}

			const componentsToInsert = new Array<AnyComponent>();
			const componentsToRemove = new Array<ComponentCtor>();

			for (const [name, container] of componentMap) {
				// If we have encoded any data then first we want to decode it
				// before adding it to the component.
				const codec = codecs.get(name);
				if (codec !== undefined && container.data !== undefined) {
					container.data = codec.decode(container.data);
				}

				if (container.data !== undefined) {
					componentsToInsert.push(Components[name](container.data as UnionComponentsMap));
				} else {
					componentsToRemove.push(Components[name]);
				}
			}

			if (clientEntityId === undefined) {
				clientEntityId = world.spawn(...componentsToInsert);
				entityIdMap.set(serverEntityId, clientEntityId);
			} else {
				if (componentsToInsert.size() > 0) {
					world.insert(clientEntityId, ...componentsToInsert);
				}

				if (componentsToRemove.size() > 0) {
					world.remove(clientEntityId, ...componentsToRemove);
				}
			}
		}
	});
}

export default receiveReplication;
