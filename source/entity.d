module ycraft.entity;

import ycraft.video;
import ycraft.world;
import ycraft.game;

class PhysicsController {
	abstract void Update(Entity entity, World world, double deltaTime);
}

class Entity {
	SDL_FRect         hitbox;
	PhysicsController physics;
}
