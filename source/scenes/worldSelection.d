module ycraft.scenes.worldSelection;

import ycraft.app;
import ycraft.video;
import ycraft.uiManager;
import ycraft.sceneManager;
import ycraft.ui.label;
import ycraft.ui.table;
import ycraft.ui.button;
import ycraft.ui.pagedTable;

class WorldSelectionScene : Scene {
	UITable table;

	override void Init() {
		ui = new UIManager();

		table = new UITable(0, 0, 600, 1, 40);
		table.AddElement(new UILabel("Worlds", 2.0));

		table.uiHeight = 280;
	}

	override void Update() {
		table.CenterTable();
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
