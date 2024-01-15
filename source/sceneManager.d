module ycraft.sceneManager;

import ycraft.video;
import ycraft.uiManager;

class Scene {
	UIManager ui;

	abstract void Init();
	abstract void Update();
	abstract void Render();
	
	bool HandleEvent(SDL_Event* e) {
		return ui.HandleEvent(e);
	}
}

class SceneManager {
	Scene[] scenes;
	Scene   current;

	this() {
		
	}

	void AddScene(Scene scene) {
		scenes ~= scene;
	}

	void SetScene(Scene scene) {
		current = scene;
		scene.Init();
	}

	void Update() {
		current.Update();
		current.Render();
		current.ui.Render();
	}
}
