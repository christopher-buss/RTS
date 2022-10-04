import { AnyComponent } from "@rbxts/matter";

const codecs = new Map<string, codec>();

export type codec = {
	encode: (arg0: AnyComponent) => AnyComponent;
	decode: (arg0: AnyComponent) => AnyComponent;
};

script.GetChildren().forEach((child) => {
	if (child.IsA("ModuleScript")) {
		codecs.set(tostring(child), require(child) as codec);
	}
});

export { codecs };
