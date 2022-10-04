import { Computed, New, Value } from "@rbxts/fusion";
import { RunService } from "@rbxts/services";
import { input } from "client/input";

const mousePosition = Value(input.mouse.getPosition());
const visible = Value(false);

input.mouse.getButtonDownSignal(Enum.UserInputType.MouseButton1).connect(() => {
	RunService.BindToRenderStep("SelectionFrame", 1, () => {
		const currentPosition = input.mouse.getPosition();
		if (currentPosition.sub(input.mb1DownKey).Magnitude < 10) {
			return /* */;
		}
		mousePosition.set(currentPosition);
		visible.set(true);
	});
});

input.mouse.getButtonUpSignal(Enum.UserInputType.MouseButton1).connect(() => {
	RunService.UnbindFromRenderStep("SelectionFrame");
	visible.set(false);
});

/**
 * Creates a selection frame when the user drags their input.
 */
function selectionFrame(_props: unknown) {
	return New("Frame")({
		Name: "SelectionFrame",
		AnchorPoint: new Vector2(0.5, 0.5),
		BackgroundColor3: Color3.fromRGB(255, 255, 255),
		BackgroundTransparency: 0.8,

		Visible: visible, // TODO: needs to only activate on mb down

		Position: Computed(() => {
			const center = input.mb1DownKey.add(mousePosition.get()).mul(0.5);
			return new UDim2(0, center.X, 0, center.Y);
		}),

		Size: Computed(() => {
			const distX = math.abs(input.mb1DownKey.X - mousePosition.get().X);
			const distY = math.abs(input.mb1DownKey.Y - mousePosition.get().Y);
			return new UDim2(0, distX, 0, distY);
		}),
	});
}

export = selectionFrame;
