module ycraft.ui.label;

import std.stdio;
import ycraft.app;
import ycraft.types;
import ycraft.video;
import ycraft.uiManager;

class UILabel : UIElement {
	string label;
	double scale;

	this(string plabel) {
		label = plabel;
		scale = 1.0;
	}

	this(string plabel, double pscale) {
		label = plabel;
		scale = pscale;
	}

	override bool HandleEvent(SDL_Event* e) {
		return false;
	}

	override void Render(SDL_Texture* uiTexture) {
		auto app      = App.Instance();
		auto video    = app.video;
		auto renderer = video.renderer;

		auto black = SDL_Color(0, 0, 0, 255);
		auto white = SDL_Color(255, 255, 255, 255);

		auto labelSize = app.font.GetTextSize(label);

		labelSize.x = cast(int) (cast(double) labelSize.x * scale);
		labelSize.y = cast(int) (cast(double) labelSize.y * scale);
		
		auto labelPos  = Vec2!int(
			rect.x + ((rect.w / 2) - (labelSize.x / 2)) + cast(int) scale,
			rect.y + ((rect.h / 2) - (labelSize.y / 2)) + cast(int) scale
		);

		app.font.DrawText(label, labelPos.x, labelPos.y, black, scale);
		labelPos.x -= cast(int) scale;
		labelPos.y -= cast(int) scale;
		app.font.DrawText(label, labelPos.x, labelPos.y, white, scale);
	}
}
