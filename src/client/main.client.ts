import { CharacterRigR15 } from "@rbxts/promise-character";
import { Players, ReplicatedStorage } from "@rbxts/services";
import { start } from "shared/start";
import { input, Input } from "./input";
import receiveReplication from "./receive-replication";
import initializeUi from "./ui";

/**
 * @interface
 */
export interface ClientState {
	debugEnabled: boolean;
	player: Player;
	character: CharacterRigR15;
	input: Input;
}

const player = Players.LocalPlayer;

const state: ClientState = {
	debugEnabled: true,
	player: player,
	character: (player.Character || player.CharacterAdded.Wait()[0]) as CharacterRigR15,
	input: input,
};

const world = start([ReplicatedStorage.client.systems, ReplicatedStorage.shared.systems], state);
receiveReplication(world);

initializeUi();
