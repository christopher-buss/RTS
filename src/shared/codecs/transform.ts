const coordMultiplier = 5;
const orientationMultiplier = 100;

type TransformData = {
	position: Vector3;
	orientation: number;
};

type PositioningData = [
	{
		X: number;
		Y: number;
		Z: number;
	},
];

function encode(transformData: TransformData): [Vector3int16] {
	const orientation = math.floor(orientationMultiplier * transformData.orientation + 0.5);
	const x = math.floor(coordMultiplier * transformData.position.X + 0.5);
	const z = math.floor(coordMultiplier * transformData.position.Z + 0.5);

	return [new Vector3int16(orientation, x, z)];
}

function decode(positioningData: PositioningData): TransformData {
	const data = positioningData[0];

	const orientation = data.X / orientationMultiplier;
	const x = data.Y / coordMultiplier;
	const z = data.Z / coordMultiplier;

	const y = 2; // calculateHeightOfUnit(x, z)

	const transform: TransformData = {
		orientation: orientation,
		position: new Vector3(x, y, z),
	};
	return transform;
}

export { encode, decode };
