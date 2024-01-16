module ycraft.world;

import std.math;
import ycraft.app;
import ycraft.types;
import ycraft.video;
import ycraft.blocks;
import ycraft.exceptions;
import ycraft.scenes.game;

struct Block {
	BlockID type = 0;
}

struct Wall {
	WallID type = 0;
}

class World {
	Vec2!int   size;
	Block[]    blocks;
	BlockDef[] blockDefs;

	this(Vec2!int psize) {
		size      = psize;
		blocks    = new Block[](size.x * size.y);
		blockDefs = new BlockDef[](BlockType.max + 1);
		CreateDefs(blockDefs);
	}

	Block* GetBlock(int x, int y) {
		if (x >= size.x) ThrowFatal("X (%d) out of bounds (%d)", x, size.x);
		if (y >= size.y) ThrowFatal("Y (%d) out of bounds (%d)", y, size.y);
		if (x < 0)       ThrowFatal("X (%d) out of bounds (%d)", x, size.x);
		if (y < 0)       ThrowFatal("Y (%d) out of bounds (%d)", y, size.y);
		return &blocks[(y * size.x) + x];
	}

	void Generate() {
		for (int x = 0; x < size.x; ++ x) {
			int waterLevel = cast(int) (0.25 * (cast(float) size.y));
			int stoneLevel = waterLevel + 50;

			waterLevel += cast(int) (sin(cast(float) x) * 3.0);

			for (int y = 0; y < size.y; ++ y) {
				if (y == waterLevel) {
					*GetBlock(x, y) = Block(BlockType.Grass);
				}
				else if (y > waterLevel) {
					if (y >= stoneLevel) {
						*GetBlock(x, y) = Block(BlockType.Stone);
					}
					else {
						*GetBlock(x, y) = Block(BlockType.Dirt);
					}
				}
			}
		}
	}

	void Render(Vec2!double offset) {
		auto app      = App.Instance();
		auto video    = app.video;
		auto renderer = video.renderer;

		Vec2!int textureSize;
		SDL_QueryTexture(app.blockTextures, null, null, &textureSize.x, &textureSize.y);
		textureSize.x /= GameScene.blockSize;
		textureSize.y /= GameScene.blockSize;

		Vec2!int end;
		end.x = (cast(int) offset.x) + (video.size.x / GameScene.blockSize) + 2;
		end.y = (cast(int) offset.y) + (video.size.y / GameScene.blockSize) + 2;
		
		Vec2!int start;
		start.x = offset.x > 0? cast(int) offset.x : 0;
		start.y = offset.y > 0? cast(int) offset.y : 0;

		for (int y = start.y; (y < end.y) && (y < size.y); ++ y) {
			for (int x = start.x; (x < end.x) && (x < size.x); ++ x) {
				auto blockRect = SDL_Rect(
					(x * GameScene.blockSize) - cast(int) (offset.x * GameScene.blockSize),
					(y * GameScene.blockSize) - cast(int) (offset.y * GameScene.blockSize),
					GameScene.blockSize,
					GameScene.blockSize
				);
				auto block = GetBlock(x, y);
				auto blockDef = blockDefs[block.type];

				if (block.type == 0) continue;

				uint textureID = blockDef.textureID[0];

				auto blockSrc = SDL_Rect(
					(textureID % textureSize.x) * GameScene.blockSize,
					(textureID / textureSize.y) * GameScene.blockSize,
					GameScene.blockSize, GameScene.blockSize
				);
				SDL_RenderCopy(renderer, app.blockTextures, &blockSrc, &blockRect);
			}
		}
	}
}
