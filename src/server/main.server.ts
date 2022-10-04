import { ReplicatedStorage, ServerScriptService } from "@rbxts/services";
import { start } from "shared/start";

export interface ServerState {
	debugEnabled: boolean;
}

const state: ServerState = {
	debugEnabled: false,
};

/** const world = */ start([ServerScriptService.server.systems, ReplicatedStorage.shared.systems], state);
