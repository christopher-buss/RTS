import { World } from "@rbxts/matter";
import { Players, ReplicatedStorage } from "@rbxts/services";
import * as Components from "shared/components";

function spawnUnit(world: World) {
	if (Players.GetPlayers().size() <= 0) {
		return;
	}

	for (const [_] of world.query(Components.Unit)) {
		return;
	}

	world.spawn(
		Components.Movement({
			movementSpeed: 8,
			maxForce: math.huge,
		}),
		Components.Transform({
			position: new Vector3(14, 0.5, -11),
			orientation: math.rad(180),
		}),
		Components.Unit({
			appearance: ReplicatedStorage.prefabs.units.dummy,
			owner: Players.GetPlayers()[0],
		}),
	);
}

export = spawnUnit;
