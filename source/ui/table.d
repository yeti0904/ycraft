module ycraft.ui.table;

import std.stdio;
import ycraft.app;
import ycraft.util;
import ycraft.video;
import ycraft.types;
import ycraft.uiManager;

class UITable : UIElement {
	UIElement[] elements;
	int         cols;
	int         uiHeight;
	Vec2!int    padding;

	this(int x, int y, int w, int pcols, int puiHeight) {
		rect.x   = x;
		rect.y   = y;
		rect.w   = w;
		cols     = pcols;
		uiHeight = puiHeight;
	}

	void AddElement(UIElement element, bool setSize = true) {
		elements ~= element;

		int heightSum = uiHeight + padding.y;

		if (setSize) {
			element.rect.w = rect.w / cols;
			element.rect.h = uiHeight;
		}
		element.rect.x = ((cast(int) (elements.length - 1) % cols) * (rect.w / cols)) + rect.x;
		element.rect.y = (((cast(int) elements.length - 1) / cols) * heightSum) + rect.y;

		rect.h = ((cast(int) elements.length + 1) / cols) * uiHeight;
	}

	void CenterTable() {
		auto video = App.Instance().video;

		rect.x = (video.size.x / 2) - (rect.w / 2);
		rect.y = (video.size.y / 2) - (rect.h / 2);

		auto elements2 = elements.dup;
		elements       = [];

		foreach (element ; elements2) {
			AddElement(element, false);
		}
	}

	override bool HandleEvent(SDL_Event* e) {
		foreach (element ; elements) {
			if (element.HandleEvent(e)) return true;
		}

		return false;
	}

	override void Render(SDL_Texture* uiTexture) {
		foreach (element ; elements) {
			element.Render(uiTexture);
		}
	}
}
