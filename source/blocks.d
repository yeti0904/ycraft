module ycraft.blocks;

import ycraft.video;

alias BlockID = ushort;
alias WallID  = ushort;

enum BlockType {
	None = 0,
	Grass,
	Dirt,
	Stone
}

enum WallType {
	None = 0
}

struct BlockDef {
	string    name;
	uint[]    textureID;
	SDL_Color colour;

	this(string pname, uint ptextureID, SDL_Color pcolour) {
		name      = pname;
		textureID = [ptextureID];
		colour    = pcolour;
	}
}

void CreateDefs(ref BlockDef[] blocks) {
	blocks[BlockType.None] = BlockDef(
		"None", 0, Video.HexToColour(0xFF0000)
	);
	blocks[BlockType.Grass] = BlockDef(
		"Grass", 0, Video.HexToColour(0x59C135)
	);
	blocks[BlockType.Dirt] = BlockDef(
		"Dirt", 1, Video.HexToColour(0x5A4E44)
	);
	blocks[BlockType.Stone] = BlockDef(
		"Stone", 2, Video.HexToColour(0x4A5462)
	);
}
