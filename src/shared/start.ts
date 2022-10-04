import { AnyEntity, AnySystem, Debugger, Loop, World } from "@rbxts/matter";
import Plasma from "@rbxts/plasma";
import { Context, HotReloader } from "@rbxts/rewire";
import { RunService, UserInputService } from "@rbxts/services";
import type { ClientState } from "client/main.client";
import * as Components from "shared/components";

/**
 * Used to initialize Matter and corresponding systems for both client and server.
 *
 * @param containers The locations of systems to initialize.
 * @param state
 * @returns
 */
export function start<S extends object>(containers: Array<Instance>, state: S): World {
	const world = new World();

	const debug = new Debugger(Plasma);
	// eslint-disable-next-line @typescript-eslint/ban-types
	debug.findInstanceFromEntity = (id: AnyEntity): Model | undefined => {
		if (!world.contains(id)) {
			return;
		}

		const model = world.get(id, Components.Renderable);
		return model ? model.model : undefined;
	};

	const loop = new Loop(world, state, debug.getWidgets());

	const hotReloader = new HotReloader();

	let firstRunSystems = new Array<AnySystem>();
	const systemsByModule = new Map<ModuleScript, AnySystem>();

	function loadModule(module: ModuleScript, ctx: Context): void {
		const originalModule = ctx.originalModule;

		const [ok, system] = pcall(require, module) as LuaTuple<[boolean, AnySystem]>;

		if (!ok) {
			warn("Error when hot-reloading system", module.Name, system);
			return;
		}

		firstRunSystems.push(system as AnySystem);

		if (systemsByModule.has(originalModule)) {
			loop.replaceSystem(systemsByModule.get(originalModule)!, system);
			debug.replaceSystem(systemsByModule.get(originalModule)!, system);
		} else {
			loop.scheduleSystem(system);
		}

		systemsByModule.set(originalModule, system);
	}

	function unloadModule(_: ModuleScript, ctx: Context): void {
		if (ctx.isReloading) return;

		const originalModule = ctx.originalModule;
		if (systemsByModule.has(originalModule)) {
			loop.evictSystem(systemsByModule.get(originalModule)!);
			systemsByModule.delete(originalModule);
		}
	}

	containers.forEach((container) => {
		hotReloader.scan(container, loadModule, unloadModule);
	});

	loop.scheduleSystems(firstRunSystems);
	firstRunSystems = undefined!;

	debug.autoInitialize(loop);

	loop.begin({
		default: RunService.IsClient() ? RunService.RenderStepped : RunService.Heartbeat,
		fixed: RunService.Heartbeat,
	});

	if (RunService.IsClient()) {
		UserInputService.InputBegan.Connect((input) => {
			if (input.KeyCode === Enum.KeyCode.F4) {
				debug.toggle();
				(state as ClientState).debugEnabled = debug.enabled;
			}
		});
	}

	return world;
}
