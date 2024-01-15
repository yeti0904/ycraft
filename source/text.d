module ycraft.text;

import ycraft.app;
import ycraft.types;
import ycraft.video;

class Font {
	SDL_Texture* texture;
	Vec2!int     fontSize;
	Vec2!int     dim; // dimensions

	this(string path, int fontW, int fontH) {
		auto app   = App.Instance();
		auto video = app.video;

		texture  = video.LoadBMP(path);
		fontSize = Vec2!int(fontW, fontH);

		SDL_QueryTexture(texture, null, null, &dim.x, &dim.y);
		dim.x /= fontSize.x;
		dim.y /= fontSize.y;
	}

	void DrawText(string str, int x, int y, SDL_Color colour, double scale) {
		auto renderer = App.Instance().video.renderer;

		SDL_SetTextureColorMod(texture, colour.r, colour.g, colour.b);
	
		foreach (i, ref ch ; str) {
			auto index = ch;
			auto src   = SDL_Rect(0, 0, fontSize.x, fontSize.y);
			auto dest  = SDL_Rect(
				(cast(int) i * fontSize.x * cast(int) scale) + x, y, fontSize.x, fontSize.y
			);

			src.x = (index % dim.x) * fontSize.x;
			src.y = (index / dim.y) * fontSize.y;

			dest.w = cast(int) (cast(double) dest.w * scale);
			dest.h = cast(int) (cast(double) dest.h * scale);

			SDL_RenderCopy(renderer, texture, &src, &dest);
		}
	}

	Vec2!int GetTextSize(string str) {
		return Vec2!int(fontSize.x * cast(int) str.length, fontSize.y);
	}
}
