module ycraft.uiManager;

import std.string;
import ycraft.app;
import ycraft.util;
import ycraft.video;

class UIElement {
	SDL_Rect rect;
	
	abstract bool HandleEvent(SDL_Event* e);
	abstract void Render(SDL_Texture* uiTexture);
}

class UIManager {
	UIElement[]  ui;
	bool         isFocused;
	UIElement    focus;

	this() {
		
	}

	void AddElement(UIElement element) {
		ui ~= element;
	}

	bool HandleEvent(SDL_Event* e) {
		if (isFocused) {
			if (focus.HandleEvent(e)) return true;
		}

		foreach (element ; ui) {
			if (isFocused && element is focus) continue;
			if (element.HandleEvent(e))        return true;
		}

		return false;
	}

	void Render() {
		foreach (element ; ui) {
			element.Render(App.Instance().uiTexture);
		}
	}
}
