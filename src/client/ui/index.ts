import { Children, New } from "@rbxts/fusion";
import { Players } from "@rbxts/services";

import selectionFrame from "./selection-frame";

function initializeUi() {
	New("ScreenGui")({
		DisplayOrder: 10,
		IgnoreGuiInset: true,
		Name: "GameUI",
		Parent: Players.LocalPlayer.FindFirstChildOfClass("PlayerGui"),

		[Children]: [selectionFrame([])],
	});
}

export = initializeUi;
