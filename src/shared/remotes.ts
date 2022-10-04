import { AnyComponent } from "@rbxts/matter";
import Net, { Definitions, Middleware } from "@rbxts/net";
import { t } from "@rbxts/t";
import { ComponentNames } from "./serde";

const Remotes = Net.CreateDefinitions({
	Replication: Definitions.ServerToClientEvent<[Map<string, Map<ComponentNames, { data?: AnyComponent }>>]>(),

	MoveUnits: Definitions.ClientToServerEvent<[position: Vector2int16, selectedUnits: number[]]>([
		Middleware.TypeChecking(t.Vector2int16, t.array(t.number)),
	]),
});

export default Remotes;
