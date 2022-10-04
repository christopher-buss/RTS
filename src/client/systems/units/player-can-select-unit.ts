import { Mouse } from "@rbxts/clack";
import { AnyEntity, useEvent, World } from "@rbxts/matter";
import { ComponentCtor } from "@rbxts/matter/lib/component";
import { Option } from "@rbxts/rust-classes";
import { Workspace } from "@rbxts/services";
import type { ClientState } from "client/main.client";
import * as Components from "shared/components";

const camera = Workspace.CurrentCamera;

/**
 * Returns the entityId of any unit that is currently underneath the mouse of
 * the LocalPlayer.
 *
 * @param mouse mouse for the player
 * @return id of unit if found
 */
function getUnitBelowMouse(mouse: Mouse): Option<AnyEntity> {
	const raycastParams = new RaycastParams();
	const result = mouse.raycast(raycastParams);
	if (result) {
		const id = result.Instance.Parent?.GetAttribute("clientEntityId") as AnyEntity;
		return Option.some<AnyEntity>(id);
	}

	return Option.none<AnyEntity>();
}

/**
 * Deselects a specified unit if it is already selected.
 *
 * @param world Matter
 * @param id entityId id of the entity to deselect
 */
function deselectUnit(world: World, id: AnyEntity): void {
	world.remove(id, Components.Selected);
}

/**
 * Deselects all units that are currently selected.
 *
 * @param world Matter
 */
function deselectAllUnits(world: World): void {
	for (const [id] of world.query(Components.Selected)) {
		deselectUnit(world, id);
	}
}

/**
 * Gets the number of entities that have a set of given components.
 *
 * @param world Matter
 * @param components
 * @returns number of total entities in the world with given components
 */
function getTotalEntitiesWithComponents(world: World, components: ComponentCtor[]): number {
	let total = 0;
	for (const [,] of world.query(...components)) {
		total++;
	}

	return total;
}

/**
 *
 *
 * @param position
 * @returns
 */
function hitPos(position: Vector2): Option<Vector3> {
	const unitRay = camera?.ScreenPointToRay(position.X, position.Y);
	if (unitRay !== undefined) {
		const result = Workspace.Raycast(unitRay.Origin, unitRay.Direction.mul(1000));
		if (result) {
			return Option.some<Vector3>(result.Position);
		}

		return Option.some<Vector3>(unitRay.Origin);
	}

	return Option.none<Vector3>();
}

/**
 *
 *
 * @param vec
 * @returns
 */
function calcSlope(vec: Vector3): Option<Vector2> {
	const rel = camera?.CFrame.PointToObjectSpace(vec);
	if (rel) {
		return Option.some<Vector2>(new Vector2(rel.X / -rel.Z, rel.Y / -rel.Z));
	}
	return Option.none<Vector2>();
}

/**
 *
 * @param cf
 * @param a1
 * @param a2
 * @returns
 */
function overlaps(cf: CFrame, a1: Vector2, a2: Vector2): Option<boolean> {
	const rel = camera?.CFrame.ToObjectSpace(cf);
	if (rel === undefined) {
		return Option.none<boolean>();
	}

	const x = rel.X / -rel.Z;
	const y = rel.Y / -rel.Z;
	return Option.some<boolean>(a1.X < x && x < a2.X && a1.Y < y && y < a2.Y && rel.Z < 0);
}

/**
 *
 * @param a1
 * @param a2
 * @returns
 */
function swap(a1: Vector2, a2: Vector2): LuaTuple<[Vector2, Vector2]> {
	return $tuple(
		new Vector2(math.min(a1.X, a2.X), math.min(a1.Y, a2.Y)),
		new Vector2(math.max(a1.X, a2.X), math.max(a1.Y, a2.Y)),
	);
}

/**
 *
 * @param objs
 * @param p1
 * @param p2
 * @returns
 */
function search(objs: Map<AnyEntity, Model>, p1: Vector3, p2: Vector3): Model[] {
	const found = new Array<Model>();
	const a1_opt = calcSlope(p1);
	const a2_opt = calcSlope(p2);

	if (a1_opt.isNone() || a2_opt.isNone()) {
		return found;
	}

	const [a1, a2] = swap(a1_opt.unwrap(), a2_opt.unwrap());

	objs.forEach((element) => {
		const [cf, _] = element.GetBoundingBox();
		if (overlaps(cf, a1, a2).unwrap()) {
			found.push(element);
		}
	});

	return found;
}

/**
 *
 * @param world
 * @param lastPosition
 * @param mousePosition
 * @returns
 */
function selectUnitsInSelectionFrame(world: World, lastPosition: Vector2, mousePosition: Vector2): void {
	const models = new Map<AnyEntity, Model>();

	for (const [id, model, _selectable] of world.query(Components.Renderable, Components.Selectable)) {
		models.set(id, model.model);
	}

	const p1_opt = hitPos(lastPosition);
	const p2_opt = hitPos(mousePosition);
	if (p1_opt.isNone() || p2_opt.isNone()) {
		return;
	}

	const results = search(models, p1_opt.unwrap(), p2_opt.unwrap());
	results.forEach((element) => {
		const attribute = element.GetAttribute("clientEntityId");
		if (attribute !== undefined) {
			const id = attribute as AnyEntity;
			world.insert(id, Components.Selected());
		}
	});
}

/**
 * Marks any unit within the selection frame as selected.
 *
 * @param world Matter
 * @param state
 */
function playerCanSelectUnit(world: World, state: ClientState): void {
	const mouse = state.input.mouse;
	const keyboard = state.input.keyboard;
	for (const [_, _position] of useEvent(mouse, mouse.getButtonDownSignal(Enum.UserInputType.MouseButton1))) {
		const id_opt = getUnitBelowMouse(mouse);
		if (id_opt.isNone()) {
			return;
		}

		const id = id_opt.unwrap();
		if (world.get(id, Components.Selectable) === undefined) {
			// unit isn't selectable, it could be owned by another player
			continue;
		}

		const alreadySelected = world.get(id, Components.Selected);
		if (alreadySelected) {
			if (keyboard.isKeyDown(Enum.KeyCode.LeftControl)) {
				deselectUnit(world, id);
				continue;
			}
			const amount = getTotalEntitiesWithComponents(world, [Components.Selected]);
			if (amount === 1) {
				deselectAllUnits(world);
				continue;
			}
		}

		if (!keyboard.isKeyDown(Enum.KeyCode.LeftControl)) {
			deselectAllUnits(world);
		}

		world.insert(id, Components.Selected());
		return;
	}

	for (const [_, _position] of useEvent(mouse, mouse.getButtonDownSignal(Enum.UserInputType.MouseButton2))) {
		deselectAllUnits(world);
	}

	if (keyboard.isKeyDown(Enum.KeyCode.C)) {
		deselectAllUnits(world);
	}

	if (mouse.isButtonDown(Enum.UserInputType.MouseButton1)) {
		const mousePosition = mouse.getPosition();

		const SOME_SMALL_MAGNITUDE = 10;
		if (mousePosition.sub(state.input.mb1DownKey).Magnitude < SOME_SMALL_MAGNITUDE) {
			return;
		}

		deselectAllUnits(world);
		selectUnitsInSelectionFrame(world, state.input.mb1DownKey, mousePosition);
	}
}

export = playerCanSelectUnit;
