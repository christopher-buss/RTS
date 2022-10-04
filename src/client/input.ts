import { Gamepad, Keyboard, Mouse, Touch } from "@rbxts/clack";

export type Input = {
	mouse: Mouse;
	keyboard: Keyboard;
	gamepad: Gamepad;
	touch: Touch;
	// preferredInput: Enum.InputType;
	mb1DownKey: Vector2;
};

const input: Input = {
	mouse: new Mouse(),
	keyboard: new Keyboard(),
	gamepad: new Gamepad(),
	touch: new Touch(),
	// preferredInput: getPreferredInput(),
	mb1DownKey: new Vector2(),
};

input.mouse.getButtonDownSignal(Enum.UserInputType.MouseButton1).connect(() => {
	input.mb1DownKey = input.mouse.getPosition();
});

export { input };
