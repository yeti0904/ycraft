module ycraft.scenes.game;

import std.stdio;
import ycraft.app;
import ycraft.util;
import ycraft.video;
import ycraft.types;
import ycraft.world;
import ycraft.uiManager;
import ycraft.sceneManager;
import ycraft.player;
import ycraft.ui.table;
import ycraft.ui.label;
import ycraft.ui.button;
import ycraft.scenes.game;

class GameScene : Scene {
	static const int blockSize = 16;

	Vec2!double camera;
	World       world;
	Player      player;

	static SDL_Rect FRectToRect(SDL_FRect rect) {
		return SDL_Rect(
			cast(int) (rect.x * (cast(double) blockSize)),
			cast(int) (rect.y * (cast(double) blockSize)),
			cast(int) (rect.w * (cast(double) blockSize)),
			cast(int) (rect.h * (cast(double) blockSize))
		);
	}

	override void Init() {
		ui     = new UIManager();
		world  = new World(Vec2!int(1000, 1000));
		world.Generate();
		
		player          = new Player();
		player.hitbox.x = 0;
		player.hitbox.y = 245;
		camera.x        = 0;
		camera.y        = 240;
	}

	void UpdateCamera() {
		auto video = App.Instance().video;
		
		camera.x = player.hitbox.x - (video.size.x / 2 / blockSize);
		camera.y = player.hitbox.y - (video.size.y / 2 / blockSize);
	}

	override void Update() {
		auto app  = App.Instance();
		auto keys = SDL_GetKeyboardState(null);

		if (keys[SDL_SCANCODE_A] && !keys[SDL_SCANCODE_D]) {
			player.velocity.x = -10.0;
		}
		else if (!keys[SDL_SCANCODE_A] && keys[SDL_SCANCODE_D]) {
			player.velocity.x = 10.0;
		}
		else {
			player.velocity.x = 0.0;
		}

		if (keys[SDL_SCANCODE_SPACE] && player.touchingGround) {
			player.velocity.y = -8.0;
		}

		player.physics.Update(player, world, app.deltaTime);
		UpdateCamera();
	}

	override void Render() {
		auto app      = App.Instance();
		auto video    = app.video;
		auto renderer = video.renderer;

		video.SetDrawColour(Video.HexToColour(0x249FDE));
		SDL_RenderClear(renderer);

		world.Render(camera);

		video.SetDrawColour(Video.HexToColour(0x00FF00));

		auto playerFRect  = player.hitbox;
		playerFRect.x    -= camera.x;
		playerFRect.y    -= camera.y;
		auto playerRect   = FRectToRect(playerFRect);
		SDL_RenderFillRect(renderer, &playerRect);
	}
}
