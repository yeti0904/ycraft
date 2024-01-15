module ycraft.scenes.game;

import std.stdio;
import ycraft.app;
import ycraft.util;
import ycraft.video;
import ycraft.types;
import ycraft.world;
import ycraft.uiManager;
import ycraft.sceneManager;
import ycraft.ui.table;
import ycraft.ui.label;
import ycraft.ui.button;
import ycraft.scenes.game;

class GameScene : Scene {
	static const auto blockSize = 16;

	Vec2!double camera;
	World       world;

	override void Init() {
		ui    = new UIManager();
		world = new World(Vec2!int(1000, 1000));
		world.Generate();
		camera.x = 0;
		camera.y = 240;
	}

	override void Update() {
		auto keys = SDL_GetKeyboardState(null);

		double moveBy = 0.25;
		if (keys[SDL_SCANCODE_W]) camera.y -= moveBy;
		if (keys[SDL_SCANCODE_A]) camera.x -= moveBy;
		if (keys[SDL_SCANCODE_S]) camera.y += moveBy;
		if (keys[SDL_SCANCODE_D]) camera.x += moveBy;
	}

	override void Render() {
		auto app      = App.Instance();
		auto video    = app.video;
		auto renderer = video.renderer;

		video.SetDrawColour(Video.HexToColour(0x249FDE));
		SDL_RenderClear(renderer);

		world.Render(camera);
	}
}
