module ycraft.video;

import std.stdio;
import std.string;
import ycraft.app;
import ycraft.util;
import ycraft.types;

public import bindbc.sdl;

class Video {
	SDL_Window*    window;
	SDL_Renderer*  renderer;
	string         sdlPath;
	Vec2!int       size = Vec2!int(640, 360);

	this() {
		version (Windows) {
			sdlPath = "./SDL2.dll";
		}
	}

	static string GetError() {
		return cast(string) SDL_GetError().fromStringz();
	}

	static SDL_Color HexToColour(int hexValue) {
		return SDL_Color(
			(hexValue >> 16) & 0xFF,
			(hexValue >> 8) & 0xFF,
			hexValue & 0xFF,
			255
		);
	}

	void Init() {
		auto support = sdlPath.empty()? loadSDL() : loadSDL(sdlPath.toStringz());

		if (support != sdlSupport) {
			stderr.writeln("Couldn't load SDL");
			exit(1);
		}

		if (SDL_Init(SDL_INIT_EVERYTHING) < 0) {
			stderr.writefln("Failed to initialise SDL: %s", Video.GetError());
			exit(1);
		}

		window = SDL_CreateWindow(
			toStringz(App.name), 0, 0, size.x, size.y, SDL_WINDOW_RESIZABLE
		);

		if (window is null) {
			stderr.writefln("Failed to create window: %s", Video.GetError());
			exit(1);
		}

		renderer = SDL_CreateRenderer(
			window, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC
		);

		if (renderer is null) {
			stderr.writefln("Failed to create renderer: %s", Video.GetError());
			exit(1);
		}

		SDL_RenderSetLogicalSize(renderer, 640, 360);

		Log("Created window");
	}

	void SetDrawColour(SDL_Colour colour) {
		SDL_SetRenderDrawColor(renderer, colour.r, colour.g, colour.b, colour.a);
	}

	SDL_Texture* LoadBMP(string path) {
		auto surface = SDL_LoadBMP(path.toStringz());

		if (surface is null) {
			ErrorMsg("Failed to load texture: %s", Video.GetError());
		}

		auto texture = SDL_CreateTextureFromSurface(
			App.Instance().video.renderer, surface
		);

		if (texture is null) {
			ErrorMsg("Failed to create texture: %s", Video.GetError());
		}

		SDL_FreeSurface(surface);
		return texture;
	}

	void Clear() {
		auto rect = SDL_Rect(0, 0, size.x, size.y);
		SDL_RenderFillRect(renderer, &rect);
	}
}
