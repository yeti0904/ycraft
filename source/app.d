module ycraft.app;

import std.file;
import std.path;
import std.stdio;
import std.format;
import std.string;
import std.datetime.stopwatch;
import ycraft.text;
import ycraft.util;
import ycraft.types;
import ycraft.video;
import ycraft.sceneManager;
import ycraft.scenes.game;
import ycraft.scenes.titleScreen;

enum AppScene {
	TitleScreen = 0,
	Game
}

class App {
	static const string name     = "ycraft";
	static const string ver      = "beta";
	static const string author   = "MESYETI";
	static const auto   fontSize = Vec2!int(9, 16);

	bool         running;
	Video        video;
	SceneManager scenes;
	SDL_Texture* uiTexture;
	SDL_Texture* blockTextures;
	Font         font;
	Vec2!int     cursor;
	double       deltaTime;

	this() {
		video     = new Video();
		scenes    = new SceneManager();
		deltaTime = 0.0;
	}

	~this() {
		// TODO: free stuff
	}

	static App Instance() {
		static App app;

		if (!app) {
			app = new App();
		}

		return app;
	}

	static string Path() {
		return thisExePath().dirName();
	}

	void Init() {
		Log("Starting ycraft");

		video.Init();

		scenes.AddScene(new TitleScreenScene());
		scenes.AddScene(new GameScene());
		scenes.SetScene(scenes.scenes[0]);

		uiTexture     = video.LoadBMP(App.Path() ~ "/assets/ui.bmp");
		blockTextures = video.LoadBMP(App.Path() ~ "/assets/blocks.bmp");

		font = new Font(App.Path() ~ "/assets/font.bmp", fontSize.x, fontSize.y);

		running = true;
		Log("Ready");
	}

	void Update() {
		auto sw = StopWatch(AutoStart.yes);

		SDL_Event e;
		while (SDL_PollEvent(&e)) {
			switch (e.type) {
				case SDL_QUIT: {
					running = false;
					return;
				}
				case SDL_MOUSEMOTION: {
					cursor = Vec2!int(
						e.motion.x, e.motion.y
					);
					
					goto default;
				}
				case SDL_WINDOWEVENT: {
					switch (e.window.event) {
						case SDL_WINDOWEVENT_RESIZED: {
							// video.size = Vec2!int(e.window.data1, e.window.data2);
							break;
						}
						default: break;
					}

					goto default;
				}
				default: {
					scenes.current.HandleEvent(&e);
					break;
				}
			}
		}

		scenes.Update();

		SDL_RenderPresent(video.renderer);

		sw.stop();
		deltaTime = sw.peek.total!("usecs") / 1000000.0;
	}
}

void main() {
	try {
		auto app = App.Instance();
		app.Init();

		while (app.running) {
			app.Update();
		}
	}
	catch (Exception e) {
		string crashMsg = format("%s", e);

		ErrorMsg(true, "%s\n\n%s", e.msg, e.info);
	}
}
