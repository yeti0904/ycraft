module ycraft.ui.button;

import std.stdio;
import ycraft.app;
import ycraft.types;
import ycraft.video;
import ycraft.uiManager;

static const segmentWidth  = 8;
static const segmentHeight = 8;

class UIButton : UIElement {
	string label;
	
	void function(UIButton) onClick;

	this(int w, int h) {
		rect.w = w * segmentWidth;
		rect.h = h * segmentHeight;
	}

	this(string plabel, int w, int h) {
		label  = plabel;
		rect.w = w * segmentWidth;
		rect.h = h * segmentHeight;
	}

	bool Intersects(Vec2!int pos) {
		return (
			(pos.x > rect.x) &&
			(pos.y > rect.y) &&
			(pos.x < rect.x + rect.w) &&
			(pos.y < rect.y + rect.h)
		);
	}

	override bool HandleEvent(SDL_Event* e) {
		switch (e.type) {
			case SDL_MOUSEBUTTONDOWN: {
				auto mousePos = Vec2!int(e.button.x, e.button.y);
				
				if (Intersects(mousePos)) {
					onClick(this);
					return true;
				}
				
				goto default;
			}
			default: return false;
		}
	}

	override void Render(SDL_Texture* uiTexture) {
		int w = rect.w / segmentWidth;
		int h = rect.h / segmentHeight;

		auto app      = App.Instance();
		auto video    = app.video;
		auto renderer = video.renderer;

		int srcOffset = 0;

		if (Intersects(app.cursor)) {
			srcOffset += 24;
		}

		for (int x = 0; x < w; ++ x) {
			for (int y = 0; y < h; ++ y) {
				auto square = SDL_Rect(
					(x * segmentWidth) + rect.x, (y * segmentHeight) + rect.y,
					segmentWidth, segmentHeight
				);

				SDL_Rect src;
				src.w = segmentWidth;
				src.h = segmentHeight;

				if ((y == 0) && (x == 0)) {
					src.x = 0;
					src.y = 0;
				}
				else if ((y == h - 1) && (x == 0)) {
					src.x = 0;
					src.y = 2;
				}
				else if ((y == 0) && (x == w - 1)) {
					src.x = 2;
					src.y = 0;
				}
				else if ((y == h - 1) && (x == w - 1)) {
					src.x = 2;
					src.y = 2;
				}
				else if (y == 0) {
					src.x = 1;
					src.y = 0;
				}
				else if (y == h - 1) {
					src.x = 1;
					src.y = 2;
				}
				else if (x == 0) {
					src.x = 0;
					src.y = 1;
				}
				else if (x == w - 1) {
					src.x = 2;
					src.y = 1;
				}
				else {
					src.x = 1;
					src.y = 1;
				}

				src.x *= segmentWidth;
				src.y *= segmentHeight;
				src.x += srcOffset;
				
				SDL_RenderCopy(renderer, uiTexture, &src, &square);
			}
		}

		auto black = SDL_Color(0, 0, 0, 255);
		auto white = SDL_Color(255, 255, 255, 255);

		auto labelSize = app.font.GetTextSize(label);
		auto labelPos  = Vec2!int(
			rect.x + ((rect.w / 2) - (labelSize.x / 2)) + 1,
			rect.y + ((rect.h / 2) - (labelSize.y / 2)) + 1
		);

		app.font.DrawText(label, labelPos.x, labelPos.y, black, 1.0);
		-- labelPos.x;
		-- labelPos.y;
		app.font.DrawText(label, labelPos.x, labelPos.y, white, 1.0);
	}
}
