module ycraft.scenes.titleScreen;

import std.stdio;
import ycraft.app;
import ycraft.util;
import ycraft.video;
import ycraft.types;
import ycraft.uiManager;
import ycraft.sceneManager;
import ycraft.ui.table;
import ycraft.ui.label;
import ycraft.ui.button;

class TitleScreenScene : Scene {
	UITable table;

	override void Init() {
		ui = new UIManager();

		table         = new UITable(0, 0, 400, 1, 40);
		table.padding = Vec2!int(0, 5);

		table.AddElement(new UILabel(App.name, 2.0));

		auto playButton = new UIButton("Play", 0, 0);
		playButton.onClick = (UIButton button) {
			auto app = App.Instance();

			app.scenes.SetScene(app.scenes.scenes[AppScene.Game]);
		};
		table.AddElement(playButton);

		auto exitButton = new UIButton("Exit", 0, 0);
		exitButton.onClick = (UIButton button) {
			exit(0);
		};
		table.AddElement(exitButton);

		ui.AddElement(table);
	}

	override void Update() {
		table.CenterTable(); // optimise this if its slow
	}

	override void Render() {
		auto app      = App.Instance();
		auto video    = app.video;
		auto renderer = video.renderer;

		video.SetDrawColour(Video.HexToColour(0x000000));
		SDL_RenderClear(renderer);
		video.SetDrawColour(Video.HexToColour(0x249FDE));
		video.Clear();
	}
}
