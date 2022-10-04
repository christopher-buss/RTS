interface ReplicatedStorage extends Instance {
	prefabs: Folder & {
		units: Folder & {
			dummy: Model & {
				["Left Leg"]: Part;
				Humanoid: Humanoid;
				["Right Leg"]: Part;
				["Left Arm"]: Part;
				Head: Part & {
					Mesh: SpecialMesh;
					Face: Decal;
				};
				Torso: Part & {
					["Left Shoulder"]: Motor6D;
					["Right Shoulder"]: Motor6D;
					Neck: Motor6D;
					["Right Hip"]: Motor6D;
					["Left Hip"]: Motor6D;
				};
				HumanoidRootPart: Part & {
					["Root Hip"]: Motor6D;
				};
				["Right Arm"]: Part;
			};
		};
	};
	client: Folder & {
		systems: Folder & {
			units: Folder & {
				["remove-missing-models"]: ModuleScript;
				["unit-initialise"]: ModuleScript;
				["unit-can-move"]: ModuleScript;
				["update-missing-models"]: ModuleScript;
			};
		};
		["receive-replication"]: ModuleScript;
		main: LocalScript;
	};
	shared: Folder & {
		module: ModuleScript;
		systems: Folder;
		start: ModuleScript;
		remotes: ModuleScript;
		components: ModuleScript;
		codecs: ModuleScript & {
			transform: ModuleScript;
		};
	};
	rbxts_include: Folder & {
		RuntimeLib: ModuleScript;
		Promise: ModuleScript;
		node_modules: Folder & {
			["@rbxts"]: Folder & {
				matter: Folder & {
					lib: ModuleScript & {
						topoRuntime: ModuleScript;
						["debugger"]: Folder & {
							hookWidgets: ModuleScript;
							["debugger"]: ModuleScript;
							ui: ModuleScript;
							clientBindings: ModuleScript;
							hookWorld: ModuleScript;
							mouseHighlight: ModuleScript;
							EventBridge: ModuleScript;
							formatTable: ModuleScript;
							widgets: Folder & {
								panel: ModuleScript;
								queryInspect: ModuleScript;
								link: ModuleScript;
								entityInspect: ModuleScript;
								errorInspect: ModuleScript;
								worldInspect: ModuleScript;
								realmSwitch: ModuleScript;
								valueInspect: ModuleScript;
								tooltip: ModuleScript;
								hoverInspect: ModuleScript;
								selectionList: ModuleScript;
								codeText: ModuleScript;
								frame: ModuleScript;
								container: ModuleScript;
							};
						};
						["archetype.spec"]: ModuleScript;
						archetype: ModuleScript;
						rollingAverage: ModuleScript;
						hooks: Folder & {
							useThrottle: ModuleScript;
							log: ModuleScript;
							useDeltaTime: ModuleScript;
							useEvent: ModuleScript;
							["useEvent.spec"]: ModuleScript;
						};
						immutable: ModuleScript;
						Queue: ModuleScript;
						component: ModuleScript;
						Loop: ModuleScript;
						mock: Folder & {
							BindableEvent: ModuleScript;
						};
						["topoRuntime.spec"]: ModuleScript;
						["Loop.spec"]: ModuleScript;
						["component.spec"]: ModuleScript;
						["World.spec"]: ModuleScript;
						World: ModuleScript;
					};
				};
				services: ModuleScript;
				plasma: Folder & {
					src: ModuleScript & {
						Runtime: ModuleScript;
						hydrateAutomaticSize: ModuleScript;
						Style: ModuleScript;
						create: ModuleScript;
						createConnect: ModuleScript;
						automaticSize: ModuleScript;
						widgets: Folder & {
							checkbox: ModuleScript;
							heading: ModuleScript;
							highlight: ModuleScript;
							label: ModuleScript;
							window: ModuleScript;
							portal: ModuleScript;
							spinner: ModuleScript;
							space: ModuleScript;
							arrow: ModuleScript;
							row: ModuleScript;
							table: ModuleScript;
							button: ModuleScript;
							blur: ModuleScript;
							error: ModuleScript;
							slider: ModuleScript;
						};
					};
				};
				rewire: Folder & {
					out: ModuleScript & {
						HotReloader: ModuleScript;
						Constants: ModuleScript;
					};
				};
				["compiler-types"]: Folder & {
					types: Folder;
				};
				["promise-character"]: ModuleScript & {
					node_modules: Folder & {
						["@rbxts"]: Folder & {
							["compiler-types"]: Folder & {
								types: Folder;
							};
						};
					};
				};
				trove: Folder & {
					out: ModuleScript;
				};
				clack: Folder & {
					out: ModuleScript & {
						touch: ModuleScript;
						prefer: ModuleScript;
						keyboard: ModuleScript;
						gamepad: ModuleScript;
						mouse: ModuleScript;
					};
				};
				["validate-tree"]: ModuleScript & {
					node_modules: Folder & {
						["@rbxts"]: Folder & {
							["compiler-types"]: Folder & {
								types: Folder;
							};
						};
					};
				};
				beacon: Folder & {
					out: ModuleScript;
				};
				net: Folder & {
					out: ModuleScript & {
						definitions: ModuleScript & {
							ServerDefinitionBuilder: ModuleScript;
							NamespaceBuilder: ModuleScript;
							ClientDefinitionBuilder: ModuleScript;
							Types: ModuleScript;
						};
						messaging: Folder & {
							ExperienceBroadcastEvent: ModuleScript;
							MessagingService: ModuleScript;
						};
						client: ModuleScript & {
							ClientFunction: ModuleScript;
							ClientEvent: ModuleScript;
							ClientAsyncFunction: ModuleScript;
						};
						internal: ModuleScript & {
							validator: ModuleScript;
							tables: ModuleScript;
						};
						middleware: ModuleScript & {
							RateLimitMiddleware: ModuleScript & {
								throttle: ModuleScript;
							};
							LoggerMiddleware: ModuleScript;
							TypeCheckMiddleware: ModuleScript;
						};
						server: ModuleScript & {
							ServerEvent: ModuleScript;
							ServerAsyncFunction: ModuleScript;
							ServerFunction: ModuleScript;
							MiddlewareFunction: ModuleScript;
							NetServerScriptSignal: ModuleScript;
							CreateServerListener: ModuleScript;
							ServerMessagingEvent: ModuleScript;
							MiddlewareEvent: ModuleScript;
						};
					};
				};
				types: Folder & {
					include: Folder & {
						generated: Folder;
					};
				};
			};
		};
	};
}
