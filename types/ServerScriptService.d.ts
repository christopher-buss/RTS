interface ServerScriptService extends Instance {
	server: Folder & {
		main: Script;
		systems: Folder & {
			replicate: ModuleScript;
			units: Folder & {
				["spawn-units"]: ModuleScript;
			};
			["test-system"]: ModuleScript;
		};
	};
}
